Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56793 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754052AbeCHOfm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Mar 2018 09:35:42 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1B9EDAE19
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Mar 2018 14:35:41 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 06/22] btrfs: drop fs_info parameter from tree_mod_log_set_node_key
Date: Thu,  8 Mar 2018 15:33:20 +0100
Message-Id: <1a75d9a6ff4ebfe2a8d0b0f8603014c7c8087924.1520518876.git.dsterba@suse.com>
In-Reply-To: <cover.1520518876.git.dsterba@suse.com>
References: <cover.1520518876.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's provided by the extent_buffer.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index b88a79e69ddf..11e985ca0bc2 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -877,13 +877,12 @@ tree_mod_log_eb_move(struct btrfs_fs_info *fs_info, struct extent_buffer *dst,
 	BUG_ON(ret < 0);
 }
 
-static noinline void
-tree_mod_log_set_node_key(struct btrfs_fs_info *fs_info,
-			  struct extent_buffer *eb, int slot, int atomic)
+static noinline void tree_mod_log_set_node_key(struct extent_buffer *eb,
+		int slot, int atomic)
 {
 	int ret;
 
-	ret = tree_mod_log_insert_key(fs_info, eb, slot,
+	ret = tree_mod_log_insert_key(eb->fs_info, eb, slot,
 					MOD_LOG_KEY_REPLACE,
 					atomic ? GFP_ATOMIC : GFP_NOFS);
 	BUG_ON(ret < 0);
@@ -2007,8 +2006,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 		} else {
 			struct btrfs_disk_key right_key;
 			btrfs_node_key(right, &right_key, 0);
-			tree_mod_log_set_node_key(fs_info, parent,
-						  pslot + 1, 0);
+			tree_mod_log_set_node_key(parent, pslot + 1, 0);
 			btrfs_set_node_key(parent, &right_key, pslot + 1);
 			btrfs_mark_buffer_dirty(parent);
 		}
@@ -2052,7 +2050,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 		/* update the parent key to reflect our changes */
 		struct btrfs_disk_key mid_key;
 		btrfs_node_key(mid, &mid_key, 0);
-		tree_mod_log_set_node_key(fs_info, parent, pslot, 0);
+		tree_mod_log_set_node_key(parent, pslot, 0);
 		btrfs_set_node_key(parent, &mid_key, pslot);
 		btrfs_mark_buffer_dirty(parent);
 	}
@@ -2153,7 +2151,7 @@ static noinline int push_nodes_for_insert(struct btrfs_trans_handle *trans,
 			struct btrfs_disk_key disk_key;
 			orig_slot += left_nr;
 			btrfs_node_key(mid, &disk_key, 0);
-			tree_mod_log_set_node_key(fs_info, parent, pslot, 0);
+			tree_mod_log_set_node_key(parent, pslot, 0);
 			btrfs_set_node_key(parent, &disk_key, pslot);
 			btrfs_mark_buffer_dirty(parent);
 			if (btrfs_header_nritems(left) > orig_slot) {
@@ -2207,8 +2205,7 @@ static noinline int push_nodes_for_insert(struct btrfs_trans_handle *trans,
 			struct btrfs_disk_key disk_key;
 
 			btrfs_node_key(right, &disk_key, 0);
-			tree_mod_log_set_node_key(fs_info, parent,
-						  pslot + 1, 0);
+			tree_mod_log_set_node_key(parent, pslot + 1, 0);
 			btrfs_set_node_key(parent, &disk_key, pslot + 1);
 			btrfs_mark_buffer_dirty(parent);
 
@@ -3167,7 +3164,7 @@ static void fixup_low_keys(struct btrfs_fs_info *fs_info,
 		if (!path->nodes[i])
 			break;
 		t = path->nodes[i];
-		tree_mod_log_set_node_key(fs_info, t, tslot, 1);
+		tree_mod_log_set_node_key(t, tslot, 1);
 		btrfs_set_node_key(t, key, tslot);
 		btrfs_mark_buffer_dirty(path->nodes[i]);
 		if (tslot != 0)
-- 
2.16.2

