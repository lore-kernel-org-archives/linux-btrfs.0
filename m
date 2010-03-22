From: jim owens <owens6336@gmail.com>
Subject: [PATCH V3 14/18] Btrfs: add multi-device minimum logical block size
 for direct I/O.
Date: Sun, 21 Mar 2010 23:31:35 -0400
Message-ID: <4BA6E497.5080801@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


In a multi-device filesystem, it is possible to have devices with
different block sizes, as in 512, 1024, 2048, 4096. DirectIO read
will check user request alignment is valid for at least one device.

Signed-off-by: jim owens <owens6336@gmail.com>
---
 fs/btrfs/volumes.c |   24 +++++++++++++++++++++++-
 fs/btrfs/volumes.h |    3 +++
 2 files changed, 26 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index aedef39..a7697ef 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -580,10 +580,14 @@ static int __btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 	u64 devid;
 	int seeding = 1;
 	int ret = 0;
+	u32 dio_min_blocksize = PAGE_SIZE;
 
 	list_for_each_entry(device, head, dev_list) {
-		if (device->bdev)
+		if (device->bdev) {
+			dio_min_blocksize = min_t(u32, dio_min_blocksize,
+					bdev_logical_block_size(device->bdev));
 			continue;
+		}
 		if (!device->name)
 			continue;
 
@@ -634,6 +638,8 @@ static int __btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 			list_add(&device->dev_alloc_list,
 				 &fs_devices->alloc_list);
 		}
+		dio_min_blocksize = min_t(u32, dio_min_blocksize,
+					bdev_logical_block_size(device->bdev));
 		continue;
 
 error_brelse:
@@ -653,6 +659,7 @@ error:
 	fs_devices->latest_devid = latest_devid;
 	fs_devices->latest_trans = latest_transid;
 	fs_devices->total_rw_bytes = 0;
+	fs_devices->dio_min_blocksize = dio_min_blocksize;
 out:
 	return ret;
 }
@@ -1133,6 +1140,7 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 	u64 num_devices;
 	u8 *dev_uuid;
 	int ret = 0;
+	u32 dio_min_blocksize;
 
 	mutex_lock(&uuid_mutex);
 	mutex_lock(&root->fs_info->volume_mutex);
@@ -1284,6 +1292,14 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 	kfree(device);
 	ret = 0;
 
+	dio_min_blocksize = PAGE_SIZE;
+	list_for_each_entry(device,
+				&root->fs_info->fs_devices->devices, dev_list)
+		if (device->bdev)
+			dio_min_blocksize = min_t(u32, dio_min_blocksize,
+					bdev_logical_block_size(device->bdev));
+	root->fs_info->fs_devices->dio_min_blocksize = dio_min_blocksize;
+
 error_brelse:
 	brelse(bh);
 error_close:
@@ -1563,6 +1579,12 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 		ret = btrfs_relocate_sys_chunks(root);
 		BUG_ON(ret);
 	}
+
+	if (!ret)
+		root->fs_info->fs_devices->dio_min_blocksize = min_t(u32,
+			root->fs_info->fs_devices->dio_min_blocksize,
+			bdev_logical_block_size(bdev));
+
 out:
 	mutex_unlock(&root->fs_info->volume_mutex);
 	return ret;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 732c8c5..cce6039 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -117,6 +117,9 @@ struct btrfs_fs_devices {
 	 * nonrot flag set
 	 */
 	int rotating;
+
+	/* smallest logical blocksize possible in file system for direct IO */
+	u32 dio_min_blocksize;
 };
 
 struct btrfs_bio_stripe {
-- 
1.6.3.3
