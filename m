Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:44389 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753956AbeAKFKN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 00:10:13 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id DF7BC48AEA0B
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 13:10:00 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 22/67] btrfs-progs: add the stack prefix for backup_tree_root_gen set/get function
Date: Thu, 11 Jan 2018 13:08:54 +0800
Message-ID: <20180111050939.21251-23-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
References: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The backup_tree_root_gen set/get function defined by
BTRFS_SETGET_STACK_FUNCS macro is missing the prefix stack.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 cmds-inspect-dump-super.c | 2 +-
 cmds-inspect-dump-tree.c  | 2 +-
 ctree.h                   | 2 +-
 disk-io.c                 | 8 ++++----
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
index a9962ee3..69b4da4e 100644
--- a/cmds-inspect-dump-super.c
+++ b/cmds-inspect-dump-super.c
@@ -154,7 +154,7 @@ static void print_root_backup(struct btrfs_root_backup *backup)
 {
 	printf("\t\tbackup_tree_root:\t%llu\tgen: %llu\tlevel: %d\n",
 			btrfs_stack_backup_tree_root(backup),
-			btrfs_backup_tree_root_gen(backup),
+			btrfs_stack_backup_tree_root_gen(backup),
 			btrfs_backup_tree_root_level(backup));
 	printf("\t\tbackup_chunk_root:\t%llu\tgen: %llu\tlevel: %d\n",
 			btrfs_backup_chunk_root(backup),
diff --git a/cmds-inspect-dump-tree.c b/cmds-inspect-dump-tree.c
index bb94ae8f..326c8f90 100644
--- a/cmds-inspect-dump-tree.c
+++ b/cmds-inspect-dump-tree.c
@@ -87,7 +87,7 @@ static void print_old_roots(struct btrfs_super_block *super)
 		backup = super->super_roots + i;
 		printf("btrfs root backup slot %d\n", i);
 		printf("\ttree root gen %llu block %llu\n",
-		(unsigned long long)btrfs_backup_tree_root_gen(backup),
+		(unsigned long long)btrfs_stack_backup_tree_root_gen(backup),
 		(unsigned long long)btrfs_stack_backup_tree_root(backup));
 
 		printf("\t\textent root gen %llu block %llu\n",
diff --git a/ctree.h b/ctree.h
index 189c1b0c..7acc7620 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2111,7 +2111,7 @@ static inline struct btrfs_timespec* btrfs_root_rtime(
 /* struct btrfs_root_backup */
 BTRFS_SETGET_STACK_FUNCS(stack_backup_tree_root, struct btrfs_root_backup,
 		   tree_root, 64);
-BTRFS_SETGET_STACK_FUNCS(backup_tree_root_gen, struct btrfs_root_backup,
+BTRFS_SETGET_STACK_FUNCS(stack_backup_tree_root_gen, struct btrfs_root_backup,
 		   tree_root_gen, 64);
 BTRFS_SETGET_STACK_FUNCS(backup_tree_root_level, struct btrfs_root_backup,
 		   tree_root_level, 8);
diff --git a/disk-io.c b/disk-io.c
index 8d226e38..ef147a40 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -800,10 +800,10 @@ static int find_best_backup_root(struct btrfs_super_block *super)
 
 	for (i = 0; i < BTRFS_NUM_BACKUP_ROOTS; i++) {
 		backup = super->super_roots + i;
-		if (btrfs_backup_tree_root_gen(backup) != orig_gen &&
-		    btrfs_backup_tree_root_gen(backup) > gen) {
+		if (btrfs_stack_backup_tree_root_gen(backup) != orig_gen &&
+		    btrfs_stack_backup_tree_root_gen(backup) > gen) {
 			best_index = i;
-			gen = btrfs_backup_tree_root_gen(backup);
+			gen = btrfs_stack_backup_tree_root_gen(backup);
 		}
 	}
 	return best_index;
@@ -860,7 +860,7 @@ int btrfs_setup_all_roots(struct btrfs_fs_info *fs_info, u64 root_tree_bytenr,
 		}
 		backup = fs_info->super_copy->super_roots + index;
 		root_tree_bytenr = btrfs_stack_backup_tree_root(backup);
-		generation = btrfs_backup_tree_root_gen(backup);
+		generation = btrfs_stack_backup_tree_root_gen(backup);
 	}
 
 	root->node = read_tree_block(fs_info, root_tree_bytenr, generation);
-- 
2.15.1



