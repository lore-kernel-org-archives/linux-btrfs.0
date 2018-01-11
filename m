Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:36208 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753990AbeAKFKQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 00:10:16 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id A279848AEA1B
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 13:10:10 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 41/67] btrfs-progs: add the stack prefix for backup_num_devices set/get function
Date: Thu, 11 Jan 2018 13:09:13 +0800
Message-ID: <20180111050939.21251-42-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
References: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The backup_num_devices set/get function defined by
BTRFS_SETGET_STACK_FUNCS macro is missing the prefix stack.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 cmds-inspect-dump-super.c | 2 +-
 cmds-inspect-dump-tree.c  | 2 +-
 ctree.h                   | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
index 3a663d06..fd4a574b 100644
--- a/cmds-inspect-dump-super.c
+++ b/cmds-inspect-dump-super.c
@@ -182,7 +182,7 @@ static void print_root_backup(struct btrfs_root_backup *backup)
 	printf("\t\tbackup_bytes_used:\t%llu\n",
 					btrfs_stack_backup_bytes_used(backup));
 	printf("\t\tbackup_num_devices:\t%llu\n",
-					btrfs_backup_num_devices(backup));
+					btrfs_stack_backup_num_devices(backup));
 	putchar('\n');
 }
 
diff --git a/cmds-inspect-dump-tree.c b/cmds-inspect-dump-tree.c
index 248c2f19..92aec858 100644
--- a/cmds-inspect-dump-tree.c
+++ b/cmds-inspect-dump-tree.c
@@ -113,7 +113,7 @@ static void print_old_roots(struct btrfs_super_block *super)
 		printf("\t\t%llu used %llu total %llu devices\n",
 		(unsigned long long)btrfs_stack_backup_bytes_used(backup),
 		(unsigned long long)btrfs_stack_backup_total_bytes(backup),
-		(unsigned long long)btrfs_backup_num_devices(backup));
+		(unsigned long long)btrfs_stack_backup_num_devices(backup));
 	}
 }
 
diff --git a/ctree.h b/ctree.h
index 520f5065..e159382e 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2156,7 +2156,7 @@ BTRFS_SETGET_STACK_FUNCS(stack_backup_total_bytes, struct btrfs_root_backup,
 		   total_bytes, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_backup_bytes_used, struct btrfs_root_backup,
 		   bytes_used, 64);
-BTRFS_SETGET_STACK_FUNCS(backup_num_devices, struct btrfs_root_backup,
+BTRFS_SETGET_STACK_FUNCS(stack_backup_num_devices, struct btrfs_root_backup,
 		   num_devices, 64);
 
 /* struct btrfs_super_block */
-- 
2.15.1



