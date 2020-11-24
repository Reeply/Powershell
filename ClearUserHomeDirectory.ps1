<#
.SYNOPSIS
  Clear User Home directory if User Go Away
.DESCRIPTION
  <Brief description of script>
.PARAMETER None
    None
.INPUTS
  <Inputs if any, otherwise state None>
.OUTPUTS
  <Outputs if any, otherwise state None - example: Log file stored in C:\Windows\Temp\<name>.log>
.NOTES
  Version:        1.0
  Author:         
  Creation Date:  24/11/2020
  Purpose/Change: Initial script development
#>

Begin
{
    #Force script to exit on error
    $ErrorActionPreference = "Stop";
    $DebugPreference = 'Continue';
    $VerbosePreference = 'Continue';
    $LogPath = Join-Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name.Replace("ps1","log");
    Start-Transcript -Path $LogPath;
}
Process
{
    $UserHomeFolderRoot = "c:\temp\UserHomeRoot\";

    $AllUsersHome = Get-ChildItem -Path $UserHomeFolderRoot -Directory;

    ForEach($UserHome in $AllUsersHome)
    {
        Write-Debug "Working On $($UserHome)";
        $UserName = $UserHome.Name;

        #$UserInformations = Get-ADUser -Identity $UserName -ErrorAction SilentlyContinue;
        $UserInformations = Get-ADUser -Filter {SamAccountName -eq $UserName} -ErrorAction SilentlyContinue;
        If($null -eq $UserInformations)
        {
            Write-Information "User not found in AD. Delete this folder";
            Try
            {
              Remove-Item -Path $UserHome.FullName -Recurse -Force -Confirm:$false;
              Write-Information "User Home successfully deleted.";
            }
            Catch
            {
              Write-Error "Failed to delete $($UserHome.FullName)";
              Write-Error "$($_.Message.ToString())";
            }
        }
        Else
        {
            Write-Debug "User found in AD. Nothing to do!";  
        }
    }
}
End
{
    Write-Information "Script Finished";
    Stop-Transcript;
}
