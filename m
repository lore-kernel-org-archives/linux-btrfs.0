From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 13/18] btrfs: Remove unnecessary finish_wait() in wait_current_trans()
Date: Thu, 25 Mar 2010 20:35:14 +0800
Message-ID: <4BAB5882.2080205@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Chris Mason <chris.mason@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

We only need to call finish_wait() after wait loop.

By the way, this patch makes code of waiting loop similar to
example in wait.h(no functional change)

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/transaction.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 2d654c1..4305428 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -147,18 +147,13 @@ static void wait_current_trans(struct btrfs_root *root)
 		while (1) {
 			prepare_to_wait(&root->fs_info->transaction_wait, &wait,
 					TASK_UNINTERRUPTIBLE);
-			if (cur_trans->blocked) {
-				mutex_unlock(&root->fs_info->trans_mutex);
-				schedule();
-				mutex_lock(&root->fs_info->trans_mutex);
-				finish_wait(&root->fs_info->transaction_wait,
-					    &wait);
-			} else {
-				finish_wait(&root->fs_info->transaction_wait,
-					    &wait);
+			if (!cur_trans->blocked)
 				break;
-			}
+			mutex_unlock(&root->fs_info->trans_mutex);
+			schedule();
+			mutex_lock(&root->fs_info->trans_mutex);
 		}
+		finish_wait(&root->fs_info->transaction_wait, &wait);
 		put_transaction(cur_trans);
 	}
 }
-- 
1.6.5.2


