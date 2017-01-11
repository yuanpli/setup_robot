@echo off
call :check_Permissions
pushd %temp%
 
@echo.===================================================================
@echo.install python-2.7.6.amd64
call :download "http://www.python.org/ftp/python/2.7.6/python-2.7.6.amd64.msi" "python-2.7.6.amd64.msi"
python-2.7.6.amd64.msi /passive
call :download "http://www.rapidee.com/download/RapidEE_setup.exe" "RapidEE_setup.exe"
RapidEE_setup.exe /SILENT
"%programfiles%\Rapid Environment Editor\RapidEE.exe" -a -c Path "C:\Python27;C:\Python27\scripts"
 
@echo.===================================================================
@echo.install setuptools
call :download "https://github.com/yuanpli/setup_robot/raw/master/patch.py" "patch.py"
call :create_patch
python patch.py -d C:\Python27 python27_patch.diff
call :download "https://github.com/yuanpli/setup_robot/raw/master/ez_setup.py" "ez_setup.py"
python ez_setup.py
 
@echo.===================================================================
@echo.install pip
call :download "https://bootstrap.pypa.io/get-pip.py" "get-pip.py"
python get-pip.py
 
@echo.===================================================================
@echo.install wxPython2.8-win64-unicode-2.8.12.1-py27
call :download "http://downloads.sourceforge.net/project/wxpython/wxPython/2.8.12.1/wxPython2.8-win64-unicode-2.8.12.1-py27.exe" "wxPython2.8-win64-unicode-2.8.12.1-py27.exe"
wxPython2.8-win64-unicode-2.8.12.1-py27.exe 
 
@echo.===================================================================
@echo.install robotframework
pip install --upgrade robotframework
 
@echo.===================================================================
@echo.install robotframework-ride
call :download "https://github.com/robotframework/RIDE/releases/download/v1.5.2.1/robotframework-ride-1.5.2.1.win-amd64.exe" "robotframework-ride-1.5.2.1.win-amd64.exe"
robotframework-ride-1.5.2.1.win-amd64.exe
pip install --upgrade robotframework-ride --allow-external robotframework-ride --allow-unverified robotframework-ride
 
 
pause
@goto :EOF
 
:download 
@"C:\Windows\System32\WindowsPowerShell\v1.0\powershell" "$wc = New-Object System.Net.WebClient;$wc.DownloadFile('%1', '%2')"
@echo %2
@goto :EOF
 
:create_patch
@> python27_patch.diff (
@echo.Index: Lib/mimetypes.py
@echo.===================================================================
@echo.--- Lib/mimetypes.py  (revision 85786^)
@echo.+++ Lib/mimetypes.py  (working copy^)
@echo.@@ -27,6 +27,7 @@
@echo. import sys
@echo. import posixpath
@echo. import urllib
@echo.+from itertools import count
@echo. try:
@echo.     import _winreg
@echo. except ImportError:
@echo.@@ -239,19 +240,11 @@
@echo.             return
@echo. 
@echo.         def enum_types(mimedb^):
@echo.-            i = 0
@echo.-            while True:
@echo.+            for i in count(^):
@echo.                 try:
@echo.-                    ctype = _winreg.EnumKey(mimedb, i^)
@echo.+                    yield _winreg.EnumKey(mimedb, i^)
@echo.                 except EnvironmentError:
@echo.                     break
@echo.-                try:
@echo.-                    ctype = ctype.encode(default_encoding^) # omit in 3.x!
@echo.-                except UnicodeEncodeError:
@echo.-                    pass
@echo.-                else:
@echo.-                    yield ctype
@echo.-                i += 1
@echo. 
@echo.         default_encoding = sys.getdefaultencoding(^)
@echo.         with _winreg.OpenKey(_winreg.HKEY_CLASSES_ROOT, ''^) as hkcr:
)
@goto :EOF
 
 
:check_Permissions
echo Administrative permissions required. Detecting permissions...
net session >nul 2>&1
if %errorLevel% == 0 (
	echo Success: Administrative permissions confirmed.
	@goto :EOF
) else (
	echo Failure: Current permissions inadequate.
	pause >nul
	exit
)