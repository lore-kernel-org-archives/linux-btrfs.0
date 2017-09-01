Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:35810 "EHLO
        mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751040AbdIAHJd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Sep 2017 03:09:33 -0400
Received: by mail-qk0-f172.google.com with SMTP id p67so7275443qkd.2
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Sep 2017 00:09:32 -0700 (PDT)
From: josef@toxicpanda.com
To: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc: Josef Bacik <jbacik@fb.com>
Subject: [PATCH][v3] Btrfs: add a extent ref verify tool
Date: Fri,  1 Sep 2017 03:09:30 -0400
Message-Id: <1504249770-22660-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Josef Bacik <jbacik@fb.com>

We were having corruption issues that were tied back to problems with the extent
tree.  In order to track them down I built this tool to try and find the
culprit, which was pretty successful.  If you compile with this tool on it will
live verify every ref update that the fs makes and make sure it is consistent
and valid.  I've run this through with xfstests and haven't gotten any false
positives.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
v2->v3:
- fix use after free in an error case

 fs/btrfs/Kconfig       |   10 +
 fs/btrfs/Makefile      |    1 +
 fs/btrfs/ctree.c       |    2 +-
 fs/btrfs/ctree.h       |   14 +-
 fs/btrfs/disk-io.c     |   15 +
 fs/btrfs/extent-tree.c |   44 ++-
 fs/btrfs/file.c        |   10 +-
 fs/btrfs/inode.c       |    9 +-
 fs/btrfs/ioctl.c       |    2 +-
 fs/btrfs/ref-verify.c  | 1019 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/ref-verify.h  |   51 +++
 fs/btrfs/relocation.c  |   14 +-
 fs/btrfs/super.c       |   17 +
 fs/btrfs/tree-log.c    |    2 +-
 14 files changed, 1178 insertions(+), 32 deletions(-)
 create mode 100644 fs/btrfs/ref-verify.c
 create mode 100644 fs/btrfs/ref-verify.h

diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
index 80e9c18..77d7f74 100644
--- a/fs/btrfs/Kconfig
+++ b/fs/btrfs/Kconfig
@@ -89,3 +89,13 @@ config BTRFS_ASSERT
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
index 128ce17..3172751 100644
--- a/fs/btrfs/Makefile
+++ b/fs/btrfs/Makefile
@@ -13,6 +13,7 @@ btrfs-y += super.o ctree.o extent-tree.o print-tree.o root-tree.o dir-item.o \
 
 btrfs-$(CONFIG_BTRFS_FS_POSIX_ACL) += acl.o
 btrfs-$(CONFIG_BTRFS_FS_CHECK_INTEGRITY) += check-integrity.o
+btrfs-$(CONFIG_BTRFS_FS_REF_VERIFY) += ref-verify.o
 
 btrfs-$(CONFIG_BTRFS_FS_RUN_SANITY_TESTS) += tests/free-space-tests.o \
 	tests/extent-buffer-tests.o tests/btrfs-tests.o \
diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 6d49db7..a4812ce 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -192,7 +192,7 @@ struct extent_buffer *btrfs_lock_root_node(struct btrfs_root *root)
  * tree until you end up with a lock on the root.  A locked buffer
  * is returned, with a reference held.
  */
-static struct extent_buffer *btrfs_read_lock_root_node(struct btrfs_root *root)
+struct extent_buffer *btrfs_read_lock_root_node(struct btrfs_root *root)
 {
 	struct extent_buffer *eb;
 
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index d49b045..4fa3ddd 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1098,6 +1098,12 @@ struct btrfs_fs_info {
 	u32 nodesize;
 	u32 sectorsize;
 	u32 stripesize;
+
+#ifdef CONFIG_BTRFS_FS_REF_VERIFY
+	spinlock_t ref_verify_lock;
+	struct rb_root block_tree;
+	bool ref_verify_enabled;
+#endif
 };
 
 static inline struct btrfs_fs_info *btrfs_sb(struct super_block *sb)
@@ -1336,6 +1342,7 @@ static inline u32 BTRFS_MAX_XATTR_SIZE(const struct btrfs_fs_info *info)
 #define BTRFS_MOUNT_FRAGMENT_METADATA	(1 << 25)
 #define BTRFS_MOUNT_FREE_SPACE_TREE	(1 << 26)
 #define BTRFS_MOUNT_NOLOGREPLAY		(1 << 27)
+#define BTRFS_MOUNT_REF_VERIFY		(1 << 28)
 
 #define BTRFS_DEFAULT_COMMIT_INTERVAL	(30)
 #define BTRFS_DEFAULT_MAX_INLINE	(2048)
@@ -2627,7 +2634,7 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 			   struct extent_buffer *buf,
 			   u64 parent, int last_ref);
 int btrfs_alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
