Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:44389 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754069AbeAKFK1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 00:10:27 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 086D149F0E4D
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 13:10:23 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 67/67] btrfs-progs: add the stack prefix for super_magic set/get function
Date: Thu, 11 Jan 2018 13:09:39 +0800
Message-ID: <20180111050939.21251-68-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
References: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The super_magic set/get function defined by
BTRFS_SETGET_STACK_FUNCS macro is missing the prefix stack.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 cmds-inspect-dump-super.c | 4 ++--
 convert/common.c          | 2 +-
 ctree.h                   | 3 ++-
 disk-io.c                 | 8 ++++----
 mkfs/common.c             | 2 +-
 utils.c                   | 4 ++--
 6 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
index 299426f2..cd498d45 100644
--- a/cmds-inspect-dump-super.c
+++ b/cmds-inspect-dump-super.c
@@ -355,7 +355,7 @@ static void dump_superblock(struct btrfs_super_block *sb, int full)
 	s = (char *) &sb->magic;
 	for (i = 0; i < 8; i++)
 		putchar(isprint(s[i]) ? s[i] : '.');
-	if (btrfs_super_magic(sb) == BTRFS_MAGIC)
+	if (btrfs_stack_super_magic(sb) == BTRFS_MAGIC)
 		printf(" [match]\n");
 	else
 		printf(" [DON'T MATCH]\n");
@@ -478,7 +478,7 @@ static int load_and_dump_sb(char *filename, int fd, u64 sb_bytenr, int full,
 	}
 	printf("superblock: bytenr=%llu, device=%s\n", sb_bytenr, filename);
 	printf("---------------------------------------------------------\n");
-	if (btrfs_super_magic(sb) != BTRFS_MAGIC && !force) {
+	if (btrfs_stack_super_magic(sb) != BTRFS_MAGIC && !force) {
 		error("bad magic on superblock on %s at %llu",
 				filename, (unsigned long long)sb_bytenr);
 	} else {
diff --git a/convert/common.c b/convert/common.c
index d5ae385f..bc0cf67d 100644
--- a/convert/common.c
+++ b/convert/common.c
@@ -116,7 +116,7 @@ static int setup_temp_super(int fd, struct btrfs_mkfs_config *cfg,
 
 	btrfs_set_stack_super_bytenr(super, cfg->super_bytenr);
 	btrfs_set_stack_super_num_devices(super, 1);
-	btrfs_set_super_magic(super, BTRFS_MAGIC_PARTIAL);
+	btrfs_set_stack_super_magic(super, BTRFS_MAGIC_PARTIAL);
 	btrfs_set_stack_super_generation(super, 1);
 	btrfs_set_stack_super_root(super, root_bytenr);
 	btrfs_set_stack_super_chunk_root(super, chunk_bytenr);
diff --git a/ctree.h b/ctree.h
index c85aef9b..6c27f5f1 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2211,7 +2211,8 @@ BTRFS_SETGET_STACK_FUNCS(stack_super_cache_generation, struct btrfs_super_block,
 BTRFS_SETGET_STACK_FUNCS(stack_super_uuid_tree_generation,
 			 struct btrfs_super_block,
 			 uuid_tree_generation, 64);
-BTRFS_SETGET_STACK_FUNCS(super_magic, struct btrfs_super_block, magic, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_super_magic, struct btrfs_super_block, magic,
+			 64);
 
 static inline int btrfs_super_csum_size(struct btrfs_super_block *s)
 {
diff --git a/disk-io.c b/disk-io.c
index 11545e97..9b63ae2a 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1283,8 +1283,8 @@ static int check_super(struct btrfs_super_block *sb, unsigned sbflags)
 	u16 csum_type;
 	int csum_size;
 
-	if (btrfs_super_magic(sb) != BTRFS_MAGIC) {
-		if (btrfs_super_magic(sb) == BTRFS_MAGIC_PARTIAL) {
+	if (btrfs_stack_super_magic(sb) != BTRFS_MAGIC) {
+		if (btrfs_stack_super_magic(sb) == BTRFS_MAGIC_PARTIAL) {
 			if (!(sbflags & SBREAD_PARTIAL)) {
 				error("superblock magic doesn't match");
 				return -EIO;
@@ -1477,7 +1477,7 @@ int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr,
 		if (btrfs_stack_super_bytenr(buf) != bytenr)
 			continue;
 		/* if magic is NULL, the device was removed */
-		if (btrfs_super_magic(buf) == 0 && i == 0)
+		if (btrfs_stack_super_magic(buf) == 0 && i == 0)
 			break;
 		if (check_super(buf, sbflags))
 			continue;
@@ -1657,7 +1657,7 @@ int close_ctree_fs_info(struct btrfs_fs_info *fs_info)
 	}
 
 	if (fs_info->finalize_on_close) {
-		btrfs_set_super_magic(fs_info->super_copy, BTRFS_MAGIC);
+		btrfs_set_stack_super_magic(fs_info->super_copy, BTRFS_MAGIC);
 		root->fs_info->finalize_on_close = 0;
 		ret = write_all_supers(fs_info);
 		if (ret)
diff --git a/mkfs/common.c b/mkfs/common.c
index 6046d449..824d9014 100644
--- a/mkfs/common.c
+++ b/mkfs/common.c
@@ -160,7 +160,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
 
 	btrfs_set_stack_super_bytenr(&super, cfg->blocks[MKFS_SUPER_BLOCK]);
 	btrfs_set_stack_super_num_devices(&super, 1);
-	btrfs_set_super_magic(&super, BTRFS_MAGIC_PARTIAL);
+	btrfs_set_stack_super_magic(&super, BTRFS_MAGIC_PARTIAL);
 	btrfs_set_stack_super_generation(&super, 1);
 	btrfs_set_stack_super_root(&super, cfg->blocks[MKFS_ROOT_TREE]);
 	btrfs_set_stack_super_chunk_root(&super, cfg->blocks[MKFS_CHUNK_TREE]);
diff --git a/utils.c b/utils.c
index 79fa04ad..0f4306b9 100644
--- a/utils.c
+++ b/utils.c
@@ -1045,8 +1045,8 @@ int btrfs_device_already_in_root(struct btrfs_root *root, int fd,
 	 * Accept devices from the same filesystem, allow partially created
 	 * structures.
 	 */
-	if (btrfs_super_magic(disk_super) != BTRFS_MAGIC &&
-			btrfs_super_magic(disk_super) != BTRFS_MAGIC_PARTIAL)
+	if (btrfs_stack_super_magic(disk_super) != BTRFS_MAGIC &&
+		btrfs_stack_super_magic(disk_super) != BTRFS_MAGIC_PARTIAL)
 		goto brelse;
 
 	if (!memcmp(disk_super->fsid, root->fs_info->super_copy->fsid,
-- 
2.15.1



