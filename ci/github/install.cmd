setlocal
cd "%~dp0..\.."

scripts\install\patch.cmd
@if errorlevel 1 goto :end

scripts\install\foobar2000.cmd v1.3
@if errorlevel 1 goto :end

scripts\install\foobar2000.cmd v1.4
@if errorlevel 1 goto :end

scripts\install\foobar2000.cmd v1.5
@if errorlevel 1 goto :end

:end
