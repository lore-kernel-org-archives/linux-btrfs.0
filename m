Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:54301 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754073AbeAKFKb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 00:10:31 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id C478849F0E41
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 13:10:17 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 56/67] btrfs-progs: add the stack prefix for super_sectorsize set/get function
Date: Thu, 11 Jan 2018 13:09:28 +0800
Message-ID: <20180111050939.21251-57-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
References: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The super_sectorsize set/get function defined by
BTRFS_SETGET_STACK_FUNCS macro is missing the prefix stack.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 chunk-recover.c           |  4 ++--
 cmds-inspect-dump-super.c |  2 +-
 convert/common.c          |  2 +-
 ctree.h                   |  2 +-
 disk-io.c                 | 14 ++++++++------
 image/main.c              |  2 +-
 mkfs/common.c             |  2 +-
 7 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/chunk-recover.c b/chunk-recover.c
index d9798d40..c91236d4 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -1475,7 +1475,7 @@ open_ctree_with_broken_chunk(struct recover_control *rc)
 	}
 
 	memcpy(fs_info->fsid, &disk_super->fsid, BTRFS_FSID_SIZE);
-	fs_info->sectorsize = btrfs_super_sectorsize(disk_super);
+	fs_info->sectorsize = btrfs_stack_super_sectorsize(disk_super);
 	fs_info->nodesize = btrfs_super_nodesize(disk_super);
 	fs_info->stripesize = btrfs_super_stripesize(disk_super);
 
@@ -1534,7 +1534,7 @@ static int recover_prepare(struct recover_control *rc, char *path)
 		goto out_close_fd;
 	}
 
-	rc->sectorsize = btrfs_super_sectorsize(sb);
+	rc->sectorsize = btrfs_stack_super_sectorsize(sb);
 	rc->nodesize = btrfs_super_nodesize(sb);
 	rc->generation = btrfs_stack_super_generation(sb);
 	rc->chunk_root_generation = btrfs_stack_super_chunk_root_generation(sb);
diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
index 80a58df7..42ee7b2b 100644
--- a/cmds-inspect-dump-super.c
+++ b/cmds-inspect-dump-super.c
@@ -394,7 +394,7 @@ static void dump_superblock(struct btrfs_super_block *sb, int full)
 	printf("bytes_used\t\t%llu\n",
 	       (unsigned long long)btrfs_stack_super_bytes_used(sb));
 	printf("sectorsize\t\t%llu\n",
-	       (unsigned long long)btrfs_super_sectorsize(sb));
+	       (unsigned long long)btrfs_stack_super_sectorsize(sb));
 	printf("nodesize\t\t%llu\n",
 	       (unsigned long long)btrfs_super_nodesize(sb));
 	printf("leafsize (deprecated)\t\t%u\n",
diff --git a/convert/common.c b/convert/common.c
index d2aaf004..307255fa 100644
--- a/convert/common.c
+++ b/convert/common.c
@@ -127,7 +127,7 @@ static int setup_temp_super(int fd, struct btrfs_mkfs_config *cfg,
 	 * and csum tree.
 	 */
 	btrfs_set_stack_super_bytes_used(super, 6 * cfg->nodesize);
-	btrfs_set_super_sectorsize(super, cfg->sectorsize);
+	btrfs_set_stack_super_sectorsize(super, cfg->sectorsize);
 	super->__unused_leafsize = cpu_to_le32(cfg->nodesize);
 	btrfs_set_super_nodesize(super, cfg->nodesize);
 	btrfs_set_super_stripesize(super, cfg->stripesize);
diff --git a/ctree.h b/ctree.h
index 8550a0e2..05b88c6a 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2188,7 +2188,7 @@ BTRFS_SETGET_STACK_FUNCS(stack_super_total_bytes, struct btrfs_super_block,
 			 total_bytes, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_super_bytes_used, struct btrfs_super_block,
 			 bytes_used, 64);
-BTRFS_SETGET_STACK_FUNCS(super_sectorsize, struct btrfs_super_block,
+BTRFS_SETGET_STACK_FUNCS(stack_super_sectorsize, struct btrfs_super_block,
 			 sectorsize, 32);
 BTRFS_SETGET_STACK_FUNCS(super_nodesize, struct btrfs_super_block,
 			 nodesize, 32);
diff --git a/disk-io.c b/disk-io.c
index 2d04c9cc..1bbac5bf 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1162,7 +1162,7 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 	}
 
 	memcpy(fs_info->fsid, &disk_super->fsid, BTRFS_FSID_SIZE);
-	fs_info->sectorsize = btrfs_super_sectorsize(disk_super);
+	fs_info->sectorsize = btrfs_stack_super_sectorsize(disk_super);
 	fs_info->nodesize = btrfs_super_nodesize(disk_super);
 	fs_info->stripesize = btrfs_super_stripesize(disk_super);
 
@@ -1349,13 +1349,14 @@ static int check_super(struct btrfs_super_block *sb, unsigned sbflags)
 		error("nodesize unaligned: %u", btrfs_super_nodesize(sb));
 		goto error_out;
 	}
-	if (btrfs_super_sectorsize(sb) < 4096) {
+	if (btrfs_stack_super_sectorsize(sb) < 4096) {
 		error("sectorsize too small: %u < 4096",
-			btrfs_super_sectorsize(sb));
+			btrfs_stack_super_sectorsize(sb));
 		goto error_out;
 	}
-	if (!IS_ALIGNED(btrfs_super_sectorsize(sb), 4096)) {
-		error("sectorsize unaligned: %u", btrfs_super_sectorsize(sb));
+	if (!IS_ALIGNED(btrfs_stack_super_sectorsize(sb), 4096)) {
+		error("sectorsize unaligned: %u",
+		      btrfs_stack_super_sectorsize(sb));
 		goto error_out;
 	}
 	if (btrfs_stack_super_total_bytes(sb) == 0) {
@@ -1368,7 +1369,8 @@ static int check_super(struct btrfs_super_block *sb, unsigned sbflags)
 		goto error_out;
 	}
 	if ((btrfs_super_stripesize(sb) != 4096)
-		&& (btrfs_super_stripesize(sb) != btrfs_super_sectorsize(sb))) {
+		&& (btrfs_super_stripesize(sb) !=
+			btrfs_stack_super_sectorsize(sb))) {
 		error("invalid stripesize %u", btrfs_super_stripesize(sb));
 		goto error_out;
 	}
diff --git a/image/main.c b/image/main.c
index b8ab1598..a4c5a8ad 100644
--- a/image/main.c
+++ b/image/main.c
@@ -1090,7 +1090,7 @@ static void update_super_old(u8 *buffer)
 	struct btrfs_super_block *super = (struct btrfs_super_block *)buffer;
 	struct btrfs_chunk *chunk;
 	struct btrfs_disk_key *key;
-	u32 sectorsize = btrfs_super_sectorsize(super);
+	u32 sectorsize = btrfs_stack_super_sectorsize(super);
 	u64 flags = btrfs_stack_super_flags(super);
 
 	flags |= BTRFS_SUPER_FLAG_METADUMP;
diff --git a/mkfs/common.c b/mkfs/common.c
index 69ccd146..ed491c20 100644
--- a/mkfs/common.c
+++ b/mkfs/common.c
@@ -166,7 +166,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
 	btrfs_set_stack_super_chunk_root(&super, cfg->blocks[MKFS_CHUNK_TREE]);
 	btrfs_set_stack_super_total_bytes(&super, num_bytes);
 	btrfs_set_stack_super_bytes_used(&super, 6 * cfg->nodesize);
-	btrfs_set_super_sectorsize(&super, cfg->sectorsize);
+	btrfs_set_stack_super_sectorsize(&super, cfg->sectorsize);
 	super.__unused_leafsize = cpu_to_le32(cfg->nodesize);
 	btrfs_set_super_nodesize(&super, cfg->nodesize);
 	btrfs_set_super_stripesize(&super, cfg->stripesize);
-- 
2.15.1



