#!/bin/bash

powershell /srv/npcgrinder/NPCgrinder.ps1 \
  -OutputToHere /srv/npcgrinder/build/out.html \
  -DataFile /srv/npcgrinder/NPCgrinderData.json \
  && cat /srv/npcgrinder/build/out.html
