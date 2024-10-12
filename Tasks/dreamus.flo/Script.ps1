$Object1 = Invoke-RestMethod -Uri 'https://www.music-flo.com/api/external/v1/electron/release'

# Version
$this.CurrentState.Version = $Object1.data.latestVersion

# Installer
$this.CurrentState.Installer += [ordered]@{
  InstallerUrl = $Object1.data.exeDownloadUrl
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