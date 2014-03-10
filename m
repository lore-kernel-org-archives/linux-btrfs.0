Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20649 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952AbaCJP1B (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Mar 2014 11:27:01 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Josef Bacik <jbacik@fb.com>
Subject: [PATCH v4 2/2] Btrfs: check if directory has already been created smarter
Date: Mon, 10 Mar 2014 23:26:04 +0800
Message-Id: <1394465164-18394-2-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1394465164-18394-1-git-send-email-bo.li.liu@oracle.com>
References: <1394465164-18394-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently to check whether a directory has been created, we search
DIR_INDEX items one by one to check if children has been processed.

Try to picture such a scenario:
   .
   |-- dir            (ino X)
         |-- foo_1    (ino X+1)
         |-- ...
         |-- foo_k    (ino X+k)

With the current way, we have to check all the k DIR_INDEX items
to find it is a fresh new one.

So this introduced a rbtree to store those directories which are
created out of order, and in the above case, we just need an O(log n)
search instead of O(n) search.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v4: rebase onto the latest btrfs-next.
v3: fix typo, s/O(1)/O(n)/g, thanks Wang Shilong.
v2: fix wrong patch name.

 fs/btrfs/send.c | 93 ++++++++++++++++++++++++++-------------------------------
 1 file changed, 42 insertions(+), 51 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 1a528d0..841ff45 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -182,6 +182,9 @@ struct send_ctx {
 	 */
 	struct rb_root waiting_dir_moves;
 
+	/* directories which are created out of order, check did_create_dir() */
+	struct rb_root out_of_order;
+
 	/*
 	 * A directory that is going to be rm'ed might have a child directory
 	 * which is in the pending directory moves index above. In this case,
@@ -2513,64 +2516,40 @@ out:
  */
 static int did_create_dir(struct send_ctx *sctx, u64 dir)
 {
-	int ret = 0;
-	struct btrfs_path *path = NULL;
-	struct btrfs_key key;
-	struct btrfs_key found_key;
-	struct btrfs_key di_key;
-	struct extent_buffer *eb;
-	struct btrfs_dir_item *di;
-	int slot;
+	struct rb_node **p = &sctx->out_of_order.rb_node;
+	struct rb_node *parent = NULL;
+	struct send_dir_node *entry = NULL;
+	int cur_is_dir = !!(dir == sctx->cur_ino);
 
-	path = alloc_path_for_send();
-	if (!path) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	verbose_printk("dir=%llu cur_ino=%llu send_progress=%llu\n",
+		 dir, sctx->cur_ino, sctx->send_progress);
 
-	key.objectid = dir;
-	key.type = BTRFS_DIR_INDEX_KEY;
-	key.offset = 0;
-	ret = btrfs_search_slot(NULL, sctx->send_root, &key, path, 0, 0);
-	if (ret < 0)
-		goto out;
-
-	while (1) {
-		eb = path->nodes[0];
-		slot = path->slots[0];
-		if (slot >= btrfs_header_nritems(eb)) {
-			ret = btrfs_next_leaf(sctx->send_root, path);
-			if (ret < 0) {
-				goto out;
-			} else if (ret > 0) {
-				ret = 0;
-				break;
+	while (*p) {
+		parent = *p;
+		entry = rb_entry(parent, struct send_dir_node, node);
+		if (dir < entry->ino) {
+			p = &(*p)->rb_left;
+		} else if (dir > entry->ino) {
+			p = &(*p)->rb_right;
+		} else {
+			if (cur_is_dir) {
+				rb_erase(&entry->node, &sctx->out_of_order);
+				kfree(entry);
 			}
-			continue;
-		}
-
-		btrfs_item_key_to_cpu(eb, &found_key, slot);
-		if (found_key.objectid != key.objectid ||
-		    found_key.type != key.type) {
-			ret = 0;
-			goto out;
-		}
-
-		di = btrfs_item_ptr(eb, slot, struct btrfs_dir_item);
-		btrfs_dir_item_key_to_cpu(eb, di, &di_key);
-
-		if (di_key.type != BTRFS_ROOT_ITEM_KEY &&
-		    di_key.objectid < sctx->send_progress) {
-			ret = 1;
-			goto out;
+			return 1;
 		}
+	}
 
-		path->slots[0]++;
+	if (!cur_is_dir) {
+		entry = kmalloc(sizeof(*entry), GFP_NOFS);
+		if (!entry)
+			return -ENOMEM;
+		entry->ino = dir;
+		rb_link_node(&entry->node, parent, p);
+		rb_insert_color(&entry->node, &sctx->out_of_order);
 	}
 
-out:
-	btrfs_free_path(path);
-	return ret;
+	return 0;
 }
 
 /*
@@ -5566,6 +5545,7 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
 
 	sctx->pending_dir_moves = RB_ROOT;
 	sctx->waiting_dir_moves = RB_ROOT;
+	sctx->out_of_order = RB_ROOT;
 	sctx->orphan_dirs = RB_ROOT;
 
 	sctx->clone_roots = vzalloc(sizeof(struct clone_root) *
@@ -5714,6 +5694,17 @@ out:
 		free_orphan_dir_info(sctx, odi);
 	}
 
+	WARN_ON(sctx && !ret && !RB_EMPTY_ROOT(&sctx->out_of_order));
+	while (sctx && !RB_EMPTY_ROOT(&sctx->out_of_order)) {
+		struct rb_node *n;
+		struct send_dir_node *entry;
+
+		n = rb_first(&sctx->out_of_order);
+		entry = rb_entry(n, struct send_dir_node, node);
+		rb_erase(&entry->node, &sctx->out_of_order);
+		kfree(entry);
+	}
+
 	if (sort_clone_roots) {
 		for (i = 0; i < sctx->clone_roots_cnt; i++)
 			btrfs_root_dec_send_in_progress(
-- 
1.8.1.4

