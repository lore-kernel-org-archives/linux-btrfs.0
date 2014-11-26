Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:57762 "EHLO
	prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753585AbaKZP3T (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Wed, 26 Nov 2014 10:29:19 -0500
From: Filipe Manana <fdmanana@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [PATCH 1/6] Btrfs: fix invalid block group rbtree access after bg is removed
Date: Wed, 26 Nov 2014 15:28:50 +0000
Message-Id: <1417015735-8581-2-git-send-email-fdmanana@suse.com>
In-Reply-To: <1417015735-8581-1-git-send-email-fdmanana@suse.com>
References: <1417015735-8581-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we grab a block group, for example in btrfs_trim_fs(), we will be holding
a reference on it but the block group can be removed after we got it (via
btrfs_remove_block_group), which means it will no longer be part of the
rbtree.

However, btrfs_remove_block_group() was only calling rb_erase() which leaves
the block group's rb_node left and right child pointers with the same content
they had before calling rb_erase. This was dangerous because a call to
next_block_group() would access the node's left and right child pointers (via
rb_next), which can be no longer valid.

Fix this by clearing a block group's node after removing it from the tree,
and have next_block_group() do a tree search to get the next block group
instead of using rb_next() if our block group was removed.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/extent-tree.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 744b580..3ba65d9 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3162,7 +3162,19 @@ next_block_group(struct btrfs_root *root,
 		 struct btrfs_block_group_cache *cache)
 {
 	struct rb_node *node;
+
 	spin_lock(&root->fs_info->block_group_cache_lock);
+
+	/* If our block group was removed, we need a full search. */
+	if (RB_EMPTY_NODE(&cache->cache_node)) {
+		const u64 next_bytenr = cache->key.objectid + cache->key.offset;
+
+		spin_unlock(&root->fs_info->block_group_cache_lock);
+		btrfs_put_block_group(cache);
+		cache = btrfs_lookup_first_block_group(root->fs_info,
+						       next_bytenr);
+		return cache;
+	}
 	node = rb_next(&cache->cache_node);
 	btrfs_put_block_group(cache);
 	if (node) {
@@ -9400,6 +9412,7 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 	spin_lock(&root->fs_info->block_group_cache_lock);
 	rb_erase(&block_group->cache_node,
 		 &root->fs_info->block_group_cache_tree);
+	RB_CLEAR_NODE(&block_group->cache_node);
 
 	if (root->fs_info->first_logical_byte == block_group->key.objectid)
 		root->fs_info->first_logical_byte = (u64)-1;
-- 
2.1.3

