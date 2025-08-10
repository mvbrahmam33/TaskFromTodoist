#pragma once

#include <string>
#include <vector>
#include <memory>

namespace TodoistFetcher {

struct Task {
    std::string id;
    std::string content;
    std::string due_date;
    bool is_completed;
    int priority;
    
    Task(const std::string& id, const std::string& content, 
         const std::string& due_date = "", bool completed = false, int prio = 1)
        : id(id), content(content), due_date(due_date), is_completed(completed), priority(prio) {}
};

class TaskFetcher {
public:
    TaskFetcher(const std::string& api_token);
    ~TaskFetcher() = default;
    
    std::vector<Task> fetchTasks(const std::string& filter = "#Inbox");
    bool writeTasksToFile(const std::vector<Task>& tasks, const std::string& output_path);
    
private:
    std::string api_token_;
    std::string base_url_ = "https://api.todoist.com/rest/v2/";
    
    std::string getCurrentDate() const;
    bool isTaskDueToday(const Task& task) const;
};

class ConfigManager {
public:
    ConfigManager(const std::string& config_path);
    
    std::string getApiToken() const { return api_token_; }
    std::string getFilter() const { return filter_; }
    std::string getOutputPath() const { return output_path_; }
    
private:
    std::string api_token_;
    std::string filter_;
    std::string output_path_;
    
    void loadConfig(const std::string& config_path);
};

} // namespace TodoistFetcher
