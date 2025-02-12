$Object1 = Invoke-WebRequest -Uri 'https://purple-store.plaync.com/api/conti/content?service=PurpleStore&alias=PurpleStore_Download'
$windowsLink = [regex]::Match(
  $Object1.Content, '(https:\/\/[^\s"]+\.exe)'
  ).Groups[1].Value

# Version
$this.CurrentState.Version = [regex]::Match(
  $windowsLink, '(\d+_\d+_\d+_\d+)'
  ).Groups[1].Value.Replace('_', '.')

# Installer
$this.CurrentState.Installer += [ordered]@{
  InstallerUrl = $windowsLink
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