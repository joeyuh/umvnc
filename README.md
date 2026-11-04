# umvnc

Two small scripts for getting onto U-M CAEN machines from a Linux laptop off-campus:

| Command | What it does |
|---|---|
| `umvpn` | Connects to the U-M VPN (Weblogin + Duo in a little browser window). |
| `umvnc <uniqname>` | Opens an SSH tunnel to CAEN's Linux Remote Login Service and launches a VNC viewer onto your CAEN desktop. |
| `umvnc --windows <uniqname>` | Opens CAEN's Windows remote desktop (Omnissa Horizon) instead. |

Tested on Arch Linux (Omarchy / Hyprland). Should work on other distros with the equivalent packages.

## 1. Install the dependencies

**Arch:**

```sh
sudo pacman -S openconnect tigervnc openssh xclip wl-clipboard
yay -S openconnect-sso                 # the U-M VPN login needs this, plain openconnect won't work
yay -S omnissa-horizon-client          # only if you want --windows
```

**Debian/Ubuntu/Fedora:** install `openconnect`, `tigervnc-viewer` (or `tigervnc`), `openssh-client` and, on Wayland, `xclip` + `wl-clipboard`. Install `openconnect-sso` with `pipx install openconnect-sso`. Horizon Client comes from Omnissa's download page.

`xclip`/`wl-clipboard` are optional. They just let you paste from your laptop into the VNC session on Wayland.

## 2. Install the scripts

```sh
git clone https://github.com/yaghofgm/umvnc.git
cd umvnc
./install.sh
```

That copies `umvpn` and `umvnc` into `~/.local/bin`. Make sure that's on your `PATH`.

Optional: put your uniqname in your shell config so you don't have to type it every time:

```sh
echo 'export UMICH_UNIQNAME=youruniqname' >> ~/.bashrc
```

## 3. Use it

On campus (MWireless, eduroam or wired) you can skip the VPN step.

**Terminal 1, VPN:**

```sh
umvpn
```

Log in with Weblogin + Duo in the window that pops up, then enter your sudo password. It's connected once you see `Configured as 35.7.x.x`. Leave this terminal open. Ctrl+C disconnects. The `Server certificate verify failed: signer not found` warning is harmless.

**Terminal 2, CAEN desktop:**

```sh
umvnc youruniqname
```

Enter your U-M password, approve Duo, and the CAEN Linux desktop opens in TigerVNC.

### Options

```
umvnc [--linux|--windows] [uniqname] [host]
umvpn [group]
```

- Default Linux host: `login-course.engin.umich.edu`. `oncampus-course.engin.umich.edu` has some campus-only software but **rejects VPN connections**, so it only works when you're physically on campus.
- `umvnc --windows` connects to `caen.midesktop.it.umich.edu`. Pick the "CAEN Labs" pool after logging in.
- Default VPN group: `UMVPN - Only U-M Traffic` (only U-M traffic goes through the VPN). Use `umvpn "UMVPN - All Traffic"` to send everything through it.

## Troubleshooting

- **`No SSO handler`**: you ran plain `openconnect`. Use `umvpn`, which uses `openconnect-sso`.
- **`RuntimeError: There is no current event loop`**: this is openconnect-sso on Python 3.14. `umvpn` already works around it, so make sure you're running `umvpn` and not `openconnect-sso` directly.
- **VNC says "connection refused"**: the SSH tunnel only waits 30 seconds for the viewer to attach. Just run `umvnc` again. Also check the VPN is still up (`ip a` should show a `tun` device with a 35.7.x.x address).
- **Can't paste into the VNC window (Wayland)**: install `xclip` and `wl-clipboard`. `umvnc` mirrors your clipboard into X while the viewer is open.
- **The VPN login window never shows up**: add `-l DEBUG` to the arguments at the bottom of `umvpn` to see what's going on.

## Docs

- CAEN Linux remote login how-to: https://teamdynamix.umich.edu/TDClient/76/Portal/KB/Article/5001
- CAEN remote access overview: https://caen.engin.umich.edu/?p=411
