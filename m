From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 27/66] btrfs: schedule_bio should return void
Date: Mon, 24 Oct 2011 21:03:03 -0400
Message-ID: <20111025010853.667370437@suse.com>
References: <20111025010236.322699279@suse.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>,
	David Sterba <dsterba@suse.com>
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


