Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56804 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754898AbeCHOfs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Mar 2018 09:35:48 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DB6A7AE19
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Mar 2018 14:35:46 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 09/22] btrfs: drop fs_info parameter from tree_mod_log_free_eb
Date: Thu,  8 Mar 2018 15:33:26 +0100
Message-Id: <be8d4a28bd86f0943bb3dffc3911795fdb3c4db8.1520518876.git.dsterba@suse.com>
In-Reply-To: <cover.1520518876.git.dsterba@suse.com>
References: <cover.1520518876.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's provided by the extent_buffer.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 60e27bef0e27..6d2f8562bb36 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -41,8 +41,6 @@ static int balance_node_right(struct btrfs_trans_handle *trans,
 			      struct extent_buffer *src_buf);
 static void del_ptr(struct btrfs_root *root, struct btrfs_path *path,
 		    int level, int slot);
-static int tree_mod_log_free_eb(struct btrfs_fs_info *fs_info,
-				 struct extent_buffer *eb);
 
 struct btrfs_path *btrfs_alloc_path(void)
 {
@@ -882,8 +880,7 @@ static noinline void tree_mod_log_set_node_key(struct extent_buffer *eb,
 	BUG_ON(ret < 0);
 }
 
-static noinline int
-tree_mod_log_free_eb(struct btrfs_fs_info *fs_info, struct extent_buffer *eb)
+static noinline int tree_mod_log_free_eb(struct extent_buffer *eb)
 {
 	struct tree_mod_elem **tm_list = NULL;
 	int nritems = 0;
@@ -893,7 +890,7 @@ tree_mod_log_free_eb(struct btrfs_fs_info *fs_info, struct extent_buffer *eb)
 	if (btrfs_header_level(eb) == 0)
 		return 0;
 
-	if (!tree_mod_need_log(fs_info, NULL))
+	if (!tree_mod_need_log(eb->fs_info, NULL))
 		return 0;
 
 	nritems = btrfs_header_nritems(eb);
@@ -910,11 +907,11 @@ tree_mod_log_free_eb(struct btrfs_fs_info *fs_info, struct extent_buffer *eb)
 		}
 	}
 
-	if (tree_mod_dont_log(fs_info, eb))
+	if (tree_mod_dont_log(eb->fs_info, eb))
 		goto free_tms;
 
-	ret = __tree_mod_log_free_eb(fs_info, tm_list, nritems);
-	tree_mod_log_write_unlock(fs_info);
+	ret = __tree_mod_log_free_eb(eb->fs_info, tm_list, nritems);
+	tree_mod_log_write_unlock(eb->fs_info);
 	if (ret)
 		goto free_tms;
 	kfree(tm_list);
@@ -1183,7 +1180,7 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 					      trans->transid);
 		btrfs_mark_buffer_dirty(parent);
 		if (last_ref) {
-			ret = tree_mod_log_free_eb(fs_info, buf);
+			ret = tree_mod_log_free_eb(buf);
 			if (ret) {
 				btrfs_abort_transaction(trans, ret);
 				return ret;
-- 
2.16.2

