From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 06/16] Btrfs: remove a BUG_ON() in btrfs_commit_transaction()
Date: Thu, 14 Jul 2011 11:17:14 +0800
Message-ID: <4E1E5FBA.5030609@cn.fujitsu.com>
References: <4E1E5F59.5030208@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E1E5F59.5030208@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

wait_for_commit() always returns 0.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/transaction.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 34a30ea..40726ac 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -353,11 +353,10 @@ struct btrfs_trans_handle *btrfs_start_ioctl_transaction(struct btrfs_root *root
 }
 
 /* wait for a transaction commit to be fully complete */
-static noinline int wait_for_commit(struct btrfs_root *root,
+static noinline void wait_for_commit(struct btrfs_root *root,
 				    struct btrfs_transaction *commit)
 {
 	wait_event(commit->commit_wait, commit->commit_done);
-	return 0;
 }
 
 int btrfs_wait_for_commit(struct btrfs_root *root, u64 transid)
@@ -1184,8 +1183,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 		atomic_inc(&cur_trans->use_count);
 		btrfs_end_transaction(trans, root);
 
-		ret = wait_for_commit(root, cur_trans);
-		BUG_ON(ret);
+		wait_for_commit(root, cur_trans);
 
 		put_transaction(cur_trans);
 
-- 
1.7.3.1
