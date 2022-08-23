Unicode True

!define VERSION "2.13.1.0"
!define APP_EXE "railway.exe"

ShowInstDetails show
OutFile "Install_RailOs.exe"

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

LangString DESC_Section1 ${LANG_ENGLISH} "Install the main simulation software."
LangString DESC_Section2 ${LANG_ENGLISH} "A package manager for Railway Operation Simulator which provides a quick and easy way to manage route add-ons."

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
    SetOutPath "$INSTDIR"
    File "media\railos.ico"
    File "Railway_Operation_Simulator\${APP_EXE}"
    File "Railway_Operation_Simulator\*.dll"
    EnVar::AddValue "RAILOS_HOME" "$INSTDIR"
    CreateDirectory "$OUTDIR\Formatted timetables"
    CreateDirectory "$OUTDIR\Documentation"
    CreateDirectory "$OUTDIR\Graphics"
    CreateDirectory "$OUTDIR\Images"
    CreateDirectory "$OUTDIR\Metadata"
    CreateDirectory "$OUTDIR\Performance logs"
    CreateDirectory "$OUTDIR\Program timetables"
    CreateDirectory "$OUTDIR\Railways"
    CreateDirectory "$OUTDIR\Sessions"
    WriteUninstaller "$OUTDIR\Uninstall.exe"
    WriteRegStr HKLM "${UNINSTALL_KEYLOC}" "DisplayName" "${APP_NAME}"
    WriteRegStr HKLM "${UNINSTALL_KEYLOC}" "UninstallString" "$INSTDIR\Uninstall.exe"
    WriteRegStr HKLM "${UNINSTALL_KEYLOC}" "UninstallStringQuiet" "$INSTDIR\Uninstall.exe"
    WriteRegStr HKLM "${UNINSTALL_KEYLOC}" "DisplayIcon" "$INSTDIR\railos.ico"
    WriteRegStr HKLM "${UNINSTALL_KEYLOC}" "DisplayVersion" "${VERSION}"
    WriteRegStr HKLM "${UNINSTALL_KEYLOC}" "Publisher" "${APP_NAME} Development Team"
    WriteRegStr HKLM "${UNINSTALL_KEYLOC}" "HelpLink" "https://www.railwayoperationsimulator.com/catalog/base-program/railway-operation-simulator-manuals"
    WriteRegStr HKLM "${UNINSTALL_KEYLOC}" "URLInfoAbout" "https://www.railwayoperationsimulator.com"
    WriteRegStr HKLM "${UNINSTALL_KEYLOC}" "HelpLink" "https://www.railwayoperationsimulator.com"
	createDirectory "$SMPROGRAMS\${APP_NAME}"
	createShortCut "$SMPROGRAMS\${APP_NAME}\${APP_NAME}.lnk" "$INSTDIR\${APP_EXE}" "" "$INSTDIR\railos.ico"
    AccessControl::GrantOnFile "$INSTDIR" "(BU)" "FullAccess"
SectionEnd

Section /o "RailOSPkgManager" PackageManager
    SetOutPath "$INSTDIR\Utilities\RailOSPkgManager"
    File "RailOSPkgManager\RailOSPkgManager.exe"
    File "RailOSPkgManager\railospkgmanager.ico"
    File "RailOSPkgManager\*.dll"
    File /r "RailOSPkgManager\platforms"
    File /r "RailOSPkgManager\translations"
    createShortCut "$SMPROGRAMS\${APP_NAME}\RailOSPkgManager.lnk" "$OUTDIR\RailOSPkgManager.exe" "" "$OUTDIR\railospkgmanager.ico"
SectionEnd

Section /o "json2ttb" JSON2TTB
    SetOutPath "$INSTDIR\Utilities\json2ttb"
    File "json2ttb\json2ttb.jar"
    File "extras\json2ttb"
    File "extras\json2ttb.bat"
    EnVar::AddValue "PATH" "$OUTDIR"
SectionEnd

Section "un.Railway Operation Simulator"
    RMDir /r "$INSTDIR"
    EnVar::Delete "RAILOS_HOME"
    EnVar::DeleteValue "PATH" "$\"$INSTDIR\Utilities\json2ttb$\""
    DeleteRegKey HKLM "${UNINSTALL_KEYLOC}"
	delete "$SMPROGRAMS\${APP_NAME}\*.lnk"
	rmDir "$SMPROGRAMS\${APP_NAME}"
SectionEnd

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
!insertmacro MUI_DESCRIPTION_TEXT ${MainSoftware} $(DESC_Section1)
!insertmacro MUI_DESCRIPTION_TEXT ${PackageManager} $(DESC_Section2)
!insertmacro MUI_FUNCTION_DESCRIPTION_END