-				     u64 root_objectid, u64 owner,
+				     struct btrfs_root *root, u64 owner,
 				     u64 offset, u64 ram_bytes,
 				     struct btrfs_key *ins);
 int btrfs_alloc_logged_file_extent(struct btrfs_trans_handle *trans,
@@ -2646,7 +2653,7 @@ int btrfs_set_disk_extent_flags(struct btrfs_trans_handle *trans,
 				u64 bytenr, u64 num_bytes, u64 flags,
 				int level, int is_data);
 int btrfs_free_extent(struct btrfs_trans_handle *trans,
-		      struct btrfs_fs_info *fs_info,
+		      struct btrfs_root *root,
 		      u64 bytenr, u64 num_bytes, u64 parent, u64 root_objectid,
 		      u64 owner, u64 offset);
 
@@ -2658,7 +2665,7 @@ void btrfs_prepare_extent_commit(struct btrfs_fs_info *fs_info);
 int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
 			       struct btrfs_fs_info *fs_info);
 int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
-			 struct btrfs_fs_info *fs_info,
+			 struct btrfs_root *root,
 			 u64 bytenr, u64 num_bytes, u64 parent,
 			 u64 root_objectid, u64 owner, u64 offset);
 
@@ -2803,6 +2810,7 @@ void btrfs_set_item_key_safe(struct btrfs_fs_info *fs_info,
 			     const struct btrfs_key *new_key);
 struct extent_buffer *btrfs_root_node(struct btrfs_root *root);
 struct extent_buffer *btrfs_lock_root_node(struct btrfs_root *root);
+struct extent_buffer *btrfs_read_lock_root_node(struct btrfs_root *root);
 int btrfs_find_next_key(struct btrfs_root *root, struct btrfs_path *path,
 			struct btrfs_key *key, int lowest_level,
 			u64 min_trans);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 4a41158..32215e5 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -50,6 +50,7 @@
 #include "sysfs.h"
 #include "qgroup.h"
 #include "compression.h"
+#include "ref-verify.h"
 
 #ifdef CONFIG_X86
 #include <asm/cpufeature.h>
