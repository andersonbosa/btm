# btm - b00t the m4chine

![License](https://img.shields.io/badge/License-OPEN--SOURCE-brightgreen)
![Repo status](https://img.shields.io/badge/repo%20status-ACTIVE-brightgreen)
[![Contributions are welcome](https://img.shields.io/badge/contributions-WELCOME-brightgreen.svg?style=flat)](https://github.com/andersonbosa/mykro/issues)

> Automatization of some installations.
> I was tired of always installing the same things.

- A tool to speed up the setup of development environments through the installation of a series of tools chosen by the user.

<br />

#### 🫂 Contribute

- The idea is to be a script that can install [preconfigured][toolsList] tools for [any system][testedIn].

#### 📑 Tested in:

```
✅ Ubuntu 20.04.2 LTS focal
```

#### 🍴 Fork and start your own!

## How to

- Just download and run (as root) in your shell :D ~(remember, ALWAYS check the content inside a script)~.

```bash
curl -sLf https://github.com/andersonbosa/btm/raw/master/btm.sh > btm.sh # download
sudo bash btm.sh -v # run w/ verbose

# or the fastest and most insecure way:

curl -sLf https://github.com/andersonbosa/btm/raw/master/btm.sh | sudo bash -s -- -v
```

[toolsList]: https://github.com/andersonbosa/btm/blob/master/btm.sh#L20
[testedIn]: https://github.com/andersonbosa/btm#-tested-in
