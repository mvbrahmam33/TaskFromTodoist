#include <cpr/cpr.h>
#include <string>
#include <nlohmann/json.hpp>
#include <fstream>
#include <iostream>
#include <ctime>

int main(int argc, char* argv[]) {
    if (argc < 3) {
        std::cerr << "Usage: " << argv[0] << " <API_KEY> <OUTPUT_PATH>\n";
        return 1;
    }
    std::string token = argv[1];
    std::string outputPath = argv[2];

    // Get inbox tasks only
    auto inboxResponse = cpr::Get(
        cpr::Url{"https://api.todoist.com/rest/v2/tasks?filter=%23Inbox"},
        cpr::Header{{"Authorization", "Bearer " + token}}
    );


    if (inboxResponse.status_code != 200) {
        std::cerr << "Error: Inbox: " << inboxResponse.status_code << "\n";
        return 1;
    }
    auto inboxTasks = nlohmann::json::parse(inboxResponse.text);

    std::ofstream out(outputPath);

    if (!inboxTasks.empty()) {
        out << "TASKS:\n";
        int count = 1;

        // Get today's date in YYYY-MM-DD
        std::time_t t = std::time(nullptr);
        std::tm tm = *std::localtime(&t);
        char today[11];
        std::strftime(today, sizeof(today), "%Y-%m-%d", &tm);

        for (auto& task : inboxTasks) {
            // If task has no due date, or due date is today or earlier, include it
            if (!task.contains("due") || !task["due"].contains("date") ||
                task["due"]["date"].get<std::string>() <= today) {
                out << std::to_string(count++) << ") " << task["content"].get<std::string>() << "\n";
            }
        }
    }

    out.close();

    return 0;
}


