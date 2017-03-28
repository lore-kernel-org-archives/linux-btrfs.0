Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38309 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753140AbdC1Mgg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Mar 2017 08:36:36 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D13CDAE18
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Mar 2017 12:36:24 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: sink GFP flags parameter to tree_mod_log_insert_root
Date: Tue, 28 Mar 2017 14:35:42 +0200
Message-Id: <20170328123542.22193-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

All (1) callers pass the same value.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index d034d47c5470..165e7ec12af7 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -663,7 +663,7 @@ __tree_mod_log_free_eb(struct btrfs_fs_info *fs_info,
 static noinline int
 tree_mod_log_insert_root(struct btrfs_fs_info *fs_info,
 			 struct extent_buffer *old_root,
-			 struct extent_buffer *new_root, gfp_t flags,
+			 struct extent_buffer *new_root,
 			 int log_removal)
 {
 	struct tree_mod_elem *tm = NULL;
@@ -678,14 +678,14 @@ tree_mod_log_insert_root(struct btrfs_fs_info *fs_info,
 	if (log_removal && btrfs_header_level(old_root) > 0) {
 		nritems = btrfs_header_nritems(old_root);
 		tm_list = kcalloc(nritems, sizeof(struct tree_mod_elem *),
-				  flags);
+				  GFP_NOFS);
 		if (!tm_list) {
 			ret = -ENOMEM;
 			goto free_tms;
 		}
 		for (i = 0; i < nritems; i++) {
 			tm_list[i] = alloc_tree_mod_elem(old_root, i,
-			    MOD_LOG_KEY_REMOVE_WHILE_FREEING, flags);
+			    MOD_LOG_KEY_REMOVE_WHILE_FREEING, GFP_NOFS);
 			if (!tm_list[i]) {
 				ret = -ENOMEM;
 				goto free_tms;
@@ -693,7 +693,7 @@ tree_mod_log_insert_root(struct btrfs_fs_info *fs_info,
 		}
 	}
 
-	tm = kzalloc(sizeof(*tm), flags);
+	tm = kzalloc(sizeof(*tm), GFP_NOFS);
 	if (!tm) {
 		ret = -ENOMEM;
 		goto free_tms;
@@ -943,7 +943,7 @@ tree_mod_log_set_root_pointer(struct btrfs_root *root,
 {
 	int ret;
 	ret = tree_mod_log_insert_root(root->fs_info, root->node,
-				       new_root_node, GFP_NOFS, log_removal);
+				       new_root_node, log_removal);
 	BUG_ON(ret < 0);
 }
 
-- 
2.12.0

