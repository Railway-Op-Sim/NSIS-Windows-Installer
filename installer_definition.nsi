Unicode True

; Set metadata for the RailOS release here
!define VERSION "2.13.2.0"
!define APP_EXE "railway.exe"

ShowInstDetails show
OutFile "Install_RailOS.exe"

!include "MUI2.nsh"

!define APP_NAME "Railway Operation Simulator"
!define UNINSTALL_KEYLOC "Software\Microsoft\Windows\CurrentVersion\Uninstall\Railway_Operation_Simulator"
!define MUI_HEADERIMAGE
!define MUI_ICON "media\RailOSInstall.ico"
!define MUI_WELCOMEFINISHPAGE_BITMAP "media\Example_Birmingham.bmp"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "media\Example_Birmingham.bmp"
!define MUI_HEADERIMAGE_BITMAP "media\header.bmp"
!define MUI_UNHEADERIMAGE_BITMAP "media\header.bmp"
!define MUI_FINISHPAGE_BUTTON "Exit"
!define MULTIUSER_EXECUTIONLEVEL Highest
!define MULTIUSER_INSTALLMODE_INSTDIR "${APP_NAME}"
!define MULTIUSER_MUI

!include "MultiUser.nsh"
!include "LogicLib.nsh"

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "LICENSE"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

!insertmacro MUI_LANGUAGE "English"

; Descriptions for the components
LangString DESC_Section1 ${LANG_ENGLISH} "Install the main simulation software."
LangString DESC_Section2 ${LANG_ENGLISH} "A package manager for Railway Operation Simulator which provides a quick and easy way to manage route add-ons."
LangString DESC_Section3 ${LANG_ENGLISH} "A launcher for Railway Operation Simulator which provides live updates on Discord. Installation requires internet connection."

Name "${APP_NAME}"
InstallDir "$PROGRAMFILES32\Railway_Operation_Simulator"
VIFileVersion "${VERSION}"
VIProductVersion "${VERSION}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductName" "${Name}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileVersion" "${VERSION}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalCopyright" "© Railway Operation Simulator Development Team"
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileDescription" "Railway signalling simulation software"

Function .onInit
    !insertmacro MULTIUSER_INIT
FunctionEnd

Function un.onInit
    !insertmacro MULTIUSER_UNINIT
FunctionEnd

Section "${APP_NAME}" MainSoftware
    SectionIn RO
    SetOutPath "$INSTDIR\Railway"
    File "media\railos.ico"
    File /r "Railway_Operation_Simulator\Railway\*"
    WriteUninstaller "$INSTDIR\Uninstall.exe"
    WriteRegStr HKLM "${UNINSTALL_KEYLOC}" "DisplayName" "${APP_NAME}"
    WriteRegStr HKLM "${UNINSTALL_KEYLOC}" "UninstallString" "$INSTDIR\Uninstall.exe"
    WriteRegStr HKLM "${UNINSTALL_KEYLOC}" "UninstallStringQuiet" "$INSTDIR\Uninstall.exe"
    WriteRegStr HKLM "${UNINSTALL_KEYLOC}" "DisplayIcon" "$OUTDIR\railos.ico"
    WriteRegStr HKLM "${UNINSTALL_KEYLOC}" "DisplayVersion" "${VERSION}"
    WriteRegStr HKLM "${UNINSTALL_KEYLOC}" "Publisher" "${APP_NAME} Development Team"
    WriteRegStr HKLM "${UNINSTALL_KEYLOC}" "HelpLink" "https://www.railwayoperationsimulator.com/catalog/base-program/railway-operation-simulator-manuals"
    WriteRegStr HKLM "${UNINSTALL_KEYLOC}" "URLInfoAbout" "https://www.railwayoperationsimulator.com"
    WriteRegStr HKLM "${UNINSTALL_KEYLOC}" "HelpLink" "https://www.railwayoperationsimulator.com"
	createDirectory "$SMPROGRAMS\${APP_NAME}"
	createShortCut "$SMPROGRAMS\${APP_NAME}\${APP_NAME}.lnk" "$OUTDIR\${APP_EXE}" "" "$OUTDIR\railos.ico"
    AccessControl::GrantOnFile "$INSTDIR" "(BU)" "FullAccess"
