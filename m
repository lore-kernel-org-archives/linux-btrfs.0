From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 24/65] btrfs: run_scheduled_bios should return void
Date: Mon, 03 Oct 2011 23:22:54 -0400
Message-ID: <20111004032302.674511781@suse.com>
References: <20111004032230.458853274@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
To: BtrFS List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 run_scheduled_bios has no error conditions and should return void.
 Its callers already ignore the error code anyway.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/volumes.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -127,7 +127,7 @@ static void requeue_list(struct btrfs_pe
  * the list if the block device is congested.  This way, multiple devices
  * can make progress from a single worker thread.
  */
-static noinline int run_scheduled_bios(struct btrfs_device *device)
+static noinline void run_scheduled_bios(struct btrfs_device *device)
 {
 	struct bio *pending;
 	struct backing_dev_info *bdi;
@@ -307,7 +307,6 @@ loop_lock:
 
 done:
 	blk_finish_plug(&plug);
-	return 0;
 }
 
 static void pending_bios_fn(struct btrfs_work *work)


