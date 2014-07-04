Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:60044 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752120AbaGDBoc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jul 2014 21:44:32 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH v2 3/4] btrfs-progs: Add more meaningful return value for btrfs_read_dev_super() and corresponding error string.
Date: Fri, 4 Jul 2014 09:45:16 +0800
Message-ID: <1404438316-24437-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since btrfs_read_dev_super() now can distinguish non-btrfs fs and
corrupted superblock thanks for the newly introduced super csum check,
the return value and corresponding error string should also be updated
to print more meaningful errors for end users.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v2:
  Use fprintf(stderr,) to replace the old printk.
---
 btrfs-find-root.c |  5 ++++-
 chunk-recover.c   | 10 ++++++++--
 cmds-filesystem.c |  7 ++++++-
 disk-io.c         | 36 ++++++++++++++++++++++++++----------
 utils.c           |  5 ++++-
 volumes.c         |  4 +---
 6 files changed, 49 insertions(+), 18 deletions(-)

diff --git a/btrfs-find-root.c b/btrfs-find-root.c
index e31a9b5..7932308 100644
--- a/btrfs-find-root.c
+++ b/btrfs-find-root.c
@@ -96,7 +96,10 @@ static struct btrfs_root *open_ctree_broken(int fd, const char *device)
 	ret = btrfs_read_dev_super(fs_devices->latest_bdev,
 				   disk_super, fs_info->super_bytenr, 1);
 	if (ret) {
-		printk("No valid btrfs found\n");
+		if (ret == -ENOENT)
+			fprintf(stderr, "No valid btrfs found\n");
+		if (ret == -EIO)
+			fprintf(stderr, "Superblock is corrupted\n");
 		goto out_devices;
 	}
 
diff --git a/chunk-recover.c b/chunk-recover.c
index 9baedd7..4a16110 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -1285,7 +1285,10 @@ open_ctree_with_broken_chunk(struct recover_control *rc)
 	ret = btrfs_read_dev_super(fs_info->fs_devices->latest_bdev,
 				   disk_super, fs_info->super_bytenr, 1);
 	if (ret) {
-		fprintf(stderr, "No valid btrfs found\n");
+		if (ret == -ENOENT)
+			fprintf(stderr, "No valid btrfs found\n");
+		if (ret == -EIO)
+			fprintf(stderr, "Superblock is corrupted\n");
 		goto out_devices;
 	}
 
