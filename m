Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:14430 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754622AbcEQDx7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 May 2016 23:53:59 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v1.1 3/4] btrfs-progs: fsck: Add support to clear free space cache
Date: Tue, 17 May 2016 11:53:54 +0800
Message-Id: <1463457234-18989-1-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1463456878-17550-4-git-send-email-quwenruo@cn.fujitsu.com>
References: <1463456878-17550-4-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add a new option "--clear-space-cache" for btrfs check.

Unlike many may assume, kernel "clear_cache" will only rebuild *SOME* of
the free space cache, not *ALL*.

Or more specifically, it will only rebuild free space cache for block
groups that has read out the cache during "clear_cache" mount time.

And since kernel will not read out free space cache at mount, but only
when kernel needs to allocate space from the block group, so bad
free space cache will stay untouched for a long time.

Such kernel design is quite good, as it dramatically reduce the mount
time for large fs, so I prefer not to change that.

Instead, since a lot of user consider free space warning from kernel as
an error, we should handle them like an error, which means we should use
btrfsck to fix it, even it's harmless most of time.

This patch will use "--clear-space-cache" to clear all free space
cache, and modify cache_generation to -1.

Reported-by: Ivan P <chrnosphered@gmail.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v1.1:
   Fix error that when free space cache inode is not found, we still
   remove one item from tree root.
---
 Documentation/btrfs-check.asciidoc |   8 +++
 cmds-check.c                       |  58 ++++++++++++++++-
 free-space-cache.c                 | 126 +++++++++++++++++++++++++++++++++++++
 free-space-cache.h                 |   4 ++
 4 files changed, 195 insertions(+), 1 deletion(-)

diff --git a/Documentation/btrfs-check.asciidoc b/Documentation/btrfs-check.asciidoc
index 74a2ad2..ea25582 100644
--- a/Documentation/btrfs-check.asciidoc
+++ b/Documentation/btrfs-check.asciidoc
@@ -78,6 +78,14 @@ respective superblock offset is within the device size
 This can be used to use a different starting point if some of the primary
 superblock is damaged.
 
+--clear-space-cache::
+clear all free space cache
++
+NOTE:
+Kernel mount option 'clear_cache' is only designed to rebuild free space cache
+which is modified during the lifetime of that mount option.
+It doesn't rebuild all free space cache, nor clear them out.
+
 DANGEROUS OPTIONS
 -----------------
 
diff --git a/cmds-check.c b/cmds-check.c
index ec0bbfd..1f6aefb 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -9524,10 +9524,41 @@ const char * const cmd_check_usage[] = {
 	"                            print subvolume extents and sharing state",
 	"-r|--tree-root <bytenr>     use the given bytenr for the tree root",
 	"--chunk-root <bytenr>       use the given bytenr for the chunk tree root",
+	"--clear-space-cache         clear all free space cache(v1)",
 	"-p|--progress               indicate progress",
 	NULL
 };
 
