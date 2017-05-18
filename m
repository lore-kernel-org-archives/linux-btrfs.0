Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:46077 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755106AbdERDjM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 23:39:12 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH 05/32] btrfs-progs: Refactor block sizes users in ctree.c and ctree.h
Date: Thu, 18 May 2017 11:38:30 +0800
Message-ID: <20170518033857.15002-6-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
References: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 ctree.c | 10 +++++-----
 ctree.h |  4 ++--
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/ctree.c b/ctree.c
index 02c71807..266a3cf2 100644
--- a/ctree.c
+++ b/ctree.c
@@ -650,7 +650,7 @@ struct extent_buffer *read_node_slot(struct btrfs_root *root,
 		return NULL;
 
 	return read_tree_block(root, btrfs_node_blockptr(parent, slot),
-		       root->nodesize,
+		       root->fs_info->nodesize,
 		       btrfs_node_ptr_generation(parent, slot));
 }
 
@@ -987,7 +987,7 @@ void reada_for_search(struct btrfs_root *root, struct btrfs_path *path,
 
 	node = path->nodes[level];
 	search = btrfs_node_blockptr(node, slot);
-	blocksize = root->nodesize;
+	blocksize = root->fs_info->nodesize;
 	eb = btrfs_find_tree_block(root, search, blocksize);
 	if (eb) {
 		free_extent_buffer(eb);
@@ -1420,7 +1420,7 @@ static int noinline insert_new_root(struct btrfs_trans_handle *trans,
 	else
 		btrfs_node_key(lower, &lower_key, 0);
 
-	c = btrfs_alloc_free_block(trans, root, root->nodesize,
+	c = btrfs_alloc_free_block(trans, root, root->fs_info->nodesize,
 				   root->root_key.objectid, &lower_key, 
 				   level, root->node->start, 0);
 
@@ -1543,7 +1543,7 @@ static int split_node(struct btrfs_trans_handle *trans, struct btrfs_root
 	mid = (c_nritems + 1) / 2;
 	btrfs_node_key(c, &disk_key, mid);
 
-	split = btrfs_alloc_free_block(trans, root, root->nodesize,
+	split = btrfs_alloc_free_block(trans, root, root->fs_info->nodesize,
 					root->root_key.objectid,
 					&disk_key, level, c->start, 0);
 	if (IS_ERR(split))
@@ -2110,7 +2110,7 @@ again:
 	else
 		btrfs_item_key(l, &disk_key, mid);
 
-	right = btrfs_alloc_free_block(trans, root, root->nodesize,
+	right = btrfs_alloc_free_block(trans, root, root->fs_info->nodesize,
 					root->root_key.objectid,
 					&disk_key, 0, l->start, 0);
 	if (IS_ERR(right)) {
diff --git a/ctree.h b/ctree.h
index 78956a4f..84298c7b 100644
--- a/ctree.h
+++ b/ctree.h
@@ -352,11 +352,11 @@ struct btrfs_header {
 	u8 level;
 } __attribute__ ((__packed__));
 
-#define BTRFS_NODEPTRS_PER_BLOCK(r) (((r)->nodesize - \
+#define BTRFS_NODEPTRS_PER_BLOCK(r) (((r)->fs_info->nodesize - \
 			        sizeof(struct btrfs_header)) / \
 			        sizeof(struct btrfs_key_ptr))
 #define __BTRFS_LEAF_DATA_SIZE(bs) ((bs) - sizeof(struct btrfs_header))
-#define BTRFS_LEAF_DATA_SIZE(r) (__BTRFS_LEAF_DATA_SIZE(r->nodesize))
+#define BTRFS_LEAF_DATA_SIZE(r) (__BTRFS_LEAF_DATA_SIZE(r->fs_info->nodesize))
 #define BTRFS_MAX_INLINE_DATA_SIZE(r) (BTRFS_LEAF_DATA_SIZE(r) - \
 					sizeof(struct btrfs_item) - \
 					sizeof(struct btrfs_file_extent_item))
-- 
2.13.0



