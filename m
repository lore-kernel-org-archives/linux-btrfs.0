Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:19115 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758657Ab3BTJPh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Feb 2013 04:15:37 -0500
Message-ID: <51249468.6010004@cn.fujitsu.com>
Date: Wed, 20 Feb 2013 17:16:24 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
CC: Josef Bacik <jbacik@fusionio.com>
Subject: [PATCH 2/3] Btrfs: fix the deadlock between the transaction start/attach
 and commit
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now btrfs_commit_transaction() does this

ret = btrfs_run_ordered_operations(root, 0)

which async flushes all inodes on the ordered operations list, it introduced
a deadlock that transaction-start task, transaction-commit task and the flush
workers waited for each other.
(See the following URL to get the detail
 http://marc.info/?l=linux-btrfs&m=136070705732646&w=2)

As we know, if ->in_commit is set, it means someone is committing the
current transaction, we should not try to join it if we are not JOIN
or JOIN_NOLOCK, wait is the best choice for it. In this way, we can avoid
the above problem. In this way, there is another benefit: there is no new
transaction handle to block the transaction which is on the way of commit,
once we set ->in_commit.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/transaction.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index bc2f2d1..71b7e2e 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -51,6 +51,14 @@ static noinline void switch_commit_root(struct btrfs_root *root)
 	root->commit_root = btrfs_root_node(root);
 }
 
+static inline int can_join_transaction(struct btrfs_transaction *trans,
+				       int type)
+{
+	return !(trans->in_commit &&
+		 type != TRANS_JOIN &&
+		 type != TRANS_JOIN_NOLOCK);
+}
+
 /*
  * either allocate a new transaction or hop into the existing one
  */
@@ -86,6 +94,10 @@ loop:
 			spin_unlock(&fs_info->trans_lock);
 			return cur_trans->aborted;
 		}
+		if (!can_join_transaction(cur_trans, type)) {
+			spin_unlock(&fs_info->trans_lock);
+			return -EBUSY;
+		}
 		atomic_inc(&cur_trans->use_count);
 		atomic_inc(&cur_trans->num_writers);
 		cur_trans->num_joined++;
@@ -360,8 +372,11 @@ again:
 
 	do {
 		ret = join_transaction(root, type);
-		if (ret == -EBUSY)
+		if (ret == -EBUSY) {
 			wait_current_trans(root);
+			if (unlikely(type == TRANS_ATTACH))
+				ret = -ENOENT;
+		}
 	} while (ret == -EBUSY);
 
 	if (ret < 0) {
-- 
1.6.5.2
