#get all user dirs
function Test-RegistryValue 
{
    param (
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]$Path,
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]$Value
    )
    try{
        Get-ItemProperty -Path $Path | Select-Object -ExpandProperty $Value -ErrorAction Stop | Out-Null
        return $true
    }
    catch{
        return $false
    }
}
   
Try
{
    $user_folders = Get-ChildItem -Path "C:\Users"
    ForEach ($userFolder in $user_folders)
    {
        #get extension folders
        if (Test-Path -Path "$($userFolder.FullName)\AppData\Local\Google\Chrome\User Data\Default\Extensions")
        {
            $extension_folders = Get-ChildItem -Path "$($userFolder.FullName)\AppData\Local\Google\Chrome\User Data\Default\Extensions"
            #loop through each extension folder
            ForEach ($extension_folder in $extension_folders)
            {
                $version_folders = Get-ChildItem -Path "$($extension_folder.FullName)"
                ForEach ($version_folder in $version_folders) {
                    ##: The extension folder name is the app id in the Chrome web store
                    $appid = $extension_folder.BaseName
                    ##: First check the manifest for a name
                    If( Test-Path -Path "$($version_folder.FullName)\manifest.json")
                    {
                        $json = Get-Content -Raw -Path "$($version_folder.FullName)\manifest.json" | ConvertFrom-Json
                        $name = $json.name
                        $extType = "EXT"
                            ##: If we find _MSG_ in the manifest it's probably an app
                            if( $name -like "*MSG*" ) {
                                ##: Sometimes the folder is en
                                if( Test-Path -Path "$($version_folder.FullName)\_locales\en\messages.json" ) {
                                    $json = Get-Content -Raw -Path "$($version_folder.FullName)\_locales\en\messages.json" | ConvertFrom-Json
                                    $name = $json.appName.message
                                    $extType = "APP"
                                    if(!$name) {
                                        $name = $json.extName.message
                                    }
                                    if(!$name) {
                                        $name = $json.app_name.message
                                    }
                                }
                                ##: Sometimes the folder is en_US
                                if( Test-Path -Path "$($version_folder.FullName)\_locales\en_US\messages.json" ) {
                                    $json = Get-Content -Raw -Path "$($version_folder.FullName)\_locales\en_US\messages.json" | ConvertFrom-Json
                                    $name = $json.appName.message
                                    $extType = "APP"
                                    if(!$name) {
                                        $name = $json.extName.message
                                    }
                                    if(!$name) {
                                        $name = $json.app_name.message
                                    }
                                }                       
                            }
                            if( ($extension_folder -ne "") -or `
                                ($extension_folder -ne "") -or `
                                ($extension_folder -ne "") -or `
                                ($extension_folder -ne "") -or `
                                ($extension_folder -ne ""))
                            {
                                try
                                {
                                    #checks to see if the registry Key already exits
                                    $keyPath = "HKEY_LOCAL_MACHINE\SOFTWARE\Westrock\ChromeExt"
                                    if(Test-RegistryValue -path $keyPath -Value  $extension_folder)
                                    {}
                                    Else # if it doesn't exist then it creates the key
                                    {
                                        if(!(Test-Path $keyPath))
                                        {
                                            New-Item -Path $keyPath -Force | Out-Null
                                        }
                                        New-ItemProperty -Path $keyPath -Name $extension_folder -Value $name `
                                        -PropertyType REG_SZ -Force | Out-Null
                                    }
                                }
                                Catch{}
                            }
                            Else
                            {
                                
                            }
            
                    }
                }
            }
        }
    }
}
Catch{}