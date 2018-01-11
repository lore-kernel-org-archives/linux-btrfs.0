Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:36208 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753979AbeAKFKP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 00:10:15 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 7C8DB486A78B
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 13:10:05 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 31/67] btrfs-progs: add the stack prefix for backup_fs_root_gen set/get function
Date: Thu, 11 Jan 2018 13:09:03 +0800
Message-ID: <20180111050939.21251-32-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
References: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The backup_fs_root_gen set/get function defined by
BTRFS_SETGET_STACK_FUNCS macro is missing the prefix stack.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 cmds-inspect-dump-super.c | 2 +-
 cmds-inspect-dump-tree.c  | 4 ++--
 ctree.h                   | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
index 624f0e91..07fd8400 100644
--- a/cmds-inspect-dump-super.c
+++ b/cmds-inspect-dump-super.c
@@ -166,7 +166,7 @@ static void print_root_backup(struct btrfs_root_backup *backup)
 			btrfs_stack_backup_extent_root_level(backup));
 	printf("\t\tbackup_fs_root:\t\t%llu\tgen: %llu\tlevel: %d\n",
 			btrfs_stack_backup_fs_root(backup),
-			btrfs_backup_fs_root_gen(backup),
+			btrfs_stack_backup_fs_root_gen(backup),
 			btrfs_backup_fs_root_level(backup));
 	printf("\t\tbackup_dev_root:\t%llu\tgen: %llu\tlevel: %d\n",
 			btrfs_backup_dev_root(backup),
diff --git a/cmds-inspect-dump-tree.c b/cmds-inspect-dump-tree.c
index 38af67e0..6ad9ed1d 100644
--- a/cmds-inspect-dump-tree.c
+++ b/cmds-inspect-dump-tree.c
@@ -107,8 +107,8 @@ static void print_old_roots(struct btrfs_super_block *super)
 		       (unsigned long long)btrfs_backup_csum_root(backup));
 
 		printf("\t\tfs root gen %llu block %llu\n",
-		       (unsigned long long)btrfs_backup_fs_root_gen(backup),
-		       (unsigned long long)btrfs_stack_backup_fs_root(backup));
+		(unsigned long long)btrfs_stack_backup_fs_root_gen(backup),
+		(unsigned long long)btrfs_stack_backup_fs_root(backup));
 
 		printf("\t\t%llu used %llu total %llu devices\n",
 		       (unsigned long long)btrfs_backup_bytes_used(backup),
diff --git a/ctree.h b/ctree.h
index ebd7c5b9..2253d340 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2134,7 +2134,7 @@ BTRFS_SETGET_STACK_FUNCS(stack_backup_extent_root_level,
 
 BTRFS_SETGET_STACK_FUNCS(stack_backup_fs_root, struct btrfs_root_backup,
 		   fs_root, 64);
-BTRFS_SETGET_STACK_FUNCS(backup_fs_root_gen, struct btrfs_root_backup,
+BTRFS_SETGET_STACK_FUNCS(stack_backup_fs_root_gen, struct btrfs_root_backup,
 		   fs_root_gen, 64);
 BTRFS_SETGET_STACK_FUNCS(backup_fs_root_level, struct btrfs_root_backup,
 		   fs_root_level, 8);
-- 
2.15.1



