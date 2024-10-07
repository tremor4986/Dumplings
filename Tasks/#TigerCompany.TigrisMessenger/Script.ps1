$Object1 = Invoke-WebRequest -Uri 'https://www.tigrison.com/home' | ConvertFrom-Html

# Version

$this.CurrentState.Version = "1.1.7"

# Installer
$this.CurrentState.Installer += [ordered]@{
  InstallerUrl = 'https://www.tigrison.com/store/messenger/update/packages/1.1.7/TigrisMessenger-1.1.7%20Setup.exe'
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