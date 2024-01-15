# Create reminder note after inactivity period.
# See Config.Tasks.Reminder for parameter info.
function bt-reminder {

    $now = (Get-Date).AddDays(1)
    $inactiveDateStart = $now.AddDays(-$Task.InactivityDays).ToString("yyyy-MM-dd")
    $createdAfter = $Task.CreatedAfter

    log "Initializing"
    $projects = Get-AllPages "Get-RedmineProject"

    if ($Task.Projects) { $projects = $projects | ? name -in $Task.Projects }
    if ($Task.Trackers) { $trackers = Get-RedmineTracker | ? name -in $Task.Trackers }
    if ($Task.Statuses) { $statuses = Get-RedmineStatus  | ? name -in $Task.Statuses }

    log "Finding issues inactive for more than" $Task.InactivityDays  "days"
    $all_issues = @()
    foreach ($project in $projects) {
        $filter = New-RedmineIssueFilter -ProjectId $project.id -StatusId open -UpdatedOn "<=$inactiveDateStart" -CreatedOn ">=$createdAfter"
        $issues = Get-AllPages "Get-RedmineIssue" @{ Filter = $filter }

        if ($trackers) { $issues = $issues | ? { $_.tracker.name -in $trackers.name } }
        if ($statuses) { $issues = $issues | ? { $_.status.name -in $statuses.name }}
        $all_issues += $issues
    }
    $all_issues = $all_issues | Sort-Object updated_on
    log $all_issues.Count "issues found" -Ident 1

    $maxIssues = [math]::Min($all_issues.Count, ($Task.MaxIssues ?? 1000))
    $updatedIssues = @{}
    log "Updating $maxIssues issues"
    for ($j=0; $j -lt $maxIssues ; $j++) {
        $issue = $all_issues[$j]
        if ($updatedIssues[ $issue.id ]) { continue }

        $Assignee = $issue.assigned_to.name
        $UpdatedOn = $issue.updated_on
        $UpdatedBefore = ($now - [datetime]$UpdatedOn).Days
        $note = "`"$($Task.Note)`"" | iex
        $updatedIssues[ $issue.id ] = $true
        if (!$Task.WhatIf) {
            try {
                Update-RedmineIssue -Id $issue.id -Notes $note
                log $Issue.id -Ident 1
            } catch {
                log "ERR $($Issue.id): $_" -Ident 1
            }
        } else {
            $note = ($note -split "`n" | % { " "*4 + $_ }) -join "`n"
            log "WHAT IF $j`n$note" -Ident 1
        }
    }
}