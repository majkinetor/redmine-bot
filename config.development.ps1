@{
    RedmineUserLogin = $Env:Development_RedmineUserLogin
    RedmineUserId    = $Env:Development_RedmineUserId
    RedmineUserKey   = $Env:Development_RedmineUserKey
    RedmineUrl       = $Env:Development_RedmineUrl
    DateFormat       = "dd.MM.yyyy."

    Tasks = @(
        [ordered]@{
            Name = 'Reminder'
            TaskUid = 'adb48403-9022-40bc-aed0-9881ae4f1c3f'
            Enabled = $false
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
            TaskUid = '29b1b897-0de7-4aa7-90af-2d6a1085501e'
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