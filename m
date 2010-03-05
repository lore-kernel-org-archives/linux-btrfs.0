From: jim owens <owens6336@gmail.com>
Subject: [PATCH 1/2] Btrfs: add multi-device minimum logical block size for
 direct I/O.
Date: Fri, 05 Mar 2010 14:42:18 -0500
Message-ID: <4B915E9A.8070507@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


In a multi-device filesystem, it is possible to have devices with
different block sizes, as in 512, 1024, 2048, 4096. DirectIO read
will check user request alignment is valid for at least one device.

Signed-off-by: jim owens <jim6336@gmail.com>
---
 fs/btrfs/volumes.c |   24 +++++++++++++++++++++++-
 fs/btrfs/volumes.h |    3 +++
 2 files changed, 26 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index d1a1b8d..5ff9878 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -573,10 +573,14 @@ static int __btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
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
 
@@ -627,6 +631,8 @@ static int __btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 			list_add(&device->dev_alloc_list,
 				 &fs_devices->alloc_list);
 		}
+		dio_min_blocksize = min_t(u32, dio_min_blocksize,
+					bdev_logical_block_size(device->bdev));
 		continue;
 
 error_brelse:
@@ -646,6 +652,7 @@ error:
 	fs_devices->latest_devid = latest_devid;
 	fs_devices->latest_trans = latest_transid;
 	fs_devices->total_rw_bytes = 0;
+	fs_devices->dio_min_blocksize = dio_min_blocksize;
 out:
 	return ret;
 }
@@ -1126,6 +1133,7 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 	u64 num_devices;
 	u8 *dev_uuid;
 	int ret = 0;
+	u32 dio_min_blocksize;
 
 	mutex_lock(&uuid_mutex);
 	mutex_lock(&root->fs_info->volume_mutex);
@@ -1277,6 +1285,14 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
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
@@ -1556,6 +1572,12 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
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
