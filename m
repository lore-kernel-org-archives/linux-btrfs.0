Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:36208 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753849AbeAKFKM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 00:10:12 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 6D07548AEA0A
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 13:10:00 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 21/67] btrfs-progs: add the stack prefix for backup_tree_root set/get function
Date: Thu, 11 Jan 2018 13:08:53 +0800
Message-ID: <20180111050939.21251-22-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
References: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The backup_tree_root set/get function defined by
BTRFS_SETGET_STACK_FUNCS macro is missing the prefix stack.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 cmds-inspect-dump-super.c | 2 +-
 cmds-inspect-dump-tree.c  | 4 ++--
 ctree.h                   | 2 +-
 disk-io.c                 | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
index 23a71155..a9962ee3 100644
--- a/cmds-inspect-dump-super.c
+++ b/cmds-inspect-dump-super.c
@@ -153,7 +153,7 @@ static int empty_backup(struct btrfs_root_backup *backup)
 static void print_root_backup(struct btrfs_root_backup *backup)
 {
 	printf("\t\tbackup_tree_root:\t%llu\tgen: %llu\tlevel: %d\n",
-			btrfs_backup_tree_root(backup),
+			btrfs_stack_backup_tree_root(backup),
 			btrfs_backup_tree_root_gen(backup),
 			btrfs_backup_tree_root_level(backup));
 	printf("\t\tbackup_chunk_root:\t%llu\tgen: %llu\tlevel: %d\n",
diff --git a/cmds-inspect-dump-tree.c b/cmds-inspect-dump-tree.c
index 66e7227d..bb94ae8f 100644
--- a/cmds-inspect-dump-tree.c
+++ b/cmds-inspect-dump-tree.c
@@ -87,8 +87,8 @@ static void print_old_roots(struct btrfs_super_block *super)
 		backup = super->super_roots + i;
 		printf("btrfs root backup slot %d\n", i);
 		printf("\ttree root gen %llu block %llu\n",
-		       (unsigned long long)btrfs_backup_tree_root_gen(backup),
-		       (unsigned long long)btrfs_backup_tree_root(backup));
+		(unsigned long long)btrfs_backup_tree_root_gen(backup),
+		(unsigned long long)btrfs_stack_backup_tree_root(backup));
 
 		printf("\t\textent root gen %llu block %llu\n",
 		       (unsigned long long)btrfs_backup_extent_root_gen(backup),
diff --git a/ctree.h b/ctree.h
index fa05adea..189c1b0c 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2109,7 +2109,7 @@ static inline struct btrfs_timespec* btrfs_root_rtime(
 }
 
 /* struct btrfs_root_backup */
-BTRFS_SETGET_STACK_FUNCS(backup_tree_root, struct btrfs_root_backup,
+BTRFS_SETGET_STACK_FUNCS(stack_backup_tree_root, struct btrfs_root_backup,
 		   tree_root, 64);
 BTRFS_SETGET_STACK_FUNCS(backup_tree_root_gen, struct btrfs_root_backup,
 		   tree_root_gen, 64);
diff --git a/disk-io.c b/disk-io.c
index 6f9258d2..8d226e38 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -859,7 +859,7 @@ int btrfs_setup_all_roots(struct btrfs_fs_info *fs_info, u64 root_tree_bytenr,
 			return -EIO;
 		}
 		backup = fs_info->super_copy->super_roots + index;
-		root_tree_bytenr = btrfs_backup_tree_root(backup);
+		root_tree_bytenr = btrfs_stack_backup_tree_root(backup);
 		generation = btrfs_backup_tree_root_gen(backup);
 	}
 
-- 
2.15.1



