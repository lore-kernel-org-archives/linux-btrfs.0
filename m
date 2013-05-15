Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:62621 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757155Ab3EOHso (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 May 2013 03:48:44 -0400
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: alex.btrfs@zadarastorage.com
Subject: [PATCH 10/17] Btrfs: just flush the delalloc inodes in the source tree before snapshot creation
Date: Wed, 15 May 2013 15:48:24 +0800
Message-Id: <1368604111-25073-11-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1368604111-25073-1-git-send-email-miaox@cn.fujitsu.com>
References: <1368604111-25073-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before applying this patch, we need flush all the delalloc inodes in
the fs when we want to create a snapshot, it wastes time, and make
the transaction commit be blocked for a long time. It means some other
user operation would also be blocked for a long time.

This patch improves this problem, we just flush the delalloc inodes that
in the source trees before snapshot creation, so the transaction commit
will complete quickly.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c       |  6 ++++++
 fs/btrfs/transaction.c | 10 +---------
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 0de4a2f..2677dcc 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -555,6 +555,12 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
 	if (!root->ref_cows)
 		return -EINVAL;
 
+	ret = btrfs_start_delalloc_inodes(root, 0);
+	if (ret)
+		return ret;
+
+	btrfs_wait_ordered_extents(root, 0);
+
 	pending_snapshot = kzalloc(sizeof(*pending_snapshot), GFP_NOFS);
 	if (!pending_snapshot)
 		return -ENOMEM;
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 2b17213..bc22be9 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1491,17 +1491,9 @@ static int btrfs_flush_all_pending_stuffs(struct btrfs_trans_handle *trans,
 					  struct btrfs_root *root)
 {
 	int flush_on_commit = btrfs_test_opt(root, FLUSHONCOMMIT);
-	int snap_pending = 0;
 	int ret;
 
-	if (!flush_on_commit) {
-		spin_lock(&root->fs_info->trans_lock);
-		if (!list_empty(&trans->transaction->pending_snapshots))
-			snap_pending = 1;
-		spin_unlock(&root->fs_info->trans_lock);
-	}
-
-	if (flush_on_commit || snap_pending) {
+	if (flush_on_commit) {
 		ret = btrfs_start_all_delalloc_inodes(root->fs_info, 1);
 		if (ret)
 			return ret;
-- 
1.8.1.4

