# Close tickets after inactivity period
# See Config.Tasks.Terminator for parameter info.
function bt-terminator {
    $now = (Get-Date).AddDays(1)
    $inactiveDateStart = $now.AddDays(-$Task.InactivityDays).ToString("yyyy-MM-dd")
    $createdAfter = $Task.CreatedAfter

    log "Initializing"
    $all_projects = Get-AllPages "Get-RedmineProject"
    $all_statuses = Get-RedmineStatus

    if ($Task.Projects) { $projects = $all_projects | ? identifier -in $Task.Projects }
    if ($Task.Trackers) { $trackers = Get-RedmineTracker | ? name -in $Task.Trackers }
    if ($Task.Statuses) { $statuses = $all_statuses | ? name -in $Task.Statuses }

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
        $IssueUrl = $Config.RedmineUrl + "/issues/" + $issue.id
        if ($updatedIssues[ $issue.id ]) { continue }
        if ($issue.description.ToLower() -like "*$BotIgnoreString*") { log $issue.id "explicitely ignored" -Ident 1; continue }

        $IssueId       = $issue.id
        $ProjectName   = $issue.project.name
        $Assignee      = $issue.assigned_to.name
        $AssigneeId    = $issue.assigned_to.id
        $UpdatedOn     = ([datetime]$issue.updated_on).ToString($Config.DateFormat)
        $UpdatedBefore = ($now - [datetime]$issue.updated_on).Days

        $issueStatusName = $issue.status.name
        $ClosingStatusName = $Task.StatusMap.$issueStatusName
        if (!$ClosingStatusName) { $ClosingStatusName = $Task.StatusMap.Default }
        $closingStatus = $all_statuses | ? name -eq $ClosingStatusName
        if (!$closingStatus) { log "err: can't find status '$ClosingStatusName'" -Ident 1; continue }

        $note = "`"$($Task.Note)`"" | iex
        $note += "`n---`n`nTask UID: $($Task.TaskUid)"
        $updatedIssues[ $issue.id ] = $true
        if (!$Task.WhatIf) {
            try {
                Update-RedmineIssue -Id $issue.id -Notes $note -StatusId $closingStatus.id
                log "OK" $IssueUrl "|" $issue.subject "`n$note" -Ident 1
            } catch {
                log "ERR" $IssueUrl $issue.subject $_ -Ident 1
            }
        } else {
            $note = ($note -split "`n" | % { " "*4 + $_ }) -join "`n"
            log "???" $IssueUrl "|" $issue.subject  "`n$note" -Ident 1
        }
    }
}
