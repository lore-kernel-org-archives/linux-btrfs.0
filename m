From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: detect wether a device supports discard
Date: Thu,  4 Aug 2011 10:52:27 -0400
Message-ID: <1312469547-7816-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We have a problem where if a user specifies discard but doesn't actually support
it we will return EOPNOTSUPP from btrfs_discard_extent.  This is a problem
because this gets called (in a fashion) from the tree log recovery code, which
has a nice little BUG_ON(ret) after it, which causes us to fail the tree log
replay.  So instead detect wether our devices support discard when we're adding
them and then don't issue discards if we know that the device doesn't support
it.  And just for good measure set ret = 0 in btrfs_issue_discard just in case
we still get EOPNOTSUPP so we don't screw anybody up like this again.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/extent-tree.c |   12 ++++++++++--
 fs/btrfs/volumes.c     |   17 +++++++++++++++++
 fs/btrfs/volumes.h     |    2 ++
 3 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index ca57fdc..3d3a4b3 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1797,6 +1797,9 @@ int btrfs_discard_extent(struct btrfs_root *root, u64 bytenr, u64 num_bytes,
 
 
 		for (i = 0; i < multi->num_stripes; i++, stripe++) {
+			if (!stripe->dev->can_discard)
+				continue;
+
 			ret = btrfs_issue_discard(stripe->dev->bdev,
 						  stripe->physical,
 						  stripe->length);
@@ -1804,11 +1807,16 @@ int btrfs_discard_extent(struct btrfs_root *root, u64 bytenr, u64 num_bytes,
 				discarded_bytes += stripe->length;
 			else if (ret != -EOPNOTSUPP)
 				break;
+
+			/*
+			 * Just in case we get back EOPNOTSUPP for some reason,
+			 * just ignore the return value so we don't screw up
+			 * people calling discard_extent.
+			 */
+			ret = 0;
 		}
 		kfree(multi);
 	}
-	if (discarded_bytes && ret == -EOPNOTSUPP)
-		ret = 0;
 
 	if (actual_bytes)
 		*actual_bytes = discarded_bytes;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b89e372..8af3bf9 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -500,6 +500,9 @@ static int __btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
 			fs_devices->rw_devices--;
 		}
 
+		if (device->can_discard)
+			fs_devices->num_can_discard--;
+
 		new_device = kmalloc(sizeof(*new_device), GFP_NOFS);
 		BUG_ON(!new_device);
 		memcpy(new_device, device, sizeof(*new_device));
@@ -508,6 +511,7 @@ static int __btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
 		new_device->bdev = NULL;
 		new_device->writeable = 0;
 		new_device->in_fs_metadata = 0;
+		new_device->can_discard = 0;
 		list_replace_rcu(&device->dev_list, &new_device->dev_list);
 
 		call_rcu(&device->rcu, free_device);
@@ -547,6 +551,7 @@ int btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
 static int __btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 				fmode_t flags, void *holder)
 {
+	struct request_queue *q;
 	struct block_device *bdev;
 	struct list_head *head = &fs_devices->devices;
 	struct btrfs_device *device;
@@ -603,6 +608,12 @@ static int __btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 			seeding = 0;
 		}
 
+		q = bdev_get_queue(bdev);
+		if (blk_queue_discard(q)) {
+			device->can_discard = 1;
+			fs_devices->num_can_discard++;
+		}
+
 		device->bdev = bdev;
 		device->in_fs_metadata = 0;
 		device->mode = flags;
@@ -1542,6 +1553,7 @@ error:
 
 int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 {
+	struct request_queue *q;
 	struct btrfs_trans_handle *trans;
 	struct btrfs_device *device;
 	struct block_device *bdev;
@@ -1611,6 +1623,9 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 
 	lock_chunks(root);
 
+	q = bdev_get_queue(bdev);
+	if (blk_queue_discard(q))
+		device->can_discard = 1;
 	device->writeable = 1;
 	device->work.func = pending_bios_fn;
 	generate_random_uuid(device->uuid);
@@ -1646,6 +1661,8 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 	root->fs_info->fs_devices->num_devices++;
 	root->fs_info->fs_devices->open_devices++;
 	root->fs_info->fs_devices->rw_devices++;
+	if (device->can_discard)
+		root->fs_info->fs_devices->num_can_discard++;
 	root->fs_info->fs_devices->total_rw_bytes += device->total_bytes;
 
 	if (!blk_queue_nonrot(bdev_get_queue(bdev)))
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 7c12d61..6d866db 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -48,6 +48,7 @@ struct btrfs_device {
 	int writeable;
 	int in_fs_metadata;
 	int missing;
+	int can_discard;
 
 	spinlock_t io_lock;
 
@@ -104,6 +105,7 @@ struct btrfs_fs_devices {
 	u64 rw_devices;
 	u64 missing_devices;
 	u64 total_rw_bytes;
+	u64 num_can_discard;
 	struct block_device *latest_bdev;
 
 	/* all of the devices in the FS, protected by a mutex
-- 
1.7.5.2

