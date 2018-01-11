Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:44389 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754010AbeAKFKS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 00:10:18 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 3C56C49F0D76
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 13:10:11 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 42/67] btrfs-progs: add the stack prefix for super_bytenr set/get function
Date: Thu, 11 Jan 2018 13:09:14 +0800
Message-ID: <20180111050939.21251-43-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
References: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The super_bytenr set/get function defined by
BTRFS_SETGET_STACK_FUNCS macro is missing the prefix stack.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 cmds-inspect-dump-super.c | 2 +-
 convert/common.c          | 2 +-
 convert/main.c            | 4 ++--
 ctree.h                   | 3 ++-
 disk-io.c                 | 8 ++++----
 image/main.c              | 2 +-
 mkfs/common.c             | 2 +-
 utils.c                   | 2 +-
 8 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
index fd4a574b..cbd86c50 100644
--- a/cmds-inspect-dump-super.c
+++ b/cmds-inspect-dump-super.c
@@ -346,7 +346,7 @@ static void dump_superblock(struct btrfs_super_block *sb, int full)
 	putchar('\n');
 
 	printf("bytenr\t\t\t%llu\n",
-		(unsigned long long)btrfs_super_bytenr(sb));
+		(unsigned long long)btrfs_stack_super_bytenr(sb));
 	printf("flags\t\t\t0x%llx\n",
 		(unsigned long long)btrfs_super_flags(sb));
 	print_readable_super_flag(btrfs_super_flags(sb));
