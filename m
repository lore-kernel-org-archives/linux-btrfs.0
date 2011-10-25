From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 31/66] btrfs: btrfs_stop_workers should return void
Date: Mon, 24 Oct 2011 21:03:07 -0400
Message-ID: <20111025010854.125851710@suse.com>
References: <20111025010236.322699279@suse.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>,
	David Sterba <dsterba@suse.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 btrfs_stop_workers has no error conditions and should return void.
 Its callers already ignore the error code anyway.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/async-thread.c |    3 +--
 fs/btrfs/async-thread.h |    2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -401,7 +401,7 @@ again:
 /*
  * this will wait for all the worker threads to shutdown
  */
-int btrfs_stop_workers(struct btrfs_workers *workers)
+void btrfs_stop_workers(struct btrfs_workers *workers)
 {
 	struct list_head *cur;
 	struct btrfs_worker_thread *worker;
@@ -429,7 +429,6 @@ int btrfs_stop_workers(struct btrfs_work
 		put_worker(worker);
 	}
 	spin_unlock_irq(&workers->lock);
-	return 0;
 }
 
 /*
--- a/fs/btrfs/async-thread.h
+++ b/fs/btrfs/async-thread.h
@@ -111,7 +111,7 @@ struct btrfs_workers {
 
 void btrfs_queue_worker(struct btrfs_workers *workers, struct btrfs_work *work);
 int btrfs_start_workers(struct btrfs_workers *workers, int num_workers);
-int btrfs_stop_workers(struct btrfs_workers *workers);
+void btrfs_stop_workers(struct btrfs_workers *workers);
 void btrfs_init_workers(struct btrfs_workers *workers, char *name, int max,
 			struct btrfs_workers *async_starter);
 int btrfs_requeue_work(struct btrfs_work *work);


