Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:36208 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753919AbeAKFKL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 00:10:11 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 1053348AEA17
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 13:10:04 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 28/67] btrfs-progs: add the stack prefix for backup_extent_root_gen set/get function
Date: Thu, 11 Jan 2018 13:09:00 +0800
Message-ID: <20180111050939.21251-29-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
References: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The backup_extent_root_gen set/get function defined by
BTRFS_SETGET_STACK_FUNCS macro is missing the prefix stack.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 cmds-inspect-dump-super.c | 2 +-
 cmds-inspect-dump-tree.c  | 2 +-
 ctree.h                   | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
index fc38cd72..d1c9c90d 100644
--- a/cmds-inspect-dump-super.c
+++ b/cmds-inspect-dump-super.c
@@ -162,7 +162,7 @@ static void print_root_backup(struct btrfs_root_backup *backup)
 			btrfs_stack_backup_chunk_root_level(backup));
 	printf("\t\tbackup_extent_root:\t%llu\tgen: %llu\tlevel: %d\n",
 			btrfs_stack_backup_extent_root(backup),
-			btrfs_backup_extent_root_gen(backup),
+			btrfs_stack_backup_extent_root_gen(backup),
 			btrfs_backup_extent_root_level(backup));
 	printf("\t\tbackup_fs_root:\t\t%llu\tgen: %llu\tlevel: %d\n",
 			btrfs_backup_fs_root(backup),
diff --git a/cmds-inspect-dump-tree.c b/cmds-inspect-dump-tree.c
index 4fe401c8..d3634784 100644
--- a/cmds-inspect-dump-tree.c
+++ b/cmds-inspect-dump-tree.c
@@ -91,7 +91,7 @@ static void print_old_roots(struct btrfs_super_block *super)
 		(unsigned long long)btrfs_stack_backup_tree_root(backup));
 
 		printf("\t\textent root gen %llu block %llu\n",
-		(unsigned long long)btrfs_backup_extent_root_gen(backup),
+		(unsigned long long)btrfs_stack_backup_extent_root_gen(backup),
 		(unsigned long long)btrfs_stack_backup_extent_root(backup));
 
 		printf("\t\tchunk root gen %llu block %llu\n",
diff --git a/ctree.h b/ctree.h
index d5a18704..b77a3f1e 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2126,7 +2126,7 @@ BTRFS_SETGET_STACK_FUNCS(stack_backup_chunk_root_level,
 
 BTRFS_SETGET_STACK_FUNCS(stack_backup_extent_root, struct btrfs_root_backup,
 		   extent_root, 64);
-BTRFS_SETGET_STACK_FUNCS(backup_extent_root_gen, struct btrfs_root_backup,
+BTRFS_SETGET_STACK_FUNCS(stack_backup_extent_root_gen, struct btrfs_root_backup,
 		   extent_root_gen, 64);
 BTRFS_SETGET_STACK_FUNCS(backup_extent_root_level, struct btrfs_root_backup,
 		   extent_root_level, 8);
-- 
2.15.1



