$Object1 = Invoke-RestMethod -Uri 'https://purple-api.plaync.com/api/categories/purpleWeb/contents/purple-store?keySets=purple-download-info'
$WindowsLink = $Object1.'purple-download-info'.download_info.download_link.pc.windowsLink

# Version
$this.CurrentState.Version = [regex]::Match(
  $WindowsLink, '(\d+_\d+_\d+_\d+)'
  ).Groups[1].Value.Replace('_', '.')

# Installer
$this.CurrentState.Installer += [ordered]@{
  InstallerUrl = $WindowsLink
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