#include "todoist_fetcher.hpp"
#include <cpr/cpr.h>
#include <string>
#include <nlohmann/json.hpp>
#include <fstream>
#include <iostream>
#include <ctime>

using namespace TodoistFetcher;

std::string getCurrentDate() {
    std::time_t t = std::time(nullptr);
    std::tm tm = *std::localtime(&t);
    char today[11];
    std::strftime(today, sizeof(today), "%Y-%m-%d", &tm);
    return std::string(today);
}

std::vector<Task> fetchTasks(const std::string& token, const std::string& filter = "#Inbox") {
    std::vector<Task> tasks;
    
    auto response = cpr::Get(
        cpr::Url{"https://api.todoist.com/rest/v2/tasks?filter=" + filter},
        cpr::Header{{"Authorization", "Bearer " + token}}
    );

    if (response.status_code != 200) {
        std::cerr << "Error fetching tasks: HTTP " << response.status_code << std::endl;
        return tasks;
    }

    auto json_tasks = nlohmann::json::parse(response.text);
    std::string today = getCurrentDate();

    for (const auto& task_json : json_tasks) {
        std::string due_date = "";
        if (task_json.contains("due") && task_json["due"].contains("date")) {
            due_date = task_json["due"]["date"].get<std::string>();
        }
        
        // Include tasks with no due date or due today/overdue
        if (due_date.empty() || due_date <= today) {
            tasks.emplace_back(
                task_json["id"].get<std::string>(),
                task_json["content"].get<std::string>(),
                due_date,
                task_json.value("is_completed", false),
                task_json.value("priority", 1)
            );
        }
    }
    
    return tasks;
}

bool writeTasksToFile(const std::vector<Task>& tasks, const std::string& output_path) {
    std::ofstream out(output_path);
    if (!out.is_open()) {
        std::cerr << "Error: Cannot open output file: " << output_path << std::endl;
        return false;
    }

    if (!tasks.empty()) {
        out << "TASKS:\n";
        int count = 1;
        for (const auto& task : tasks) {
            out << std::to_string(count++) << ") " << task.content << std::endl;
        }
    } else {
        out << "No tasks found.\n";
    }

    out.close();
    return true;
}

int main(int argc, char* argv[]) {
    if (argc < 3) {
        std::cerr << "Usage: " << argv[0] << " <API_KEY> <OUTPUT_PATH> [FILTER]" << std::endl;
        std::cerr << "Example: " << argv[0] << " your_api_token output/tasks.txt \"#Inbox\"" << std::endl;
        return 1;
    }

    std::string token = argv[1];
    std::string outputPath = argv[2];
    std::string filter = (argc > 3) ? argv[3] : "#Inbox";

    std::cout << "Fetching tasks from Todoist..." << std::endl;
    
    auto tasks = fetchTasks(token, filter);
    
    if (tasks.empty()) {
        std::cout << "No tasks found matching criteria." << std::endl;
    } else {
        std::cout << "Found " << tasks.size() << " task(s)." << std::endl;
    }

    if (writeTasksToFile(tasks, outputPath)) {
        std::cout << "Tasks written to: " << outputPath << std::endl;
        return 0;
    } else {
        std::cerr << "Failed to write tasks to file." << std::endl;
        return 1;
    }
}


