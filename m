Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25585 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab3DEFxE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Apr 2013 01:53:04 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r355r2Yk031941
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 5 Apr 2013 05:53:03 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r355r2ck025627
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 5 Apr 2013 05:53:02 GMT
Received: from abhmt117.oracle.com (abhmt117.oracle.com [141.146.116.69])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r355r1Jd014689
	for <linux-btrfs@vger.kernel.org>; Fri, 5 Apr 2013 00:53:01 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/5] btrfs-progs: Introduce flag BTRFS_SCAN_BACKUP_SB for btrfs_read_dev_super
Date: Fri,  5 Apr 2013 13:54:16 +0800
Message-Id: <1365141259-10529-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1365141259-10529-1-git-send-email-anand.jain@oracle.com>
References: <5127022B.6070200@oracle.com>
 <1365141259-10529-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As of now btrfs_read_dev_super() reads the backup super block
by default and calling function has no control. However in the
following patch we would see that is undesirable.
So with the flag BTRFS_SCAN_BACKUP_SB the calling function
can now indicate if btrfs_read_dev_super should scan for
the backup SB when primary SB fails.

This patch just provides the frame-work, keeping all the logic
in the code same with or without this patch.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 disk-io.c   | 10 +++++++---
 disk-io.h   |  3 ++-
 find-root.c |  3 ++-
 utils.h     |  1 +
 volumes.c   |  4 +++-
 5 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index 6a03e9c..8d68c2e 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -880,7 +880,8 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 	fs_info->super_bytenr = sb_bytenr;
 	disk_super = fs_info->super_copy;
 	ret = btrfs_read_dev_super(fs_devices->latest_bdev,
-				   disk_super, sb_bytenr);
+				   disk_super, sb_bytenr,
+				   BTRFS_SCAN_BACKUP_SB);
 	if (ret) {
 		printk("No valid btrfs found\n");
 		goto out_devices;
@@ -1103,7 +1104,8 @@ struct btrfs_root *open_ctree_fd(int fp, const char *path, u64 sb_bytenr,
 	return info->fs_root;
 }
 
-int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr)
+int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr,
+			u64 flags)
 {
 	u8 fsid[BTRFS_FSID_SIZE];
 	int fsid_is_initialized = 0;
@@ -1112,6 +1114,7 @@ int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr)
 	int ret;
 	u64 transid = 0;
 	u64 bytenr;
+	int max;
 
 	if (sb_bytenr != BTRFS_SUPER_INFO_OFFSET) {
 		ret = pread64(fd, &buf, sizeof(buf), sb_bytenr);
@@ -1126,7 +1129,8 @@ int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr)
 		return 0;
 	}
 
-	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
+	max = flags & BTRFS_SCAN_BACKUP_SB ? BTRFS_SUPER_MIRROR_MAX : 1;
+	for (i = 0; i < max; i++) {
 		bytenr = btrfs_sb_offset(i);
 		ret = pread64(fd, &buf, sizeof(buf), bytenr);
 		if (ret < sizeof(buf))
diff --git a/disk-io.h b/disk-io.h
index ff87958..40b7222 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -59,7 +59,8 @@ int close_ctree(struct btrfs_root *root);
 int write_all_supers(struct btrfs_root *root);
 int write_ctree_super(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *root);
-int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr);
+int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr,
+			u64 flags);
 int btrfs_map_bh_to_logical(struct btrfs_root *root, struct extent_buffer *bh,
 			    u64 logical);
 struct extent_buffer *btrfs_find_tree_block(struct btrfs_root *root,
diff --git a/find-root.c b/find-root.c
index 16920ed..0b08358 100644
--- a/find-root.c
+++ b/find-root.c
@@ -151,7 +151,8 @@ static struct btrfs_root *open_ctree_broken(int fd, const char *device)
 	fs_info->super_bytenr = BTRFS_SUPER_INFO_OFFSET;
 	disk_super = fs_info->super_copy;
 	ret = btrfs_read_dev_super(fs_devices->latest_bdev,
-				   disk_super, BTRFS_SUPER_INFO_OFFSET);
+				   disk_super, BTRFS_SUPER_INFO_OFFSET,
+				   BTRFS_SCAN_BACKUP_SB);
 	if (ret) {
 		printk("No valid btrfs found\n");
 		goto out_devices;
diff --git a/utils.h b/utils.h
index 1de5143..ab22b02 100644
--- a/utils.h
+++ b/utils.h
@@ -24,6 +24,7 @@
 
 #define BTRFS_MKFS_SYSTEM_GROUP_SIZE (4 * 1024 * 1024)
 #define BTRFS_SCAN_REGISTER	(1ULL << 1)
+#define BTRFS_SCAN_BACKUP_SB	(1ULL << 2)
 
 int make_btrfs(int fd, const char *device, const char *label,
 	       u64 blocks[6], u64 num_bytes, u32 nodesize,
diff --git a/volumes.c b/volumes.c
index 3e52d06..1113cb5 100644
--- a/volumes.c
+++ b/volumes.c
@@ -29,6 +29,7 @@
 #include "transaction.h"
 #include "print-tree.h"
 #include "volumes.h"
+#include "utils.h"
 
 struct stripe {
 	struct btrfs_device *dev;
@@ -226,7 +227,8 @@ int btrfs_scan_one_device(int fd, const char *path,
 		goto error;
 	}
 	disk_super = (struct btrfs_super_block *)buf;
-	ret = btrfs_read_dev_super(fd, disk_super, super_offset);
+	ret = btrfs_read_dev_super(fd, disk_super, super_offset,
+			BTRFS_SCAN_BACKUP_SB);
 	if (ret < 0) {
 		ret = -EIO;
 		goto error_brelse;
-- 
1.8.1.227.g44fe835

