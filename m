From: Jan Engelhardt <jengelh@medozas.de>
Subject: To loop or not to loop with btrfs
Date: Wed, 18 Nov 2009 22:31:53 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0911182229500.32206@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,


This left me puzzled for a while:

22:29 borg:/ # losetup /dev/loop1 /.B.disk
22:29 borg:/ # mount /dev/loop1 /B
mount: /dev/loop1: can't read superblock
22:29 borg:/ # blkid /dev/loop1
/dev/loop1: UUID="e19fe89b-cde3-4ccc-bc70-b759a57bd1c9"
UUID_SUB="f29c6218-d040-4546-a227-4dd2d2142817" TYPE="btrfs" 
22:29 borg:/ # losetup -d /dev/loop1
22:29 borg:/ # losetup /dev/loop2 /.B.disk 
22:29 borg:/ # mount /dev/loop2 /B
(success)

So the btrfs volume is tied to loop2? That certainly is not good.
Even real disks (/dev/sd*) can move around, the more so USB flash
gadgets and loop devices.
