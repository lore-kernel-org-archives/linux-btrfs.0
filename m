Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:52531 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934638AbaEaAQc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 May 2014 20:16:32 -0400
Received: by mail-wi0-f173.google.com with SMTP id bs8so1975194wib.12
        for <linux-btrfs@vger.kernel.org>; Fri, 30 May 2014 17:16:31 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: fix clone to deal with holes when NO_HOLES feature is enabled
Date: Sat, 31 May 2014 02:16:17 +0100
Message-Id: <1401498977-11117-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If the NO_HOLES feature is enabled holes don't have file extent items in
the btree that represent them anymore. This made the clone operation
ignore the gaps that exist between consecutive file extent items and
therefore not create the holes at the destination.

A test case for xfstests follows.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/ioctl.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index ecf56af..bf34b7a 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3009,6 +3009,7 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
 	int no_quota;
 	u64 len = olen_aligned;
 	u64 last_disko = 0;
+	u64 last_dest_end = (u64)-1;
 
 	ret = -ENOMEM;
 	buf = vmalloc(btrfs_level_size(root, 0));
@@ -3077,6 +3078,7 @@ process_slot:
 			u64 datao = 0, datal = 0;
 			u8 comp;
 			u64 endoff;
+			u64 drop_start;
 
 			extent = btrfs_item_ptr(leaf, slot,
 						struct btrfs_file_extent_item);
@@ -3125,6 +3127,16 @@ process_slot:
 				new_key.offset = destoff;
 
 			/*
+			 * Deal with a hole that doesn't have an extent item
+			 * that represents it (NO_HOLES feature enabled).
+			 */
+			if (last_dest_end != (u64)-1 &&
+			    new_key.offset != last_dest_end)
+				drop_start = last_dest_end;
+			else
+				drop_start = new_key.offset;
+
+			/*
 			 * 1 - adjusting old extent (we may have to split it)
 			 * 1 - add new extent
 			 * 1 - inode update
@@ -3153,7 +3165,7 @@ process_slot:
 				}
 
 				ret = btrfs_drop_extents(trans, root, inode,
-							 new_key.offset,
+							 drop_start,
 							 new_key.offset + datal,
 							 1);
 				if (ret) {
@@ -3254,7 +3266,7 @@ process_slot:
 				aligned_end = ALIGN(new_key.offset + datal,
 						    root->sectorsize);
 				ret = btrfs_drop_extents(trans, root, inode,
-							 new_key.offset,
+							 drop_start,
 							 aligned_end,
 							 1);
 				if (ret) {
@@ -3301,6 +3313,7 @@ process_slot:
 			 * but shouldn't round up the file size
 			 */
 			endoff = new_key.offset + datal;
+			last_dest_end = endoff;
 			if (endoff > destoff+olen)
 				endoff = destoff+olen;
 			if (endoff > inode->i_size)
-- 
1.9.1