+static int clear_free_space_cache(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_block_group_cache *bg_cache;
+	u64 current = 0;
+	int ret = 0;
+
+	/* Clear all free space cache inodes and its extent data */
+	while (1) {
+		bg_cache = btrfs_lookup_first_block_group(fs_info, current);
+		if (!bg_cache)
+			break;
+		ret = btrfs_clear_free_space_cache(fs_info, bg_cache);
+		if (ret < 0)
+			return ret;
+		current = bg_cache->key.objectid + bg_cache->key.offset;
+	}
+
+	/* Don't forget to set cache_generation to -1 */
+	trans = btrfs_start_transaction(fs_info->tree_root, 0);
+	if (IS_ERR(trans)) {
+		error("failed to update super block cache generation");
+		return PTR_ERR(trans);
+	}
+	btrfs_set_super_cache_generation(fs_info->super_copy, (u64)-1);
+	btrfs_commit_transaction(trans, fs_info->tree_root);
+	
+	return ret;
+}
+
 int cmd_check(int argc, char **argv)
 {
 	struct cache_tree root_cache;
@@ -9543,13 +9574,15 @@ int cmd_check(int argc, char **argv)
 	int init_csum_tree = 0;
 	int readonly = 0;
 	int qgroup_report = 0;
+	int clear_space_cache = 0;
 	enum btrfs_open_ctree_flags ctree_flags = OPEN_CTREE_EXCLUSIVE;
 
 	while(1) {
 		int c;
 		enum { GETOPT_VAL_REPAIR = 257, GETOPT_VAL_INIT_CSUM,
 			GETOPT_VAL_INIT_EXTENT, GETOPT_VAL_CHECK_CSUM,
-			GETOPT_VAL_READONLY, GETOPT_VAL_CHUNK_TREE };
+			GETOPT_VAL_READONLY, GETOPT_VAL_CHUNK_TREE, 
+			GETOPT_VAL_CLEAR_SPACE_CACHE};
 		static const struct option long_options[] = {
 			{ "super", required_argument, NULL, 's' },
 			{ "repair", no_argument, NULL, GETOPT_VAL_REPAIR },
@@ -9566,6 +9599,8 @@ int cmd_check(int argc, char **argv)
 			{ "tree-root", required_argument, NULL, 'r' },
 			{ "chunk-root", required_argument, NULL,
 				GETOPT_VAL_CHUNK_TREE },
+			{ "clear-space-cache", no_argument, NULL,
+				GETOPT_VAL_CLEAR_SPACE_CACHE},
 			{ "progress", no_argument, NULL, 'p' },
 			{ NULL, 0, NULL, 0}
 		};
@@ -9631,6 +9666,11 @@ int cmd_check(int argc, char **argv)
 			case GETOPT_VAL_CHECK_CSUM:
 				check_data_csum = 1;
 				break;
+			case GETOPT_VAL_CLEAR_SPACE_CACHE:
+				clear_space_cache = 1;
+				repair = 1;
+				ctree_flags |= OPEN_CTREE_WRITES;
+				break;
 		}
 	}
 
@@ -9693,6 +9733,22 @@ int cmd_check(int argc, char **argv)
 	}
 
 	uuid_unparse(info->super_copy->fsid, uuidbuf);
