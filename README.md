# npcgrinder
Generates generic townsfolk-style NPCs for Dungeons and Dragons 5th Edition

# Usability Stuff
This was written in Powershell. You will need Powershell on your machine to make it run.

invoke with the following command arguments
* `-OutputToHere <path>`
* `-DataFile <path>`

This script will output the character in HTML.

I figured everyone has a browser, so that's a pretty universal format.

Future versions will probably have other outputs.

There may or may not be future versions.

It doesn't use anything fancy, it's just a handful of data arranged with DIVs.

## Docker Usage

To use with docker. First install docker and then...

```
make build
make run
```

output will be in **build/out.html**.

```
make out
```

Can be used to view the output.

# Purpose Stuff
The purpose of this script is to make generating random townsfolk NPCs easier for the DM.

I typically keep ten of them printed out and ready to go for an adventure.

The players walk into a bar? BAM! Ready to go NPC.

The players meet a shopkeep? BAM! Ready to go NPC.

The players meet a farmer? BAM! Ready to go NPC.

You can always create these people off-the-cuff, but with this you'll have ready-made personality quirks, loot, stats in case of checks or contests, and all sorts of other fun!

Use an NPC or modify on the fly - it's totally up to you!

