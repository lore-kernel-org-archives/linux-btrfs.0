Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:52101 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933333AbaLJVFp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 16:05:45 -0500
Received: from mail-in-05-z2.arcor-online.net (mail-in-05-z2.arcor-online.net [151.189.8.17])
	by mx.arcor.de (Postfix) with ESMTP id D5CB72D65EA
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Dec 2014 22:05:43 +0100 (CET)
From: mwilck@arcor.de
To: linux-btrfs@vger.kernel.org
Cc: mwilck@arcor.de
Subject: [PATCH 18/18] btrfs-progs: documentation for btrfs-raw and btrfs-search-metadata
Date: Wed, 10 Dec 2014 21:51:48 +0100
Message-Id: <1418244708-7087-19-git-send-email-mwilck@arcor.de>
In-Reply-To: <1418244708-7087-1-git-send-email-mwilck@arcor.de>
References: <1418244708-7087-1-git-send-email-mwilck@arcor.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Martin Wilck <mwilck@arcor.de>

Update documentation for btrfs-debug-tree, and add pages for
btrfs-search-metadata and btrfs-raw.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 Documentation/Makefile                  |    2 +
 Documentation/btrfs-debug-tree.txt      |   10 +++++
 Documentation/btrfs-raw.txt             |   54 +++++++++++++++++++++++++++++
 Documentation/btrfs-search-metadata.txt |   57 +++++++++++++++++++++++++++++++
 4 files changed, 123 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/btrfs-raw.txt
 create mode 100644 Documentation/btrfs-search-metadata.txt

diff --git a/Documentation/Makefile b/Documentation/Makefile
index ef4f1bd..354c412 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -5,6 +5,8 @@ MAN8_TXT =
 MAN8_TXT += btrfs.txt
 MAN8_TXT += btrfs-convert.txt
 MAN8_TXT += btrfs-debug-tree.txt
+MAN8_TXT += btrfs-raw.txt
+MAN8_TXT += btrfs-search-metadata.txt
 MAN8_TXT += btrfs-find-root.txt
 MAN8_TXT += btrfs-image.txt
 MAN8_TXT += btrfs-map-logical.txt
diff --git a/Documentation/btrfs-debug-tree.txt b/Documentation/btrfs-debug-tree.txt
index 23fc115..69a547d 100644
--- a/Documentation/btrfs-debug-tree.txt
+++ b/Documentation/btrfs-debug-tree.txt
@@ -25,8 +25,18 @@ Print detailed extents info.
 Print info of btrfs device and root tree dirs only.
 -r::
 Print info of roots only.
+-u::
+Print info of UUID tree only.
+-R::
+Print info of roots and root backups.
+-t <object id>::
+Only print the subvolume tree with given object ID.
+-B <backup_num>::
+Start at backup root from superblock rather than current root.
 -b <block_num>::
 Print info of the specified block only.
+-f::
+Follow (descend) the (sub)tree rooted at the block given with -b.
 
 EXIT STATUS
 -----------
diff --git a/Documentation/btrfs-raw.txt b/Documentation/btrfs-raw.txt
new file mode 100644
index 0000000..ae7bd2d
--- /dev/null
+++ b/Documentation/btrfs-raw.txt
@@ -0,0 +1,54 @@
+btrfs-raw(8)
+============
+
+NAME
+----
+btrfs-raw - low-level manipulation of btrfs meta data blocks.
+
+SYNOPSIS
+--------
+*btrfs-raw* [[-r|-w] <bytenr>] <device>
+
+DESCRIPTION
+-----------
+*btrfs-raw* is used to dump the raw contents of the given logical block
+of a btrfs device to stdout, or write raw data read from stdin to the
+given logical block.
+
+*THIS TOOL IS DANGEROUS; IT MAY CORRUPT YOUR FILESYSTEM BEYOND REPAIR!!*
+
+Please exert extreme caution when writing modified blocks to disk. You
+should make a backup copy of the entire file system before doing so, even
+if the file system is already corrupted. Make sure you have a thorough
+understanding of the btrfs disk data structures before making any changes.
+
+*YOU USE THIS TOOL AT YOUR OWN RISK!*
+
+OPTIONS
+-------
+-r <bytenr>::
+Read the logical block starting at <bytenr> and write the raw contents
+to stdout (caution, binary data).
+-w <bytenr>::
+Write the logical block starting at <bytenr> to disk, reading data from
+stdin. The tool will adjust the header checksum before writing to disk.
+
+EXIT STATUS
+-----------
+*btrfs-raw* will return 0 if no error happened.
+If any problems happened, 1 will be returned.
+
+EXAMPLE
+-------
+
+`btrfs-raw -r 874991616 /dev/sda >/tmp/blob`
+
+`btrfs-raw -w 874991616 /dev/sda </tmp/blob`
+
+Dump the data of the given block to a file and write it back.
+Between these operations, a hex editor could be used to manually fix
+inconsistencies in the meta data.
+
+SEE ALSO
+--------
+`mkfs.btrfs`(8), `btrfs-debug-tree`(8)
diff --git a/Documentation/btrfs-search-metadata.txt b/Documentation/btrfs-search-metadata.txt
new file mode 100644
index 0000000..d97295b
--- /dev/null
+++ b/Documentation/btrfs-search-metadata.txt
@@ -0,0 +1,57 @@
+btrfs-search-metadata(8)
+========================
+
+NAME
+----
+btrfs-search-metadata - search for certain nodes or leaves in btrfs metadata
+
+SYNOPSIS
+--------
+*btrfs-search-metadata* [options] <device>
+
+DESCRIPTION
+-----------
+*btrfs-search-metadata* is used to dump the meta data of a device, or to 
+selectively dump nodes or leaves matching certain conditions.
+
+Unlike `btrfs-dump-tree`, this tool will also find tree "branches" that
+are disconnected from the root tree, and previous meta data copies. If a
+corruption occurs, this may be useful for finding old, still healthy copies.
+
+This is maybe useful for analyzing filesystem state or inconsistence and has
+a positive educational effect on understanding the internal structure.
+<device> is the device file where the filesystem is stored.
+
+OPTIONS
+-------
+-k <object id>/<key type>/<offset>::
+Search for leaves and nodes containing the given key.
+-g <generation>::
+Search for leaves and nodes with the given generation (transid).
+-l <level>::
+Search for nodes with the given level, or leaves (level 0).
+-t <object id>::
+Search for leaves and nodes with the given owner object ID.
+-L::
+dump full content of found nodes or leaves, like btrfs-debug-tree.
+
+EXIT STATUS
+-----------
+*btrfs-search-metadata* will return 0 if no error happened.
+If any problems happened, 1 will be returned.
+
+EXAMPLE
+-------
+
+`btrfs-search-metadata -t 260 -l 0 -k 256/1/0 /dev/sda`
+
+Search the btrfs file system on `/dev/sda` for leaves belonging to
+subvolume 260 and containing the first inode item (type 1: inode item,
+object ID 256: first available object ID).
+
+See `ctree.h` in the btrfs source code and the btrfs Wiki for 
+assigned object IDs and key types.
+
+SEE ALSO
+--------
+`mkfs.btrfs`(8), `btrfs-debug-tree`(8)
-- 
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo
