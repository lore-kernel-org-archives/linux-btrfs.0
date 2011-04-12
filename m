From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH v2 1/3] btrfs: move btrfs_cmp_device_free_bytes to super.c
Date: Tue, 12 Apr 2011 12:42:29 +0200
Message-ID: <2e3828e93cb99d7ec2f288e52ef31830fa5bdc7a.1302604903.git.sensille@gmx.net>
References: <cover.1302604903.git.sensille@gmx.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1302604903.git.sensille@gmx.net>
In-Reply-To: <cover.1302604903.git.sensille@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

this function won't be used here anymore, so move it super.c where it is
used for df-calculation

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/super.c   |   25 +++++++++++++++++++++++++
 fs/btrfs/volumes.c |   13 -------------
 fs/btrfs/volumes.h |   15 ---------------
 3 files changed, 25 insertions(+), 28 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 58e7de9..6f5c426 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -889,6 +889,31 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 	return 0;
 }
 
+/* Used to sort the devices by max_avail(descending sort) */
+int btrfs_cmp_device_free_bytes(const void *dev_info1, const void *dev_info2)
+{
+	if (((struct btrfs_device_info *)dev_info1)->max_avail >
+	    ((struct btrfs_device_info *)dev_info2)->max_avail)
+		return -1;
+	else if (((struct btrfs_device_info *)dev_info1)->max_avail <
+	         ((struct btrfs_device_info *)dev_info2)->max_avail)
+		return 1;
+	else
+	return 0;
+}
+
+/*
+ * sort the devices by max_avail, in which max free extent size of each device
+ * is stored.(Descending Sort)
+ */
+static inline void btrfs_descending_sort_devices(
+					struct btrfs_device_info *devices,
+					size_t nr_devices)
+{
+	sort(devices, nr_devices, sizeof(struct btrfs_device_info),
+	     btrfs_cmp_device_free_bytes, NULL);
+}
+
 /*
  * The helper to calc the free space on the devices that can be used to store
  * file data.
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 8b9fb8c..a9f1fc2 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2282,19 +2282,6 @@ static noinline u64 chunk_bytes_by_type(u64 type, u64 calc_size,
 		return calc_size * num_stripes;
 }
 
-/* Used to sort the devices by max_avail(descending sort) */
-int btrfs_cmp_device_free_bytes(const void *dev_info1, const void *dev_info2)
-{
-	if (((struct btrfs_device_info *)dev_info1)->max_avail >
-	    ((struct btrfs_device_info *)dev_info2)->max_avail)
-		return -1;
-	else if (((struct btrfs_device_info *)dev_info1)->max_avail <
-		 ((struct btrfs_device_info *)dev_info2)->max_avail)
-		return 1;
-	else
-		return 0;
-}
-
 static int __btrfs_calc_nstripes(struct btrfs_fs_devices *fs_devices, u64 type,
 				 int *num_stripes, int *min_stripes,
 				 int *sub_stripes)
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index cc2eada..b502f01 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -157,21 +157,6 @@ struct map_lookup {
 	struct btrfs_bio_stripe stripes[];
 };
 
-/* Used to sort the devices by max_avail(descending sort) */
-int btrfs_cmp_device_free_bytes(const void *dev_info1, const void *dev_info2);
-
-/*
- * sort the devices by max_avail, in which max free extent size of each device
- * is stored.(Descending Sort)
- */
-static inline void btrfs_descending_sort_devices(
-					struct btrfs_device_info *devices,
-					size_t nr_devices)
-{
-	sort(devices, nr_devices, sizeof(struct btrfs_device_info),
-	     btrfs_cmp_device_free_bytes, NULL);
-}
-
 int btrfs_account_dev_extents_size(struct btrfs_device *device, u64 start,
 				   u64 end, u64 *length);
 
-- 
1.7.3.4

