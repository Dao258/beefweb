setlocal
cd "%~dp0..\.."

call scripts\install\patch.cmd
@if errorlevel 1 goto :end

call scripts\install\foobar2000.cmd v1.3
@if errorlevel 1 goto :end

call scripts\install\foobar2000.cmd v1.4
@if errorlevel 1 goto :end

call scripts\install\foobar2000.cmd v1.5
@if errorlevel 1 goto :end

:end
