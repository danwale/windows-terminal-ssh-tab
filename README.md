# windows-terminal-ssh-tab
This script allows you to have a Windows Terminal option for creating SSH connections to configurable hosts. Copy the PowerShell script sslLaunch.ps1 to your home directory and add a .sshhosts file as described below. It currently only supports username/password credentials, I will update it in the future to handle identity certificate files when I need them (or if someone else wants to add that functionality and raise a PR).

It assumes you've already installed the Windows 10 SSH Client, you can follow these instructions for adding it:

**From PowerShell (run as Administrator)**
```
Get-WindowsCapability -Online | ? Name -like 'OpenSSH.Client*'
```
This will return output that is similar to below:
```
Name  : OpenSSH.Client~~~~0.0.1.0
State : NotPresent
```
If the State is *Installed* you don't have to do anything more besides configure the .sshhosts file (described below) and update the settings for Windows Terminal.

If the State is *NotPresent* then you need to add the SSH Client with the following command (note the version number may be higher):
```
Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
```

## .sshhosts File
The script makes use of a JSON configuration file called .sshhosts in the users home directory. If the file has a single host configured in it the tab will try use the SSH Client to connect to that host immediately, if there are multiple hosts configured it will present a selection menu of hosts to attempt to connect to.
```
[
  {
    "Host": "sampleuser@host.com",
    "Port": 22
  },
  {
    "Host": "sampleuser2@host.com",
    "Port": 22
  },
]
```

## Windows Terminal settings.json
From Windows Terminal it's possible to edit the settings.json file to add new tab options.
The following is what can be added to the profiles/list section of the file:
```
{
  "guid": "{D74C6E83-1B53-4668-A70F-CEF80E15FE36}",
  "name": "SSH Client",
  "icon": "ms-appx:///ProfileIcons/{9acb9455-ca41-5af7-950f-6bca1bc9722f}.png",
  "commandline": "powershell.exe -noexit ~//sshLaunch.ps1"
}
```
