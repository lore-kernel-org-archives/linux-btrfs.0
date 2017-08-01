Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33498 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751910AbdHARP4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Aug 2017 13:15:56 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v71HFtOa002182
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 1 Aug 2017 17:15:56 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v71HFtb7021647
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 1 Aug 2017 17:15:55 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v71HFtDK002198
        for <linux-btrfs@vger.kernel.org>; Tue, 1 Aug 2017 17:15:55 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 12/14] Btrfs: raid56: fix error handling while adding a log device
Date: Tue,  1 Aug 2017 10:14:35 -0600
Message-Id: <20170801161439.13426-13-bo.li.liu@oracle.com>
In-Reply-To: <20170801161439.13426-1-bo.li.liu@oracle.com>
References: <20170801161439.13426-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently there is a memory leak if we have an error while adding a
raid5/6 log.  Moreover, it didn't abort the transaction as others do,
so this is fixing the broken error handling by applying two steps on
initializing the log, step #1 is to allocate memory, check if it has a
proper size, and step #2 is to assign the pointer in %fs_info.  And by
running step #1 ahead of starting transaction, we can gracefully bail
out on errors now.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/raid56.c  | 48 +++++++++++++++++++++++++++++++++++++++++-------
 fs/btrfs/raid56.h  |  5 +++++
 fs/btrfs/volumes.c | 36 ++++++++++++++++++++++--------------
 3 files changed, 68 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 8bc7ba4..0bfc97a 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -3711,30 +3711,64 @@ void raid56_submit_missing_rbio(struct btrfs_raid_bio *rbio)
 		async_missing_raid56(rbio);
 }
 
-int btrfs_set_r5log(struct btrfs_fs_info *fs_info, struct btrfs_device *device)
+struct btrfs_r5l_log * btrfs_r5l_init_log_prepare(struct btrfs_fs_info *fs_info, struct btrfs_device *device, struct block_device *bdev)
 {
-	struct btrfs_r5l_log *log;
-
-	log = kzalloc(sizeof(*log), GFP_NOFS);
+	int num_devices = fs_info->fs_devices->num_devices;
+	u64 dev_total_bytes;
+	struct btrfs_r5l_log *log = kzalloc(sizeof(struct btrfs_r5l_log), GFP_NOFS);
 	if (!log)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
+
+	ASSERT(device);
+	ASSERT(bdev);
+	dev_total_bytes = i_size_read(bdev->bd_inode);
 
 	/* see find_free_dev_extent for 1M start offset */
 	log->data_offset = 1024ull * 1024;
-	log->device_size = btrfs_device_get_total_bytes(device) - log->data_offset;
+	log->device_size = dev_total_bytes - log->data_offset;
 	log->device_size = round_down(log->device_size, PAGE_SIZE);
+
+	/*
+	 * when device has been included in fs_devices, do not take
+	 * into account this device when checking log size.
+	 */
+	if (device->in_fs_metadata)
+		num_devices--;
+
+	if (log->device_size < BTRFS_STRIPE_LEN * num_devices * 2) {
+		btrfs_info(fs_info, "r5log log device size (%llu < %llu) is too small", log->device_size, BTRFS_STRIPE_LEN * num_devices * 2);
+		kfree(log);
+		return ERR_PTR(-EINVAL);
+	}
+
 	log->dev = device;
 	log->fs_info = fs_info;
 	ASSERT(sizeof(device->uuid) == BTRFS_UUID_SIZE);
 	log->uuid_csum = btrfs_crc32c(~0, device->uuid, sizeof(device->uuid));
 	mutex_init(&log->io_mutex);
 
+	return log;
+}
+
+void btrfs_r5l_init_log_post(struct btrfs_fs_info *fs_info, struct btrfs_r5l_log *log)
+{
 	cmpxchg(&fs_info->r5log, NULL, log);
 	ASSERT(fs_info->r5log == log);
 
 #ifdef BTRFS_DEBUG_R5LOG
-	trace_printk("r5log: set a r5log in fs_info,  alloc_range 0x%llx 0x%llx",
+	trace_printk("r5log: set a r5log in fs_info,  alloc_range 0x%llx 0x%llx\n",
 		     log->data_offset, log->data_offset + log->device_size);
 #endif
+}
+
+int btrfs_set_r5log(struct btrfs_fs_info *fs_info, struct btrfs_device *device)
+{
+	struct btrfs_r5l_log *log;
+
+	log = btrfs_r5l_init_log_prepare(fs_info, device, device->bdev);
+	if (IS_ERR(log))
+		return PTR_ERR(log);
+
+	btrfs_r5l_init_log_post(fs_info, log);
 	return 0;
 }
diff --git a/fs/btrfs/raid56.h b/fs/btrfs/raid56.h
index 569cec8..f6d6f36 100644
--- a/fs/btrfs/raid56.h
+++ b/fs/btrfs/raid56.h
@@ -134,6 +134,11 @@ void raid56_submit_missing_rbio(struct btrfs_raid_bio *rbio);
 
 int btrfs_alloc_stripe_hash_table(struct btrfs_fs_info *info);
 void btrfs_free_stripe_hash_table(struct btrfs_fs_info *info);
+struct btrfs_r5l_log * btrfs_r5l_init_log_prepare(struct btrfs_fs_info *fs_info,
+						  struct btrfs_device *device,
+						  struct block_device *bdev);
+void btrfs_r5l_init_log_post(struct btrfs_fs_info *fs_info,
+			     struct btrfs_r5l_log *log);
 int btrfs_set_r5log(struct btrfs_fs_info *fs_info, struct btrfs_device *device);
 int btrfs_r5l_load_log(struct btrfs_fs_info *fs_info, u64 cp);
 #endif
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index ac64d93..851c001 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2327,6 +2327,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	int seeding_dev = 0;
 	int ret = 0;
 	bool is_r5log = (flags & BTRFS_DEVICE_RAID56_LOG);
+	struct btrfs_r5l_log *r5log = NULL;
 
 	if (is_r5log)
 		ASSERT(!fs_info->fs_devices->seeding);
@@ -2367,6 +2368,15 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 		goto error;
 	}
 
