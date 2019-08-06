echo "appveyor version"
appveyor version
$ErrorActionPreference = "Stop"
echo (New-Object Net.WebClient).DownloadString('https://www.appveyor.com/tools/my-ip.aspx')

#install:
#- ps: Start-FileDownload http://nsis.sourceforge.net/mediawiki/images/d/d7/NSIS_Simple_Firewall_Plugin_1.20.zip -FileName SimpleFC.zip
#- ps: Start-FileDownload http://nsis.sourceforge.net/mediawiki/images/c/c9/Inetc.zip -FileName Inetc.zip
#- appveyor DownloadFile http://nsis.sourceforge.net/mediawiki/images/2/28/Nsisos.zip -FileName Nsisos.zip

#- dir c:\go16\doc
echo "Pushing artifacts"
Push-AppveyorArtifact C:\go16\doc\go1.html -FileName 'go - file - with spaces, v. 1.html'
Push-AppveyorArtifact C:\go16\doc\go1.1.html
Push-AppveyorArtifact C:\go16\doc\go1.2.html
Push-AppveyorArtifact C:\go16\doc\go1.3.html
Push-AppveyorArtifact C:\go16\doc\go1.4.html
Push-AppveyorArtifact C:\go16\doc\go1.5.html
Push-AppveyorArtifact C:\go16\doc\go1.6.html

# download bunch of files in a row using PS
echo "Download bunch of files in a row using PS"
Start-FileDownload 'https://dl.dropboxusercontent.com/s/c1by0uulee6g8th/wxWidgets.7z?dl=0' -FileName wxWidgets.7z
Start-FileDownload 'https://drive.google.com/uc?export=download&id=0B-98fOyaZKJ5YWVnb29JZXFQWkU' -FileName llvmlibs.7z
Start-FileDownload 'https://drive.google.com/uc?export=download&id=0B8A6NaxhQAGRa21fbDQteTN1dGs' -FileName vulkan.7z
Start-FileDownload 'https://drive.google.com/uc?export=download&id=0B6v_qtb9hkicQ2hHa2dRbF83cE0' -FileName zlib.7z
Start-FileDownload https://www.appveyor.com/downloads/Appveyor.NUnitLogger.zip
Start-FileDownload https://www.appveyor.com/downloads/Appveyor.NUnit3Logger.zip

# download bunch of files in a row using appveyor.exe
echo "Download bunch of files in a row using appveyor.exe"
appveyor DownloadFile "https://dl.dropboxusercontent.com/s/c1by0uulee6g8th/wxWidgets.7z?dl=0" -FileName wxWidgets.7z
appveyor DownloadFile "https://drive.google.com/uc?export=download&id=0B-98fOyaZKJ5YWVnb29JZXFQWkU" -FileName llvmlibs.7z
appveyor DownloadFile "https://drive.google.com/uc?export=download&id=0B8A6NaxhQAGRa21fbDQteTN1dGs" -FileName vulkan.7z
appveyor DownloadFile "https://drive.google.com/uc?export=download&id=0B6v_qtb9hkicQ2hHa2dRbF83cE0" -FileName zlib.7z

appveyor PushArtifact README.md -Verbosity Quiet
Push-AppveyorArtifact C:\go16\CONTRIBUTORS -Verbosity Normal
Push-AppveyorArtifact C:\go16\AUTHORS -Verbosity Minimal
Push-AppveyorArtifact C:\go16\LICENSE -Verbosity Quiet


#test_script:
echo "Zipping for upload through 'artifacts' section"
7z a go17.zip c:\go17
copy go17.zip go17-1.zip
appveyor PushArtifact go17-1.zip -Type Auto -Verbosity Minimal
copy go17.zip go17-2.zip
Push-AppveyorArtifact go17-1.zip
Start-FileDownload https://nodejs.org/dist/v6.5.0/node-v6.5.0-darwin-x64.tar.gz -FileName "$env:appveyor_build_folder\node-v6.5.0.zip" -Timeout 1000
appveyor DownloadFile https://nodejs.org/dist/v6.6.0/node-v6.6.0-darwin-x64.tar.gz -Timeout 1000
cmd /c mklink go17-1-link.zip go17-1.zip
Push-AppveyorArtifact go17-1-link.zip
cmd /c mklink go17-2-link.zip go17-1.zip
move C:\go16 $env:appveyor_build_folder\go16
appveyor PushArtifact README.md -FileName README-2.md -Verbosity Normal

#artifacts:
#- path: go17.zip
#- path: go17-2-link.zip
#- path: go16

#on_failure:
Get-EventLog AppVeyor -newest 10 | Format-List
