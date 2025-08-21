$Object1 = Invoke-RestMethod -Uri 'https://daou.daouoffice.com/api/update-center/public/application/check-update?osType=WINDOWS&version=0.0.0'

# Version
$this.CurrentState.Version = $Object1.latestVersion

# Installer
$this.CurrentState.Installer += [ordered]@{
  InstallerUrl = $Object1.latestPath
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
