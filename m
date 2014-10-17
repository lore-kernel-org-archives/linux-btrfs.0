Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:34186 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490AbaJQQU2 (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Fri, 17 Oct 2014 12:20:28 -0400
From: Filipe Manana <fdmanana@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, clm@fb.com, jbacik@fb.com,
        Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] Btrfs-progs: check, ability to detect and fix outdated snapshot root items
Date: Fri, 17 Oct 2014 18:20:08 +0100
Message-Id: <1413566408-11979-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This change adds code to detect and fix the issue introduced in the kernel
release 3.17, where creation of read-only snapshots lead to a corrupted
filesystem if they were created at a moment when the source subvolume/snapshot
had orphan items. The issue was that the on-disk root items became incorrect,
referring to the pre orphan cleanup root node instead of the post orphan
cleanup root node.

A test filesystem can be generated with the test case recently submitted for
xfstests/fstests, which is essencially the following (bash script):

    workout()
    {
	ops=$1
	procs=$2
	num_snapshots=$3

	_scratch_mkfs >> $seqres.full 2>&1
	_scratch_mount

	snapshot_cmd="$BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT"
	snapshot_cmd="$snapshot_cmd $SCRATCH_MNT/snap_\`date +'%H_%M_%S_%N'\`"
	run_check $FSSTRESS_PROG -p $procs \
	    -x "$snapshot_cmd" -X $num_snapshots -d $SCRATCH_MNT -n $ops
    }

    ops=10000
    procs=4
    snapshots=500
    workout $ops $procs $snapshots

Example of btrfsck's (btrfs check) behaviour against such filesystem:

  $ btrfsck /dev/loop0
  root item for root 311, current bytenr 44630016, current gen 60, current level 1, new bytenr 44957696, new gen 61, new level 1
  root item for root 1480, current bytenr 1003569152, current gen 1271, current level 1, new bytenr 1004175360, new gen 1272, new level 1
  root item for root 1509, current bytenr 1037434880, current gen 1300, current level 1, new bytenr 1038467072, new gen 1301, new level 1
  root item for root 1562, current bytenr 33636352, current gen 1354, current level 1, new bytenr 34455552, new gen 1355, new level 1
  root item for root 3094, current bytenr 1011712000, current gen 2935, current level 1, new bytenr 1008484352, new gen 2936, new level 1
  root item for root 3716, current bytenr 80805888, current gen 3578, current level 1, new bytenr 73515008, new gen 3579, new level 1
  root item for root 4085, current bytenr 714031104, current gen 3958, current level 1, new bytenr 716816384, new gen 3959, new level 1
  Found 7 roots with an outdated root item.
  Please run a filesystem check with the option --repair to fix them.

  $ echo $?
  1

  $ btrfsck --repair /dev/loop0
  enabling repair mode
  fixing root item for root 311, current bytenr 44630016, current gen 60, current level 1, new bytenr 44957696, new gen 61, new level 1
  fixing root item for root 1480, current bytenr 1003569152, current gen 1271, current level 1, new bytenr 1004175360, new gen 1272, new level 1
  fixing root item for root 1509, current bytenr 1037434880, current gen 1300, current level 1, new bytenr 1038467072, new gen 1301, new level 1
  fixing root item for root 1562, current bytenr 33636352, current gen 1354, current level 1, new bytenr 34455552, new gen 1355, new level 1
  fixing root item for root 3094, current bytenr 1011712000, current gen 2935, current level 1, new bytenr 1008484352, new gen 2936, new level 1
  fixing root item for root 3716, current bytenr 80805888, current gen 3578, current level 1, new bytenr 73515008, new gen 3579, new level 1
  fixing root item for root 4085, current bytenr 714031104, current gen 3958, current level 1, new bytenr 716816384, new gen 3959, new level 1
  Fixed 7 roots.
  Checking filesystem on /dev/loop0
  UUID: 2186e9b9-c977-4a35-9c7b-69c6609d4620
  checking extents
  checking free space cache
  cache and super generation don't match, space cache will be invalidated
  checking fs roots
  checking csums
  checking root refs
  found 618537000 bytes used err is 0
  total csum bytes: 130824
  total tree bytes: 601620480
  total fs tree bytes: 580288512
  total extent tree bytes: 18464768
  btree space waste bytes: 136939144
  file data blocks allocated: 34150318080
   referenced 27815415808
  Btrfs v3.17-rc3-2-gbbe1dd8

  $ echo $?
  0

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 cmds-check.c                                       | 356 +++++++++++++++++++++
 disk-io.c                                          |   2 +
 extent-tree.c                                      |  22 +-
 tests/fsck-tests.sh                                |  15 +-
 tests/fsck-tests/006-bad_root_items_fs.tar.xz      | Bin 0 -> 24980 bytes
 .../fsck-tests/007-bad_root_items_fs_skinny.tar.xz | Bin 0 -> 26520 bytes
 utils.c                                            |  21 ++
 utils.h                                            |   2 +
 8 files changed, 395 insertions(+), 23 deletions(-)
 create mode 100644 tests/fsck-tests/006-bad_root_items_fs.tar.xz
 create mode 100644 tests/fsck-tests/007-bad_root_items_fs_skinny.tar.xz

