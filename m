Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:32789 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315AbaF2Tqq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 Jun 2014 15:46:46 -0400
Received: by mail-wg0-f42.google.com with SMTP id z12so7140017wgg.13
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Jun 2014 12:46:45 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>, Chris Mason <clm@fb.com>
Subject: [PATCH v2] Btrfs: fix use-after-free when cloning a trailing file hole
Date: Sun, 29 Jun 2014 21:45:40 +0100
Message-Id: <1404074740-32112-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1404071004-20724-1-git-send-email-fdmanana@gmail.com>
References: <1404071004-20724-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The transaction handle was being used after being freed.

Cc: Chris Mason <clm@fb.com>
Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: Removed file extent item argument to clone_update_extent_map() for
    more clarity.

 fs/btrfs/ioctl.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 02dc64b..2a99f49 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3142,7 +3142,6 @@ out:
 static void clone_update_extent_map(struct inode *inode,
 				    const struct btrfs_trans_handle *trans,
 				    const struct btrfs_path *path,
-				    struct btrfs_file_extent_item *fi,
 				    const u64 hole_offset,
 				    const u64 hole_len)
 {
@@ -3157,7 +3156,11 @@ static void clone_update_extent_map(struct inode *inode,
 		return;
 	}
 
-	if (fi) {
+	if (path) {
+		struct btrfs_file_extent_item *fi;
+
+		fi = btrfs_item_ptr(path->nodes[0], path->slots[0],
+				    struct btrfs_file_extent_item);
 		btrfs_extent_item_to_extent_map(inode, path, fi, false, em);
 		em->generation = -1;
 		if (btrfs_file_extent_type(path->nodes[0], fi) ==
@@ -3511,18 +3514,15 @@ process_slot:
 					    btrfs_item_ptr_offset(leaf, slot),
 					    size);
 				inode_add_bytes(inode, datal);
-				extent = btrfs_item_ptr(leaf, slot,
-						struct btrfs_file_extent_item);
 			}
 
 			/* If we have an implicit hole (NO_HOLES feature). */
 			if (drop_start < new_key.offset)
 				clone_update_extent_map(inode, trans,
-						path, NULL, drop_start,
+						NULL, drop_start,
 						new_key.offset - drop_start);
 
-			clone_update_extent_map(inode, trans, path,
-						extent, 0, 0);
+			clone_update_extent_map(inode, trans, path, 0, 0);
 
 			btrfs_mark_buffer_dirty(leaf);
 			btrfs_release_path(path);
@@ -3565,12 +3565,10 @@ process_slot:
 			btrfs_end_transaction(trans, root);
 			goto out;
 		}
+		clone_update_extent_map(inode, trans, NULL, last_dest_end,
+					destoff + len - last_dest_end);
 		ret = clone_finish_inode_update(trans, inode, destoff + len,
 						destoff, olen);
-		if (ret)
-			goto out;
-		clone_update_extent_map(inode, trans, path, NULL, last_dest_end,
-					destoff + len - last_dest_end);
 	}
 
 out:
-- 
1.9.1

