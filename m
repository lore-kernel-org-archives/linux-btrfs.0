Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:38592 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbcCMNYT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Mar 2016 09:24:19 -0400
Received: by mail-wm0-f43.google.com with SMTP id l68so71007675wml.1
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Mar 2016 06:24:18 -0700 (PDT)
From: Alexander Fougner <fougner89@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Alexander Fougner <fougner89@gmail.com>
Subject: [PATCH] btrfs-progs: docs: fix spelling errors
Date: Sun, 13 Mar 2016 14:24:08 +0100
Message-Id: <1457875448-6658-1-git-send-email-fougner89@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Alexander Fougner <fougner89@gmail.com>
---
 Documentation/btrfs-balance.asciidoc          |  4 ++--
 Documentation/btrfs-device.asciidoc           |  2 +-
 Documentation/btrfs-filesystem.asciidoc       | 10 +++++-----
 Documentation/btrfs-inspect-internal.asciidoc |  2 +-
 Documentation/btrfs-man5.asciidoc             |  6 +++---
 Documentation/btrfs-show-super.asciidoc       |  2 +-
 Documentation/btrfs.asciidoc                  |  2 +-
 Documentation/mkfs.btrfs.asciidoc             |  4 ++--
 8 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/Documentation/btrfs-balance.asciidoc b/Documentation/btrfs-balance.asciidoc
index c840741..1629e35 100644
--- a/Documentation/btrfs-balance.asciidoc
+++ b/Documentation/btrfs-balance.asciidoc
@@ -93,7 +93,7 @@ moving data from single to RAID1). This functionality is accessed through the
 '-d', '-m' or '-s' options to btrfs balance start, which filter on data,
 metadata and system blocks respectively.
 
-A filter has the following stucture: 'type'[='params'][,'type'=...]
+A filter has the following structure: 'type'[='params'][,'type'=...]
 
 The available types are:
 
@@ -106,7 +106,7 @@ are a list of profile names separated by "'|'" (pipe).
 Balances only block groups with usage under the given percentage. The
 value of 0 is allowed and will clean up completely unused block groups, this
 should not require any new work space allocated. You may want to use 'usage=0'
-in case balance is returnin ENOSPC and your filesystem is not too full.
+in case balance is returning ENOSPC and your filesystem is not too full.
 +
 The argument may be a single value or a range. The single value 'N' means 'at
 most N percent used', equivalent to '..N' range syntax. Kernels prior to 4.4
diff --git a/Documentation/btrfs-device.asciidoc b/Documentation/btrfs-device.asciidoc
index bd878f4..68dadc2 100644
--- a/Documentation/btrfs-device.asciidoc
+++ b/Documentation/btrfs-device.asciidoc
@@ -78,7 +78,7 @@ force overwrite of existing filesystem on the given disk(s)
 Remove device(s) from a filesystem identified by <path>.
 
 *delete* <dev>|<devid> [<dev>|<devid>...] <path>::
-Alias of remove kept for backwards compatability
+Alias of remove kept for backwards compatibility
 
 *ready* <device>::
 Check device to see if it has all of it's devices in cache for mounting.
diff --git a/Documentation/btrfs-filesystem.asciidoc b/Documentation/btrfs-filesystem.asciidoc
index 2612617..eeede37 100644
--- a/Documentation/btrfs-filesystem.asciidoc
+++ b/Documentation/btrfs-filesystem.asciidoc
@@ -39,7 +39,7 @@ GlobalReserve, single: total=512.00MiB, used=0.00B
 ------------------------------
 +
 --
-* 'Data', 'System' and 'Metadata' are separeate block group types.
+* 'Data', 'System' and 'Metadata' are separate block group types.
 'GlobalReserve' is an artificial and internal emergency space, see below.
 * 'single' -- the allocation profile, defined at mkfs time
 * 'total' -- sum of space reserved for
@@ -177,7 +177,7 @@ Show the btrfs filesystem with some additional info about devices and space
 allocation.
 +
 If no option none of 'path'/'uuid'/'device'/'label' is passed, information
-about all the BTRFS filesystems is shown, both mounted and unmounted. 
+about all the BTRFS filesystems is shown, both mounted and unmounted.
 +
 `Options`
 +
