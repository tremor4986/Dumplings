$Object1 = Invoke-WebRequest -Uri 'https://sourceforge.net/projects/tortoisesvn/files/' | ConvertFrom-Html
$3Ver = [regex]::Match(
  $Object1.SelectSingleNode('/html/body/div[4]/div[2]/div[1]/div/div[1]/article/section/div/div/div[2]/div/a[1]').Attributes['title'].Value, '(\d+\.\d+\.\d+)'
  ).Groups[1].Value
$4Ver = [regex]::Match(
  $Object1.SelectSingleNode('/html/body/div[4]/div[2]/div[1]/div/div[1]/article/section/div/div/div[2]/div/a[1]').Attributes['title'].Value, '(\d+\.\d+\.\d+\.\d+)'
  ).Groups[1].Value
$ReleaseVer = [regex]::Match(
  $Object1.SelectSingleNode('/html/body/div[4]/div[2]/div[1]/div/div[1]/article/section/div/div/div[2]/div/a[1]').Attributes['title'].Value, '(svn-\d+\.\d+\.\d+)'
  ).Groups[1].Value
$InstUrl = 'https://sourceforge.net/projects/tortoisesvn/files/'+ $3Ver + '/Application/TortoiseSVN-' + $4Ver + '-arch-' + $ReleaseVer + '.msi'

# Version
$this.CurrentState.Version = $4Ver

# Installer
$this.CurrentState.Installer += [ordered]@{
  Architecture = 'x86'
  InstallerUrl = $InstUrl.Replace('arch', 'win32')
}
$this.CurrentState.Installer += [ordered]@{
  Architecture = 'x64'
  InstallerUrl = $InstUrl.Replace('arch', 'x64')
}
$this.CurrentState.Installer += [ordered]@{
  Architecture = 'arm64'
  InstallerUrl = $InstUrl.Replace('arch', 'ARM64')
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