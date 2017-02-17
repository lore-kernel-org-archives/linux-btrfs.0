Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:33871 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934552AbdBQOoW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 09:44:22 -0500
Received: by mail-wr0-f194.google.com with SMTP id c4so5517532wrd.1
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Feb 2017 06:44:22 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 35/38] btrfs: Make clone_update_extent_map take btrfs_inode
Date: Fri, 17 Feb 2017 16:43:26 +0200
Message-Id: <1487342609-20652-36-git-send-email-nborisov@suse.com>
In-Reply-To: <1487342609-20652-1-git-send-email-nborisov@suse.com>
References: <1487342609-20652-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ioctl.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index f907853e1c47..cdbf30e5743b 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3301,20 +3301,19 @@ static int clone_finish_inode_update(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-static void clone_update_extent_map(struct inode *inode,
+static void clone_update_extent_map(struct btrfs_inode *inode,
 				    const struct btrfs_trans_handle *trans,
 				    const struct btrfs_path *path,
 				    const u64 hole_offset,
 				    const u64 hole_len)
 {
-	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
+	struct extent_map_tree *em_tree = &inode->extent_tree;
 	struct extent_map *em;
 	int ret;
 
 	em = alloc_extent_map();
 	if (!em) {
-		set_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
-			&BTRFS_I(inode)->runtime_flags);
+		set_bit(BTRFS_INODE_NEEDS_FULL_SYNC, &inode->runtime_flags);
 		return;
 	}
 
@@ -3323,12 +3322,11 @@ static void clone_update_extent_map(struct inode *inode,
 
 		fi = btrfs_item_ptr(path->nodes[0], path->slots[0],
 				    struct btrfs_file_extent_item);
-		btrfs_extent_item_to_extent_map(BTRFS_I(inode), path, fi, false, em);
+		btrfs_extent_item_to_extent_map(inode, path, fi, false, em);
 		em->generation = -1;
 		if (btrfs_file_extent_type(path->nodes[0], fi) ==
 		    BTRFS_FILE_EXTENT_INLINE)
-			set_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
-				&BTRFS_I(inode)->runtime_flags);
+			set_bit(BTRFS_INODE_NEEDS_FULL_SYNC, &inode->runtime_flags);
 	} else {
 		em->start = hole_offset;
 		em->len = hole_len;
@@ -3349,13 +3347,12 @@ static void clone_update_extent_map(struct inode *inode,
 			free_extent_map(em);
 			break;
 		}
-		btrfs_drop_extent_cache(BTRFS_I(inode), em->start,
+		btrfs_drop_extent_cache(inode, em->start,
 					em->start + em->len - 1, 0);
 	}
 
 	if (ret)
-		set_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
-			&BTRFS_I(inode)->runtime_flags);
+		set_bit(BTRFS_INODE_NEEDS_FULL_SYNC, &inode->runtime_flags);
 }
 
 /*
@@ -3781,11 +3778,11 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
 
 			/* If we have an implicit hole (NO_HOLES feature). */
 			if (drop_start < new_key.offset)
-				clone_update_extent_map(inode, trans,
+				clone_update_extent_map(BTRFS_I(inode), trans,
 						NULL, drop_start,
 						new_key.offset - drop_start);
 
-			clone_update_extent_map(inode, trans, path, 0, 0);
+			clone_update_extent_map(BTRFS_I(inode), trans, path, 0, 0);
 
 			btrfs_mark_buffer_dirty(leaf);
 			btrfs_release_path(path);
@@ -3835,7 +3832,7 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
 			btrfs_end_transaction(trans);
 			goto out;
 		}
-		clone_update_extent_map(inode, trans, NULL, last_dest_end,
+		clone_update_extent_map(BTRFS_I(inode), trans, NULL, last_dest_end,
 					destoff + len - last_dest_end);
 		ret = clone_finish_inode_update(trans, inode, destoff + len,
 						destoff, olen, no_time_update);
-- 
2.7.4

