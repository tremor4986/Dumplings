$Object1 = Invoke-WebRequest -Uri 'https://apis.millie.co.kr/v3/lib/versions/' | ConvertFrom-Html

# Version

$this.CurrentState.Version = $Object1.pcv_win

# Installer
$this.CurrentState.Installer += [ordered]@{
  InstallerUrl = "https://apis.millie.co.kr/v1/download/installer/win/millie-" + $Object1.pcv_win + ".exe"
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