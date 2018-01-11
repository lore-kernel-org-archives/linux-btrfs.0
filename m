Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:12011 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754088AbeAKFKc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 00:10:32 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id A3B2A49F0E45
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 13:10:19 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 60/67] btrfs-progs: add the stack prefix for super_num_devices set/get function
Date: Thu, 11 Jan 2018 13:09:32 +0800
Message-ID: <20180111050939.21251-61-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
References: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The super_num_devices set/get function defined by
BTRFS_SETGET_STACK_FUNCS macro is missing the prefix stack.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 cmds-inspect-dump-super.c |  2 +-
 convert/common.c          |  2 +-
 ctree.h                   |  2 +-
 disk-io.c                 |  6 +++---
 image/main.c              |  4 ++--
 mkfs/common.c             |  2 +-
 utils.c                   |  4 ++--
 volumes.c                 | 14 +++++++-------
 8 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
index cbeef769..7308b476 100644
--- a/cmds-inspect-dump-super.c
+++ b/cmds-inspect-dump-super.c
@@ -404,7 +404,7 @@ static void dump_superblock(struct btrfs_super_block *sb, int full)
 	printf("root_dir\t\t%llu\n",
 	       (unsigned long long)btrfs_stack_super_root_dir(sb));
 	printf("num_devices\t\t%llu\n",
-	       (unsigned long long)btrfs_super_num_devices(sb));
+	       (unsigned long long)btrfs_stack_super_num_devices(sb));
 	printf("compat_flags\t\t0x%llx\n",
 	       (unsigned long long)btrfs_super_compat_flags(sb));
 	printf("compat_ro_flags\t\t0x%llx\n",
diff --git a/convert/common.c b/convert/common.c
index b83bfbcd..ce32e96e 100644
--- a/convert/common.c
+++ b/convert/common.c
@@ -115,7 +115,7 @@ static int setup_temp_super(int fd, struct btrfs_mkfs_config *cfg,
 	uuid_unparse(chunk_uuid, cfg->chunk_uuid);
 
 	btrfs_set_stack_super_bytenr(super, cfg->super_bytenr);
-	btrfs_set_super_num_devices(super, 1);
+	btrfs_set_stack_super_num_devices(super, 1);
 	btrfs_set_super_magic(super, BTRFS_MAGIC_PARTIAL);
 	btrfs_set_stack_super_generation(super, 1);
 	btrfs_set_stack_super_root(super, root_bytenr);
diff --git a/ctree.h b/ctree.h
index ccc97125..41b5785d 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2196,7 +2196,7 @@ BTRFS_SETGET_STACK_FUNCS(stack_super_stripesize, struct btrfs_super_block,
 			 stripesize, 32);
 BTRFS_SETGET_STACK_FUNCS(stack_super_root_dir, struct btrfs_super_block,
 			 root_dir_objectid, 64);
-BTRFS_SETGET_STACK_FUNCS(super_num_devices, struct btrfs_super_block,
+BTRFS_SETGET_STACK_FUNCS(stack_super_num_devices, struct btrfs_super_block,
 			 num_devices, 64);
 BTRFS_SETGET_STACK_FUNCS(super_compat_flags, struct btrfs_super_block,
 			 compat_flags, 64);
diff --git a/disk-io.c b/disk-io.c
index 16fb9afd..d6bc057b 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1391,12 +1391,12 @@ static int check_super(struct btrfs_super_block *sb, unsigned sbflags)
 	/*
 	 * Hint to catch really bogus numbers, bitflips or so
 	 */
-	if (btrfs_super_num_devices(sb) > (1UL << 31)) {
+	if (btrfs_stack_super_num_devices(sb) > (1UL << 31)) {
 		warning("suspicious number of devices: %llu",
-			btrfs_super_num_devices(sb));
+			btrfs_stack_super_num_devices(sb));
 	}
 
-	if (btrfs_super_num_devices(sb) == 0) {
+	if (btrfs_stack_super_num_devices(sb) == 0) {
 		error("number of devices is 0");
 		goto error_out;
 	}
diff --git a/image/main.c b/image/main.c
index 1a77de98..69fca3c3 100644
--- a/image/main.c
+++ b/image/main.c
@@ -1190,7 +1190,7 @@ static int update_super(struct mdrestore_struct *mdres, u8 *buffer)
 	flags |= BTRFS_SUPER_FLAG_METADUMP_V2;
 	btrfs_set_stack_super_flags(super, flags);
 	btrfs_set_stack_super_sys_array_size(super, new_array_size);
-	btrfs_set_super_num_devices(super, 1);
+	btrfs_set_stack_super_num_devices(super, 1);
 	csum_block(buffer, BTRFS_SUPER_INFO_SIZE);
 
 	return 0;
@@ -2574,7 +2574,7 @@ int main(int argc, char *argv[])
 			return 1;
 		}
 
-		total_devs = btrfs_super_num_devices(info->super_copy);
+		total_devs = btrfs_stack_super_num_devices(info->super_copy);
 		if (total_devs != dev_cnt) {
 			error("it needs %llu devices but has only %d",
 				total_devs, dev_cnt);
diff --git a/mkfs/common.c b/mkfs/common.c
index 6a8fdb19..1d259da5 100644
--- a/mkfs/common.c
+++ b/mkfs/common.c
@@ -159,7 +159,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
 	}
 
 	btrfs_set_stack_super_bytenr(&super, cfg->blocks[MKFS_SUPER_BLOCK]);
-	btrfs_set_super_num_devices(&super, 1);
+	btrfs_set_stack_super_num_devices(&super, 1);
 	btrfs_set_super_magic(&super, BTRFS_MAGIC_PARTIAL);
 	btrfs_set_stack_super_generation(&super, 1);
 	btrfs_set_stack_super_root(&super, cfg->blocks[MKFS_ROOT_TREE]);
diff --git a/utils.c b/utils.c
index 150623fc..79fa04ad 100644
--- a/utils.c
+++ b/utils.c
@@ -232,8 +232,8 @@ int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
 				device_total_bytes;
 	btrfs_set_stack_super_total_bytes(super, fs_total_bytes);
 
-	num_devs = btrfs_super_num_devices(super) + 1;
-	btrfs_set_super_num_devices(super, num_devs);
+	num_devs = btrfs_stack_super_num_devices(super) + 1;
+	btrfs_set_stack_super_num_devices(super, num_devs);
 
 	memcpy(disk_super, super, sizeof(*disk_super));
 
diff --git a/volumes.c b/volumes.c
index 5df064b3..5d500640 100644
--- a/volumes.c
+++ b/volumes.c
@@ -129,7 +129,7 @@ static int device_list_add(const char *path,
 			kfree(device);
 			return -ENOMEM;
 		}
-		device->total_devs = btrfs_super_num_devices(disk_super);
+		device->total_devs = btrfs_stack_super_num_devices(disk_super);
 		device->super_bytes_used =
 			btrfs_stack_super_bytes_used(disk_super);
 		device->total_bytes =
@@ -289,7 +289,7 @@ int btrfs_scan_one_device(int fd, const char *path,
 	if (btrfs_stack_super_flags(disk_super) & BTRFS_SUPER_FLAG_METADUMP)
 		*total_devs = 1;
 	else
-		*total_devs = btrfs_super_num_devices(disk_super);
+		*total_devs = btrfs_stack_super_num_devices(disk_super);
 
 	ret = device_list_add(path, disk_super, devid, fs_devices_ret);
 
@@ -905,7 +905,7 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	}
 	if (type & BTRFS_BLOCK_GROUP_RAID1) {
 		num_stripes = min_t(u64, 2,
-				  btrfs_super_num_devices(info->super_copy));
+			btrfs_stack_super_num_devices(info->super_copy));
 		if (num_stripes < 2)
 			return -ENOSPC;
 		min_stripes = 2;
@@ -915,13 +915,13 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 		min_stripes = 2;
 	}
 	if (type & (BTRFS_BLOCK_GROUP_RAID0)) {
-		num_stripes = btrfs_super_num_devices(info->super_copy);
+		num_stripes = btrfs_stack_super_num_devices(info->super_copy);
 		if (num_stripes > max_stripes)
 			num_stripes = max_stripes;
 		min_stripes = 2;
 	}
 	if (type & (BTRFS_BLOCK_GROUP_RAID10)) {
-		num_stripes = btrfs_super_num_devices(info->super_copy);
+		num_stripes = btrfs_stack_super_num_devices(info->super_copy);
 		if (num_stripes > max_stripes)
 			num_stripes = max_stripes;
 		if (num_stripes < 4)
@@ -931,7 +931,7 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 		min_stripes = 4;
 	}
 	if (type & (BTRFS_BLOCK_GROUP_RAID5)) {
-		num_stripes = btrfs_super_num_devices(info->super_copy);
+		num_stripes = btrfs_stack_super_num_devices(info->super_copy);
 		if (num_stripes > max_stripes)
 			num_stripes = max_stripes;
 		if (num_stripes < 2)
@@ -941,7 +941,7 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 				btrfs_stack_super_stripesize(info->super_copy));
 	}
 	if (type & (BTRFS_BLOCK_GROUP_RAID6)) {
-		num_stripes = btrfs_super_num_devices(info->super_copy);
+		num_stripes = btrfs_stack_super_num_devices(info->super_copy);
 		if (num_stripes > max_stripes)
 			num_stripes = max_stripes;
 		if (num_stripes < 3)
-- 
2.15.1



