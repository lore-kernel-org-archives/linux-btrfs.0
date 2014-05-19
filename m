Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35099 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932424AbaESQUC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 May 2014 12:20:02 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 26CF2AC77
	for <linux-btrfs@vger.kernel.org>; Mon, 19 May 2014 16:20:01 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 2/5] btrfs-progs: doc: remove text for unmerged features
Date: Mon, 19 May 2014 18:20:00 +0200
Message-Id: <7f7c13f48696e1d26765f43b37711968837ffc5b.1400515868.git.dsterba@suse.cz>
In-Reply-To: <cover.1400515867.git.dsterba@suse.cz>
References: <cover.1400515867.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The asciidoc conversion was done on a development branch and there are
portions of text that do not reflect the code.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 Documentation/btrfs-device.txt     |  5 -----
 Documentation/btrfs-filesystem.txt | 46 +-------------------------------------
 2 files changed, 1 insertion(+), 50 deletions(-)

diff --git a/Documentation/btrfs-device.txt b/Documentation/btrfs-device.txt
index 7a6bce5c650a..9cd8ad081a5a 100644
--- a/Documentation/btrfs-device.txt
+++ b/Documentation/btrfs-device.txt
@@ -86,11 +86,6 @@ filesystem as listed by blkid.
 Finally, if '--all-devices' or '-d' is passed, all the devices under /dev are 
 scanned.
 
-'disk-usage' [-b] <path> [<path>..]::
-Show which chunks are in a device.
-+
-If '-b' is given, byte will be set as unit.
-
 'ready' <device>::
 Check device to see if it has all of it's devices in cache for mounting.
 
diff --git a/Documentation/btrfs-filesystem.txt b/Documentation/btrfs-filesystem.txt
index 4ac8711f62c0..63e3ef676cd3 100644
--- a/Documentation/btrfs-filesystem.txt
+++ b/Documentation/btrfs-filesystem.txt
@@ -17,47 +17,8 @@ resizing, defragment.
 
 SUBCOMMAND
 ----------
-'df' [-b] <path> [<path>...]::
+'df' <path> [<path>...]::
 Show space usage information for a mount point.
-+
-If '-b' is given, then byte is used as unit. Default unit will be
-human-readable unit such as KiB/MiB/GiB.
-+
-The command 'btrfs filesystem df' is used to query how many space on the 
-disk(s) are used and an estimation of the free
-space of the filesystem.
-The output of the command 'btrfs filesystem df' shows:
-
-`Disk size`::::
-the total size of the disks which compose the filesystem.
-
-`Disk allocated`::::
-the size of the area of the disks used by the chunks.
-
-`Disk unallocated`::::
-the size of the area of the disks which is free (i.e.
-the differences of the values above).
-
-`Used`::::
-the portion of the logical space used by the file and metadata.
-
-`Free (estimated)`::::
-the estimated free space available: i.e. how many space can be used
-by the user. The evaluation cannot be rigorous because it depends by the
-allocation policy (DUP, Single, RAID1...) of the metadata and data chunks. +
-If every chunk is stored as "Single" the sum of the free (estimated) space
-and the used space  is equal to the disk size.
-Otherwise if all the chunk are mirrored (raid1 or raid10) or duplicated
-the sum of the free (estimated) space and the used space is
-half of the disk size. Normally the free (estimated) is between
-these two limits.
-
-`Data to disk ratio`::::
-the ratio betwen the logical size (i.e. the space available by
-the chunks) and the disk allocated (by the chunks). Normally it is 
-lower than 100% because the metadata is duplicated for security reasons.
-If all the data and metadata are duplicated (or have a profile like RAID1)
-the Data to disk ratio could be 50%.
 
 'show' [--mounted|--all-devices|<path>|<uuid>|<device>|<label>]::
 Show the btrfs filesystem with some additional info.
@@ -140,11 +101,6 @@ Show or update the label of a filesystem.
 If a newlabel optional argument is passed, the label is changed.
 NOTE: the maximum allowable length shall be less than 256 chars
 
-'disk-usage' [-tb] path [path...]::
-Show in which disk the chunks are allocated. +
-If '-b' is given,  set byte as unit;
-If '-t' is given, show data in tabular format.
-
 EXIT STATUS
 -----------
 'btrfs filesystem' returns a zero exist status if it succeeds. Non zero is
-- 
1.9.0

