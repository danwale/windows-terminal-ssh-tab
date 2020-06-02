Write-Host "SSH Client" -ForegroundColor Cyan
Write-Host "Using the ~/.sshhosts file to provide your host selections, this should contain a JSON array of Host and Port properties" -ForegroundColor DarkGreen
if (Test-Path ~/.sshhosts -PathType Leaf) 
{
	$hostSettings = Get-Content -Raw -Path ~/.sshhosts | ConvertFrom-Json
	if ($hostSettings.Length -eq 1)
	{
		$server = $hostSettings[0].Host
		$port = $hostSettings[0].Port
	}
	else
	{
		Write-Host "Select a host to connect to from the list below:" -ForegroundColor Yellow
		For ($i = 1; $i -le $hostSettings.Length; $i++) 
		{
			$hostSetting = $hostSettings[$i-1]
			Write-Host "   $($i)) $($hostSetting.Host):$($hostSetting.Port)" -ForegroundColor Yellow
		}
		$selection = $(Write-Host "Selection: " -ForegroundColor Yellow -NoNewline; Read-Host)
		while ($selection -notmatch '^\d+$' -or $selection -gt $i-1 -or $selection -eq 0)
		{
			Write-Host "You must enter a valid option number." -ForegroundColor Red
			$selection = $(Write-Host "Selection: " -ForegroundColor Yellow -NoNewline; Read-Host)
		}
		$hostSetting = $hostSettings[$selection-1]
		$server = $hostSetting.Host
		$port = $hostSetting.Port
	}
	Write-Host "Connecting to host $($server):$($port)" -ForegroundColor DarkYellow
	ssh $server -p $port
} 
else
{

	Write-Host "Configure a .sshhosts file in your home directory with a JSON array of objects with Host and Port properties e.g.:" -ForegroundColor Red
	Write-Host "[" -ForegroundColor Magenta
	Write-Host "   {" -ForegroundColor Magenta
	Write-Host "      ""Host"" : ""user@host.com""" -ForegroundColor Magenta
    Write-Host "      ""Port"" : ""22""" -ForegroundColor Magenta
    Write-Host "   }" -ForegroundColor Magenta
	Write-Host "]" -ForegroundColor Magenta
}