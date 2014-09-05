# ------------------------------------------------------------------------
# NAME: BazaarVCB_Restore_ESXi.ps1
# AUTHOR: Cody Eding
# DATE: 12/3/2013
#
# COMMENTS: This invokes BazaarVCB to restore ESXi virtual machines listed
# in the Servers.csv file. 
#
# Requires BazaarVCB.exe to be downloaded and placed into the folder where
# this script resides.
#
# ------------------------------------------------------------------------

# Change these variables to suit your environment #

$Username = "esxiuser"
$Password = "esxipassword"

###################################################

Push-Location $PSScriptRoot

If ( Get-Command .\bazaarvcb.exe ) {

    $Servers = Import-Csv .\Servers.csv

    $Servers | ForEach-Object {

		#Concatenate our source and destination strings
		$source = "[" + $_.source + "]" + $_.filename
		$destination = "[" + $_.destination + "]"

		.\bazaarvcb.exe restore -H $_.host -u $Username -p $Password --register $_.vm $source $destination
    }

    Pop-Location

} Else {

    Write-Host "BazaarVCB is not installed or in the executable PATH."
    Exit 1

}

