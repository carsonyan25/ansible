#ps1_sysnative
#this script used to initialize windows server
# include task   change administrator password ,auto mount Partition D, set firewall 
# install openfalcon-agent on d:\falcon-agnet, salt-minion on c:\salt

function change_administrator_pass
{
    net user administrator TDtest123
}


function diskpart_for_d
{
#attach disk and create volume
"select disk 1 `r  ATTRIBUTES DISK CLEAR READONLY `r  online disk `r  `r  create partition primary " | diskpart

#format disk and assign letter
"select disk 1 `r   select volume 2 `r  format fs=ntfs quick label='data'  `r  assign letter=D  "  | diskpart

}

function insert_firewall_rule
{

#New-NetFirewallRule -DisplayName "allow sql port 1433" -Direction Inbound -LocalPort 1433 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "allow http port 80" -Direction Inbound -LocalPort 80 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "allow openfalcon-agent 1988" -Direction Inbound -LocalPort 1988 -Protocol TCP -Action Allow

}


function install-openfalcon-agent
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


	$cfgFile="d:\falcon-agent\cfg.json"
	
	#get this server's hostname
	$ThisHostname=hostname

	$ThisNet="本地连接"

	$ipaddress = [System.Net.DNS]::GetHostByName($null)
	foreach($ip in $ipaddress.AddressList)
	{
 		 if ($ip.AddressFamily -eq 'InterNetwork')
  		{
  			#get this server's ip
  		  $ThisIP=$ip.IPAddressToString
  		}
	}
	

	#write hostname and ip , localnetwork to cfg.json 
	$content = [System.IO.File]::ReadAllText("$cfgFile").Replace("set-hostname","$ThisHostname")
	[System.IO.File]::WriteAllText("$cfgFile", $content)

	$content = [System.IO.File]::ReadAllText("$cfgFile").Replace("set-ip","$ThisIP")
	[System.IO.File]::WriteAllText("$cfgFile", $content)

	$content = [System.IO.File]::ReadAllText("$cfgFile").Replace("set-net","$ThisNet")
	[System.IO.File]::WriteAllText("$cfgFile", $content)



	#install openfalcon-agent as service
	cd  D:\falcon-agent
	.\nssm install falcon-agent  application "D:\falcon-agent\falcon-agent.exe"
	.\nssm set falcon-agent name "falcon-agent"
	.\nssm set falcon-agent application "D:\falcon-agent\falcon-agent.exe"
	.\nssm set falcon-agent appdirectory "D:\falcon-agent"
	.\nssm start falcon-agent

}


function  install-salt-minion
{

	cd c:\soft

	#download Salt-Minion package 
	$package_url = "http://pkg.tuandai888.com/packages/Salt-Minion-2018.3.0-Py2-AMD64-Setup.exe"
	$output = "c:\soft\Salt-Minion-2018.3.0-Py2-AMD64-Setup.exe"

	$wc = New-Object System.Net.WebClient
	$wc.DownloadFile($package_url, $output)

	$NAME=hostname
	.\Salt-Minion-2018.3.0-Py2-AMD64-Setup.exe /S /master=salt-master.tuandai800.cn /minion-name=$NAME
}


change_administrator_pass
diskpart_for_d
install-openfalcon-agent
install-salt-minion
insert_firewall_rule
