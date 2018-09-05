Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34090 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726272AbeIEK6K (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Sep 2018 06:58:10 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5D1D7AEEA
        for <linux-btrfs@vger.kernel.org>; Wed,  5 Sep 2018 06:29:31 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/4] btrfs-progs: Replace root parameter using fs_info for reada_for_search()
Date: Wed,  5 Sep 2018 14:29:22 +0800
Message-Id: <20180905062924.23836-3-wqu@suse.com>
In-Reply-To: <20180905062924.23836-1-wqu@suse.com>
References: <20180905062924.23836-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As the @root parameter is only used to get @fs_info, use fs_info
directly instead.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 cmds-restore.c |  4 ++--
 ctree.c        | 11 +++++------
 ctree.h        |  4 ++--
 3 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/cmds-restore.c b/cmds-restore.c
index d12c1a924059..30ea8a7e93d1 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -259,7 +259,7 @@ again:
 		}
 
 		if (path->reada)
-			reada_for_search(root, path, level, slot, 0);
+			reada_for_search(fs_info, path, level, slot, 0);
 
 		next = read_node_slot(fs_info, c, slot);
 		if (extent_buffer_uptodate(next))
@@ -276,7 +276,7 @@ again:
 		if (!level)
 			break;
 		if (path->reada)
-			reada_for_search(root, path, level, 0, 0);
+			reada_for_search(fs_info, path, level, 0, 0);
 		next = read_node_slot(fs_info, next, 0);
 		if (!extent_buffer_uptodate(next))
 			goto again;
diff --git a/ctree.c b/ctree.c
index d8a6883aa85f..042fae19344d 100644
--- a/ctree.c
+++ b/ctree.c
@@ -1000,10 +1000,9 @@ static int noinline push_nodes_for_insert(struct btrfs_trans_handle *trans,
 /*
  * readahead one full node of leaves
  */
-void reada_for_search(struct btrfs_root *root, struct btrfs_path *path,
-			     int level, int slot, u64 objectid)
+void reada_for_search(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
+		      int level, int slot, u64 objectid)
 {
-	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct extent_buffer *node;
 	struct btrfs_disk_key disk_key;
 	u32 nritems;
@@ -1203,7 +1202,7 @@ again:
 				break;
 
 			if (should_reada)
-				reada_for_search(root, p, level, slot,
+				reada_for_search(fs_info, p, level, slot,
 						 key->objectid);
 
 			b = read_node_slot(fs_info, b, slot);
@@ -2902,7 +2901,7 @@ int btrfs_next_leaf(struct btrfs_root *root, struct btrfs_path *path)
 		}
 
 		if (path->reada)
-			reada_for_search(root, path, level, slot, 0);
+			reada_for_search(fs_info, path, level, slot, 0);
 
 		next = read_node_slot(fs_info, c, slot);
 		if (!extent_buffer_uptodate(next))
@@ -2919,7 +2918,7 @@ int btrfs_next_leaf(struct btrfs_root *root, struct btrfs_path *path)
 		if (!level)
 			break;
 		if (path->reada)
-			reada_for_search(root, path, level, 0, 0);
+			reada_for_search(fs_info, path, level, 0, 0);
 		next = read_node_slot(fs_info, next, 0);
 		if (!extent_buffer_uptodate(next))
 			return -EIO;
diff --git a/ctree.h b/ctree.h
index 4719962df67d..6df6075865c2 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2562,8 +2562,8 @@ btrfs_check_node(struct btrfs_root *root, struct btrfs_disk_key *parent_key,
 enum btrfs_tree_block_status
 btrfs_check_leaf(struct btrfs_root *root, struct btrfs_disk_key *parent_key,
 		 struct extent_buffer *buf);
-void reada_for_search(struct btrfs_root *root, struct btrfs_path *path,
-			     int level, int slot, u64 objectid);
+void reada_for_search(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
+		      int level, int slot, u64 objectid);
 struct extent_buffer *read_node_slot(struct btrfs_fs_info *fs_info,
 				   struct extent_buffer *parent, int slot);
 int btrfs_previous_item(struct btrfs_root *root,
-- 
2.18.0
