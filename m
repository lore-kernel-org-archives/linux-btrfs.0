Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:54301 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754014AbeAKFKV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 00:10:21 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 9D52249F0D60
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 13:10:11 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 43/67] btrfs-progs: add the stack prefix for super_flags set/get function
Date: Thu, 11 Jan 2018 13:09:15 +0800
Message-ID: <20180111050939.21251-44-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
References: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The super_flags set/get function defined by
BTRFS_SETGET_STACK_FUNCS macro is missing the prefix stack.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 btrfstune.c               | 14 +++++++-------
 chunk-recover.c           |  2 +-
 cmds-check.c              |  2 +-
 cmds-inspect-dump-super.c |  4 ++--
 ctree.h                   |  3 ++-
 disk-io.c                 | 10 ++++++----
 image/main.c              |  8 ++++----
 volumes.c                 |  2 +-
 8 files changed, 24 insertions(+), 21 deletions(-)

diff --git a/btrfstune.c b/btrfstune.c
index eccedf79..e502126a 100644
--- a/btrfstune.c
+++ b/btrfstune.c
@@ -45,7 +45,7 @@ static int update_seeding_flag(struct btrfs_root *root, int set_flag)
 	int ret;
 
 	disk_super = root->fs_info->super_copy;
-	super_flags = btrfs_super_flags(disk_super);
+	super_flags = btrfs_stack_super_flags(disk_super);
 	if (set_flag) {
 		if (super_flags & BTRFS_SUPER_FLAG_SEEDING) {
 			if (force)
@@ -67,7 +67,7 @@ static int update_seeding_flag(struct btrfs_root *root, int set_flag)
 
 	trans = btrfs_start_transaction(root, 1);
 	BUG_ON(IS_ERR(trans));
-	btrfs_set_super_flags(disk_super, super_flags);
+	btrfs_set_stack_super_flags(disk_super, super_flags);
 	ret = btrfs_commit_transaction(trans, root);
 
 	return ret;
@@ -237,11 +237,11 @@ out:
 static int change_fsid_prepare(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_root *tree_root = fs_info->tree_root;
-	u64 flags = btrfs_super_flags(fs_info->super_copy);
+	u64 flags = btrfs_stack_super_flags(fs_info->super_copy);
 	int ret = 0;
 
 	flags |= BTRFS_SUPER_FLAG_CHANGING_FSID;
-	btrfs_set_super_flags(fs_info->super_copy, flags);
+	btrfs_set_stack_super_flags(fs_info->super_copy, flags);
 
 	memcpy(fs_info->super_copy->fsid, fs_info->new_fsid, BTRFS_FSID_SIZE);
 	ret = write_all_supers(fs_info);
@@ -257,10 +257,10 @@ static int change_fsid_prepare(struct btrfs_fs_info *fs_info)
 
 static int change_fsid_done(struct btrfs_fs_info *fs_info)
 {
-	u64 flags = btrfs_super_flags(fs_info->super_copy);
+	u64 flags = btrfs_stack_super_flags(fs_info->super_copy);
 
 	flags &= ~BTRFS_SUPER_FLAG_CHANGING_FSID;
-	btrfs_set_super_flags(fs_info->super_copy, flags);
+	btrfs_set_stack_super_flags(fs_info->super_copy, flags);
 
 	return write_all_supers(fs_info);
 }
@@ -274,7 +274,7 @@ static int check_unfinished_fsid_change(struct btrfs_fs_info *fs_info,
 					uuid_t fsid_ret, uuid_t chunk_id_ret)
 {
 	struct btrfs_root *tree_root = fs_info->tree_root;
-	u64 flags = btrfs_super_flags(fs_info->super_copy);
+	u64 flags = btrfs_stack_super_flags(fs_info->super_copy);
 
 	if (flags & BTRFS_SUPER_FLAG_CHANGING_FSID) {
 		memcpy(fsid_ret, fs_info->super_copy->fsid, BTRFS_FSID_SIZE);
diff --git a/chunk-recover.c b/chunk-recover.c
index 123cd097..6734212c 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -1540,7 +1540,7 @@ static int recover_prepare(struct recover_control *rc, char *path)
 	rc->csum_size = btrfs_super_csum_size(sb);
 
 	/* if seed, the result of scanning below will be partial */
-	if (btrfs_super_flags(sb) & BTRFS_SUPER_FLAG_SEEDING) {
+	if (btrfs_stack_super_flags(sb) & BTRFS_SUPER_FLAG_SEEDING) {
 		fprintf(stderr, "this device is seed device\n");
 		ret = -1;
 		goto out_close_fd;
diff --git a/cmds-check.c b/cmds-check.c
index 6070e8d5..170da424 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -11291,7 +11291,7 @@ static bool is_super_size_valid(struct btrfs_fs_info *fs_info)
 	 *
 	 * For a btrfs-image restored fs, we don't need to check it anyway.
 	 */
-	if (btrfs_super_flags(fs_info->super_copy) &
+	if (btrfs_stack_super_flags(fs_info->super_copy) &
 	    (BTRFS_SUPER_FLAG_METADUMP | BTRFS_SUPER_FLAG_METADUMP_V2))
 		return true;
 	if (!IS_ALIGNED(super_bytes, fs_info->sectorsize) ||
diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
index cbd86c50..3a8acd7e 100644
--- a/cmds-inspect-dump-super.c
+++ b/cmds-inspect-dump-super.c
@@ -348,8 +348,8 @@ static void dump_superblock(struct btrfs_super_block *sb, int full)
 	printf("bytenr\t\t\t%llu\n",
 		(unsigned long long)btrfs_stack_super_bytenr(sb));
 	printf("flags\t\t\t0x%llx\n",
-		(unsigned long long)btrfs_super_flags(sb));
-	print_readable_super_flag(btrfs_super_flags(sb));
+		(unsigned long long)btrfs_stack_super_flags(sb));
+	print_readable_super_flag(btrfs_stack_super_flags(sb));
 
 	printf("magic\t\t\t");
 	s = (char *) &sb->magic;
diff --git a/ctree.h b/ctree.h
index 14e5aac8..fdf274d6 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2163,7 +2163,8 @@ BTRFS_SETGET_STACK_FUNCS(stack_backup_num_devices, struct btrfs_root_backup,
 
 BTRFS_SETGET_STACK_FUNCS(stack_super_bytenr, struct btrfs_super_block, bytenr,
 			 64);
-BTRFS_SETGET_STACK_FUNCS(super_flags, struct btrfs_super_block, flags, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_super_flags, struct btrfs_super_block, flags,
+			 64);
 BTRFS_SETGET_STACK_FUNCS(super_generation, struct btrfs_super_block,
 			 generation, 64);
 BTRFS_SETGET_STACK_FUNCS(super_root, struct btrfs_super_block, root, 64);
diff --git a/disk-io.c b/disk-io.c
index 9458242b..3a3275b5 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1069,7 +1069,7 @@ int btrfs_setup_chunk_tree_and_device_map(struct btrfs_fs_info *fs_info,
 		}
 	}
 
-	if (!(btrfs_super_flags(sb) & BTRFS_SUPER_FLAG_METADUMP)) {
+	if (!(btrfs_stack_super_flags(sb) & BTRFS_SUPER_FLAG_METADUMP)) {
 		ret = btrfs_read_chunk_tree(fs_info);
 		if (ret) {
 			fprintf(stderr, "Couldn't read chunk tree\n");
@@ -1154,7 +1154,8 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 		goto out_devices;
 	}
 
-	if (btrfs_super_flags(disk_super) & BTRFS_SUPER_FLAG_CHANGING_FSID &&
+	if (btrfs_stack_super_flags(disk_super) &
+			BTRFS_SUPER_FLAG_CHANGING_FSID &&
 	    !fs_info->ignore_fsid_mismatch) {
 		fprintf(stderr, "ERROR: Filesystem UUID change in progress\n");
 		goto out_devices;
@@ -1582,8 +1583,9 @@ int write_all_supers(struct btrfs_fs_info *fs_info)
 		memcpy(dev_item->uuid, dev->uuid, BTRFS_UUID_SIZE);
 		memcpy(dev_item->fsid, dev->fs_devices->fsid, BTRFS_UUID_SIZE);
 
-		flags = btrfs_super_flags(sb);
-		btrfs_set_super_flags(sb, flags | BTRFS_HEADER_FLAG_WRITTEN);
+		flags = btrfs_stack_super_flags(sb);
+		btrfs_set_stack_super_flags(sb,
+					    flags | BTRFS_HEADER_FLAG_WRITTEN);
 
 		ret = write_dev_supers(fs_info, sb, dev);
 		BUG_ON(ret);
diff --git a/image/main.c b/image/main.c
index 84d4d0dd..e9df95ad 100644
--- a/image/main.c
+++ b/image/main.c
@@ -1091,10 +1091,10 @@ static void update_super_old(u8 *buffer)
 	struct btrfs_chunk *chunk;
 	struct btrfs_disk_key *key;
 	u32 sectorsize = btrfs_super_sectorsize(super);
-	u64 flags = btrfs_super_flags(super);
+	u64 flags = btrfs_stack_super_flags(super);
 
 	flags |= BTRFS_SUPER_FLAG_METADUMP;
-	btrfs_set_super_flags(super, flags);
+	btrfs_set_stack_super_flags(super, flags);
 
 	key = (struct btrfs_disk_key *)(super->sys_chunk_array);
 	chunk = (struct btrfs_chunk *)(super->sys_chunk_array +
@@ -1126,7 +1126,7 @@ static int update_super(struct mdrestore_struct *mdres, u8 *buffer)
 	struct btrfs_chunk *chunk;
 	struct btrfs_disk_key *disk_key;
 	struct btrfs_key key;
-	u64 flags = btrfs_super_flags(super);
+	u64 flags = btrfs_stack_super_flags(super);
 	u32 new_array_size = 0;
 	u32 array_size;
 	u32 cur = 0;
@@ -1187,7 +1187,7 @@ static int update_super(struct mdrestore_struct *mdres, u8 *buffer)
 		btrfs_set_super_cache_generation(super, 0);
 
 	flags |= BTRFS_SUPER_FLAG_METADUMP_V2;
-	btrfs_set_super_flags(super, flags);
+	btrfs_set_stack_super_flags(super, flags);
 	btrfs_set_super_sys_array_size(super, new_array_size);
 	btrfs_set_super_num_devices(super, 1);
 	csum_block(buffer, BTRFS_SUPER_INFO_SIZE);
diff --git a/volumes.c b/volumes.c
index ce3a5405..90c23582 100644
--- a/volumes.c
+++ b/volumes.c
@@ -285,7 +285,7 @@ int btrfs_scan_one_device(int fd, const char *path,
 	if (ret < 0)
 		return -EIO;
 	devid = btrfs_stack_device_id(&disk_super->dev_item);
-	if (btrfs_super_flags(disk_super) & BTRFS_SUPER_FLAG_METADUMP)
+	if (btrfs_stack_super_flags(disk_super) & BTRFS_SUPER_FLAG_METADUMP)
 		*total_devs = 1;
 	else
 		*total_devs = btrfs_super_num_devices(disk_super);
-- 
2.15.1



