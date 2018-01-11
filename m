Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:44389 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753242AbeAKFKY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 00:10:24 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id D9A5848AEA19
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 13:10:15 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 52/67] btrfs-progs: add the stack prefix for super_log_root_transid set/get function
Date: Thu, 11 Jan 2018 13:09:24 +0800
Message-ID: <20180111050939.21251-53-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
References: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The super_log_root_transid set/get function defined by
BTRFS_SETGET_STACK_FUNCS macro is missing the prefix stack.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 btrfs-find-root.c         | 2 +-
 cmds-inspect-dump-super.c | 2 +-
 ctree.h                   | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/btrfs-find-root.c b/btrfs-find-root.c
index 5fddf8b3..4c838878 100644
--- a/btrfs-find-root.c
+++ b/btrfs-find-root.c
@@ -73,7 +73,7 @@ static void get_root_gen_and_level(u64 objectid, struct btrfs_fs_info *fs_info,
 		break;
 	case BTRFS_TREE_LOG_OBJECTID:
 		level = btrfs_super_log_root_level(super);
-		gen = btrfs_super_log_root_transid(super);
+		gen = btrfs_stack_super_log_root_transid(super);
 		break;
 	case BTRFS_UUID_TREE_OBJECTID:
 		gen = btrfs_super_uuid_tree_generation(super);
diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
index 91db9d4a..aebfa734 100644
--- a/cmds-inspect-dump-super.c
+++ b/cmds-inspect-dump-super.c
@@ -386,7 +386,7 @@ static void dump_superblock(struct btrfs_super_block *sb, int full)
 	printf("log_root\t\t%llu\n",
 	       (unsigned long long)btrfs_stack_super_log_root(sb));
 	printf("log_root_transid\t%llu\n",
-	       (unsigned long long)btrfs_super_log_root_transid(sb));
+	       (unsigned long long)btrfs_stack_super_log_root_transid(sb));
 	printf("log_root_level\t\t%llu\n",
 	       (unsigned long long)btrfs_super_log_root_level(sb));
 	printf("total_bytes\t\t%llu\n",
diff --git a/ctree.h b/ctree.h
index 854aa548..17f21bff 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2180,7 +2180,7 @@ BTRFS_SETGET_STACK_FUNCS(stack_super_chunk_root_level, struct btrfs_super_block,
 			 chunk_root_level, 8);
 BTRFS_SETGET_STACK_FUNCS(stack_super_log_root, struct btrfs_super_block,
 			 log_root, 64);
-BTRFS_SETGET_STACK_FUNCS(super_log_root_transid, struct btrfs_super_block,
+BTRFS_SETGET_STACK_FUNCS(stack_super_log_root_transid, struct btrfs_super_block,
 			 log_root_transid, 64);
 BTRFS_SETGET_STACK_FUNCS(super_log_root_level, struct btrfs_super_block,
 			 log_root_level, 8);
-- 
2.15.1



