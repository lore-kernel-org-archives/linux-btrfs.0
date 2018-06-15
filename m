Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54719 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965684AbeFOLGM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Jun 2018 07:06:12 -0400
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: osandov@osandov.com, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 5/6] btrfs-progs: check: Add support for freespace tree fixing
Date: Fri, 15 Jun 2018 14:06:01 +0300
Message-Id: <1529060762-4372-6-git-send-email-nborisov@suse.com>
In-Reply-To: <1529060762-4372-1-git-send-email-nborisov@suse.com>
References: <1529060762-4372-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now that all the prerequisite code for proper support of free space
tree repair is in, it's time to wire it in. This is achieved by first
hooking the freespace tree to the __free_extent/alloc_reserved_tree_block
functions. And then introducing a wrapper function to contains the
existing check_space_cache and the newly introduced repair code.
Finally, it's important to note that FST repair code first clears the
existing FST in case of any problem found and rebuilds it from scratch.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 check/main.c  | 61 +++++++++++++++++++++++++++++++++++++----------------------
 extent-tree.c |  9 +++++++++
 2 files changed, 47 insertions(+), 23 deletions(-)

diff --git a/check/main.c b/check/main.c
index 3a5efaf615a9..44d734ff4254 100644
--- a/check/main.c
+++ b/check/main.c
@@ -5321,19 +5321,6 @@ static int check_space_cache(struct btrfs_root *root)
 	int ret;
 	int error = 0;
 
-	if (btrfs_super_cache_generation(root->fs_info->super_copy) != -1ULL &&
-	    btrfs_super_generation(root->fs_info->super_copy) !=
-	    btrfs_super_cache_generation(root->fs_info->super_copy)) {
-		printf("cache and super generation don't match, space cache "
-		       "will be invalidated\n");
-		return 0;
-	}
-
-	if (ctx.progress_enabled) {
-		ctx.tp = TASK_FREE_SPACE;
-		task_start(ctx.info);
-	}
-
 	while (1) {
 		cache = btrfs_lookup_first_block_group(root->fs_info, start);
 		if (!cache)
@@ -5383,11 +5370,11 @@ static int check_space_cache(struct btrfs_root *root)
 		}
 	}
 
-	task_stop(ctx.info);
 
 	return error ? -EINVAL : 0;
 }
 
+
 /*
  * Check data checksum for [@bytenr, @bytenr + @num_bytes).
  *
@@ -9338,7 +9325,6 @@ static int do_clear_free_space_cache(struct btrfs_fs_info *fs_info,
 			ret = 1;
 			goto close_out;
 		}
-		printf("Clearing free space cache\n");
 		ret = clear_free_space_cache(fs_info);
 		if (ret) {
 			error("failed to clear free space cache");
@@ -9365,6 +9351,41 @@ static int do_clear_free_space_cache(struct btrfs_fs_info *fs_info,
 	return ret;
 }
 
+static int validate_free_space_cache(struct btrfs_root *root)
+{
+
+	int ret;
+
+	if (btrfs_super_cache_generation(root->fs_info->super_copy) != -1ULL &&
+	    btrfs_super_generation(root->fs_info->super_copy) !=
+	    btrfs_super_cache_generation(root->fs_info->super_copy)) {
+		printf("cache and super generation don't match, space cache "
+		       "will be invalidated\n");
+		return 0;
+	}
+
+	if (ctx.progress_enabled) {
+		ctx.tp = TASK_FREE_SPACE;
+		task_start(ctx.info);
+	}
+
+	ret = check_space_cache(root);
+	if (ret && btrfs_fs_compat_ro(global_info, FREE_SPACE_TREE)
+	    && repair) {
+		ret = do_clear_free_space_cache(global_info, 2);
+		if (ret)
+			goto out;
+
+		ret = btrfs_create_free_space_tree(global_info);
+		if (ret)
+			error("couldn't repair freespace tree");
+	}
+
+out:
+	task_stop(ctx.info);
+	return ret ? -EINVAL : 0;
+}
+
 const char * const cmd_check_usage[] = {
 	"btrfs check [options] <device>",
 	"Check structural integrity of a filesystem (unmounted).",
@@ -9768,15 +9789,9 @@ int cmd_check(int argc, char **argv)
 		else
 			fprintf(stderr, "checking free space cache\n");
 	}
-	ret = check_space_cache(root);
+
+	ret = validate_free_space_cache(root);
 	err |= !!ret;
-	if (ret) {
-		if (btrfs_fs_compat_ro(info, FREE_SPACE_TREE))
-			error("errors found in free space tree");
-		else
-			error("errors found in free space cache");
-		goto out;
-	}
 
 	/*
 	 * We used to have to have these hole extents in between our real
diff --git a/extent-tree.c b/extent-tree.c
index b9d51b388c9a..40117f81352e 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -29,6 +29,7 @@
 #include "crc32c.h"
 #include "volumes.h"
 #include "free-space-cache.h"
+#include "free-space-tree.h"
 #include "utils.h"
 
 #define PENDING_EXTENT_INSERT 0
@@ -2292,6 +2293,11 @@ static int __free_extent(struct btrfs_trans_handle *trans,
 			BUG_ON(ret);
 		}
 
+		ret = add_to_free_space_tree(trans, bytenr, num_bytes);
+		if (ret) {
+			goto fail;
+		}
+
 		update_block_group(trans->fs_info, bytenr, num_bytes, 0,
 				   mark_free);
 	}
@@ -2630,6 +2636,9 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 	btrfs_mark_buffer_dirty(leaf);
 	btrfs_free_path(path);
 
+	ret = remove_from_free_space_tree(trans, ins->objectid, fs_info->nodesize);
+	if (ret)
+		return ret;
 	ret = update_block_group(fs_info, ins->objectid, fs_info->nodesize,
 				 1, 0);
 	return ret;
-- 
2.7.4

