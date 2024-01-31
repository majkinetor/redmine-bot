@{
    RedmineUserLogin = $Env:Production_RedmineUserLogin
    RedmineUserId    = $Env:Production_RedmineUserId
    RedmineUserKey   = $Env:Production_RedmineUserKey
    RedmineUrl       = $Env:Production_RedmineUrl
    DateFormat       = "dd.MM.yyyy."

    Tasks = @(
        [ordered]@{
            Name = 'Reminder'
            TaskUid = 'adb48403-9022-40bc-aed0-9881ae4f1c3f'
            Enabled = $true
            WhatIf = $true

            MaxIssues = 50
            NoSpam = $true
            CreatedAfter = '2023-01-01'
            Projects = 'pud', 'spiri', 'ibjls', 'lokalni-plasmani', 'zavrsni_racuni', 'top', 'poslovno-izvestavanje'
            Trackers = ''
            Statuses = 'Fidbek'
            InactivityDays = 10
            Note = '### Automatski podsetnik

Poslednja aktivnost na tiketu #$IssueId desila se pre $UpdatedBefore dana ($UpdatedOn).
Potrebno je da $($Assignee ? $Assignee : "se") reaguje u adekvatnom roku.
'
        }
        [ordered]@{
            Name = 'Terminator'
            TaskUid = '29b1b897-0de7-4aa7-90af-2d6a1085501e'
            Enabled = $true
            WhatIf = $true

            MaxIssues = 50
            CreatedAfter = '2023-01-01'
            Projects = 'pud', 'spiri', 'ibjls', 'lokalni-plasmani', 'zavrsni_racuni', 'top', 'poslovno-izvestavanje'
            Trackers = ''
            Statuses = 'Fidbek'
            InactivityDays = 30
            StatusMap = @{
                'Default' = 'Zatvoreno'
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