Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:55737 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030401AbaGCJfl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jul 2014 05:35:41 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s639ZaIj009558
	for <linux-btrfs@vger.kernel.org>; Thu, 3 Jul 2014 17:35:36 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/4] btrfs-progs: Allow btrfs_read_dev_super() to read all 3 super for super_recover.
Date: Thu, 3 Jul 2014 17:36:36 +0800
Message-ID: <1404380198-25948-3-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1404380198-25948-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1404380198-25948-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs-progs superblock checksum check is somewhat too restricted for
super-recover, since current btrfs-progs will only read the 1st
superblock and if you need super-recover the 1st superblock is
possibly already damaged.

The fix is introducing super_recover parameter for
btrfs_read_dev_super() and callers to allow scan backup superblocks if
needed.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-find-root.c |  4 ++--
 chunk-recover.c   |  6 +++---
 cmds-filesystem.c |  2 +-
 disk-io.c         | 17 ++++++++++-------
 disk-io.h         |  5 +++--
 super-recover.c   |  2 +-
 utils.c           | 11 ++++++-----
 volumes.c         |  4 ++--
 volumes.h         |  2 +-
 9 files changed, 29 insertions(+), 24 deletions(-)

diff --git a/btrfs-find-root.c b/btrfs-find-root.c
index 25d79f1..e31a9b5 100644
--- a/btrfs-find-root.c
+++ b/btrfs-find-root.c
@@ -82,7 +82,7 @@ static struct btrfs_root *open_ctree_broken(int fd, const char *device)
 		return NULL;
 	}
 
-	ret = btrfs_scan_fs_devices(fd, device, &fs_devices, 0, 1);
+	ret = btrfs_scan_fs_devices(fd, device, &fs_devices, 0, 1, 1);
 	if (ret)
 		goto out;
 
@@ -94,7 +94,7 @@ static struct btrfs_root *open_ctree_broken(int fd, const char *device)
 
 	disk_super = fs_info->super_copy;
 	ret = btrfs_read_dev_super(fs_devices->latest_bdev,
-				   disk_super, fs_info->super_bytenr);
+				   disk_super, fs_info->super_bytenr, 1);
 	if (ret) {
 		printk("No valid btrfs found\n");
 		goto out_devices;
diff --git a/chunk-recover.c b/chunk-recover.c
index 613d715..9baedd7 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -1283,7 +1283,7 @@ open_ctree_with_broken_chunk(struct recover_control *rc)
 
 	disk_super = fs_info->super_copy;
 	ret = btrfs_read_dev_super(fs_info->fs_devices->latest_bdev,
-				   disk_super, fs_info->super_bytenr);
+				   disk_super, fs_info->super_bytenr, 1);
 	if (ret) {
 		fprintf(stderr, "No valid btrfs found\n");
 		goto out_devices;
@@ -1349,7 +1349,7 @@ static int recover_prepare(struct recover_control *rc, char *path)
 		goto fail_close_fd;
 	}
 
-	ret = btrfs_read_dev_super(fd, sb, BTRFS_SUPER_INFO_OFFSET);
+	ret = btrfs_read_dev_super(fd, sb, BTRFS_SUPER_INFO_OFFSET, 1);
 	if (ret) {
 		fprintf(stderr, "read super block error\n");
 		goto fail_free_sb;
@@ -1368,7 +1368,7 @@ static int recover_prepare(struct recover_control *rc, char *path)
 		goto fail_free_sb;
 	}
 
-	ret = btrfs_scan_fs_devices(fd, path, &fs_devices, 0, 1);
+	ret = btrfs_scan_fs_devices(fd, path, &fs_devices, 0, 1, 1);
 	if (ret)
 		goto fail_free_sb;
 
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 306f715..d2e46dc 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -513,7 +513,7 @@ static int dev_to_fsid(char *dev, __u8 *fsid)
 
 	disk_super = (struct btrfs_super_block *)buf;
 	ret = btrfs_read_dev_super(fd, disk_super,
-			BTRFS_SUPER_INFO_OFFSET);
+				   BTRFS_SUPER_INFO_OFFSET, 0);
 	if (ret)
 		goto out;
 
