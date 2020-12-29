param (
        [switch]$mobile,
        [switch]$PC
)

function mobile
{
        Write-Host "Rearranging mobile blacklist..."
        Get-Content .\my_blacklisted_hosts_mobile.txt | Sort-Object | Get-Unique | Out-File .\my_blacklisted_hosts_mobile2.txt
        Remove-Item .\my_blacklisted_hosts_mobile.txt
        Move-Item .\my_blacklisted_hosts_mobile2.txt .\my_blacklisted_hosts_mobile.txt
        Write-Host "Mobile Blacklist Rearranged"

        Write-Host "Rearranging mobile whitelist..."
        Get-Content .\my_whitelisted_hosts_mobile.txt | Sort-Object | Get-Unique | Out-File .\my_whitelisted_hosts_mobile2.txt
        Remove-Item .\my_whitelisted_hosts_mobile.txt
        Move-Item .\my_whitelisted_hosts_mobile2.txt .\my_whitelisted_hosts_mobile.txt
        Write-Host "Mobile Whitelist Rearranged"

        Write-Host "Creating blacklist host file for Mobile..."
        $con = Get-Content .\my_blacklisted_hosts_mobile.txt, .\base_host.txt
        $con | ?{$_ -notin (Get-Content .\my_whitelisted_hosts_mobile.txt)} | Select-String -NotMatch "^\s*!.*", "^\s*\[.*", "^\s*#.*", "^\s*$" | Sort-Object | Get-Unique | Out-File "hosts_mobile"
        Write-Host "Done"

        Write-Host "Creating blacklist uBlockOrigin file for Mobile..."
        $con = Get-Content .\hosts_mobile
        $con -match "(?<=^0.0.0.0 ).*" | %{$_.replace("0.0.0.0 ", "")} | %{$_ -replace "\s#.*", "" } | Out-File '.\firefox\uBlockOrigin\CustomHostForuBlockOrigin_mobile.txt'
        Write-Host "Done"

        Write-Host "Blacklists for mobile devices are ready"
}

function PC
{
        Write-Host "Rearranging PC blacklist..."
        Get-Content .\my_blacklisted_hosts_PC.txt | Sort-Object | Get-Unique | Out-File .\my_blacklisted_hosts_PC2.txt
        Remove-Item .\my_blacklisted_hosts_PC.txt
        Move-Item .\my_blacklisted_hosts_PC2.txt .\my_blacklisted_hosts_PC.txt
        Write-Host "PC Blacklist Rearranged"

        Write-Host "Rearranging PC whitelist..."
        Get-Content .\my_whitelisted_hosts_PC.txt | Sort-Object | Get-Unique | Out-File .\my_whitelisted_hosts_PC2.txt
        Remove-Item .\my_whitelisted_hosts_PC.txt
        Move-Item .\my_whitelisted_hosts_PC2.txt .\my_whitelisted_hosts_PC.txt
        Write-Host "PC Whitelist Rearranged"

        Write-Host "Creating blacklist host file for PC..."
        $con = Get-Content .\my_blacklisted_hosts_PC.txt, .\base_host.txt
        $con | ?{$_ -notin (Get-Content .\my_whitelisted_hosts_PC.txt)} | Select-String -NotMatch "^\s*!.*", "^\s*\[.*", "^\s*#.*", "^\s*$" | Sort-Object | Get-Unique | Out-File "hosts_PC"
        Write-Host "Done"

        Write-Host "Creating blacklist uBlockOrigin file for PC..."
        $con = Get-Content .\hosts_PC
        $con -match "(?<=^0.0.0.0 ).*" | %{$_.replace("0.0.0.0 ", "")} | %{$_ -replace "\s#.*", "" } | Out-File '.\firefox\uBlockOrigin\CustomHostForuBlockOrigin_PC.txt'
        Write-Host "Done"

        Write-Host "Blacklists for PC are ready"
}

Invoke-WebRequest -Uri "https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-social/hosts" -Outfile "base_host.txt"
if(!$PC)
{
        mobile
}

if(!$mobile)
{
        PC
}
Remove-Item .\base_host.txt