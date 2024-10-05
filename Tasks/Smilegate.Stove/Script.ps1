$Object1 = Invoke-RestMethod -Uri 'https://api.onstove.com/game/v1.0/stove/client/download'

# Version

$this.CurrentState.Version = "2.0.0." + [regex]::Match($Object1.value[0], '\d{4}').Groups[1].Value

# Installer
$this.CurrentState.Installer += [ordered]@{
  InstallerUrl = $Object1.value
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