@@ -1351,7 +1354,10 @@ static int recover_prepare(struct recover_control *rc, char *path)
 
 	ret = btrfs_read_dev_super(fd, sb, BTRFS_SUPER_INFO_OFFSET, 1);
 	if (ret) {
-		fprintf(stderr, "read super block error\n");
+		if (ret == -ENOENT)
+			fprintf(stderr, "No valid btrfs found\n");
+		if (ret == -EIO)
+			fprintf(stderr, "Superblock is corrupted\n");
 		goto fail_free_sb;
 	}
 
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index d2e46dc..d58397d 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -604,9 +604,14 @@ static int cmd_show(int argc, char **argv)
 				} else {
 					ret = dev_to_fsid(search, fsid);
 					if (ret) {
-						fprintf(stderr,
+						if (ret == -ENOENT)
+							fprintf(stderr,
 							"ERROR: No btrfs on %s\n",
 							search);
+						if (ret == -EIO)
+							fprintf(stderr,
+							"Superblock is corrupted on %s\n",
+							search);
 						return 1;
 					}
 					uuid_unparse(fsid, uuid_buf);
diff --git a/disk-io.c b/disk-io.c
index 1bd9fae..5ee7edd 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -990,7 +990,11 @@ int btrfs_scan_fs_devices(int fd, const char *path,
 	ret = btrfs_scan_one_device(fd, path, fs_devices,
 				    &total_devs, sb_bytenr, super_recover);
 	if (ret) {
-		fprintf(stderr, "No valid Btrfs found on %s\n", path);
+		if (ret == -ENOENT)
+			fprintf(stderr, "No valid Btrfs found on %s\n", path);
+		if (ret == -EIO)
+			fprintf(stderr, "Superblock is corrupted on %s\n",
+				path);
 		return ret;
 	}
 
@@ -1101,7 +1105,10 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 	else
 		ret = btrfs_read_dev_super(fp, disk_super, sb_bytenr, 0);
 	if (ret) {
-		printk("No valid btrfs found\n");
+		if (ret == -ENOENT)
+			fprintf(stderr, "No valid btrfs found\n");
+		if (ret == -EIO)
+			fprintf(stderr, "Superblock is corrupted\n");
 		goto out_devices;
 	}
 
@@ -1201,11 +1208,11 @@ int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr,
 	if (sb_bytenr != BTRFS_SUPER_INFO_OFFSET) {
 		ret = pread64(fd, data, sizeof(data), sb_bytenr);
 		if (ret < sizeof(data))
-			return -1;
+			return -EIO;
 
 		if (btrfs_super_bytenr(buf) != sb_bytenr ||
 		    btrfs_super_magic(buf) != BTRFS_MAGIC)
-			return -1;
+			return -ENOENT;
 
 		memcpy(sb, data, sizeof(data));
 		return 0;
@@ -1221,16 +1228,22 @@ int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr,
 	for (i = 0; i < max_super; i++) {
 		bytenr = btrfs_sb_offset(i);
 		ret = pread64(fd, data, sizeof(data), bytenr);
-		if (ret < sizeof(data))
+		if (ret < sizeof(data)) {
+			ret = -EIO;
 			break;
+		}
 
-		if (btrfs_super_bytenr(buf) != bytenr)
+		if (btrfs_super_bytenr(buf) != bytenr) {
+			ret = -EIO;
 			continue;
+		}
 		/* if first super block is not btrfs, the device was removed */
 		if (btrfs_super_magic(buf) != BTRFS_MAGIC && i == 0)
-			return -1;
-		if (btrfs_super_magic(buf) != BTRFS_MAGIC)
+			return -ENOENT;
+		if (btrfs_super_magic(buf) != BTRFS_MAGIC) {
+			ret = -ENOENT;
 			continue;
+		}
 
 		/* check if the superblock is damaged */
 		crc = ~(u32)0;
@@ -1238,8 +1251,10 @@ int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr,
 				      crc, BTRFS_SUPER_INFO_SIZE -
 				      BTRFS_CSUM_SIZE);
 		btrfs_csum_final(crc, crc_result);
-		if (memcmp(crc_result, buf, btrfs_super_csum_size(buf)))
+		if (memcmp(crc_result, buf, btrfs_super_csum_size(buf))) {
+			ret = -EIO;
 			continue;
+		}
 
 		if (!fsid_is_initialized) {
 			memcpy(fsid, buf->fsid, sizeof(fsid));
@@ -1250,6 +1265,7 @@ int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr,
 			 * its backups) contain data of different
 			 * filesystems -> the super cannot be trusted
 			 */
+			ret = -EIO;
 			continue;
 		}
 
@@ -1259,7 +1275,7 @@ int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr,
 		}
 	}
 
-	return transid > 0 ? 0 : -1;
+	return transid > 0 ? 0 : ret;
 }
 
 static int write_dev_supers(struct btrfs_root *root,
diff --git a/utils.c b/utils.c
index b0c24b1..9071be3 100644
--- a/utils.c
+++ b/utils.c
@@ -1699,7 +1699,10 @@ int get_fs_info(char *path, struct btrfs_ioctl_fs_info_args *fi_args,
 		ret = btrfs_read_dev_super(fd, disk_super,
 					   BTRFS_SUPER_INFO_OFFSET, 0);
 		if (ret < 0) {
-			ret = -EIO;
+			if (ret == -ENOENT)
+				fprintf(stderr, "No valid btrfs found\n");
+			if (ret == -EIO)
+				fprintf(stderr, "Superblock is corrupted\n");
 			goto out;
 		}
 		devid = btrfs_stack_device_id(&disk_super->dev_item);
diff --git a/volumes.c b/volumes.c
index fa17ce1..f10fc95 100644
--- a/volumes.c
+++ b/volumes.c
@@ -246,10 +246,8 @@ int btrfs_scan_one_device(int fd, const char *path,
 	}
 	disk_super = (struct btrfs_super_block *)buf;
 	ret = btrfs_read_dev_super(fd, disk_super, super_offset, super_recover);
-	if (ret < 0) {
-		ret = -EIO;
+	if (ret < 0)
 		goto error_brelse;
-	}
 	devid = btrfs_stack_device_id(&disk_super->dev_item);
 	if (btrfs_super_flags(disk_super) & BTRFS_SUPER_FLAG_METADUMP)
 		*total_devs = 1;
-- 
2.0.1

