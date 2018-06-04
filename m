Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:42368 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753417AbeFDO5y (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Jun 2018 10:57:54 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w54EttCG065542
        for <linux-btrfs@vger.kernel.org>; Mon, 4 Jun 2018 14:57:53 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2jbvynuwx5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Jun 2018 14:57:53 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w54EvrWf023210
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 4 Jun 2018 14:57:53 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w54Evqxq030979
        for <linux-btrfs@vger.kernel.org>; Mon, 4 Jun 2018 14:57:52 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] btrfs: convert volume seeding flag into bitmap
Date: Mon,  4 Jun 2018 23:00:29 +0800
Message-Id: <20180604150030.12883-2-anand.jain@oracle.com>
In-Reply-To: <20180604150030.12883-1-anand.jain@oracle.com>
References: <20180604150030.12883-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch converts btrfs_fs_devices::seeding into flag
BTRFS_VOL_FLAG_SEEDING.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/dev-replace.c |  3 ++-
 fs/btrfs/volumes.c     | 25 +++++++++++++++----------
 fs/btrfs/volumes.h     |  2 +-
 3 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index e2ba0419297a..9635a67d8836 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -195,7 +195,8 @@ static int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 	int ret = 0;
 
 	*device_out = NULL;
-	if (fs_info->fs_devices->seeding) {
+	if (test_bit(BTRFS_VOLUME_STATE_SEEDING,
+		     &fs_info->fs_devices->volume_state)) {
 		btrfs_err(fs_info, "the filesystem is a seed filesystem!");
 		return -EINVAL;
 	}
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 0513ecd694e6..87a4b12f98e3 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -716,7 +716,7 @@ static int btrfs_open_one_device(struct btrfs_fs_devices *fs_devices,
 
 	if (btrfs_super_flags(disk_super) & BTRFS_SUPER_FLAG_SEEDING) {
 		clear_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state);
-		fs_devices->seeding = 1;
+		set_bit(BTRFS_VOLUME_STATE_SEEDING, &fs_devices->volume_state);
 	} else {
 		if (bdev_read_only(bdev))
 			clear_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state);
@@ -1088,7 +1088,7 @@ static int close_fs_devices(struct btrfs_fs_devices *fs_devices)
 	WARN_ON(fs_devices->open_devices);
 	WARN_ON(fs_devices->rw_devices);
 	fs_devices->opened = 0;
-	fs_devices->seeding = 0;
+	clear_bit(BTRFS_VOLUME_STATE_SEEDING, &fs_devices->volume_state);
 
 	return 0;
 }
@@ -2152,7 +2152,8 @@ void btrfs_rm_dev_replace_free_srcdev(struct btrfs_fs_info *fs_info,
 		 * target added to the sprout FS, so there will be no more
 		 * device left under the seed FS.
 		 */
-		ASSERT(fs_devices->seeding);
+		ASSERT(test_bit(BTRFS_VOLUME_STATE_SEEDING,
+				&fs_devices->volume_state));
 
 		tmp_fs_devices = fs_info->fs_devices;
 		while (tmp_fs_devices) {
@@ -2293,7 +2294,7 @@ static int btrfs_prepare_sprout(struct btrfs_fs_info *fs_info)
 	u64 super_flags;
 
 	lockdep_assert_held(&uuid_mutex);
-	if (!fs_devices->seeding)
+	if (!test_bit(BTRFS_VOLUME_STATE_SEEDING, &fs_devices->volume_state))
 		return -EINVAL;
 
 	seed_devices = alloc_fs_devices(NULL);
@@ -2324,7 +2325,7 @@ static int btrfs_prepare_sprout(struct btrfs_fs_info *fs_info)
 	list_splice_init(&fs_devices->alloc_list, &seed_devices->alloc_list);
 	mutex_unlock(&fs_info->chunk_mutex);
 
-	fs_devices->seeding = 0;
+	clear_bit(BTRFS_VOLUME_STATE_SEEDING, &fs_devices->volume_state);
 	fs_devices->num_devices = 0;
 	fs_devices->open_devices = 0;
 	fs_devices->missing_devices = 0;
@@ -2402,7 +2403,8 @@ static int btrfs_finish_sprout(struct btrfs_trans_handle *trans,
 		device = btrfs_find_device(fs_info, devid, dev_uuid, fs_uuid);
 		BUG_ON(!device); /* Logic error */
 
-		if (device->fs_devices->seeding) {
+		if (test_bit(BTRFS_VOLUME_STATE_SEEDING,
+			     &device->fs_devices->volume_state)) {
 			btrfs_set_device_generation(leaf, dev_item,
 						    device->generation);
 			btrfs_mark_buffer_dirty(leaf);
@@ -2432,7 +2434,9 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	int ret = 0;
 	bool unlocked = false;
 
-	if (sb_rdonly(sb) && !fs_info->fs_devices->seeding)
+	if (sb_rdonly(sb) &&
+	    !test_bit(BTRFS_VOLUME_STATE_SEEDING,
+		      &fs_info->fs_devices->volume_state))
 		return -EROFS;
 
 	bdev = blkdev_get_by_path(device_path, FMODE_WRITE | FMODE_EXCL,
@@ -2440,7 +2444,8 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	if (IS_ERR(bdev))
 		return PTR_ERR(bdev);
 
-	if (fs_info->fs_devices->seeding) {
+	if (test_bit(BTRFS_VOLUME_STATE_SEEDING,
+		     &fs_info->fs_devices->volume_state)) {
 		seeding_dev = 1;
 		down_write(&sb->s_umount);
 		mutex_lock(&uuid_mutex);
@@ -6636,7 +6641,7 @@ static struct btrfs_fs_devices *open_seed_devices(struct btrfs_fs_info *fs_info,
 		if (IS_ERR(fs_devices))
 			return fs_devices;
 
-		fs_devices->seeding = 1;
+		set_bit(BTRFS_VOLUME_STATE_SEEDING, &fs_devices->volume_state);
 		fs_devices->opened = 1;
 		return fs_devices;
 	}
@@ -6652,7 +6657,7 @@ static struct btrfs_fs_devices *open_seed_devices(struct btrfs_fs_info *fs_info,
 		goto out;
 	}
 
-	if (!fs_devices->seeding) {
+	if (!test_bit(BTRFS_VOLUME_STATE_SEEDING, &fs_devices->volume_state)) {
 		close_fs_devices(fs_devices);
 		free_fs_devices(fs_devices);
 		fs_devices = ERR_PTR(-EINVAL);
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 6bedfd0e918f..cd18916f2bbc 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -213,6 +213,7 @@ BTRFS_DEVICE_GETSET_FUNCS(bytes_used);
  * Set when we find or add a device that doesn't have the nonrot flag set
  */
 #define BTRFS_VOLUME_STATE_ROTATING	(0)
+#define BTRFS_VOLUME_STATE_SEEDING	(1)
 
 struct btrfs_fs_devices {
 	u8 fsid[BTRFS_FSID_SIZE]; /* FS specific uuid */
@@ -242,7 +243,6 @@ struct btrfs_fs_devices {
 	struct btrfs_fs_devices *seed;
 
 	unsigned long volume_state;
-	int seeding;
 
 	int opened;
 
-- 
2.15.0

