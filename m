Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:46257 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752008AbeERDAk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 May 2018 23:00:40 -0400
From: Liu Bo <bo.liu@linux.alibaba.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 3/6] Btrfs: move get root of btrfs_search_slot to a helper
Date: Fri, 18 May 2018 11:00:21 +0800
Message-Id: <1526612424-97061-4-git-send-email-bo.liu@linux.alibaba.com>
In-Reply-To: <1526612424-97061-1-git-send-email-bo.liu@linux.alibaba.com>
References: <1526612424-97061-1-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's good to have a helper instead of having all get-root details
open-coded.

The new helper locks (if necessary) and sets root node of the path.

Also invert the checks to make the code flow easier to read.

There is no functional change in this commit.

Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
---
 fs/btrfs/ctree.c | 115 +++++++++++++++++++++++++++++++++----------------------
 1 file changed, 70 insertions(+), 45 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index a96d308c51b8..d12fc0474e21 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2598,6 +2598,75 @@ int btrfs_find_item(struct btrfs_root *fs_root, struct btrfs_path *path,
 	return 0;
 }
 
+static struct extent_buffer *btrfs_search_slot_get_root(struct btrfs_root *root,
+							struct btrfs_path *p,
+							int write_lock_level)
+{
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct extent_buffer *b;
+	int root_lock;
+	int level = 0;
+
+	/*
+	 * we try very hard to do read locks on the root
+	 */
+	root_lock = BTRFS_READ_LOCK;
+
+	if (p->search_commit_root) {
+		/*
+		 * the commit roots are read only so we always do read locks
+		 */
+		if (p->need_commit_sem)
+			down_read(&fs_info->commit_root_sem);
+		b = root->commit_root;
+		extent_buffer_get(b);
+		level = btrfs_header_level(b);
+		if (p->need_commit_sem)
+			up_read(&fs_info->commit_root_sem);
+		if (!p->skip_locking)
+			btrfs_tree_read_lock(b);
+
+		goto out;
+	}
+
+	if (p->skip_locking) {
+		b = btrfs_root_node(root);
+		level = btrfs_header_level(b);
+		goto out;
+	}
+
+	/*
+	 * we don't know the level of the root node until we actually
+	 * have it read locked
+	 */
+	b = btrfs_read_lock_root_node(root);
+	level = btrfs_header_level(b);
+	if (level > write_lock_level)
+		goto out;
+
+	/*
+	 * whoops, must trade for write lock
+	 */
+	btrfs_tree_read_unlock(b);
+	free_extent_buffer(b);
+	b = btrfs_lock_root_node(root);
+	root_lock = BTRFS_WRITE_LOCK;
+	/*
+	 * the level might have changed, check again
+	 */
+	level = btrfs_header_level(b);
+
+out:
+	p->nodes[level] = b;
+	if (!p->skip_locking)
+		p->locks[level] = root_lock;
+	/*
+	 * Callers are responsible for drop b's refs.
+	 */
+	return b;
+}
+
+
 /*
  * btrfs_search_slot - look for a key in a tree and perform necessary
  * modifications to preserve tree invariants.
@@ -2634,7 +2703,6 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	int err;
 	int level;
 	int lowest_unlock = 1;
-	int root_lock;
 	/* everything at write_lock_level or lower must be write locked */
 	int write_lock_level = 0;
 	u8 lowest_level = 0;
@@ -2672,50 +2740,7 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 
 again:
 	prev_cmp = -1;
-	/*
-	 * we try very hard to do read locks on the root
-	 */
-	root_lock = BTRFS_READ_LOCK;
-	level = 0;
-	if (p->search_commit_root) {
-		/*
-		 * the commit roots are read only
-		 * so we always do read locks
-		 */
-		if (p->need_commit_sem)
-			down_read(&fs_info->commit_root_sem);
-		b = root->commit_root;
-		extent_buffer_get(b);
-		level = btrfs_header_level(b);
-		if (p->need_commit_sem)
-			up_read(&fs_info->commit_root_sem);
-		if (!p->skip_locking)
-			btrfs_tree_read_lock(b);
-	} else {
-		if (p->skip_locking) {
-			b = btrfs_root_node(root);
-			level = btrfs_header_level(b);
-		} else {
-			/* we don't know the level of the root node
-			 * until we actually have it read locked
-			 */
-			b = btrfs_read_lock_root_node(root);
-			level = btrfs_header_level(b);
-			if (level <= write_lock_level) {
-				/* whoops, must trade for write lock */
-				btrfs_tree_read_unlock(b);
-				free_extent_buffer(b);
-				b = btrfs_lock_root_node(root);
-				root_lock = BTRFS_WRITE_LOCK;
-
-				/* the level might have changed, check again */
-				level = btrfs_header_level(b);
-			}
-		}
-	}
-	p->nodes[level] = b;
-	if (!p->skip_locking)
-		p->locks[level] = root_lock;
+	b = btrfs_search_slot_get_root(root, p, write_lock_level);
 
 	while (b) {
 		level = btrfs_header_level(b);
-- 
1.8.3.1

