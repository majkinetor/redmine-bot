@{
    RedmineUserId = $Env:Development_RedmineUserId
    RedmineKey = $Env:Development_RedmineKey
    RedmineUrl = $Env:Development_RedmineUrl
    DateFormat = "dd.MM.yyyy."

    Tasks = @(
        [ordered]@{
            Name = 'Reminder'
            Enabled = $true
            WhatIf = $false

            MaxIssues = 50
            NoSpam = $true
            CreatedAfter = '2023-01-01'
            Projects = 'test', 'test-subproject'
            Trackers = ''
            Statuses = 'Feedback Required'
            InactivityDays = 0
            Note = '### Automatski podsetnik

Poslednja aktivnost na tiketu #$IssueId desila se pre $UpdatedBefore dana ($UpdatedOn).
Potrebno je da **rešavalac** reaguje u što kraćem roku.
'
        }
        [ordered]@{
            Name = 'Terminator'
            Enabled = $true
            WhatIf = $false

            MaxIssues = 50
            CreatedAfter = '2023-01-01'
            Projects = 'test', 'test-subproject'
            Trackers = ''
            Statuses = 'Feedback Required'
            InactivityDays = 0
            StatusMap = @{
                'Default' = 'Closed'
            }
            Note = '### Automatsko zatvaranje

Poslednja aktivnost na tiketu #$IssueId desila se pre $UpdatedBefore dana ($UpdatedOn).
Tiket se zatvara zbog neaktivnosti:

- Projekat: $ProjectName
- Status: $ClosingStatusName
'
        }
    )
}