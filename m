Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56798 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754780AbeCHOfn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Mar 2018 09:35:43 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5469EAE22
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Mar 2018 14:35:42 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 07/22] btrfs: drop fs_info parameter from tree_mod_log_insert_move
Date: Thu,  8 Mar 2018 15:33:22 +0100
Message-Id: <20b5ada300838f25f1bc9270e7ba1c0cff532937.1520518876.git.dsterba@suse.com>
In-Reply-To: <cover.1520518876.git.dsterba@suse.com>
References: <cover.1520518876.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's provided by the extent_buffer.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 11e985ca0bc2..3b707af76579 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -564,10 +564,8 @@ tree_mod_log_insert_key(struct btrfs_fs_info *fs_info,
 	return ret;
 }
 
-static noinline int
-tree_mod_log_insert_move(struct btrfs_fs_info *fs_info,
-			 struct extent_buffer *eb, int dst_slot, int src_slot,
-			 int nr_items)
+static noinline int tree_mod_log_insert_move(struct extent_buffer *eb,
+		int dst_slot, int src_slot, int nr_items)
 {
 	struct tree_mod_elem *tm = NULL;
 	struct tree_mod_elem **tm_list = NULL;
@@ -575,7 +573,7 @@ tree_mod_log_insert_move(struct btrfs_fs_info *fs_info,
 	int i;
 	int locked = 0;
 
-	if (!tree_mod_need_log(fs_info, eb))
+	if (!tree_mod_need_log(eb->fs_info, eb))
 		return 0;
 
 	tm_list = kcalloc(nr_items, sizeof(struct tree_mod_elem *), GFP_NOFS);
@@ -603,7 +601,7 @@ tree_mod_log_insert_move(struct btrfs_fs_info *fs_info,
 		}
 	}
 
-	if (tree_mod_dont_log(fs_info, eb))
+	if (tree_mod_dont_log(eb->fs_info, eb))
 		goto free_tms;
 	locked = 1;
 
@@ -613,26 +611,26 @@ tree_mod_log_insert_move(struct btrfs_fs_info *fs_info,
 	 * buffer, i.e. dst_slot < src_slot.
 	 */
 	for (i = 0; i + dst_slot < src_slot && i < nr_items; i++) {
-		ret = __tree_mod_log_insert(fs_info, tm_list[i]);
+		ret = __tree_mod_log_insert(eb->fs_info, tm_list[i]);
 		if (ret)
 			goto free_tms;
 	}
 
-	ret = __tree_mod_log_insert(fs_info, tm);
+	ret = __tree_mod_log_insert(eb->fs_info, tm);
 	if (ret)
 		goto free_tms;
-	tree_mod_log_write_unlock(fs_info);
+	tree_mod_log_write_unlock(eb->fs_info);
 	kfree(tm_list);
 
 	return 0;
 free_tms:
 	for (i = 0; i < nr_items; i++) {
 		if (tm_list[i] && !RB_EMPTY_NODE(&tm_list[i]->node))
-			rb_erase(&tm_list[i]->node, &fs_info->tree_mod_log);
+			rb_erase(&tm_list[i]->node, &eb->fs_info->tree_mod_log);
 		kfree(tm_list[i]);
 	}
 	if (locked)
-		tree_mod_log_write_unlock(fs_info);
+		tree_mod_log_write_unlock(eb->fs_info);
 	kfree(tm_list);
 	kfree(tm);
 
@@ -872,8 +870,7 @@ tree_mod_log_eb_move(struct btrfs_fs_info *fs_info, struct extent_buffer *dst,
 		     int dst_offset, int src_offset, int nr_items)
 {
 	int ret;
-	ret = tree_mod_log_insert_move(fs_info, dst, dst_offset, src_offset,
-				       nr_items);
+	ret = tree_mod_log_insert_move(dst, dst_offset, src_offset, nr_items);
 	BUG_ON(ret < 0);
 }
 
-- 
2.16.2

