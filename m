Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:42338 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753417AbeFDO5w (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Jun 2018 10:57:52 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w54Euxx8066118
        for <linux-btrfs@vger.kernel.org>; Mon, 4 Jun 2018 14:57:52 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2jbvynuwwr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Jun 2018 14:57:52 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w54EvpAt021493
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 4 Jun 2018 14:57:51 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w54Evpp4014782
        for <linux-btrfs@vger.kernel.org>; Mon, 4 Jun 2018 14:57:51 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] btrfs: convert volume rotating flag into bitmap
Date: Mon,  4 Jun 2018 23:00:28 +0800
Message-Id: <20180604150030.12883-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add bitmap btrfs_fs_devices::volume_state to maintain the volume states and
flags. This patch in perticular converts btrfs_fs_devices::rotating into
flag BTRFS_VOLUME_STATE_ROTATING.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/disk-io.c |  3 ++-
 fs/btrfs/volumes.c |  7 ++++---
 fs/btrfs/volumes.h | 15 ++++++++++-----
 3 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 002d20b3ed61..b3c9e1f1a11d 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3146,7 +3146,8 @@ int open_ctree(struct super_block *sb,
 		goto fail_cleaner;
 
 	if (!btrfs_test_opt(fs_info, NOSSD) &&
-	    !fs_info->fs_devices->rotating) {
+	    !test_bit(BTRFS_VOLUME_STATE_ROTATING,
+		      &fs_info->fs_devices->volume_state)) {
 		btrfs_set_and_info(fs_info, SSD, "enabling ssd optimizations");
 	}
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 16c320a7661d..0513ecd694e6 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -726,7 +726,7 @@ static int btrfs_open_one_device(struct btrfs_fs_devices *fs_devices,
 
 	q = bdev_get_queue(bdev);
 	if (!blk_queue_nonrot(q))
-		fs_devices->rotating = 1;
+		set_bit(BTRFS_VOLUME_STATE_ROTATING, &fs_devices->volume_state);
 
 	device->bdev = bdev;
 	clear_bit(BTRFS_DEV_STATE_IN_FS_METADATA, &device->dev_state);
@@ -2328,7 +2328,7 @@ static int btrfs_prepare_sprout(struct btrfs_fs_info *fs_info)
 	fs_devices->num_devices = 0;
 	fs_devices->open_devices = 0;
 	fs_devices->missing_devices = 0;
-	fs_devices->rotating = 0;
+	clear_bit(BTRFS_VOLUME_STATE_ROTATING, &fs_devices->volume_state);
 	fs_devices->seed = seed_devices;
 
 	generate_random_uuid(fs_devices->fsid);
@@ -2524,7 +2524,8 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	atomic64_add(device->total_bytes, &fs_info->free_chunk_space);
 
 	if (!blk_queue_nonrot(q))
-		fs_info->fs_devices->rotating = 1;
+		set_bit(BTRFS_VOLUME_STATE_ROTATING,
+			&fs_info->fs_devices->volume_state);
 
 	tmp = btrfs_super_total_bytes(fs_info->super_copy);
 	btrfs_set_super_total_bytes(fs_info->super_copy,
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 5139ec8daf4c..6bedfd0e918f 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -206,6 +206,14 @@ BTRFS_DEVICE_GETSET_FUNCS(total_bytes);
 BTRFS_DEVICE_GETSET_FUNCS(disk_total_bytes);
 BTRFS_DEVICE_GETSET_FUNCS(bytes_used);
 
+/*
+ * btrfs_fs_devices::volume_state bitmap
+ */
+/*
+ * Set when we find or add a device that doesn't have the nonrot flag set
+ */
+#define BTRFS_VOLUME_STATE_ROTATING	(0)
+
 struct btrfs_fs_devices {
 	u8 fsid[BTRFS_FSID_SIZE]; /* FS specific uuid */
 	struct list_head fs_list;
@@ -232,15 +240,12 @@ struct btrfs_fs_devices {
 	struct list_head alloc_list;
 
 	struct btrfs_fs_devices *seed;
+
+	unsigned long volume_state;
 	int seeding;
 
 	int opened;
 
-	/* set when we find or add a device that doesn't have the
-	 * nonrot flag set
-	 */
-	int rotating;
-
 	struct btrfs_fs_info *fs_info;
 	/* sysfs kobjects */
 	struct kobject fsid_kobj;
-- 
2.15.0

