Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:36708 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbbKMWdY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Nov 2015 17:33:24 -0500
Received: by wmww144 with SMTP id w144so46567593wmw.1
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2015 14:33:23 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 13 Nov 2015 16:33:23 -0600
Message-ID: <CALuXmTBWN3_PLnm4uh7u1SmGA2+5_VvNou-BLtv4=+Jvjjdz1Q@mail.gmail.com>
Subject: free space is missing after dist upgrade on lzo compressed vol
From: Brenton Chapin <bzipitidoo@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I was running Lubuntu 14.04 on btrfs with lzo compresssion on, with
the following partition scheme:

sda5   232M  /boot
sda6   16G   /
sda7   104G /home

(sda5 is ext4)

I did 2 distribution upgrades, one after the other, to 15.04, then
15.10, since the upgrade utility would not go directly to the latest
version.  This process did a whole lot of reading and writing to the
root volume of course.  Everything seems to be working, except most of
the free space I had on sda6 is gone.  Was using about 4G, now df
reports that the usage is 12G.  At first, I thought Lubuntu had not
removed old files, but I can't find anything old left behind.  I began
to suspect btrfs, and checking, find that du shows only 4G used on
sda6.  Where'd the other 8G go?

"btrfs fi df /" reports the following:

Data, single: total=11.01GiB, used=10.58GiB
System, DUP: total=8.00MiB, used=16.00KiB
System, single: total=4.00MiB, used=0.00B
Metadata, DUP: total=1.00GiB, used=397.80MiB
Metadata, single: total=8.00MiB, used=0.00B
GlobalReserve, single: total=144.00MiB, used=0.00B

"btrfs filesystem show /" gives:

Label: none  uuid: 4ea4ac08-ff37-4b51-b1a3-d8b21fd43ddd
    Total devices 1 FS bytes used 10.97GiB
    devid    1 size 15.02GiB used 13.04GiB path /dev/sda6

btrfs-progs v4.0

"du --max-depth=1 -h -x" on / shows:

29M    ./etc
0    ./media
16M    ./bin
354M    ./lib
4.0K    ./lib64
0    ./mnt
160K    ./root
12M    ./sbin
0    ./srv
4.0K    ./tmp
3.1G    ./usr
442M    ./var
0    ./cdrom
3.8M    ./lib32
3.9G    .

And of course df:

/dev/sda6        16G   12G  2.5G  83% /
/dev/sda5       232M   53M  163M  25% /boot
/dev/sda7       104G   46G   57G  45% /home

And mount:

mount |grep sda
/dev/sda6 on / type btrfs
(rw,relatime,compress=lzo,space_cache,subvolid=257,subvol=/@)
/dev/sda5 on /boot type ext4 (rw,relatime,data=ordered)
/dev/sda7 on /home type btrfs
(rw,relatime,compress=lzo,space_cache,subvolid=257,subvol=/@home)

uname -a
Linux ichor 4.2.0-18-generic #22-Ubuntu SMP Fri Nov 6 18:25:50 UTC
2015 x86_64 x86_64 x86_64 GNU/Linux

I can live with the situation, but recovering that space would be nice.
-- 
http://brentonchapin.no-ip.biz
