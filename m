Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56833 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754957AbeCHOgE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Mar 2018 09:36:04 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C9095AE19
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Mar 2018 14:36:02 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 16/22] btrfs: kill tree_mod_log_set_node_key helper
Date: Thu,  8 Mar 2018 15:33:42 +0100
Message-Id: <7a6fd7659753cd08e2e911ee88c5f3574ed1f4cf.1520518876.git.dsterba@suse.com>
In-Reply-To: <cover.1520518876.git.dsterba@suse.com>
References: <cover.1520518876.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A trivial wrapper that can be simply opencoded and makes the GFP
allocation request more visible. The error handling is now moved to the
callers.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.c | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 45c17433bb76..ceb0836d74cd 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -837,16 +837,6 @@ tree_mod_log_eb_copy(struct btrfs_fs_info *fs_info, struct extent_buffer *dst,
 	return ret;
 }
 
-static noinline void tree_mod_log_set_node_key(struct extent_buffer *eb,
-		int slot, int atomic)
-{
-	int ret;
-
-	ret = tree_mod_log_insert_key(eb, slot, MOD_LOG_KEY_REPLACE,
-					atomic ? GFP_ATOMIC : GFP_NOFS);
-	BUG_ON(ret < 0);
-}
-
 static noinline int tree_mod_log_free_eb(struct extent_buffer *eb)
 {
 	struct tree_mod_elem **tm_list = NULL;
@@ -1962,7 +1952,9 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 		} else {
 			struct btrfs_disk_key right_key;
 			btrfs_node_key(right, &right_key, 0);
-			tree_mod_log_set_node_key(parent, pslot + 1, 0);
+			ret = tree_mod_log_insert_key(parent, pslot + 1,
+					MOD_LOG_KEY_REPLACE, GFP_NOFS);
+			BUG_ON(ret < 0);
 			btrfs_set_node_key(parent, &right_key, pslot + 1);
 			btrfs_mark_buffer_dirty(parent);
 		}
@@ -2006,7 +1998,9 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 		/* update the parent key to reflect our changes */
 		struct btrfs_disk_key mid_key;
 		btrfs_node_key(mid, &mid_key, 0);
-		tree_mod_log_set_node_key(parent, pslot, 0);
+		ret = tree_mod_log_insert_key(parent, pslot,
+				MOD_LOG_KEY_REPLACE, GFP_NOFS);
+		BUG_ON(ret < 0);
 		btrfs_set_node_key(parent, &mid_key, pslot);
 		btrfs_mark_buffer_dirty(parent);
 	}
@@ -2107,7 +2101,9 @@ static noinline int push_nodes_for_insert(struct btrfs_trans_handle *trans,
 			struct btrfs_disk_key disk_key;
 			orig_slot += left_nr;
 			btrfs_node_key(mid, &disk_key, 0);
-			tree_mod_log_set_node_key(parent, pslot, 0);
+			ret = tree_mod_log_insert_key(parent, pslot,
+					MOD_LOG_KEY_REPLACE, GFP_NOFS);
+			BUG_ON(ret < 0);
 			btrfs_set_node_key(parent, &disk_key, pslot);
 			btrfs_mark_buffer_dirty(parent);
 			if (btrfs_header_nritems(left) > orig_slot) {
@@ -2161,7 +2157,9 @@ static noinline int push_nodes_for_insert(struct btrfs_trans_handle *trans,
 			struct btrfs_disk_key disk_key;
 
 			btrfs_node_key(right, &disk_key, 0);
-			tree_mod_log_set_node_key(parent, pslot + 1, 0);
+			ret = tree_mod_log_insert_key(parent, pslot + 1,
+					MOD_LOG_KEY_REPLACE, GFP_NOFS);
+			BUG_ON(ret < 0);
 			btrfs_set_node_key(parent, &disk_key, pslot + 1);
 			btrfs_mark_buffer_dirty(parent);
 
@@ -3114,13 +3112,17 @@ static void fixup_low_keys(struct btrfs_fs_info *fs_info,
 {
 	int i;
 	struct extent_buffer *t;
+	int ret;
 
 	for (i = level; i < BTRFS_MAX_LEVEL; i++) {
 		int tslot = path->slots[i];
+
 		if (!path->nodes[i])
 			break;
 		t = path->nodes[i];
-		tree_mod_log_set_node_key(t, tslot, 1);
+		ret = tree_mod_log_insert_key(t, tslot, MOD_LOG_KEY_REPLACE,
+				GFP_ATOMIC);
+		BUG_ON(ret < 0);
 		btrfs_set_node_key(t, key, tslot);
 		btrfs_mark_buffer_dirty(path->nodes[i]);
 		if (tslot != 0)
-- 
2.16.2

