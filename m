Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59404 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753563AbcHWKnp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Aug 2016 06:43:45 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 12951AD33
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Aug 2016 10:26:25 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 02/13] btrfs-progs: make superblock reading/scanning api more generic
Date: Tue, 23 Aug 2016 12:25:06 +0200
Message-Id: <1471947917-5324-3-git-send-email-dsterba@suse.com>
In-Reply-To: <1471947917-5324-1-git-send-email-dsterba@suse.com>
References: <1471947917-5324-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We'll add more modes that affect scanning.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 chunk-recover.c   |  8 +++++---
 cmds-filesystem.c |  2 +-
 disk-io.c         | 25 +++++++++++++------------
 disk-io.h         | 13 +++++++++++--
 super-recover.c   |  3 ++-
 utils.c           |  5 +++--
 volumes.c         |  4 ++--
 volumes.h         |  2 +-
 8 files changed, 38 insertions(+), 24 deletions(-)

diff --git a/chunk-recover.c b/chunk-recover.c
index 085e9a256ea4..4a081db2de33 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -1470,7 +1470,8 @@ open_ctree_with_broken_chunk(struct recover_control *rc)
 
 	disk_super = fs_info->super_copy;
 	ret = btrfs_read_dev_super(fs_info->fs_devices->latest_bdev,
-				   disk_super, fs_info->super_bytenr, 1);
+				   disk_super, fs_info->super_bytenr,
+				   SBREAD_RECOVER);
 	if (ret) {
 		fprintf(stderr, "No valid btrfs found\n");
 		goto out_devices;
@@ -1531,7 +1532,8 @@ static int recover_prepare(struct recover_control *rc, char *path)
 	}
 
 	sb = (struct btrfs_super_block*)buf;
-	ret = btrfs_read_dev_super(fd, sb, BTRFS_SUPER_INFO_OFFSET, 1);
+	ret = btrfs_read_dev_super(fd, sb, BTRFS_SUPER_INFO_OFFSET,
+			SBREAD_RECOVER);
 	if (ret) {
 		fprintf(stderr, "read super block error\n");
 		goto out_close_fd;
@@ -1550,7 +1552,7 @@ static int recover_prepare(struct recover_control *rc, char *path)
 		goto out_close_fd;
 	}
 
-	ret = btrfs_scan_fs_devices(fd, path, &fs_devices, 0, 1, 0);
+	ret = btrfs_scan_fs_devices(fd, path, &fs_devices, 0, SBREAD_RECOVER, 0);
 	if (ret)
 		goto out_close_fd;
 
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 00e4bfe41c86..76ea82edf23c 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -524,7 +524,7 @@ static int dev_to_fsid(char *dev, __u8 *fsid)
 
 	disk_super = (struct btrfs_super_block *)buf;
 	ret = btrfs_read_dev_super(fd, disk_super,
-				   BTRFS_SUPER_INFO_OFFSET, 0);
+				   BTRFS_SUPER_INFO_OFFSET, SBREAD_DEFAULT);
 	if (ret)
 		goto out;
 
diff --git a/disk-io.c b/disk-io.c
index 279e38b74c39..4874f0689228 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1114,7 +1114,7 @@ void btrfs_cleanup_all_caches(struct btrfs_fs_info *fs_info)
 
 int btrfs_scan_fs_devices(int fd, const char *path,
 			  struct btrfs_fs_devices **fs_devices,
-			  u64 sb_bytenr, int super_recover,
+			  u64 sb_bytenr, unsigned sbflags,
 			  int skip_devices)
 {
 	u64 total_devs;
@@ -1136,7 +1136,7 @@ int btrfs_scan_fs_devices(int fd, const char *path,
 	}
 
 	ret = btrfs_scan_one_device(fd, path, fs_devices,
-				    &total_devs, sb_bytenr, super_recover);
+				    &total_devs, sb_bytenr, sbflags);
 	if (ret) {
 		fprintf(stderr, "No valid Btrfs found on %s\n", path);
 		return ret;
@@ -1248,8 +1248,8 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 		fs_info->ignore_chunk_tree_error = 1;
 
 	ret = btrfs_scan_fs_devices(fp, path, &fs_devices, sb_bytenr,
-				    (flags & OPEN_CTREE_RECOVER_SUPER),
-				    (flags & OPEN_CTREE_NO_DEVICES));
+		(flags & OPEN_CTREE_RECOVER_SUPER) ? SBREAD_RECOVER : SBREAD_DEFAULT,
+		(flags & OPEN_CTREE_NO_DEVICES));
 	if (ret)
 		goto out;
 
