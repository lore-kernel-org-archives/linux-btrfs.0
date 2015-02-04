Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:7750 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751716AbbBDHTd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Feb 2015 02:19:33 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t147ICc2020220
	for <linux-btrfs@vger.kernel.org>; Wed, 4 Feb 2015 15:18:12 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/7] btrfs-progs: Add btrfs_(prev/next)_tree_block() to keep search result in the same level of path->lowest_level.
Date: Wed, 4 Feb 2015 15:16:45 +0800
Message-ID: <1423034213-14018-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1423034213-14018-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1423034213-14018-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before this patch, btrfs_(prev/next)_leaf() will search for the leaf
even path->lowest_level is set.

This is OK since nobody needs such function.

But later patches to clean up the csum in tree block needs to iterate
tree blocks level by level, which such function will be very handy.

This patch just modify the original btrfs_(prev/next)_leaf() to stop at
path->lowest_level, and alias btrfs_(prev/next)_tree_block() to them.
Since caller of btrfs_(prev/next)_leaf() don't set path->lowest_level,
there is no difference for them.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 ctree.c | 18 +++++++++++-------
 ctree.h | 12 ++++++++++++
 2 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/ctree.c b/ctree.c
index 130c61f..2d1da1c 100644
--- a/ctree.c
+++ b/ctree.c
@@ -2750,13 +2750,15 @@ int btrfs_del_items(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 
 /*
  * walk up the tree as far as required to find the previous leaf.
+ * result will be at the same level of path->lowest_level.
+ *
  * returns 0 if it found something or 1 if there are no lesser leaves.
  * returns < 0 on io errors.
  */
 int btrfs_prev_leaf(struct btrfs_root *root, struct btrfs_path *path)
 {
-	int slot;
-	int level = 1;
+	int slot = 0;
+	int level = path->lowest_level + 1;
 	struct extent_buffer *c;
 	struct extent_buffer *next = NULL;
 
@@ -2792,7 +2794,7 @@ int btrfs_prev_leaf(struct btrfs_root *root, struct btrfs_path *path)
 			slot--;
 		path->nodes[level] = next;
 		path->slots[level] = slot;
-		if (!level)
+		if (level == path->lowest_level)
 			break;
 		next = read_node_slot(root, next, slot);
 		if (!extent_buffer_uptodate(next)) {
@@ -2805,14 +2807,16 @@ int btrfs_prev_leaf(struct btrfs_root *root, struct btrfs_path *path)
 }
 
 /*
- * walk up the tree as far as required to find the next leaf.
+ * walk up the tree as far as required to find the next node/leaf.
+ * result will be at the same level of path->lowest_level.
+ *
  * returns 0 if it found something or 1 if there are no greater leaves.
  * returns < 0 on io errors.
  */
 int btrfs_next_leaf(struct btrfs_root *root, struct btrfs_path *path)
 {
-	int slot;
-	int level = 1;
+	int slot = 0;
+	int level = path->lowest_level + 1;
 	struct extent_buffer *c;
 	struct extent_buffer *next = NULL;
 
@@ -2844,7 +2848,7 @@ int btrfs_next_leaf(struct btrfs_root *root, struct btrfs_path *path)
 		free_extent_buffer(c);
 		path->nodes[level] = next;
 		path->slots[level] = 0;
-		if (!level)
+		if (level == path->lowest_level)
 			break;
 		if (path->reada)
 			reada_for_search(root, path, level, 0, 0);
diff --git a/ctree.h b/ctree.h
index 2a678a9..c52d3de 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2334,6 +2334,12 @@ static inline int btrfs_insert_empty_item(struct btrfs_trans_handle *trans,
 }
 
 int btrfs_next_leaf(struct btrfs_root *root, struct btrfs_path *path);
+static inline int btrfs_next_tree_block(struct btrfs_root *root,
+					struct btrfs_path *path)
+{
+	return btrfs_next_leaf(root, path);
+}
+
 static inline int btrfs_next_item(struct btrfs_root *root,
 				  struct btrfs_path *p)
 {
@@ -2344,6 +2350,12 @@ static inline int btrfs_next_item(struct btrfs_root *root,
 }
 
 int btrfs_prev_leaf(struct btrfs_root *root, struct btrfs_path *path);
+static inline int btrfs_prev_tree_block(struct btrfs_root *root,
+					struct btrfs_path *path)
+{
+	return btrfs_prev_leaf(root, path);
+}
+
 int btrfs_leaf_free_space(struct btrfs_root *root, struct extent_buffer *leaf);
 void btrfs_fixup_low_keys(struct btrfs_root *root, struct btrfs_path *path,
 			  struct btrfs_disk_key *key, int level);
-- 
2.2.2

