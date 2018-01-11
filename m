Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:44389 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753620AbeAKFKW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 00:10:22 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 48EE849F5B3C
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 13:10:17 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 55/67] btrfs-progs: add the stack prefix for super_bytes_used set/get function
Date: Thu, 11 Jan 2018 13:09:27 +0800
Message-ID: <20180111050939.21251-56-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
References: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The super_bytes_used set/get function defined by
BTRFS_SETGET_STACK_FUNCS macro is missing the prefix stack.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 chunk-recover.c           | 5 +++--
 cmds-inspect-dump-super.c | 2 +-
 cmds-inspect-dump-tree.c  | 2 +-
 convert/common.c          | 2 +-
 ctree.h                   | 2 +-
 disk-io.c                 | 5 +++--
 extent-tree.c             | 6 +++---
 mkfs/common.c             | 2 +-
 mkfs/main.c               | 2 +-
 volumes.c                 | 3 ++-
 10 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/chunk-recover.c b/chunk-recover.c
index a01d4c4f..d9798d40 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -1069,12 +1069,13 @@ again:
 		del_nr++;
 		if (key.type == BTRFS_EXTENT_ITEM_KEY ||
 		    key.type == BTRFS_METADATA_ITEM_KEY) {
-			old_val = btrfs_super_bytes_used(fs_info->super_copy);
+			old_val = btrfs_stack_super_bytes_used(
+					fs_info->super_copy);
 			if (key.type == BTRFS_METADATA_ITEM_KEY)
 				old_val += fs_info->nodesize;
 			else
 				old_val += key.offset;
-			btrfs_set_super_bytes_used(fs_info->super_copy,
+			btrfs_set_stack_super_bytes_used(fs_info->super_copy,
 						   old_val);
 		}
 	}
diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
index 7855f8ce..80a58df7 100644
--- a/cmds-inspect-dump-super.c
+++ b/cmds-inspect-dump-super.c
@@ -392,7 +392,7 @@ static void dump_superblock(struct btrfs_super_block *sb, int full)
 	printf("total_bytes\t\t%llu\n",
 	       (unsigned long long)btrfs_stack_super_total_bytes(sb));
 	printf("bytes_used\t\t%llu\n",
-	       (unsigned long long)btrfs_super_bytes_used(sb));
+	       (unsigned long long)btrfs_stack_super_bytes_used(sb));
 	printf("sectorsize\t\t%llu\n",
 	       (unsigned long long)btrfs_super_sectorsize(sb));
 	printf("nodesize\t\t%llu\n",
diff --git a/cmds-inspect-dump-tree.c b/cmds-inspect-dump-tree.c
index 43cd1648..3b6fedd9 100644
--- a/cmds-inspect-dump-tree.c
+++ b/cmds-inspect-dump-tree.c
@@ -577,7 +577,7 @@ no_node:
 	printf("total bytes %llu\n",
 	(unsigned long long)btrfs_stack_super_total_bytes(info->super_copy));
 	printf("bytes used %llu\n",
-	       (unsigned long long)btrfs_super_bytes_used(info->super_copy));
+	(unsigned long long)btrfs_stack_super_bytes_used(info->super_copy));
 	uuidbuf[BTRFS_UUID_UNPARSED_SIZE - 1] = '\0';
 	uuid_unparse(info->super_copy->fsid, uuidbuf);
 	printf("uuid %s\n", uuidbuf);
