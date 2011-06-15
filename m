From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Subject: btrfs: Remove all sysfs entries
Date: Wed, 15 Jun 2011 10:36:40 +0200
Message-ID: <4DF86F18.3010704@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Seems that currently none of the sysfs are created any more, so just
remove sysfs support entirely.

Fixes compiling warnings in 3.0rc3

Signed-off-by: Maarten Lankhorst <m.b.lankhorst@gmail.com>

diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
index 9b72dcf..78fdd86 100644
--- a/fs/btrfs/Makefile
+++ b/fs/btrfs/Makefile
@@ -4,7 +4,7 @@ obj-$(CONFIG_BTRFS_FS) := btrfs.o
 btrfs-y += super.o ctree.o extent-tree.o print-tree.o root-tree.o dir-item.o \
 	   file-item.o inode-item.o inode-map.o disk-io.o \
 	   transaction.o inode.o file.o tree-defrag.o \
-	   extent_map.o sysfs.o struct-funcs.o xattr.o ordered-data.o \
+	   extent_map.o struct-funcs.o xattr.o ordered-data.o \
 	   extent_io.o volumes.o async-thread.o ioctl.o locking.o orphan.o \
 	   export.o tree-log.o acl.o free-space-cache.o zlib.o lzo.o \
 	   compression.o delayed-ref.o relocation.o delayed-inode.o scrub.o
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 378b5b4..6aefbb2 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1181,7 +1181,6 @@ struct btrfs_root {
 	struct btrfs_key defrag_max;
 	int defrag_running;
 	char *name;
-	int in_sysfs;
 
 	/* the dirty list is only used by non-reference counted roots */
 	struct list_head dirty_list;
@@ -2604,10 +2603,6 @@ int btrfs_dirty_pages(struct btrfs_root *root, struct inode *inode,
 int btrfs_defrag_leaves(struct btrfs_trans_handle *trans,
 			struct btrfs_root *root, int cache_only);
 
-/* sysfs.c */
-int btrfs_init_sysfs(void);
-void btrfs_exit_sysfs(void);
-
 /* xattr.c */
 ssize_t btrfs_listxattr(struct dentry *dentry, char *buffer, size_t size);
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 9f68c68..5df6d8f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1044,7 +1044,6 @@ static int __setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
 	root->last_trans = 0;
 	root->highest_objectid = 0;
 	root->name = NULL;
-	root->in_sysfs = 0;
 	root->inode_tree = RB_ROOT;
 	INIT_RADIX_TREE(&root->delayed_nodes_tree, GFP_ATOMIC);
 	root->block_rsv = NULL;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 0bb4ebb..02bf74e 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1228,13 +1228,9 @@ static int __init init_btrfs_fs(void)
 {
 	int err;
 
-	err = btrfs_init_sysfs();
-	if (err)
-		return err;
-
 	err = btrfs_init_compress();
 	if (err)
-		goto free_sysfs;
+		return ret;
 
 	err = btrfs_init_cachep();
 	if (err)
@@ -1275,8 +1271,6 @@ free_cachep:
 	btrfs_destroy_cachep();
 free_compress:
 	btrfs_exit_compress();
-free_sysfs:
-	btrfs_exit_sysfs();
 	return err;
 }
 
@@ -1288,7 +1282,6 @@ static void __exit exit_btrfs_fs(void)
 	extent_io_exit();
 	btrfs_interface_exit();
 	unregister_filesystem(&btrfs_fs_type);
-	btrfs_exit_sysfs();
 	btrfs_cleanup_fs_uuids();
 	btrfs_exit_compress();
 }
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
deleted file mode 100644
index c3c223a..0000000
--- a/fs/btrfs/sysfs.c
+++ /dev/null
@@ -1,192 +0,0 @@
-/*
- * Copyright (C) 2007 Oracle.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License v2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
- */
-
-#include <linux/sched.h>
-#include <linux/slab.h>
-#include <linux/spinlock.h>
-#include <linux/completion.h>
-#include <linux/buffer_head.h>
-#include <linux/module.h>
-#include <linux/kobject.h>
-
-#include "ctree.h"
-#include "disk-io.h"
-#include "transaction.h"
-
-static ssize_t root_blocks_used_show(struct btrfs_root *root, char *buf)
-{
-	return snprintf(buf, PAGE_SIZE, "%llu\n",
-		(unsigned long long)btrfs_root_used(&root->root_item));
-}
-
-static ssize_t root_block_limit_show(struct btrfs_root *root, char *buf)
-{
-	return snprintf(buf, PAGE_SIZE, "%llu\n",
-		(unsigned long long)btrfs_root_limit(&root->root_item));
-}
-
-static ssize_t super_blocks_used_show(struct btrfs_fs_info *fs, char *buf)
-{
-
-	return snprintf(buf, PAGE_SIZE, "%llu\n",
-		(unsigned long long)btrfs_super_bytes_used(&fs->super_copy));
-}
-
-static ssize_t super_total_blocks_show(struct btrfs_fs_info *fs, char *buf)
-{
-	return snprintf(buf, PAGE_SIZE, "%llu\n",
-		(unsigned long long)btrfs_super_total_bytes(&fs->super_copy));
-}
-
-static ssize_t super_blocksize_show(struct btrfs_fs_info *fs, char *buf)
-{
-	return snprintf(buf, PAGE_SIZE, "%llu\n",
-		(unsigned long long)btrfs_super_sectorsize(&fs->super_copy));
-}
-
-/* this is for root attrs (subvols/snapshots) */
-struct btrfs_root_attr {
-	struct attribute attr;
-	ssize_t (*show)(struct btrfs_root *, char *);
-	ssize_t (*store)(struct btrfs_root *, const char *, size_t);
-};
-
-#define ROOT_ATTR(name, mode, show, store) \
-static struct btrfs_root_attr btrfs_root_attr_##name = __ATTR(name, mode, \
-							      show, store)
-
-ROOT_ATTR(blocks_used,	0444,	root_blocks_used_show,	NULL);
-ROOT_ATTR(block_limit,	0644,	root_block_limit_show,	NULL);
-
-static struct attribute *btrfs_root_attrs[] = {
-	&btrfs_root_attr_blocks_used.attr,
-	&btrfs_root_attr_block_limit.attr,
-	NULL,
-};
-
-/* this is for super attrs (actual full fs) */
-struct btrfs_super_attr {
-	struct attribute attr;
-	ssize_t (*show)(struct btrfs_fs_info *, char *);
-	ssize_t (*store)(struct btrfs_fs_info *, const char *, size_t);
-};
-
-#define SUPER_ATTR(name, mode, show, store) \
-static struct btrfs_super_attr btrfs_super_attr_##name = __ATTR(name, mode, \
-								show, store)
-
-SUPER_ATTR(blocks_used,		0444,	super_blocks_used_show,		NULL);
-SUPER_ATTR(total_blocks,	0444,	super_total_blocks_show,	NULL);
-SUPER_ATTR(blocksize,		0444,	super_blocksize_show,		NULL);
-
-static struct attribute *btrfs_super_attrs[] = {
-	&btrfs_super_attr_blocks_used.attr,
-	&btrfs_super_attr_total_blocks.attr,
-	&btrfs_super_attr_blocksize.attr,
-	NULL,
-};
-
-static ssize_t btrfs_super_attr_show(struct kobject *kobj,
-				    struct attribute *attr, char *buf)
-{
-	struct btrfs_fs_info *fs = container_of(kobj, struct btrfs_fs_info,
-						super_kobj);
-	struct btrfs_super_attr *a = container_of(attr,
-						  struct btrfs_super_attr,
-						  attr);
-
-	return a->show ? a->show(fs, buf) : 0;
-}
-
-static ssize_t btrfs_super_attr_store(struct kobject *kobj,
-				     struct attribute *attr,
-				     const char *buf, size_t len)
-{
-	struct btrfs_fs_info *fs = container_of(kobj, struct btrfs_fs_info,
-						super_kobj);
-	struct btrfs_super_attr *a = container_of(attr,
-						  struct btrfs_super_attr,
-						  attr);
-
-	return a->store ? a->store(fs, buf, len) : 0;
-}
-
-static ssize_t btrfs_root_attr_show(struct kobject *kobj,
-				    struct attribute *attr, char *buf)
-{
-	struct btrfs_root *root = container_of(kobj, struct btrfs_root,
-						root_kobj);
-	struct btrfs_root_attr *a = container_of(attr,
-						 struct btrfs_root_attr,
-						 attr);
-
-	return a->show ? a->show(root, buf) : 0;
-}
-
-static ssize_t btrfs_root_attr_store(struct kobject *kobj,
-				     struct attribute *attr,
-				     const char *buf, size_t len)
-{
-	struct btrfs_root *root = container_of(kobj, struct btrfs_root,
-						root_kobj);
-	struct btrfs_root_attr *a = container_of(attr,
-						 struct btrfs_root_attr,
-						 attr);
-	return a->store ? a->store(root, buf, len) : 0;
-}
-
-static void btrfs_super_release(struct kobject *kobj)
-{
-	struct btrfs_fs_info *fs = container_of(kobj, struct btrfs_fs_info,
-						super_kobj);
-	complete(&fs->kobj_unregister);
-}
-
-static void btrfs_root_release(struct kobject *kobj)
-{
-	struct btrfs_root *root = container_of(kobj, struct btrfs_root,
-						root_kobj);
-	complete(&root->kobj_unregister);
-}
-
-static const struct sysfs_ops btrfs_super_attr_ops = {
-	.show	= btrfs_super_attr_show,
-	.store	= btrfs_super_attr_store,
-};
-
-static const struct sysfs_ops btrfs_root_attr_ops = {
-	.show	= btrfs_root_attr_show,
-	.store	= btrfs_root_attr_store,
-};
-
-/* /sys/fs/btrfs/ entry */
-static struct kset *btrfs_kset;
-
-int btrfs_init_sysfs(void)
-{
-	btrfs_kset = kset_create_and_add("btrfs", NULL, fs_kobj);
-	if (!btrfs_kset)
-		return -ENOMEM;
-	return 0;
-}
-
-void btrfs_exit_sysfs(void)
-{
-	kset_unregister(btrfs_kset);
-}
-


