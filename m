Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:56413 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbbASXpr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Jan 2015 18:45:47 -0500
Received: by mail-wg0-f54.google.com with SMTP id b13so4216098wgh.13
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Jan 2015 15:45:45 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 20 Jan 2015 10:45:45 +1100
Message-ID: <CA+WRLO9nCFgjHzY1F_xR5PpmgaSEemfmZ=MtiSpiaHcROQnq-A@mail.gmail.com>
Subject: btrfs convert running out of space
From: Gareth Pye <gareth@cerberos.id.au>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm attempting to convert a btrfs filesystem from raid10 to raid1.
Things had been going well through a couple of pauses and resumes, but
last night it errored with:
ERROR: error during balancing '/data' - No space left on device

Which is strange because there is around 1.4T spare on the drives.
df:
/dev/drbd0      5.5T  4.6T  1.4T  77% /data

btrfs fi df:
Data, RAID10: total=1.34TiB, used=1.34TiB
Data, RAID1: total=3.80TiB, used=3.20TiB
System, RAID1: total=32.00MiB, used=720.00KiB
Metadata, RAID1: total=13.00GiB, used=9.70GiB
GlobalReserve, single: total=512.00MiB, used=204.00KiB

btrfs fi show:
Label: none  uuid: b2986e1a-0891-4779-960c-e01f7534c6eb
        Total devices 6 FS bytes used 4.55TiB
        devid    1 size 1.81TiB used 1.72TiB path /dev/drbd0
        devid    2 size 1.81TiB used 1.72TiB path /dev/drbd1
        devid    3 size 1.81TiB used 1.72TiB path /dev/drbd2
        devid    4 size 1.81TiB used 1.72TiB path /dev/drbd3
        devid    5 size 1.81TiB used 1.72TiB path /dev/drbd4
        devid    6 size 1.81TiB used 1.72TiB path /dev/drbd5

The above numbers are from after a quick bit of testing. When the
error occured the RAID1 total number was much larger and the device
used totals were 1.81TiB. So I ran a balance with -dusage=2 and all
the numbers went back to where I expected them to be. RAID1 total of
3.21TiB and appropriate device usage numbers. With the system looking
healthy again I checked my btrfs tools version (3.12) and updated that
to the current git (3.18.1, matching my kernel version) and tried the
convert to raid1 again (this time with the dsoft option) but that
quickly got to the above 600G empty allocation, where I canceled it.

# uname -a
Linux emile 3.18.1-031801-generic #201412170637 SMP Wed Dec 17
11:38:50 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux
# btrfs --version
Btrfs v3.12

dmesg doesn't tell me much, this is the end of it:
[1295952.558506] BTRFS info (device drbd5): relocating block group
13734193922048 flags 65
[1295971.813271] BTRFS info (device drbd5): relocating block group
13716980498432 flags 65
[1295976.492826] BTRFS info (device drbd5): relocating block group
13713759272960 flags 65
[1295976.921302] BTRFS info (device drbd5): relocating block group
13710538047488 flags 65
[1295977.593500] BTRFS info (device drbd5): relocating block group
13707316822016 flags 65
[1295988.490751] BTRFS info (device drbd5): relocating block group
13704095596544 flags 65
[1295999.193131] BTRFS info (device drbd5): relocating block group
13613800620032 flags 65
[1296003.036323] BTRFS info (device drbd5): relocating block group
13578367139840 flags 65
[1296009.333859] BTRFS info (device drbd5): relocating block group
13539712434176 flags 65
[1296041.246938] BTRFS info (device drbd5): relocating block group
13513942630400 flags 65
[1296056.891600] BTRFS info (device drbd5): relocating block group
13488172826624 flags 65
[1296071.386463] BTRFS info (device drbd5): relocating block group
13472066699264 flags 65
[1296074.577288] BTRFS info (device drbd5): relocating block group
13468845473792 flags 65
[1296105.783088] BTRFS info (device drbd5): relocating block group
13465624248320 flags 65
[1296114.910226] BTRFS info (device drbd5): relocating block group
13462403022848 flags 65
[1296115.398699] BTRFS info (device drbd5): relocating block group
13459181797376 flags 65
[1296115.798719] BTRFS info (device drbd5): relocating block group
13455960571904 flags 65
[1296123.664726] BTRFS info (device drbd5): relocating block group
13452739346432 flags 65
[1296124.262510] BTRFS info (device drbd5): relocating block group
13449518120960 flags 65
[1296124.787219] BTRFS info (device drbd5): relocating block group
13446296895488 flags 65
[1296125.290209] BTRFS info (device drbd5): relocating block group
13443075670016 flags 65
[1296125.820547] BTRFS info (device drbd5): relocating block group
13439854444544 flags 65
[1296126.306939] BTRFS info (device drbd5): relocating block group
13436633219072 flags 65
[1296126.831993] BTRFS info (device drbd5): relocating block group
13433411993600 flags 65
[1296127.331577] BTRFS info (device drbd5): relocating block group
13430190768128 flags 65
[1296127.914643] BTRFS info (device drbd5): relocating block group
13426969542656 flags 65
[1296128.462360] BTRFS info (device drbd5): relocating block group
13423748317184 flags 65
[1296129.290787] BTRFS info (device drbd5): relocating block group
13420527091712 flags 65
[1296129.927392] BTRFS info (device drbd5): relocating block group
13417305866240 flags 65
[1296136.878558] BTRFS info (device drbd5): relocating block group
13414084640768 flags 65
[1296144.932052] BTRFS info (device drbd5): relocating block group
13282014396416 flags 65
[1296153.141743] BTRFS info (device drbd5): relocating block group
13222925041664 flags 65
[1296153.830643] BTRFS info (device drbd5): relocating block group
13219703816192 flags 65
[1296154.519497] BTRFS info (device drbd5): relocating block group
13216482590720 flags 65
[1296163.842627] BTRFS info (device drbd5): 203 enospc errors during balance

Before that there is just lots of not particularly different
"relocating block group" messages.

Any ideas on what is going on here?

-- 
Gareth Pye
Level 2 MTG Judge, Melbourne, Australia
"Dear God, I would like to file a bug report"