+	if (clear_space_cache) {
+		/* Basic check, don't support v2 free space cache yet */
+		if (btrfs_fs_compat_ro(info,
+				BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE)) {
+			error("doesn't support space cache tree(v2) yet");
+			ret = -ENOTTY;
+			goto close_out;
+		}
+		printf("Clearing all free space cache\n");
+		ret = clear_free_space_cache(info);
+		if (ret)
+			error("failed to clear free space cache");
+		else
+			printf("Free space cache cleared\n");
+		goto close_out;
+	}
 	if (qgroup_report) {
 		printf("Print quota groups for %s\nUUID: %s\n", argv[optind],
 		       uuidbuf);
diff --git a/free-space-cache.c b/free-space-cache.c
index 357d69e..8cff23b 100644
--- a/free-space-cache.c
+++ b/free-space-cache.c
@@ -25,6 +25,7 @@
 #include "crc32c.h"
 #include "bitops.h"
 #include "internal.h"
+#include "utils.h"
 
 /*
  * Kernel always uses PAGE_CACHE_SIZE for sectorsize, but we don't have
@@ -877,3 +878,128 @@ next:
 		prev = e;
 	}
 }
+
+int btrfs_clear_free_space_cache(struct btrfs_fs_info *fs_info,
+				 struct btrfs_block_group_cache *bg)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_root *tree_root = fs_info->tree_root;
+	struct btrfs_path path;
+	struct btrfs_key key;
+	struct btrfs_disk_key location;
+	struct btrfs_free_space_header *sc_header;
+	struct extent_buffer *node;
+	u64 ino;
+	int slot;
+	int ret;
+
+	trans = btrfs_start_transaction(tree_root, 1);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
+
+	btrfs_init_path(&path);
+
+	key.objectid = BTRFS_FREE_SPACE_OBJECTID;
+	key.type = 0;
+	key.offset = bg->key.objectid;
+
+	ret = btrfs_search_slot(trans, tree_root, &key, &path, -1, 1);
+	if (ret > 0) {
+		ret = 0;
+		goto out;
+	}
+	if (ret < 0)
+		goto out;
+
+	node = path.nodes[0];
+	slot = path.slots[0];
+	sc_header = btrfs_item_ptr(node, slot, struct btrfs_free_space_header);
+	btrfs_free_space_key(node, sc_header, &location);
+	ino = location.objectid;
+
+	/* Delete the free space header, as we have the ino to continue */
+	ret = btrfs_del_item(trans, tree_root, &path);
+	if (ret < 0) {
+		error("failed to remove free space header for block group %llu",
+		      bg->key.objectid);
+		goto out;
+	}
+	btrfs_release_path(&path);
+
+	/* Iterate from the end of the free space cache inode */
+	key.objectid = ino;
+	key.type = BTRFS_EXTENT_DATA_KEY;
+	key.offset = (u64)-1;
+	ret = btrfs_search_slot(trans, tree_root, &key, &path, -1, 1);
+	if (ret < 0) {
+		error("failed to locate free space cache extent for block group %llu",
+		      bg->key.objectid);
+		goto out;
+	}
+	while (1) {
+		struct btrfs_file_extent_item *fi;
+		u64 disk_bytenr;
+		u64 disk_num_bytes;
+
+
+		ret = btrfs_previous_item(tree_root, &path, ino,
+					  BTRFS_EXTENT_DATA_KEY);
+		if (ret > 0) {
+			ret = 0;
+			break;
+		}
+		if (ret < 0) {
+			error("failed to locate free space cache extent for block group %llu",
+			      bg->key.objectid);
+			goto out;
+		}
+		node = path.nodes[0];
+		slot = path.slots[0];
+		btrfs_item_key_to_cpu(node, &key, slot);
+		fi = btrfs_item_ptr(node, slot, struct btrfs_file_extent_item);
+		disk_bytenr = btrfs_file_extent_disk_bytenr(node, fi);
+		disk_num_bytes = btrfs_file_extent_disk_num_bytes(node, fi);
+
+		ret = btrfs_free_extent(trans, tree_root, disk_bytenr,
+					disk_num_bytes, 0, tree_root->objectid,
+					ino, key.offset);
+		if (ret < 0) {
+			error("failed to remove backref for disk bytenr %llu",
+			      disk_bytenr);
+			goto out;
+		}
+		ret = btrfs_del_item(trans, tree_root, &path);
+		if (ret < 0) {
+			error("failed to remove free space extent data for ino %llu offset %llu",
+			      ino, key.offset);
+			goto out;
+		}
+	}
+	btrfs_release_path(&path);
+
+	/* Now delete free space cache inode item */
+	key.objectid = ino;
+	key.type = BTRFS_INODE_ITEM_KEY;
+	key.offset = 0;
+
+	ret = btrfs_search_slot(trans, tree_root, &key, &path, -1, 1);
+	if (ret > 0) {
+		warning("free space inode %llu not found, ignore", ino);
+		goto out;
+	}
+	if (ret < 0) {
+		error("failed to locate free space cache inode %llu for block group %llu",
+		      ino, bg->key.objectid);
+		goto out;
+	}
+	ret = btrfs_del_item(trans, tree_root, &path);
+	if (ret < 0) {
+		error("failed to delete free space cache inode %llu for block group %llu",
+		      ino, bg->key.objectid);
+	}
+out:
+	btrfs_release_path(&path);
+	if (!ret)
+		btrfs_commit_transaction(trans, tree_root);
+	return ret;
+}
diff --git a/free-space-cache.h b/free-space-cache.h
index 9214077..90302ac 100644
--- a/free-space-cache.h
+++ b/free-space-cache.h
@@ -59,4 +59,8 @@ void unlink_free_space(struct btrfs_free_space_ctl *ctl,
 		       struct btrfs_free_space *info);
 int btrfs_add_free_space(struct btrfs_free_space_ctl *ctl, u64 offset,
 			 u64 bytes);
+
+/* Used for clearing one free space cache for given block group */
+int btrfs_clear_free_space_cache(struct btrfs_fs_info *fs_info,
+				 struct btrfs_block_group_cache *bg);
 #endif
-- 
2.8.2



