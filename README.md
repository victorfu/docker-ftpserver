ftp server
=========

`docker build --rm -t ftpserver .`

`docker run -d -p 20:20 -p 21:21 --name ftpserver ftpserver`


Testing
-------

`docker run -t -i ftpserver /bin/bash`