SectionEnd

Section /o "RailOSPkgManager" PackageManager
    SetOutPath "$INSTDIR\Utilities\RailOSPkgManager"

    ; Copy all required files for the package manager
    File "RailOSPkgManager\RailOSPkgManager.exe"
    File "RailOSPkgManager\railospkgmanager.ico"
    File "RailOSPkgManager\*.dll"
    File /r "RailOSPkgManager\platforms"
    File /r "RailOSPkgManager\translations"

    ; Create the cache file to point to the RailOS install so the user doesn't have to set it
    ${If} ${FileExists} "$%LOCALAPPDATA%\RailOSPkgManager\cache"
        rmDir /r "$%LOCALAPPDATA%\RailOSPkgManager\cache"
        ${If} ${Errors}
            MessageBox mb_IconStop|mb_TopMost|mb_SetForeground "Failed to create cache directory for RailOSPkgManager"
        ${EndiF}
    ${EndIf}

    createDirectory "$%LOCALAPPDATA%\RailOSPkgManager\cache"
    AccessControl::GrantOnFile "$%LOCALAPPDATA%\RailOSPkgManager\cache" "(BU)" "FullAccess"
    FileOpen $0 "$%LOCALAPPDATA%\RailOSPkgManager\cache\ros_cfg" w
    FileWrite $0 "$INSTDIR"
    FileClose $0

    ; Create a start menu shortcut for the package manager
    createShortCut "$SMPROGRAMS\${APP_NAME}\RailOSPkgManager.lnk" "$OUTDIR\RailOSPkgManager.exe" "" "$OUTDIR\railospkgmanager.ico"
SectionEnd

Section /o "RailOS Discord Launcher" DiscordLauncher
    SetOutPath "$INSTDIR\Railway\Discord"

    ; Copy all required files for the discord launcher
    File "RailOSLauncher\railos_launcher.exe"
    File "RailOSLauncher\RailOSLauncher.ico"

    ; Create a start menu shortcut for the launcher
    createShortCut "$SMPROGRAMS\${APP_NAME}\RailOSLauncher.lnk" "$OUTDIR\railos_launcher.exe" "" "$OUTDIR\RailOSLauncher.ico"

    ; Download the SDK
    NSISdl::download_quiet https://dl-game-sdk.discordapp.net/3.2.1/discord_game_sdk.zip "$OUTDIR\discord_game_sdk.zip"
    Pop $R0

    CreateDirectory "$OUTDIR\lib"

    StrCmp $R0 "success" +3
    MessageBox MB_OK "Failed to download Discord SDK for RailOSLauncher, $R0."
    Quit
    nsisunz::UnzipToLog /noextractpath /file "lib\x86_64\discord_game_sdk.dll" "$OUTDIR\discord_game_sdk.zip" "$OUTDIR\lib"
    Pop $R0
    StrCmp $R0 "success" +2
        MessageBox MB_OK "Failed to extract Discord SDK for RailOSLauncher, $R0."
    Delete "discord_game_sdk.zip"
SectionEnd

Section "un.Railway Operation Simulator"
    RMDir /r "$INSTDIR"
    DeleteRegKey HKLM "${UNINSTALL_KEYLOC}"
	delete "$SMPROGRAMS\${APP_NAME}\*.lnk"
    rmDir "$%LOCALAPPDATA%\RailOSPkgManager"
	rmDir "$SMPROGRAMS\${APP_NAME}"
SectionEnd

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
!insertmacro MUI_DESCRIPTION_TEXT ${MainSoftware} $(DESC_Section1)
!insertmacro MUI_DESCRIPTION_TEXT ${PackageManager} $(DESC_Section2)
!insertmacro MUI_DESCRIPTION_TEXT ${DiscordLauncher} $(DESC_Section3)
!insertmacro MUI_FUNCTION_DESCRIPTION_END