+	if (is_r5log) {
+		r5log = btrfs_r5l_init_log_prepare(fs_info, device, bdev);
+		if (IS_ERR(r5log)) {
+			kfree(device);
+			ret = PTR_ERR(r5log);
+			goto error;
+		}
+	}
+
 	name = rcu_string_strdup(device_path, GFP_KERNEL);
 	if (!name) {
 		kfree(device);
@@ -2467,12 +2477,6 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 		goto error_trans;
 	}
 
-	if (is_r5log) {
-		ret = btrfs_set_r5log(fs_info, device);
-		if (ret)
-			goto error_trans;
-	}
-
 	if (seeding_dev) {
 		char fsid_buf[BTRFS_UUID_UNPARSED_SIZE];
 
@@ -2516,6 +2520,10 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 		ret = btrfs_commit_transaction(trans);
 	}
 
+	if (is_r5log) {
+		btrfs_r5l_init_log_post(fs_info, r5log);
+	}
+
 	/* Update ctime/mtime for libblkid */
 	update_dev_time(device_path);
 	return ret;
@@ -6701,6 +6709,14 @@ static int read_one_dev(struct btrfs_fs_info *fs_info,
 	}
 
 	fill_device_from_item(leaf, dev_item, device);
+	device->in_fs_metadata = 1;
+	if (device->writeable && !device->is_tgtdev_for_dev_replace) {
+		device->fs_devices->total_rw_bytes += device->total_bytes;
+		spin_lock(&fs_info->free_chunk_lock);
+		fs_info->free_chunk_space += device->total_bytes -
+			device->bytes_used;
+		spin_unlock(&fs_info->free_chunk_lock);
+	}
 
 	if (device->type & BTRFS_DEV_RAID56_LOG) {
 		ret = btrfs_set_r5log(fs_info, device);
@@ -6713,14 +6729,6 @@ static int read_one_dev(struct btrfs_fs_info *fs_info,
 			   device->devid, device->uuid);
 	}
 
-	device->in_fs_metadata = 1;
-	if (device->writeable && !device->is_tgtdev_for_dev_replace) {
-		device->fs_devices->total_rw_bytes += device->total_bytes;
-		spin_lock(&fs_info->free_chunk_lock);
-		fs_info->free_chunk_space += device->total_bytes -
-			device->bytes_used;
-		spin_unlock(&fs_info->free_chunk_lock);
-	}
 	ret = 0;
 	return ret;
 }
-- 
2.9.4

