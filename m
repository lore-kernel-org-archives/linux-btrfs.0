Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:12011 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753683AbeAKFKZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 00:10:25 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 0505B48AEA11
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 13:10:14 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 48/67] btrfs-progs: add the stack prefix for super_root_level set/get function
Date: Thu, 11 Jan 2018 13:09:20 +0800
Message-ID: <20180111050939.21251-49-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
References: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The super_root_level set/get function defined by
BTRFS_SETGET_STACK_FUNCS macro is missing the prefix stack.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 btrfs-find-root.c         | 2 +-
 cmds-inspect-dump-super.c | 2 +-
 ctree.h                   | 2 +-
 disk-io.c                 | 6 +++---
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/btrfs-find-root.c b/btrfs-find-root.c
index 56179935..fc8debea 100644
--- a/btrfs-find-root.c
+++ b/btrfs-find-root.c
@@ -64,7 +64,7 @@ static void get_root_gen_and_level(u64 objectid, struct btrfs_fs_info *fs_info,
 
 	switch (objectid) {
 	case BTRFS_ROOT_TREE_OBJECTID:
-		level = btrfs_super_root_level(super);
+		level = btrfs_stack_super_root_level(super);
 		gen = btrfs_stack_super_generation(super);
 		break;
 	case BTRFS_CHUNK_TREE_OBJECTID:
diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
index 49cabca0..39c8b536 100644
--- a/cmds-inspect-dump-super.c
+++ b/cmds-inspect-dump-super.c
@@ -378,7 +378,7 @@ static void dump_superblock(struct btrfs_super_block *sb, int full)
 	printf("chunk_root_generation\t%llu\n",
 	       (unsigned long long)btrfs_stack_super_chunk_root_generation(sb));
 	printf("root_level\t\t%llu\n",
-	       (unsigned long long)btrfs_super_root_level(sb));
+	       (unsigned long long)btrfs_stack_super_root_level(sb));
 	printf("chunk_root\t\t%llu\n",
 	       (unsigned long long)btrfs_super_chunk_root(sb));
 	printf("chunk_root_level\t%llu\n",
diff --git a/ctree.h b/ctree.h
index 919ada4b..3ca18e22 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2172,7 +2172,7 @@ BTRFS_SETGET_STACK_FUNCS(stack_super_sys_array_size,
 			 struct btrfs_super_block, sys_chunk_array_size, 32);
 BTRFS_SETGET_STACK_FUNCS(stack_super_chunk_root_generation,
 			 struct btrfs_super_block, chunk_root_generation, 64);
-BTRFS_SETGET_STACK_FUNCS(super_root_level, struct btrfs_super_block,
+BTRFS_SETGET_STACK_FUNCS(stack_super_root_level, struct btrfs_super_block,
 			 root_level, 8);
 BTRFS_SETGET_STACK_FUNCS(super_chunk_root, struct btrfs_super_block,
 			 chunk_root, 64);
diff --git a/disk-io.c b/disk-io.c
index 9b3b64c5..e9411681 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1308,9 +1308,9 @@ static int check_super(struct btrfs_super_block *sb, unsigned sbflags)
 		error("superblock checksum mismatch");
 		return -EIO;
 	}
-	if (btrfs_super_root_level(sb) >= BTRFS_MAX_LEVEL) {
+	if (btrfs_stack_super_root_level(sb) >= BTRFS_MAX_LEVEL) {
 		error("tree_root level too big: %d >= %d",
-			btrfs_super_root_level(sb), BTRFS_MAX_LEVEL);
+			btrfs_stack_super_root_level(sb), BTRFS_MAX_LEVEL);
 		goto error_out;
 	}
 	if (btrfs_super_chunk_root_level(sb) >= BTRFS_MAX_LEVEL) {
@@ -1609,7 +1609,7 @@ int write_ctree_super(struct btrfs_trans_handle *trans,
 				   trans->transid);
 	btrfs_set_stack_super_root(fs_info->super_copy,
 			     tree_root->node->start);
-	btrfs_set_super_root_level(fs_info->super_copy,
+	btrfs_set_stack_super_root_level(fs_info->super_copy,
 				   btrfs_header_level(tree_root->node));
 	btrfs_set_super_chunk_root(fs_info->super_copy,
 				   chunk_root->node->start);
-- 
2.15.1