diff --git a/disk-io.c b/disk-io.c
index e447af8..1bd9fae 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -980,7 +980,7 @@ void btrfs_cleanup_all_caches(struct btrfs_fs_info *fs_info)
 
 int btrfs_scan_fs_devices(int fd, const char *path,
 			  struct btrfs_fs_devices **fs_devices,
-			  u64 sb_bytenr, int run_ioctl)
+			  u64 sb_bytenr, int run_ioctl, int super_recover)
 {
 	u64 total_devs;
 	int ret;
@@ -988,7 +988,7 @@ int btrfs_scan_fs_devices(int fd, const char *path,
 		sb_bytenr = BTRFS_SUPER_INFO_OFFSET;
 
 	ret = btrfs_scan_one_device(fd, path, fs_devices,
-				    &total_devs, sb_bytenr);
+				    &total_devs, sb_bytenr, super_recover);
 	if (ret) {
 		fprintf(stderr, "No valid Btrfs found on %s\n", path);
 		return ret;
@@ -1076,7 +1076,8 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 		fs_info->on_restoring = 1;
 
 	ret = btrfs_scan_fs_devices(fp, path, &fs_devices, sb_bytenr,
-				    !(flags & OPEN_CTREE_RECOVER_SUPER));
+				    !(flags & OPEN_CTREE_RECOVER_SUPER),
+				    (flags & OPEN_CTREE_RECOVER_SUPER));
 	if (ret)
 		goto out;
 
@@ -1096,9 +1097,9 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 	disk_super = fs_info->super_copy;
 	if (!(flags & OPEN_CTREE_RECOVER_SUPER))
 		ret = btrfs_read_dev_super(fs_devices->latest_bdev,
-					   disk_super, sb_bytenr);
+					   disk_super, sb_bytenr, 1);
 	else
-		ret = btrfs_read_dev_super(fp, disk_super, sb_bytenr);
+		ret = btrfs_read_dev_super(fp, disk_super, sb_bytenr, 0);
 	if (ret) {
 		printk("No valid btrfs found\n");
 		goto out_devices;
@@ -1182,7 +1183,8 @@ struct btrfs_root *open_ctree_fd(int fp, const char *path, u64 sb_bytenr,
 	return info->fs_root;
 }
 
-int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr)
+int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr,
+			 int recover_super)
 {
 	u8 fsid[BTRFS_FSID_SIZE];
 	int fsid_is_initialized = 0;
@@ -1190,6 +1192,7 @@ int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr)
 	struct btrfs_super_block *buf = (struct btrfs_super_block *) data;
 	int i;
 	int ret;
+	int max_super = recover_super ? BTRFS_SUPER_MIRROR_MAX : 1;
 	u64 transid = 0;
 	u64 bytenr;
 	u32 crc;
@@ -1215,7 +1218,7 @@ int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr)
 	* later supers, using BTRFS_SUPER_MIRROR_MAX instead
 	*/
 
-	for (i = 0; i < 1; i++) {
+	for (i = 0; i < max_super; i++) {
 		bytenr = btrfs_sb_offset(i);
 		ret = pread64(fd, data, sizeof(data), bytenr);
 		if (ret < sizeof(data))
diff --git a/disk-io.h b/disk-io.h
index 941a3da..13d4420 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -68,7 +68,7 @@ void btrfs_release_all_roots(struct btrfs_fs_info *fs_info);
 void btrfs_cleanup_all_caches(struct btrfs_fs_info *fs_info);
 int btrfs_scan_fs_devices(int fd, const char *path,
 			  struct btrfs_fs_devices **fs_devices, u64 sb_bytenr,
-			  int run_ioctl);
+			  int run_ioctl, int super_recover);
 int btrfs_setup_chunk_tree_and_device_map(struct btrfs_fs_info *fs_info);
 
 struct btrfs_root *open_ctree(const char *filename, u64 sb_bytenr,
@@ -82,7 +82,8 @@ int close_ctree(struct btrfs_root *root);
 int write_all_supers(struct btrfs_root *root);
 int write_ctree_super(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *root);
-int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr);
+int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr,
+			 int super_recover);
 int btrfs_map_bh_to_logical(struct btrfs_root *root, struct extent_buffer *bh,
 			    u64 logical);
 struct extent_buffer *btrfs_find_tree_block(struct btrfs_root *root,
diff --git a/super-recover.c b/super-recover.c
index cd6ba37..767de4b 100644
--- a/super-recover.c
+++ b/super-recover.c
@@ -292,7 +292,7 @@ int btrfs_recover_superblocks(const char *dname,
 	}
 	init_recover_superblock(&recover);
 
-	ret = btrfs_scan_fs_devices(fd, dname, &recover.fs_devices, 0, 0);
+	ret = btrfs_scan_fs_devices(fd, dname, &recover.fs_devices, 0, 0, 1);
 	close(fd);
 	if (ret) {
 		ret = 1;
diff --git a/utils.c b/utils.c
index e130849..b0c24b1 100644
--- a/utils.c
+++ b/utils.c
@@ -1017,7 +1017,7 @@ int check_mounted_where(int fd, const char *file, char *where, int size,
 
 	/* scan the initial device */
 	ret = btrfs_scan_one_device(fd, file, &fs_devices_mnt,
-				    &total_devs, BTRFS_SUPER_INFO_OFFSET);
+				    &total_devs, BTRFS_SUPER_INFO_OFFSET, 0);
 	is_btrfs = (ret >= 0);
 
 	/* scan other devices */
@@ -1179,7 +1179,7 @@ again:
 		}
 		ret = btrfs_scan_one_device(fd, fullpath, &tmp_devices,
 					    &num_devices,
-					    BTRFS_SUPER_INFO_OFFSET);
+					    BTRFS_SUPER_INFO_OFFSET, 0);
 		if (ret == 0 && run_ioctl > 0) {
 			btrfs_register_one_device(fullpath);
 		}
