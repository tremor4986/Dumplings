$Object1 = Invoke-RestMethod -Uri 'https://apis.millie.co.kr/v3/lib/versions/'

# Version
$this.CurrentState.Version = $Version = $Object1.pcv_win

# Installer
$this.CurrentState.Installer += [ordered]@{
  InstallerUrl = "https://apis.millie.co.kr/v1/download/installer/win/millie-$($Version).exe"
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