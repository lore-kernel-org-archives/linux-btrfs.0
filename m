Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.182]:45904 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab2JPNM1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Oct 2012 09:12:27 -0400
Message-ID: <507D5D34.8070209@jan-o-sch.net>
Date: Tue, 16 Oct 2012 15:12:20 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>, Josef Bacik <josef@redhat.com>
Subject: Free space cache writeback issue
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I've hit an issue with the free space cache. It looks like we miss writing
everything to disk on unmount under rough conditions.

Setup: git head cmason/master, /dev/sdv1 is a 55MB partition on an SSD. Run the
following script:

--
DEV=/dev/sdv1
MP=/mnt/scratch

umount $MP
mkfs.btrfs -M $DEV
mount -o inode_cache $DEV $MP

cat /dev/urandom | head -c 654321 > $MP/1
mkdir $MP/2
mv $MP/1 $MP/2/1

btrfs subvol snap $MP $MP/@1
rm $MP/2/1

umount $MP
mount -o inode_cache $DEV $MP

cat /dev/urandom | head -c 654321 > $MP/tempname-1

ls -li $MP/@1/2/1 $MP/tempname-1
--

Actual result:
> 257 -rw-r--r-- 1 root root 654321 Oct 16 15:04 /mnt/scratch/@1/2/1
> 259 -rw-r--r-- 1 root root 654321 Oct 16 15:04 /mnt/scratch/tempname-1

Expected result: Both files should have inode 257.

If I make any of the following changes, I get the expected results:
- omit umount/mount from the script
- replace SSD partition by spinning disk's partition of the same size
- use 266MB partition instead of a 55MB partition (still mixed mode)
- dump 554321 bytes into file "1" instead of 654321
- dump 7654321 bytes into file "1" instead of 654321

Despite being that fragile, with the above script the results are 100%
reproducible here. I wouldn't be surprised if on a different machine one would
need different parameter fine-tuning to trigger the problem. I'm happy to test
patches :-)

-Jan
