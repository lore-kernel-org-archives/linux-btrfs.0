Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:10679 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726971AbeHHQTe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 8 Aug 2018 12:19:34 -0400
From: zhong jiang <zhongjiang@huawei.com>
To: <clm@fb.com>, <jbacik@fb.com>, <dsterba@suse.com>
CC: <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCHv3 3/3] fs/btrfs/tree-log: change btrfs_pin_log_trans to be void function
Date: Wed, 8 Aug 2018 21:47:55 +0800
Message-ID: <1533736075-8691-4-git-send-email-zhongjiang@huawei.com>
In-Reply-To: <1533736075-8691-1-git-send-email-zhongjiang@huawei.com>
References: <1533736075-8691-1-git-send-email-zhongjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_pin_log_trans defines the variable "ret" for return valule,
but it is not modified after initialization. Further, I find that
any of the callees do not handle the return value, so it is safe
to drop the unneeded value "ret".

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 fs/btrfs/tree-log.c | 5 +----
 fs/btrfs/tree-log.h | 2 +-
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 1650dc4..4ed7379 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -205,14 +205,11 @@ static int join_running_log_trans(struct btrfs_root *root)
  * until you call btrfs_end_log_trans() or it makes any future
  * log transactions wait until you call btrfs_end_log_trans()
  */
-int btrfs_pin_log_trans(struct btrfs_root *root)
+void btrfs_pin_log_trans(struct btrfs_root *root)
 {
-	int ret = -ENOENT;
-
 	mutex_lock(&root->log_mutex);
 	atomic_inc(&root->log_writers);
 	mutex_unlock(&root->log_mutex);
-	return ret;
 }
 
 /*
diff --git a/fs/btrfs/tree-log.h b/fs/btrfs/tree-log.h
index 122e68b..8977678 100644
--- a/fs/btrfs/tree-log.h
+++ b/fs/btrfs/tree-log.h
@@ -65,7 +65,7 @@ int btrfs_del_inode_ref_in_log(struct btrfs_trans_handle *trans,
 			       const char *name, int name_len,
 			       struct btrfs_inode *inode, u64 dirid);
 void btrfs_end_log_trans(struct btrfs_root *root);
-int btrfs_pin_log_trans(struct btrfs_root *root);
+void btrfs_pin_log_trans(struct btrfs_root *root);
 void btrfs_record_unlink_dir(struct btrfs_trans_handle *trans,
 			     struct btrfs_inode *dir, struct btrfs_inode *inode,
 			     int for_rename);
-- 
1.7.12.4

