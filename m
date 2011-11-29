From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH] Btrfs: fix submit_worker congestion
Date: Tue, 29 Nov 2011 21:40:56 +0100
Message-ID: <1322599256-15621-1-git-send-email-sensille@gmx.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Write bios are submitted from the submit_worker. The worker pumps down
bios into the block layer until it signals a congestion. At least this
is the theory. In pratice submit_bio just blocks before any signalling
happens. As the bios are queued per device, this can lead to a situation
where only one device is served until all bios are submitted, and only
then the next device is served. This is obviously suboptimal.
This patch just throws out the congestion detection and reschedules the
worker every 8 requests. This way, all devices can be kept busy.
This is only a temporary fix until the block layer provides a non-blocking
submit_bio. Then the whole submit_worker mechanism can be killed.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/volumes.c |   30 +-----------------------------
 1 files changed, 1 insertions(+), 29 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c37433d..5b01742 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -257,36 +257,8 @@ loop_lock:
 		 * is now congested.  Back off and let other work structs
 		 * run instead
 		 */
-		if (pending && bdi_write_congested(bdi) && batch_run > 8 &&
+		if (pending && batch_run > 8 &&
 		    fs_info->fs_devices->open_devices > 1) {
-			struct io_context *ioc;
-
-			ioc = current->io_context;
-
-			/*
-			 * the main goal here is that we don't want to
-			 * block if we're going to be able to submit
-			 * more requests without blocking.
-			 *
-			 * This code does two great things, it pokes into
-			 * the elevator code from a filesystem _and_
-			 * it makes assumptions about how batching works.
-			 */
-			if (ioc && ioc->nr_batch_requests > 0 &&
-			    time_before(jiffies, ioc->last_waited + HZ/50UL) &&
-			    (last_waited == 0 ||
-			     ioc->last_waited == last_waited)) {
-				/*
-				 * we want to go through our batch of
-				 * requests and stop.  So, we copy out
-				 * the ioc->last_waited time and test
-				 * against it before looping
-				 */
-				last_waited = ioc->last_waited;
-				if (need_resched())
-					cond_resched();
-				continue;
-			}
 			spin_lock(&device->io_lock);
 			requeue_list(pending_bios, pending, tail);
 			device->running_pending = 1;
-- 
1.7.3.4

