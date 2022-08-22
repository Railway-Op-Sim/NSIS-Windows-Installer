!define VERSION "2.13.1.0"

!include "MUI2.nsh"

!define MUI_HEADERIMAGE
!define MUI_ICON "media\RailOSInstall.ico"
!define MUI_WELCOMEFINISHPAGE_BITMAP "media\Example_Birmingham.bmp"
!define MUI_HEADERIMAGE_BITMAP "media\header.bmp"

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "LICENSE"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_COMPONENTS
!insertmacro MUI_UNPAGE_INSTFILES

!insertmacro MUI_LANGUAGE "English"

LangString DESC_Section1 ${LANG_ENGLISH} "Install the main simulation software."
LangString DESC_Section2 ${LANG_ENGLISH} "A package manager for Railway Operation Simulator which provides a quick and easy way to manage route add-ons."

Name "Railway Operation Simulator"
InstallDir "$PROGRAMFILES32\Railway_Operation_Simulator"
VIFileVersion "${VERSION}"
VIProductVersion "${VERSION}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductName" "$Name"
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileVersion" "${VERSION}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalCopyright" "© Railway Operation Simulator Development Team"
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileDescription" "Railway signalling simulation software"

Section "Railway Operation Simulator" MainSoftware
    SetOutPath "$INSTDIR"
    File "Railway_Operation_Simulator\railway.exe"
    File "Railway_Operation_Simulator\*.dll"
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
SectionEnd

Section /o "RailOSPkgManager" PackageManager
    SetOutPath "$INSTDIR\Railway_Operation_Simulator\Utilities"
    File "RailOSPkgManager\RailOSPkgManager.exe"
    WriteUninstaller "$OUTDIR\Uninstall.exe"
SectionEnd

Section "Uninstall"
    DELETE "$INSTDIR"
SectionEnd

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
!insertmacro MUI_DESCRIPTION_TEXT ${MainSoftware} $(DESC_Section1)
!insertmacro MUI_DESCRIPTION_TEXT ${PackageManager} $(DESC_Section2)
!insertmacro MUI_FUNCTION_DESCRIPTION_END