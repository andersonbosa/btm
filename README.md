# btm - b00t the m4chine

> Automatization of some installations.
> I was tired of always installing the same things.

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
