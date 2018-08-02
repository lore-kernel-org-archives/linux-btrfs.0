Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm03.jp.fujitsu.com ([202.219.69.170]:53731 "EHLO
        mgwkm03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726106AbeHBJJr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Aug 2018 05:09:47 -0400
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
        by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 23DEEAC016F
        for <linux-btrfs@vger.kernel.org>; Thu,  2 Aug 2018 16:19:52 +0900 (JST)
Received: from g01jpexchkw38.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw03.exch.g01.fujitsu.local (Postfix) with ESMTP id 4917BBD67E7
        for <linux-btrfs@vger.kernel.org>; Thu,  2 Aug 2018 16:19:51 +0900 (JST)
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH] btrfs: Use wrapper macro for rcu string to remove duplicate
 code
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <cover.1533189995.git.misono.tomohiro@jp.fujitsu.com>
Message-ID: <0181282c-c4e3-3193-8320-57b2ec3019dc@jp.fujitsu.com>
Date: Thu, 2 Aug 2018 16:19:07 +0900
MIME-Version: 1.0
In-Reply-To: <cover.1533189995.git.misono.tomohiro@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Cleanup patch and no functional changes.

Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
---
 fs/btrfs/ioctl.c   |  6 ++----
 fs/btrfs/scrub.c   |  8 ++------
 fs/btrfs/super.c   |  9 +++------
 fs/btrfs/volumes.c | 21 ++++++---------------
 4 files changed, 13 insertions(+), 31 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index b077544b5232..2becabe2aaf4 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3165,10 +3165,8 @@ static long btrfs_ioctl_dev_info(struct btrfs_fs_info *fs_info,
 	di_args->total_bytes = btrfs_device_get_total_bytes(dev);
 	memcpy(di_args->uuid, dev->uuid, sizeof(di_args->uuid));
 	if (dev->name) {
-		struct rcu_string *name;
-
-		name = rcu_dereference(dev->name);
-		strncpy(di_args->path, name->str, sizeof(di_args->path) - 1);
+		strncpy(di_args->path, rcu_str_deref(dev->name),
+				sizeof(di_args->path) - 1);
 		di_args->path[sizeof(di_args->path) - 1] = 0;
 	} else {
 		di_args->path[0] = '\0';
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 6702896cdb8f..5a282268deee 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -4113,7 +4113,6 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 	struct scrub_ctx *sctx;
 	int ret;
 	struct btrfs_device *dev;
-	struct rcu_string *name;
 
 	if (btrfs_fs_closing(fs_info))
 		return -EINVAL;
@@ -4167,11 +4166,8 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 	if (!is_dev_replace && !readonly &&
 	    !test_bit(BTRFS_DEV_STATE_WRITEABLE, &dev->dev_state)) {
 		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
-		rcu_read_lock();
-		name = rcu_dereference(dev->name);
-		btrfs_err(fs_info, "scrub: device %s is not writable",
-			  name->str);
-		rcu_read_unlock();
+		btrfs_err_in_rcu(fs_info, "scrub: device %s is not writable",
+			  rcu_str_deref(dev->name));
 		return -EROFS;
 	}
 
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 81107ad49f3a..d9f00704f4aa 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2290,7 +2290,6 @@ static int btrfs_show_devname(struct seq_file *m, struct dentry *root)
 	struct btrfs_fs_devices *cur_devices;
 	struct btrfs_device *dev, *first_dev = NULL;
 	struct list_head *head;
-	struct rcu_string *name;
 
 	/*
 	 * Lightweight locking of the devices. We should not need
@@ -2314,12 +2313,10 @@ static int btrfs_show_devname(struct seq_file *m, struct dentry *root)
 		cur_devices = cur_devices->seed;
 	}
 
-	if (first_dev) {
-		name = rcu_dereference(first_dev->name);
-		seq_escape(m, name->str, " \t\n\\");
-	} else {
+	if (first_dev)
+		seq_escape(m, rcu_str_deref(first_dev->name), " \t\n\\");
+	else
 		WARN_ON(1);
-	}
 	rcu_read_unlock();
 	return 0;
 }
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 1da162928d1a..d30bbc3cf921 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6187,21 +6187,12 @@ static void submit_stripe_bio(struct btrfs_bio *bbio, struct bio *bio,
 	btrfs_io_bio(bio)->stripe_index = dev_nr;
 	bio->bi_end_io = btrfs_end_bio;
 	bio->bi_iter.bi_sector = physical >> 9;
-#ifdef DEBUG
-	{
-		struct rcu_string *name;
-
-		rcu_read_lock();
-		name = rcu_dereference(dev->name);
-		btrfs_debug(fs_info,
-			"btrfs_map_bio: rw %d 0x%x, sector=%llu, dev=%lu (%s id %llu), size=%u",
-			bio_op(bio), bio->bi_opf,
-			(u64)bio->bi_iter.bi_sector,
-			(u_long)dev->bdev->bd_dev, name->str, dev->devid,
-			bio->bi_iter.bi_size);
-		rcu_read_unlock();
-	}
-#endif
+	btrfs_debug_in_rcu(fs_info,
+		"btrfs_map_bio: rw %d 0x%x, sector=%llu, dev=%lu (%s id %llu), size=%u",
+		bio_op(bio), bio->bi_opf,
+		(u64)bio->bi_iter.bi_sector,
+		(u_long)dev->bdev->bd_dev, rcu_str_deref(dev->name), dev->devid,
+		bio->bi_iter.bi_size);
 	bio_set_dev(bio, dev->bdev);
 
 	btrfs_bio_counter_inc_noblocked(fs_info);
-- 
2.14.4


