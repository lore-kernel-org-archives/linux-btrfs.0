Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:59460 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752075Ab2FNIQI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jun 2012 04:16:08 -0400
From: Liu Bo <liubo2009@cn.fujitsu.com>
To: <chris.mason@fusionio.com>
Cc: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 06/10 RESEND] Btrfs: destroy the items of the delayed inodes in error handling routine
Date: Thu, 14 Jun 2012 16:23:22 +0800
Message-Id: <1339662206-5307-7-git-send-email-liubo2009@cn.fujitsu.com>
In-Reply-To: <1339662206-5307-1-git-send-email-liubo2009@cn.fujitsu.com>
References: <1339662206-5307-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Miao Xie <miaox@cn.fujitsu.com>

the items of the delayed inodes were forgotten to be freed, this patch
fixes it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/delayed-inode.c |   18 ++++++++++++++++++
 fs/btrfs/delayed-inode.h |    3 +++
 fs/btrfs/disk-io.c       |    6 ++++++
 3 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index c18d044..2399f40 100644
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
index 7083d08..f5aa402 100644
--- a/fs/btrfs/delayed-inode.h
+++ b/fs/btrfs/delayed-inode.h
@@ -124,6 +124,9 @@ int btrfs_fill_inode(struct inode *inode, u32 *rdev);
 /* Used for drop dead root */
 void btrfs_kill_all_delayed_nodes(struct btrfs_root *root);
 
+/* Used for clean the transaction */
+void btrfs_destroy_delayed_inodes(struct btrfs_root *root);
+
 /* Used for readdir() */
 void btrfs_get_delayed_items(struct inode *inode, struct list_head *ins_list,
 			     struct list_head *del_list);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 61deaa6..d16f4ce 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3607,6 +3607,9 @@ void btrfs_cleanup_one_transaction(struct btrfs_transaction *cur_trans,
 	if (waitqueue_active(&cur_trans->commit_wait))
 		wake_up(&cur_trans->commit_wait);
 
+	btrfs_destroy_delayed_inodes(root);
+	btrfs_assert_delayed_root_empty(root);
+
 	btrfs_destroy_pending_snapshots(cur_trans);
 
 	btrfs_destroy_marked_extents(root, &cur_trans->dirty_pages,
@@ -3661,6 +3664,9 @@ int btrfs_cleanup_transaction(struct btrfs_root *root)
 		if (waitqueue_active(&t->commit_wait))
 			wake_up(&t->commit_wait);
 
+		btrfs_destroy_delayed_inodes(root);
+		btrfs_assert_delayed_root_empty(root);
+
 		btrfs_destroy_pending_snapshots(t);
 
 		btrfs_destroy_delalloc_inodes(root);
-- 
1.6.5.2

