Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:12011 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753983AbeAKFKP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 00:10:15 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 0AA3348AEA17
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 13:10:09 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 38/67] btrfs-progs: add the stack prefix for backup_csum_root_level set/get function
Date: Thu, 11 Jan 2018 13:09:10 +0800
Message-ID: <20180111050939.21251-39-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
References: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The backup_csum_root_level set/get function defined by
BTRFS_SETGET_STACK_FUNCS macro is missing the prefix stack.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 cmds-inspect-dump-super.c | 2 +-
 ctree.h                   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
index fc5eea8a..1d9fe942 100644
--- a/cmds-inspect-dump-super.c
+++ b/cmds-inspect-dump-super.c
@@ -175,7 +175,7 @@ static void print_root_backup(struct btrfs_root_backup *backup)
 	printf("\t\tbackup_csum_root:\t%llu\tgen: %llu\tlevel: %d\n",
 			btrfs_stack_backup_csum_root(backup),
 			btrfs_stack_backup_csum_root_gen(backup),
-			btrfs_backup_csum_root_level(backup));
+			btrfs_stack_backup_csum_root_level(backup));
 
 	printf("\t\tbackup_total_bytes:\t%llu\n",
 					btrfs_backup_total_bytes(backup));
diff --git a/ctree.h b/ctree.h
index 355e4b3a..406f21d8 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2150,7 +2150,7 @@ BTRFS_SETGET_STACK_FUNCS(stack_backup_csum_root, struct btrfs_root_backup,
 		   csum_root, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_backup_csum_root_gen, struct btrfs_root_backup,
 		   csum_root_gen, 64);
-BTRFS_SETGET_STACK_FUNCS(backup_csum_root_level, struct btrfs_root_backup,
+BTRFS_SETGET_STACK_FUNCS(stack_backup_csum_root_level, struct btrfs_root_backup,
 		   csum_root_level, 8);
 BTRFS_SETGET_STACK_FUNCS(backup_total_bytes, struct btrfs_root_backup,
 		   total_bytes, 64);
-- 
2.15.1



