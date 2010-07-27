From: Vasiliy Kulikov <segooon@gmail.com>
Subject: [PATCH v2] btrfs: set task state with
 schedule_timeout_uninterruptible()
Date: Tue, 27 Jul 2010 21:46:53 +0400
Message-ID: <20100727174653.GA21048@albatros>
References: <1280132864-8266-1-git-send-email-segooon@gmail.com>
 <4C4E5560.9060905@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kernel-janitors@vger.kernel.org,
	Chris Mason <chris.mason@oracle.com>,
	Tejun Heo <tj@kernel.org>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Miao Xie <miaox@cn.fujitsu.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4C4E5560.9060905@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

schedule_timeout() is used without setting state to
STATE_(UN)INTERRUPTIBLE. As it is called without checking of pending
signals, use schedule_timeout_uninterruptible() instead.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 fs/btrfs/async-thread.c |    2 +-
 fs/btrfs/extent-tree.c  |    6 +++---
 fs/btrfs/ordered-data.c |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index 7ec1409..54eb070 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -362,7 +362,7 @@ again:
 				 * worker->working is still 1, so nobody
 				 * is going to try and wake us up
 				 */
-				schedule_timeout(1);
+				schedule_timeout_uninterruptible(1);
 				smp_mb();
 				if (!list_empty(&worker->pending) ||
 				    !list_empty(&worker->prio_pending))
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 32d0940..5b55a20 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -365,7 +365,7 @@ again:
 			up_read(&fs_info->extent_commit_sem);
 			mutex_unlock(&caching_ctl->mutex);
 			if (btrfs_transaction_in_commit(fs_info))
-				schedule_timeout(1);
+				schedule_timeout_uninterruptible(1);
 			else
 				cond_resched();
 			goto again;
@@ -2237,7 +2237,7 @@ again:
 			node = rb_next(node);
 		}
 		spin_unlock(&delayed_refs->lock);
-		schedule_timeout(1);
+		schedule_timeout_uninterruptible(1);
 		goto again;
 	}
 out:
@@ -3686,7 +3686,7 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 	int ret;
 
 	if (btrfs_transaction_in_commit(root->fs_info))
-		schedule_timeout(1);
+		schedule_timeout_uninterruptible(1);
 
 	num_bytes = ALIGN(num_bytes, root->sectorsize);
 again:
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index e56c72b..9ff49e5 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -576,7 +576,7 @@ again:
 	}
 	if (found || test_range_bit(&BTRFS_I(inode)->io_tree, start, orig_end,
 			   EXTENT_DELALLOC, 0, NULL)) {
-		schedule_timeout(1);
+		schedule_timeout_uninterruptible(1);
 		goto again;
 	}
 	return 0;
-- 
1.7.0.4
