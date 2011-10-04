From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 26/65] btrfs: schedule_bio should return void
Date: Mon, 03 Oct 2011 23:22:56 -0400
Message-ID: <20111004032302.902705164@suse.com>
References: <20111004032230.458853274@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
To: BtrFS List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 schedule_bio has no error conditions and should return void. Its callers
 already ignore the error code anyway.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/volumes.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3243,7 +3243,7 @@ struct async_sched {
  * This will add one bio to the pending list for a device and make sure
  * the work struct is scheduled.
  */
-static noinline int schedule_bio(struct btrfs_root *root,
+static noinline void schedule_bio(struct btrfs_root *root,
 				 struct btrfs_device *device,
 				 int rw, struct bio *bio)
 {
@@ -3255,7 +3255,6 @@ static noinline int schedule_bio(struct
 		bio_get(bio);
 		submit_bio(rw, bio);
 		bio_put(bio);
-		return 0;
 	}
 
 	/*
@@ -3289,7 +3288,6 @@ static noinline int schedule_bio(struct
 	if (should_queue)
 		btrfs_queue_worker(&root->fs_info->submit_workers,
 				   &device->work);
-	return 0;
 }
 
 int btrfs_map_bio(struct btrfs_root *root, int rw, struct bio *bio,