@@ -1268,10 +1268,11 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 
 	disk_super = fs_info->super_copy;
 	if (flags & OPEN_CTREE_RECOVER_SUPER)
-		ret = btrfs_read_dev_super(fs_devices->latest_bdev,
-					   disk_super, sb_bytenr, 1);
+		ret = btrfs_read_dev_super(fs_devices->latest_bdev, disk_super,
+				sb_bytenr, SBREAD_RECOVER);
 	else
-		ret = btrfs_read_dev_super(fp, disk_super, sb_bytenr, 0);
+		ret = btrfs_read_dev_super(fp, disk_super, sb_bytenr,
+				SBREAD_DEFAULT);
 	if (ret) {
 		printk("No valid btrfs found\n");
 		goto out_devices;
@@ -1392,7 +1393,7 @@ struct btrfs_root *open_ctree_fd(int fp, const char *path, u64 sb_bytenr,
  * - number of devices   - something sane
  * - sys array size      - maximum
  */
-static int check_super(struct btrfs_super_block *sb)
+static int check_super(struct btrfs_super_block *sb, unsigned sbflags)
 {
 	char result[BTRFS_CSUM_SIZE];
 	u32 crc;
@@ -1533,7 +1534,7 @@ static int check_super(struct btrfs_super_block *sb)
 }
 
 int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr,
-			 int super_recover)
+			 unsigned sbflags)
 {
 	u8 fsid[BTRFS_FSID_SIZE];
 	int fsid_is_initialized = 0;
@@ -1541,7 +1542,7 @@ int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr,
 	struct btrfs_super_block *buf = (struct btrfs_super_block *)tmp;
 	int i;
 	int ret;
-	int max_super = super_recover ? BTRFS_SUPER_MIRROR_MAX : 1;
+	int max_super = sbflags & SBREAD_RECOVER ? BTRFS_SUPER_MIRROR_MAX : 1;
 	u64 transid = 0;
 	u64 bytenr;
 
@@ -1553,7 +1554,7 @@ int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr,
 		if (btrfs_super_bytenr(buf) != sb_bytenr)
 			return -1;
 
-		if (check_super(buf))
+		if (check_super(buf, sbflags))
 			return -1;
 		memcpy(sb, buf, BTRFS_SUPER_INFO_SIZE);
 		return 0;
@@ -1577,7 +1578,7 @@ int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr,
 		/* if magic is NULL, the device was removed */
 		if (btrfs_super_magic(buf) == 0 && i == 0)
 			break;
-		if (check_super(buf))
+		if (check_super(buf, sbflags))
 			continue;
 
 		if (!fsid_is_initialized) {
diff --git a/disk-io.h b/disk-io.h
index 9ebb2366b933..153ef1f49641 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -64,6 +64,15 @@ enum btrfs_open_ctree_flags {
 	OPEN_CTREE_IGNORE_CHUNK_TREE_ERROR = (1 << 11)
 };
 
+/*
+ * Modes of superblock access
+ */
+enum btrfs_read_sb_flags {
+	SBREAD_DEFAULT		= 0,
+	/* Reading superblock during recovery */
+	SBREAD_RECOVER		= (1 << 0),
+};
+
 static inline u64 btrfs_sb_offset(int mirror)
 {
 	u64 start = 16 * 1024;
@@ -108,7 +117,7 @@ void btrfs_release_all_roots(struct btrfs_fs_info *fs_info);
 void btrfs_cleanup_all_caches(struct btrfs_fs_info *fs_info);
 int btrfs_scan_fs_devices(int fd, const char *path,
 			  struct btrfs_fs_devices **fs_devices, u64 sb_bytenr,
-			  int super_recover, int skip_devices);
+			  unsigned sbflags, int skip_devices);
 int btrfs_setup_chunk_tree_and_device_map(struct btrfs_fs_info *fs_info,
 			  u64 chunk_root_bytenr);
 
@@ -132,7 +141,7 @@ int write_all_supers(struct btrfs_root *root);
 int write_ctree_super(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *root);
 int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr,
-			 int super_recover);
+		unsigned sbflags);
 int btrfs_map_bh_to_logical(struct btrfs_root *root, struct extent_buffer *bh,
 			    u64 logical);
 struct extent_buffer *btrfs_find_tree_block(struct btrfs_root *root,
diff --git a/super-recover.c b/super-recover.c
index 88ecdee83e14..1dc3fc7d12e6 100644
--- a/super-recover.c
+++ b/super-recover.c
@@ -279,7 +279,8 @@ int btrfs_recover_superblocks(const char *dname,
 	}
 	init_recover_superblock(&recover);
 
-	ret = btrfs_scan_fs_devices(fd, dname, &recover.fs_devices, 0, 1, 0);
+	ret = btrfs_scan_fs_devices(fd, dname, &recover.fs_devices, 0,
+			SBREAD_RECOVER, 0);
 	close(fd);
 	if (ret) {
 		ret = 1;
diff --git a/utils.c b/utils.c
index 79bf946614c2..8be0e7537f8f 100644
--- a/utils.c
+++ b/utils.c
@@ -2272,7 +2272,7 @@ int check_mounted_where(int fd, const char *file, char *where, int size,
 
 	/* scan the initial device */
 	ret = btrfs_scan_one_device(fd, file, &fs_devices_mnt,
-				    &total_devs, BTRFS_SUPER_INFO_OFFSET, 0);
+		    &total_devs, BTRFS_SUPER_INFO_OFFSET, SBREAD_DEFAULT);
 	is_btrfs = (ret >= 0);
 
 	/* scan other devices */
@@ -3419,7 +3419,8 @@ int btrfs_scan_lblkid(void)
 			continue;
 		}
 		ret = btrfs_scan_one_device(fd, path, &tmp_devices,
-				&num_devices, BTRFS_SUPER_INFO_OFFSET, 0);
+				&num_devices, BTRFS_SUPER_INFO_OFFSET,
+				SBREAD_DEFAULT);
 		if (ret) {
 			error("cannot scan %s: %s", path, strerror(-ret));
 			close (fd);
diff --git a/volumes.c b/volumes.c
index a356d740cf44..9a5580ae6a5c 100644
--- a/volumes.c
+++ b/volumes.c
@@ -251,7 +251,7 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices, int flags)
 
 int btrfs_scan_one_device(int fd, const char *path,
 			  struct btrfs_fs_devices **fs_devices_ret,
-			  u64 *total_devs, u64 super_offset, int super_recover)
+			  u64 *total_devs, u64 super_offset, unsigned sbflags)
 {
 	struct btrfs_super_block *disk_super;
 	char buf[BTRFS_SUPER_INFO_SIZE];
@@ -259,7 +259,7 @@ int btrfs_scan_one_device(int fd, const char *path,
 	u64 devid;
 
 	disk_super = (struct btrfs_super_block *)buf;
-	ret = btrfs_read_dev_super(fd, disk_super, super_offset, super_recover);
+	ret = btrfs_read_dev_super(fd, disk_super, super_offset, sbflags);
 	if (ret < 0)
 		return -EIO;
 	devid = btrfs_stack_device_id(&disk_super->dev_item);
diff --git a/volumes.h b/volumes.h
index d88e1cf01abe..af7182b87cba 100644
--- a/volumes.h
+++ b/volumes.h
@@ -210,7 +210,7 @@ int btrfs_update_device(struct btrfs_trans_handle *trans,
 			struct btrfs_device *device);
 int btrfs_scan_one_device(int fd, const char *path,
 			  struct btrfs_fs_devices **fs_devices_ret,
-			  u64 *total_devs, u64 super_offset, int super_recover);
+			  u64 *total_devs, u64 super_offset, unsigned sbflags);
 int btrfs_num_copies(struct btrfs_mapping_tree *map_tree, u64 logical, u64 len);
 struct list_head *btrfs_scanned_uuids(void);
 int btrfs_add_system_chunk(struct btrfs_trans_handle *trans,
-- 
2.7.1

