# TEAMVB Termux Theme

Login screen + voice welcome + team banner + full green hacker-style terminal.

- Every user sets their **own username/password** on first run (stored locally on their device only, never uploaded anywhere).
- **Team name (TEAMVB), banner, and voice message stay the same** for everyone who installs this repo.
- Login prompt appears **every time Termux is restarted**.
- Prompt shows `TEAMVB >>>` and the whole terminal (text, prompt, output) is green — matrix/hacker style.
- Voice message: *"Welcome back TEAMVB servers, I hope you are fine"*

---

## 1. Required Packages (installed automatically by install.sh)

| Package | Purpose |
|---|---|
| `figlet` | ASCII art text for team banner |
| `toilet` | Extra ASCII art styles (optional) |
| `lolcat` | Rainbow/gradient coloring of text |
| `termux-api` | Lets Termux talk to the Termux:API app (for voice) |
| `grc` | Colorizes command output (ping, netstat, ps, etc.) |
| `python` | Needed for some grc/tools dependencies |

You also need to separately install the **Termux:API app** (not just the package) from:
- F-Droid: https://f-droid.org/packages/com.termux.api/
- Or Play Store: search "Termux:API"

This is required for `termux-tts-speak` (voice welcome) to work.

---

## 2. How to Install (on Termux)

```bash
pkg install git -y
git clone https://github.com/YOUR_USERNAME/termux-theme.git
cd termux-theme
bash install.sh
```

On first run, it will ask you to create your own username and password.
After that, restart Termux (close and reopen the app) — you'll see:

1. Login prompt (your own username/password)
2. Team banner (figlet + lolcat)
3. Voice welcome message
4. Colored prompt and command output

---

## 3. Customize Before Publishing to GitHub

Edit these two files and set your team name + voice message **once** —
these will be the same for every user who clones your repo:

**`banner.sh`** and **`install.sh`** (already set for you):
```bash
TEAM_NAME="TEAMVB"
VOICE_MESSAGE="Welcome back TEAMVB servers, I hope you are fine"
```

You can change the banner font by editing this line in `banner.sh`:
```bash
figlet -f slant "$TEAM_NAME"
```
Try other fonts: `standard`, `big`, `block`, `bubble`, `digital`, `banner3-D`
(list all with `figlet -l`... actually use `showfigfonts` after installing `figlet-fonts` if you want previews)

---

## 4. Reset Your Login

If you forget your password or want to change username/password:

```bash
rm ~/.termux-theme/.creds
```

Next Termux restart will ask you to set a new one.

---

## 5. Uninstall

```bash
sed -i '/termux-theme/,+3d' ~/.bashrc
rm -rf ~/.termux-theme
```

---

## File Structure

```
termux-theme/
├── install.sh     # setup script, installs packages + hooks .bashrc
├── login.sh       # per-user local login (username/password)
├── banner.sh      # team banner + voice welcome (same for all users)
├── colors.sh      # prompt + command output colors
└── README.md
```
