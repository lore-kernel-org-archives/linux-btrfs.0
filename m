Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:54301 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754067AbeAKFKZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 00:10:25 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 678E048AEA18
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 13:10:15 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 51/67] btrfs-progs: add the stack prefix for super_log_root set/get function
Date: Thu, 11 Jan 2018 13:09:23 +0800
Message-ID: <20180111050939.21251-52-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
References: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The super_log_root set/get function defined by
BTRFS_SETGET_STACK_FUNCS macro is missing the prefix stack.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 btrfs-zero-log.c          | 4 ++--
 cmds-check.c              | 4 ++--
 cmds-inspect-dump-super.c | 2 +-
 cmds-rescue.c             | 4 ++--
 ctree.h                   | 2 +-
 disk-io.c                 | 6 +++---
 image/main.c              | 2 +-
 7 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/btrfs-zero-log.c b/btrfs-zero-log.c
index 2fce59e9..0b6bf539 100644
--- a/btrfs-zero-log.c
+++ b/btrfs-zero-log.c
@@ -65,11 +65,11 @@ int main(int argc, char **argv)
 	sb = root->fs_info->super_copy;
 	printf("Clearing log on %s, previous log_root %llu, level %u\n",
 			argv[optind],
-			(unsigned long long)btrfs_super_log_root(sb),
+			(unsigned long long)btrfs_stack_super_log_root(sb),
 			(unsigned)btrfs_super_log_root_level(sb));
 	trans = btrfs_start_transaction(root, 1);
 	BUG_ON(IS_ERR(trans));
-	btrfs_set_super_log_root(root->fs_info->super_copy, 0);
+	btrfs_set_stack_super_log_root(root->fs_info->super_copy, 0);
 	btrfs_set_super_log_root_level(root->fs_info->super_copy, 0);
 	btrfs_commit_transaction(trans, root);
 	close_ctree(root);
diff --git a/cmds-check.c b/cmds-check.c
index 6218eddb..b184aa48 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -13967,7 +13967,7 @@ static int zero_log_tree(struct btrfs_root *root)
 		ret = PTR_ERR(trans);
 		return ret;
 	}
-	btrfs_set_super_log_root(root->fs_info->super_copy, 0);
+	btrfs_set_stack_super_log_root(root->fs_info->super_copy, 0);
 	btrfs_set_super_log_root_level(root->fs_info->super_copy, 0);
 	ret = btrfs_commit_transaction(trans, root);
 	return ret;
@@ -14868,7 +14868,7 @@ int cmd_check(int argc, char **argv)
 	 * repair mode will force us to commit transaction which
 	 * will make us fail to load log tree when mounting.
 	 */
-	if (repair && btrfs_super_log_root(info->super_copy)) {
+	if (repair && btrfs_stack_super_log_root(info->super_copy)) {
 		ret = ask_user("repair mode will force to clear out log tree, are you sure?");
 		if (!ret) {
 			ret = 1;
diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
index c4bc3621..91db9d4a 100644
--- a/cmds-inspect-dump-super.c
+++ b/cmds-inspect-dump-super.c
@@ -384,7 +384,7 @@ static void dump_superblock(struct btrfs_super_block *sb, int full)
 	printf("chunk_root_level\t%llu\n",
 	       (unsigned long long)btrfs_stack_super_chunk_root_level(sb));
 	printf("log_root\t\t%llu\n",
-	       (unsigned long long)btrfs_super_log_root(sb));
+	       (unsigned long long)btrfs_stack_super_log_root(sb));
 	printf("log_root_transid\t%llu\n",
 	       (unsigned long long)btrfs_super_log_root_transid(sb));
 	printf("log_root_level\t\t%llu\n",
diff --git a/cmds-rescue.c b/cmds-rescue.c
index c40088ad..b3baf47c 100644
--- a/cmds-rescue.c
+++ b/cmds-rescue.c
@@ -190,11 +190,11 @@ static int cmd_rescue_zero_log(int argc, char **argv)
 	sb = root->fs_info->super_copy;
 	printf("Clearing log on %s, previous log_root %llu, level %u\n",
 			devname,
-			(unsigned long long)btrfs_super_log_root(sb),
+			(unsigned long long)btrfs_stack_super_log_root(sb),
 			(unsigned)btrfs_super_log_root_level(sb));
 	trans = btrfs_start_transaction(root, 1);
 	BUG_ON(IS_ERR(trans));
-	btrfs_set_super_log_root(sb, 0);
+	btrfs_set_stack_super_log_root(sb, 0);
 	btrfs_set_super_log_root_level(sb, 0);
 	btrfs_commit_transaction(trans, root);
 	close_ctree(root);
diff --git a/ctree.h b/ctree.h
index e413b76a..854aa548 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2178,7 +2178,7 @@ BTRFS_SETGET_STACK_FUNCS(stack_super_chunk_root, struct btrfs_super_block,
 			 chunk_root, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_super_chunk_root_level, struct btrfs_super_block,
 			 chunk_root_level, 8);
-BTRFS_SETGET_STACK_FUNCS(super_log_root, struct btrfs_super_block,
+BTRFS_SETGET_STACK_FUNCS(stack_super_log_root, struct btrfs_super_block,
 			 log_root, 64);
 BTRFS_SETGET_STACK_FUNCS(super_log_root_transid, struct btrfs_super_block,
 			 log_root_transid, 64);
diff --git a/disk-io.c b/disk-io.c
index 4995c295..183121cc 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -507,7 +507,7 @@ static int find_and_setup_log_root(struct btrfs_root *tree_root,
 			       struct btrfs_fs_info *fs_info,
 			       struct btrfs_super_block *disk_super)
 {
-	u64 blocknr = btrfs_super_log_root(disk_super);
+	u64 blocknr = btrfs_stack_super_log_root(disk_super);
 	struct btrfs_root *log_root = malloc(sizeof(struct btrfs_root));
 
 	if (!log_root)
@@ -1335,9 +1335,9 @@ static int check_super(struct btrfs_super_block *sb, unsigned sbflags)
 			btrfs_stack_super_chunk_root(sb));
 		goto error_out;
 	}
-	if (!IS_ALIGNED(btrfs_super_log_root(sb), 4096)) {
+	if (!IS_ALIGNED(btrfs_stack_super_log_root(sb), 4096)) {
 		error("log_root block unaligned: %llu",
-			btrfs_super_log_root(sb));
+			btrfs_stack_super_log_root(sb));
 		goto error_out;
 	}
 	if (btrfs_super_nodesize(sb) < 4096) {
diff --git a/image/main.c b/image/main.c
index 718ab88e..b8ab1598 100644
--- a/image/main.c
+++ b/image/main.c
@@ -819,7 +819,7 @@ static int copy_tree_blocks(struct btrfs_root *root, struct extent_buffer *eb,
 static int copy_log_trees(struct btrfs_root *root,
 			  struct metadump_struct *metadump)
 {
-	u64 blocknr = btrfs_super_log_root(root->fs_info->super_copy);
+	u64 blocknr = btrfs_stack_super_log_root(root->fs_info->super_copy);
 
 	if (blocknr == 0)
 		return 0;
-- 
2.15.1



