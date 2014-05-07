Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42246 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120AbaEGUH3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 May 2014 16:07:29 -0400
From: Mark Fasheh <mfasheh@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: Josef Bacik <jbacik@fb.com>, Chris Mason <clm@fb.com>,
        Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 3/3] btrfs-progs: add quota group verify code
Date: Wed,  7 May 2014 13:07:17 -0700
Message-Id: <1399493237-19740-4-git-send-email-mfasheh@suse.de>
In-Reply-To: <1399493237-19740-1-git-send-email-mfasheh@suse.de>
References: <1399493237-19740-1-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch adds functionality (in qgroup-verify.c) to compute bytecounts in
subvolume quota groups. The original groups are read in and stored in memory
so that after we compute our own bytecounts, we can compare them with those
on disk. A print function is provided to do this comparison and show the
results on the console.

A 'qgroup check' pass is added to btrfsck. If any subvolume quota groups
differ from what we compute, the differences for them are printed.  We also
provide an option '--qgroup-report' which will run only the quota check code
and print a report on all quota groups.  Other than making it possible to
verify that our qgroup changes work correctly, this mode can also be used in
xfstests for automated checking after qgroup tests.

This patch does not address the following:
- compressed counts are identical to non compressed, because kernel doesn't
  make the distinction yet.  Adding the code to verify compressed counts
  shouldn't be hard at all though once kernel can do this.
- It is only concerned with subvolume quota groups (like most of
  btrfs-progs).

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 Makefile        |    2 +-
 cmds-check.c    |   24 ++
 ctree.h         |   10 +
 disk-io.c       |   16 +-
 print-tree.c    |    2 +-
 print-tree.h    |    1 +
 qgroup-verify.c | 1085 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 qgroup-verify.h |   25 ++
 8 files changed, 1161 insertions(+), 4 deletions(-)
 create mode 100644 qgroup-verify.c
 create mode 100644 qgroup-verify.h

diff --git a/Makefile b/Makefile
index 202013e..51e5264 100644
--- a/Makefile
+++ b/Makefile
@@ -10,7 +10,7 @@ objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
 	  root-tree.o dir-item.o file-item.o inode-item.o inode-map.o \
 	  extent-cache.o extent_io.o volumes.o utils.o repair.o \
 	  qgroup.o raid6.o free-space-cache.o list_sort.o props.o \
-	  ulist.o
+	  ulist.o qgroup-verify.o
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
 	       cmds-quota.o cmds-qgroup.o cmds-replace.o cmds-check.o \
diff --git a/cmds-check.c b/cmds-check.c
index d195e7a..5401ad9 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -38,6 +38,7 @@
 #include "commands.h"
 #include "free-space-cache.h"
 #include "btrfsck.h"
+#include "qgroup-verify.h"
 
 static u64 bytes_used = 0;
 static u64 total_csum_bytes = 0;
@@ -6427,6 +6428,7 @@ static struct option long_options[] = {
 	{ "init-csum-tree", 0, NULL, 0 },
 	{ "init-extent-tree", 0, NULL, 0 },
 	{ "backup", 0, NULL, 0 },
+	{ "qgroup-report", 0, NULL, 'Q' },
 	{ NULL, 0, NULL, 0}
 };
 
@@ -6439,6 +6441,7 @@ const char * const cmd_check_usage[] = {
 	"--repair                    try to repair the filesystem",
 	"--init-csum-tree            create a new CRC tree",
 	"--init-extent-tree          create a new extent tree",
+	"--qgroup-report             print a report on qgroup consistency",
 	NULL
 };
 
@@ -6453,6 +6456,7 @@ int cmd_check(int argc, char **argv)
 	u64 num;
 	int option_index = 0;
 	int init_csum_tree = 0;
+	int qgroup_report = 0;
 	enum btrfs_open_ctree_flags ctree_flags =
 		OPEN_CTREE_PARTIAL | OPEN_CTREE_EXCLUSIVE;
 
@@ -6479,6 +6483,9 @@ int cmd_check(int argc, char **argv)
 				printf("using SB copy %llu, bytenr %llu\n", num,
 				       (unsigned long long)bytenr);
 				break;
+			case 'Q':
+				qgroup_report = 1;
+				break;
 			case '?':
 			case 'h':
 				usage(cmd_check_usage);
@@ -6526,6 +6533,14 @@ int cmd_check(int argc, char **argv)
 
 	root = info->fs_root;
 	uuid_unparse(info->super_copy->fsid, uuidbuf);
+	if (qgroup_report) {
+		printf("Print quota groups for %s\nUUID: %s\n", argv[optind],
+		       uuidbuf);
+		ret = qgroup_verify_all(info);
+		if (ret == 0)
+			print_qgroup_report(1);
+		goto close_out;
+	}
 	printf("Checking filesystem on %s\nUUID: %s\n", argv[optind], uuidbuf);
 
 	if (!extent_buffer_uptodate(info->tree_root->node) ||
@@ -6629,11 +6644,20 @@ int cmd_check(int argc, char **argv)
 		free(bad);
 	}
 
+	if (info->quota_enabled) {
+		int err;
+		fprintf(stderr, "checking quota groups\n");
+		err = qgroup_verify_all(info);
+		if (err)
+			goto out;
+	}
+
 	if (!list_empty(&root->fs_info->recow_ebs)) {
 		fprintf(stderr, "Transid errors in file system\n");
 		ret = 1;
 	}
 out:
