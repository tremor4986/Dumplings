$Object1 = Invoke-RestMethod -Uri 'https://test40.tigrison.com/store/messenger/update/LATEST_RELEASE2'

# Version
$this.CurrentState.Version = $Version = $Object1.win32.version

# Installer
$this.CurrentState.Installer += [ordered]@{
  InstallerUrl = 'https://www.tigrison.com/store/messenger/update/packages/' + $Version + '/TigrisMessenger-' + $Version + '%20Setup.exe'
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