From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: Add a clear_cache mount option
Date: Tue, 21 Sep 2010 14:23:35 -0400
Message-ID: <1285093415-23406-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

If something goes wrong with the free space cache we need a way to make sure
it's not loaded on mount and that it's cleared for everybody.  When you pass the
clear_cache option it will make it so all block groups are setup to be cleared,
which keeps them from being loaded and then they will be truncated when the
transaction is committed.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/ctree.h            |    1 +
 fs/btrfs/extent-tree.c      |   13 +++++++++++--
 fs/btrfs/free-space-cache.c |    2 --
 fs/btrfs/super.c            |    6 +++++-
 4 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 1ecd8f6..470f06c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1226,6 +1226,7 @@ struct btrfs_root {
 #define BTRFS_MOUNT_NOSSD		(1 << 9)
 #define BTRFS_MOUNT_DISCARD		(1 << 10)
 #define BTRFS_MOUNT_FORCE_COMPRESS      (1 << 11)
+#define BTRFS_MOUNT_CLEAR_CACHE		(1 << 12)
 
 #define btrfs_clear_opt(o, opt)		((o) &= ~BTRFS_MOUNT_##opt)
 #define btrfs_set_opt(o, opt)		((o) |= BTRFS_MOUNT_##opt)
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index c0a9ad3..5343e56 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2836,6 +2836,7 @@ int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans,
 	int err = 0;
 	struct btrfs_path *path;
 	u64 last = 0;
+	u64 features = btrfs_super_incompat_flags(&root->fs_info->super_copy);
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -2885,8 +2886,13 @@ again:
 			continue;
 		}
 
-		if (cache->disk_cache_state == BTRFS_DC_SETUP)
-			cache->disk_cache_state = BTRFS_DC_NEED_WRITE;
+		if (cache->disk_cache_state == BTRFS_DC_SETUP) {
+			if (features & BTRFS_FEATURE_INCOMPAT_SPACE_CACHE)
+				cache->disk_cache_state = BTRFS_DC_NEED_WRITE;
+			else
+				cache->disk_cache_state = BTRFS_DC_WRITTEN;
+		}
+
 		cache->dirty = 0;
 		last = cache->key.objectid + cache->key.offset;
 
@@ -8262,6 +8268,9 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 			free_excluded_extents(root, cache);
 		}
 
+		if (btrfs_test_opt(root, CLEAR_CACHE))
+			cache->disk_cache_state = BTRFS_DC_CLEAR;
+
 		ret = update_space_info(info, cache->flags, found_key.offset,
 					btrfs_block_group_used(&cache->item),
 					&space_info);
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index c1e8b6e..81085b4 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -242,8 +242,6 @@ int load_free_space_cache(struct btrfs_fs_info *fs_info,
 	 */
 	spin_lock(&block_group->lock);
 	if (block_group->disk_cache_state != BTRFS_DC_WRITTEN) {
-		printk(KERN_ERR "not reading block group %llu, dcs is %d\n", block_group->key.objectid,
-		       block_group->disk_cache_state);
 		spin_unlock(&block_group->lock);
 		return 0;
 	}
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 6a625e9..1b92f57 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -68,7 +68,7 @@ enum {
 	Opt_nodatacow, Opt_max_inline, Opt_alloc_start, Opt_nobarrier, Opt_ssd,
 	Opt_nossd, Opt_ssd_spread, Opt_thread_pool, Opt_noacl, Opt_compress,
 	Opt_compress_force, Opt_notreelog, Opt_ratio, Opt_flushoncommit,
-	Opt_discard, Opt_space_cache, Opt_err,
+	Opt_discard, Opt_space_cache, Opt_clear_cache, Opt_err,
 };
 
 static match_table_t tokens = {
@@ -93,6 +93,7 @@ static match_table_t tokens = {
 	{Opt_ratio, "metadata_ratio=%d"},
 	{Opt_discard, "discard"},
 	{Opt_space_cache, "space_cache"},
+	{Opt_clear_cache, "clear_cache"},
 	{Opt_err, NULL},
 };
 
@@ -244,6 +245,9 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			features |= BTRFS_FEATURE_INCOMPAT_SPACE_CACHE;
 			btrfs_set_super_incompat_flags(disk_super, features);
 			break;
+		case Opt_clear_cache:
+			btrfs_set_opt(info->mount_opt, CLEAR_CACHE);
+			break;
 		case Opt_err:
 			printk(KERN_INFO "btrfs: unrecognized mount option "
 			       "'%s'\n", p);
-- 
1.6.6.1

