Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:35941 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756382AbaEaNMV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 31 May 2014 09:12:21 -0400
Received: by mail-we0-f176.google.com with SMTP id q59so3104419wes.7
        for <linux-btrfs@vger.kernel.org>; Sat, 31 May 2014 06:12:20 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH v2] Btrfs: fix clone to deal with holes when NO_HOLES feature is enabled
Date: Sat, 31 May 2014 15:12:12 +0100
Message-Id: <1401545532-6317-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1401498977-11117-1-git-send-email-fdmanana@gmail.com>
References: <1401498977-11117-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If the NO_HOLES feature is enabled holes don't have file extent items in
the btree that represent them anymore. This made the clone operation
ignore the gaps that exist between consecutive file extent items and
therefore not create the holes at the destination.

A test case for xfstests follows.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: Deal with holes at the boundaries of the cloning range and that
    either overlap the boundary completely or partially.
    Test case for xfstests updated too to test these 2 cases.

 fs/btrfs/ioctl.c | 54 +++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 49 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 04ece8f..4a7a311 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2995,7 +2995,8 @@ out:
  * @destoff: Offset within @inode to start clone
  */
 static int btrfs_clone(struct inode *src, struct inode *inode,
-		       u64 off, u64 olen, u64 olen_aligned, u64 destoff)
+		       const u64 off, const u64 olen, const u64 olen_aligned,
+		       const u64 destoff)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_path *path = NULL;
@@ -3007,8 +3008,10 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
 	int slot;
 	int ret;
 	int no_quota;
-	u64 len = olen_aligned;
+	const u64 len = olen_aligned;
 	u64 last_disko = 0;
+	u64 last_dest_end = destoff;
+	bool add_trailing_hole = false;
 
 	ret = -ENOMEM;
 	buf = vmalloc(btrfs_level_size(root, 0));
@@ -3077,6 +3080,7 @@ process_slot:
 			u64 datao = 0, datal = 0;
 			u8 comp;
 			u64 endoff;
+			u64 drop_start;
 
 			extent = btrfs_item_ptr(leaf, slot,
 						struct btrfs_file_extent_item);
@@ -3106,7 +3110,20 @@ process_slot:
 				path->slots[0]++;
 				goto process_slot;
 			} else if (key.offset >= off + len) {
-				break;
+				if (last_dest_end < destoff + len) {
+					/*
+					 * We have an implicit hole (NO_HOLES
+					 * feature is enabled) that fully or
+					 * partially overlaps our cloning range
+					 * at its end.
+					 */
+					btrfs_release_path(path);
+					path->leave_spinning = 0;
+					add_trailing_hole = true;
+					goto start_trans;
+				} else {
+					break;
+				}
 			}
 
 			size = btrfs_item_size_nr(leaf, slot);
@@ -3125,6 +3142,19 @@ process_slot:
 				new_key.offset = destoff;
 
 			/*
+			 * Deal with a hole that doesn't have an extent item
+			 * that represents it (NO_HOLES feature enabled).
+			 * This hole is either in the middle of the cloning
+			 * range or at the beginning (fully overlaps it or
+			 * partially overlaps it).
+			 */
+			if (new_key.offset != last_dest_end)
+				drop_start = last_dest_end;
+			else
+				drop_start = new_key.offset;
+
+start_trans:
+			/*
 			 * 1 - adjusting old extent (we may have to split it)
 			 * 1 - add new extent
 			 * 1 - inode update
@@ -3135,6 +3165,19 @@ process_slot:
 				goto out;
 			}
 
+			if (add_trailing_hole) {
+				ret = btrfs_drop_extents(trans, root, inode,
+							 last_dest_end,
+							 destoff + len, 1);
+				if (ret && ret != -EOPNOTSUPP)
+					btrfs_abort_transaction(trans, root,
+								ret);
+				btrfs_end_transaction(trans, root);
+				if (ret)
+					goto out;
+				break;
+			}
+
 			if (type == BTRFS_FILE_EXTENT_REG ||
 			    type == BTRFS_FILE_EXTENT_PREALLOC) {
 				/*
@@ -3153,7 +3196,7 @@ process_slot:
 				}
 
 				ret = btrfs_drop_extents(trans, root, inode,
-							 new_key.offset,
+							 drop_start,
 							 new_key.offset + datal,
 							 1);
 				if (ret) {
@@ -3254,7 +3297,7 @@ process_slot:
 				aligned_end = ALIGN(new_key.offset + datal,
 						    root->sectorsize);
 				ret = btrfs_drop_extents(trans, root, inode,
-							 new_key.offset,
+							 drop_start,
 							 aligned_end,
 							 1);
 				if (ret) {
@@ -3301,6 +3344,7 @@ process_slot:
 			 * but shouldn't round up the file size
 			 */
 			endoff = new_key.offset + datal;
+			last_dest_end = endoff;
 			if (endoff > destoff+olen)
 				endoff = destoff+olen;
 			if (endoff > inode->i_size)
-- 
1.9.1

