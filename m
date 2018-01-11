Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:42499 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753749AbeAKFKQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 00:10:16 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 19DCC48AEA11
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 13:10:08 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 36/67] btrfs-progs: add the stack prefix for backup_csum_root set/get function
Date: Thu, 11 Jan 2018 13:09:08 +0800
Message-ID: <20180111050939.21251-37-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
References: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The backup_csum_root set/get function defined by
BTRFS_SETGET_STACK_FUNCS macro is missing the prefix stack.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 cmds-inspect-dump-super.c | 2 +-
 cmds-inspect-dump-tree.c  | 4 ++--
 ctree.h                   | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
index 5b0678d5..80cf0418 100644
--- a/cmds-inspect-dump-super.c
+++ b/cmds-inspect-dump-super.c
@@ -173,7 +173,7 @@ static void print_root_backup(struct btrfs_root_backup *backup)
 			btrfs_stack_backup_dev_root_gen(backup),
 			btrfs_stack_backup_dev_root_level(backup));
 	printf("\t\tbackup_csum_root:\t%llu\tgen: %llu\tlevel: %d\n",
-			btrfs_backup_csum_root(backup),
+			btrfs_stack_backup_csum_root(backup),
 			btrfs_backup_csum_root_gen(backup),
 			btrfs_backup_csum_root_level(backup));
 
diff --git a/cmds-inspect-dump-tree.c b/cmds-inspect-dump-tree.c
index 934070a2..4e6a20a4 100644
--- a/cmds-inspect-dump-tree.c
+++ b/cmds-inspect-dump-tree.c
@@ -103,8 +103,8 @@ static void print_old_roots(struct btrfs_super_block *super)
 		(unsigned long long)btrfs_stack_backup_dev_root(backup));
 
 		printf("\t\tcsum root gen %llu block %llu\n",
-		       (unsigned long long)btrfs_backup_csum_root_gen(backup),
-		       (unsigned long long)btrfs_backup_csum_root(backup));
+		(unsigned long long)btrfs_backup_csum_root_gen(backup),
+		(unsigned long long)btrfs_stack_backup_csum_root(backup));
 
 		printf("\t\tfs root gen %llu block %llu\n",
 		(unsigned long long)btrfs_stack_backup_fs_root_gen(backup),
diff --git a/ctree.h b/ctree.h
index 95ce1f13..86666378 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2146,7 +2146,7 @@ BTRFS_SETGET_STACK_FUNCS(stack_backup_dev_root_gen, struct btrfs_root_backup,
 BTRFS_SETGET_STACK_FUNCS(stack_backup_dev_root_level, struct btrfs_root_backup,
 		   dev_root_level, 8);
 
-BTRFS_SETGET_STACK_FUNCS(backup_csum_root, struct btrfs_root_backup,
+BTRFS_SETGET_STACK_FUNCS(stack_backup_csum_root, struct btrfs_root_backup,
 		   csum_root, 64);
 BTRFS_SETGET_STACK_FUNCS(backup_csum_root_gen, struct btrfs_root_backup,
 		   csum_root_gen, 64);
-- 
2.15.1



