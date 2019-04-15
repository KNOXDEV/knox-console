param($subcommand)

# ensure the correct pshazz selection
function apply() {
    if((pshazz config theme) -ne "console-prompt") {
        cp "$PSScriptRoot\console-prompt.json" "$($env:SCOOP, "$env:USERPROFILE\scoop" | Select-Object -first 1)\apps\pshazz\current\themes"
        pshazz use console-prompt
    }
}

# install our concfg and pshazz configs
# also the profile shim
function install() {
    concfg tokencolor enable -n
    concfg import "$PSScriptRoot\console-mustang.json" -n
    concfg clean
    apply

    # Find $Profile
    if(!(Test-Path $profile)) {
        $profile_dir = Split-Path $profile
        if(!(Test-Path $profile_dir)) { mkdir $profile_dir > $null }
        '' > $profile
    }
    $text = Get-Content $profile

    if($null -eq ($text | Select-String 'knxcon apply')) {
        Write-Output 'Adding knox-console to your powershell profile...'

        # read and write whole profile to avoid problems with line endings and encodings
        $new_profile = @($text) + "try { `$null = Get-Command knxcon -ea stop; knxcon apply } catch { }"
        $new_profile > $profile
    } else {
        Write-Output 'It looks like you have installed knox-console in your powershell profile, skipping'
    }
}


# parse the requested operation
if($subcommand -eq "install") {
    install
}
if($subcommand -eq "apply") {
    apply
}