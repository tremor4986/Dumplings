$Object1 = Invoke-WebRequest -Uri 'https://purple-store.plaync.com/api/conti/content?service=PurpleStore&alias=PurpleStore_Download' | ConvertFrom-Html

# Version

$this.CurrentState.Version = [regex]::Match(
  $Object1.SelectSingleNode('/html/body/div/div[3]/a').Attributes['href'].Value, '(\d+\_\d+\_\d+\_\d+)'
  ).Groups[1].Value.Replace('_', '.')

# Installer
$this.CurrentState.Installer += [ordered]@{
  InstallerUrl ="https://gs-purple-inst.download.ncupdate.com/Purple/PurpleInstaller_" + [regex]::Match(
  $Object1.SelectSingleNode('/html/body/div/div[3]/a').Attributes['href'].Value, '(\d+\_\d+\_\d+\_\d+)'
  ).Groups[1].Value + ".exe"
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