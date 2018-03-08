Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56801 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754780AbeCHOfp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Mar 2018 09:35:45 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A611CAE19
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Mar 2018 14:35:44 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 08/22] btrfs: drop fs_info parameter from tree_mod_log_insert_key
Date: Thu,  8 Mar 2018 15:33:24 +0100
Message-Id: <4bdee5b65d772cab68146e1327da37f62ed18ab0.1520518876.git.dsterba@suse.com>
In-Reply-To: <cover.1520518876.git.dsterba@suse.com>
References: <cover.1520518876.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's provided by the extent_buffer.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 3b707af76579..60e27bef0e27 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -536,28 +536,26 @@ alloc_tree_mod_elem(struct extent_buffer *eb, int slot,
 	return tm;
 }
 
-static noinline int
-tree_mod_log_insert_key(struct btrfs_fs_info *fs_info,
-			struct extent_buffer *eb, int slot,
-			enum mod_log_op op, gfp_t flags)
+static noinline int tree_mod_log_insert_key(struct extent_buffer *eb, int slot,
+		enum mod_log_op op, gfp_t flags)
 {
 	struct tree_mod_elem *tm;
 	int ret;
 
-	if (!tree_mod_need_log(fs_info, eb))
+	if (!tree_mod_need_log(eb->fs_info, eb))
 		return 0;
 
 	tm = alloc_tree_mod_elem(eb, slot, op, flags);
 	if (!tm)
 		return -ENOMEM;
 
-	if (tree_mod_dont_log(fs_info, eb)) {
+	if (tree_mod_dont_log(eb->fs_info, eb)) {
 		kfree(tm);
 		return 0;
 	}
 
-	ret = __tree_mod_log_insert(fs_info, tm);
-	tree_mod_log_write_unlock(fs_info);
+	ret = __tree_mod_log_insert(eb->fs_info, tm);
+	tree_mod_log_write_unlock(eb->fs_info);
 	if (ret)
 		kfree(tm);
 
@@ -879,8 +877,7 @@ static noinline void tree_mod_log_set_node_key(struct extent_buffer *eb,
 {
 	int ret;
 
-	ret = tree_mod_log_insert_key(eb->fs_info, eb, slot,
-					MOD_LOG_KEY_REPLACE,
+	ret = tree_mod_log_insert_key(eb, slot, MOD_LOG_KEY_REPLACE,
 					atomic ? GFP_ATOMIC : GFP_NOFS);
 	BUG_ON(ret < 0);
 }
@@ -1178,7 +1175,7 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 		add_root_to_dirty_list(root);
 	} else {
 		WARN_ON(trans->transid != btrfs_header_generation(parent));
-		tree_mod_log_insert_key(fs_info, parent, parent_slot,
+		tree_mod_log_insert_key(parent, parent_slot,
 					MOD_LOG_KEY_REPLACE, GFP_NOFS);
 		btrfs_set_node_blockptr(parent, parent_slot,
 					cow->start);
@@ -3441,8 +3438,8 @@ static void insert_ptr(struct btrfs_trans_handle *trans,
 			      (nritems - slot) * sizeof(struct btrfs_key_ptr));
 	}
 	if (level) {
-		ret = tree_mod_log_insert_key(fs_info, lower, slot,
-					      MOD_LOG_KEY_ADD, GFP_NOFS);
+		ret = tree_mod_log_insert_key(lower, slot, MOD_LOG_KEY_ADD,
+				GFP_NOFS);
 		BUG_ON(ret < 0);
 	}
 	btrfs_set_node_key(lower, key, slot);
@@ -4914,8 +4911,8 @@ static void del_ptr(struct btrfs_root *root, struct btrfs_path *path,
 			      sizeof(struct btrfs_key_ptr) *
 			      (nritems - slot - 1));
 	} else if (level) {
-		ret = tree_mod_log_insert_key(fs_info, parent, slot,
-					      MOD_LOG_KEY_REMOVE, GFP_NOFS);
+		ret = tree_mod_log_insert_key(parent, slot, MOD_LOG_KEY_REMOVE,
+				GFP_NOFS);
 		BUG_ON(ret < 0);
 	}
 
-- 
2.16.2

