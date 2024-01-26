# Redmine bot

This is a bot that uses Redmine REST API to do specific tasks.

## Usage

1. Clone [mm-redmine](https://github.com/majkinetor/mm-redmine) and put it in a sibling directory or install in the system location
1. Use an existing task or add new one in the [tasks](./tasks) folder
1. Create trigger mechanism (scheduled task, email scanner, RSS feed etc.)

Mandatory configuration options:

|   Parameter   |              Meaning              |    Type     |
| ------------- | --------------------------------- | ----------- |
| RedmineUserId | Id of the Redmine bot             | int         |
| RedmineKey    | Key of the Redmine bot            | string      |
| RedmineUrl    | URL of the Redmine server         | string      |
| DateFormat    | Date format used in messages      | string      |
| Task          | Array of tasks for bot to execute | HashTable[] |

## Tasks

Tasks are configured in the appropriate `config.<environment>.ps1` file.

All tasks have the following parameters:

| Parameter |                     Meaning                      |  Type  |
| --------- | ------------------------------------------------ | ------ |
| Name      | Name of the tasks to run                         | string |
| Enabled   | Determines if task runs                          | bool   |
| WhatIf    | Determines if task just reports what it would do | bool   |
| TaskUid   | Unique identifier of the task                    | string |

Bot will ignore task with the following string anywhere in the issue description: `@<RedmineUserLogin>: ignore`

### Reminder

Add an issue note when a ticket is inactive for more than the configured number of days.

|   Parameter    |                                  Meaning                                   |   Type   |
| -------------- | -------------------------------------------------------------------------- | -------- |
| MaxIssues      | Maximum number of issues to process in one run                             | int      |
| NoSpam         | Do not create another message if the last one belongs to the bot           | bool     |
| CreatedAfter   | Limit task to the issues created after this ISO8601 date                   | datetime |
| Projects       | Limit task to the given projects (identifiers)                             | string[] |
| Trackers       | Limit task to the given trackers (names)                                   | string[] |
| Statuses       | Limit task to the given statuses (names)                                   | string[] |
| InactivityDays | Number of days of inactivity after which message is created                | int      |
| Note           | Template for the message to be created after ticket is considered inactive | string   |

Message template supports the following variables: `$IssueId`, `$IssueUrl`, `$ProjectName`, `$Assignee`, `$UpdatedOn`, `$UpdatedBefore`

### Terminator

Close an issue with the note when a ticket is inactive for more than the configured number of days.

|   Parameter    |                                  Meaning                                   |   Type   |
| -------------- | -------------------------------------------------------------------------- | -------- |
| MaxIssues      | Maximum number of issues to process in one run                             | int      |
| CreatedAfter   | Limit task to the issues created after this ISO8601 date                   | datetime |
| Projects       | Limit task to the given projects (identifiers)                             | string[] |
| Trackers       | Limit task to the given trackers (names)                                   | string[] |
| Statuses       | Limit task to the given statuses (names)                                   | string[] |
| InactivityDays | Number of days of inactivity after which message is created                | int      |
| Note           | Template for the message to be created after ticket is considered inactive | string   |

Message template supports the following variables: `$IssueId`, `$ProjectName`, `$Assignee`, `$UpdatedOn`, `$UpdatedBefore`