@@ -286,18 +286,18 @@ of IO load and the system may stall for a moment.
 
 *$ btrfs filesystem defrag -v -r -f dir/*
 
-Recusively defragment files under 'dir/', be verbose and wait until all blocks
+Recursively defragment files under 'dir/', be verbose and wait until all blocks
 are flushed before processing next file. You can note slower progress of the
 output and lower IO load (proportional to currently defragmented file).
 
 *$ btrfs filesystem defrag -v -r -f -clzo dir/*
 
-Recusively defragment files under 'dir/', be verbose, wait until all blocks are
+Recursively defragment files under 'dir/', be verbose, wait until all blocks are
 flushed and force file compression.
 
 *$ btrfs filesystem defrag -v -r -t 64M dir/*
 
-Recusively defragment files under 'dir/', be verbose and try to merge extents
+Recursively defragment files under 'dir/', be verbose and try to merge extents
 to be about 64MiB. As stated above, the success rate depends on actual free
 space fragmentation and the final result is not guaranteed to meet the target
 even if run repeatedly.
diff --git a/Documentation/btrfs-inspect-internal.asciidoc b/Documentation/btrfs-inspect-internal.asciidoc
index bbbbc59..3018967 100644
--- a/Documentation/btrfs-inspect-internal.asciidoc
+++ b/Documentation/btrfs-inspect-internal.asciidoc
@@ -120,7 +120,7 @@ If several '-i <super_mirror>' are given, only the last one is valid.
 Attempt to print the superblock even if no superblock magic is found.  May end
 badly.
 -s <bytenr>::::
-specifiy offset to a superblock in a non-standard location at 'bytenr', useful
+specify offset to a superblock in a non-standard location at 'bytenr', useful
 for debugging (disables the '-f' option)
 
 *subvolid-resolve* <subvolid> <path>::
diff --git a/Documentation/btrfs-man5.asciidoc b/Documentation/btrfs-man5.asciidoc
index d432391..6580866 100644
--- a/Documentation/btrfs-man5.asciidoc
+++ b/Documentation/btrfs-man5.asciidoc
@@ -35,7 +35,7 @@ Debugging option to force all block allocations above a certain
 byte threshold on each block device.  The value is specified in
 bytes, optionally with a K, M, or G suffix (case insensitive).
 +
-This option was used for testing and has not practial use, it's slated to be
+This option was used for testing and has no practical use, it's slated to be
 removed in the future.
 
 *autodefrag*::
@@ -72,7 +72,7 @@ The write flushes incur a slight hit and also prevent the IO block
 scheduler to reorder requests in more effective way. Disabling barriers gets
 rid of that penalty but will most certainly lead to a corrupted filesystem in
 case of a crash or power loss. The ordinary metadata blocks could be yet
-unwrittent at the time the new superblock is stored permanently, expecting that
+unwritten at the time the new superblock is stored permanently, expecting that
 the block pointers to metadata were stored permanently before.
 +
 On a device with a volatile battery-backed write-back cache, the 'nobarrier'
@@ -167,7 +167,7 @@ system at that point.
 Enable discarding of freed file blocks using TRIM operation.  This is useful
 for SSD devices, thinly provisioned LUNs or virtual machine images where the
 backing device understands the operation. Depending on support of the
-underlying device, the operation may severly hurt performance in case the TRIM
+underlying device, the operation may severely hurt performance in case the TRIM
 operation is synchronous (eg. with SATA devices up to revision 3.0).
 +
 If discarding is not necessary to be done at the block freeing time, there's
diff --git a/Documentation/btrfs-show-super.asciidoc b/Documentation/btrfs-show-super.asciidoc
index 8866c94..87ed578 100644
--- a/Documentation/btrfs-show-super.asciidoc
+++ b/Documentation/btrfs-show-super.asciidoc
@@ -41,7 +41,7 @@ Attempt to print the superblock even if no superblock magic is found.  May end
 badly.
 
 -s <bytenr>::
-specifiy offset to a superblock in a non-standard location at 'bytenr', useful
+specify offset to a superblock in a non-standard location at 'bytenr', useful
 for debugging (disables the '-f' option)
 
 EXIT STATUS
diff --git a/Documentation/btrfs.asciidoc b/Documentation/btrfs.asciidoc
index abf1ff8..6a77a85 100644
--- a/Documentation/btrfs.asciidoc
+++ b/Documentation/btrfs.asciidoc
@@ -15,7 +15,7 @@ The *btrfs* utility is a toolbox for managing btrfs filesystems.  There are
 command groups to work with subvolumes, devices, for whole filesystem or other
 specific actions. See section *COMMANDS*.
 
-COMMAND SYTNAX
+COMMAND SYNTAX
 --------------
 
 Any command name can be shortened as far as it stays unambiguous,
diff --git a/Documentation/mkfs.btrfs.asciidoc b/Documentation/mkfs.btrfs.asciidoc
index 6a49265..0c43a79 100644
--- a/Documentation/mkfs.btrfs.asciidoc
+++ b/Documentation/mkfs.btrfs.asciidoc
@@ -230,7 +230,7 @@ Other terms commonly used:
 *block group*::
 *chunk*::
 a logical range of space of a given profile, stores data, metadata or both;
-sometimes the terms are used interchangably
+sometimes the terms are used interchangeably
 +
 A typical size of metadata block group is 256MiB (filesystem smaller than
 50GiB) and 1GiB (larger than 50GiB), for data it's 1GiB. The system block group
@@ -274,7 +274,7 @@ the logical blocks to 2 physical locations. Whether there are really 2
 physical copies highly depends on the underlying device type.
 
 For example, a SSD drive can remap the blocks internally to a single copy thus
-deduplicating them. This negates the purpose of increased redunancy and just
+deduplicating them. This negates the purpose of increased redundancy and just
 wastes space.
 
 The duplicated data/metadata may still be useful to statistically improve the
-- 
2.7.3

