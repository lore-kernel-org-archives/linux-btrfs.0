Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50042 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755006AbaEOOs0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 May 2014 10:48:26 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 7D96CAD03
	for <linux-btrfs@vger.kernel.org>; Thu, 15 May 2014 14:48:24 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: remove stale newlines from log messages
Date: Thu, 15 May 2014 16:48:20 +0200
Message-Id: <1400165300-16094-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've noticed an extra line after "use no compression", but search
revealed much more in messages of more critical levels and rare errors.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/extent-tree.c  |  2 +-
 fs/btrfs/inode.c        |  4 ++--
 fs/btrfs/ordered-data.c |  2 +-
 fs/btrfs/relocation.c   |  4 ++--
 fs/btrfs/send.c         |  4 ++--
 fs/btrfs/super.c        |  2 +-
 fs/btrfs/volumes.c      | 10 +++++-----
 7 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 5590af92094b..e7d44767bee0 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5806,7 +5806,7 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 	refs = btrfs_extent_refs(leaf, ei);
 	if (refs < refs_to_drop) {
 		btrfs_err(info, "trying to drop %d refs but we only have %Lu "
-			  "for bytenr %Lu\n", refs_to_drop, refs, bytenr);
+			  "for bytenr %Lu", refs_to_drop, refs, bytenr);
 		ret = -EINVAL;
 		btrfs_abort_transaction(trans, extent_root, ret);
 		goto out;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5f805bc944fa..94eb7950a25d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3473,7 +3473,7 @@ cache_acl:
 		ret = btrfs_load_inode_props(inode, path);
 		if (ret)
 			btrfs_err(root->fs_info,
-				  "error loading props for ino %llu (root %llu): %d\n",
+				  "error loading props for ino %llu (root %llu): %d",
 				  btrfs_ino(inode),
 				  root->root_key.objectid, ret);
 	}
@@ -7992,7 +7992,7 @@ int btrfs_create_subvol_root(struct btrfs_trans_handle *trans,
 	err = btrfs_subvol_inherit_props(trans, new_root, parent_root);
 	if (err)
 		btrfs_err(new_root->fs_info,
-			  "error inheriting subvolume %llu properties: %d\n",
+			  "error inheriting subvolume %llu properties: %d",
 			  new_root->root_key.objectid, err);
 
 	err = btrfs_update_inode(trans, new_root, inode);
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index a94b05f72869..e12441c7cf1d 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -67,7 +67,7 @@ static void ordered_data_tree_panic(struct inode *inode, int errno,
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	btrfs_panic(fs_info, errno, "Inconsistency in ordered tree at offset "
-		    "%llu\n", offset);
+		    "%llu", offset);
 }
 
 /*
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 7f92ab1daa87..41c02cb8b06d 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -337,7 +337,7 @@ static void backref_tree_panic(struct rb_node *rb_node, int errno, u64 bytenr)
 	if (bnode->root)
 		fs_info = bnode->root->fs_info;
 	btrfs_panic(fs_info, errno, "Inconsistency in backref cache "
-		    "found at offset %llu\n", bytenr);
+		    "found at offset %llu", bytenr);
 }
 
 /*
@@ -1258,7 +1258,7 @@ static int __must_check __add_reloc_root(struct btrfs_root *root)
 	if (rb_node) {
 		btrfs_panic(root->fs_info, -EEXIST, "Duplicate root found "
 			    "for start=%llu while inserting into relocation "
-			    "tree\n", node->bytenr);
+			    "tree", node->bytenr);
 		kfree(node);
 		return -EEXIST;
 	}
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index eb6537a08c1b..094f7dee8031 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -1346,7 +1346,7 @@ static int find_extent_clone(struct send_ctx *sctx,
 		ret = -EIO;
 		btrfs_err(sctx->send_root->fs_info, "did not find backref in "
 				"send_root. inode=%llu, offset=%llu, "
-				"disk_byte=%llu found extent=%llu\n",
+				"disk_byte=%llu found extent=%llu",
 				ino, data_offset, disk_byte, found_key.objectid);
 		goto out;
 	}
@@ -5487,7 +5487,7 @@ static void btrfs_root_dec_send_in_progress(struct btrfs_root* root)
 	 */
 	if (root->send_in_progress < 0)
 		btrfs_err(root->fs_info,
-			"send_in_progres unbalanced %d root %llu\n",
+			"send_in_progres unbalanced %d root %llu",
 			root->send_in_progress, root->root_key.objectid);
 	spin_unlock(&root->root_item_lock);
 }
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 9601d25a4607..b6771877b433 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -511,7 +511,7 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			} else if (compress) {
 				if (!btrfs_test_opt(root, COMPRESS))
 					btrfs_info(root->fs_info,
-						   "btrfs: use %s compression\n",
+						   "btrfs: use %s compression",
 						   compress_type);
 			}
 			break;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 49d7fab73360..f594f6349d3d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4046,7 +4046,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 		max_stripe_size = 32 * 1024 * 1024;
 		max_chunk_size = 2 * max_stripe_size;
 	} else {
-		btrfs_err(info, "invalid chunk type 0x%llx requested\n",
+		btrfs_err(info, "invalid chunk type 0x%llx requested",
 		       type);
 		BUG_ON(1);
 	}
@@ -4294,7 +4294,7 @@ int btrfs_finish_chunk_alloc(struct btrfs_trans_handle *trans,
 
 	if (em->start != chunk_offset || em->len != chunk_size) {
 		btrfs_crit(extent_root->fs_info, "found a bad mapping, wanted"
-			  " %Lu-%Lu, found %Lu-%Lu\n", chunk_offset,
+			  " %Lu-%Lu, found %Lu-%Lu", chunk_offset,
 			  chunk_size, em->start, em->len);
 		free_extent_map(em);
 		return -EINVAL;
@@ -4496,14 +4496,14 @@ int btrfs_num_copies(struct btrfs_fs_info *fs_info, u64 logical, u64 len)
 	 * and exit, so return 1 so the callers don't try to use other copies.
 	 */
 	if (!em) {
-		btrfs_crit(fs_info, "No mapping for %Lu-%Lu\n", logical,
+		btrfs_crit(fs_info, "No mapping for %Lu-%Lu", logical,
 			    logical+len);
 		return 1;
 	}
 
 	if (em->start > logical || em->start + em->len < logical) {
 		btrfs_crit(fs_info, "Invalid mapping for %Lu-%Lu, got "
-			    "%Lu-%Lu\n", logical, logical+len, em->start,
+			    "%Lu-%Lu", logical, logical+len, em->start,
 			    em->start + em->len);
 		free_extent_map(em);
 		return 1;
@@ -4684,7 +4684,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 
 	if (em->start > logical || em->start + em->len < logical) {
 		btrfs_crit(fs_info, "found a bad mapping, wanted %Lu, "
-			   "found %Lu-%Lu\n", logical, em->start,
+			   "found %Lu-%Lu", logical, em->start,
 			   em->start + em->len);
 		free_extent_map(em);
 		return -EINVAL;
-- 
1.9.0

