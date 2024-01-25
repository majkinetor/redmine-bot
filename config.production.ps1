@{
    RedmineUserId = $Env:Production_RedmineUserId
    RedmineKey = $Env:Production_RedmineKey
    RedmineUrl = $Env:Production_RedmineUrl
    DateFormat = "dd.MM.yyyy."

    Tasks = @(
        [ordered]@{
            Name = 'Reminder'
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
Potrebno je da **rešavalac** reaguje u što kraćem roku.
'
        }
        [ordered]@{
            Name = 'Terminator'
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