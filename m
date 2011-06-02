From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [RFC PATCH] Btrfs-progs: Backref walking utilities
Date: Thu, 2 Jun 2011 10:11:49 +0800
Message-ID: <1306980709-9234-1-git-send-email-liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch comes from one of project ideas on btrfs's wiki:
Quote:
Given a block number on a disk, the Btrfs metadata can find all the files and
directories that use or care about that block. Some utilities to walk these
back refs and print the results would help debug corruptions.

Given an inode, the Btrfs metadata can find all the directories that point to
the inode. We should have utils to walk these back refs as well.
end quote.

And the patch brings us:
1) -i aaa
   This indicates to walk inode ref belonged to 'aaa' ('aaa' is an inode number).
2) -b aaa
   This indicates to walk extent backref who started at 'aaa' ('aaa' is a logical
   address).
3) -s aaa -i bbb
   This is similar to 1), and '-s aaa' stands for which snapshot we will search
   thorough, while '-i bbb' still point to an inode number.

Here are some results:
===
$ btrfs-walk-backref -i 257 /dev/sda10
FS tree
	file (inode: 257):
		inode ref index 2 namelen 3 name: tmp
		inode ref index 4 namelen 4 name: foo1
	|
	`---dir (inode: 256):
		inode ref index 0 namelen 2 name: ..

	file (inode: 257):
		inode ref index 2 namelen 4 name: foo2
	|
	`---dir (inode: 258):
		inode ref index 5 namelen 3 name: dir

file tree (256)
	file (inode: 257):
		inode ref index 2 namelen 3 name: tmp
	|
	`---dir (inode: 256):
		inode ref index 0 namelen 2 name: ..

file tree (257)
	file (inode: 257):
		inode ref index 2 namelen 3 name: tmp
	|
	`---dir (inode: 256):
		inode ref index 0 namelen 2 name: ..

