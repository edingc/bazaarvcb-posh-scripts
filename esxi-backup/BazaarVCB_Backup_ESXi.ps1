# ------------------------------------------------------------------------
# NAME: BazaarVCB_Backup_ESXi.ps1
# AUTHOR: Cody Eding
# DATE: 12/3/2013
#
# COMMENTS: This invokes BazaarVCB to backup ESXi virtual machines listed
# in CSV files for each day of the week (located in same directory). 
# Run as a scheduled task for backups to occur at scheduled intervals. 
#
# To backup a single server multiple times per week, add the server to 
# each day's CSV file.
#
# Requires BazaarVCB.exe to be downloaded and placed into the folder where
# this script resides.
#
# ------------------------------------------------------------------------

# Change these variables to suit your environment #

$Username = "esxiuser"
$Password = "esxipassword"
$RollOut = 3
$SmtpServer = "smtp.server.net"
$From = "noreply@domain.com"
$To = "alerts@domain.com"
$Datastore = "BackupDatastore"

###################################################

Push-Location $PSScriptRoot

If ( Get-Command .\bazaarvcb.exe ) {

	Remove-Item ".\bazaarvcb.log"

    $Today = (Get-Date).DayOfWeek

    If ( Test-Path ".\$Today.csv" ) {

        $BackupJobs = Import-CSV ".\$Today.csv"
        $BackupJobs | ForEach-Object {
            .\bazaarvcb.exe backup -H $_.host -u $Username -p $Password --consolidate --roll-out $RollOut --mail always --mail-host $SmtpServer --mail-sender $From --mail-recipient $To --mail-header "Backup results: $_" $_.vm "[$Datastore]"
        }
    }

    Pop-Location

} Else {

    Write-Host "BazaarVCB is not installed or in the executable PATH."
    Exit 1

}

