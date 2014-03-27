Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56789 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757138AbaC0Xm4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Mar 2014 19:42:56 -0400
Received: from pps.filterd (m0004060 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s2RNbKBJ030637
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Mar 2014 16:42:55 -0700
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0b-00082601.pphosted.com with ESMTP id 1jvwfc8271-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Mar 2014 16:42:55 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: add a extent ref verify tool
Date: Thu, 27 Mar 2014 19:42:51 -0400
Message-ID: <1395963771-2349-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We were having corruption issues that were tied back to problems with the extent
tree.  In order to track them down I built this tool to try and find the
culprit, which was pretty successful.  If you compile with this tool on it will
live verify every ref update that the fs makes and make sure it is consistent
and valid.  This should only be used with a clean file system to start with and
then have the tests run as it doesn't lookup the actual shared refs on mount, so
it will get snapshots and things wrong.  This could be fixed in the future
easily, I just didn't need it for my particular test.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/Kconfig       |  10 +
 fs/btrfs/Makefile      |   1 +
 fs/btrfs/ctree.c       |   2 +-
 fs/btrfs/ctree.h       |   7 +
 fs/btrfs/disk-io.c     |  14 +-
 fs/btrfs/extent-tree.c |  16 +
 fs/btrfs/ref-verify.c  | 892 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/ref-verify.h  |  34 ++
 fs/btrfs/relocation.c  |   1 +
 9 files changed, 975 insertions(+), 2 deletions(-)
 create mode 100644 fs/btrfs/ref-verify.c
 create mode 100644 fs/btrfs/ref-verify.h

diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
index a66768e..1dfd411 100644
--- a/fs/btrfs/Kconfig
+++ b/fs/btrfs/Kconfig
@@ -88,3 +88,13 @@ config BTRFS_ASSERT
 	  any of the assertions trip.  This is meant for btrfs developers only.
 
 	  If unsure, say N.
+
+config BTRFS_FS_REF_VERIFY
+	bool "Btrfs with the ref verify tool compiled in"
+	depends on BTRFS_FS
+	help
+	  Enable run-time extent reference verification instrumentation.  This
+	  is meant to be used by btrfs developers for tracking down extent
+	  reference problems or verifying they didn't break something.
+
+	  If unsure, say N.
diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
index f341a98..ae837d2 100644
--- a/fs/btrfs/Makefile
+++ b/fs/btrfs/Makefile
@@ -13,6 +13,7 @@ btrfs-y += super.o ctree.o extent-tree.o print-tree.o root-tree.o dir-item.o \
 
 btrfs-$(CONFIG_BTRFS_FS_POSIX_ACL) += acl.o
 btrfs-$(CONFIG_BTRFS_FS_CHECK_INTEGRITY) += check-integrity.o
+btrfs-$(CONFIG_BTRFS_FS_REF_VERIFY) += ref-verify.o
 
 btrfs-$(CONFIG_BTRFS_FS_RUN_SANITY_TESTS) += tests/free-space-tests.o \
 	tests/extent-buffer-tests.o tests/btrfs-tests.o \
diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 9d89c16..71bbafe 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -202,7 +202,7 @@ struct extent_buffer *btrfs_lock_root_node(struct btrfs_root *root)
  * tree until you end up with a lock on the root.  A locked buffer
  * is returned, with a reference held.
  */
-static struct extent_buffer *btrfs_read_lock_root_node(struct btrfs_root *root)
+struct extent_buffer *btrfs_read_lock_root_node(struct btrfs_root *root)
 {
 	struct extent_buffer *eb;
 
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 4253ab2..2277006 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1680,6 +1680,12 @@ struct btrfs_fs_info {
 
 	struct semaphore uuid_tree_rescan_sem;
 	unsigned int update_uuid_tree_gen:1;
+
+#ifdef CONFIG_BTRFS_FS_REF_VERIFY
+	spinlock_t ref_verify_lock;
+	struct rb_root block_tree;
+	bool ref_verify_enabled;
+#endif
 };
 
 struct btrfs_subvolume_writers {
@@ -3379,6 +3385,7 @@ void btrfs_set_item_key_safe(struct btrfs_root *root, struct btrfs_path *path,
 			     struct btrfs_key *new_key);
 struct extent_buffer *btrfs_root_node(struct btrfs_root *root);
 struct extent_buffer *btrfs_lock_root_node(struct btrfs_root *root);
+struct extent_buffer *btrfs_read_lock_root_node(struct btrfs_root *root);
 int btrfs_find_next_key(struct btrfs_root *root, struct btrfs_path *path,
 			struct btrfs_key *key, int lowest_level,
 			u64 min_trans);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index a152a96..02ae4d1 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -49,6 +49,7 @@
 #include "dev-replace.h"
 #include "raid56.h"
 #include "sysfs.h"
+#include "ref-verify.h"
 
 #ifdef CONFIG_X86
 #include <asm/cpufeature.h>
@@ -2268,6 +2269,11 @@ int open_ctree(struct super_block *sb,
 #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
 	fs_info->check_integrity_print_mask = 0;
 #endif
+#ifdef CONFIG_BTRFS_FS_REF_VERIFY
+	spin_lock_init(&fs_info->ref_verify_lock);
+	fs_info->block_tree = RB_ROOT;
+	fs_info->ref_verify_enabled = true;
+#endif
 
 	spin_lock_init(&fs_info->balance_lock);
 	mutex_init(&fs_info->balance_mutex);
@@ -2895,7 +2901,12 @@ retry_root_backup:
 
 	if (sb->s_flags & MS_RDONLY)
 		return 0;
-
+#ifdef CONFIG_BTRFS_FS_REF_VERIFY
+	if (btrfs_build_ref_tree(fs_info)) {
+		fs_info->ref_verify_enabled = false;
+		printk(KERN_ERR "BTRFS: couldn't build ref tree\n");
+	}
+#endif
 	down_read(&fs_info->cleanup_work_sem);
 	if ((ret = btrfs_orphan_cleanup(fs_info->fs_root)) ||
 	    (ret = btrfs_orphan_cleanup(fs_info->tree_root))) {
@@ -3639,6 +3650,7 @@ int close_ctree(struct btrfs_root *root)
 	cleanup_srcu_struct(&fs_info->subvol_srcu);
 
 	btrfs_free_stripe_hash_table(fs_info);
+	btrfs_free_ref_cache(fs_info);
 
 	btrfs_free_block_rsv(root, root->orphan_block_rsv);
 	root->orphan_block_rsv = NULL;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index c69cb24..af5a656 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -36,6 +36,7 @@
 #include "free-space-cache.h"
 #include "math.h"
 #include "sysfs.h"
+#include "ref-verify.h"
 
 #undef SCRAMBLE_DELAYED_REFS
 
@@ -1953,6 +1954,9 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 	BUG_ON(owner < BTRFS_FIRST_FREE_OBJECTID &&
 	       root_objectid == BTRFS_TREE_LOG_OBJECTID);
 
+	btrfs_ref_tree_mod(root, bytenr, num_bytes, parent, root_objectid,
+			   owner, offset, BTRFS_ADD_DELAYED_REF);
+
 	if (owner < BTRFS_FIRST_FREE_OBJECTID) {
 		ret = btrfs_add_delayed_tree_ref(fs_info, trans, bytenr,
 					num_bytes,
@@ -5955,6 +5959,9 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 	int ret;
 
 	if (root->root_key.objectid != BTRFS_TREE_LOG_OBJECTID) {
+		btrfs_ref_tree_mod(root, buf->start, buf->len, parent,
+				   root->objectid, btrfs_header_level(buf),
+				   0, BTRFS_DROP_DELAYED_REF);
 		ret = btrfs_add_delayed_tree_ref(root->fs_info, trans,
 					buf->start, buf->len,
 					parent, root->root_key.objectid,
@@ -6011,6 +6018,9 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 
 	add_pinned_bytes(root->fs_info, num_bytes, owner, root_objectid);
 
+	btrfs_ref_tree_mod(root, bytenr, num_bytes, parent, root_objectid,
+			   owner, offset, BTRFS_DROP_DELAYED_REF);
+
 	/*
 	 * tree log blocks never actually go into the extent allocation
 	 * tree, just update pinning info and exit early.
@@ -6827,6 +6837,9 @@ int btrfs_alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
 
 	BUG_ON(root_objectid == BTRFS_TREE_LOG_OBJECTID);
 
+	btrfs_ref_tree_mod(root, ins->objectid, ins->offset, 0, root_objectid,
+			   owner, offset, BTRFS_ADD_DELAYED_EXTENT);
+
 	ret = btrfs_add_delayed_data_ref(root->fs_info, trans, ins->objectid,
 					 ins->offset, 0,
 					 root_objectid, owner, offset,
@@ -7029,6 +7042,9 @@ struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
 		extent_op->is_data = 0;
 		extent_op->level = level;
 
+		btrfs_ref_tree_mod(root, ins.objectid, ins.offset, parent,
+				   root_objectid, level, 0,
+				   BTRFS_ADD_DELAYED_EXTENT);
 		ret = btrfs_add_delayed_tree_ref(root->fs_info, trans,
 					ins.objectid,
 					ins.offset, parent, root_objectid,
diff --git a/fs/btrfs/ref-verify.c b/fs/btrfs/ref-verify.c
new file mode 100644
index 0000000..3f75181
--- /dev/null
+++ b/fs/btrfs/ref-verify.c
@@ -0,0 +1,892 @@
+/*
+ * Copyright (C) 2014 Facebook.  All rights reserved.
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
+#include <linux/sched.h>
+#include <linux/stacktrace.h>
+#include "ctree.h"
+#include "disk-io.h"
+#include "locking.h"
+#include "delayed-ref.h"
+#include "ref-verify.h"
+
+/*
+ * Used to keep track the roots and number of refs each root has for a given
+ * bytenr.  This just tracks the number of direct references, no shared
+ * references.
+ */
+struct root_entry {
+	u64 root_objectid;
+	u64 num_refs;
+	struct rb_node node;
+};
+
+/*
+ * These are meant to represent what should exist in the extent tree, these can
+ * be used to verify the extent tree is consistent as these should all match
+ * what the extent tree says.
+ */
+struct ref_entry {
+	u64 root_objectid;
+	u64 parent;
+	u64 owner;
+	u64 offset;
+	u64 num_refs;
+	struct rb_node node;
+};
+
+#define MAX_TRACE	16
+
+/*
+ * Whenever we add/remove a reference we record the action.  The action maps
+ * back to the delayed ref action.  We hold the ref we are changing in the
+ * action so we can account for the history properly, and we record the root we
+ * were called with since it could be different from ref_root.  We also store
+ * stack traces because thats how I roll.
+ */
+struct ref_action {
+	int action;
+	u64 root;
+	struct ref_entry ref;
+	struct list_head list;
+	unsigned long trace[MAX_TRACE];
+	unsigned int trace_len;
+};
+
+/*
+ * One of these for every block we reference, it holds the roots and references
+ * to it as well as all of the ref actions that have occured to it.  We never
+ * free it until we unmount the file system in order to make sure re-allocations
+ * are happening properly.
+ */
+struct block_entry {
+	u64 bytenr;
+	u64 len;
+	u64 num_refs;
+	int metadata;
+	struct rb_root roots;
+	struct rb_root refs;
+	struct rb_node node;
+	struct list_head actions;
+};
+
+static struct block_entry *insert_block_entry(struct rb_root *root,
+					      struct block_entry *be)
+{
+	struct rb_node **p = &root->rb_node;
+	struct rb_node *parent_node = NULL;
+	struct block_entry *entry;
+
+	while (*p) {
+		parent_node = *p;
+		entry = rb_entry(parent_node, struct block_entry, node);
+		if (entry->bytenr > be->bytenr)
+			p = &(*p)->rb_left;
+		else if (entry->bytenr < be->bytenr)
+			p = &(*p)->rb_right;
+		else
+			return entry;
+	}
+
+	rb_link_node(&be->node, parent_node, p);
+	rb_insert_color(&be->node, root);
+	return NULL;
+}
+
+static struct block_entry *lookup_block_entry(struct rb_root *root, u64 bytenr)
+{
+	struct rb_node *n;
+	struct block_entry *entry = NULL;
+
+	n = root->rb_node;
+	while (n) {
+		entry = rb_entry(n, struct block_entry, node);
+		if (entry->bytenr < bytenr)
+			n = n->rb_right;
+		else if (entry->bytenr > bytenr)
+			n = n->rb_left;
+		else
+			return entry;
+	}
+	return NULL;
+}
+
+static struct root_entry *insert_root_entry(struct rb_root *root,
+					    struct root_entry *re)
+{
+	struct rb_node **p = &root->rb_node;
+	struct rb_node *parent_node = NULL;
+	struct root_entry *entry;
+
+	while (*p) {
+		parent_node = *p;
+		entry = rb_entry(parent_node, struct root_entry, node);
+		if (entry->root_objectid > re->root_objectid)
+			p = &(*p)->rb_left;
+		else if (entry->root_objectid < re->root_objectid)
+			p = &(*p)->rb_right;
+		else
+			return entry;
+	}
+
+	rb_link_node(&re->node, parent_node, p);
+	rb_insert_color(&re->node, root);
+	return NULL;
+
+}
+
+static int comp_refs(struct ref_entry *ref1, struct ref_entry *ref2)
+{
+	if (ref1->root_objectid < ref2->root_objectid)
+		return -1;
+	if (ref1->root_objectid > ref2->root_objectid)
+		return 1;
+	if (ref1->parent < ref2->parent)
+		return -1;
+	if (ref1->parent > ref2->parent)
+		return 1;
+	if (ref1->owner < ref2->owner)
+		return -1;
+	if (ref1->owner > ref2->owner)
+		return 1;
+	if (ref1->offset < ref2->offset)
+		return -1;
+	if (ref1->offset > ref2->offset)
+		return 1;
+	return 0;
+}
+
+static struct ref_entry *insert_ref_entry(struct rb_root *root,
+					  struct ref_entry *ref)
+{
+	struct rb_node **p = &root->rb_node;
+	struct rb_node *parent_node = NULL;
+	struct ref_entry *entry;
+	int cmp;
+
+	while (*p) {
+		parent_node = *p;
+		entry = rb_entry(parent_node, struct ref_entry, node);
+		cmp = comp_refs(entry, ref);
+		if (cmp > 0)
+			p = &(*p)->rb_left;
+		else if (cmp < 0)
+			p = &(*p)->rb_right;
+		else
+			return entry;
+	}
+
+	rb_link_node(&ref->node, parent_node, p);
+	rb_insert_color(&ref->node, root);
+	return NULL;
+
+}
+
+static struct root_entry *lookup_root_entry(struct rb_root *root, u64 objectid)
+{
+	struct rb_node *n;
+	struct root_entry *entry = NULL;
+
+	n = root->rb_node;
+	while (n) {
+		entry = rb_entry(n, struct root_entry, node);
+		if (entry->root_objectid < objectid)
+			n = n->rb_right;
+		else if (entry->root_objectid > objectid)
+			n = n->rb_left;
+		else
+			return entry;
+	}
+	return NULL;
+}
+
+static void update_block_entry(struct btrfs_root *root, struct block_entry *be,
+			       struct root_entry *re)
+{
+	struct root_entry *exist;
+
+	exist = insert_root_entry(&be->roots, re);
+	if (exist) {
+		kfree(re);
+		re = exist;
+	}
+	re->num_refs++;
+	be->num_refs++;
+}
+
+static void __save_stack_trace(struct ref_action *ra)
+{
+	struct stack_trace stack_trace;
+
+	stack_trace.max_entries = MAX_TRACE;
+	stack_trace.nr_entries = 0;
+	stack_trace.entries = ra->trace;
+	stack_trace.skip = 2;
+	save_stack_trace(&stack_trace);
+	ra->trace_len = stack_trace.nr_entries;
+}
+
+static void free_block_entry(struct block_entry *be)
+{
+	struct root_entry *re;
+	struct ref_entry *ref;
+	struct ref_action *ra;
+	struct rb_node *n;
+
+	while ((n = rb_first(&be->roots))) {
+		re = rb_entry(n, struct root_entry, node);
+		rb_erase(&re->node, &be->roots);
+		kfree(re);
+	}
+
+	while((n = rb_first(&be->refs))) {
+		ref = rb_entry(n, struct ref_entry, node);
+		rb_erase(&ref->node, &be->refs);
+		kfree(ref);
+	}
+
+	while (!list_empty(&be->actions)) {
+		ra = list_first_entry(&be->actions, struct ref_action,
+				      list);
+		list_del(&ra->list);
+		kfree(ra);
+	}
+	kfree(be);
+}
+
+static struct block_entry *add_block_entry(struct btrfs_root *root, u64 bytenr,
+					   u64 len, u64 root_objectid)
+{
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct block_entry *be = NULL, *exist;
+	struct root_entry *re = NULL;
+
+	re = kmalloc(sizeof(struct root_entry), GFP_NOFS);
+	be = kmalloc(sizeof(struct block_entry), GFP_NOFS);
+	if (!be || !re) {
+		kfree(re);
+		kfree(be);
+		return ERR_PTR(-ENOMEM);
+	}
+	be->bytenr = bytenr;
+	be->len = len;
+
+	re->root_objectid = root_objectid;
+	re->num_refs = 0;
+
+	spin_lock(&fs_info->ref_verify_lock);
+	exist = insert_block_entry(&fs_info->block_tree, be);
+	if (exist) {
+		update_block_entry(root, exist, re);
+		kfree(be);
+		be = exist;
+		goto out;
+	}
+
+	be->num_refs = 1;
+	be->metadata = 0;
+	be->roots = RB_ROOT;
+	be->refs = RB_ROOT;
+	INIT_LIST_HEAD(&be->actions);
+	if (insert_root_entry(&be->roots, re)) {
+		kfree(re);
+		kfree(be);
+		rb_erase(&be->node, &fs_info->block_tree);
+		be = ERR_PTR(-EINVAL);
+		ASSERT(0);
+	}
+out:
+	spin_unlock(&fs_info->ref_verify_lock);
+	return be;
+}
+
+static int add_tree_block(struct btrfs_root *root, struct btrfs_path *path,
+			  int level)
+{
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct block_entry *be;
+	struct root_entry *re;
+	struct ref_entry *ref = NULL, *exist;
+	struct ref_action *ra;
+	struct extent_buffer *eb, *parent = NULL;
+
+	eb = path->nodes[level];
+	if (level < BTRFS_MAX_LEVEL - 1)
+		parent = path->nodes[level+1];
+
+	ref = kmalloc(sizeof(struct ref_entry), GFP_NOFS);
+	if (!ref)
+		return -ENOMEM;
+
+	ra = kmalloc(sizeof(struct ref_action), GFP_NOFS);
+	if (!ra) {
+		kfree(ref);
+		return -ENOMEM;
+	}
+
+	ref->root_objectid = root->objectid;
+	ref->parent = 0;
+	ref->owner = level;
+	ref->offset = 0;
+	ref->num_refs = 1;
+
+	/*
+	 * Action is tied to the delayed ref actions, so just use
+	 * UPDATE_DELAYED_HEAD to indicate we got this during a scan.
+	 */
+	ra->action = BTRFS_UPDATE_DELAYED_HEAD;
+	ra->root = root->objectid;
+	memcpy(&ra->ref, ref, sizeof(struct ref_entry));
+	__save_stack_trace(ra);
+	INIT_LIST_HEAD(&ra->list);
+
+	be = add_block_entry(root, eb->start, eb->len, root->objectid);
+	if (IS_ERR(be)) {
+		kfree(ref);
+		kfree(ra);
+		return PTR_ERR(be);
+	}
+
+	spin_lock(&fs_info->ref_verify_lock);
+	be->metadata = 1;
+	re = lookup_root_entry(&be->roots, root->objectid);
+	ASSERT(re);
+	re->num_refs++;
+	exist = insert_ref_entry(&be->refs, ref);
+	if (exist) {
+		exist->num_refs++;
+		kfree(ref);
+	}
+	list_add_tail(&ra->list, &be->actions);
+	spin_unlock(&fs_info->ref_verify_lock);
+
+	return 0;
+}
+
+static int process_leaf(struct btrfs_root *root, struct btrfs_path *path)
+{
+	struct extent_buffer *leaf = path->nodes[0];
+	struct btrfs_file_extent_item *fi;
+	struct block_entry *be;
+	struct ref_entry *ref = NULL, *exist;
+	struct root_entry *re;
+	struct ref_action *ra;
+	u64 bytenr, num_bytes, offset;
+	struct btrfs_key key;
+	int i = 0;
+	int nritems = btrfs_header_nritems(leaf);
+	u8 type;
+	bool implied = false;
+
+	if (path->nodes[1]) {
+		if (btrfs_header_owner(leaf) != root->objectid &&
+		    btrfs_header_owner(path->nodes[1]) != root->objectid)
+			implied = true;
+	}
+
+	for (i = 0; i < nritems; i++) {
+		btrfs_item_key_to_cpu(leaf, &key, i);
+		if (key.type != BTRFS_EXTENT_DATA_KEY)
+			continue;
+		fi = btrfs_item_ptr(leaf, i, struct btrfs_file_extent_item);
+		type = btrfs_file_extent_type(leaf, fi);
+		if (type == BTRFS_FILE_EXTENT_INLINE)
+			continue;
+		ASSERT(type == BTRFS_FILE_EXTENT_REG ||
+		       type == BTRFS_FILE_EXTENT_PREALLOC);
+		bytenr = btrfs_file_extent_disk_bytenr(leaf, fi);
+		if (bytenr == 0)
+			continue;
+		num_bytes = btrfs_file_extent_disk_num_bytes(leaf, fi);
+		offset = key.offset - btrfs_file_extent_offset(leaf, fi);
+
+		be = add_block_entry(root, bytenr, num_bytes, root->objectid);
+		if (IS_ERR(be))
+			return PTR_ERR(be);
+		ref = kmalloc(sizeof(struct ref_entry), GFP_NOFS);
+		if (!ref)
+			return -ENOMEM;
+		ra = kmalloc(sizeof(struct ref_action), GFP_NOFS);
+		if (!ra) {
+			kfree(ref);
+			return -ENOMEM;
+		}
+
+		ref->root_objectid = root->objectid;
+		ref->parent = 0;
+		ref->owner = key.objectid;
+		ref->offset = key.offset -
+			btrfs_file_extent_offset(leaf, fi);
+		ref->num_refs = 1;
+
+		ra->action = BTRFS_UPDATE_DELAYED_HEAD;
+		ra->root = root->objectid;
+		memcpy(&ra->ref, ref, sizeof(struct ref_entry));
+		__save_stack_trace(ra);
+		INIT_LIST_HEAD(&ra->list);
+
+		spin_lock(&root->fs_info->ref_verify_lock);
+		re = lookup_root_entry(&be->roots, root->objectid);
+		ASSERT(re);
+		re->num_refs++;
+
+		exist = insert_ref_entry(&be->refs, ref);
+		if (exist) {
+			kfree(ref);
+			exist->num_refs++;
+		}
+		list_add_tail(&ra->list, &be->actions);
+		spin_unlock(&root->fs_info->ref_verify_lock);
+	}
+
+	return 0;
+}
+
+/* Walk down to the leaf from the given level */
+static int walk_down_tree(struct btrfs_root *root, struct btrfs_path *path,
+			  int level)
+{
+	struct extent_buffer *eb;
+	u64 bytenr, gen;
+	int ret = 0;
+
+	while (level >= 0) {
+		if (btrfs_header_owner(path->nodes[level]) != root->objectid)
+			break;
+		if (level) {
+			bytenr = btrfs_node_blockptr(path->nodes[level],
+						     path->slots[level]);
+			gen = btrfs_node_ptr_generation(path->nodes[level],
+							path->slots[level]);
+			eb = read_tree_block(root, bytenr, root->leafsize,
+					     gen);
+			if (!eb || !extent_buffer_uptodate(eb)) {
+				free_extent_buffer(eb);
+				return -EIO;
+			}
+			btrfs_tree_read_lock(eb);
+			btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
+			path->nodes[level-1] = eb;
+			path->slots[level-1] = 0;
+			path->locks[level-1] = BTRFS_READ_LOCK_BLOCKING;
+
+			ret = add_tree_block(root, path, level-1);
+			if (ret)
+				break;
+		} else if (root->ref_cows ||
+			   root == root->fs_info->tree_root) {
+			ret = process_leaf(root, path);
+		}
+		level--;
+	}
+	return ret;
+}
+
+/* Walk up to the next node that needs to be processed */
+static int walk_up_tree(struct btrfs_root *root, struct btrfs_path *path,
+			int *level)
+{
+	int l = 0;
+
+	while (l < BTRFS_MAX_LEVEL) {
+		if (!path->nodes[l]) {
+			l++;
+			continue;
+		}
+		if (!l)
+			goto drop;
+		path->slots[l]++;
+		if (path->slots[l] < btrfs_header_nritems(path->nodes[l])) {
+			*level = l;
+			return 0;
+		}
+drop:
+		btrfs_tree_unlock_rw(path->nodes[l], path->locks[l]);
+		free_extent_buffer(path->nodes[l]);
+		path->nodes[l] = NULL;
+		path->slots[l] = 0;
+		path->locks[l] = 0;
+		l++;
+	}
+
+	return 1;
+}
+
+static int build_ref_tree_for_root(struct btrfs_root *root)
+{
+	struct btrfs_path *path;
+	struct extent_buffer *eb;
+	int level;
+	int ret = 0;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	eb = btrfs_read_lock_root_node(root);
+	btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
+	level = btrfs_header_level(eb);
+	path->nodes[level] = eb;
+	path->slots[level] = 0;
+	path->locks[level] = BTRFS_READ_LOCK_BLOCKING;
+
+	ret = add_tree_block(root, path, level);
+	if (ret) {
+		btrfs_free_path(path);
+		return ret;
+	}
+
+	while (1) {
+		ret = walk_down_tree(root, path, level);
+		if (ret)
+			break;
+		ret = walk_up_tree(root, path, &level);
+		if (ret < 0)
+			break;
+		if (ret > 0) {
+			ret = 0;
+			break;
+		}
+	}
+	if (ret)
+		btrfs_free_ref_cache(root->fs_info);
+	btrfs_free_path(path);
+	return ret;
+}
+
+static void dump_ref_action(struct ref_action *ra)
+{
+	struct stack_trace trace;
+
+	printk(KERN_ERR "  Ref action %d, root %llu, ref_root %llu, parent "
+	       "%llu, owner %llu, offset %llu, num_refs %llu\n",
+	       ra->action, ra->root, ra->ref.root_objectid, ra->ref.parent,
+	       ra->ref.owner, ra->ref.offset, ra->ref.num_refs);
+	trace.nr_entries = ra->trace_len;
+	trace.entries = ra->trace;
+	print_stack_trace(&trace, 2);
+}
+
+/*
+ * Dumps all the information from the block entry to printk, it's going to be
+ * awesome.
+ */
+static void dump_block_entry(struct block_entry *be)
+{
+	struct ref_entry *ref;
+	struct root_entry *re;
+	struct ref_action *ra;
+	struct rb_node *n;
+
+	printk(KERN_ERR "Dumping block entry [%llu %llu], num_refs %llu, "
+	       "metadata %d\n", be->bytenr, be->len, be->num_refs,
+	       be->metadata);
+
+	for (n = rb_first(&be->refs); n; n = rb_next(n)) {
+		ref = rb_entry(n, struct ref_entry, node);
+		printk(KERN_ERR "  Ref root %llu, parent %llu, owner %llu, "
+		       "offset %llu, num_refs %llu\n", ref->root_objectid,
+		       ref->parent, ref->owner, ref->offset, ref->num_refs);
+	}
+
+	for (n = rb_first(&be->roots); n; n = rb_next(n)) {
+		re = rb_entry(n, struct root_entry, node);
+		printk(KERN_ERR "  Root entry %llu, num_refs %llu\n",
+		       re->root_objectid, re->num_refs);
+	}
+
+	list_for_each_entry(ra, &be->actions, list)
+		dump_ref_action(ra);
+}
+
+/*
+ * btrfs_ref_tree_mod: called when we modify a ref for a bytenr
+ * @root: the root we are making this modification from.
+ * @bytenr: the bytenr we are modifying.
+ * @num_bytes: number of bytes.
+ * @parent: the parent bytenr.
+ * @ref_root: the original root owner of the bytenr.
+ * @owner: level in the case of metadata, inode in the case of data.
+ * @offset: 0 for metadata, file offset for data.
+ * @action: the action that we are doing, this is the same as the delayed ref
+ *	action.
+ *
+ * This will add an action item to the given bytenr and do sanity checks to make
+ * sure we haven't messed something up.  If we are making a new allocation and
+ * this block entry has history we will delete all previous actions as long as
+ * our sanity checks pass as they are no longer needed.
+ */
+int btrfs_ref_tree_mod(struct btrfs_root *root, u64 bytenr, u64 num_bytes,
+		       u64 parent, u64 ref_root, u64 owner, u64 offset,
+		       int action)
+{
+	struct ref_entry *ref = NULL, *exist;
+	struct ref_action *ra = NULL;
+	struct block_entry *be = NULL;
+	struct root_entry *re;
+	int ret = 0;
+	bool metadata = owner < BTRFS_FIRST_FREE_OBJECTID;
+	bool update_caller_root = root->objectid != ref_root;
+
+	if (!root->fs_info->ref_verify_enabled)
+		return 0;
+
+	ref = kmalloc(sizeof(struct ref_entry), GFP_NOFS);
+	ra = kmalloc(sizeof(struct ref_action), GFP_NOFS);
+	if (!ra || !ref) {
+		kfree(ref);
+		kfree(ra);
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	if (parent) {
+		ref->root_objectid = 0;
+	} else {
+		ref->root_objectid = ref_root;
+	}
+	ref->parent = parent;
+	ref->owner = owner;
+	ref->offset = offset;
+	ref->num_refs = (action == BTRFS_DROP_DELAYED_REF) ? -1 : 1;
+
+	memcpy(&ra->ref, ref, sizeof(struct ref_entry));
+	__save_stack_trace(ra);
+
+	INIT_LIST_HEAD(&ra->list);
+	ra->action = action;
+	ra->root = root->objectid;
+
+	/*
+	 * This is an allocation, preallocate the block_entry in case we haven't
+	 * used it before.
+	 */
+	ret = -EINVAL;
+	if (action == BTRFS_ADD_DELAYED_EXTENT) {
+		update_caller_root = false;
+
+		/*
+		 * For subvol_create we'll just pass in whatever the parent root
+		 * is and the new root objectid, so let's not treat the passed
+		 * in root as if it really has a ref for this bytenr.
+		 */
+		be = add_block_entry(root, bytenr, num_bytes, ref_root);
+		if (IS_ERR(be)) {
+			kfree(ra);
+			ret = PTR_ERR(be);
+			goto out;
+		}
+
+		spin_lock(&root->fs_info->ref_verify_lock);
+		if (metadata)
+			be->metadata = 1;
+
+		if (be->num_refs != 1) {
+			printk(KERN_ERR "re-allocated a block that still has "
+			       "references to it!\n");
+			dump_block_entry(be);
+			dump_ref_action(ra);
+			goto out;
+		}
+
+		while (!list_empty(&be->actions)) {
+			struct ref_action *tmp;
+			tmp = list_first_entry(&be->actions, struct ref_action,
+					       list);
+			list_del(&tmp->list);
+			kfree(tmp);
+		}
+	} else {
+		struct root_entry *tmp;
+
+		re = kmalloc(sizeof(struct root_entry), GFP_NOFS);
+		if (!re) {
+			kfree(ref);
+			kfree(ra);
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		/*
+		 * The ref root is the original owner, we want to lookup the
+		 * root responsible for this modification.
+		 */
+		ref_root = root->objectid;
+		re->root_objectid = root->objectid;
+		re->num_refs = 0;
+
+		spin_lock(&root->fs_info->ref_verify_lock);
+		be = lookup_block_entry(&root->fs_info->block_tree, bytenr);
+		if (!be) {
+			printk(KERN_ERR "Trying to do action %d to bytenr %Lu "
+			       " num_bytes %Lu but there is no existing "
+			       "entry!\n", action, bytenr, num_bytes);
+			dump_ref_action(ra);
+			spin_unlock(&root->fs_info->ref_verify_lock);
+			kfree(ref);
+			kfree(ra);
+			goto out;
+		}
+
+		tmp = insert_root_entry(&be->roots, re);
+		if (tmp)
+			kfree(re);
+	}
+
+	exist = insert_ref_entry(&be->refs, ref);
+	if (exist) {
+		if (action == BTRFS_DROP_DELAYED_REF) {
+			if (exist->num_refs == 0) {
+				printk(KERN_ERR "Dropping a ref for a "
+				       "existing root that doesn't have a ref "
+				       "on the block\n");
+				dump_block_entry(be);
+				dump_ref_action(ra);
+				kfree(ra);
+				goto out;
+			}
+			exist->num_refs--;
+			if (exist->num_refs == 0) {
+				rb_erase(&exist->node, &be->refs);
+				kfree(exist);
+			}
+		} else {
+			exist->num_refs++;
+		}
+		kfree(ref);
+	} else {
+		if (action == BTRFS_DROP_DELAYED_REF) {
+			printk(KERN_ERR "Dropping a ref for a root that "
+			       "doesn't have a ref on the block\n");
+			dump_block_entry(be);
+			dump_ref_action(ra);
+			kfree(ra);
+			goto out;
+		}
+	}
+
+	re = lookup_root_entry(&be->roots, ref_root);
+	if (!re) {
+		/*
+		 * This really shouldn't happen but there where bugs when I
+		 * originally put this stuff together so I would hit it every
+		 * once and a while.  Now everything is working so it really
+		 * won't get tripped, but if anybody starts messing around in
+		 * here it will be a nice sanity check instead of a panic.  We
+		 * can remove it later if we need to.
+		 */
+		printk(KERN_ERR "Failed to find root %llu for %llu",
+		       ref_root, be->bytenr);
+		dump_block_entry(be);
+		dump_ref_action(ra);
+		spin_unlock(&root->fs_info->ref_verify_lock);
+		kfree(ra);
+		goto out;
+	}
+	ASSERT(re);
+	if (action == BTRFS_DROP_DELAYED_REF) {
+		if (!parent)
+			re->num_refs--;
+		be->num_refs--;
+	} else if (action == BTRFS_ADD_DELAYED_REF) {
+		be->num_refs++;
+		if (!parent)
+			re->num_refs++;
+	}
+	list_add_tail(&ra->list, &be->actions);
+	spin_unlock(&root->fs_info->ref_verify_lock);
+	ret = 0;
+out:
+	if (ret)
+		root->fs_info->ref_verify_enabled = false;
+	return ret;
+}
+
+/* Free up the ref cache */
+void btrfs_free_ref_cache(struct btrfs_fs_info *fs_info)
+{
+	struct block_entry *be;
+	struct rb_node *n;
+
+	spin_lock(&fs_info->ref_verify_lock);
+	while ((n = rb_first(&fs_info->block_tree))) {
+		be = rb_entry(n, struct block_entry, node);
+		rb_erase(&be->node, &fs_info->block_tree);
+		free_block_entry(be);
+		cond_resched_lock(&fs_info->ref_verify_lock);
+	}
+	spin_unlock(&fs_info->ref_verify_lock);
+}
+
+/* Walk down all roots and build the ref tree, meant to be called at mount */
+int btrfs_build_ref_tree(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_path *path;
+	struct btrfs_root *root;
+	struct btrfs_key key;
+	u64 last_objectid = BTRFS_EXTENT_TREE_OBJECTID;
+	int ret;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	ret = build_ref_tree_for_root(fs_info->tree_root);
+	if (ret)
+		goto out;
+
+	ret = build_ref_tree_for_root(fs_info->chunk_root);
+	if (ret)
+		goto out;
+again:
+	key.objectid = last_objectid;
+	key.type = BTRFS_ROOT_ITEM_KEY;
+	key.offset = 0;
+
+	ret = btrfs_search_slot(NULL, fs_info->tree_root, &key, path, 0, 0);
+	if (ret < 0)
+		goto out;
+	while (1) {
+		if (path->slots[0] >= btrfs_header_nritems(path->nodes[0])) {
+			ret = btrfs_next_leaf(fs_info->tree_root, path);
+			if (ret > 0) {
+				ret = 0;
+				break;
+			} else if (ret) {
+				break;
+			}
+		}
+		btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
+		if (key.type != BTRFS_ROOT_ITEM_KEY) {
+			path->slots[0]++;
+			continue;
+		}
+		btrfs_release_path(path);
+		root = btrfs_get_fs_root(fs_info, &key, false);
+		if (IS_ERR(root)) {
+			ret = PTR_ERR(root);
+			break;
+		}
+		last_objectid = key.objectid + 1;
+		ret = build_ref_tree_for_root(root);
+		if (ret)
+			break;
+		goto again;
+	}
+out:
+	btrfs_free_path(path);
+	return ret;
+}
diff --git a/fs/btrfs/ref-verify.h b/fs/btrfs/ref-verify.h
new file mode 100644
index 0000000..df282ea
--- /dev/null
+++ b/fs/btrfs/ref-verify.h
@@ -0,0 +1,34 @@
+/*
+ * Copyright (C) 2014 Facebook.  All rights reserved.
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
+#ifndef __REF_VERIFY__
+#define __REF_VERIFY__
+
+#ifdef CONFIG_BTRFS_FS_REF_VERIFY
+int btrfs_build_ref_tree(struct btrfs_fs_info *fs_info);
+void btrfs_free_ref_cache(struct btrfs_fs_info *fs_info);
+int btrfs_ref_tree_mod(struct btrfs_root *root, u64 bytenr, u64 num_bytes,
+		       u64 parent, u64 ref_root, u64 owner, u64 offset,
+		       int action);
+#else
+
+#define btrfs_free_ref_cache(fs_info) do { } while (0)
+#define btrfs_ref_tree_mod(root, bytenr, num_bytes, parent, ref_root,	\
+			   owner, offset, action) do { } while (0)
+
+#endif /* CONFIG_BTRFS_FS_REF_VERIFY */
+#endif /* _REF_VERIFY__ */
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 7f92ab1..f026a82 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -31,6 +31,7 @@
 #include "async-thread.h"
 #include "free-space-cache.h"
 #include "inode-map.h"
+#include "ref-verify.h"
 
 /*
  * backref_node, mapping_node and tree_block start with this
-- 
1.8.3.1

