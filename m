From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: fix num_start_workers count if we fail to make an alloc
Date: Fri, 18 Nov 2011 14:38:54 -0500
Message-ID: <1321645134-3944-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org, viro@ZenIV.linux.org.uk
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Al pointed out that if we fail to start a worker for whatever reason (ENOMEM
basically), we could leak our count for num_start_workers, and so we'd think we
had more workers than we actually do.  This could cause us to shrink workers
when we shouldn't or not start workers when we should.  So check the return
value and if we failed fix num_start_workers and fallback.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/async-thread.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index 7ec1409..09ef1b0 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -568,6 +568,7 @@ static struct btrfs_worker_thread *find_worker(struct btrfs_workers *workers)
 	struct btrfs_worker_thread *worker;
 	unsigned long flags;
 	struct list_head *fallback;
+	int ret;
 
 again:
 	spin_lock_irqsave(&workers->lock, flags);
@@ -584,7 +585,13 @@ again:
 			workers->num_workers_starting++;
 			spin_unlock_irqrestore(&workers->lock, flags);
 			/* we're below the limit, start another worker */
-			__btrfs_start_workers(workers, 1);
+			ret = __btrfs_start_workers(workers, 1);
+			if (ret) {
+				spin_lock_irqsave(&workers->lock, flags);
+				workers->num_workers_starting--;
+				spin_unlock_irqrestore(&workers->lock, flags);
+				goto fallback;
+			}
 			goto again;
 		}
 	}
-- 
1.7.5.2

