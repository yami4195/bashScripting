# URL Health Checker

A simple Bash script that checks whether a website is reachable by testing DNS resolution, TCP connectivity, TLS certificate expiry, and HTTP response status.

This project was built as part of my backend engineering learning journey.

## Features

* Checks DNS resolution using `dig`
* Checks TCP connectivity on port 443 using `nc`
* Checks TLS certificate expiry using `openssl`
* Checks HTTP response status using `curl`
* Logs results with timestamps
* Reports an overall `HEALTHY` or `UNHEALTHY` status
* Returns an exit code for success or failure

## Requirements

This project is designed to run on Linux or Ubuntu through WSL.

Required tools:

* Bash
* dig
* netcat
* OpenSSL
* curl

Install the required tools on Ubuntu:

```bash
sudo apt update
sudo apt install dnsutils netcat-openbsd openssl curl
```

## Usage

Make the script executable:

```bash
chmod +x healthcheck.sh
```

Run the health check by providing a URL:

```bash
./healthcheck.sh https://google.com
```

## Example Output

```text
URL: https://google.com
Hostname: google.com
DNS: PASS - ...
TCP: PASS - Port 443 is reachable
TLS: PASS - Certificate expires in ... days
HTTP: PASS - Status 200

Overall: HEALTHY
```

## Log File

The script saves check results in:

```text
healthcheck.log
```

To view the log:

```bash
cat healthcheck.log
```

## What I Learned

Through this project, I practiced:

* Bash scripting
* Command-line arguments
* Variables and conditions
* Command substitution
* Pipes and output redirection
* DNS resolution
* TCP connectivity
* TLS certificates
* HTTP status codes
* Logging
* Exit codes

## Future Improvements

* Support both HTTP and HTTPS automatically
* Validate URLs more thoroughly
* Improve error handling
* Support custom ports
* Add command-line options
* Add more detailed monitoring features
