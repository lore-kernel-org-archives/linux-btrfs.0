Return-Path: <SRS0=ilb6=O5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50CA7C43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 20 Dec 2018 08:01:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1307320815
	for <linux-btrfs@archiver.kernel.org>; Thu, 20 Dec 2018 08:01:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727767AbeLTIBq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 20 Dec 2018 03:01:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:40854 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726604AbeLTIBq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Dec 2018 03:01:46 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AD930AF7E
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Dec 2018 08:01:41 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: Introduce new mount option to skip block group items scan
Date:   Thu, 20 Dec 2018 16:01:37 +0800
Message-Id: <20181220080137.22819-1-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Btrfs needs to read out all block group (bg) items to fill its bg
caches.

However such bg caches are only needed for read-write mount, and makes
no sense for RO mount.

So this patch introduce new mount option, skip_bg, to skip block group
items scan.

This new 'skip_bg' mount option can only be used with TRUE read-only
mount, which needs the following dependency:
- RO mount
  Obviously.

- No log tree or notreelog mount option

- No way to remoutn RW
  Similar to notreelog mount option.

- No chunk <-> bg <-> dev extents restrict check

This option should only be used as kernel equivalent of btrfs-restore.

With this patch, we can even mount a btrfs whose extent root is
completely corrupted.

But can also be an option to test if btrfs_read_block_groups() is the
major cause for slow btrfs mount.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/ctree.h       |  1 +
 fs/btrfs/disk-io.c     | 29 ++++++++++++++++++---
 fs/btrfs/extent-tree.c | 59 ++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/super.c       | 20 ++++++++++++++
 fs/btrfs/volumes.c     |  7 +++++
 5 files changed, 112 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 80953528572d..371b5e2f6fbe 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1353,6 +1353,7 @@ static inline u32 BTRFS_MAX_XATTR_SIZE(const struct btrfs_fs_info *info)
 #define BTRFS_MOUNT_FREE_SPACE_TREE	(1 << 26)
 #define BTRFS_MOUNT_NOLOGREPLAY		(1 << 27)
 #define BTRFS_MOUNT_REF_VERIFY		(1 << 28)
+#define BTRFS_MOUNT_SKIP_BG		(1 << 29)
 
 #define BTRFS_DEFAULT_COMMIT_INTERVAL	(30)
 #define BTRFS_DEFAULT_MAX_INLINE	(2048)
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index b0ab41da91d1..5228320030a5 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2330,11 +2330,15 @@ static int btrfs_read_roots(struct btrfs_fs_info *fs_info)
 
 	root = btrfs_read_tree_root(tree_root, &location);
 	if (IS_ERR(root)) {
-		ret = PTR_ERR(root);
-		goto out;
+		if (!btrfs_test_opt(fs_info, SKIP_BG)) {
+			ret = PTR_ERR(root);
+			goto out;
+		}
+		fs_info->extent_root = NULL;
+	} else {
+		set_bit(BTRFS_ROOT_TRACK_DIRTY, &root->state);
+		fs_info->extent_root = root;
 	}
-	set_bit(BTRFS_ROOT_TRACK_DIRTY, &root->state);
-	fs_info->extent_root = root;
 
 	location.objectid = BTRFS_DEV_TREE_OBJECTID;
 	root = btrfs_read_tree_root(tree_root, &location);
@@ -2927,6 +2931,23 @@ int open_ctree(struct super_block *sb,
 		goto fail_alloc;
 	}
 
+	/* Skip bg needs RO and no log tree replay */
+	if (btrfs_test_opt(fs_info, SKIP_BG)) {
+		if (!sb_rdonly(sb)) {
+			btrfs_err(fs_info,
+		"skip_bg mount option can only be used with read-only mount");
+			err = -EINVAL;
+			goto fail_alloc;
+		}
+		if (btrfs_super_log_root(disk_super) &&
+		    !btrfs_test_opt(fs_info, NOTREELOG)) {
+			btrfs_err(fs_info,
+	"skip_bg must be used with notreelog mount option for dirty log");
+			err = -EINVAL;
+			goto fail_alloc;
+		}
+	}
+
 	ret = btrfs_init_workqueues(fs_info, fs_devices);
 	if (ret) {
 		err = ret;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a1febf155747..051a5a63c2b0 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -9948,6 +9948,62 @@ static int check_chunk_block_group_mappings(struct btrfs_fs_info *fs_info)
 	return ret;
 }
 
