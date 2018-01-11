Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:42499 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754020AbeAKFKb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 00:10:31 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id B327B49F0E42
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 13:10:18 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 58/67] btrfs-progs: add the stack prefix for super_stripesize set/get function
Date: Thu, 11 Jan 2018 13:09:30 +0800
Message-ID: <20180111050939.21251-59-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
References: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The super_stripesize set/get function defined by
BTRFS_SETGET_STACK_FUNCS macro is missing the prefix stack.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 chunk-recover.c           | 2 +-
 cmds-inspect-dump-super.c | 2 +-
 convert/common.c          | 2 +-
 ctree.h                   | 2 +-
 disk-io.c                 | 9 +++++----
 mkfs/common.c             | 2 +-
 volumes.c                 | 4 ++--
 7 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/chunk-recover.c b/chunk-recover.c
index 788b241b..ad0f36f5 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -1477,7 +1477,7 @@ open_ctree_with_broken_chunk(struct recover_control *rc)
 	memcpy(fs_info->fsid, &disk_super->fsid, BTRFS_FSID_SIZE);
 	fs_info->sectorsize = btrfs_stack_super_sectorsize(disk_super);
 	fs_info->nodesize = btrfs_stack_super_nodesize(disk_super);
-	fs_info->stripesize = btrfs_super_stripesize(disk_super);
+	fs_info->stripesize = btrfs_stack_super_stripesize(disk_super);
 
 	ret = btrfs_check_fs_compatibility(disk_super, OPEN_CTREE_WRITES);
 	if (ret)
diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
index 7320bc28..1a92a8dd 100644
--- a/cmds-inspect-dump-super.c
+++ b/cmds-inspect-dump-super.c
@@ -400,7 +400,7 @@ static void dump_superblock(struct btrfs_super_block *sb, int full)
 	printf("leafsize (deprecated)\t\t%u\n",
 	       le32_to_cpu(sb->__unused_leafsize));
 	printf("stripesize\t\t%llu\n",
-	       (unsigned long long)btrfs_super_stripesize(sb));
+	       (unsigned long long)btrfs_stack_super_stripesize(sb));
 	printf("root_dir\t\t%llu\n",
 	       (unsigned long long)btrfs_super_root_dir(sb));
 	printf("num_devices\t\t%llu\n",
diff --git a/convert/common.c b/convert/common.c
index 81fe80df..b83bfbcd 100644
--- a/convert/common.c
+++ b/convert/common.c
@@ -130,7 +130,7 @@ static int setup_temp_super(int fd, struct btrfs_mkfs_config *cfg,
 	btrfs_set_stack_super_sectorsize(super, cfg->sectorsize);
 	super->__unused_leafsize = cpu_to_le32(cfg->nodesize);
 	btrfs_set_stack_super_nodesize(super, cfg->nodesize);
-	btrfs_set_super_stripesize(super, cfg->stripesize);
+	btrfs_set_stack_super_stripesize(super, cfg->stripesize);
 	btrfs_set_super_csum_type(super, BTRFS_CSUM_TYPE_CRC32);
 	btrfs_set_stack_super_chunk_root(super, chunk_bytenr);
 	btrfs_set_super_cache_generation(super, -1);
diff --git a/ctree.h b/ctree.h
index a8bad6f2..ccad87e8 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2192,7 +2192,7 @@ BTRFS_SETGET_STACK_FUNCS(stack_super_sectorsize, struct btrfs_super_block,
 			 sectorsize, 32);
 BTRFS_SETGET_STACK_FUNCS(stack_super_nodesize, struct btrfs_super_block,
 			 nodesize, 32);
-BTRFS_SETGET_STACK_FUNCS(super_stripesize, struct btrfs_super_block,
+BTRFS_SETGET_STACK_FUNCS(stack_super_stripesize, struct btrfs_super_block,
 			 stripesize, 32);
 BTRFS_SETGET_STACK_FUNCS(super_root_dir, struct btrfs_super_block,
 			 root_dir_objectid, 64);
diff --git a/disk-io.c b/disk-io.c
index d17c4163..16fb9afd 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1164,7 +1164,7 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 	memcpy(fs_info->fsid, &disk_super->fsid, BTRFS_FSID_SIZE);
 	fs_info->sectorsize = btrfs_stack_super_sectorsize(disk_super);
 	fs_info->nodesize = btrfs_stack_super_nodesize(disk_super);
-	fs_info->stripesize = btrfs_super_stripesize(disk_super);
+	fs_info->stripesize = btrfs_stack_super_stripesize(disk_super);
 
 	ret = btrfs_check_fs_compatibility(fs_info->super_copy, flags);
 	if (ret)
@@ -1369,10 +1369,11 @@ static int check_super(struct btrfs_super_block *sb, unsigned sbflags)
 		      btrfs_stack_super_bytes_used(sb));
 		goto error_out;
 	}
-	if ((btrfs_super_stripesize(sb) != 4096)
-		&& (btrfs_super_stripesize(sb) !=
+	if ((btrfs_stack_super_stripesize(sb) != 4096)
+		&& (btrfs_stack_super_stripesize(sb) !=
 			btrfs_stack_super_sectorsize(sb))) {
-		error("invalid stripesize %u", btrfs_super_stripesize(sb));
+		error("invalid stripesize %u",
+		      btrfs_stack_super_stripesize(sb));
 		goto error_out;
 	}
 
diff --git a/mkfs/common.c b/mkfs/common.c
index d51f2e15..6a8fdb19 100644
--- a/mkfs/common.c
+++ b/mkfs/common.c
@@ -169,7 +169,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
 	btrfs_set_stack_super_sectorsize(&super, cfg->sectorsize);
 	super.__unused_leafsize = cpu_to_le32(cfg->nodesize);
 	btrfs_set_stack_super_nodesize(&super, cfg->nodesize);
-	btrfs_set_super_stripesize(&super, cfg->stripesize);
+	btrfs_set_stack_super_stripesize(&super, cfg->stripesize);
 	btrfs_set_super_csum_type(&super, BTRFS_CSUM_TYPE_CRC32);
 	btrfs_set_stack_super_chunk_root_generation(&super, 1);
 	btrfs_set_super_cache_generation(&super, -1);
diff --git a/volumes.c b/volumes.c
index 95480f41..5df064b3 100644
--- a/volumes.c
+++ b/volumes.c
@@ -938,7 +938,7 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 			return -ENOSPC;
 		min_stripes = 2;
 		stripe_len = find_raid56_stripe_len(num_stripes - 1,
-				    btrfs_super_stripesize(info->super_copy));
+				btrfs_stack_super_stripesize(info->super_copy));
 	}
 	if (type & (BTRFS_BLOCK_GROUP_RAID6)) {
 		num_stripes = btrfs_super_num_devices(info->super_copy);
@@ -948,7 +948,7 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 			return -ENOSPC;
 		min_stripes = 3;
 		stripe_len = find_raid56_stripe_len(num_stripes - 2,
-				    btrfs_super_stripesize(info->super_copy));
+				btrfs_stack_super_stripesize(info->super_copy));
 	}
 
 	/* we don't want a chunk larger than 10% of the FS */
-- 
2.15.1



