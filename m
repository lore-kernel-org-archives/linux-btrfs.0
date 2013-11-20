Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55612 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609Ab3KTOGM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Nov 2013 09:06:12 -0500
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: chris.mason@fusionio.com, David Sterba <dsterba@suse.cz>,
        linux-doc@vger.kernel.org
Subject: [PATCH 2/2] Documentation: filesystems: update btrfs tools section
Date: Wed, 20 Nov 2013 15:06:08 +0100
Message-Id: <1384956368-18889-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The tools mentioned have been obsoleted long ago, replace
with the current ones.

CC: linux-doc@vger.kernel.org
Signed-off-by: David Sterba <dsterba@suse.cz>
---
 Documentation/filesystems/btrfs.txt | 22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/Documentation/filesystems/btrfs.txt b/Documentation/filesystems/btrfs.txt
index 3744ec373db9..52f34cb56384 100644
--- a/Documentation/filesystems/btrfs.txt
+++ b/Documentation/filesystems/btrfs.txt
@@ -244,24 +244,14 @@ available from the git repository at the following location:
 
 These include the following tools:
 
-mkfs.btrfs: create a filesystem
+* mkfs.btrfs: create a filesystem
 
-btrfsctl: control program to create snapshots and subvolumes:
+* btrfs: a single tool to manage the filesystems, refer to the manpage for more details
 
-	mount /dev/sda2 /mnt
-	btrfsctl -s new_subvol_name /mnt
-	btrfsctl -s snapshot_of_default /mnt/default
-	btrfsctl -s snapshot_of_new_subvol /mnt/new_subvol_name
-	btrfsctl -s snapshot_of_a_snapshot /mnt/snapshot_of_new_subvol
-	ls /mnt
-	default snapshot_of_a_snapshot snapshot_of_new_subvol
-	new_subvol_name snapshot_of_default
+* 'btrfsck' or 'btrfs check': do a consistency check of the filesystem
 
-	Snapshots and subvolumes cannot be deleted right now, but you can
-	rm -rf all the files and directories inside them.
+Other tools for specific tasks:
 
-btrfsck: do a limited check of the FS extent trees.
+* btrfs-convert: in-place conversion from ext2/3/4 filesystems
 
-btrfs-debug-tree: print all of the FS metadata in text form.  Example:
-
-	btrfs-debug-tree /dev/sda2 >& big_output_file
+* btrfs-image: dump filesystem metadata for debugging
-- 
1.8.4.2

