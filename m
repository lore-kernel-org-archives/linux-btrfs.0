Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zimbra13.linbit.com ([212.69.166.240]:58643 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932844AbcDENqB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Apr 2016 09:46:01 -0400
Date: Tue, 5 Apr 2016 15:36:57 +0200
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: Neil Brown <neilb@suse.de>, Jens Axboe <axboe@kernel.dk>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [PATCH] [RFC] fix potential access after free: return value of
 blk_check_plugged() must be used schedule() safe
Message-ID: <20160405133657.GA3078@soda.linbit>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

blk_check_plugged() will return a pointer
to an object linked on current->plug->cb_list.

That list may "at any time" be implicitly cleared by
blk_flush_plug_list()
 flush_plug_callbacks()
either as a result of blk_finish_plug(),
or implicitly by schedule() [and maybe other implicit mechanisms?]

If there is no protection against an implicit unplug
between the call to blk_check_plug() and using its return value,
that implicit unplug may have already happened,
even before the plug is actually initialized or populated,
and we may be using a pointer to already free()d data.

I suggest that both raid1 and raid10 can easily be fixed
by moving the call to blk_check_plugged() inside the spinlock.

For md/raid5 and btrfs/raid56,
I'm unsure how (if) this needs to be fixed.

The other current in-tree users of blk_check_plugged()
are mm_check_plugged(), and mddev_check_plugged().

mm_check_plugged() is already used safely inside a spinlock.

with mddev_check_plugged() I'm unsure, at least on a preempt kernel.

Did I overlook any magic that protects against such implicit unplug?

Also, why pretend that a custom plug struct (such as raid1_plug_cb)
may have its member "struct blk_plug_cb cb" at an arbitrary offset?
As it is, raid1_check_plugged() below is actually just a cast.

Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/md/raid1.c  | 19 +++++++++++++------
 drivers/md/raid10.c | 21 +++++++++++++--------
 drivers/md/raid5.c  |  5 +++++
 fs/btrfs/raid56.c   |  5 +++++
 4 files changed, 36 insertions(+), 14 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 39fb21e..55dc960 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1044,6 +1044,18 @@ static void raid1_unplug(struct blk_plug_cb *cb, bool from_schedule)
 	kfree(plug);
 }
 
+static struct raid1_plug_cb *raid1_check_plugged(struct mddev *mddev)
+{
+	/* return (struct raid1_plug_cb*)blk_check_plugged(...); */
+	struct blk_plug_cb *cb;
+	struct raid1_plug_cb *plug = NULL;
+
+	cb = blk_check_plugged(raid1_unplug, mddev, sizeof(*plug));
+	if (cb)
+		plug = container_of(cb, struct raid1_plug_cb, cb);
+	return plug;
+}
+
 static void raid1_make_request(struct mddev *mddev, struct bio * bio)
 {
 	struct r1conf *conf = mddev->private;
@@ -1060,7 +1072,6 @@ static void raid1_make_request(struct mddev *mddev, struct bio * bio)
 					  & (REQ_DISCARD | REQ_SECURE));
 	const unsigned long do_same = (bio->bi_rw & REQ_WRITE_SAME);
 	struct md_rdev *blocked_rdev;
-	struct blk_plug_cb *cb;
 	struct raid1_plug_cb *plug = NULL;
 	int first_clone;
 	int sectors_handled;
@@ -1382,12 +1393,8 @@ read_again:
 
 		atomic_inc(&r1_bio->remaining);
 
-		cb = blk_check_plugged(raid1_unplug, mddev, sizeof(*plug));
-		if (cb)
-			plug = container_of(cb, struct raid1_plug_cb, cb);
-		else
-			plug = NULL;
 		spin_lock_irqsave(&conf->device_lock, flags);
+		plug = raid1_check_plugged(mddev);
 		if (plug) {
 			bio_list_add(&plug->pending, mbio);
 			plug->pending_cnt++;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index e3fd725..d7d4397 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1052,6 +1052,18 @@ static void raid10_unplug(struct blk_plug_cb *cb, bool from_schedule)
 	kfree(plug);
 }
 
+static struct raid10_plug_cb *raid10_check_plugged(struct mddev *mddev)
+{
+	/* return (struct raid1_plug_cb*)blk_check_plugged(...); */
+	struct blk_plug_cb *cb;
+	struct raid10_plug_cb *plug = NULL;
+
+	cb = blk_check_plugged(raid10_unplug, mddev, sizeof(*plug));
+	if (cb)
+		plug = container_of(cb, struct raid10_plug_cb, cb);
+	return plug;
+}
+
 static void __make_request(struct mddev *mddev, struct bio *bio)
 {
 	struct r10conf *conf = mddev->private;
@@ -1066,7 +1078,6 @@ static void __make_request(struct mddev *mddev, struct bio *bio)
 	const unsigned long do_same = (bio->bi_rw & REQ_WRITE_SAME);
 	unsigned long flags;
 	struct md_rdev *blocked_rdev;
-	struct blk_plug_cb *cb;
 	struct raid10_plug_cb *plug = NULL;
 	int sectors_handled;
 	int max_sectors;
@@ -1369,14 +1380,8 @@ retry_write:
 
 			atomic_inc(&r10_bio->remaining);
 
-			cb = blk_check_plugged(raid10_unplug, mddev,
-					       sizeof(*plug));
-			if (cb)
-				plug = container_of(cb, struct raid10_plug_cb,
-						    cb);
-			else
-				plug = NULL;
 			spin_lock_irqsave(&conf->device_lock, flags);
+			plug = raid10_check_plugged(mddev);
 			if (plug) {
 				bio_list_add(&plug->pending, mbio);
 				plug->pending_cnt++;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 8ab8b65..4e3b02b 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5034,6 +5034,11 @@ static void release_stripe_plug(struct mddev *mddev,
 	}
 
 	cb = container_of(blk_cb, struct raid5_plug_cb, cb);
+/* FIXME
+ * Nothing protects current from being scheduled, which means cb, aka plug,
+ * may implicitly be "unplugged" any time now, before it even is initialized,
+ * and will then be a pointer to free()d space.
+ */
 
 	if (cb->list.next == NULL) {
 		int i;
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 0b7792e..17757d4 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -1774,6 +1774,11 @@ int raid56_parity_write(struct btrfs_root *root, struct bio *bio,
 	cb = blk_check_plugged(btrfs_raid_unplug, root->fs_info,
 			       sizeof(*plug));
 	if (cb) {
+/* FIXME
+ * Nothing protects current from being scheduled, which means cb, aka plug,
+ * may implicitly be "unplugged" any time now, before it even is initialized,
+ * and will then be a pointer to free()d space.
+ */
 		plug = container_of(cb, struct btrfs_plug_cb, cb);
 		if (!plug->info) {
 			plug->info = root->fs_info;
-- 
1.9.1

