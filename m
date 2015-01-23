Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:48533 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752608AbbAWJdv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Jan 2015 04:33:51 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>, <miaoxie@huawei.com>
Subject: [PATCH RFC v3 3/5] btrfs: Introduce per-transaction mount_opt to keep mount option consistent during transaction.
Date: Fri, 23 Jan 2015 17:31:43 +0800
Message-ID: <1422005505-9472-4-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1422005505-9472-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1422005505-9472-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before this patch, mount_opt is not consistent during a transaction.
btrfs_parse_options() can race with transaction.

Now each transaction will keep a copy of fs_info->mount_opt upon
creation, and new btrfs_test_trans_opt() macro is introduced to get the
mount_opt in the transaction.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/transaction.c | 1 +
 fs/btrfs/transaction.h | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 295a135..846e1b8 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -210,6 +210,7 @@ loop:
 		return -EROFS;
 	}
 
+	cur_trans->mount_opt = fs_info->mount_opt;
 	atomic_set(&cur_trans->num_writers, 1);
 	extwriter_counter_init(cur_trans, type);
 	init_waitqueue_head(&cur_trans->writer_wait);
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index fd400a3..4052879 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -52,6 +52,7 @@ struct btrfs_transaction {
 	struct list_head list;
 	struct extent_io_tree dirty_pages;
 	unsigned long start_time;
+	unsigned long mount_opt;
 	wait_queue_head_t writer_wait;
 	wait_queue_head_t commit_wait;
 	struct list_head pending_snapshots;
@@ -126,6 +127,9 @@ struct btrfs_pending_snapshot {
 	struct list_head list;
 };
 
+#define btrfs_test_trans_opt(trans, opt)	\
+	(btrfs_raw_test_opt(trans->transaction->mount_opt, opt))
+
 static inline void btrfs_set_inode_last_trans(struct btrfs_trans_handle *trans,
 					      struct inode *inode)
 {
-- 
2.2.2

