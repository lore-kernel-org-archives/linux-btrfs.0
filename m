Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp205.alice.it ([82.57.200.101]:57587 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756047Ab3AFS2l (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 6 Jan 2013 13:28:41 -0500
Message-ID: <50E9C267.3050302@inwind.it>
Date: Sun, 06 Jan 2013 19:28:55 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: "kreijack@inwind.it" <kreijack@inwind.it>
MIME-Version: 1.0
To: util-linux@vger.kernel.org
CC: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>,
        Chris Murphy <lists@colorremedies.com>
Subject: Btrfs: wipe all the superblock [redhat bugzilla 889888]
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

ghigo@venice:/tmp$ sudo wipefs /dev/loop0 -a
8 bytes were erased at offset 0x10040 (btrfs)
they were: 5f 42 48 52 66 53 5f 4d
$ sudo btrfs filesystem  show /dev/loop0
Btrfs Btrfs v0.19

# it seems that the filesystem is disappeared 
# now zero all the 1st superblock

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


# With this patch, wipefs is able to find all the superblock:

$ sudo mkfs.btrfs -L "Btrfs-test" /dev/loop0
$ sudo ~/btrfs/util-linux/wipefs /dev/loop0 
offset               type
----------------------------------------------------------------
0x4000000040         btrfs [bak #2]   [filesystem]
                     LABEL: Btrfs-test
                     UUID:  5ca3239c-363c-4c28-b831-eac03cc5ca62

0x4000040            btrfs [bak #1]   [filesystem]
                     LABEL: Btrfs-test
                     UUID:  5ca3239c-363c-4c28-b831-eac03cc5ca62

0x10040              btrfs   [filesystem]
                     LABEL: Btrfs-test
                     UUID:  5ca3239c-363c-4c28-b831-eac03cc5ca62

ghigo@venice:/tmp$ sudo ~/btrfs/util-linux/wipefs -a /dev/loop0 
/dev/loop0: 8 bytes were erased at offset 0x00010040 (btrfs): 
	5f 42 48 52 66 53 5f 4d
/dev/loop0: 8 bytes were erased at offset 0x04000040 (btrfs [bak #1]):
	5f 42 48 52 66 53 5f 4d
/dev/loop0: 8 bytes were erased at offset 0x4000000040 (btrfs [bak #2]): 
	5f 42 48 52 66 53 5f 4d

# Now even if we zero the 1st superblock the filesystem doesn't resurrect

$ sudo dd if=/dev/zero of=/dev/loop0 bs=1 count=4k seek=64k4096+0 records in
4096+0 records out
4096 bytes (4.1 kB) copied, 0.00643427 s, 637 kB/s
$ sudo btrfs filesystem  show /dev/loop0
Btrfs Btrfs v0.19

Br 
G.Baroncelli

You can pull the change from:
	http://cassiopea.homelinux.net/git/util-linux.git
from the branch
	btrfs-wipefs

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>

------
>From 3ae972080495770205ec5da6d7a379a8d4a4d1c9 Mon Sep 17 00:00:00 2001
From: Goffredo Baroncelli <kreijack@inwind.it>
Date: Sun, 6 Jan 2013 18:47:11 +0100
Subject: [PATCH] Add support for wiping the other btrfs superblock.

Btrfs has three superblock. The first one is placed at 64KB, the
second one at 64MB, the third one at 256GB.

If the first superblock is valid except that the "magic field" is zeroed,
btrfs skips the check of the other superblocks.
If the first superblock is fully invalid, btrfs checks for the other
superblock.

So zeroing the first superblock "magic field" at the beginning seems
that the filesystem is wiped. But when the first superblock is overwritten
(e.g. by another filesystem), then the other two superblock may be considered
valid, and the filesystem may resurrect.

This patch allow to find and wipe the other btrfs superblocks signature.
---
 libblkid/src/superblocks/btrfs.c       |   32 ++++++++++++++++++++++++++++++++
 libblkid/src/superblocks/superblocks.c |    2 ++
 libblkid/src/superblocks/superblocks.h |    2 ++
 3 files changed, 36 insertions(+)

diff --git a/libblkid/src/superblocks/btrfs.c b/libblkid/src/superblocks/btrfs.c
index 039be42..d1331e6 100644
--- a/libblkid/src/superblocks/btrfs.c
+++ b/libblkid/src/superblocks/btrfs.c
@@ -91,3 +91,35 @@ const struct blkid_idinfo btrfs_idinfo =
 	}
 };
 
+const struct blkid_idinfo btrfs_idinfo1 =
+{
+	.name		= "btrfs [bak #1]",
+	.usage		= BLKID_USAGE_FILESYSTEM,
+	.probefunc	= probe_btrfs,
+	.minsz		= 64 * 1024 * 1024 + 4 * 1024,
+	.magics		=
+	{
+		{ .magic = "_BHRfS_M", 
+		  .len = 8, 
+		  .kboff = 64 * 1024, 
+		  .sboff = 0x40 },
+		{ NULL }
+	}
+};
+
+const struct blkid_idinfo btrfs_idinfo2 =
+{
+	.name		= "btrfs [bak #2]",
+	.usage		= BLKID_USAGE_FILESYSTEM,
+	.probefunc	= probe_btrfs,
+	.minsz		= 256 * 1024 * 1024 * 1024 + 4 *1024,
+	.magics		=
+	{
+		{ .magic = "_BHRfS_M", 
+		  .len = 8, 
+		  .kboff = 256 * 1024 * 1024, 
+		  .sboff = 0x40 },
+		{ NULL }
+	}
+};
+
diff --git a/libblkid/src/superblocks/superblocks.c b/libblkid/src/superblocks/superblocks.c
index 2929a5f..1e88b63 100644
--- a/libblkid/src/superblocks/superblocks.c
+++ b/libblkid/src/superblocks/superblocks.c
@@ -135,6 +135,8 @@ static const struct blkid_idinfo *idinfos[] =
 	&squashfs_idinfo,
 	&netware_idinfo,
 	&btrfs_idinfo,
+	&btrfs_idinfo1,
+	&btrfs_idinfo2,
 	&ubifs_idinfo,
 	&bfs_idinfo,
 	&vmfs_fs_idinfo,
diff --git a/libblkid/src/superblocks/superblocks.h b/libblkid/src/superblocks/superblocks.h
index 08f1438..974ff8e 100644
--- a/libblkid/src/superblocks/superblocks.h
+++ b/libblkid/src/superblocks/superblocks.h
@@ -59,6 +59,8 @@ extern const struct blkid_idinfo netware_idinfo;
 extern const struct blkid_idinfo sysv_idinfo;
 extern const struct blkid_idinfo xenix_idinfo;
 extern const struct blkid_idinfo btrfs_idinfo;
+extern const struct blkid_idinfo btrfs_idinfo1;
+extern const struct blkid_idinfo btrfs_idinfo2;
 extern const struct blkid_idinfo ubifs_idinfo;
 extern const struct blkid_idinfo zfs_idinfo;
 extern const struct blkid_idinfo bfs_idinfo;
-- 
1.7.10.4


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
