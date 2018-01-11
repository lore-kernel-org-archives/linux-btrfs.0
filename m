Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:12011 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754091AbeAKFK3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 00:10:29 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 8C69849F0E4C
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 13:10:22 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 66/67] btrfs-progs: add the stack prefix for super_uuid_tree_generation set/get function
Date: Thu, 11 Jan 2018 13:09:38 +0800
Message-ID: <20180111050939.21251-67-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
References: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The super_uuid_tree_generation set/get function defined by
BTRFS_SETGET_STACK_FUNCS macro is missing the prefix stack.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 btrfs-find-root.c         | 2 +-
 cmds-inspect-dump-super.c | 2 +-
 ctree.h                   | 3 ++-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/btrfs-find-root.c b/btrfs-find-root.c
index 08bf2781..42c9a60a 100644
--- a/btrfs-find-root.c
+++ b/btrfs-find-root.c
@@ -76,7 +76,7 @@ static void get_root_gen_and_level(u64 objectid, struct btrfs_fs_info *fs_info,
 		gen = btrfs_stack_super_log_root_transid(super);
 		break;
 	case BTRFS_UUID_TREE_OBJECTID:
-		gen = btrfs_super_uuid_tree_generation(super);
+		gen = btrfs_stack_super_uuid_tree_generation(super);
 		break;
 	}
 	if (gen != (u64)-1) {
diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
index 877b3b77..299426f2 100644
--- a/cmds-inspect-dump-super.c
+++ b/cmds-inspect-dump-super.c
@@ -416,7 +416,7 @@ static void dump_superblock(struct btrfs_super_block *sb, int full)
 	printf("cache_generation\t%llu\n",
 	       (unsigned long long)btrfs_stack_super_cache_generation(sb));
 	printf("uuid_tree_generation\t%llu\n",
-	       (unsigned long long)btrfs_super_uuid_tree_generation(sb));
+	       (unsigned long long)btrfs_stack_super_uuid_tree_generation(sb));
 
 	uuid_unparse(sb->dev_item.uuid, buf);
 	printf("dev_item.uuid\t\t%s\n", buf);
diff --git a/ctree.h b/ctree.h
index a7aacf40..c85aef9b 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2208,7 +2208,8 @@ BTRFS_SETGET_STACK_FUNCS(stack_super_csum_type, struct btrfs_super_block,
 			 csum_type, 16);
 BTRFS_SETGET_STACK_FUNCS(stack_super_cache_generation, struct btrfs_super_block,
 			 cache_generation, 64);
-BTRFS_SETGET_STACK_FUNCS(super_uuid_tree_generation, struct btrfs_super_block,
+BTRFS_SETGET_STACK_FUNCS(stack_super_uuid_tree_generation,
+			 struct btrfs_super_block,
 			 uuid_tree_generation, 64);
 BTRFS_SETGET_STACK_FUNCS(super_magic, struct btrfs_super_block, magic, 64);
 
-- 
2.15.1



