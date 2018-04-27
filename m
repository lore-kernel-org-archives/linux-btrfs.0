Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from synology.com ([59.124.61.242]:37827 "EHLO synology.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932491AbeD0J7Y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Apr 2018 05:59:24 -0400
From: ethanwu <ethanwu@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: bo.li.liu@oracle.com, ethanwu <ethanwu@synology.com>
Subject: [PATCH] btrfs: Take trans lock before access running trans in check_delayed_ref
Date: Fri, 27 Apr 2018 17:58:46 +0800
Message-Id: <1524823126-23414-1-git-send-email-ethanwu@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In preivous patch:
Btrfs: kill trans in run_delalloc_nocow and btrfs_cross_ref_exist
We avoid starting btrfs transaction and get this information from
fs_info->running_transaction directly.

When accessing running_transaction in check_delayed_ref, there's a
chance that current transaction will be freed by commit transaction
after the NULL pointer check of running_transaction is passed.

After looking all the other places using fs_info->running_transaction,
they are either protected by trans_lock or holding the transactions.

Fix this by using trans_lock and incrementing the use_count.

Signed-off-by: ethanwu <ethanwu@synology.com>
---
 fs/btrfs/extent-tree.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index c1618ab..c8fd37b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3149,7 +3149,11 @@ static noinline int check_delayed_ref(struct btrfs_root *root,
 	struct rb_node *node;
 	int ret = 0;
 
+	spin_lock(&root->fs_info->trans_lock);
 	cur_trans = root->fs_info->running_transaction;
+	if (cur_trans)
+		atomic_inc(&cur_trans->use_count);
+	spin_unlock(&root->fs_info->trans_lock);
 	if (!cur_trans)
 		return 0;
 
@@ -3158,6 +3162,7 @@ static noinline int check_delayed_ref(struct btrfs_root *root,
 	head = btrfs_find_delayed_ref_head(delayed_refs, bytenr);
 	if (!head) {
 		spin_unlock(&delayed_refs->lock);
+		btrfs_put_transaction(cur_trans);
 		return 0;
 	}
 
@@ -3174,6 +3179,7 @@ static noinline int check_delayed_ref(struct btrfs_root *root,
 		mutex_lock(&head->mutex);
 		mutex_unlock(&head->mutex);
 		btrfs_put_delayed_ref_head(head);
+		btrfs_put_transaction(cur_trans);
 		return -EAGAIN;
 	}
 	spin_unlock(&delayed_refs->lock);
@@ -3206,6 +3212,7 @@ static noinline int check_delayed_ref(struct btrfs_root *root,
 	}
 	spin_unlock(&head->lock);
 	mutex_unlock(&head->mutex);
+	btrfs_put_transaction(cur_trans);
 	return ret;
 }
 
-- 
1.9.1

