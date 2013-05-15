Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:48578 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756715Ab3EOHsp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 May 2013 03:48:45 -0400
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: alex.btrfs@zadarastorage.com
Subject: [PATCH 15/17] Btrfs: remove unnecessary varient ->num_joined in btrfs_transaction structure
Date: Wed, 15 May 2013 15:48:29 +0800
Message-Id: <1368604111-25073-16-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1368604111-25073-1-git-send-email-miaox@cn.fujitsu.com>
References: <1368604111-25073-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We used ->num_joined track if there were some writers which join the current
transaction when the committer was sleeping. If some writers joined the current
transaction, we has to continue the while loop to do some necessary stuff, such
as flush the ordered operations. But it is unnecessary because we will do it
after the while loop.

Besides that, tracking ->num_joined would make the committer drop into the while
loop when there are lots of internal writers(TRANS_JOIN).

So we remove ->num_joined and don't track if there are some writers which join
the current transaction when the committer is sleeping.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/transaction.c | 8 +-------
 fs/btrfs/transaction.h | 2 --
 2 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 265db57..75e7b15 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -124,7 +124,6 @@ loop:
 		atomic_inc(&cur_trans->use_count);
 		atomic_inc(&cur_trans->num_writers);
 		extwriter_counter_inc(cur_trans, type);
-		cur_trans->num_joined++;
 		spin_unlock(&fs_info->trans_lock);
 		return 0;
 	}
@@ -157,7 +156,6 @@ loop:
 
 	atomic_set(&cur_trans->num_writers, 1);
 	extwriter_counter_init(cur_trans, type);
-	cur_trans->num_joined = 0;
 	init_waitqueue_head(&cur_trans->writer_wait);
 	init_waitqueue_head(&cur_trans->commit_wait);
 	cur_trans->in_commit = 0;
@@ -1566,7 +1564,6 @@ static inline void btrfs_wait_delalloc_flush(struct btrfs_fs_info *fs_info)
 int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root)
 {
-	unsigned long joined = 0;
 	struct btrfs_transaction *cur_trans = trans->transaction;
 	struct btrfs_transaction *prev_trans = NULL;
 	DEFINE_WAIT(wait);
@@ -1668,8 +1665,6 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 		should_grow = 1;
 
 	do {
-		joined = cur_trans->num_joined;
-
 		WARN_ON(cur_trans != trans->transaction);
 
 		ret = btrfs_flush_all_pending_stuffs(trans, root);
@@ -1685,8 +1680,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 			schedule_timeout(1);
 
 		finish_wait(&cur_trans->writer_wait, &wait);
-	} while (extwriter_counter_read(cur_trans) > 0 ||
-		 (should_grow && cur_trans->num_joined != joined));
+	} while (extwriter_counter_read(cur_trans) > 0);
 
 	ret = btrfs_flush_all_pending_stuffs(trans, root);
 	if (ret)
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 5cc77b0..0fc45e2 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -37,8 +37,6 @@ struct btrfs_transaction {
 	atomic_t num_writers;
 	atomic_t use_count;
 
-	unsigned long num_joined;
-
 	spinlock_t commit_lock;
 	int in_commit;
 	int commit_done;
-- 
1.8.1.4

