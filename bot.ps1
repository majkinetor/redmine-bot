Get-ChildItem $PSScriptRoot\inc\*.ps1 | % { . $_ }

import-module $PSScriptRoot\..\mm-redmine -Force

$Config = . $PSScriptRoot\config.ps1
Initialize-RedmineSession -Url $Config.RedmineUrl -Key $Config.RedmineKey

Get-ChildItem $PSScriptRoot\tasks\*.ps1 | % { . $_ }

log "Bot started"
foreach ($Task in $config.Tasks) {
    if (!$task.Enabled) { log "Skipping disabled task:" $task.Name }
    $taskFunction = "bt-" + $task.Name
    if (!(Get-ChildItem Function:$taskFunction)) { log "Skipping invalid task:" $task.Name }

    log "Task:" $task.Name ("`n`n" + ((($task | Out-String).Trim() -split "`n" | Select -Skip 4 ) | Out-String))
    iex $taskFunction
}