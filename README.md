# python-openssl-docker
Docker image of Python 3.6.0 + OpenSSL 1.1.0e

Building:
`docker build . -t python-openssl`

Using (example): `docker run --rm python-openssl sh -c "mkdir -p /tmp/src && cd /tmp/src && git clone https://github.com/ValdikSS/blockcheck.git &&
cd blockcheck && python3 -m pip install -r requirements.txt && python3 blockcheck.py"`
