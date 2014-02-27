Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20952 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbaB0Hjw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Feb 2014 02:39:52 -0500
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s1R7dpTk026976
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Feb 2014 07:39:51 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s1R7dorS020973
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Feb 2014 07:39:51 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s1R7doxh005726
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Feb 2014 07:39:50 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/4] Btrfs: check if directory has already been created smarter
Date: Thu, 27 Feb 2014 15:39:40 +0800
Message-Id: <1393486780-17811-2-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1393486780-17811-1-git-send-email-bo.li.liu@oracle.com>
References: <1393486780-17811-1-git-send-email-bo.li.liu@oracle.com>
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
created out of order, and in the above case, we just need an O(logn)
search instead of O(1) search.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/send.c | 87 ++++++++++++++++++++++++++++-----------------------------
 1 file changed, 43 insertions(+), 44 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 33063d1..fcad93c 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -175,6 +175,9 @@ struct send_ctx {
 	 * own move/rename can be performed.
 	 */
 	struct rb_root waiting_dir_moves;
+
+	/* directories which are created out of order, check did_create_dir() */
+	struct rb_root out_of_order;
 };
 
 struct pending_dir_move {
@@ -2494,56 +2497,40 @@ out:
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
-	while (1) {
-		ret = btrfs_search_slot_for_read(sctx->send_root, &key, path,
-				1, 0);
-		if (ret < 0)
-			goto out;
-		if (!ret) {
-			eb = path->nodes[0];
-			slot = path->slots[0];
-			btrfs_item_key_to_cpu(eb, &found_key, slot);
-		}
-		if (ret || found_key.objectid != key.objectid ||
-		    found_key.type != key.type) {
-			ret = 0;
-			goto out;
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
+			}
+			return 1;
 		}
+	}
 
-		di = btrfs_item_ptr(eb, slot, struct btrfs_dir_item);
-		btrfs_dir_item_key_to_cpu(eb, di, &di_key);
-
-		if (di_key.type != BTRFS_ROOT_ITEM_KEY &&
-		    di_key.objectid < sctx->send_progress) {
-			ret = 1;
-			goto out;
-		}
+	if (!cur_is_dir) {
+		entry = kmalloc(sizeof(*entry), GFP_NOFS);
+		if (!entry)
+			return -ENOMEM;
+		entry->ino = dir;
 
-		key.offset = found_key.offset + 1;
-		btrfs_release_path(path);
+		rb_link_node(&entry->node, parent, p);
+		rb_insert_color(&entry->node, &sctx->out_of_order);
 	}
-
-out:
-	btrfs_free_path(path);
-	return ret;
+	return 0;
 }
 
 /*
@@ -5340,6 +5327,7 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
 
 	sctx->pending_dir_moves = RB_ROOT;
 	sctx->waiting_dir_moves = RB_ROOT;
+	sctx->out_of_order = RB_ROOT;
 
 	sctx->clone_roots = vzalloc(sizeof(struct clone_root) *
 			(arg->clone_sources_count + 1));
@@ -5477,6 +5465,17 @@ out:
 		kfree(dm);
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
1.8.2.1

