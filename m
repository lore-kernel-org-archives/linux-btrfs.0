Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:48392 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756654AbaEaXuz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 31 May 2014 19:50:55 -0400
Received: by mail-wg0-f44.google.com with SMTP id a1so3495881wgh.3
        for <linux-btrfs@vger.kernel.org>; Sat, 31 May 2014 16:50:53 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH v4] Btrfs: fix clone to deal with holes when NO_HOLES feature is enabled
Date: Sun,  1 Jun 2014 01:50:28 +0100
Message-Id: <1401583828-9230-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1401498977-11117-1-git-send-email-fdmanana@gmail.com>
References: <1401498977-11117-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If the NO_HOLES feature is enabled holes don't have file extent items in
the btree that represent them anymore. This made the clone operation
ignore the gaps that exist between consecutive file extent items and
therefore not create the holes at the destination. When not using the
NO_HOLES feature, the holes were created at the destination.

A test case for xfstests follows.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: Deal with holes at the boundaries of the cloning range and that
    either overlap the boundary completely or partially.
    Test case for xfstests updated too to test these 2 cases.

V3: Deal with the case where the cloning range overlaps (partially or
    completely) a hole at the end of the source file, and might increase
    the size of the target file.
    Updated the test for xfstests to cover these cases too.

V4: Moved some duplicated code into an helper function.

 fs/btrfs/ioctl.c | 108 ++++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 83 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 04ece8f..95194a9 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2983,6 +2983,37 @@ out:
 	return ret;
 }
 
+static int clone_finish_inode_update(struct btrfs_trans_handle *trans,
+				     struct inode *inode,
+				     u64 endoff,
+				     const u64 destoff,
+				     const u64 olen)
+{
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	int ret;
+
+	inode_inc_iversion(inode);
+	inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+	/*
+	 * We round up to the block size at eof when determining which
+	 * extents to clone above, but shouldn't round up the file size.
+	 */
+	if (endoff > destoff + olen)
+		endoff = destoff + olen;
+	if (endoff > inode->i_size)
+		btrfs_i_size_write(inode, endoff);
+
+	ret = btrfs_update_inode(trans, root, inode);
+	if (ret) {
+		btrfs_abort_transaction(trans, root, ret);
+		btrfs_end_transaction(trans, root);
+		goto out;
+	}
+	ret = btrfs_end_transaction(trans, root);
+out:
+	return ret;
+}
+
 /**
  * btrfs_clone() - clone a range from inode file to another
  *
@@ -2995,7 +3026,8 @@ out:
  * @destoff: Offset within @inode to start clone
  */
 static int btrfs_clone(struct inode *src, struct inode *inode,
-		       u64 off, u64 olen, u64 olen_aligned, u64 destoff)
+		       const u64 off, const u64 olen, const u64 olen_aligned,
+		       const u64 destoff)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_path *path = NULL;
@@ -3007,8 +3039,9 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
 	int slot;
 	int ret;
 	int no_quota;
-	u64 len = olen_aligned;
+	const u64 len = olen_aligned;
 	u64 last_disko = 0;
+	u64 last_dest_end = destoff;
 
 	ret = -ENOMEM;
 	buf = vmalloc(btrfs_level_size(root, 0));
@@ -3076,7 +3109,7 @@ process_slot:
 			u64 disko = 0, diskl = 0;
 			u64 datao = 0, datal = 0;
 			u8 comp;
-			u64 endoff;
+			u64 drop_start;
 
 			extent = btrfs_item_ptr(leaf, slot,
 						struct btrfs_file_extent_item);
@@ -3125,6 +3158,18 @@ process_slot:
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
+			/*
 			 * 1 - adjusting old extent (we may have to split it)
 			 * 1 - add new extent
 			 * 1 - inode update
@@ -3153,7 +3198,7 @@ process_slot:
 				}
 
 				ret = btrfs_drop_extents(trans, root, inode,
-							 new_key.offset,
+							 drop_start,
 							 new_key.offset + datal,
 							 1);
 				if (ret) {
@@ -3254,7 +3299,7 @@ process_slot:
 				aligned_end = ALIGN(new_key.offset + datal,
 						    root->sectorsize);
 				ret = btrfs_drop_extents(trans, root, inode,
-							 new_key.offset,
+							 drop_start,
 							 aligned_end,
 							 1);
 				if (ret) {
@@ -3292,27 +3337,12 @@ process_slot:
 			btrfs_mark_buffer_dirty(leaf);
 			btrfs_release_path(path);
 
-			inode_inc_iversion(inode);
-			inode->i_mtime = inode->i_ctime = CURRENT_TIME;
-
-			/*
-			 * we round up to the block size at eof when
-			 * determining which extents to clone above,
-			 * but shouldn't round up the file size
-			 */
-			endoff = new_key.offset + datal;
-			if (endoff > destoff+olen)
-				endoff = destoff+olen;
-			if (endoff > inode->i_size)
-				btrfs_i_size_write(inode, endoff);
-
-			ret = btrfs_update_inode(trans, root, inode);
-			if (ret) {
-				btrfs_abort_transaction(trans, root, ret);
-				btrfs_end_transaction(trans, root);
+			last_dest_end = new_key.offset + datal;
+			ret = clone_finish_inode_update(trans, inode,
+							last_dest_end,
+							destoff, olen);
+			if (ret)
 				goto out;
-			}
-			ret = btrfs_end_transaction(trans, root);
 			if (new_key.offset + datal >= destoff + len)
 				break;
 		}
@@ -3321,6 +3351,34 @@ process_slot:
 	}
 	ret = 0;
 
+	if (last_dest_end < destoff + len) {
+		/*
+		 * We have an implicit hole (NO_HOLES feature is enabled) that
+		 * fully or partially overlaps our cloning range at its end.
+		 */
+		btrfs_release_path(path);
+
+		/*
+		 * 1 - remove extent(s)
+		 * 1 - inode update
+		 */
+		trans = btrfs_start_transaction(root, 2);
+		if (IS_ERR(trans)) {
+			ret = PTR_ERR(trans);
+			goto out;
+		}
+		ret = btrfs_drop_extents(trans, root, inode,
+					 last_dest_end, destoff + len, 1);
+		if (ret) {
+			if (ret != -EOPNOTSUPP)
+				btrfs_abort_transaction(trans, root, ret);
+			btrfs_end_transaction(trans, root);
+			goto out;
+		}
+		ret = clone_finish_inode_update(trans, inode, destoff + len,
+						destoff, olen);
+	}
+
 out:
 	btrfs_free_path(path);
 	vfree(buf);
-- 
1.9.1

