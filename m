Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:44573 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756142Ab3AOG2b (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Jan 2013 01:28:31 -0500
Message-ID: <50F4F738.50606@cn.fujitsu.com>
Date: Tue, 15 Jan 2013 14:29:12 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
CC: dsterba@suse.cz
Subject: [PATCH] Btrfs: fix missed transaction->aborted check
References: <50EEB9AF.2010301@cn.fujitsu.com> <20130110173800.GH20089@twin.jikos.cz>
In-Reply-To: <20130110173800.GH20089@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

First, though the current transaction->aborted check can stop the commit early
and avoid unnecessary operations, it is too early, and some transaction handles
don't end, those handles may set transaction->aborted after the check.

Second, when we commit the transaction, we will wake up some worker threads to
flush the space cache and inode cache. Those threads also allocate some transaction
handles and may set transaction->aborted if some serious error happens.

So we need more check for ->aborted when committing the transaction. Fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
This patch is against the following patch:
[PATCH V2 11/11] Btrfs: Add ACCESS_ONCE() to transaction->abort accesses
---
 fs/btrfs/transaction.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 7dbfe2c..50437b4 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1575,6 +1575,11 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	wait_event(cur_trans->writer_wait,
 		   atomic_read(&cur_trans->num_writers) == 1);
 
+	/* ->aborted might be set after the previous check, so check it */
+	if (unlikely(ACCESS_ONCE(cur_trans->aborted))) {
+		ret = cur_trans->aborted;
+		goto cleanup_transaction;
+	}
 	/*
 	 * the reloc mutex makes sure that we stop
 	 * the balancing code from coming in and moving
@@ -1658,6 +1663,17 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 		goto cleanup_transaction;
 	}
 
+	/*
+	 * The tasks which save the space cache and inode cache may also
+	 * update ->aborted, check it.
+	 */
+	if (unlikely(ACCESS_ONCE(cur_trans->aborted))) {
+		ret = cur_trans->aborted;
+		mutex_unlock(&root->fs_info->tree_log_mutex);
+		mutex_unlock(&root->fs_info->reloc_mutex);
+		goto cleanup_transaction;
+	}
+
 	btrfs_prepare_extent_commit(trans, root);
 
 	cur_trans = root->fs_info->running_transaction;
-- 
1.7.11.7

