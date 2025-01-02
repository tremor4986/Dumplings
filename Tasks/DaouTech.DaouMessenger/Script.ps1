$Object1 = Invoke-RestMethod -Uri 'https://daou.daouoffice.com/api/device/version/check?deviceType=pc_electron&version=3.0.0&lang=ko'

# Version
$this.CurrentState.Version = $Version = $Object1.data.version

# Installer
$this.CurrentState.Installer += [ordered]@{
  InstallerUrl = "https://msgdown.daouoffice.com:4443/app/electron/"+ $Version +"/DaouMessenger%20Setup%20" + $Version + ".exe"
}

switch -Regex ($this.Check()) {
  'New|Changed|Updated' {
    $this.Print()
    $this.Write()
  }
  'Changed|Updated' {
    $this.Message()
  }
  'Updated' {
    $this.Submit()
  }
}