file tree (258)
	file (inode: 257):
		inode ref index 2 namelen 3 name: tmp
	|
	`---dir (inode: 256):
		inode ref index 0 namelen 2 name: ..

Btrfs v0.19-36-g96dbd42
===

Here we track a file, whose ino is 257, and the file is in 4 trees,
the sole FS tree and three snapshots.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 Makefile       |    5 +-
 disk-io.c      |    6 +-
 print-tree.c   |    4 +-
 print-tree.h   |    3 +
 walk-backref.c |  434 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 448 insertions(+), 4 deletions(-)
 create mode 100644 walk-backref.c

diff --git a/Makefile b/Makefile
index 6e6f6c6..b3808b2 100644
--- a/Makefile
+++ b/Makefile
@@ -18,7 +18,7 @@ LIBS=-luuid
 
 progs = btrfsctl mkfs.btrfs btrfs-debug-tree btrfs-show btrfs-vol btrfsck \
 	btrfs \
-	btrfs-map-logical
+	btrfs-map-logical btrfs-walk-backref
 
 # make C=1 to enable sparse
 ifdef C
@@ -59,6 +59,9 @@ mkfs.btrfs: $(objects) mkfs.o
 btrfs-debug-tree: $(objects) debug-tree.o
 	gcc $(CFLAGS) -o btrfs-debug-tree $(objects) debug-tree.o $(LDFLAGS) $(LIBS)
 
+btrfs-walk-backref: $(objects) walk-backref.o
+	gcc $(CFLAGS) -o btrfs-walk-backref $(objects) walk-backref.o $(LDFLAGS) $(LIBS)
+
 btrfs-zero-log: $(objects) btrfs-zero-log.o
 	gcc $(CFLAGS) -o btrfs-zero-log $(objects) btrfs-zero-log.o $(LDFLAGS) $(LIBS)
 
diff --git a/disk-io.c b/disk-io.c
index a6e1000..342a884 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -407,7 +407,11 @@ static int find_and_setup_root(struct btrfs_root *tree_root,
 		     root, fs_info, objectid);
 	ret = btrfs_find_last_root(tree_root, objectid,
 				   &root->root_item, &root->root_key);
-	BUG_ON(ret);
+	if (ret) {
+		if (ret == 1)
+			ret = -ENOENT;
+		return ret;
+	}
 
 	blocksize = btrfs_level_size(root, btrfs_root_level(&root->root_item));
 	generation = btrfs_root_generation(&root->root_item);
diff --git a/print-tree.c b/print-tree.c
index ac575d5..7d02f9f 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -55,7 +55,7 @@ static int print_dir_item(struct extent_buffer *eb, struct btrfs_item *item,
 	return 0;
 }
 
-static int print_inode_ref_item(struct extent_buffer *eb, struct btrfs_item *item,
+int print_inode_ref_item(struct extent_buffer *eb, struct btrfs_item *item,
 				struct btrfs_inode_ref *ref)
 {
 	u32 total;
@@ -159,7 +159,7 @@ static void print_file_extent_item(struct extent_buffer *eb,
 	       btrfs_file_extent_compression(eb, fi));
 }
 
-static void print_extent_item(struct extent_buffer *eb, int slot)
+void print_extent_item(struct extent_buffer *eb, int slot)
 {
 	struct btrfs_extent_item *ei;
 	struct btrfs_extent_inline_ref *iref;
diff --git a/print-tree.h b/print-tree.h
index 495b81a..2b4664c 100644
--- a/print-tree.h
+++ b/print-tree.h
@@ -21,4 +21,7 @@
 void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l);
 void btrfs_print_tree(struct btrfs_root *root, struct extent_buffer *t, int follow);
 void btrfs_print_key(struct btrfs_disk_key *disk_key);
+int print_inode_ref_item(struct extent_buffer *eb, struct btrfs_item *item,
+				struct btrfs_inode_ref *ref);
+void print_extent_item(struct extent_buffer *eb, int slot);
 #endif
diff --git a/walk-backref.c b/walk-backref.c
new file mode 100644
index 0000000..af40758
--- /dev/null
+++ b/walk-backref.c
@@ -0,0 +1,434 @@
+/*
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+#include <sys/types.h>
+#include <dirent.h>
+#include <sys/stat.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <libgen.h>
+#include <limits.h>
+#include <uuid/uuid.h>
+#include <ctype.h>
+
+#undef ULONG_MAX
+
+#include "kerncompat.h"
+#include "ctree.h"
+#include "transaction.h"
+#include "utils.h"
+#include "version.h"
+#include "ioctl.h"
+#include "volumes.h"
+#include "print-tree.h"
+#include "disk-io.h"
+
+#include "btrfs_cmds.h"
+
+static int __walk_inode_backref(struct btrfs_root *fs_tree,
+				u64 inode_id, int *nr)
+{
+	struct btrfs_key key;
+	struct btrfs_key found_key;
+	struct extent_buffer *leaf;
+	struct btrfs_path *path;
+	struct btrfs_path *dir_path;
+	struct btrfs_inode_ref *ref;
+	struct btrfs_item *item;
+	int slot;
+	int ret;
+	int iter = *nr;
+
+	path = btrfs_alloc_path();
+	dir_path = btrfs_alloc_path();
+	if (!path || !dir_path) {
+		if (path)
+			btrfs_free_path(path);
+		if (dir_path)
+			btrfs_free_path(dir_path);
+		return -ENOMEM;
+	}
+
+	key.objectid = inode_id;
+	key.type = BTRFS_INODE_REF_KEY;
+	key.offset = 0;
+
+	ret = btrfs_search_slot(NULL, fs_tree, &key, path, 0, 0);
+	if (ret < 0)
+		goto out;
+
+	while (1) {
+		leaf = path->nodes[0];
+		slot = path->slots[0];
+		if (slot >= btrfs_header_nritems(leaf)) {
+			ret = btrfs_next_leaf(fs_tree, path);
+			if (ret != 0)
+				break;
+			leaf = path->nodes[0];
+			slot = path->slots[0];
+		}
+
+		btrfs_item_key_to_cpu(leaf, &found_key, slot);
+		if (found_key.objectid != inode_id ||
+		    found_key.type != BTRFS_INODE_REF_KEY)
+			break;
+
+		/* we've found one */
+		iter++;
+
+		/* show the processing file */
+		printf("\tfile (inode: %llu):\n", found_key.objectid);
+		ref = btrfs_item_ptr(leaf, slot, struct btrfs_inode_ref);
+		item = btrfs_item_nr(leaf, slot);
+		print_inode_ref_item(leaf, item, ref);
+
+		path->slots[0]++;
+
+		/* find the dir via found_key.offset */
+		key.objectid = found_key.offset;
+		key.type = BTRFS_INODE_REF_KEY;
+		key.offset = -1;
+
+		ret = btrfs_search_slot(NULL, fs_tree, &key, dir_path, 0, 0);
+		if (ret < 0) {
+			fprintf(stderr, "\tERROR\n");
+			break;
+		}
+
+		leaf = dir_path->nodes[0];
+		slot = dir_path->slots[0] - 1;
+
+		/* show parent directory */
+		printf("\t|\n");
+		printf("\t`---dir (inode: %llu):\n", found_key.offset);
+		ref = btrfs_item_ptr(leaf, slot, struct btrfs_inode_ref);
+		item = btrfs_item_nr(leaf, slot);
+		print_inode_ref_item(leaf, item, ref);
+		printf("\n");
+
+		btrfs_release_path(fs_tree, dir_path);
+	}
+	btrfs_release_path(fs_tree, path);
+
+	ret = 0;
+out:
+	*nr = iter;
+	btrfs_free_path(path);
+	btrfs_free_path(dir_path);
+	return ret;
+}
+
+int walk_inode_backref_with_snap(struct btrfs_root *root,
+				 u64 inode_id, u64 snap_id)
+{
+	struct btrfs_root *fs_tree;
+	struct btrfs_key key;
+	int nr;
+	int ret;
+
+	if (snap_id != BTRFS_FS_TREE_OBJECTID &&
+	    snap_id < BTRFS_FIRST_FREE_OBJECTID) {
+		fprintf(stderr, "invalid snapshot id\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (snap_id != BTRFS_FS_TREE_OBJECTID) {
+		key.objectid = snap_id;
+		key.offset = -1;
+		btrfs_set_key_type(&key, BTRFS_ROOT_ITEM_KEY);
+
+		fs_tree = btrfs_read_fs_root(root->fs_info, &key);
+
+		if (PTR_ERR(fs_tree) != -ENOENT) {
+			printf("file tree (%llu)\n", snap_id);
+		} else {
+			fprintf(stderr, "snapshot %llu NOT FOUND\n", snap_id);
+			ret = PTR_ERR(fs_tree);
+			goto out;
+		}
+	} else {
+		fs_tree = root->fs_info->fs_root;
+		printf("FS tree\n");
+	}
+
+	ret = __walk_inode_backref(fs_tree, inode_id, &nr);
+
+	if (!nr)
+		fprintf(stderr, "\tfile (inode %llu): NOT FOUND\n\n", inode_id);
+
+out:
+	return ret;
+}
+
+int walk_inode_backref(struct btrfs_root *root, u64 inode_id)
+{
+	struct btrfs_key key;
+	struct btrfs_root *fs_tree;
+	u64 snapshot_id = BTRFS_FIRST_FREE_OBJECTID;
+	int nr = 0;
+	int ret;
+
+	fs_tree = root->fs_info->fs_root;
+	printf("FS tree\n");
+
+again:
+	ret = __walk_inode_backref(fs_tree, inode_id, &nr);
+
+	if (!nr)
+		fprintf(stderr, "\tfile (inode %llu): NOT FOUND\n\n", inode_id);
+	nr = 0;
+
+	if (ret)
+		goto out;
+
+	/* if we have snapshots? */
+	key.objectid = snapshot_id;
+	key.offset = -1;
+	btrfs_set_key_type(&key, BTRFS_ROOT_ITEM_KEY);
+
+	fs_tree = btrfs_read_fs_root(root->fs_info, &key);
+
+	if (PTR_ERR(fs_tree) != -ENOENT) {
+		snapshot_id = fs_tree->root_key.objectid;
+		printf("file tree (%llu)\n", snapshot_id);
+		snapshot_id++;
+
+		goto again;
+	}
+
+out:
+	return 0;
+}
+
+int track_extent_item(struct btrfs_root *root,
+		      struct extent_buffer *eb, int slot)
+{
+	struct btrfs_extent_item *ei;
+	struct btrfs_extent_inline_ref *iref;
+	struct btrfs_extent_data_ref *dref;
+	u32 item_size = btrfs_item_size_nr(eb, slot);
+	unsigned long end;
+	unsigned long ptr;
+	u64 objectid;
+	u64 flags;
+	int type;
+	int ret = 0;
+
+	ei = btrfs_item_ptr(eb, slot, struct btrfs_extent_item);
+	flags = btrfs_extent_flags(eb, ei);
+
+	if (flags & BTRFS_EXTENT_FLAG_DATA)
+		iref = (struct btrfs_extent_inline_ref *)(ei + 1);
+	else
+		goto out;
+
+	ptr = (unsigned long)iref;
+	end = (unsigned long)ei + item_size;
+
+	while (ptr < end) {
+		iref = (struct btrfs_extent_inline_ref *)ptr;
+		type = btrfs_extent_inline_ref_type(eb, iref);
+
+		if (type == BTRFS_EXTENT_DATA_REF_KEY) {
+			dref = (struct btrfs_extent_data_ref *)(&iref->offset);
+			objectid = btrfs_extent_data_ref_objectid(eb, dref);
+			ret = walk_inode_backref(root, objectid);
+			if (ret)
+				goto out;
+		}
+
+		ptr += btrfs_extent_inline_ref_size(type);
+	}
+
+out:
+	return ret;
+}
+
+int walk_extent_backref(struct btrfs_root *root, u64 block)
+{
+	struct btrfs_path *path;
+	struct btrfs_root *extent_tree;
+	struct btrfs_key key;
+	struct btrfs_disk_key disk_key;
+	struct extent_buffer *leaf;
+	struct btrfs_shared_data_ref *sref = NULL;
+	struct btrfs_extent_data_ref *dref = NULL;
+	u64 objectid;
+	int slot;
+	u32 type;
+	int nr = 0;
+	int ret;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	extent_tree = root->fs_info->extent_root;
+	printf("extent tree:\n");
+
+	key.objectid = block;
+	key.type = -1;
+	key.offset = -1;
+
+	ret = btrfs_search_slot(NULL, extent_tree, &key, path, 0, 0);
+	if (ret < 0)
+		goto out;
+
+	BUG_ON(!ret);
+
+again:
+	leaf = path->nodes[0];
+	slot = path->slots[0] - 1;
+	btrfs_item_key(leaf, &disk_key, slot);
+
+	if (disk_key.objectid != block) {
+		if (!nr)
+			fprintf(stderr, "block %llu NOT FOUND\n", block);
+		goto out;
+	}
+
+	nr++;
+
+	printf("\t");
+	btrfs_print_key(&disk_key);
+	printf("\n");
+
+	type = btrfs_disk_key_type(&disk_key);
+	switch (type) {
+	case BTRFS_EXTENT_ITEM_KEY:
+		print_extent_item(leaf, slot);
+		break;
+	case BTRFS_TREE_BLOCK_REF_KEY:
+		printf("\t\ttree block backref\n");
+		break;
+	case BTRFS_SHARED_BLOCK_REF_KEY:
+		printf("\t\tshared block backref\n");
+		break;
+	case BTRFS_EXTENT_DATA_REF_KEY:
+		dref = btrfs_item_ptr(leaf, slot,
+					 struct btrfs_extent_data_ref);
+		printf("\t\textent data backref root %llu "
+			"objectid %llu offset %llu count %u\n",
+			btrfs_extent_data_ref_root(leaf, dref),
+			btrfs_extent_data_ref_objectid(leaf, dref),
+			btrfs_extent_data_ref_offset(leaf, dref),
+			btrfs_extent_data_ref_count(leaf, dref));
+		break;
+	case BTRFS_SHARED_DATA_REF_KEY:
+		sref = btrfs_item_ptr(leaf, slot,
+				      struct btrfs_shared_data_ref);
+		printf("\t\tshared data backref count %u\n",
+		       btrfs_shared_data_ref_count(leaf, sref));
+		break;
+	default:
+		fprintf(stderr, "NOT A EXTENT BACKREF\n");
+	}
+
+	printf("\n");
+
+	switch (type) {
+	case BTRFS_EXTENT_ITEM_KEY:
+		ret = track_extent_item(root, leaf, slot);
+		if (ret)
+			goto out;
+		break;
+	case BTRFS_EXTENT_DATA_REF_KEY:
+		objectid = btrfs_extent_data_ref_objectid(leaf, dref);
+		ret = walk_inode_backref(root, objectid);
+		if (ret)
+			goto out;
+		break;
+	}
+
+	path->slots[0]++;
+	printf("\n");
+	goto again;
+
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
+int main(int argc, char **argv)
+{
+	struct btrfs_root *root;
+	u64 block_number = 0;
+	u64 inode_id = 0;
+	u64 snap_id = 0;
+	int block_fl = 0;
+	int inode_fl = 0;
+	int snap_fl = 0;
+	int ret = 0;
+
+	optind = 1;
+	while (1) {
+		int c;
+		c = getopt(argc, argv, "b:i:s:");
+		if (c < 0)
+			break;
+
+		switch (c) {
+		case 'b':
+			block_number = atoll(optarg);
+			block_fl = 1;
+			break;
+		case 'i':
+			inode_id = atoll(optarg);
+			inode_fl = 1;
+			break;
+		case 's':
+			snap_id = atoll(optarg);
+			snap_fl = 1;
+			break;
+		default:
+			fprintf(stderr, "Invalid arguments for backref "
+				"walking utilities\n");
+			return 1;
+		}
+	}
+
+	argc = argc - optind;
+	if (argc != 1) {
+		fprintf(stderr, "Invalid arguments!\n");
+		return 1;
+	}
+
+	root = open_ctree(argv[optind], 0, 0);
+	if (!root) {
+		fprintf(stderr, "unable to open %s\n", argv[optind]);
+		return 1;
+	}
+
+	if (block_fl)
+		ret = walk_extent_backref(root, block_number);
+	else if (snap_fl && inode_fl)
+		ret = walk_inode_backref_with_snap(root, inode_id, snap_id);
+	else if (inode_fl)
+		ret = walk_inode_backref(root, inode_id);
+
+	if (ret)
+		printf("ERROR %d\n", ret);
+
+	printf("%s\n", BTRFS_BUILD_VERSION);
+
+	return 0;
+}
-- 
1.6.5.2

