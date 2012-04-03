From: Remco Hosman <remco@hosman.xs4all.nl>
Subject: weekend of btrfs findings
Date: Tue, 03 Apr 2012 21:11:26 +0200
Message-ID: <4F7B4B5E.4050902@hosman.xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

hi,
after getting a USB enclosure that allowes me to access each of its 
disks as individual devices, i played around with btrfs a weekend, and 
here are some questions i hit, but could not find an answer for.

Setup: 4 disks, 2x 500gig, 2x1500gig, connected to a SATA port 
multiplier backplane to a SATA<->USB converter. PC is a i686 Celeron M, 
running 3.4.0-rc1, running the latest btrfs tools from git.

*) at first, i created the volume as raid10. i started filling it up, 
and when the 2 500gig disks where full, i got ENOSPC errors. which makes 
me wonder: what is the advantage of raid10 over raid1?

*) i added a 16gig SD card to the array

*) with `btrfs balance start -dprofile=raid1 /vol` (the syntax of the -d 
parameter is not clear in the help --full or man page). this operation 
completed quite quickly.

*) i continued to fill it, and i could put another 100gig orso on the 
volume before i hit ENOSPC again. but this time, there is plenty of 
space on the 2 1500gig disks that should be usable right?

*) i deleted the 16gig SD card from the array. when i watched this 
process with dstat, i noticed that its doing lots of writes to the 
device beeing deleted. why is this? after a while, it failed claiming 
there was not enough free space.

*) i started a rebalance, when i watched this with `btrfs balance status 
/vol` i showed that is planned to process 549 chunks, when i paused and 
resumed it, (the pause takes quite a while), it only planned to do 80 
chuncks.

If i should do more specific tests or provide specific details, please 
let me know. i have little experience in 'official' testing these kind 
of things.

Remco
