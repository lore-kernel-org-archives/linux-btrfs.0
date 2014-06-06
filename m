Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:37229 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbaFFDIE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Jun 2014 23:08:04 -0400
Received: by mail-we0-f179.google.com with SMTP id q59so2088603wes.24
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Jun 2014 20:08:02 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: make fsync work after cloning into a file
Date: Fri,  6 Jun 2014 05:05:51 +0100
Message-Id: <1402027551-9737-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When cloning into a file, we were correctly replacing the extent
items in the target range and removing the extent maps. However
we weren't replacing the extent maps with new ones that point to
the new extents - as a consequence, an incremental fsync (when the
inode doesn't have the full sync flag) was a NOOP, since it relies
on the existence of extent maps in the modified list of the inode's
extent map tree, which was empty. Therefore add new extent maps to
reflect the target clone range.

A test case for xfstests follows.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/ioctl.c | 114 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 114 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 44dcfd0..1197478 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3043,6 +3043,104 @@ out:
 	return ret;
 }
 
+static void clone_update_extent_map(struct inode *inode,
+				    const struct btrfs_trans_handle *trans,
+				    const struct btrfs_path *path,
+				    const struct btrfs_key *key,
+				    struct btrfs_file_extent_item *fi,
+				    const u64 hole_offset,
+				    const u64 hole_len)
+{
+	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct extent_buffer *leaf = path->nodes[0];
+	const int slot = path->slots[0];
+	struct extent_map *em;
+	u64 extent_start, extent_end;
+	u64 bytenr;
+	u8 type;
+	int ret;
+
+	em = alloc_extent_map();
+	if (!em) {
+		set_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
+			&BTRFS_I(inode)->runtime_flags);
+		return;
+	}
+
+	em->bdev = root->fs_info->fs_devices->latest_bdev;
+	if (!fi) {
+		em->start = hole_offset;
+		em->len = hole_len;
+		em->ram_bytes = em->len;
+		em->orig_start = hole_offset;
+		em->block_start = EXTENT_MAP_HOLE;
+		em->block_len = 0;
+		em->orig_block_len = 0;
+		em->compress_type = BTRFS_COMPRESS_NONE;
+		em->generation = trans->transid;
+		goto insert_em;
+	}
+
+	em->generation = -1;
+	extent_start = key->offset;
+	extent_end = extent_start + btrfs_file_extent_num_bytes(leaf, fi);
+	bytenr = btrfs_file_extent_disk_bytenr(leaf, fi);
+	type = btrfs_file_extent_type(leaf, fi);
+
+	em->start = extent_start;
+	em->ram_bytes = btrfs_file_extent_ram_bytes(leaf, fi);
+	em->compress_type = btrfs_file_extent_compression(leaf, fi);
+
+	if (em->compress_type != BTRFS_COMPRESS_NONE)
+		set_bit(EXTENT_FLAG_COMPRESSED, &em->flags);
+
+	if (type == BTRFS_FILE_EXTENT_INLINE) {
+		em->len = ALIGN(btrfs_file_extent_inline_len(leaf, slot, fi),
+				root->sectorsize);
+		em->orig_block_len = em->len;
+		em->orig_start = em->start;
+		em->block_start = EXTENT_MAP_INLINE;
+		em->block_len = (u64)-1;
+		goto insert_em;
+	}
+
+	em->len = extent_end - extent_start;
+	em->orig_block_len = btrfs_file_extent_disk_num_bytes(leaf, fi);
+	em->orig_start = extent_start - btrfs_file_extent_offset(leaf, fi);
+	if (bytenr == 0)
+		em->block_start = EXTENT_MAP_HOLE;
+	else
+		em->block_start = bytenr;
+
+	if (em->compress_type == BTRFS_COMPRESS_NONE) {
+		em->block_start += btrfs_file_extent_offset(leaf, fi);
+		em->block_len = em->len;
+	} else {
+		em->block_len = em->orig_block_len;
+	}
+
+	if (type == BTRFS_FILE_EXTENT_PREALLOC)
+		set_bit(EXTENT_FLAG_PREALLOC, &em->flags);
+
+insert_em:
+	while (1) {
+		write_lock(&em_tree->lock);
+		ret = add_extent_mapping(em_tree, em, 1);
+		write_unlock(&em_tree->lock);
+		if (ret != -EEXIST) {
+			free_extent_map(em);
+			break;
+		}
+		btrfs_drop_extent_cache(inode, em->start,
+					em->start + em->len - 1, 0);
+	}
+
+	if (unlikely(ret))
+		set_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
+			&BTRFS_I(inode)->runtime_flags);
+}
+
 /**
  * btrfs_clone() - clone a range from inode file to another
  *
@@ -3361,8 +3459,19 @@ process_slot:
 					    btrfs_item_ptr_offset(leaf, slot),
 					    size);
 				inode_add_bytes(inode, datal);
+				extent = btrfs_item_ptr(leaf, slot,
+						struct btrfs_file_extent_item);
 			}
 
+			/* If we have an implicit hole (NO_HOLES feature). */
+			if (drop_start < new_key.offset)
+				clone_update_extent_map(inode, trans,
+						path, NULL, NULL, drop_start,
+						new_key.offset - drop_start);
+
+			clone_update_extent_map(inode, trans, path,
+						&new_key, extent, 0, 0);
+
 			btrfs_mark_buffer_dirty(leaf);
 			btrfs_release_path(path);
 
@@ -3406,6 +3515,11 @@ process_slot:
 		}
 		ret = clone_finish_inode_update(trans, inode, destoff + len,
 						destoff, olen);
+		if (ret)
+			goto out;
+		clone_update_extent_map(inode, trans,
+					path, NULL, NULL, last_dest_end,
+					destoff + len - last_dest_end);
 	}
 
 out:
-- 
1.9.1

