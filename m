From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 29/65] btrfs: run_ordered_completions should return void
Date: Mon, 03 Oct 2011 23:22:59 -0400
Message-ID: <20111004032303.246364891@suse.com>
References: <20111004032230.458853274@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
To: BtrFS List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 run_ordered_completions has no error conditions and should return void.
 Its callers already ignore the error code anyway.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/async-thread.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -174,11 +174,11 @@ out:
 	spin_unlock_irqrestore(&workers->lock, flags);
 }
 
-static noinline int run_ordered_completions(struct btrfs_workers *workers,
+static noinline void run_ordered_completions(struct btrfs_workers *workers,
 					    struct btrfs_work *work)
 {
 	if (!workers->ordered)
-		return 0;
+		return;
 
 	set_bit(WORK_DONE_BIT, &work->flags);
 
@@ -216,7 +216,6 @@ static noinline int run_ordered_completi
 	}
 
 	spin_unlock(&workers->order_lock);
-	return 0;
 }
 
 static void put_worker(struct btrfs_worker_thread *worker)