diff --git a/convert/common.c b/convert/common.c
index 9a386932..38769081 100644
--- a/convert/common.c
+++ b/convert/common.c
@@ -114,7 +114,7 @@ static int setup_temp_super(int fd, struct btrfs_mkfs_config *cfg,
 	uuid_generate(chunk_uuid);
 	uuid_unparse(chunk_uuid, cfg->chunk_uuid);
 
-	btrfs_set_super_bytenr(super, cfg->super_bytenr);
+	btrfs_set_stack_super_bytenr(super, cfg->super_bytenr);
 	btrfs_set_super_num_devices(super, 1);
 	btrfs_set_super_magic(super, BTRFS_MAGIC_PARTIAL);
 	btrfs_set_super_generation(super, 1);
diff --git a/convert/main.c b/convert/main.c
index a3bcfbd3..66b839e2 100644
--- a/convert/main.c
+++ b/convert/main.c
@@ -1025,8 +1025,8 @@ static int migrate_super_block(int fd, u64 old_bytenr)
 		goto fail;
 
 	super = (struct btrfs_super_block *)buf->data;
-	BUG_ON(btrfs_super_bytenr(super) != old_bytenr);
-	btrfs_set_super_bytenr(super, BTRFS_SUPER_INFO_OFFSET);
+	BUG_ON(btrfs_stack_super_bytenr(super) != old_bytenr);
+	btrfs_set_stack_super_bytenr(super, BTRFS_SUPER_INFO_OFFSET);
 
 	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
 	ret = pwrite(fd, buf->data, BTRFS_SUPER_INFO_SIZE,
diff --git a/ctree.h b/ctree.h
index e159382e..14e5aac8 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2161,7 +2161,8 @@ BTRFS_SETGET_STACK_FUNCS(stack_backup_num_devices, struct btrfs_root_backup,
 
 /* struct btrfs_super_block */
 
-BTRFS_SETGET_STACK_FUNCS(super_bytenr, struct btrfs_super_block, bytenr, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_super_bytenr, struct btrfs_super_block, bytenr,
+			 64);
 BTRFS_SETGET_STACK_FUNCS(super_flags, struct btrfs_super_block, flags, 64);
 BTRFS_SETGET_STACK_FUNCS(super_generation, struct btrfs_super_block,
 			 generation, 64);
diff --git a/disk-io.c b/disk-io.c
index ef147a40..9458242b 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1442,7 +1442,7 @@ int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr,
 		if (ret < BTRFS_SUPER_INFO_SIZE)
 			return -ENOENT;
 
-		if (btrfs_super_bytenr(buf) != sb_bytenr)
+		if (btrfs_stack_super_bytenr(buf) != sb_bytenr)
 			return -EIO;
 
 		ret = check_super(buf, sbflags);
@@ -1465,7 +1465,7 @@ int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr,
 		if (ret < BTRFS_SUPER_INFO_SIZE)
 			break;
 
-		if (btrfs_super_bytenr(buf) != bytenr )
+		if (btrfs_stack_super_bytenr(buf) != bytenr)
 			continue;
 		/* if magic is NULL, the device was removed */
 		if (btrfs_super_magic(buf) == 0 && i == 0)
@@ -1503,7 +1503,7 @@ static int write_dev_supers(struct btrfs_fs_info *fs_info,
 	int i, ret;
 
 	if (fs_info->super_bytenr != BTRFS_SUPER_INFO_OFFSET) {
-		btrfs_set_super_bytenr(sb, fs_info->super_bytenr);
+		btrfs_set_stack_super_bytenr(sb, fs_info->super_bytenr);
 		crc = ~(u32)0;
 		crc = btrfs_csum_data((char *)sb + BTRFS_CSUM_SIZE, crc,
 				      BTRFS_SUPER_INFO_SIZE - BTRFS_CSUM_SIZE);
@@ -1526,7 +1526,7 @@ static int write_dev_supers(struct btrfs_fs_info *fs_info,
 		if (bytenr + BTRFS_SUPER_INFO_SIZE > device->total_bytes)
 			break;
 
-		btrfs_set_super_bytenr(sb, bytenr);
+		btrfs_set_stack_super_bytenr(sb, bytenr);
 
 		crc = ~(u32)0;
 		crc = btrfs_csum_data((char *)sb + BTRFS_CSUM_SIZE, crc,
diff --git a/image/main.c b/image/main.c
index 56244586..84d4d0dd 100644
--- a/image/main.c
+++ b/image/main.c
@@ -1352,7 +1352,7 @@ static void write_backup_supers(int fd, u8 *buf)
 		bytenr = btrfs_sb_offset(i);
 		if (bytenr + BTRFS_SUPER_INFO_SIZE > size)
 			break;
-		btrfs_set_super_bytenr(super, bytenr);
+		btrfs_set_stack_super_bytenr(super, bytenr);
 		csum_block(buf, BTRFS_SUPER_INFO_SIZE);
 		ret = pwrite64(fd, buf, BTRFS_SUPER_INFO_SIZE, bytenr);
 		if (ret < BTRFS_SUPER_INFO_SIZE) {
diff --git a/mkfs/common.c b/mkfs/common.c
index 0b3e8173..1845cb14 100644
--- a/mkfs/common.c
+++ b/mkfs/common.c
@@ -158,7 +158,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
 			cfg->nodesize * i;
 	}
 
-	btrfs_set_super_bytenr(&super, cfg->blocks[MKFS_SUPER_BLOCK]);
+	btrfs_set_stack_super_bytenr(&super, cfg->blocks[MKFS_SUPER_BLOCK]);
 	btrfs_set_super_num_devices(&super, 1);
 	btrfs_set_super_magic(&super, BTRFS_MAGIC_PARTIAL);
 	btrfs_set_super_generation(&super, 1);
diff --git a/utils.c b/utils.c
index 2f57617f..d80e02d1 100644
--- a/utils.c
+++ b/utils.c
@@ -236,7 +236,7 @@ int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
 
 	memcpy(disk_super, super, sizeof(*disk_super));
 
-	btrfs_set_super_bytenr(disk_super, BTRFS_SUPER_INFO_OFFSET);
+	btrfs_set_stack_super_bytenr(disk_super, BTRFS_SUPER_INFO_OFFSET);
 	btrfs_set_stack_device_id(dev_item, device->devid);
 	btrfs_set_stack_device_type(dev_item, device->type);
 	btrfs_set_stack_device_io_align(dev_item, device->io_align);
-- 
2.15.1



