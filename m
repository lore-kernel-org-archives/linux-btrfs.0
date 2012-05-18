Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:46037 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757119Ab2ERKDw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 May 2012 06:03:52 -0400
Received: from mailserver.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q4IA3lS2025150
	for <linux-btrfs@vger.kernel.org>; Fri, 18 May 2012 18:03:49 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: destroy the items of the delayed inodes in error handling routine
Date: Fri, 18 May 2012 18:07:51 +0800
Message-Id: <1337335671-24926-3-git-send-email-liubo2009@cn.fujitsu.com>
In-Reply-To: <1337335671-24926-1-git-send-email-liubo2009@cn.fujitsu.com>
References: <1337335671-24926-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Miao Xie <miaox@cn.fujitsu.com>

the items of the delayed inodes were forgotten to be freed, this patch
fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/delayed-inode.c |   18 ++++++++++++++++++
 fs/btrfs/delayed-inode.h |    3 +++
 fs/btrfs/disk-io.c       |    6 ++++++
 3 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 03e3748..858d6c7 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1879,3 +1879,21 @@ void btrfs_kill_all_delayed_nodes(struct btrfs_root *root)
 		}
 	}
 }
+
+void btrfs_destroy_delayed_inodes(struct btrfs_root *root)
+{
+	struct btrfs_delayed_root *delayed_root;
+	struct btrfs_delayed_node *curr_node, *prev_node;
+
+	delayed_root = btrfs_get_delayed_root(root);
+
+	curr_node = btrfs_first_delayed_node(delayed_root);
+	while (curr_node) {
+		__btrfs_kill_delayed_node(curr_node);
+
+		prev_node = curr_node;
+		curr_node = btrfs_next_delayed_node(curr_node);
+		btrfs_release_delayed_node(prev_node);
+	}
+}
+
diff --git a/fs/btrfs/delayed-inode.h b/fs/btrfs/delayed-inode.h
index 7083d08..c1cfa87 100644
--- a/fs/btrfs/delayed-inode.h
+++ b/fs/btrfs/delayed-inode.h
@@ -124,6 +124,9 @@ int btrfs_fill_inode(struct inode *inode, u32 *rdev);
 /* Used for drop dead root */
 void btrfs_kill_all_delayed_nodes(struct btrfs_root *root);
 
+/* Used for clean the transaction */
+void btrfs_destroy_delayed_inodes(struct btrfs_root *root)
+
 /* Used for readdir() */
 void btrfs_get_delayed_items(struct inode *inode, struct list_head *ins_list,
 			     struct list_head *del_list);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 20196f4..a56026f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3583,6 +3583,9 @@ void btrfs_cleanup_one_transaction(struct btrfs_transaction *cur_trans,
 	if (waitqueue_active(&cur_trans->commit_wait))
 		wake_up(&cur_trans->commit_wait);
 
+	btrfs_destroy_delayed_inodes(root);
+	btrfs_assert_delayed_root_empty(root);
+
 	btrfs_destroy_pending_snapshots(cur_trans);
 
 	btrfs_destroy_marked_extents(root, &cur_trans->dirty_pages,
@@ -3635,6 +3638,9 @@ int btrfs_cleanup_transaction(struct btrfs_root *root)
 		if (waitqueue_active(&t->commit_wait))
 			wake_up(&t->commit_wait);
 
+		btrfs_destroy_delayed_inodes(root);
+		btrfs_assert_delayed_root_empty(root);
+
 		btrfs_destroy_pending_snapshots(t);
 
 		btrfs_destroy_delalloc_inodes(root);
-- 
1.7.6.5

