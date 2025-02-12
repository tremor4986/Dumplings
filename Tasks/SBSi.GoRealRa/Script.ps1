$Domain = 'https://kr-co-sbs-gorealraplayer.s3.ap-northeast-2.amazonaws.com/latest.yml'
$Object1 = Invoke-RestMethod -Uri $Domain | ConvertFrom-Yaml

# Version
$this.CurrentState.Version = $Version = [regex]::Match(
  $Object1.version, '(\d+.\d+.\d+)'
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