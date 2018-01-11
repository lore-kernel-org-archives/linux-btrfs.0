Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:44389 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753974AbeAKFKP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 00:10:15 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 008F949F5B3A
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 13:10:05 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 30/67] btrfs-progs: add the stack prefix for backup_fs_root set/get function
Date: Thu, 11 Jan 2018 13:09:02 +0800
Message-ID: <20180111050939.21251-31-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
References: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The backup_fs_root set/get function defined by
BTRFS_SETGET_STACK_FUNCS macro is missing the prefix stack.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 cmds-inspect-dump-super.c | 2 +-
 cmds-inspect-dump-tree.c  | 2 +-
 ctree.h                   | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
index e7e2ada2..624f0e91 100644
--- a/cmds-inspect-dump-super.c
+++ b/cmds-inspect-dump-super.c
@@ -165,7 +165,7 @@ static void print_root_backup(struct btrfs_root_backup *backup)
 			btrfs_stack_backup_extent_root_gen(backup),
 			btrfs_stack_backup_extent_root_level(backup));
 	printf("\t\tbackup_fs_root:\t\t%llu\tgen: %llu\tlevel: %d\n",
-			btrfs_backup_fs_root(backup),
+			btrfs_stack_backup_fs_root(backup),
 			btrfs_backup_fs_root_gen(backup),
 			btrfs_backup_fs_root_level(backup));
 	printf("\t\tbackup_dev_root:\t%llu\tgen: %llu\tlevel: %d\n",
diff --git a/cmds-inspect-dump-tree.c b/cmds-inspect-dump-tree.c
index d3634784..38af67e0 100644
--- a/cmds-inspect-dump-tree.c
+++ b/cmds-inspect-dump-tree.c
@@ -108,7 +108,7 @@ static void print_old_roots(struct btrfs_super_block *super)
 
 		printf("\t\tfs root gen %llu block %llu\n",
 		       (unsigned long long)btrfs_backup_fs_root_gen(backup),
-		       (unsigned long long)btrfs_backup_fs_root(backup));
+		       (unsigned long long)btrfs_stack_backup_fs_root(backup));
 
 		printf("\t\t%llu used %llu total %llu devices\n",
 		       (unsigned long long)btrfs_backup_bytes_used(backup),
diff --git a/ctree.h b/ctree.h
index 346c6a1f..ebd7c5b9 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2132,7 +2132,7 @@ BTRFS_SETGET_STACK_FUNCS(stack_backup_extent_root_level,
 		   struct btrfs_root_backup,
 		   extent_root_level, 8);
 
-BTRFS_SETGET_STACK_FUNCS(backup_fs_root, struct btrfs_root_backup,
+BTRFS_SETGET_STACK_FUNCS(stack_backup_fs_root, struct btrfs_root_backup,
 		   fs_root, 64);
 BTRFS_SETGET_STACK_FUNCS(backup_fs_root_gen, struct btrfs_root_backup,
 		   fs_root_gen, 64);
-- 
2.15.1



