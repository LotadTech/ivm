# ivm — Istio Version Manager

[![istio](https://img.shields.io/badge/istio-compatible-466BB0?logo=istio&logoColor=white)](https://istio.io)
[![AI Assisted](https://img.shields.io/badge/AI-assisted-8A2BE2?logo=githubcopilot&logoColor=white)](https://github.com/features/copilot)

A tool to seamlessly install and switch between multiple `istioctl` versions.

## Install ivm

```sh
sudo ln -sf ~/ivm/ivm.sh /usr/local/bin/ivm
```

## Usage

```sh
ivm install <version>    # Install a version
ivm use <version>        # Switch to a version
ivm current              # Show active version
ivm list                 # List installed versions
ivm list-remote [n]      # List available versions (default: 20)
ivm uninstall <version>  # Remove a version
```

## Add istioctl to PATH

After running `ivm use <version>`, add `~/.ivm/bin` to your PATH.

**bash:**
```sh
echo 'export PATH="$HOME/.ivm/bin:$PATH"' >> ~/.bashrc && source ~/.bashrc
```

**zsh:**
```sh
echo 'export PATH="$HOME/.ivm/bin:$PATH"' >> ~/.zshrc && source ~/.zshrc
```

Then use `istioctl` from anywhere.

## License

See [LICENSE](./LICENSE).
