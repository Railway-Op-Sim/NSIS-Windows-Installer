!include "MUI.nsh"

!define MUI_ICON "media\RailOSInstall.ico"

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

Page license
Page components
Page directory
Page instfiles
UninstPage uninstConfirm
UninstPage instfiles

InstallDir "$PROGRAMFILES32\Railway_Operation_Simulator"

Section "Railway Operation Simulator"
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

Section /o "RailOSPkgManager"
    SetOutPath "$INSTDIR\Railway_Operation_Simulator\Utilities"
    File "RailOSPkgManager\RailOSPkgManager.exe"
    WriteUninstaller "$OUTDIR\Uninstall.exe"
SectionEnd

Section "Uninstall"
    DELETE "$INSTDIR"
SectionEnd