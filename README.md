# Archeesepelago-Discord-Bot

Posts Archipelago multiworld room status from [CheeseTrackers](https://cheesetrackers.theincrediblewheelofchee.se) into Discord.

---

## Quick Start

### 1. Create a Discord bot
1. Go to [discord.com/developers/applications](https://discord.com/developers/applications) → **New Application**
2. Under **Bot**: click **Reset Token** and copy your token. Enable **Server Members Intent** under Privileged Gateway Intents.
3. Under **OAuth2**: generate an invite URL with the `bot` and `applications.commands` scopes and the **View Channels** + **Send Messages** + **Embed Links** permissions, then invite the bot to your server

### 2. Get your CheeseTrackers API key
Log in at CheeseTrackers → click your profile → copy your API key.

### 3. Configure and run
Open `bot/archeesepelago.conf`, fill in the two values, then double-click `bot/run.bat`.

`run.bat` handles everything automatically on first run:
- **Node.js** — installs it via winget if not found, with a PowerShell download as fallback. A UAC prompt may appear during installation.
- **Dependencies** — runs `npm install` automatically.
- **Config** — opens `archeesepelago.conf` in Notepad for you if it hasn't been filled in yet.

> **If Node.js fails to install automatically**, install it manually from [nodejs.org](https://nodejs.org/), then double-click `run.bat` again.

---

## Commands

| Command | Who can use | Description |
|---|---|---|
| `/link <url>` | Manage Channels | Links the current channel to a CheeseTrackers room. Accepts a full URL or bare tracker ID. Re-running it in an already-linked channel updates the link. |
| `/status` | Everyone | Shows a status preview (visible only to you), with a **Post to channel** button to publish it. |
| `/help` | Everyone | Shows bot info and a link to this GitHub page. |

---

## Status format

Slots are sorted alphabetically and grouped by owner. Owners appear as Discord `@mentions` if their CT username matches a server member.

```
🏁🚀 `SlotName` — Game Name — 42/80 (53%) — Go Mode
```

| Completion | | Progression | |
|---|---|---|---|
| 🔴 Incomplete | ✅ All checks | 🟢 Unblocked | 🔒 BK |
| 🎯 Goal | 🏁 Done | 🚀 Go Mode | 🟡 Soft BK |
| 🎉 Released | | ❓ Unknown | |

---

## Notes
- Links are saved in `bot/links.json` — one entry per guild+channel pair
- Slash commands register globally on startup; Discord may take up to an hour to propagate changes to all servers
