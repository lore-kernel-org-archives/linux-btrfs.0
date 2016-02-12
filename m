Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:45503 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbcBLQEm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Feb 2016 11:04:42 -0500
Received: from merlin by mail1.merlins.org with local (Exim 4.80 #2)
	id 1aUGD3-0007S2-BL by authid <merlin>
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Feb 2016 08:04:41 -0800
Date: Fri, 12 Feb 2016 08:04:41 -0800
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: btrfs on top of bcache on top of dmcrypt on top of md raid5
Message-ID: <20160212160441.GH2763@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have a 5 drive md array with dmcrypt on top, and btrfs on top of that.
Kernel: 4.4 but the filesystem was created 2 years ago with an older version
of btrfs.
It's littered with files and hardlinks (it's a backup server). Mostly it
gets btrfs receive data, and rsyncs of filesystem trees that are
occasionally hardlinked to keep history (for data that wasn't on btrfs to
start with).
Basically the filesystem works, but it's slow, I can see that my system
feels sluggish when backups are running, cronjobs that are somewhat time
critical also fail to run in time when rsyncs/backups to that filesystem,
are running.

It's time to re-create it, but this time I'm looking at adding bcache in the
middle (backed by an encrypted ssd) to hopefully help with the random I/O
bits that won't be as fast on disk backed raid5.

Are there best practises in doing this?

Are there issues with the default filesystem options in btrfs?

Do I want -m dup considering it's ultimately backed by raid5/hdd and not
ssd? (I would think yes, but I've noticed -m dup gets disabled when bcache
is in the middle, probably because the detection gets foiled).

Do I want to mess with --nodesize or --sectorsize and adjust for ssd write
block size? (with ext4, I use -b 4096 -E stride=128,stripe-width=128 )

Any specific configuration I ought to do with bcache or mdadm chunk sizes?

Does align-payload look ok?
cryptsetup luksFormat --align-payload=8192 -s 256 -c aes-xts-plain

Thanks,
Marc

PS: for reference:
As discussed in the past, there seems to be a general agreement that dmcrypt
on top of mdadm is better than mdadm on top of dmcrypt now that dmcrypt is
multithreaded.
My current array and encryption look like this.

Currently, I have:
gargamel:~# mdadm --detail /dev/md8
/dev/md8:   
        Version : 1.2
  Creation Time : Sat Apr 19 23:03:59 2014
     Raid Level : raid5
     Array Size : 7813523456 (7451.56 GiB 8001.05 GB)
  Used Dev Size : 1953380864 (1862.89 GiB 2000.26 GB)
   Raid Devices : 5
  Total Devices : 5
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Thu Feb 11 08:26:45 2016
          State : active 
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 256K

gargamel:~# cryptsetup luksDump /dev/md8
LUKS header information for /dev/md8

Version:        1
Cipher name:    aes
Cipher mode:    xts-plain64
Hash spec:      sha1
Payload offset: 3072
MK bits:        256

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
