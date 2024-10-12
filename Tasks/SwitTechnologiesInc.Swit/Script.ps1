$Object1 = Invoke-RestMethod -Uri 'https://api3.swit.io/v1/common/version?device=PCAPP'

# Version
$this.CurrentState.Version = $Object1.data.latest_ver

# Installer
$this.CurrentState.Installer += [ordered]@{
  InstallerUrl = "https://af.swit.io/app/swit-" + $Object1.data.latest_ver + ".exe"
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