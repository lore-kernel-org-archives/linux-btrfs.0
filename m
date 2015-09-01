Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:36031 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbbIATGI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Sep 2015 15:06:08 -0400
Received: by pacwi10 with SMTP id wi10so4615638pac.3
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Sep 2015 12:06:07 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: Omar Sandoval <osandov@fb.com>
Subject: [PATCH 6/6] Btrfs: add free space tree mount option
Date: Tue,  1 Sep 2015 12:05:56 -0700
Message-Id: <508d5b51b22371362ee49047afbfe536bee8ce84.1441131625.git.osandov@fb.com>
In-Reply-To: <5354d2ad80625f36be4032664a7d39f4c4874119.1441131625.git.osandov@fb.com>
References: <5354d2ad80625f36be4032664a7d39f4c4874119.1441131625.git.osandov@fb.com>
In-Reply-To: <cover.1441131625.git.osandov@fb.com>
References: <cover.1441131625.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Now we can finally hook up everything so we can actually use free space
tree. On the first mount with the free_space_tree mount option, the free
space tree will be created and the FREE_SPACE_TREE read-only compat bit
will be set. Any time the filesystem is mounted from then on, we will
use the free space tree.

Having both the free space cache and free space trees enabled is
nonsense, so we don't allow that to happen. Since mkfs sets the
superblock cache generation to -1, this means that the filesystem will
have to be mounted with nospace_cache,free_space_tree to create the free
space trees on first mount. Once the FREE_SPACE_TREE bit is set, the
cache generation is ignored when mounting. This is all a little more
complicated than would be ideal, but at some point we can presumably
make the free space tree the default and stop setting the cache
generation in mkfs.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/ctree.h   |  7 ++++++-
 fs/btrfs/disk-io.c | 26 ++++++++++++++++++++++++++
 fs/btrfs/super.c   | 21 +++++++++++++++++++--
 3 files changed, 51 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index d49181d35f08..bf4ca5a5496a 100644
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
 
@@ -2200,6 +2203,7 @@ struct btrfs_ioctl_defrag_range_args {
 #define BTRFS_MOUNT_CHECK_INTEGRITY_INCLUDING_EXTENT_DATA (1 << 21)
 #define BTRFS_MOUNT_PANIC_ON_FATAL_ERROR	(1 << 22)
 #define BTRFS_MOUNT_RESCAN_UUID_TREE	(1 << 23)
+#define BTRFS_MOUNT_FREE_SPACE_TREE	(1 << 24)
 
 #define BTRFS_DEFAULT_COMMIT_INTERVAL	(30)
 #define BTRFS_DEFAULT_MAX_INLINE	(8192)
@@ -3743,6 +3747,7 @@ static inline void free_fs_info(struct btrfs_fs_info *fs_info)
 	kfree(fs_info->csum_root);
 	kfree(fs_info->quota_root);
 	kfree(fs_info->uuid_root);
+	kfree(fs_info->free_space_root);
 	kfree(fs_info->super_copy);
 	kfree(fs_info->super_for_commit);
 	security_free_mnt_opts(&fs_info->security_opts);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index f556c3732c2c..e88674c594da 100644
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
 
@@ -3063,6 +3077,18 @@ retry_root_backup:
 
 	btrfs_qgroup_rescan_resume(fs_info);
 
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
index cd7ef34d2dce..60135e53f4b9 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -319,7 +319,7 @@ enum {
 	Opt_check_integrity_print_mask, Opt_fatal_errors, Opt_rescan_uuid_tree,
 	Opt_commit_interval, Opt_barrier, Opt_nodefrag, Opt_nodiscard,
 	Opt_noenospc_debug, Opt_noflushoncommit, Opt_acl, Opt_datacow,
-	Opt_datasum, Opt_treelog, Opt_noinode_cache,
+	Opt_datasum, Opt_treelog, Opt_noinode_cache, Opt_free_space_tree,
 	Opt_err,
 };
 
@@ -372,6 +372,7 @@ static match_table_t tokens = {
 	{Opt_rescan_uuid_tree, "rescan_uuid_tree"},
 	{Opt_fatal_errors, "fatal_errors=%s"},
 	{Opt_commit_interval, "commit=%d"},
+	{Opt_free_space_tree, "free_space_tree"},
 	{Opt_err, NULL},
 };
 
@@ -392,7 +393,9 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 	bool compress_force = false;
 
 	cache_gen = btrfs_super_cache_generation(root->fs_info->super_copy);
-	if (cache_gen)
+	if (btrfs_fs_compat_ro(root->fs_info, FREE_SPACE_TREE))
+		btrfs_set_opt(info->mount_opt, FREE_SPACE_TREE);
+	else if (cache_gen)
 		btrfs_set_opt(info->mount_opt, SPACE_CACHE);
 
 	if (!options)
@@ -738,6 +741,10 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 				info->commit_interval = BTRFS_DEFAULT_COMMIT_INTERVAL;
 			}
 			break;
+		case Opt_free_space_tree:
+			btrfs_set_and_info(root, FREE_SPACE_TREE,
+					   "enabling free space tree");
+			break;
 		case Opt_err:
 			btrfs_info(root->fs_info, "unrecognized mount option '%s'", p);
 			ret = -EINVAL;
@@ -747,8 +754,16 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 		}
 	}
 out:
+	if (btrfs_test_opt(root, SPACE_CACHE) &&
+	    btrfs_test_opt(root, FREE_SPACE_TREE)) {
+		btrfs_err(root->fs_info,
+			  "cannot use both free space cache and free space tree");
+		ret = -EINVAL;
+	}
 	if (!ret && btrfs_test_opt(root, SPACE_CACHE))
 		btrfs_info(root->fs_info, "disk space caching is enabled");
+	if (!ret && btrfs_test_opt(root, FREE_SPACE_TREE))
+		btrfs_info(root->fs_info, "using free space tree");
 	kfree(orig);
 	return ret;
 }
@@ -1152,6 +1167,8 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
 		seq_puts(seq, ",discard");
 	if (!(root->fs_info->sb->s_flags & MS_POSIXACL))
 		seq_puts(seq, ",noacl");
+	if (btrfs_test_opt(root, FREE_SPACE_TREE))
+		seq_puts(seq, ",free_space_tree");
 	if (btrfs_test_opt(root, SPACE_CACHE))
 		seq_puts(seq, ",space_cache");
 	else
-- 
2.5.1

