Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:44389 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754020AbeAKFKU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 00:10:20 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 5808748AEA1A
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 13:10:16 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 53/67] btrfs-progs: add the stack prefix for super_log_root_level set/get function
Date: Thu, 11 Jan 2018 13:09:25 +0800
Message-ID: <20180111050939.21251-54-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
References: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The super_log_root_level set/get function defined by
BTRFS_SETGET_STACK_FUNCS macro is missing the prefix stack.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 btrfs-find-root.c         | 2 +-
 btrfs-zero-log.c          | 4 ++--
 cmds-check.c              | 2 +-
 cmds-inspect-dump-super.c | 2 +-
 cmds-rescue.c             | 4 ++--
 ctree.h                   | 2 +-
 disk-io.c                 | 4 ++--
 7 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/btrfs-find-root.c b/btrfs-find-root.c
index 4c838878..08bf2781 100644
--- a/btrfs-find-root.c
+++ b/btrfs-find-root.c
@@ -72,7 +72,7 @@ static void get_root_gen_and_level(u64 objectid, struct btrfs_fs_info *fs_info,
 		gen = btrfs_stack_super_chunk_root_generation(super);
 		break;
 	case BTRFS_TREE_LOG_OBJECTID:
-		level = btrfs_super_log_root_level(super);
+		level = btrfs_stack_super_log_root_level(super);
 		gen = btrfs_stack_super_log_root_transid(super);
 		break;
 	case BTRFS_UUID_TREE_OBJECTID:
diff --git a/btrfs-zero-log.c b/btrfs-zero-log.c
index 0b6bf539..87004ec7 100644
--- a/btrfs-zero-log.c
+++ b/btrfs-zero-log.c
@@ -66,11 +66,11 @@ int main(int argc, char **argv)
 	printf("Clearing log on %s, previous log_root %llu, level %u\n",
 			argv[optind],
 			(unsigned long long)btrfs_stack_super_log_root(sb),
-			(unsigned)btrfs_super_log_root_level(sb));
+			(unsigned)btrfs_stack_super_log_root_level(sb));
 	trans = btrfs_start_transaction(root, 1);
 	BUG_ON(IS_ERR(trans));
 	btrfs_set_stack_super_log_root(root->fs_info->super_copy, 0);
-	btrfs_set_super_log_root_level(root->fs_info->super_copy, 0);
+	btrfs_set_stack_super_log_root_level(root->fs_info->super_copy, 0);
 	btrfs_commit_transaction(trans, root);
 	close_ctree(root);
 out:
diff --git a/cmds-check.c b/cmds-check.c
index b184aa48..40be3c7b 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -13968,7 +13968,7 @@ static int zero_log_tree(struct btrfs_root *root)
 		return ret;
 	}
 	btrfs_set_stack_super_log_root(root->fs_info->super_copy, 0);
-	btrfs_set_super_log_root_level(root->fs_info->super_copy, 0);
+	btrfs_set_stack_super_log_root_level(root->fs_info->super_copy, 0);
 	ret = btrfs_commit_transaction(trans, root);
 	return ret;
 }
diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
index aebfa734..3e23184c 100644
--- a/cmds-inspect-dump-super.c
+++ b/cmds-inspect-dump-super.c
@@ -388,7 +388,7 @@ static void dump_superblock(struct btrfs_super_block *sb, int full)
 	printf("log_root_transid\t%llu\n",
 	       (unsigned long long)btrfs_stack_super_log_root_transid(sb));
 	printf("log_root_level\t\t%llu\n",
-	       (unsigned long long)btrfs_super_log_root_level(sb));
+	       (unsigned long long)btrfs_stack_super_log_root_level(sb));
 	printf("total_bytes\t\t%llu\n",
 	       (unsigned long long)btrfs_super_total_bytes(sb));
 	printf("bytes_used\t\t%llu\n",
diff --git a/cmds-rescue.c b/cmds-rescue.c
index b3baf47c..f8b82367 100644
--- a/cmds-rescue.c
+++ b/cmds-rescue.c
@@ -191,11 +191,11 @@ static int cmd_rescue_zero_log(int argc, char **argv)
 	printf("Clearing log on %s, previous log_root %llu, level %u\n",
 			devname,
 			(unsigned long long)btrfs_stack_super_log_root(sb),
-			(unsigned)btrfs_super_log_root_level(sb));
+			(unsigned)btrfs_stack_super_log_root_level(sb));
 	trans = btrfs_start_transaction(root, 1);
 	BUG_ON(IS_ERR(trans));
 	btrfs_set_stack_super_log_root(sb, 0);
-	btrfs_set_super_log_root_level(sb, 0);
+	btrfs_set_stack_super_log_root_level(sb, 0);
 	btrfs_commit_transaction(trans, root);
 	close_ctree(root);
 
diff --git a/ctree.h b/ctree.h
index 17f21bff..3fe38461 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2182,7 +2182,7 @@ BTRFS_SETGET_STACK_FUNCS(stack_super_log_root, struct btrfs_super_block,
 			 log_root, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_super_log_root_transid, struct btrfs_super_block,
 			 log_root_transid, 64);
-BTRFS_SETGET_STACK_FUNCS(super_log_root_level, struct btrfs_super_block,
+BTRFS_SETGET_STACK_FUNCS(stack_super_log_root_level, struct btrfs_super_block,
 			 log_root_level, 8);
 BTRFS_SETGET_STACK_FUNCS(super_total_bytes, struct btrfs_super_block,
 			 total_bytes, 64);
diff --git a/disk-io.c b/disk-io.c
index 183121cc..1d55bf22 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1319,9 +1319,9 @@ static int check_super(struct btrfs_super_block *sb, unsigned sbflags)
 		      BTRFS_MAX_LEVEL);
 		goto error_out;
 	}
-	if (btrfs_super_log_root_level(sb) >= BTRFS_MAX_LEVEL) {
+	if (btrfs_stack_super_log_root_level(sb) >= BTRFS_MAX_LEVEL) {
 		error("log_root level too big: %d >= %d",
-			btrfs_super_log_root_level(sb), BTRFS_MAX_LEVEL);
+			btrfs_stack_super_log_root_level(sb), BTRFS_MAX_LEVEL);
 		goto error_out;
 	}
 
-- 
2.15.1