@@ -2664,6 +2665,12 @@ int open_ctree(struct super_block *sb,
 	INIT_RADIX_TREE(&fs_info->reada_tree, GFP_NOFS & ~__GFP_DIRECT_RECLAIM);
 	spin_lock_init(&fs_info->reada_lock);
 
+#ifdef CONFIG_BTRFS_FS_REF_VERIFY
+	spin_lock_init(&fs_info->ref_verify_lock);
+	fs_info->block_tree = RB_ROOT;
+	fs_info->ref_verify_enabled = true;
+#endif
+
 	fs_info->thread_pool_size = min_t(unsigned long,
 					  num_online_cpus() + 2, 8);
 
@@ -3079,6 +3086,13 @@ int open_ctree(struct super_block *sb,
 	if (ret)
 		goto fail_trans_kthread;
 
+#ifdef CONFIG_BTRFS_FS_REF_VERIFY
+	if (btrfs_build_ref_tree(fs_info)) {
+		fs_info->ref_verify_enabled = false;
+		printk(KERN_ERR "BTRFS: couldn't build ref tree\n");
+	}
+#endif
+
 	/* do not make disk changes in broken FS or nologreplay is given */
 	if (btrfs_super_log_root(disk_super) != 0 &&
 	    !btrfs_test_opt(fs_info, NOLOGREPLAY)) {
@@ -3936,6 +3950,7 @@ void close_ctree(struct btrfs_fs_info *fs_info)
 	cleanup_srcu_struct(&fs_info->subvol_srcu);
 
 	btrfs_free_stripe_hash_table(fs_info);
+	btrfs_free_ref_cache(fs_info);
 
 	__btrfs_free_block_rsv(root->orphan_block_rsv);
 	root->orphan_block_rsv = NULL;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 1464678..b68fb8c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -39,6 +39,7 @@
 #include "math.h"
 #include "sysfs.h"
 #include "qgroup.h"
+#include "ref-verify.h"
 
 #undef SCRAMBLE_DELAYED_REFS
 
@@ -2110,16 +2111,20 @@ int btrfs_discard_extent(struct btrfs_fs_info *fs_info, u64 bytenr,
 
 /* Can return -ENOMEM */
 int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
-			 struct btrfs_fs_info *fs_info,
+			 struct btrfs_root *root,
 			 u64 bytenr, u64 num_bytes, u64 parent,
 			 u64 root_objectid, u64 owner, u64 offset)
 {
+	struct btrfs_fs_info *fs_info = root->fs_info;
 	int old_ref_mod, new_ref_mod;
 	int ret;
 
 	BUG_ON(owner < BTRFS_FIRST_FREE_OBJECTID &&
 	       root_objectid == BTRFS_TREE_LOG_OBJECTID);
 
+	btrfs_ref_tree_mod(root, bytenr, num_bytes, parent, root_objectid,
+			   owner, offset, BTRFS_ADD_DELAYED_REF);
+
 	if (owner < BTRFS_FIRST_FREE_OBJECTID) {
 		ret = btrfs_add_delayed_tree_ref(fs_info, trans, bytenr,
 						 num_bytes, parent,
@@ -3270,7 +3275,7 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
 	int level;
 	int ret = 0;
 	int (*process_func)(struct btrfs_trans_handle *,
-			    struct btrfs_fs_info *,
+			    struct btrfs_root *,
 			    u64, u64, u64, u64, u64, u64);
 
 
@@ -3310,7 +3315,7 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
 
 			num_bytes = btrfs_file_extent_disk_num_bytes(buf, fi);
 			key.offset -= btrfs_file_extent_offset(buf, fi);
-			ret = process_func(trans, fs_info, bytenr, num_bytes,
+			ret = process_func(trans, root, bytenr, num_bytes,
 					   parent, ref_root, key.objectid,
 					   key.offset);
 			if (ret)
@@ -3318,7 +3323,7 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
 		} else {
 			bytenr = btrfs_node_blockptr(buf, i);
 			num_bytes = fs_info->nodesize;
-			ret = process_func(trans, fs_info, bytenr, num_bytes,
+			ret = process_func(trans, root, bytenr, num_bytes,
 					   parent, ref_root, level - 1, 0);
 			if (ret)
 				goto fail;
@@ -7154,6 +7159,10 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 	if (root->root_key.objectid != BTRFS_TREE_LOG_OBJECTID) {
 		int old_ref_mod, new_ref_mod;
 
+		btrfs_ref_tree_mod(root, buf->start, buf->len, parent,
+				   root->root_key.objectid,
+				   btrfs_header_level(buf), 0,
+				   BTRFS_DROP_DELAYED_REF);
 		ret = btrfs_add_delayed_tree_ref(fs_info, trans, buf->start,
 						 buf->len, parent,
 						 root->root_key.objectid,
@@ -7206,16 +7215,21 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 
 /* Can return -ENOMEM */
 int btrfs_free_extent(struct btrfs_trans_handle *trans,
-		      struct btrfs_fs_info *fs_info,
+		      struct btrfs_root *root,
 		      u64 bytenr, u64 num_bytes, u64 parent, u64 root_objectid,
 		      u64 owner, u64 offset)
 {
+	struct btrfs_fs_info *fs_info = root->fs_info;
 	int old_ref_mod, new_ref_mod;
 	int ret;
 
 	if (btrfs_is_testing(fs_info))
 		return 0;
 
+	if (root_objectid != BTRFS_TREE_LOG_OBJECTID)
+		btrfs_ref_tree_mod(root, bytenr, num_bytes, parent,
+				   root_objectid, owner, offset,
+				   BTRFS_DROP_DELAYED_REF);
 
 	/*
 	 * tree log blocks never actually go into the extent allocation
@@ -8183,17 +8197,22 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 }
 
 int btrfs_alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
-				     u64 root_objectid, u64 owner,
+				     struct btrfs_root *root, u64 owner,
 				     u64 offset, u64 ram_bytes,
 				     struct btrfs_key *ins)
 {
-	struct btrfs_fs_info *fs_info = trans->fs_info;
+	struct btrfs_fs_info *fs_info = root->fs_info;
 	int ret;
 
-	BUG_ON(root_objectid == BTRFS_TREE_LOG_OBJECTID);
+	BUG_ON(root->root_key.objectid == BTRFS_TREE_LOG_OBJECTID);
+
+	btrfs_ref_tree_mod(root, ins->objectid, ins->offset, 0,
+			   root->root_key.objectid, owner, offset,
+			   BTRFS_ADD_DELAYED_EXTENT);
 
 	ret = btrfs_add_delayed_data_ref(fs_info, trans, ins->objectid,
-					 ins->offset, 0, root_objectid, owner,
+					 ins->offset, 0,
+					 root->root_key.objectid, owner,
 					 offset, ram_bytes,
 					 BTRFS_ADD_DELAYED_EXTENT, NULL, NULL);
 	return ret;
@@ -8415,6 +8434,9 @@ struct extent_buffer *btrfs_alloc_tree_block(struct btrfs_trans_handle *trans,
 		extent_op->is_data = false;
 		extent_op->level = level;
 
+		btrfs_ref_tree_mod(root, ins.objectid, ins.offset, parent,
+				   root_objectid, level, 0,
+				   BTRFS_ADD_DELAYED_EXTENT);
 		ret = btrfs_add_delayed_tree_ref(fs_info, trans, ins.objectid,
 						 ins.offset, parent,
 						 root_objectid, level,
@@ -8771,7 +8793,7 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
 					     ret);
 			}
 		}
-		ret = btrfs_free_extent(trans, fs_info, bytenr, blocksize,
+		ret = btrfs_free_extent(trans, root, bytenr, blocksize,
 					parent, root->root_key.objectid,
 					level - 1, 0);
 		if (ret)
@@ -10264,6 +10286,8 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 	 * remove it.
 	 */
 	free_excluded_extents(fs_info, block_group);
+	btrfs_free_ref_tree_range(fs_info, block_group->key.objectid,
+				  block_group->key.offset);
 
 	memcpy(&key, &block_group->key, sizeof(key));
 	index = get_block_group_index(block_group);
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index aeab384..7d01dc4 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -856,7 +856,7 @@ int __btrfs_drop_extents(struct btrfs_trans_handle *trans,
 			btrfs_mark_buffer_dirty(leaf);
 
 			if (update_refs && disk_bytenr > 0) {
-				ret = btrfs_inc_extent_ref(trans, fs_info,
+				ret = btrfs_inc_extent_ref(trans, root,
 						disk_bytenr, num_bytes, 0,
 						root->root_key.objectid,
 						new_key.objectid,
@@ -940,7 +940,7 @@ int __btrfs_drop_extents(struct btrfs_trans_handle *trans,
 				extent_end = ALIGN(extent_end,
 						   fs_info->sectorsize);
 			} else if (update_refs && disk_bytenr > 0) {
-				ret = btrfs_free_extent(trans, fs_info,
+				ret = btrfs_free_extent(trans, root,
 						disk_bytenr, num_bytes, 0,
 						root->root_key.objectid,
 						key.objectid, key.offset -
@@ -1234,7 +1234,7 @@ int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
 						extent_end - split);
 		btrfs_mark_buffer_dirty(leaf);
 
-		ret = btrfs_inc_extent_ref(trans, fs_info, bytenr, num_bytes,
+		ret = btrfs_inc_extent_ref(trans, root, bytenr, num_bytes,
 					   0, root->root_key.objectid,
 					   ino, orig_offset);
 		if (ret) {
@@ -1268,7 +1268,7 @@ int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
 		extent_end = other_end;
 		del_slot = path->slots[0] + 1;
 		del_nr++;
-		ret = btrfs_free_extent(trans, fs_info, bytenr, num_bytes,
+		ret = btrfs_free_extent(trans, root, bytenr, num_bytes,
 					0, root->root_key.objectid,
 					ino, orig_offset);
 		if (ret) {
@@ -1288,7 +1288,7 @@ int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
 		key.offset = other_start;
 		del_slot = path->slots[0];
 		del_nr++;
-		ret = btrfs_free_extent(trans, fs_info, bytenr, num_bytes,
+		ret = btrfs_free_extent(trans, root, bytenr, num_bytes,
 					0, root->root_key.objectid,
 					ino, orig_offset);
 		if (ret) {
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0038de5..f9f9de5 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2215,8 +2215,9 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 	if (ret < 0)
 		goto out;
 	qg_released = ret;
-	ret = btrfs_alloc_reserved_file_extent(trans, root->root_key.objectid,
-			btrfs_ino(BTRFS_I(inode)), file_pos, qg_released, &ins);
+	ret = btrfs_alloc_reserved_file_extent(trans, root,
+					       btrfs_ino(BTRFS_I(inode)),
+					       file_pos, qg_released, &ins);
 out:
 	btrfs_free_path(path);
 
@@ -2668,7 +2669,7 @@ static noinline int relink_extent_backref(struct btrfs_path *path,
 	inode_add_bytes(inode, len);
 	btrfs_release_path(path);
 
-	ret = btrfs_inc_extent_ref(trans, fs_info, new->bytenr,
+	ret = btrfs_inc_extent_ref(trans, root, new->bytenr,
 			new->disk_len, 0,
 			backref->root_id, backref->inum,
 			new->file_pos);	/* start - extent_offset */
@@ -4659,7 +4660,7 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 		     root == fs_info->tree_root)) {
 			btrfs_set_path_blocking(path);
 			bytes_deleted += extent_num_bytes;
-			ret = btrfs_free_extent(trans, fs_info, extent_start,
+			ret = btrfs_free_extent(trans, root, extent_start,
 						extent_num_bytes, 0,
 						btrfs_header_owner(leaf),
 						ino, extent_offset);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 137402f..d4e3eb6 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3704,7 +3704,7 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
 				if (disko) {
 					inode_add_bytes(inode, datal);
 					ret = btrfs_inc_extent_ref(trans,
-							fs_info,
+							root,
 							disko, diskl, 0,
 							root->root_key.objectid,
 							btrfs_ino(BTRFS_I(inode)),
diff --git a/fs/btrfs/ref-verify.c b/fs/btrfs/ref-verify.c
new file mode 100644
index 0000000..5d3aa8b
--- /dev/null
+++ b/fs/btrfs/ref-verify.c
@@ -0,0 +1,1019 @@
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
+	be->num_refs++;
+}
+
+#ifdef CONFIG_STACK_TRACE
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
+static void __print_stack_trace(struct ref_action *ra)
+{
+	struct stack_trace trace;
+	trace.nr_entries = ra->trace_len;
+	trace.entries = ra->trace;
+	print_stack_trace(&trace, 2);
+}
+#else
+static void inline __save_stack_trace(struct ref_action *ra) {}
+static void inline __print_stack_trace(struct ref_action *ra)
+{
+	printk(KERN_ERR "  No stacktrace support\n");
+}
+#endif
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
+		rb_erase(&be->node, &fs_info->block_tree);
+		kfree(re);
+		kfree(be);
+		be = ERR_PTR(-EINVAL);
+		ASSERT(0);
+	}
+out:
+	spin_unlock(&fs_info->ref_verify_lock);
+	return be;
+}
+
+static int add_tree_block(struct btrfs_root *root, u64 parent, u64 bytenr,
+			  int level)
+{
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct block_entry *be;
+	struct root_entry *re;
+	struct ref_entry *ref = NULL, *exist;
+	struct ref_action *ra;
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
+	if (parent)
+		ref->root_objectid = 0;
+	else
+		ref->root_objectid = root->objectid;
+	ref->parent = parent;
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
+	be = add_block_entry(root, bytenr, fs_info->nodesize, root->objectid);
+	if (IS_ERR(be)) {
+		kfree(ref);
+		kfree(ra);
+		return PTR_ERR(be);
+	}
+
+	spin_lock(&fs_info->ref_verify_lock);
+	be->metadata = 1;
+
+	if (!parent) {
+		re = lookup_root_entry(&be->roots, root->objectid);
+		ASSERT(re);
+		re->num_refs++;
+	}
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
+static int process_leaf(struct btrfs_root *root, struct btrfs_path *path,
+			int shared)
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
+		if (shared) {
+			ref->root_objectid = 0;
+			ref->parent = leaf->start;
+		} else {
+			ref->root_objectid = root->objectid;
+			ref->parent = 0;
+		}
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
+
+		if (!shared) {
+			re = lookup_root_entry(&be->roots, root->objectid);
+			ASSERT(re);
+			re->num_refs++;
+		}
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
+static int add_shared_refs(struct btrfs_root *root, struct btrfs_path *path,
+			   int level)
+{
+	int i;
+	int ret = 0;
+
+	if (level == 0)
+		return process_leaf(root, path, 1);
+
+	for (i = 0; i < btrfs_header_nritems(path->nodes[level]); i++) {
+		u64 bytenr;
+
+		bytenr = btrfs_node_blockptr(path->nodes[level], i);
+		ret = add_tree_block(root, path->nodes[level]->start, bytenr,
+				     level-1);
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
+
+/* Walk down to the leaf from the given level */
+static int walk_down_tree(struct btrfs_root *root, struct btrfs_path *path,
+			  int level)
+{
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct extent_buffer *eb;
+	u64 bytenr, gen;
+	int ret = 0;
+
+	while (level >= 0) {
+		if (btrfs_header_owner(path->nodes[level]) != root->objectid) {
+			u64 refs, flags;
+			if (!btrfs_block_can_be_shared(root, path->nodes[level]))
+				break;
+			eb = path->nodes[level];
+			ret = btrfs_lookup_extent_info(NULL, fs_info,
+						       eb->start, level, 1,
+						       &refs, &flags);
+			if (ret)
+				break;
+			if (refs == 0) {
+				WARN_ON(1);
+				ret = -EINVAL;
+				break;
+			}
+
+			if (flags & BTRFS_BLOCK_FLAG_FULL_BACKREF)
+				ret = add_shared_refs(root, path, level);
+			break;
+		}
+		if (level) {
+			bytenr = btrfs_node_blockptr(path->nodes[level],
+						     path->slots[level]);
+			gen = btrfs_node_ptr_generation(path->nodes[level],
+							path->slots[level]);
+			eb = read_tree_block(fs_info, bytenr, gen);
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
+			ret = add_tree_block(root, 0, bytenr, level-1);
+			if (ret)
+				break;
+		} else if (test_bit(BTRFS_ROOT_REF_COWS, &root->state) ||
+			   root == root->fs_info->tree_root) {
+			ret = process_leaf(root, path, 0);
+			if (ret)
+				break;
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
+	ret = add_tree_block(root, 0, eb->start, level);
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
+
+static void dump_ref_action(struct ref_action *ra)
+{
+	printk(KERN_ERR "  Ref action %d, root %llu, ref_root %llu, parent "
+	       "%llu, owner %llu, offset %llu, num_refs %llu\n",
+	       ra->action, ra->root, ra->ref.root_objectid, ra->ref.parent,
+	       ra->ref.owner, ra->ref.offset, ra->ref.num_refs);
+	__print_stack_trace(ra);
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
+	if (!btrfs_test_opt(root->fs_info, REF_VERIFY))
+		return 0;
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
+			goto out_unlock;
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
+			kfree(ref);
+			kfree(ra);
+			goto out_unlock;
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
+				goto out_unlock;
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
+			goto out_unlock;
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
+		kfree(ra);
+		goto out_unlock;
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
+	ret = 0;
+out_unlock:
+	spin_unlock(&root->fs_info->ref_verify_lock);
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
+	if (!btrfs_test_opt(fs_info, REF_VERIFY))
+		return;
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
+void btrfs_free_ref_tree_range(struct btrfs_fs_info *fs_info, u64 start,
+			       u64 len)
+{
+	struct block_entry *be = NULL, *entry;
+	struct rb_node *n;
+
+	if (!btrfs_test_opt(fs_info, REF_VERIFY))
+		return;
+
+	spin_lock(&fs_info->ref_verify_lock);
+	n = fs_info->block_tree.rb_node;
+	while (n) {
+		entry = rb_entry(n, struct block_entry, node);
+		if (entry->bytenr < start) {
+			n = n->rb_right;
+		} else if (entry->bytenr > start) {
+			n = n->rb_left;
+		} else {
+			be = entry;
+			break;
+		}
+		/* We want to get as close to start as possible */
+		if (be == NULL ||
+		    (entry->bytenr < start && be->bytenr > start) ||
+		    (entry->bytenr < start && entry->bytenr > be->bytenr))
+			be = entry;
+	}
+
+	/*
+	 * Could have an empty block group, maybe have something to check for
+	 * this case to verify we were actually empty?
+	 */
+	if (!be) {
+		spin_unlock(&fs_info->ref_verify_lock);
+		return;
+	}
+
+	n = &be->node;
+	while (n) {
+		be = rb_entry(n, struct block_entry, node);
+		n = rb_next(n);
+		if (be->bytenr < start && be->bytenr + be->len > start) {
+			printk(KERN_ERR "Block entry overlaps a block "
+			       "group [%llu,%llu]!\n", start, len);
+			dump_block_entry(be);
+			continue;
+		}
+		if (be->bytenr < start)
+			continue;
+		if (be->bytenr >= start + len)
+			break;
+		if (be->bytenr + be->len > start + len) {
+			printk(KERN_ERR "Block entry overlaps a block "
+			       "group [%llu,%llu]!\n", start, len);
+			dump_block_entry(be);
+		}
+		rb_erase(&be->node, &fs_info->block_tree);
+		free_block_entry(be);
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
+	if (!btrfs_test_opt(fs_info, REF_VERIFY))
+		return 0;
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
index 0000000..8f508c0
--- /dev/null
+++ b/fs/btrfs/ref-verify.h
@@ -0,0 +1,51 @@
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
+void btrfs_free_ref_tree_range(struct btrfs_fs_info *fs_info, u64 start,
+			       u64 len);
+#else
+static inline int btrfs_build_ref_tree(struct btrfs_fs_info *fs_info)
+{
+	return 0;
+}
+
+static inline void btrfs_free_ref_cache(struct btrfs_fs_info *fs_info)
+{
+}
+
+static inline int btrfs_ref_tree_mod(struct btrfs_root *root, u64 bytenr,
+				     u64 num_bytes, u64 parent, u64 ref_root,
+				     u64 owner, u64 offset, int action)
+{
+	return 0;
+}
+
+static inline void btrfs_free_ref_tree_range(struct btrfs_fs_info *fs_info,
+					     u64 start, u64 len)
+{
+}
+#endif /* CONFIG_BTRFS_FS_REF_VERIFY */
+#endif /* _REF_VERIFY__ */
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index b67844b..8a15464 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1733,7 +1733,7 @@ int replace_file_extents(struct btrfs_trans_handle *trans,
 		dirty = 1;
 
 		key.offset -= btrfs_file_extent_offset(leaf, fi);
-		ret = btrfs_inc_extent_ref(trans, fs_info, new_bytenr,
+		ret = btrfs_inc_extent_ref(trans, root, new_bytenr,
 					   num_bytes, parent,
 					   btrfs_header_owner(leaf),
 					   key.objectid, key.offset);
@@ -1742,7 +1742,7 @@ int replace_file_extents(struct btrfs_trans_handle *trans,
 			break;
 		}
 
-		ret = btrfs_free_extent(trans, fs_info, bytenr, num_bytes,
+		ret = btrfs_free_extent(trans, root, bytenr, num_bytes,
 					parent, btrfs_header_owner(leaf),
 					key.objectid, key.offset);
 		if (ret) {
@@ -1943,21 +1943,21 @@ int replace_path(struct btrfs_trans_handle *trans,
 					      path->slots[level], old_ptr_gen);
 		btrfs_mark_buffer_dirty(path->nodes[level]);
 
-		ret = btrfs_inc_extent_ref(trans, fs_info, old_bytenr,
+		ret = btrfs_inc_extent_ref(trans, src, old_bytenr,
 					blocksize, path->nodes[level]->start,
 					src->root_key.objectid, level - 1, 0);
 		BUG_ON(ret);
-		ret = btrfs_inc_extent_ref(trans, fs_info, new_bytenr,
+		ret = btrfs_inc_extent_ref(trans, dest, new_bytenr,
 					blocksize, 0, dest->root_key.objectid,
 					level - 1, 0);
 		BUG_ON(ret);
 
-		ret = btrfs_free_extent(trans, fs_info, new_bytenr, blocksize,
+		ret = btrfs_free_extent(trans, src, new_bytenr, blocksize,
 					path->nodes[level]->start,
 					src->root_key.objectid, level - 1, 0);
 		BUG_ON(ret);
 
-		ret = btrfs_free_extent(trans, fs_info, old_bytenr, blocksize,
+		ret = btrfs_free_extent(trans, dest, old_bytenr, blocksize,
 					0, dest->root_key.objectid, level - 1,
 					0);
 		BUG_ON(ret);
@@ -2799,7 +2799,7 @@ static int do_relocation(struct btrfs_trans_handle *trans,
 						      trans->transid);
 			btrfs_mark_buffer_dirty(upper->eb);
 
-			ret = btrfs_inc_extent_ref(trans, root->fs_info,
+			ret = btrfs_inc_extent_ref(trans, root,
 						node->eb->start, blocksize,
 						upper->eb->start,
 						btrfs_header_owner(upper->eb),
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 0b7a1d8..aad45dc 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -326,6 +326,9 @@ enum {
 #ifdef CONFIG_BTRFS_DEBUG
 	Opt_fragment_data, Opt_fragment_metadata, Opt_fragment_all,
 #endif
+#ifdef CONFIG_BTRFS_FS_REF_VERIFY
+	Opt_ref_verify,
+#endif
 	Opt_err,
 };
 
@@ -387,6 +390,9 @@ static const match_table_t tokens = {
 	{Opt_fragment_metadata, "fragment=metadata"},
 	{Opt_fragment_all, "fragment=all"},
 #endif
+#ifdef CONFIG_BTRFS_FS_REF_VERIFY
+	{Opt_ref_verify, "ref_verify"},
+#endif
 	{Opt_err, NULL},
 };
 
@@ -817,6 +823,13 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 			btrfs_set_opt(info->mount_opt, FRAGMENT_DATA);
 			break;
 #endif
+#ifdef CONFIG_BTRFS_FS_REF_VERIFY
+		case Opt_ref_verify:
+			btrfs_info(info, "doing ref verification");
+			btrfs_set_opt(info->mount_opt,
+				      REF_VERIFY);
+			break;
+#endif
 		case Opt_err:
 			btrfs_info(info, "unrecognized mount option '%s'", p);
 			ret = -EINVAL;
@@ -1295,6 +1308,10 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
 	if (btrfs_test_opt(info, FRAGMENT_METADATA))
 		seq_puts(seq, ",fragment=metadata");
 #endif
+#ifdef CONFIG_BTRFS_FS_REF_VERIFY
+	if (btrfs_test_opt(info, REF_VERIFY))
+		seq_puts(seq, ",ref_verify");
+#endif
 	seq_printf(seq, ",subvolid=%llu",
 		  BTRFS_I(d_inode(dentry))->root->root_key.objectid);
 	seq_puts(seq, ",subvol=");
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index da9d802..34b6070 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -717,7 +717,7 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 			ret = btrfs_lookup_data_extent(fs_info, ins.objectid,
 						ins.offset);
 			if (ret == 0) {
-				ret = btrfs_inc_extent_ref(trans, fs_info,
+				ret = btrfs_inc_extent_ref(trans, root,
 						ins.objectid, ins.offset,
 						0, root->root_key.objectid,
 						key->objectid, offset);
-- 
2.7.4