+static int fill_dummy_bgs(struct btrfs_fs_info *fs_info)
+{
+	struct extent_map_tree *em_tree = &fs_info->mapping_tree.map_tree;
+	struct extent_map *em;
+	struct map_lookup *map;
+	struct btrfs_block_group_cache *cache;
+	struct btrfs_space_info *space_info;
+	struct rb_node *node;
+	int ret = 0;
+
+	read_lock(&em_tree->lock);
+	for (node = rb_first_cached(&em_tree->map); node;
+	     node = rb_next(node)) {
+		em = rb_entry(node, struct extent_map, rb_node);
+		map = em->map_lookup;
+		cache = btrfs_create_block_group_cache(fs_info, em->start,
+						       em->len);
+		if (!cache) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		/* Fill dummy cache as FULL */
+		cache->flags = map->type;
+		cache->last_byte_to_unpin = (u64)-1;
+		cache->cached = BTRFS_CACHE_FINISHED;
+		btrfs_set_block_group_used(&cache->item, em->len);
+		btrfs_set_block_group_chunk_objectid(&cache->item, em->start);
+		btrfs_set_block_group_flags(&cache->item, map->type);
+		ret = exclude_super_stripes(cache);
+		if (ret) {
+			free_excluded_extents(cache);
+			btrfs_put_block_group(cache);
+			goto out;
+		}
+		free_excluded_extents(cache);
+		ret = btrfs_add_block_group_cache(fs_info, cache);
+		if (ret) {
+			btrfs_remove_free_space_cache(cache);
+			btrfs_put_block_group(cache);
+			goto out;
+		}
+		update_space_info(fs_info, cache->flags, em->start, em->len,
+				  cache->bytes_super, &space_info);
+		cache->space_info = space_info;
+		link_block_group(cache);
+
+		set_avail_alloc_bits(fs_info, cache->flags);
+		if (btrfs_chunk_readonly(fs_info, em->start))
+			inc_block_group_ro(cache, 1);
+	}
+out:
+	read_unlock(&em_tree->lock);
+	return ret;
+}
+
 int btrfs_read_block_groups(struct btrfs_fs_info *info)
 {
 	struct btrfs_path *path;
@@ -9962,6 +10018,9 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info)
 	u64 feature;
 	int mixed;
 
+	if (btrfs_test_opt(info, SKIP_BG))
+		return fill_dummy_bgs(info);
+
 	feature = btrfs_super_incompat_flags(info->super_copy);
 	mixed = !!(feature & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS);
 
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index b362b45dd757..5bc751819b19 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -337,6 +337,7 @@ enum {
 	Opt_check_integrity_including_extent_data,
 	Opt_check_integrity_print_mask,
 	Opt_enospc_debug, Opt_noenospc_debug,
+	Opt_skip_bg,
 #ifdef CONFIG_BTRFS_DEBUG
 	Opt_fragment_data, Opt_fragment_metadata, Opt_fragment_all,
 #endif
@@ -393,6 +394,7 @@ static const match_table_t tokens = {
 	{Opt_notreelog, "notreelog"},
 	{Opt_usebackuproot, "usebackuproot"},
 	{Opt_user_subvol_rm_allowed, "user_subvol_rm_allowed"},
+	{Opt_skip_bg, "skip_bg"},
 
 	/* Deprecated options */
 	{Opt_alloc_start, "alloc_start=%s"},
@@ -664,6 +666,10 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 			btrfs_clear_and_info(info, NOTREELOG,
 					     "enabling tree log");
 			break;
+		case Opt_skip_bg:
+			btrfs_set_and_info(info, SKIP_BG,
+				"skip mount time block groupo searching");
+			break;
 		case Opt_norecovery:
 		case Opt_nologreplay:
 			btrfs_set_and_info(info, NOLOGREPLAY,
@@ -1797,6 +1803,13 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 	if (ret)
 		goto restore;
 
+	if (btrfs_test_opt(fs_info, SKIP_BG) !=
+	    (old_opts & BTRFS_MOUNT_SKIP_BG)) {
+		btrfs_err(fs_info,
+			"skip_bg mount option can't be changed during remount");
+		ret = -EINVAL;
+		goto restore;
+	}
 	btrfs_remount_begin(fs_info, old_opts, *flags);
 	btrfs_resize_thread_pool(fs_info,
 		fs_info->thread_pool_size, old_thread_pool_size);
@@ -1858,6 +1871,13 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 			goto restore;
 		}
 
+		if (btrfs_test_opt(fs_info, SKIP_BG)) {
+			btrfs_err(fs_info,
+			"remounting read-write with skip_bg is not allowed");
+			ret = -EINVAL;
+			goto restore;
+		}
+
 		ret = btrfs_cleanup_fs_roots(fs_info);
 		if (ret)
 			goto restore;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f435d397019e..d614b2fab652 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7480,6 +7480,13 @@ int btrfs_verify_dev_extents(struct btrfs_fs_info *fs_info)
 	struct btrfs_key key;
 	int ret = 0;
 
+	/*
+	 * For skip_bg mount option, we're already RO and are salvaging data,
+	 * no need for such restrict check.
+	 */
+	if (btrfs_test_opt(fs_info, SKIP_BG))
+		return 0;
+
 	key.objectid = 1;
 	key.type = BTRFS_DEV_EXTENT_KEY;
 	key.offset = 0;
-- 
2.20.1

