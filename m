Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:12011 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753974AbeAKFKT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 00:10:19 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 99EEB48AEA19
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 13:10:09 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 39/67] btrfs-progs: add the stack prefix for backup_total_bytes set/get function
Date: Thu, 11 Jan 2018 13:09:11 +0800
Message-ID: <20180111050939.21251-40-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
References: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The backup_total_bytes set/get function defined by
BTRFS_SETGET_STACK_FUNCS macro is missing the prefix stack.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 cmds-inspect-dump-super.c | 2 +-
 cmds-inspect-dump-tree.c  | 6 +++---
 ctree.h                   | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
index 1d9fe942..51d9fda6 100644
--- a/cmds-inspect-dump-super.c
+++ b/cmds-inspect-dump-super.c
@@ -178,7 +178,7 @@ static void print_root_backup(struct btrfs_root_backup *backup)
 			btrfs_stack_backup_csum_root_level(backup));
 
 	printf("\t\tbackup_total_bytes:\t%llu\n",
-					btrfs_backup_total_bytes(backup));
+					btrfs_stack_backup_total_bytes(backup));
 	printf("\t\tbackup_bytes_used:\t%llu\n",
 					btrfs_backup_bytes_used(backup));
 	printf("\t\tbackup_num_devices:\t%llu\n",
diff --git a/cmds-inspect-dump-tree.c b/cmds-inspect-dump-tree.c
index fc63a6b6..255bdbb9 100644
--- a/cmds-inspect-dump-tree.c
+++ b/cmds-inspect-dump-tree.c
@@ -111,9 +111,9 @@ static void print_old_roots(struct btrfs_super_block *super)
 		(unsigned long long)btrfs_stack_backup_fs_root(backup));
 
 		printf("\t\t%llu used %llu total %llu devices\n",
-		       (unsigned long long)btrfs_backup_bytes_used(backup),
-		       (unsigned long long)btrfs_backup_total_bytes(backup),
-		       (unsigned long long)btrfs_backup_num_devices(backup));
+		(unsigned long long)btrfs_backup_bytes_used(backup),
+		(unsigned long long)btrfs_stack_backup_total_bytes(backup),
+		(unsigned long long)btrfs_backup_num_devices(backup));
 	}
 }
 
diff --git a/ctree.h b/ctree.h
index 406f21d8..8996c978 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2152,7 +2152,7 @@ BTRFS_SETGET_STACK_FUNCS(stack_backup_csum_root_gen, struct btrfs_root_backup,
 		   csum_root_gen, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_backup_csum_root_level, struct btrfs_root_backup,
 		   csum_root_level, 8);
-BTRFS_SETGET_STACK_FUNCS(backup_total_bytes, struct btrfs_root_backup,
+BTRFS_SETGET_STACK_FUNCS(stack_backup_total_bytes, struct btrfs_root_backup,
 		   total_bytes, 64);
 BTRFS_SETGET_STACK_FUNCS(backup_bytes_used, struct btrfs_root_backup,
 		   bytes_used, 64);
-- 
2.15.1



