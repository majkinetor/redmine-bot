@{
    RedmineKey = $Env:RedmineKey
    RedmineUrl = $Env:RedmineUrl

    Tasks = @(
        [ordered]@{
            Name = 'Reminder'
            Enabled = $false
            WhatIf = $true

            MaxIssues = 10
            CreatedAfter = '2023-01-01'
            Projects = ''
            Trackers = ''
            Statuses = 'Fidbek'
            InactivityDays = 10
            Note = '### Automatski podsetnik

Poslednja aktivnost na tiketu #$($Issue.Id) desila se pre $UpdatedBefore dana ($($UpdatedOn.ToString("dd.MM.yyyy"))).
$( $Assignee ? "Potrebno je da **$Assignee** reaguje u što kraćem roku" : "Potrebno je da neko od učesnika reaguje u što kraćem roku.").
'
        }
        [ordered]@{
            Name = 'Terminator'
            Enabled = $true
            WhatIf = $true

            MaxIssues = 1000
            CreatedAfter = '2023-11-01'
            Projects = ''
            Trackers = ''
            Statuses = ''
            InactivityDays = 30
            StatusMap = @{
                'Default' = 'Nerešeno'
                'Rešeno' = 'Zatvoreno'
            }
            Note = '### Automatsko zatvaranje

Poslednja aktivnost na tiketu #$($Issue.Id) desila se pre $UpdatedBefore dana ($($UpdatedOn.ToString("dd.MM.yyyy"))).
Tiket se zatvara zbog neaktivnosti:

- Projekat: $ProjectName
- Status: $ClosingStatusName
'
        }
    )
}