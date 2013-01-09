Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp205.alice.it ([82.57.200.101]:50839 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933663Ab3AIVO1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Jan 2013 16:14:27 -0500
Message-ID: <50EDDDC3.10407@inwind.it>
Date: Wed, 09 Jan 2013 22:14:43 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: util-linux@vger.kernel.org
CC: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>,
        Chris Murphy <lists@colorremedies.com>
Subject: [PATCH][v2] Btrfs: wipe all the superblock [redhat bugzilla 889888]
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

Currently wipefs doesn't clear all the superblock of btrfs. Only the first 
one is cleared.

Btrfs has three superblocks. The first one is placed at 64KB, the second 
one at 64MB, the third one at 256GB.

If the first superblock is valid except that the "magic field" is zeroed,
btrfs skips the check of the other superblocks.
If the first superblock is fully invalid, btrfs checks for the other
superblock.

So zeroing the first superblock "magic field" at the beginning seems
that the filesystem is wiped. But when the first superblock is overwritten
(e.g. by another filesystem), then the other two superblocks may be considered
valid, and the filesystem may resurrect.


# make a filesystem, wipe it and check if it disappears

$ sudo mkfs.btrfs -L "Btrfs-test" /dev/loop0
$ sudo btrfs filesystem  show /dev/loop0
Label: 'Btrfs-test'  uuid: 3156cef7-8522-411f-876a-ba8ec32cc781
	Total devices 1 FS bytes used 28.00KB
	devid    1 size 4.00TB used 2.04GB path /dev/loop0

Btrfs Btrfs v0.19
$ sudo wipefs /dev/loop0
offset               type
----------------------------------------------------------------
0x10040              btrfs   [filesystem]
                     LABEL: Btrfs-test
                     UUID:  3156cef7-8522-411f-876a-ba8ec32cc781

$ sudo wipefs /dev/loop0 -a
8 bytes were erased at offset 0x10040 (btrfs)
they were: 5f 42 48 52 66 53 5f 4d
$ sudo btrfs filesystem  show /dev/loop0
Btrfs Btrfs v0.19

# it seems that the filesystem is disappeared # now zero all the 1st superblock

$ sudo dd if=/dev/zero of=/dev/loop0 bs=1 count=4k seek=64k
4096+0 records in
4096+0 records out
4096 bytes (4.1 kB) copied, 0.00659795 s, 621 kB/s

# check if the filesystem is resurrected
$ sudo btrfs filesystem  show /dev/loop0
failed to read /dev/sr0
Label: 'Btrfs-test'  uuid: 3156cef7-8522-411f-876a-ba8ec32cc781
	Total devices 1 FS bytes used 28.00KB
	devid    1 size 4.00TB used 2.04GB path /dev/loop0

Btrfs Btrfs v0.19

# it is !!!


# With this patch, wipefs is able to wipe all the superblock:

$ sudo mkfs.btrfs -L "Btrfs-test" /dev/loop0
$ sudo ~/btrfs/util-linux/wipefs /dev/loop0 offset               type
----------------------------------------------------------------
0x10040              btrfs   [filesystem]
                     LABEL: Btrfs-test
                     UUID:  5ca3239c-363c-4c28-b831-eac03cc5ca62

$ sudo ~/btrfs/util-linux/wipefs -a /dev/loop0 
/dev/loop0: 8 bytes were erased at offset 0x00010040 (btrfs): 	5f 42 48 52 66 53 5f 4d
/dev/loop0: 8 bytes were erased at offset 0x04000040 (btrfs):	5f 42 48 52 66 53 5f 4d
/dev/loop0: 8 bytes were erased at offset 0x4000000040 (btrfs): 5f 42 48 52 66 53 5f 4d

# Now even if we zero the 1st superblock, the filesystem doesn't resurrect

$ sudo dd if=/dev/zero of=/dev/loop0 bs=1 count=4k seek=64k4096+0 records in
4096+0 records out
4096 bytes (4.1 kB) copied, 0.00643427 s, 637 kB/s
$ sudo btrfs filesystem  show /dev/loop0
Btrfs Btrfs v0.19
$

Br 
G.Baroncelli

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>

ChangeLog

V1 -> V2	Removed the three different superblock and put
		all the info in the same array (Thanks to Karel Zak
		for the suggestion)
		

------

Btrfs has three superblock. The first one is placed at 64KB, the
second one at 64MB, the third one at 256GB.

If the first superblock is valid except that the "magic field" is zeroed,
btrfs skips the check of the other superblocks.
If the first superblock is fully invalid, btrfs checks for the other
superblock.

So zeroing the first superblock "magic field" at the beginning seems
that the filesystem is wiped. But when the first superblock is overwritten
(eg by another filesystem), then the other two superblock may be considered
valid, and the filesystem may resurrect.

This patch allow to find and wipe the other btrfs superblocks signature.
---
 libblkid/src/superblocks/btrfs.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/libblkid/src/superblocks/btrfs.c b/libblkid/src/superblocks/btrfs.c
index 039be42..cb5004f 100644
--- a/libblkid/src/superblocks/btrfs.c
+++ b/libblkid/src/superblocks/btrfs.c
@@ -87,6 +87,14 @@ const struct blkid_idinfo btrfs_idinfo =
 	.magics		=
 	{
 		{ .magic = "_BHRfS_M", .len = 8, .kboff = 64, .sboff = 0x40 },
+		{ .magic = "_BHRfS_M", 
+		  .len = 8, 
+		  .kboff = 64 * 1024, 
+		  .sboff = 0x40 },
+		{ .magic = "_BHRfS_M", 
+		  .len = 8, 
+		  .kboff = 256 * 1024 * 1024, 
+		  .sboff = 0x40 },
 		{ NULL }
 	}
 };
-- 
1.7.10.4 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
