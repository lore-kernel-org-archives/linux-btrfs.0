Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49643 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933483AbeE1QNr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 May 2018 12:13:47 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A5B1CADE5
        for <linux-btrfs@vger.kernel.org>; Mon, 28 May 2018 16:13:45 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 09/11] btrfs-progs: Remove root argument from btrfs_set_block_flags
Date: Mon, 28 May 2018 09:36:48 +0300
Message-Id: <1527489410-3564-10-git-send-email-nborisov@suse.com>
In-Reply-To: <1527489410-3564-1-git-send-email-nborisov@suse.com>
References: <1527489410-3564-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's used only to get a reference to fs_info, which can be obtained from
the transaction handle.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 ctree.c       |  2 +-
 ctree.h       |  5 ++---
 extent-tree.c | 22 ++++++++++------------
 3 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/ctree.c b/ctree.c
index c89fd11fc48b..2c51580fec65 100644
--- a/ctree.c
+++ b/ctree.c
@@ -236,7 +236,7 @@ static noinline int update_ref_for_cow(struct btrfs_trans_handle *trans,
 			BUG_ON(ret);
 		}
 		if (new_flags != 0) {
-			ret = btrfs_set_block_flags(trans, root, buf->start,
+			ret = btrfs_set_block_flags(trans, buf->start,
 						    btrfs_header_level(buf),
 						    new_flags);
 			BUG_ON(ret);
diff --git a/ctree.h b/ctree.h
index 037e020401d2..c1033c86d484 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2519,9 +2519,8 @@ struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
 int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
 			     struct btrfs_fs_info *fs_info, u64 bytenr,
 			     u64 offset, int metadata, u64 *refs, u64 *flags);
-int btrfs_set_block_flags(struct btrfs_trans_handle *trans,
-			  struct btrfs_root *root,
-			  u64 bytenr, int level, u64 flags);
+int btrfs_set_block_flags(struct btrfs_trans_handle *trans, u64 bytenr,
+			  int level, u64 flags);
 int btrfs_inc_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		  struct extent_buffer *buf, int record_parent);
 int btrfs_dec_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
diff --git a/extent-tree.c b/extent-tree.c
index 2fd4e7a0d9eb..24fb96492c13 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -1529,18 +1529,17 @@ int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-int btrfs_set_block_flags(struct btrfs_trans_handle *trans,
-			  struct btrfs_root *root,
-			  u64 bytenr, int level, u64 flags)
+int btrfs_set_block_flags(struct btrfs_trans_handle *trans, u64 bytenr,
+			  int level, u64 flags)
 {
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_path *path;
 	int ret;
 	struct btrfs_key key;
 	struct extent_buffer *l;
 	struct btrfs_extent_item *item;
 	u32 item_size;
-	int skinny_metadata =
-		btrfs_fs_incompat(root->fs_info, SKINNY_METADATA);
+	int skinny_metadata = btrfs_fs_incompat(fs_info, SKINNY_METADATA);
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -1552,13 +1551,12 @@ int btrfs_set_block_flags(struct btrfs_trans_handle *trans,
 		key.offset = level;
 		key.type = BTRFS_METADATA_ITEM_KEY;
 	} else {
-		key.offset = root->fs_info->nodesize;
+		key.offset = fs_info->nodesize;
 		key.type = BTRFS_EXTENT_ITEM_KEY;
 	}
 
 again:
-	ret = btrfs_search_slot(trans, root->fs_info->extent_root, &key, path,
-				0, 0);
+	ret = btrfs_search_slot(trans, fs_info->extent_root, &key, path, 0, 0);
 	if (ret < 0)
 		goto out;
 
@@ -1569,13 +1567,13 @@ int btrfs_set_block_flags(struct btrfs_trans_handle *trans,
 			btrfs_item_key_to_cpu(path->nodes[0], &key,
 					      path->slots[0]);
 			if (key.objectid == bytenr &&
-			    key.offset == root->fs_info->nodesize &&
+			    key.offset == fs_info->nodesize &&
 			    key.type == BTRFS_EXTENT_ITEM_KEY)
 				ret = 0;
 		}
 		if (ret) {
 			btrfs_release_path(path);
-			key.offset = root->fs_info->nodesize;
+			key.offset = fs_info->nodesize;
 			key.type = BTRFS_EXTENT_ITEM_KEY;
 			goto again;
 		}
@@ -1591,8 +1589,8 @@ int btrfs_set_block_flags(struct btrfs_trans_handle *trans,
 	item_size = btrfs_item_size_nr(l, path->slots[0]);
 #ifdef BTRFS_COMPAT_EXTENT_TREE_V0
 	if (item_size < sizeof(*item)) {
-		ret = convert_extent_item_v0(trans, root->fs_info->extent_root,
-					     path, (u64)-1, 0);
+		ret = convert_extent_item_v0(trans, fs_info->extent_root, path,
+					     (u64)-1, 0);
 		if (ret < 0)
 			goto out;
 
-- 
2.7.4