diff --git a/cmds-check.c b/cmds-check.c
index 310eb2a..2a5f823 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -7198,6 +7198,345 @@ static int fill_csum_tree(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
+struct root_item_info {
+	/* level of the root */
+	u8 level;
+	/* number of nodes at this level, must be 1 for a root */
+	int node_count;
+	u64 bytenr;
+	u64 gen;
+	struct cache_extent cache_extent;
+};
+
+static struct cache_tree *roots_info_cache = NULL;
+
+static void free_roots_info_cache(void)
+{
+	if (!roots_info_cache)
+		return;
+
+	while (!cache_tree_empty(roots_info_cache)) {
+		struct cache_extent *entry;
+		struct root_item_info *rii;
+
+		entry = first_cache_extent(roots_info_cache);
+		remove_cache_extent(roots_info_cache, entry);
+		rii = container_of(entry, struct root_item_info, cache_extent);
+		free(rii);
+	}
+
+	free(roots_info_cache);
+	roots_info_cache = NULL;
+}
+
+static int build_roots_info_cache(struct btrfs_fs_info *info)
+{
+	int ret = 0;
+	struct btrfs_key key;
+	struct extent_buffer *leaf;
+	struct btrfs_path *path;
+
+	if (!roots_info_cache) {
+		roots_info_cache = malloc(sizeof(*roots_info_cache));
+		if (!roots_info_cache)
+			return -ENOMEM;
+		cache_tree_init(roots_info_cache);
+	}
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	key.objectid = 0;
+	key.type = BTRFS_EXTENT_ITEM_KEY;
+	key.offset = 0;
+
+	ret = btrfs_search_slot(NULL, info->extent_root, &key, path, 0, 0);
+	if (ret < 0)
+		goto out;
+	leaf = path->nodes[0];
+
+	while (1) {
+		struct btrfs_key found_key;
+		struct btrfs_extent_item *ei;
+		struct btrfs_extent_inline_ref *iref;
+		int slot = path->slots[0];
+		int type;
+		u64 flags;
+		u64 root_id;
+		u8 level;
+		struct cache_extent *entry;
+		struct root_item_info *rii;
+
+		if (slot >= btrfs_header_nritems(leaf)) {
+			ret = btrfs_next_leaf(info->extent_root, path);
+			if (ret < 0) {
+				break;
+			} else if (ret) {
+				ret = 0;
+				break;
+			}
+			leaf = path->nodes[0];
+			slot = path->slots[0];
+		}
+
+		btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
+
+		if (found_key.type != BTRFS_EXTENT_ITEM_KEY &&
+		    found_key.type != BTRFS_METADATA_ITEM_KEY)
+			goto next;
+
+		ei = btrfs_item_ptr(leaf, slot, struct btrfs_extent_item);
+		flags = btrfs_extent_flags(leaf, ei);
+
+		if (found_key.type == BTRFS_EXTENT_ITEM_KEY &&
+		    !(flags & BTRFS_EXTENT_FLAG_TREE_BLOCK))
+			goto next;
+
+		if (found_key.type == BTRFS_METADATA_ITEM_KEY) {
+			iref = (struct btrfs_extent_inline_ref *)(ei + 1);
+			level = found_key.offset;
+		} else {
+			struct btrfs_tree_block_info *info;
+
+			info = (struct btrfs_tree_block_info *)(ei + 1);
+			iref = (struct btrfs_extent_inline_ref *)(info + 1);
+			level = btrfs_tree_block_level(leaf, info);
+		}
+
+		/*
+		 * For a root extent, it must be of the following type and the
+		 * first (and only one) iref in the item.
+		 */
+		type = btrfs_extent_inline_ref_type(leaf, iref);
+		if (type != BTRFS_TREE_BLOCK_REF_KEY)
+			goto next;
+
+		root_id = btrfs_extent_inline_ref_offset(leaf, iref);
+		entry = lookup_cache_extent(roots_info_cache, root_id, 1);
+		if (!entry) {
+			rii = malloc(sizeof(struct root_item_info));
+			if (!rii) {
+				ret = -ENOMEM;
+				goto out;
+			}
+			rii->cache_extent.start = root_id;
+			rii->cache_extent.size = 1;
+			rii->level = (u8)-1;
+			entry = &rii->cache_extent;
+			ret = insert_cache_extent(roots_info_cache, entry);
+			ASSERT(ret == 0);
+		} else {
+			rii = container_of(entry, struct root_item_info,
+					   cache_extent);
+		}
+
+		ASSERT(rii->cache_extent.start == root_id);
+		ASSERT(rii->cache_extent.size == 1);
+
+		if (level > rii->level || rii->level == (u8)-1) {
+			rii->level = level;
+			rii->bytenr = found_key.objectid;
+			rii->gen = btrfs_extent_generation(leaf, ei);
+			rii->node_count = 1;
+		} else if (level == rii->level) {
+			rii->node_count++;
+		}
+next:
+		path->slots[0]++;
+	}
+
+out:
+	btrfs_free_path(path);
+
+	return ret;
+}
+
+static int maybe_repair_root_item(struct btrfs_fs_info *info,
+				  struct btrfs_path *path,
+				  const struct btrfs_key *root_key,
+				  const int read_only_mode)
+{
+	const u64 root_id = root_key->objectid;
+	struct cache_extent *entry;
+	struct root_item_info *rii;
+	struct btrfs_root_item ri;
+	unsigned long offset;
+
+	entry = lookup_cache_extent(roots_info_cache, root_id, 1);
+	if (!entry) {
+		fprintf(stderr,
+			"Error: could not find extent items for root %llu\n",
+			root_key->objectid);
+		return -ENOENT;
+	}
+
+	rii = container_of(entry, struct root_item_info, cache_extent);
+	ASSERT(rii->cache_extent.start == root_id);
+	ASSERT(rii->cache_extent.size == 1);
+
+	if (rii->node_count != 1) {
+		fprintf(stderr,
+			"Error: could not find btree root extent for root %llu\n",
+			root_id);
+		return -ENOENT;
+	}
+
+	offset = btrfs_item_ptr_offset(path->nodes[0], path->slots[0]);
+	read_extent_buffer(path->nodes[0], &ri, offset, sizeof(ri));
+
+	if (btrfs_root_bytenr(&ri) != rii->bytenr ||
+	    btrfs_root_level(&ri) != rii->level ||
+	    btrfs_root_generation(&ri) != rii->gen) {
+
+		/*
+		 * If we're in repair mode but our caller told us to not update
+		 * the root item, i.e. just check if it needs to be updated, don't
+		 * print this message, since the caller will call us again shortly
+		 * for the same root item without read only mode (the caller will
+		 * open a transaction first).
+		 */
+		if (!(read_only_mode && repair))
+			fprintf(stderr,
+				"%sroot item for root %llu,"
+				" current bytenr %llu, current gen %llu, current level %u,"
+				" new bytenr %llu, new gen %llu, new level %u\n",
+				(read_only_mode ? "" : "fixing "),
+				root_id,
+				btrfs_root_bytenr(&ri), btrfs_root_generation(&ri),
+				btrfs_root_level(&ri),
+				rii->bytenr, rii->gen, rii->level);
+
+		if (btrfs_root_generation(&ri) > rii->gen) {
+			fprintf(stderr,
+				"root %llu has a root item with a more recent gen (%llu) compared to the found root node (%llu)\n",
+				root_id, btrfs_root_generation(&ri), rii->gen);
+			return -EINVAL;
+		}
+
+		if (!read_only_mode) {
+			btrfs_set_root_bytenr(&ri, rii->bytenr);
+			btrfs_set_root_level(&ri, rii->level);
+			btrfs_set_root_generation(&ri, rii->gen);
+			write_extent_buffer(path->nodes[0], &ri,
+					    offset, sizeof(ri));
+		}
+
+		return 1;
+	}
+
+	return 0;
+}
+
+/*
+ * A regression introduced in the 3.17 kernel (more specifically in 3.17-rc2),
+ * caused read-only snapshots to be corrupted if they were created at a moment
+ * when the source subvolume/snapshot had orphan items. The issue was that the
+ * on-disk root items became incorrect, referring to the pre orphan cleanup root
+ * node instead of the post orphan cleanup root node.
+ * So this function, and its callees, just detects and fixes those cases. Even
+ * though the regression was for read-only snapshots, this function applies to
+ * any snapshot/subvolume root.
+ * This must be run before any other repair code - not doing it so, makes other
+ * repair code delete or modify backrefs in the extent tree for example, which
+ * will result in an inconsistent fs after repairing the root items.
+ */
+static int repair_root_items(struct btrfs_fs_info *info)
+{
+	struct btrfs_path *path = NULL;
+	struct btrfs_key key;
+	struct extent_buffer *leaf;
+	struct btrfs_trans_handle *trans = NULL;
+	int ret = 0;
+	int bad_roots = 0;
+	int need_trans = 0;
+
+	ret = build_roots_info_cache(info);
+	if (ret)
+		goto out;
+
+	path = btrfs_alloc_path();
+	if (!path) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	key.objectid = BTRFS_FIRST_FREE_OBJECTID;
+	key.type = BTRFS_ROOT_ITEM_KEY;
+	key.offset = 0;
+
+again:
+	/*
+	 * Avoid opening and committing transactions if a leaf doesn't have
+	 * any root items that need to be fixed, so that we avoid rotating
+	 * backup roots unnecessarily.
+	 */
+	if (need_trans) {
+		trans = btrfs_start_transaction(info->tree_root, 1);
+		if (IS_ERR(trans)) {
+			ret = PTR_ERR(trans);
+			goto out;
+		}
+	}
+
+	ret = btrfs_search_slot(trans, info->tree_root, &key, path,
+				0, trans ? 1 : 0);
+	if (ret < 0)
+		goto out;
+	leaf = path->nodes[0];
+
+	while (1) {
+		struct btrfs_key found_key;
+
+		if (path->slots[0] >= btrfs_header_nritems(leaf)) {
+			int no_more_keys = find_next_key(path, &key);
+
+			btrfs_release_path(path);
+			if (trans) {
+				ret = btrfs_commit_transaction(trans,
+							       info->tree_root);
+				trans = NULL;
+				if (ret < 0)
+					goto out;
+			}
+			need_trans = 0;
+			if (no_more_keys)
+				break;
+			goto again;
+		}
+
+		btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
+
+		if (found_key.type != BTRFS_ROOT_ITEM_KEY)
+			goto next;
+
+		ret = maybe_repair_root_item(info, path, &found_key,
+					     trans ? 0 : 1);
+		if (ret < 0)
+			goto out;
+		if (ret) {
+			if (!trans && repair) {
+				need_trans = 1;
+				key = found_key;
+				btrfs_release_path(path);
+				goto again;
+			}
+			bad_roots++;
+		}
+next:
+		path->slots[0]++;
+	}
+	ret = 0;
+out:
+	free_roots_info_cache();
+	if (path)
+		btrfs_free_path(path);
+	if (ret < 0)
+		return ret;
+
+	return bad_roots;
+}
+
 static struct option long_options[] = {
 	{ "super", 1, NULL, 's' },
 	{ "repair", 0, NULL, 0 },
@@ -7320,6 +7659,23 @@ int cmd_check(int argc, char **argv)
 	}
 
 	root = info->fs_root;
+
+	ret = repair_root_items(info);
+	if (ret < 0)
+		goto close_out;
+	if (repair) {
+		fprintf(stderr, "Fixed %d roots.\n", ret);
+		ret = 0;
+	} else if (ret > 0) {
+		fprintf(stderr,
+		       "Found %d roots with an outdated root item.\n",
+		       ret);
+		fprintf(stderr,
+			"Please run a filesystem check with the option --repair to fix them.\n");
+		ret = 1;
+		goto close_out;
+	}
+
 	/*
 	 * repair mode will force us to commit transaction which
 	 * will make us fail to load log tree when mounting.
diff --git a/disk-io.c b/disk-io.c
index 0c4cb4a..0364b96 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -475,6 +475,8 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 
 	if (root->commit_root == root->node)
 		goto commit_tree;
+	if (root == root->fs_info->tree_root)
+		goto commit_tree;
 
 	free_extent_buffer(root->commit_root);
 	root->commit_root = NULL;
diff --git a/extent-tree.c b/extent-tree.c
index 5443ec8..080f30d 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -29,6 +29,7 @@
 #include "volumes.h"
 #include "free-space-cache.h"
 #include "math.h"
+#include "utils.h"
 
 #define PENDING_EXTENT_INSERT 0
 #define PENDING_EXTENT_DELETE 1
@@ -972,27 +973,6 @@ static inline int extent_ref_type(u64 parent, u64 owner)
 	return type;
 }
 
-static int find_next_key(struct btrfs_path *path, struct btrfs_key *key)
-
-{
-	int level;
-	for (level = 0; level < BTRFS_MAX_LEVEL; level++) {
-		if (!path->nodes[level])
-			break;
-		if (path->slots[level] + 1 >=
-		    btrfs_header_nritems(path->nodes[level]))
-			continue;
-		if (level == 0)
-			btrfs_item_key_to_cpu(path->nodes[level], key,
-					      path->slots[level] + 1);
-		else
-			btrfs_node_key_to_cpu(path->nodes[level], key,
-					      path->slots[level] + 1);
-		return 0;
-	}
-	return 1;
-}
-
 static int lookup_inline_extent_backref(struct btrfs_trans_handle *trans,
 				 struct btrfs_root *root,
 				 struct btrfs_path *path,
diff --git a/tests/fsck-tests.sh b/tests/fsck-tests.sh
index 867366b..3f04626 100644
--- a/tests/fsck-tests.sh
+++ b/tests/fsck-tests.sh
@@ -27,12 +27,23 @@ rm -f $RESULT
 # test rely on corrupting blocks tool
 run_check make btrfs-corrupt-block
 
-for i in $(find $here/tests/fsck-tests -name '*.img')
+# Some broken filesystem images are kept as .img files, created by the tool
+# btrfs-image, and others are kept as .tar.xz files that contain raw filesystem
+# image (the backing file of a loop device, as a sparse file). The reason for
+# keeping some as tarballs of raw images is that for these cases btrfs-image
+# isn't able to preserve all the (bad) filesystem structure for some reason.
+for i in $(find $here/tests/fsck-tests -name '*.img' -o -name '*.tar.xz')
 do
 	echo "     [TEST]    $(basename $i)"
 	echo "testing image $i" >> $RESULT
 
-	run_check $here/btrfs-image -r $i test.img
+	extension=${i#*.}
+
+	if [ $extension == "img" ]; then
+		run_check $here/btrfs-image -r $i test.img
+	else
+		run_check tar xJf $i
+	fi
 
 	$here/btrfsck test.img >> $RESULT 2>&1
 	[ $? -eq 0 ] && _fail "btrfsck should have detected corruption"
diff --git a/tests/fsck-tests/006-bad_root_items_fs.tar.xz b/tests/fsck-tests/006-bad_root_items_fs.tar.xz
new file mode 100644
index 0000000000000000000000000000000000000000..125d8e7d236fdd80c69bb67a0489afde345e1d5d
GIT binary patch
literal 24980
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

literal 0
HcmV?d00001

diff --git a/tests/fsck-tests/007-bad_root_items_fs_skinny.tar.xz b/tests/fsck-tests/007-bad_root_items_fs_skinny.tar.xz
new file mode 100644
index 0000000000000000000000000000000000000000..ed99dc4daff773bd7f7dee60d552502f57d30c50
GIT binary patch
literal 26520
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
P6c;-%0{{R300dcDMYoOX

literal 0
HcmV?d00001

diff --git a/utils.c b/utils.c
index e86292a..a26858e 100644
--- a/utils.c
+++ b/utils.c
@@ -2405,3 +2405,24 @@ void units_set_base(unsigned *units, unsigned base)
 
 	*units = base | mode;
 }
+
+int find_next_key(struct btrfs_path *path, struct btrfs_key *key)
+{
+	int level;
+
+	for (level = 0; level < BTRFS_MAX_LEVEL; level++) {
+		if (!path->nodes[level])
+			break;
+		if (path->slots[level] + 1 >=
+		    btrfs_header_nritems(path->nodes[level]))
+			continue;
+		if (level == 0)
+			btrfs_item_key_to_cpu(path->nodes[level], key,
+					      path->slots[level] + 1);
+		else
+			btrfs_node_key_to_cpu(path->nodes[level], key,
+					      path->slots[level] + 1);
+		return 0;
+	}
+	return 1;
+}
diff --git a/utils.h b/utils.h
index aed03f2..7accbd2 100644
--- a/utils.h
+++ b/utils.h
@@ -158,4 +158,6 @@ static inline u64 btrfs_min_dev_size(u32 leafsize)
 		    btrfs_min_global_blk_rsv_size(leafsize));
 }
 
+int find_next_key(struct btrfs_path *path, struct btrfs_key *key);
+
 #endif
-- 
1.9.1

