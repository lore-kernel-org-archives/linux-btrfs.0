From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 47/99] btrfs: schedule_bio should return void
Date: Wed, 23 Nov 2011 19:36:20 -0500
Message-ID: <20111124004225.258451745@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
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
@@ -3268,7 +3268,7 @@ struct async_sched {
  * This will add one bio to the pending list for a device and make sure
  * the work struct is scheduled.
  */
-static noinline int schedule_bio(struct btrfs_root *root,
+static noinline void schedule_bio(struct btrfs_root *root,
 				 struct btrfs_device *device,
 				 int rw, struct bio *bio)
 {
@@ -3280,7 +3280,6 @@ static noinline int schedule_bio(struct
 		bio_get(bio);
 		submit_bio(rw, bio);
 		bio_put(bio);
-		return 0;
 	}
 
 	/*
@@ -3314,7 +3313,6 @@ static noinline int schedule_bio(struct
 	if (should_queue)
 		btrfs_queue_worker(&root->fs_info->submit_workers,
 				   &device->work);
-	return 0;
 }
 
 int btrfs_map_bio(struct btrfs_root *root, int rw, struct bio *bio,



