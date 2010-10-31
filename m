From: "Helmut Hullen" <Hullen@t-online.de>
Subject: database for device scan
Date: 31 Oct 2010 15:18:00 +0100
Message-ID: <BZur8RLD1uB@helmut.hullen.de>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, linux-btrfs,

I've used for some days btrfs-progs-20100717, now I'm using "btrfs- 
progs-201030" (built with the "SlackBuild" script for slackware).

Works fine, but the actual version works in another way than the  
previous when I say

        mkfs.btrfs /dev/sdb1

(or how the device may be named).
The previous version finished its work within some seconds, the actual  
version first tests all block devices in "/dev".

If I'd run "udev" that may be no big problem. But I prefer not using  
"udev", I prefer working with static device entries, and that leads to  
many entries for devices which really don't exist. And "scan" scans all  
of them.

Maybe it's a better idea not to use "/dev" as database, using "proc/ 
partitions" may be the better way.

Viele Gruesse!
Helmut
