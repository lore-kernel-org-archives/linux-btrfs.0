Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:44389 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753991AbeAKFKQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 00:10:16 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 1674F48AEA0A
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 13:10:06 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 32/67] btrfs-progs: add the stack prefix for backup_fs_root_level set/get function
Date: Thu, 11 Jan 2018 13:09:04 +0800
Message-ID: <20180111050939.21251-33-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
References: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The backup_fs_root_level set/get function defined by
BTRFS_SETGET_STACK_FUNCS macro is missing the prefix stack.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 cmds-inspect-dump-super.c | 2 +-
 ctree.h                   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
index 07fd8400..15828ad2 100644
--- a/cmds-inspect-dump-super.c
+++ b/cmds-inspect-dump-super.c
@@ -167,7 +167,7 @@ static void print_root_backup(struct btrfs_root_backup *backup)
 	printf("\t\tbackup_fs_root:\t\t%llu\tgen: %llu\tlevel: %d\n",
 			btrfs_stack_backup_fs_root(backup),
 			btrfs_stack_backup_fs_root_gen(backup),
-			btrfs_backup_fs_root_level(backup));
+			btrfs_stack_backup_fs_root_level(backup));
 	printf("\t\tbackup_dev_root:\t%llu\tgen: %llu\tlevel: %d\n",
 			btrfs_backup_dev_root(backup),
 			btrfs_backup_dev_root_gen(backup),
diff --git a/ctree.h b/ctree.h
index 2253d340..62eecf7f 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2136,7 +2136,7 @@ BTRFS_SETGET_STACK_FUNCS(stack_backup_fs_root, struct btrfs_root_backup,
 		   fs_root, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_backup_fs_root_gen, struct btrfs_root_backup,
 		   fs_root_gen, 64);
-BTRFS_SETGET_STACK_FUNCS(backup_fs_root_level, struct btrfs_root_backup,
+BTRFS_SETGET_STACK_FUNCS(stack_backup_fs_root_level, struct btrfs_root_backup,
 		   fs_root_level, 8);
 
 BTRFS_SETGET_STACK_FUNCS(backup_dev_root, struct btrfs_root_backup,
-- 
2.15.1



