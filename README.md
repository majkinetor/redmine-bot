# Redmine bot

This is a bot that uses Redmine REST API to do specific tasks.

## Usage

1. Clone [mm-redmine](https://github.com/majkinetor/mm-redmine) and put it in a sibling directory
1. Use an existing task or add bot new one in the [tasks](./tasks) folder
1. Create trigger mechanism (scheduled task, email scanner, RSS feed etc.)

## Tasks

1. Inactivity Reminder<br>
Add an issue note when a ticket is inactive for more than the configured number of days.
1. Terminator<br>
Close an issue with the note when a ticket is inactive for more than the configured number of days.