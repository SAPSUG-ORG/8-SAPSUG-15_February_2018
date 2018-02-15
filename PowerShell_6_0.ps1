<#
installing PS6
documentation: https://docs.microsoft.com/en-us/powershell/scripting/setup/installing-powershell-core-on-windows?view=powershell-6
download: https://github.com/PowerShell/PowerShell/releases

ps5.1 module paths:
Directory: C:\Program Files\WindowsPowerShell\Modules
Directory: C:\windows\system32\WindowsPowerShell\v1.0\Modules

PS6 modulePath
Directory: C:\program files\powershell\6.0.1\Modules
#>

<#
ssh on windows
documentation: https://docs.microsoft.com/en-us/powershell/scripting/core-powershell/ssh-remoting-in-powershell-core?view=powershell-6
download: https://github.com/PowerShell/Win32-OpenSSH/releases
note: You should install both client (ssh.exe) and server (sshd.exe) so that you can experiment with remoting to and from the machines.
install instructions: https://github.com/PowerShell/Win32-OpenSSH/wiki/Install-Win32-OpenSSH
#>

$openSSHPath = 'C:\Program Files\OpenSSH'
New-Item -ItemType Directory $openSSHPath
Move-Item -Path 'C:\Users\Administrator\Desktop\OpenSSH-Win64\*' -Destination $openSSHPath

Set-ExecutionPolicy Unrestricted -Scope currentuser
cd 'C:\Program Files\OpenSSH\'
New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
Start-Service sshd
Set-Service sshd -StartupType Automatic
Set-Service ssh-agent -StartupType Automatic

#different paths:
$PSHOME
#enhanced remoting options in core:
(GET-Command New-PSSession).parameters

Get-ChildItem Env:
Get-Item Env:Path
$env:Path

$env:Path += "C:\Program Files\OpenSSH;"



# Linux to Linux
$session = New-PSSession -HostName UbuntuVM1 -UserName TestUser
Enter-PSSession $session
Exit-PSSession

# Linux to Windows
Enter-PSSession -HostName WinVM1 -UserName PTestName

# Windows to Windows
$session = New-PSSession -HostName WinVM2 -UserName PSRemoteUser
Enter-PSSession -Session $session

#rm ~/.ssh/known_hosts

<#
Ubuntu PS6 setup
# Import the public repository GPG keys
curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -

# Register the Microsoft Ubuntu repository
curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list | sudo tee /etc/apt/sources.list.d/microsoft.list

# Update the list of products
sudo apt-get update

# Install PowerShell
sudo apt-get install -y powershell

# Start PowerShell
pwsh
#>

#sudo ifconfig eth0 10.0.0.100 netmask 255.255.255.0
#sudo route add default gw 10.0.0.1 eth0

vim /etc/network/interfaces
iface eth0 inet static
    address 192.168.3.3
    netmask 255.255.255.0
    gateway 192.168.3.1
    dns-nameservers 192.168.3.45 192.168.8.10
systemctl restart networking
ip a
curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list | sudo tee /etc/apt/sources.list.d/microsoft.list
sudo apt-get update
sudo apt-get install -y powershell
pwsh
vim /etc/ssh/sshd_config
#/ (for searching) - Permit
bash sudo apt install openssh-client sudo apt install openssh-server
#Edit the sshd_config file at location /etc/ssh
#
# none PasswordAuthentication yes
# Subsystem powershell /usr/bin/pwsh -sshs -NoLogo -NoProfile
# PubkeyAuthentication yes
#Restart the sshd service bash sudo service sshd restart
