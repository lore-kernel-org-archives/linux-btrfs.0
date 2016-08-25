Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:31551 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1757363AbcHYFZM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Aug 2016 01:25:12 -0400
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 2/3] btrfs-progs: check: make low memory mode support partially dropped snapshots
Date: Thu, 25 Aug 2016 13:21:00 +0800
Message-Id: <20160825052101.25864-2-wangxg.fnst@cn.fujitsu.com>
In-Reply-To: <20160825052101.25864-1-wangxg.fnst@cn.fujitsu.com>
References: <20160825052101.25864-1-wangxg.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
 cmds-check.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/cmds-check.c b/cmds-check.c
index 1cd0421..bce586c 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -9016,9 +9016,10 @@ static int check_tree_block_backref(struct btrfs_fs_info *fs_info, u64 root_id,
 	free_extent_buffer(eb);
 
 	btrfs_init_path(&path);
+	path.lowest_level = level;
 	/* Search with the first key, to ensure we can reach it */
 	ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
-	if (ret) {
+	if (ret < 0) {
 		err |= REFERENCER_MISSING;
 		goto release_out;
 	}
@@ -9901,6 +9902,8 @@ static int traverse_tree_block(struct btrfs_root *root,
 				struct extent_buffer *node)
 {
 	struct extent_buffer *eb;
+	struct btrfs_key key;
+	struct btrfs_key drop_key;
 	int level;
 	u64 nr;
 	int i;
@@ -9946,6 +9949,7 @@ static int traverse_tree_block(struct btrfs_root *root,
 	}
 
 	nr = btrfs_header_nritems(node);
+	btrfs_disk_key_to_cpu(&drop_key, &root->root_item.drop_progress);
 	btree_space_waste += (BTRFS_NODEPTRS_PER_BLOCK(root) - nr) *
 		sizeof(struct btrfs_key_ptr);
 
@@ -9953,6 +9957,11 @@ static int traverse_tree_block(struct btrfs_root *root,
 	for (i = 0; i < nr; i++) {
 		u64 blocknr = btrfs_node_blockptr(node, i);
 
+		btrfs_node_key_to_cpu(node, &key, i);
+		if (level == root->root_item.drop_level &&
+		    is_dropped_key(&key, &drop_key))
+			continue;
+
 		/*
 		 * As a btrfs tree has most 8 levels (0..7), so it's quite safe
 		 * to call the function itself.
-- 
2.9.0



