Get-ChildItem $PSScriptRoot\inc\*.ps1 | % { . $_ }

import-module $PSScriptRoot\..\mm-redmine -Force

$Config = . $PSScriptRoot\config.$Environment.ps1
Initialize-RedmineSession -Url $Config.RedmineUrl -Key $Config.RedmineUserKey

Get-ChildItem $PSScriptRoot\tasks\*.ps1 | % { . $_ }
$Task = $null
$BotIgnoreString = "@{0}: ignore" -f $Config.RedmineUserLogin

log "Bot started"

foreach ($Task in $config.Tasks) {
    if (!$task.Enabled) { log "Task is disabled"; continue }
    $taskFunction = "bt-" + $task.Name
    if (!(Get-ChildItem Function:$taskFunction)) { log "Skipping invalid task:" $task.Name }

    log "Starting task" ("`n`n" + ((($task | Out-String).Trim() -split "`n" | Select -Skip 4 ) | Out-String))
    iex $taskFunction
}