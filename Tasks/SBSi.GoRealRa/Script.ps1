$Domain = 'https://gorealraplayer.radio.sbs.co.kr/intro.html'
$Object1 = Invoke-WebRequest -Uri $Domain | ConvertFrom-Html
$AssetSrc = $Object1.SelectSingleNode('/html/head/script[1]').Attributes['src'].Value

# Version
$this.CurrentState.Version = $Version = [regex]::Match(
  $AssetSrc, '(\d+.\d+.\d+)'
  ).Groups[1].Value

# Installer
$this.CurrentState.Installer += [ordered]@{
  InstallerUrl = "https://gorealraplayer.radio.sbs.co.kr/GOREALRA%20Setup%20" + $Version + ".exe"
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