# Software Security Testing

The objective is to have a list of security technologies to check the repositories.
The second objective is the ability to store report in json each time.

## Static Application Security Testing (SAST)

| Programming Language   | Tools                              |
| ---------------------- | ---------------------------------- |
| generic                | semgrep                            |
| android (java/kotlin)  | MobSF                              |
| c# / .NET              | semgrep                            |
| golang                 | gosec                              |
| ios (objective-c/swift)| MobSF                              |
| java                   | semgrep                            |
| javascript             | njsscan,semgrep                    |
| php                    | phpcs-security-audit               |
| ruby                   | semgrep                            |

### Generic - finding secrets

- [semgrep](https://semgrep.dev/p/secrets)

```bash
# Install
$ pip install semgrep

# Audit : human readable
$ semgrep --quiet --metrics=off --config=p/secrets __CODE_DIRECTORY__

# Audit : json
$ semgrep --quiet --metrics=off --config=p/secrets __CODE_DIRECTORY__ --json -o /tmp/semgrep.json
# Read json report
$ cat /tmp/semgrep.json | jq .results
```

### Android (java/kotlin)

- [MobSF](https://github.com/MobSF/Mobile-Security-Framework-MobSF)

[mobsfscan](https://github.com/MobSF/mobsfscan) do only a code_analysis, manifest_analysis (android) and ats_analysis (iOS) are important too and need to be checked.

```bash
# Install
$ docker run --rm -it -p 8000:8000 opensecurity/mobile-security-framework-mobsf:latest

# Audit : human readable
# Go to http://localhost:8000/ and drag-and-drop your apk or your zipped directory

# Audit : json
$ bash wrapper/mobsf.sh http://localhost:8000 __CODE_DIRECTORY__ <directory name> /tmp/mobsf.json # __CODE_DIRECTORY__/<directory name>/src/main/AndroidManifest.xml have to exist
# Read json report
$ cat /tmp/mobsf.json | jq .code_analysis
$ cat /tmp/mobsf.json | jq .manifest_analysis # Android specific
$ cat /tmp/mobsf.json | jq .ats_analysis      # iOS specific
```

### C# / .NET

- [semgrep](https://semgrep.dev/p/csharp)

```bash
# Install
$ pip install semgrep

# Audit : human readable
$ semgrep --config=r/csharp.lang.security.sqli.csharp-sqli.csharp-sqli --config=r/csharp.lang.security.ssrf.http-client.ssrf --config=r/csharp.lang.security.ssrf.web-request.ssrf --config=r/csharp.lang.security.injections.os-command.os-command-injection --config=r/csharp.lang.security.insecure-deserialization.javascript-serializer.insecure-javascriptserializer-deserialization __CODE_DIRECTORY__

# Audit : json
$ semgrep --quiet --metrics=off --config=r/csharp.lang.security.sqli.csharp-sqli.csharp-sqli --config=r/csharp.lang.security.ssrf.http-client.ssrf --config=r/csharp.lang.security.ssrf.web-request.ssrf --config=r/csharp.lang.security.injections.os-command.os-command-injection --config=r/csharp.lang.security.insecure-deserialization.javascript-serializer.insecure-javascriptserializer-deserialization __CODE_DIRECTORY__ --json -o /tmp/semgrep.json
# Read json report
$ cat /tmp/semgrep.json | jq .results
```

### Golang

- [gosec](https://github.com/securego/gosec)

```bash
# Install
$ curl -L https://github.com/securego/gosec/releases/download/v2.13.1/gosec_2.13.1_linux_amd64.tar.gz -o /tmp/gosec.tar.gz
$ tar xvzf /tmp/gosec.tar.gz -C /tmp/ -x gosec # /tmp/gosec

# Audit : human readable
$ gosec -exclude=G301,G302,G303,G304,G305,G306,G307,G401,G402,G403,G404,G501,G502,G503,G504,G505,G601 -severity medium -confidence medium -exclude-dir vendor/ __CODE_DIRECTORY__/...

# Audit : json
$ gosec -exclude=G301,G302,G303,G304,G305,G306,G307,G401,G402,G403,G404,G501,G502,G503,G504,G505,G601 -severity medium -confidence medium -exclude-dir vendor/ -fmt json -out /tmp/gosec.json __CODE_DIRECTORY__/...
# or
$ bash wrapper/gosec.sh __CODE_DIRECTORY__ /tmp/gosec.json
# Read json report
$ cat /tmp/gosec.json | jq .Issues
```

### iOS (Objective-C/Swift)

Check Android (java/kotlin)

### Java

find-sec-bugs seems to be great, but I can't have better results than semgrep.

- [semgrep](https://semgrep.dev/p/java)

```bash
# Install
$ pip install semgrep

# Audit : human readable
$ semgrep --config=p/owasp-top-ten --include='*.java' __CODE_DIRECTORY__

# Audit : json
$ semgrep --quiet --metrics=off --config=p/owasp-top-ten --include='*.java' __CODE_DIRECTORY__ --json -o /tmp/semgrep.json
# Read json report
$ cat /tmp/semgrep.json | jq .results
```

### Javascript

- [njsscan](https://github.com/ajinabraham/njsscan)

```bash
# Install
$ pip install njsscan

# Audit : human readable
$ njsscan __CODE_DIRECTORY__

# Audit : json
$ njsscan __CODE_DIRECTORY__ -o /tmp/njsscan.json --json
# Read json report
$ cat /tmp/njsscan.json | jq .nodejs
$ cat /tmp/njsscan.json | jq .templates
```

- [semgrep](https://semgrep.dev/p/javascript)

Semgrep is a good complement for njsscan, especially for DOM exploit like postmessage abuse.

```bash
# Install
$ pip install semgrep

# Audit : human readable
$ semgrep --config=r/javascript.browser.security.insufficient-postmessage-origin-validation.insufficient-postmessage-origin-validation --config=r/javascript.lang.security.audit.incomplete-sanitization.incomplete-sanitization --config=r/javascript.browser.security.dom-based-xss.dom-based-xss --config=r/typescript.react.security.audit.react-css-injection.react-css-injection --config=r/typescript.react.security.audit.react-dangerouslysetinnerhtml.react-dangerouslysetinnerhtml --config=r/typescript.react.security.audit.react-href-var.react-href-var __CODE_DIRECTORY__

# Audit : json
$ semgrep --quiet --metrics=off --config=r/javascript.browser.security.insufficient-postmessage-origin-validation.insufficient-postmessage-origin-validation --config=r/javascript.lang.security.audit.incomplete-sanitization.incomplete-sanitization --config=r/javascript.browser.security.dom-based-xss.dom-based-xss --config=r/typescript.react.security.audit.react-css-injection.react-css-injection --config=r/typescript.react.security.audit.react-dangerouslysetinnerhtml.react-dangerouslysetinnerhtml --config=r/typescript.react.security.audit.react-href-var.react-href-var __CODE_DIRECTORY__ --json -o /tmp/semgrep.json
# or the light version
$ semgrep --quiet --metrics=off --config=r/r/javascript.aws-lambda.security.detect-child-process.detect-child-process --config=r/r/javascript.browser.security.dom-based-xss.dom-based-xss __CODE_DIRECTORY__ --json -o /tmp/semgrep.json
# Read json report
$ cat /tmp/semgrep.json | jq .results
```

### PHP

- [phpcs-security-audit](https://github.com/FloeDesignTechnologies/phpcs-security-audit.git)

```bash
# Install
$ sudo apt install composer
$ composer require --dev dealerdirect/phpcodesniffer-composer-installer -d /tmp/
$ composer require --dev pheromone/phpcs-security-audit -d /tmp/ # /tmp/vendor/bin/phpcs

# Audit : human readable
$ /tmp/vendor/bin/phpcs --standard=/tmp/vendor/pheromone/phpcs-security-audit/example_base_ruleset.xml --extensions=php __CODE_DIRECTORY__

# Audit : json
$ /tmp/vendor/bin/phpcs --standard=/tmp/vendor/pheromone/phpcs-security-audit/example_base_ruleset.xml --extensions=php --report=json --report-file=/tmp/phpcs.json __CODE_DIRECTORY__
# add "--disable-warning" to display only critical findings
# Read json report
$ cat /tmp/phpcs.json | jq .files
```

### Ruby

- [semgrep](https://semgrep.dev/p/ruby)

```bash
# Install
$ pip install semgrep

# Audit : human readable
$ semgrep --config=p/owasp-top-ten --include='*.rb' __CODE_DIRECTORY__

# Audit : json
$ semgrep --quiet --metrics=off --config=p/owasp-top-ten --include='*.rb' __CODE_DIRECTORY__ --json -o /tmp/semgrep.json
# Read json report
$ cat /tmp/semgrep.json | jq .results
```

## Software Composition Analysis (SCA)

| Programming Language   | Tools                              |
| ---------------------- | ---------------------------------- |
| android (java/kotlin)  | TODO                               |
| c# / .NET              | depscan                            |
| golang                 | nancy                              |
| ios (objective-c/swift)| TODO                               |
| java                   | depscan                            |
| javascript             | depscan                            |
| php                    | local-php-security-checker         |
| ruby                   | depscan                            |


### Android (java/kotlin)

- TODO

### C# / .NET

- [appthreat-depscan](https://github.com/AppThreat/dep-scan)

Recursion is not working well, you need to specify a directory with a pom.xml file

```bash
# Install
$ cd /tmp
$ npm install @appthreat/cdxgen
$ PATH=$PATH:/tmp/node_modules/.bin  # Cleaner to add it directly to global
$ pip install appthreat-depscan

# Audit : human readable & json
$ depscan -t .net -o /tmp/depscan.json --src __CODE_DIRECTORY__

# Read json report
$ cat /tmp/depscan-bom.json | jq .
```

### Golang

cdxgen, used by depscan, is less accurate than nancy or govulncheck.
The only issue of govulncheck is the lack of "ignore errors" run.

- [nancy](https://github.com/sonatype-nexus-community/nancy)

```bash
# Install
$ curl -L https://github.com/sonatype-nexus-community/nancy/releases/download/v1.0.41/nancy-v1.0.41-linux-amd64.tar.gz -o /tmp/nancy.tar.gz
$ tar xvzf /tmp/nancy.tar.gz -C /tmp/ -x nancy # /tmp/nancy

# Audit : human readable
$ go list -e -json -deps ./... 2>/dev/null| /tmp/nancy sleuth

# Audit : json
$ go list -e -json -deps ./... 2>/dev/null| /tmp/nancy sleuth -o json
# or
$ bash wrapper/nancy.sh __CODE_DIRECTORY__ /tmp/nancy.json
# Read json report
$ cat /tmp/nancy.json | jq .Issues
```

### iOS (Objective-C/Swift)

Check Android (java/kotlin)

### Java

- [appthreat-depscan](https://github.com/AppThreat/dep-scan)

Recursion is not working well, you need to specify a directory with a pom.xml file

```bash
# Install
$ cd /tmp
$ npm install @appthreat/cdxgen
$ PATH=$PATH:/tmp/node_modules/.bin  # Cleaner to add it directly to global
$ pip install appthreat-depscan

# Audit : human readable & json
$ depscan -t java -o /tmp/depscan.json --src __CODE_DIRECTORY__

# Read json report
$ cat /tmp/depscan-bom.json | jq .
```

### Javascript

- [appthreat-depscan](https://github.com/AppThreat/dep-scan)

Seems to work better if cdxgen is run separately

```bash
# Install
$ cd /tmp
$ npm install @appthreat/cdxgen
$ PATH=$PATH:/tmp/node_modules/.bin  # Cleaner to add it directly to global
$ pip install appthreat-depscan

# Audit : human readable & json
$ cdxgen -o /tmp/bom.json __CODE_DIRECTORY__
$ depscan --bom /tmp/bom.json -o /tmp/depscan.json

# Read json report
$ cat /tmp/depscan-bom.json | jq .
```

### PHP

cdxgen, used by depscan, is less accurate than local-php-security-checker.

- [local-php-security-checker](https://github.com/fabpot/local-php-security-checker)

```bash
# Install
$ curl -L https://github.com/fabpot/local-php-security-checker/releases/download/v2.0.5/local-php-security-checker_2.0.5_linux_amd64 -o /tmp/local-php-security-checker
$ chmod +x /tmp/local-php-security-checker

# Audit : human readable
$ /tmp/local-php-security-checker -no-dev -path=__CODE_DIRECTORY__

# Audit : json
$ /tmp/local-php-security-checker -no-dev -format=json -path=__CODE_DIRECTORY__ > /tmp/phpsca.json
# Read json report
$ cat /tmp/phpsca.json
```

### Ruby

- [appthreat-depscan](https://github.com/AppThreat/dep-scan)

```bash
# Install
$ cd /tmp
$ npm install @appthreat/cdxgen
$ PATH=$PATH:/tmp/node_modules/.bin  # Cleaner to add it directly to global
$ pip install appthreat-depscan

# Audit : human readable & json
$ depscan -t ruby -o /tmp/depscan.json --src __CODE_DIRECTORY__

# Read json report
$ cat /tmp/depscan-bom.json | jq .
```