+	print_qgroup_report(0);
 	if (found_old_backref) { /*
 		 * there was a disk format change when mixed
 		 * backref was in testing tree. The old format
diff --git a/ctree.h b/ctree.h
index a4d2cd1..9489338 100644
--- a/ctree.h
+++ b/ctree.h
@@ -943,6 +943,7 @@ struct btrfs_fs_info {
 	struct btrfs_root *chunk_root;
 	struct btrfs_root *dev_root;
 	struct btrfs_root *csum_root;
+	struct btrfs_root *quota_root;
 
 	struct rb_root fs_root_tree;
 
@@ -988,6 +989,7 @@ struct btrfs_fs_info {
 	unsigned int readonly:1;
 	unsigned int on_restoring:1;
 	unsigned int is_chunk_recover:1;
+	unsigned int quota_enabled:1;
 
 	int (*free_extent_hook)(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
@@ -2382,4 +2384,12 @@ int btrfs_csum_truncate(struct btrfs_trans_handle *trans,
 int btrfs_lookup_uuid_subvol_item(int fd, const u8 *uuid, u64 *subvol_id);
 int btrfs_lookup_uuid_received_subvol_item(int fd, const u8 *uuid,
 					   u64 *subvol_id);
+
+static inline int is_fstree(u64 rootid)
+{
+	if (rootid == BTRFS_FS_TREE_OBJECTID ||
+	    (signed long long)rootid >= (signed long long)BTRFS_FIRST_FREE_OBJECTID)
+		return 1;
+	return 0;
+}
 #endif
diff --git a/disk-io.c b/disk-io.c
index 19b95a7..09efa31 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -569,7 +569,6 @@ static int find_and_setup_log_root(struct btrfs_root *tree_root,
 	return 0;
 }
 
-
 int btrfs_free_fs_root(struct btrfs_root *root)
 {
 	if (root->node)
@@ -695,6 +694,8 @@ struct btrfs_root *btrfs_read_fs_root(struct btrfs_fs_info *fs_info,
 		return fs_info->dev_root;
 	if (location->objectid == BTRFS_CSUM_TREE_OBJECTID)
 		return fs_info->csum_root;
+	if (location->objectid == BTRFS_QUOTA_TREE_OBJECTID)
+		return fs_info->csum_root;
 
 	BUG_ON(location->objectid == BTRFS_TREE_RELOC_OBJECTID ||
 	       location->offset != (u64)-1);
@@ -721,6 +722,7 @@ void btrfs_free_fs_info(struct btrfs_fs_info *fs_info)
 	free(fs_info->chunk_root);
 	free(fs_info->dev_root);
 	free(fs_info->csum_root);
+	free(fs_info->quota_root);
 	free(fs_info->super_copy);
 	free(fs_info->log_root_tree);
 	free(fs_info);
@@ -741,11 +743,13 @@ struct btrfs_fs_info *btrfs_new_fs_info(int writable, u64 sb_bytenr)
 	fs_info->chunk_root = malloc(sizeof(struct btrfs_root));
 	fs_info->dev_root = malloc(sizeof(struct btrfs_root));
 	fs_info->csum_root = malloc(sizeof(struct btrfs_root));
+	fs_info->quota_root = malloc(sizeof(struct btrfs_root));
 	fs_info->super_copy = malloc(BTRFS_SUPER_INFO_SIZE);
 
 	if (!fs_info->tree_root || !fs_info->extent_root ||
 	    !fs_info->chunk_root || !fs_info->dev_root ||
-	    !fs_info->csum_root || !fs_info->super_copy)
+	    !fs_info->csum_root || !fs_info->quota_root ||
+	    !fs_info->super_copy)
 		goto free_all;
 
 	memset(fs_info->super_copy, 0, BTRFS_SUPER_INFO_SIZE);
@@ -754,6 +758,7 @@ struct btrfs_fs_info *btrfs_new_fs_info(int writable, u64 sb_bytenr)
 	memset(fs_info->chunk_root, 0, sizeof(struct btrfs_root));
 	memset(fs_info->dev_root, 0, sizeof(struct btrfs_root));
 	memset(fs_info->csum_root, 0, sizeof(struct btrfs_root));
+	memset(fs_info->quota_root, 0, sizeof(struct btrfs_root));
 
 	extent_io_tree_init(&fs_info->extent_cache);
 	extent_io_tree_init(&fs_info->free_space_cache);
@@ -912,6 +917,11 @@ int btrfs_setup_all_roots(struct btrfs_fs_info *fs_info, u64 root_tree_bytenr,
 	}
 	fs_info->csum_root->track_dirty = 1;
 
+	ret = find_and_setup_root(root, fs_info, BTRFS_QUOTA_TREE_OBJECTID,
+				  fs_info->quota_root);
+	if (ret == 0)
+		fs_info->quota_enabled = 1;
+
 	ret = find_and_setup_log_root(root, fs_info, sb);
 	if (ret) {
 		printk("Couldn't setup log root tree\n");
@@ -936,6 +946,8 @@ int btrfs_setup_all_roots(struct btrfs_fs_info *fs_info, u64 root_tree_bytenr,
 
 void btrfs_release_all_roots(struct btrfs_fs_info *fs_info)
 {
+	if (fs_info->quota_root)
+		free_extent_buffer(fs_info->quota_root->node);
 	if (fs_info->csum_root)
 		free_extent_buffer(fs_info->csum_root->node);
 	if (fs_info->dev_root)
diff --git a/print-tree.c b/print-tree.c
index adef94a..d96bf52 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -242,7 +242,7 @@ static void print_file_extent_item(struct extent_buffer *eb,
 	       btrfs_file_extent_compression(eb, fi));
 }
 
-static void print_extent_item(struct extent_buffer *eb, int slot, int metadata)
+void print_extent_item(struct extent_buffer *eb, int slot, int metadata)
 {
 	struct btrfs_extent_item *ei;
 	struct btrfs_extent_inline_ref *iref;
diff --git a/print-tree.h b/print-tree.h
index 495b81a..e364fdf 100644
--- a/print-tree.h
+++ b/print-tree.h
@@ -21,4 +21,5 @@
 void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l);
 void btrfs_print_tree(struct btrfs_root *root, struct extent_buffer *t, int follow);
 void btrfs_print_key(struct btrfs_disk_key *disk_key);
+void print_extent_item(struct extent_buffer *eb, int slot, int metadata);
 #endif
diff --git a/qgroup-verify.c b/qgroup-verify.c
new file mode 100644
index 0000000..f7692f9
--- /dev/null
+++ b/qgroup-verify.c
@@ -0,0 +1,1085 @@
+/*
+ * Copyright (C) 2014 SUSE.  All rights reserved.
+ *
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
+ *
+ * Authors: Mark Fasheh <mfasheh@suse.de>
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <uuid/uuid.h>
+#include "kerncompat.h"
+#include "radix-tree.h"
+#include "ctree.h"
+#include "disk-io.h"
+#include "print-tree.h"
+#include "utils.h"
+#include "ulist.h"
+
+#include "qgroup-verify.h"
+
+/*#define QGROUP_VERIFY_DEBUG*/
+static unsigned long tot_extents_scanned = 0;
+
+static void add_bytes(u64 root_objectid, u64 num_bytes, int exclusive);
+
+struct qgroup_count {
+	u64				qgroupid;
+
+	struct btrfs_disk_key		key;
+	struct btrfs_qgroup_info_item	diskinfo;
+
+	struct btrfs_qgroup_info_item	info;
+
+	struct rb_node			rb_node;
+};
+
+struct counts_tree {
+	struct rb_root		root;
+	unsigned int		num_groups;
+} counts = { .root = RB_ROOT };
+
+struct rb_root by_bytenr = RB_ROOT;
+
+/*
+ * List of interior tree blocks. We walk this list after loading the
+ * extent tree to resolve implied refs. For each interior node we'll
+ * place a shared ref in the ref tree against each child object. This
+ * allows the shared ref resolving code to do the actual work later of
+ * finding roots to account against.
+ *
+ * An implied ref is when a tree block has refs on it that may not
+ * exist in any of it's child nodes. Even though the refs might not
+ * exist further down the tree, the fact that our interior node has a
+ * ref means we need to account anything below it to all it's roots.
+ */
+struct ulist *tree_blocks = NULL;	/* unode->val = bytenr, ->aux
+					 * = tree_block pointer */
+struct tree_block {
+	int			level;
+	u64			num_bytes;
+};
+
+struct ref {
+	u64			bytenr;
+	u64			num_bytes;
+	u64			parent;
+	u64			root;
+
+	struct rb_node		bytenr_node;
+};
+
+#ifdef QGROUP_VERIFY_DEBUG
+static void print_ref(struct ref *ref)
+{
+	printf("bytenr: %llu\t\tnum_bytes: %llu\t\t parent: %llu\t\t"
+	       "root: %llu\n", ref->bytenr, ref->num_bytes,
+	       ref->parent, ref->root);
+}
+
+static void print_all_refs(void)
+{
+	unsigned long count = 0;
+	struct ref *ref;
+	struct rb_node *node;
+
+	node = rb_first(&by_bytenr);
+	while (node) {
+		ref = rb_entry(node, struct ref, bytenr_node);
+
+		print_ref(ref);
+
+		count++;
+		node = rb_next(node);
+	}
+
+	printf("%lu extents scanned with %lu refs in total.\n",
+	       tot_extents_scanned, count);
+}
+#endif
+
+/*
+ * Store by bytenr in rbtree
+ *
+ * The tree is sorted in ascending order by bytenr, then parent, then
+ * root. Since full refs have a parent == 0, those will come before
+ * shared refs.
+ */
+static int compare_ref(struct ref *orig, u64 bytenr, u64 root, u64 parent)
+{
+	if (bytenr < orig->bytenr)
+		return -1;
+	if (bytenr > orig->bytenr)
+		return 1;
+
+	if (parent < orig->parent)
+		return -1;
+	if (parent > orig->parent)
+		return 1;
+
+	if (root < orig->root)
+		return -1;
+	if (root > orig->root)
+		return 1;
+
+	return 0;
+}
+
+/*
+ * insert a new ref into the tree.  returns the existing ref entry
+ * if one is already there.
+ */
+static struct ref *insert_ref(struct ref *ref)
+{
+	int ret;
+	struct rb_node **p = &by_bytenr.rb_node;
+	struct rb_node *parent = NULL;
+	struct ref *curr;
+
+	while (*p) {
+		parent = *p;
+		curr = rb_entry(parent, struct ref, bytenr_node);
+
+		ret = compare_ref(curr, ref->bytenr, ref->root, ref->parent);
+		if (ret < 0)
+			p = &(*p)->rb_left;
+		else if (ret > 0)
+			p = &(*p)->rb_right;
+		else
+			return curr;
+	}
+
+	rb_link_node(&ref->bytenr_node, parent, p);
+	rb_insert_color(&ref->bytenr_node, &by_bytenr);
+	return ref;
+}
+
+/*
+ * Partial search, returns the first ref with matching bytenr. Caller
+ * can walk forward from there.
+ *
+ * Leftmost refs will be full refs - this is used to our advantage
+ * when resolving roots.
+ */
+static struct ref *find_ref_bytenr(u64 bytenr)
+{
+	struct rb_node *n = by_bytenr.rb_node;
+	struct ref *ref;
+
+	while (n) {
+		ref = rb_entry(n, struct ref, bytenr_node);
+
+		if (bytenr < ref->bytenr)
+			n = n->rb_left;
+		else if (bytenr > ref->bytenr)
+			n = n->rb_right;
+		else {
+			/* Walk to the left to find the first item */
+			struct rb_node *node_left = rb_prev(&ref->bytenr_node);
+			struct ref *ref_left;
+
+			while (node_left) {
+				ref_left = rb_entry(node_left, struct ref,
+						    bytenr_node);
+				if (ref_left->bytenr != ref->bytenr)
+					break;
+				ref = ref_left;
+				node_left = rb_prev(node_left);
+			}
+			return ref;
+		}
+	}
+	return NULL;
+}
+
+static struct ref *find_ref(u64 bytenr, u64 root, u64 parent)
+{
+	struct rb_node *n = by_bytenr.rb_node;
+	struct ref *ref;
+	int ret;
+
+	while (n) {
+		ref = rb_entry(n, struct ref, bytenr_node);
+
+		ret = compare_ref(ref, bytenr, root, parent);
+		if (ret < 0)
+			n = n->rb_left;
+		else if (ret > 0)
+			n = n->rb_right;
+		else
+			return ref;
+	}
+	return NULL;
+}
+
+static struct ref *alloc_ref(u64 bytenr, u64 root, u64 parent, u64 num_bytes)
+{
+	struct ref *ref = find_ref(bytenr, root, parent);
+
+	BUG_ON(parent && root);
+
+	if (ref == NULL) {
+		ref = calloc(1, sizeof(*ref));
+		if (ref) {
+			ref->bytenr = bytenr;
+			ref->root = root;
+			ref->parent = parent;
+			ref->num_bytes = num_bytes;
+
+			insert_ref(ref);
+		}
+	}
+	return ref;
+}
+
+static void free_ref_node(struct rb_node *node)
+{
+	struct ref *ref = rb_entry(node, struct ref, bytenr_node);
+	free(ref);
+}
+
+FREE_RB_BASED_TREE(ref, free_ref_node);
+
+/*
+ * Resolves all the possible roots for the ref at parent.
+ */
+static void find_parent_roots(struct ulist *roots, u64 parent)
+{
+	struct ref *ref;
+	struct rb_node *node;
+
+	/*
+	 * Search the rbtree for the first ref with bytenr == parent.
+	 * Walk forward so long as bytenr == parent, adding resolved root ids.
+	 * For each unresolved root, we recurse
+	 */
+	ref = find_ref_bytenr(parent);
+	node = &ref->bytenr_node;
+	BUG_ON(ref == NULL);
+	BUG_ON(ref->bytenr != parent);
+
+	{
+		/*
+		 * Random sanity check, are we actually getting the
+		 * leftmost node?
+		 */
+		struct rb_node *prev_node = rb_prev(&ref->bytenr_node);
+		struct ref *prev;
+		if (prev_node) {
+			prev = rb_entry(prev_node, struct ref, bytenr_node);
+			BUG_ON(prev->bytenr == parent);
+		}
+	}
+
+	do {
+		if (ref->root)
+			ulist_add(roots, ref->root, 0, 0);
+		else
+			find_parent_roots(roots, ref->parent);
+
+		node = rb_next(node);
+		if (node)
+			ref = rb_entry(node, struct ref, bytenr_node);
+	} while (node && ref->bytenr == parent);
+}
+
+/*
+ * Account each ref. Walk the refs, for each set of refs in a
+ * given bytenr:
+ *
+ * - add the roots for direct refs to the ref roots ulist
+ *
+ * - resolve all possible roots for shared refs, insert each
+ *   of those into ref_roots ulist (this is a recursive process)
+ *
+ * - Walk ref_roots ulist, adding extent bytes to each qgroup count that
+ *    cooresponds to a found root.
+ */
+static void account_all_refs(void)
+{
+	int exclusive;
+	struct ref *ref;
+	struct rb_node *node;
+	u64 bytenr, num_bytes;
+	struct ulist *roots = ulist_alloc(0);
+	struct ulist_iterator uiter;
+	struct ulist_node *unode;
+
+	node = rb_first(&by_bytenr);
+	while (node) {
+		ulist_reinit(roots);
+
+		ref = rb_entry(node, struct ref, bytenr_node);
+		/*
+		 * Walk forward through the list of refs for this
+		 * bytenr, adding roots to our ulist. If it's a full
+		 * ref, then we have the easy case. Otherwise we need
+		 * to search for roots.
+		 */
+		bytenr = ref->bytenr;
+		num_bytes = ref->num_bytes;
+		do {
+			BUG_ON(ref->bytenr != bytenr);
+			BUG_ON(ref->num_bytes != num_bytes);
+			if (ref->root)
+				ulist_add(roots, ref->root, 0, 0);
+			else
+				find_parent_roots(roots, ref->parent);
+
+			/*
+			 * When we leave this inner loop, node is set
+			 * to next in our tree and will be turned into
+			 * a ref object up top
+			 */
+			node = rb_next(node);
+			if (node)
+				ref = rb_entry(node, struct ref, bytenr_node);
+		} while (node && ref->bytenr == bytenr);
+
+		/*
+		 * Now that we have all roots, we can properly account
+		 * this extent against the corresponding qgroups.
+		 */
+		if (roots->nnodes == 1)
+			exclusive = 1;
+		else
+			exclusive = 0;
+
+		ULIST_ITER_INIT(&uiter);
+		while ((unode = ulist_next(roots, &uiter))) {
+			BUG_ON(unode->val == 0ULL);
+			/* We only want to account fs trees */
+			if (is_fstree(unode->val))
+				add_bytes(unode->val, num_bytes, exclusive);
+		}
+	}
+
+	ulist_free(roots);
+}
+
+static u64 resolve_one_root(u64 bytenr)
+{
+	struct ref *ref = find_ref_bytenr(bytenr);
+
+	BUG_ON(ref == NULL);
+
+	if (ref->root)
+		return ref->root;
+	return resolve_one_root(ref->parent);
+}
+
+static inline struct tree_block *unode_tree_block(struct ulist_node *unode)
+{
+	return (struct tree_block *)unode->aux;
+}
+static inline u64 unode_bytenr(struct ulist_node *unode)
+{
+	return unode->val;
+}
+
+static int alloc_tree_block(u64 bytenr, u64 num_bytes, int level)
+{
+	struct tree_block *block = calloc(1, sizeof(*block));
+
+	if (block) {
+		block->num_bytes = num_bytes;
+		block->level = level;
+		if (ulist_add(tree_blocks, bytenr, (unsigned long long)block, 0) >= 0)
+			return 0;
+		free(block);
+	}
+	return -ENOMEM;
+}
+
+static void free_tree_blocks(void)
+{
+	struct ulist_iterator uiter;
+	struct ulist_node *unode;
+
+	if (!tree_blocks)
+		return;
+
+	ULIST_ITER_INIT(&uiter);
+	while ((unode = ulist_next(tree_blocks, &uiter)))
+		free(unode_tree_block(unode));
+	ulist_free(tree_blocks);	
+	tree_blocks = NULL;
+}
+
+#ifdef QGROUP_VERIFY_DEBUG
+static void print_tree_block(u64 bytenr, struct tree_block *block)
+{
+	struct ref *ref;
+	struct rb_node *node;
+
+	printf("tree block: %llu\t\tlevel: %d\n", (unsigned long long)bytenr,
+	       block->level);
+
+	ref = find_ref_bytenr(bytenr);
+	node = &ref->bytenr_node;
+	do {
+		print_ref(ref);
+		node = rb_next(node);
+		if (node)
+			ref = rb_entry(node, struct ref, bytenr_node);
+	} while (node && ref->bytenr == bytenr);
+
+	printf("\n");
+}
+
+static void print_all_tree_blocks(void)
+{
+	struct ulist_iterator uiter;
+	struct ulist_node *unode;
+
+	if (!tree_blocks)
+		return;
+
+	printf("Listing all found interior tree nodes:\n");
+
+	ULIST_ITER_INIT(&uiter);
+	while ((unode = ulist_next(tree_blocks, &uiter)))
+		print_tree_block(unode_bytenr(unode), unode_tree_block(unode));
+}
+#endif
+
+static int add_refs_for_leaf_items(struct extent_buffer *eb, u64 ref_parent)
+{
+	int nr, i;
+	int extent_type;
+	u64 bytenr, num_bytes;
+	struct btrfs_key key;
+	struct btrfs_disk_key disk_key;
+	struct btrfs_file_extent_item *fi;
+
+	nr = btrfs_header_nritems(eb);
+	for (i = 0; i < nr; i++) {
+		btrfs_item_key(eb, &disk_key, i);
+		btrfs_disk_key_to_cpu(&key, &disk_key);
+
+		if (key.type != BTRFS_EXTENT_DATA_KEY)
+			continue;
+
+		fi = btrfs_item_ptr(eb, i, struct btrfs_file_extent_item);
+		/* filter out: inline, disk_bytenr == 0, compressed?
+		 * not if we can avoid it */
+		extent_type = btrfs_file_extent_type(eb, fi);
+
+		if (extent_type == BTRFS_FILE_EXTENT_INLINE)
+			continue;
+
+		bytenr = btrfs_file_extent_disk_bytenr(eb, fi);
+		if (!bytenr)
+			continue;
+
+		num_bytes = btrfs_file_extent_disk_num_bytes(eb, fi);
+		if (alloc_ref(bytenr, 0, ref_parent, num_bytes) == NULL)
+			return ENOMEM;
+	}
+
+	return 0;
+}
+
+static int travel_tree(struct btrfs_fs_info *info, struct btrfs_root *root,
+		       u64 bytenr, u64 num_bytes, u64 ref_parent)
+{
+	int ret, nr, i;
+	struct extent_buffer *eb;
+	u64 new_bytenr;
+	u64 new_num_bytes;
+
+//	printf("travel_tree: bytenr: %llu\tnum_bytes: %llu\tref_parent: %llu\n",
+//	       bytenr, num_bytes, ref_parent);
+
+	eb = read_tree_block(root, bytenr, num_bytes, 0);
+	if (!eb)
+		return -EIO;
+
+	ret = 0;
+	/* Don't add a ref for our starting tree block to itself */
+	if (bytenr != ref_parent) {
+		if (alloc_ref(bytenr, 0, ref_parent, num_bytes) == NULL)
+			return ENOMEM;
+	}
+
+	if (btrfs_is_leaf(eb)) {
+		ret = add_refs_for_leaf_items(eb, ref_parent);
+		goto out;
+	}
+
+	/*
+	 * Interior nodes are tuples of (key, bytenr) where key is the
+	 * leftmost key in the tree block pointed to by bytenr. We
+	 * don't have to care about key here, just follow the bytenr
+	 * pointer.
+	 */
+	nr = btrfs_header_nritems(eb);
+	for (i = 0; i < nr; i++) {
+		new_bytenr = btrfs_node_blockptr(eb, i);
+		new_num_bytes = btrfs_level_size(root,
+						 btrfs_header_level(eb) - 1);
+
+		ret = travel_tree(info, root, new_bytenr, new_num_bytes,
+				  ref_parent);
+	}
+
+out:
+	free_extent_buffer(eb);
+	return ret;
+}
+
+static int add_refs_for_implied(struct btrfs_fs_info *info, u64 bytenr,
+				struct tree_block *block)
+{
+	int ret;
+	u64 root_bytenr = resolve_one_root(bytenr);
+	struct btrfs_root *root;
+	struct btrfs_key key;
+
+	key.objectid = root_bytenr;
+	key.type = BTRFS_ROOT_ITEM_KEY;
+	key.offset = (u64)-1;
+
+	/*
+	 * XXX: Don't free the root object as we don't know whether it
+	 * came off our fs_info struct or not.
+	 */
+	root = btrfs_read_fs_root(info, &key);
+	if (!root || IS_ERR(root))
+		return ENOENT;
+
+	ret = travel_tree(info, root, bytenr, block->num_bytes, bytenr);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+/*
+ * Place shared refs in the ref tree for each child of an interior tree node.
+ */
+static int map_implied_refs(struct btrfs_fs_info *info)
+{
+	int ret = 0;
+	struct ulist_iterator uiter;
+	struct ulist_node *unode;
+
+	ULIST_ITER_INIT(&uiter);
+	while ((unode = ulist_next(tree_blocks, &uiter))) {
+		ret = add_refs_for_implied(info, unode_bytenr(unode),
+					   unode_tree_block(unode));
+		if (ret)
+			goto out;
+	}
+out:
+	return ret;
+}
+
+/*
+ * insert a new root into the tree.  returns the existing root entry
+ * if one is already there.  qgroupid is used
+ * as the key
+ */
+static int insert_count(struct qgroup_count *qc)
+{
+	struct rb_node **p = &counts.root.rb_node;
+	struct rb_node *parent = NULL;
+	struct qgroup_count *curr;
+
+	while (*p) {
+		parent = *p;
+		curr = rb_entry(parent, struct qgroup_count, rb_node);
+
+		if (qc->qgroupid < curr->qgroupid)
+			p = &(*p)->rb_left;
+		else if (qc->qgroupid > curr->qgroupid)
+			p = &(*p)->rb_right;
+		else
+			return EEXIST;
+	}
+	counts.num_groups++;
+	rb_link_node(&qc->rb_node, parent, p);
+	rb_insert_color(&qc->rb_node, &counts.root);
+	return 0;
+}
+
+static struct qgroup_count *find_count(u64 qgroupid)
+{
+	struct rb_node *n = counts.root.rb_node;
+	struct qgroup_count *count;
+
+	while (n) {
+		count = rb_entry(n, struct qgroup_count, rb_node);
+
+		if (qgroupid < count->qgroupid)
+			n = n->rb_left;
+		else if (qgroupid > count->qgroupid)
+			n = n->rb_right;
+		else
+			return count;
+	}
+	return NULL;
+}
+
+static struct qgroup_count *alloc_count(struct btrfs_disk_key *key,
+					struct extent_buffer *leaf,
+					struct btrfs_qgroup_info_item *disk)
+{
+	struct qgroup_count *c = calloc(1, sizeof(*c));
+	struct btrfs_qgroup_info_item *item;
+
+	if (c) {
+		c->qgroupid = btrfs_disk_key_offset(key);
+		c->key = *key;
+
+		item = &c->diskinfo;
+		item->generation = btrfs_qgroup_info_generation(leaf, disk);
+		item->referenced = btrfs_qgroup_info_referenced(leaf, disk);
+		item->referenced_compressed =
+			btrfs_qgroup_info_referenced_compressed(leaf, disk);
+		item->exclusive = btrfs_qgroup_info_exclusive(leaf, disk);
+		item->exclusive_compressed =
+			btrfs_qgroup_info_exclusive_compressed(leaf, disk);
+
+		if (insert_count(c)) {
+			free(c);
+			c = NULL;
+		}
+	}
+	return c;
+}
+
+static void add_bytes(u64 root_objectid, u64 num_bytes, int exclusive)
+{
+	struct qgroup_count *count = find_count(root_objectid);
+	struct btrfs_qgroup_info_item *qg;
+
+	BUG_ON(num_bytes < 4096); /* Random sanity check. */
+
+	if (!count)
+		return;
+
+	qg = &count->info;
+
+	qg->referenced += num_bytes;
+	/*
+	 * count of compressed bytes is unimplemented, so we do the
+	 * same as kernel.
+	 */
+	qg->referenced_compressed += num_bytes;
+
+	if (exclusive) {
+		qg->exclusive += num_bytes;
+		qg->exclusive_compressed += num_bytes;
+	}
+}
+
+static int load_quota_info(struct btrfs_fs_info *info)
+{
+	int ret;
+	struct btrfs_root *root = info->quota_root;
+	struct btrfs_path path;
+	struct btrfs_key key;
+	struct btrfs_disk_key disk_key;
+	struct extent_buffer *leaf;
+	struct btrfs_qgroup_info_item *item;
+	struct qgroup_count *count;
+	int i, nr;
+
+	btrfs_init_path(&path);
+
+	key.offset = 0;
+	key.objectid = 0;
+	key.type = 0;
+
+	ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
+	if (ret < 0) {
+		fprintf(stderr, "ERROR: Couldn't search slot: %d\n", ret);
+		goto out;
+	}
+
+	while (1) {
+		leaf = path.nodes[0];
+
+		nr = btrfs_header_nritems(leaf);
+		for(i = 0; i < nr; i++) {
+			btrfs_item_key(leaf, &disk_key, i);
+			btrfs_disk_key_to_cpu(&key, &disk_key);
+
+			if (key.type == BTRFS_QGROUP_RELATION_KEY)
+				printf("Ignoring qgroup relation key %llu\n",
+				       key.objectid);
+
+			/*
+			 * Ignore: BTRFS_QGROUP_STATUS_KEY,
+			 * BTRFS_QGROUP_LIMIT_KEY, BTRFS_QGROUP_RELATION_KEY
+			 */
+			if (key.type != BTRFS_QGROUP_INFO_KEY)
+				continue;
+
+			item = btrfs_item_ptr(leaf, i,
+					      struct btrfs_qgroup_info_item);
+
+			count = alloc_count(&disk_key, leaf, item);
+			if (!count) {
+				ret = ENOMEM;
+				fprintf(stderr, "ERROR: out of memory\n");
+				goto out;
+			}
+		}
+
+		ret = btrfs_next_leaf(root, &path);
+		if (ret != 0)
+			break;
+	}
+
+	ret = 0;
+	btrfs_release_path(&path);
+out:
+	return ret;
+}
+
+static int add_inline_refs(struct btrfs_fs_info *info,
+			   struct extent_buffer *ei_leaf, int slot,
+			   u64 bytenr, u64 num_bytes, int meta_item)
+{
+	struct btrfs_extent_item *ei;
+	struct btrfs_extent_inline_ref *iref;
+	struct btrfs_extent_data_ref *dref;
+	u64 flags, root_obj, offset, parent;
+	u32 item_size = btrfs_item_size_nr(ei_leaf, slot);
+	int type;
+	unsigned long end;
+	unsigned long ptr;
+
+	ei = btrfs_item_ptr(ei_leaf, slot, struct btrfs_extent_item);
+	flags = btrfs_extent_flags(ei_leaf, ei);
+
+	if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK && !meta_item) {
+		struct btrfs_tree_block_info *tbinfo;
+		tbinfo = (struct btrfs_tree_block_info *)(ei + 1);
+		iref = (struct btrfs_extent_inline_ref *)(tbinfo + 1);
+	} else {
+		iref = (struct btrfs_extent_inline_ref *)(ei + 1);
+	}
+
+	ptr = (unsigned long)iref;
+	end = (unsigned long)ei + item_size;
+	while (ptr < end) {
+		iref = (struct btrfs_extent_inline_ref *)ptr;
+
+		parent = root_obj = 0;
+		offset = btrfs_extent_inline_ref_offset(ei_leaf, iref);
+		type = btrfs_extent_inline_ref_type(ei_leaf, iref);
+		switch (type) {
+		case BTRFS_TREE_BLOCK_REF_KEY:
+			root_obj = offset;
+			break;
+		case BTRFS_EXTENT_DATA_REF_KEY:
+			dref = (struct btrfs_extent_data_ref *)(&iref->offset);
+			root_obj = btrfs_extent_data_ref_root(ei_leaf, dref);
+			break;
+		case BTRFS_SHARED_DATA_REF_KEY:
+		case BTRFS_SHARED_BLOCK_REF_KEY:
+			parent = offset;
+			break;
+		default:
+			return 1;
+		}
+
+		if (alloc_ref(bytenr, root_obj, parent, num_bytes) == NULL)
+			return ENOMEM;
+
+		ptr += btrfs_extent_inline_ref_size(type);
+	}
+
+	return 0;
+}
+
+static int add_keyed_ref(struct btrfs_fs_info *info,
+			 struct btrfs_key *key,
+			 struct extent_buffer *leaf, int slot,
+			 u64 bytenr, u64 num_bytes)
+{
+	u64 root_obj = 0, parent = 0;
+	struct btrfs_extent_data_ref *dref;
+
+	switch(key->type) {
+	case BTRFS_TREE_BLOCK_REF_KEY:
+		root_obj = key->offset;
+		break;
+	case BTRFS_EXTENT_DATA_REF_KEY:
+		dref = btrfs_item_ptr(leaf, slot, struct btrfs_extent_data_ref);
+		root_obj = btrfs_extent_data_ref_root(leaf, dref);
+		break;
+	case BTRFS_SHARED_DATA_REF_KEY:
+	case BTRFS_SHARED_BLOCK_REF_KEY:
+		parent = key->offset;
+		break;
+	default:
+		return 1;
+	}
+
+	if (alloc_ref(bytenr, root_obj, parent, num_bytes) == NULL)
+		return ENOMEM;
+
+	return 0;
+}
+
+/*
+ * return value of 0 indicates leaf or not meta data. The code that
+ * calls this does not need to make a distinction between the two as
+ * it is only concerned with intermediate blocks which will always
+ * have level > 0.
+ */
+static int get_tree_block_level(struct btrfs_key *key,
+				struct extent_buffer *ei_leaf,
+				int slot)
+{
+	int level = 0;
+	int meta_key = key->type == BTRFS_METADATA_ITEM_KEY;
+	u64 flags;
+	struct btrfs_extent_item *ei;
+
+	ei = btrfs_item_ptr(ei_leaf, slot, struct btrfs_extent_item);
+	flags = btrfs_extent_flags(ei_leaf, ei);
+
+	if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK && !meta_key) {
+		struct btrfs_tree_block_info *tbinfo;
+		tbinfo = (struct btrfs_tree_block_info *)(ei + 1);
+		level = btrfs_tree_block_level(ei_leaf, tbinfo);
+	} else if (meta_key) {
+		/* skinny metadata */
+		level = (int)key->offset;
+	}
+	return level;
+}
+
+/*
+ * Walk the extent tree, allocating a ref item for every ref and
+ * storing it in the bytenr tree.
+ */
+static int scan_extents(struct btrfs_fs_info *info,
+			u64 start, u64 end)
+{
+	int ret, i, nr, level;
+	struct btrfs_root *root = info->extent_root;
+	struct btrfs_key key;
+	struct btrfs_path path;
+	struct btrfs_disk_key disk_key;
+	struct extent_buffer *leaf;
+	u64 bytenr = 0, num_bytes = 0;
+
+	btrfs_init_path(&path);
+
+	key.objectid = start;
+	key.type = 0;
+	key.offset = 0;
+
+	ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
+	if (ret < 0) {
+		fprintf(stderr, "ERROR: Couldn't search slot: %d\n", ret);
+		goto out;
+	}
+	path.reada = 1;
+
+	while (1) {
+		leaf = path.nodes[0];
+
+		nr = btrfs_header_nritems(leaf);
+		for(i = 0; i < nr; i++) {
+			btrfs_item_key(leaf, &disk_key, i);
+			btrfs_disk_key_to_cpu(&key, &disk_key);
+
+			if (key.objectid < start)
+				continue;
+
+			if (key.objectid > end)
+				goto done;
+
+			if (key.type == BTRFS_EXTENT_ITEM_KEY ||
+			    key.type == BTRFS_METADATA_ITEM_KEY) {
+				int meta = 0;
+
+				tot_extents_scanned++;
+
+				bytenr = key.objectid;
+				num_bytes = key.offset;
+				if (key.type == BTRFS_METADATA_ITEM_KEY) {
+					num_bytes = info->extent_root->leafsize;
+					meta = 1;
+				}
+
+				ret = add_inline_refs(info, leaf, i, bytenr,
+						      num_bytes, meta);
+				if (ret)
+					goto out;
+
+				level = get_tree_block_level(&key, leaf, i);
+				if (level) {
+					if (alloc_tree_block(bytenr, num_bytes,
+							     level))
+						return ENOMEM;
+				}
+
+				continue;
+			}
+
+			if (key.type > BTRFS_SHARED_DATA_REF_KEY)
+				continue;
+			if (key.type < BTRFS_TREE_BLOCK_REF_KEY)
+				continue;
+
+			/*
+			 * Keyed refs should come after their extent
+			 * item in the tree. As a result, the value of
+			 * bytenr and num_bytes should be unchanged
+			 * from the above block that catches the
+			 * original extent item.
+			 */
+			BUG_ON(key.objectid != bytenr);
+
+			ret = add_keyed_ref(info, &key, leaf, i, bytenr,
+					    num_bytes);
+			if (ret)
+				goto out;
+		}
+
+		ret = btrfs_next_leaf(root, &path);
+		if (ret != 0) {
+			if (ret < 0) {
+				fprintf(stderr,
+					"ERROR: Next leaf failed: %d\n", ret);
+				goto out;
+			}
+			break;
+		}
+	}
+done:
+	ret = 0;
+out:
+	btrfs_release_path(&path);
+
+	return ret;
+}
+
+static void print_fields(u64 bytes, u64 bytes_compressed, char *prefix,
+			 char *type)
+{
+	printf("%s\t\t%s %llu %s compressed %llu\n",
+	       prefix, type, (unsigned long long)bytes, type,
+	       (unsigned long long)bytes_compressed);
+}
+
+static void print_fields_signed(long long bytes,
+				long long bytes_compressed,
+				char *prefix, char *type)
+{
+	printf("%s\t\t%s %lld %s compressed %lld\n",
+	       prefix, type, bytes, type, bytes_compressed);
+}
+
+static void print_qgroup_difference(struct qgroup_count *count, int verbose)
+{
+	int is_different;
+	struct btrfs_qgroup_info_item *info = &count->info;
+	struct btrfs_qgroup_info_item *disk = &count->diskinfo;
+	long long excl_diff = info->exclusive - disk->exclusive;
+	long long ref_diff = info->referenced - disk->referenced;
+
+	is_different = excl_diff || ref_diff;
+
+	if (verbose || is_different) {
+		printf("Counts for qgroup id: %llu %s\n",
+		       (unsigned long long)count->qgroupid,
+		       is_different ? "are different" : "");
+
+		print_fields(info->referenced, info->referenced_compressed,
+			     "our:", "referenced");
+		print_fields(disk->referenced, disk->referenced_compressed,
+			     "disk:", "referenced");
+		if (ref_diff)
+			print_fields_signed(ref_diff, ref_diff,
+					    "diff:", "referenced");
+		print_fields(info->exclusive, info->exclusive_compressed,
+			     "our:", "exclusive");
+		print_fields(disk->exclusive, disk->exclusive_compressed,
+			     "disk:", "exclusive");
+		if (excl_diff)
+			print_fields_signed(excl_diff, excl_diff,
+					    "diff:", "exclusive");
+	}
+}
+
+void print_qgroup_report(int all)
+{
+	struct rb_node *node;
+	struct qgroup_count *c;
+
+	node = rb_first(&counts.root);
+	while (node) {
+		c = rb_entry(node, struct qgroup_count, rb_node);
+		print_qgroup_difference(c, all);
+		node = rb_next(node);
+	}
+}
+
+int qgroup_verify_all(struct btrfs_fs_info *info)
+{
+	int ret;
+
+	if (!info->quota_enabled)
+		return 0;
+
+	tree_blocks = ulist_alloc(0);
+	if (!tree_blocks) {
+		fprintf(stderr,
+			"ERROR: Out of memory while allocating ulist.\n");
+		return ENOMEM;
+	}
+
+	ret = load_quota_info(info);
+	if (ret) {
+		fprintf(stderr, "ERROR: Loading qgroups from disk: %d\n", ret);
+		goto out;
+	}
+
+	/*
+	 * Put all extent refs into our rbtree
+	 */
+	ret = scan_extents(info, 0, ~0ULL);
+	if (ret) {
+		fprintf(stderr, "ERROR: while scanning extent tree: %d\n", ret);
+		goto out;
+	}
+
+	ret = map_implied_refs(info);
+	if (ret) {
+		fprintf(stderr, "ERROR: while mapping refs: %d\n", ret);
+		goto out;
+	}
+
+	account_all_refs();
+
+out:
+	/*
+	 * Don't free the qgroup count records as they will be walked
+	 * later via the print function.
+	 */
+	free_tree_blocks();
+	free_ref_tree(&by_bytenr);
+	return ret;
+}
diff --git a/qgroup-verify.h b/qgroup-verify.h
new file mode 100644
index 0000000..a222c17
--- /dev/null
+++ b/qgroup-verify.h
@@ -0,0 +1,25 @@
+/*
+ * Copyright (C) 2014 SUSE.  All rights reserved.
+ *
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
+#ifndef _BTRFS_QGROUP_VERIFY_H
+#define _BTRFS_QGROUP_VERIFY_H
+
+int qgroup_verify_all(struct btrfs_fs_info *info);
+void print_qgroup_report(int all);
+
+#endif	/* _BTRFS_QGROUP_VERIFY_H */
-- 
1.8.4

