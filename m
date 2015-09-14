Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:33013 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbbINGEe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Sep 2015 02:04:34 -0400
Received: by pacex6 with SMTP id ex6so134324167pac.0
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2015 23:04:33 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: Omar Sandoval <osandov@osandov.com>
Subject: [PATCH v3 9/9] Btrfs: add free space tree mount option
Date: Sun, 13 Sep 2015 23:04:16 -0700
Message-Id: <02e8d2e15a5a0449cd5f8c617224a72174e0c0f3.1442209006.git.osandov@osandov.com>
In-Reply-To: <cover.1442209006.git.osandov@osandov.com>
References: <cover.1442209006.git.osandov@osandov.com>
In-Reply-To: <cover.1442209006.git.osandov@osandov.com>
References: <cover.1442209006.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Now we can finally hook up everything so we can actually use free space
tree. The free space tree is enabled by passing the space_cache=v2 mount
option. On the first mount with the this option set, the free space tree
will be created and the FREE_SPACE_TREE read-only compat bit will be
set. Any time the filesystem is mounted from then on, we must use the
free space tree. The clear_cache option will also clear the free space
tree.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/ctree.h   |  7 ++++++-
 fs/btrfs/disk-io.c | 38 ++++++++++++++++++++++++++++++++++++++
 fs/btrfs/super.c   | 53 ++++++++++++++++++++++++++++++++++++++++++++---------
 3 files changed, 88 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 455a9016587b..d6e2d9cf41bf 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -531,7 +531,10 @@ struct btrfs_super_block {
 #define BTRFS_FEATURE_COMPAT_SUPP		0ULL
 #define BTRFS_FEATURE_COMPAT_SAFE_SET		0ULL
 #define BTRFS_FEATURE_COMPAT_SAFE_CLEAR		0ULL
-#define BTRFS_FEATURE_COMPAT_RO_SUPP		0ULL
+
+#define BTRFS_FEATURE_COMPAT_RO_SUPP			\
+	(BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE)
+
 #define BTRFS_FEATURE_COMPAT_RO_SAFE_SET	0ULL
 #define BTRFS_FEATURE_COMPAT_RO_SAFE_CLEAR	0ULL
 
@@ -2209,6 +2212,7 @@ struct btrfs_ioctl_defrag_range_args {
 #define BTRFS_MOUNT_CHECK_INTEGRITY_INCLUDING_EXTENT_DATA (1 << 21)
 #define BTRFS_MOUNT_PANIC_ON_FATAL_ERROR	(1 << 22)
 #define BTRFS_MOUNT_RESCAN_UUID_TREE	(1 << 23)
+#define BTRFS_MOUNT_FREE_SPACE_TREE	(1 << 24)
 
 #define BTRFS_DEFAULT_COMMIT_INTERVAL	(30)
 #define BTRFS_DEFAULT_MAX_INLINE	(8192)
@@ -3748,6 +3752,7 @@ static inline void free_fs_info(struct btrfs_fs_info *fs_info)
 	kfree(fs_info->csum_root);
 	kfree(fs_info->quota_root);
 	kfree(fs_info->uuid_root);
+	kfree(fs_info->free_space_root);
 	kfree(fs_info->super_copy);
 	kfree(fs_info->super_for_commit);
 	security_free_mnt_opts(&fs_info->security_opts);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index f556c3732c2c..31363675353f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -42,6 +42,7 @@
 #include "locking.h"
 #include "tree-log.h"
 #include "free-space-cache.h"
+#include "free-space-tree.h"
 #include "inode-map.h"
 #include "check-integrity.h"
 #include "rcu-string.h"
@@ -1641,6 +1642,9 @@ struct btrfs_root *btrfs_get_fs_root(struct btrfs_fs_info *fs_info,
 	if (location->objectid == BTRFS_UUID_TREE_OBJECTID)
 		return fs_info->uuid_root ? fs_info->uuid_root :
 					    ERR_PTR(-ENOENT);
+	if (location->objectid == BTRFS_FREE_SPACE_TREE_OBJECTID)
+		return fs_info->free_space_root ? fs_info->free_space_root :
+						  ERR_PTR(-ENOENT);
 again:
 	root = btrfs_lookup_fs_root(fs_info, location->objectid);
 	if (root) {
@@ -2138,6 +2142,7 @@ static void free_root_pointers(struct btrfs_fs_info *info, int chunk_root)
 	free_root_extent_buffers(info->uuid_root);
 	if (chunk_root)
 		free_root_extent_buffers(info->chunk_root);
+	free_root_extent_buffers(info->free_space_root);
 }
 
 void btrfs_free_fs_roots(struct btrfs_fs_info *fs_info)
@@ -2439,6 +2444,15 @@ static int btrfs_read_roots(struct btrfs_fs_info *fs_info,
 		fs_info->uuid_root = root;
 	}
 
+	if (btrfs_fs_compat_ro(fs_info, FREE_SPACE_TREE)) {
+		location.objectid = BTRFS_FREE_SPACE_TREE_OBJECTID;
+		root = btrfs_read_tree_root(tree_root, &location);
+		if (IS_ERR(root))
+			return PTR_ERR(root);
+		set_bit(BTRFS_ROOT_TRACK_DIRTY, &root->state);
+		fs_info->free_space_root = root;
+	}
+
 	return 0;
 }
 
@@ -3063,6 +3077,30 @@ retry_root_backup:
 
 	btrfs_qgroup_rescan_resume(fs_info);
 
+	if (btrfs_test_opt(tree_root, CLEAR_CACHE) &&
+	    btrfs_fs_compat_ro(fs_info, FREE_SPACE_TREE)) {
+		pr_info("BTRFS: clearing free space tree\n");
+		ret = btrfs_clear_free_space_tree(fs_info);
+		if (ret) {
+			pr_warn("BTRFS: failed to clear free space tree %d\n",
+				ret);
+			close_ctree(tree_root);
+			return ret;
+		}
+	}
+
+	if (btrfs_test_opt(tree_root, FREE_SPACE_TREE) &&
+	    !btrfs_fs_compat_ro(fs_info, FREE_SPACE_TREE)) {
+		pr_info("BTRFS: creating free space tree\n");
+		ret = btrfs_create_free_space_tree(fs_info);
+		if (ret) {
+			pr_warn("BTRFS: failed to create free space tree %d\n",
+				ret);
+			close_ctree(tree_root);
+			return ret;
+		}
+	}
+
 	if (!fs_info->uuid_root) {
 		pr_info("BTRFS: creating UUID tree\n");
 		ret = btrfs_create_uuid_tree(fs_info);
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index b93f127c4bc8..cb179286e421 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -312,10 +312,11 @@ enum {
 	Opt_nossd, Opt_ssd_spread, Opt_thread_pool, Opt_noacl, Opt_compress,
 	Opt_compress_type, Opt_compress_force, Opt_compress_force_type,
 	Opt_notreelog, Opt_ratio, Opt_flushoncommit, Opt_discard,
-	Opt_space_cache, Opt_clear_cache, Opt_user_subvol_rm_allowed,
-	Opt_enospc_debug, Opt_subvolrootid, Opt_defrag, Opt_inode_cache,
-	Opt_no_space_cache, Opt_recovery, Opt_skip_balance,
-	Opt_check_integrity, Opt_check_integrity_including_extent_data,
+	Opt_space_cache, Opt_space_cache_version, Opt_clear_cache,
+	Opt_user_subvol_rm_allowed, Opt_enospc_debug, Opt_subvolrootid,
+	Opt_defrag, Opt_inode_cache, Opt_no_space_cache, Opt_recovery,
+	Opt_skip_balance, Opt_check_integrity,
+	Opt_check_integrity_including_extent_data,
 	Opt_check_integrity_print_mask, Opt_fatal_errors, Opt_rescan_uuid_tree,
 	Opt_commit_interval, Opt_barrier, Opt_nodefrag, Opt_nodiscard,
 	Opt_noenospc_debug, Opt_noflushoncommit, Opt_acl, Opt_datacow,
@@ -354,6 +355,7 @@ static match_table_t tokens = {
 	{Opt_discard, "discard"},
 	{Opt_nodiscard, "nodiscard"},
 	{Opt_space_cache, "space_cache"},
+	{Opt_space_cache_version, "space_cache=%s"},
 	{Opt_clear_cache, "clear_cache"},
 	{Opt_user_subvol_rm_allowed, "user_subvol_rm_allowed"},
 	{Opt_enospc_debug, "enospc_debug"},
@@ -392,7 +394,9 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 	bool compress_force = false;
 
 	cache_gen = btrfs_super_cache_generation(root->fs_info->super_copy);
-	if (cache_gen)
+	if (btrfs_fs_compat_ro(root->fs_info, FREE_SPACE_TREE))
+		btrfs_set_opt(info->mount_opt, FREE_SPACE_TREE);
+	else if (cache_gen)
 		btrfs_set_opt(info->mount_opt, SPACE_CACHE);
 
 	if (!options)
@@ -626,15 +630,35 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 					     "turning off discard");
 			break;
 		case Opt_space_cache:
-			btrfs_set_and_info(root, SPACE_CACHE,
-					   "enabling disk space caching");
+		case Opt_space_cache_version:
+			if (token == Opt_space_cache ||
+			    strcmp(args[0].from, "v1") == 0) {
+				btrfs_clear_opt(root->fs_info->mount_opt,
+						FREE_SPACE_TREE);
+				btrfs_set_and_info(root, SPACE_CACHE,
+						   "enabling disk space caching");
+			} else if (strcmp(args[0].from, "v2") == 0) {
+				btrfs_clear_opt(root->fs_info->mount_opt,
+						SPACE_CACHE);
+				btrfs_set_and_info(root, FREE_SPACE_TREE,
+						   "enabling free space tree");
+			} else {
+				ret = -EINVAL;
+				goto out;
+			}
 			break;
 		case Opt_rescan_uuid_tree:
 			btrfs_set_opt(info->mount_opt, RESCAN_UUID_TREE);
 			break;
 		case Opt_no_space_cache:
-			btrfs_clear_and_info(root, SPACE_CACHE,
-					     "disabling disk space caching");
+			if (btrfs_test_opt(root, SPACE_CACHE)) {
+				btrfs_clear_and_info(root, SPACE_CACHE,
+						     "disabling disk space caching");
+			}
+			if (btrfs_test_opt(root, FREE_SPACE_TREE)) {
+				btrfs_clear_and_info(root, FREE_SPACE_TREE,
+						     "disabling free space tree");
+			}
 			break;
 		case Opt_inode_cache:
 			btrfs_set_pending_and_info(info, INODE_MAP_CACHE,
@@ -747,8 +771,17 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 		}
 	}
 out:
+	if (btrfs_fs_compat_ro(root->fs_info, FREE_SPACE_TREE) &&
+	    !btrfs_test_opt(root, FREE_SPACE_TREE) &&
+	    !btrfs_test_opt(root, CLEAR_CACHE)) {
+		btrfs_err(root->fs_info, "cannot disable free space tree");
+		ret = -EINVAL;
+
+	}
 	if (!ret && btrfs_test_opt(root, SPACE_CACHE))
 		btrfs_info(root->fs_info, "disk space caching is enabled");
+	if (!ret && btrfs_test_opt(root, FREE_SPACE_TREE))
+		btrfs_info(root->fs_info, "using free space tree");
 	kfree(orig);
 	return ret;
 }
@@ -1154,6 +1187,8 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
 		seq_puts(seq, ",noacl");
 	if (btrfs_test_opt(root, SPACE_CACHE))
 		seq_puts(seq, ",space_cache");
+	else if (btrfs_test_opt(root, FREE_SPACE_TREE))
+		seq_puts(seq, ",space_cache=v2");
 	else
 		seq_puts(seq, ",nospace_cache");
 	if (btrfs_test_opt(root, RESCAN_UUID_TREE))
-- 
2.5.2

