From: Danilo Reinhardt <danilo.reinhardt@gmx.net>
Subject: Recover from drive failure on raid10
Date: Wed, 24 Nov 2010 11:58:49 +0100
Message-ID: <1290596329.4834.80.camel@danilo-r-pc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

i played a little bit with btrfs and raid levels, but now i stuck on
recovering if the first disc is missing.

First i tried removing the second disc -> works!

# mkfs.btrfs -m raid1 -d raid1 /dev/sdb /dev/sdc
# mount /dev/sdb /mnt
- copy some data
- shutdown, remove /dev/sdb, add a empty /dev/sdb, reboot
# btrfs device scan
# mount -o degraded /dev/sdb
# btrfs device add /dev/sdc
# umount /mnt
# mount /dev/sdb /mnt -> EVERYTHING OK AGAIN

But now i removed the first (sdb) device. And the steps above dont work 
anymore. 

If i try to:
# btrfs device scan (found my raid array)
# mount -o degraded /dev/sdb 
mount asked to specify the filesystem type, this was expected because
sbd is empty. Now try with sdc
# mount -o degraded /dev/sdc
and i got a bad superblock message.

What should i do now?

Thanks!
Nino

