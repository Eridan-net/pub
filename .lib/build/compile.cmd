
set source=%1
set target=..\%source%.sef.json

set njs=D:\packages\nodeJS

set xslt3=%njs%\node_modules\xslt3

call %njs%\node %xslt3%\xslt3.js -t -xsl:%source%.xsl -export:%target% -nogo -relocate:on
pause
