Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:39771 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750738Ab3AVKsz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jan 2013 05:48:55 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r0MAmrwF019329
	for <linux-btrfs@vger.kernel.org>; Tue, 22 Jan 2013 18:48:53 +0800
Message-ID: <50FE6EBD.2060906@cn.fujitsu.com>
Date: Tue, 22 Jan 2013 18:49:33 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/5] Btrfs: check the return value of btrfs_start_delalloc_inodes()
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We forget to check the return value of btrfs_start_delalloc_inodes(), fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/dev-replace.c |    6 +++++-
 fs/btrfs/transaction.c |    4 +++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 66dbc8d..7ba7b39 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -465,7 +465,11 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	 * flush all outstanding I/O and inode extent mappings before the
 	 * copy operation is declared as being finished
 	 */
-	btrfs_start_delalloc_inodes(root, 0);
+	ret = btrfs_start_delalloc_inodes(root, 0);
+	if (ret) {
+		mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
+		return ret;
+	}
 	btrfs_wait_ordered_extents(root, 0);
 
 	trans = btrfs_start_transaction(root, 0);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 87fac9a..34c5b7b 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1417,7 +1417,9 @@ static int btrfs_flush_all_pending_stuffs(struct btrfs_trans_handle *trans,
 	}
 
 	if (flush_on_commit || snap_pending) {
-		btrfs_start_delalloc_inodes(root, 1);
+		ret = btrfs_start_delalloc_inodes(root, 1);
+		if (ret)
+			return ret;
 		btrfs_wait_ordered_extents(root, 1);
 	}
 
-- 
1.6.5.2