@@ -1522,7 +1522,7 @@ scan_again:
 		}
 		ret = btrfs_scan_one_device(fd, fullpath, &tmp_devices,
 					    &num_devices,
-					    BTRFS_SUPER_INFO_OFFSET);
+					    BTRFS_SUPER_INFO_OFFSET, 0);
 		if (ret == 0 && run_ioctl > 0) {
 			btrfs_register_one_device(fullpath);
 		}
@@ -1696,7 +1696,8 @@ int get_fs_info(char *path, struct btrfs_ioctl_fs_info_args *fi_args,
 		fi_args->num_devices = 1;
 
 		disk_super = (struct btrfs_super_block *)buf;
-		ret = btrfs_read_dev_super(fd, disk_super, BTRFS_SUPER_INFO_OFFSET);
+		ret = btrfs_read_dev_super(fd, disk_super,
+					   BTRFS_SUPER_INFO_OFFSET, 0);
 		if (ret < 0) {
 			ret = -EIO;
 			goto out;
@@ -2045,7 +2046,7 @@ int btrfs_scan_lblkid(int update_kernel)
 			continue;
 		}
 		ret = btrfs_scan_one_device(fd, path, &tmp_devices,
-				&num_devices, BTRFS_SUPER_INFO_OFFSET);
+				&num_devices, BTRFS_SUPER_INFO_OFFSET, 0);
 		if (ret) {
 			printf("ERROR: could not scan %s\n", path);
 			close (fd);
diff --git a/volumes.c b/volumes.c
index a61928c..fa17ce1 100644
--- a/volumes.c
+++ b/volumes.c
@@ -232,7 +232,7 @@ fail:
 
 int btrfs_scan_one_device(int fd, const char *path,
 			  struct btrfs_fs_devices **fs_devices_ret,
-			  u64 *total_devs, u64 super_offset)
+			  u64 *total_devs, u64 super_offset, int super_recover)
 {
 	struct btrfs_super_block *disk_super;
 	char *buf;
@@ -245,7 +245,7 @@ int btrfs_scan_one_device(int fd, const char *path,
 		goto error;
 	}
 	disk_super = (struct btrfs_super_block *)buf;
-	ret = btrfs_read_dev_super(fd, disk_super, super_offset);
+	ret = btrfs_read_dev_super(fd, disk_super, super_offset, super_recover);
 	if (ret < 0) {
 		ret = -EIO;
 		goto error_brelse;
diff --git a/volumes.h b/volumes.h
index b1ff3d0..70afa54 100644
--- a/volumes.h
+++ b/volumes.h
@@ -178,7 +178,7 @@ int btrfs_update_device(struct btrfs_trans_handle *trans,
 			struct btrfs_device *device);
 int btrfs_scan_one_device(int fd, const char *path,
 			  struct btrfs_fs_devices **fs_devices_ret,
-			  u64 *total_devs, u64 super_offset);
+			  u64 *total_devs, u64 super_offset, int super_recover);
 int btrfs_num_copies(struct btrfs_mapping_tree *map_tree, u64 logical, u64 len);
 struct list_head *btrfs_scanned_uuids(void);
 int btrfs_add_system_chunk(struct btrfs_trans_handle *trans,
-- 
2.0.1