diff --git a/convert/common.c b/convert/common.c
index 6f994699..d2aaf004 100644
--- a/convert/common.c
+++ b/convert/common.c
@@ -126,7 +126,7 @@ static int setup_temp_super(int fd, struct btrfs_mkfs_config *cfg,
 	 * chunk tree, root tree, extent_tree, device tree, fs tree
 	 * and csum tree.
 	 */
-	btrfs_set_super_bytes_used(super, 6 * cfg->nodesize);
+	btrfs_set_stack_super_bytes_used(super, 6 * cfg->nodesize);
 	btrfs_set_super_sectorsize(super, cfg->sectorsize);
 	super->__unused_leafsize = cpu_to_le32(cfg->nodesize);
 	btrfs_set_super_nodesize(super, cfg->nodesize);
diff --git a/ctree.h b/ctree.h
index 5df2f9d8..8550a0e2 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2186,7 +2186,7 @@ BTRFS_SETGET_STACK_FUNCS(stack_super_log_root_level, struct btrfs_super_block,
 			 log_root_level, 8);
 BTRFS_SETGET_STACK_FUNCS(stack_super_total_bytes, struct btrfs_super_block,
 			 total_bytes, 64);
-BTRFS_SETGET_STACK_FUNCS(super_bytes_used, struct btrfs_super_block,
+BTRFS_SETGET_STACK_FUNCS(stack_super_bytes_used, struct btrfs_super_block,
 			 bytes_used, 64);
 BTRFS_SETGET_STACK_FUNCS(super_sectorsize, struct btrfs_super_block,
 			 sectorsize, 32);
diff --git a/disk-io.c b/disk-io.c
index c6adb168..2d04c9cc 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1362,8 +1362,9 @@ static int check_super(struct btrfs_super_block *sb, unsigned sbflags)
 		error("invalid total_bytes 0");
 		goto error_out;
 	}
-	if (btrfs_super_bytes_used(sb) < 6 * btrfs_super_nodesize(sb)) {
-		error("invalid bytes_used %llu", btrfs_super_bytes_used(sb));
+	if (btrfs_stack_super_bytes_used(sb) < 6 * btrfs_super_nodesize(sb)) {
+		error("invalid bytes_used %llu",
+		      btrfs_stack_super_bytes_used(sb));
 		goto error_out;
 	}
 	if ((btrfs_super_stripesize(sb) != 4096)
diff --git a/extent-tree.c b/extent-tree.c
index a59761e3..bc4ffd21 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -1935,12 +1935,12 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 	u64 end;
 
 	/* block accounting for super block */
-	old_val = btrfs_super_bytes_used(info->super_copy);
+	old_val = btrfs_stack_super_bytes_used(info->super_copy);
 	if (alloc)
 		old_val += num_bytes;
 	else
 		old_val -= num_bytes;
-	btrfs_set_super_bytes_used(info->super_copy, old_val);
+	btrfs_set_stack_super_bytes_used(info->super_copy, old_val);
 
 	/* block accounting for root item */
 	old_val = btrfs_stack_root_used(&root->root_item);
@@ -3911,7 +3911,7 @@ int btrfs_fix_block_accounting(struct btrfs_trans_handle *trans,
 		}
 		path.slots[0]++;
 	}
-	btrfs_set_super_bytes_used(root->fs_info->super_copy, bytes_used);
+	btrfs_set_stack_super_bytes_used(root->fs_info->super_copy, bytes_used);
 	ret = 0;
 out:
 	btrfs_release_path(&path);
diff --git a/mkfs/common.c b/mkfs/common.c
index 60214c0e..69ccd146 100644
--- a/mkfs/common.c
+++ b/mkfs/common.c
@@ -165,7 +165,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
 	btrfs_set_stack_super_root(&super, cfg->blocks[MKFS_ROOT_TREE]);
 	btrfs_set_stack_super_chunk_root(&super, cfg->blocks[MKFS_CHUNK_TREE]);
 	btrfs_set_stack_super_total_bytes(&super, num_bytes);
-	btrfs_set_super_bytes_used(&super, 6 * cfg->nodesize);
+	btrfs_set_stack_super_bytes_used(&super, 6 * cfg->nodesize);
 	btrfs_set_super_sectorsize(&super, cfg->sectorsize);
 	super.__unused_leafsize = cpu_to_le32(cfg->nodesize);
 	btrfs_set_super_nodesize(&super, cfg->nodesize);
diff --git a/mkfs/main.c b/mkfs/main.c
index 0c58181f..5cf265ea 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -78,7 +78,7 @@ static int create_metadata_block_groups(struct btrfs_root *root, int mixed,
 
 	trans = btrfs_start_transaction(root, 1);
 	BUG_ON(IS_ERR(trans));
-	bytes_used = btrfs_super_bytes_used(fs_info->super_copy);
+	bytes_used = btrfs_stack_super_bytes_used(fs_info->super_copy);
 
 	root->fs_info->system_allocs = 1;
 	ret = btrfs_make_block_group(trans, fs_info, bytes_used,
diff --git a/volumes.c b/volumes.c
index 5ae2aa81..95480f41 100644
--- a/volumes.c
+++ b/volumes.c
@@ -130,7 +130,8 @@ static int device_list_add(const char *path,
 			return -ENOMEM;
 		}
 		device->total_devs = btrfs_super_num_devices(disk_super);
-		device->super_bytes_used = btrfs_super_bytes_used(disk_super);
+		device->super_bytes_used =
+			btrfs_stack_super_bytes_used(disk_super);
 		device->total_bytes =
 			btrfs_stack_device_total_bytes(&disk_super->dev_item);
 		device->bytes_used =
-- 
2.15.1



