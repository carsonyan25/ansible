#ps1_sysnative
# this script used to install openfalcon-agent on windows server

function download-openfalcon-agent
{
	
	#download openfalcon-agent package 
	$package_url = "http://pkg.tuandai888.com/packages/falcon-agent-windows.zip"
	$output = "c:\soft\falcon-agent-windows.zip"

	$wc = New-Object System.Net.WebClient
	$wc.DownloadFile($package_url, $output)

	#decompress openfalcon-agent package
	$zipfile= "C:\soft\falcon-agent-windows.zip"

	$destination = "d:\"

	Add-Type -assembly "system.io.compression.filesystem"

	[io.compression.zipfile]::ExtractToDirectory($zipfile, $destination)

}

function set-openfalcon-agent
{
	
	cd /d D:\falcon-agent
	#get this server's hostname
	$THIS-HOSTNAME=hostname

	$ipaddress = [System.Net.DNS]::GetHostByName($null)
	foreach($ip in $ipaddress.AddressList)
	{
 		 if ($ip.AddressFamily -eq 'InterNetwork')
  		{
  			#get this server's ip
  		  $THIS-IP=$ip.IPAddressToString
  		}
	}
	
	#write hostname and ip to cfg.json 
	(Get-Content .\cfg.json ).replace('set-hostname', '$THIS-HOSTNAME') | Set-Content .\cfg.json
	(Get-Content .\cfg.json ).replace('set-ip', '$THIS-IP') | Set-Content .\cfg.json

}


function install-openfalcon-agent
{
	cd /d D:\falcon-agent
	nssm install falcon-agent  application "D:\falcon-agent\falcon-agent.exe"
	nssm set falcon-agent name "falcon-agent"
	nssm set falcon-agent application "D:\falcon-agent\falcon-agent.exe"
	nssm set falcon-agent appdirectory "D:\falcon-agent"
	nssm start falcon-agent
}

set-openfalcon-agent