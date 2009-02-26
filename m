From: "Lee Trager" <lt73@cs.drexel.edu>
Subject: Re: experimental branch rebased
Date: Thu, 26 Feb 2009 14:05:27 -0500
Message-ID: <20090226190527.GA13057@tux64-01>
References: <1235663145.4631.11.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	Steven Pratt <slpratt@austin.ibm.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1235663145.4631.11.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

I have also cleaned up the backport experimental patch so it applies
cleanly on the latest code.

Lee

diff -Naur btrfs-orig/async-thread.c btrfs/async-thread.c
--- btrfs-orig/async-thread.c	2009-02-26 13:07:03.000000000 -0500
+++ btrfs/async-thread.c	2009-02-26 13:09:18.000000000 -0500
@@ -20,7 +20,10 @@
 #include <linux/list.h>
 #include <linux/spinlock.h>
 #include <linux/freezer.h>
+#include <linux/version.h>
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 27)
 #include <linux/ftrace.h>
+#endif
 #include "async-thread.h"
 
 #define WORK_QUEUED_BIT 0
diff -Naur btrfs-orig/compat.h btrfs/compat.h
--- btrfs-orig/compat.h	2009-02-26 13:07:03.000000000 -0500
+++ btrfs/compat.h	2009-02-26 13:09:18.000000000 -0500
@@ -1,7 +1,33 @@
 #ifndef _COMPAT_H_
 #define _COMPAT_H_
 
+#include <linux/version.h>
+
 #define btrfs_drop_nlink(inode) drop_nlink(inode)
 #define btrfs_inc_nlink(inode)	inc_nlink(inode)
 
+#if LINUX_VERSION_CODE <= KERNEL_VERSION(2, 6, 27)
+static inline struct dentry *d_obtain_alias(struct inode *inode)
+{
+	struct dentry *d;
+
+	if (!inode)
+		return NULL;
+	if (IS_ERR(inode))
+		return ERR_CAST(inode);
+
+	d = d_alloc_anon(inode);
+	if (!d)
+		iput(inode);
+	return d;
+}
+#endif
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 28)
+#define __pagevec_lru_add_file __pagevec_lru_add
+#define open_bdev_exclusive open_bdev_excl
+#define close_bdev_exclusive(bdev, mode) close_bdev_excl(bdev)
+typedef unsigned __bitwise__ fmode_t;
+#endif
+
 #endif /* _COMPAT_H_ */
diff -Naur btrfs-orig/export.h btrfs/export.h
--- btrfs-orig/export.h	2009-02-26 13:07:05.000000000 -0500
+++ btrfs/export.h	2009-02-26 13:09:56.000000000 -0500
@@ -16,4 +16,32 @@
 	u64 parent_root_objectid;
 } __attribute__ ((packed));
 
+// BTRFS needs the btrfs from fid_type which was added in 2.6.27
+// All I did was copy the btrfs defse which was found in
+// linux-2.6.27/include/linux/exportfs.h
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 27)
+enum btrfs_fid_type {
+	/*
+	 * 64 bit object ID, 64 bit root object ID,
+	 * 32 bit generation number.
+	 */
+	FILEID_BTRFS_WITHOUT_PARENT = 0x4d,
+
+	/*
+	 * 64 bit object ID, 64 bit root object ID,
+	 * 32 bit generation number,
+	 * 64 bit parent object ID, 32 bit parent generation.
+	 */
+	FILEID_BTRFS_WITH_PARENT = 0x4e,
+
+	/*
+	 * 64 bit object ID, 64 bit root object ID,
+	 * 32 bit generation number,
+	 * 64 bit parent object ID, 32 bit parent generation,
+	 * 64 bit parent root object ID.
+	 */
+	FILEID_BTRFS_WITH_PARENT_ROOT = 0x4f,
+};
+#endif
+
 #endif
diff -Naur btrfs-orig/extent_io.c btrfs/extent_io.c
--- btrfs-orig/extent_io.c	2009-02-26 13:07:06.000000000 -0500
+++ btrfs/extent_io.c	2009-02-26 13:09:56.000000000 -0500
@@ -2847,6 +2847,7 @@
 	return sector;
 }
 
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 29)
 int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		__u64 start, __u64 len, get_extent_t *get_extent)
 {
@@ -2938,6 +2939,7 @@
 			GFP_NOFS);
 	return ret;
 }
+#endif
 
 static inline struct page *extent_buffer_page(struct extent_buffer *eb,
 					      unsigned long i)
@@ -3163,13 +3165,21 @@
 			}
 		}
 		clear_page_dirty_for_io(page);
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 27)
 		spin_lock_irq(&page->mapping->tree_lock);
+#else
+		read_lock_irq(&page->mapping->tree_lock);
+#endif
 		if (!PageDirty(page)) {
 			radix_tree_tag_clear(&page->mapping->page_tree,
 						page_index(page),
 						PAGECACHE_TAG_DIRTY);
 		}
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 27)
 		spin_unlock_irq(&page->mapping->tree_lock);
+#else
+		read_unlock_irq(&page->mapping->tree_lock);
+#endif
 		unlock_page(page);
 	}
 	return 0;
@@ -3347,7 +3357,11 @@
 	for (i = start_i; i < num_pages; i++) {
 		page = extent_buffer_page(eb, i);
 		if (!wait) {
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 27)
 			if (!trylock_page(page))
+#else
+			if(!TestSetPageLocked(page))
+#endif
 				goto unlock_exit;
 		} else {
 			lock_page(page);
diff -Naur btrfs-orig/extent_io.h btrfs/extent_io.h
--- btrfs-orig/extent_io.h	2009-02-26 13:07:06.000000000 -0500
+++ btrfs/extent_io.h	2009-02-26 13:09:56.000000000 -0500
@@ -2,6 +2,7 @@
 #define __EXTENTIO__
 
 #include <linux/rbtree.h>
+#include <linux/version.h>
 
 /* bits for the extent state */
 #define EXTENT_DIRTY 1
@@ -205,8 +206,10 @@
 			unsigned from, unsigned to);
 sector_t extent_bmap(struct address_space *mapping, sector_t iblock,
 		get_extent_t *get_extent);
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 29)
 int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		__u64 start, __u64 len, get_extent_t *get_extent);
+#endif
 int set_range_dirty(struct extent_io_tree *tree, u64 start, u64 end);
 int set_state_private(struct extent_io_tree *tree, u64 start, u64 private);
 int get_state_private(struct extent_io_tree *tree, u64 start, u64 *private);
diff -Naur btrfs-orig/extent-tree.c btrfs/extent-tree.c
--- btrfs-orig/extent-tree.c	2009-02-26 13:07:06.000000000 -0500
+++ btrfs/extent-tree.c	2009-02-26 13:09:56.000000000 -0500
@@ -870,7 +870,11 @@
 static void btrfs_issue_discard(struct block_device *bdev,
 				u64 start, u64 len)
 {
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 28)
 	blkdev_issue_discard(bdev, start >> 9, len >> 9, GFP_KERNEL);
+#else
+	blkdev_issue_discard(bdev, start >> 9, len >> 9);
+#endif
 }
 #endif
 
diff -Naur btrfs-orig/file.c btrfs/file.c
--- btrfs-orig/file.c	2009-02-26 13:07:06.000000000 -0500
+++ btrfs/file.c	2009-02-26 13:09:56.000000000 -0500
@@ -1042,7 +1042,11 @@
 	if (count == 0)
 		goto out_nolock;
 
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 27)
 	err = file_remove_suid(file);
+#else
+	err = remove_suid(fdentry(file));
+#endif
 	if (err)
 		goto out_nolock;
 	file_update_time(file);
diff -Naur btrfs-orig/inode.c btrfs/inode.c
--- btrfs-orig/inode.c	2009-02-26 13:07:07.000000000 -0500
+++ btrfs/inode.c	2009-02-26 13:09:56.000000000 -0500
@@ -3456,14 +3456,22 @@
 	if (objectid > root->highest_inode)
 		root->highest_inode = objectid;
 
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 27)
 	inode->i_uid = current_fsuid();
+#else
+	inode->i_uid = current->fsuid;
+#endif
 
 	if (dir && (dir->i_mode & S_ISGID)) {
 		inode->i_gid = dir->i_gid;
 		if (S_ISDIR(mode))
 			mode |= S_ISGID;
 	} else
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 27)
 		inode->i_gid = current_fsgid();
+#else
+		inode->i_gid = current->fsgid;
+#endif
 
 	inode->i_mode = mode;
 	inode->i_ino = objectid;
@@ -4164,11 +4172,13 @@
 	return -EINVAL;
 }
 
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 29)
 static int btrfs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		__u64 start, __u64 len)
 {
 	return extent_fiemap(inode, fieinfo, start, len, btrfs_get_extent);
 }
+#endif
 
 int btrfs_readpage(struct file *file, struct page *page)
 {
@@ -4500,7 +4510,11 @@
 	kmem_cache_free(btrfs_inode_cachep, BTRFS_I(inode));
 }
 
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 27)
 static void init_once(void *foo)
+#else
+static void init_once(struct kmem_cache *bar, void *foo)
+#endif
 {
 	struct btrfs_inode *ei = (struct btrfs_inode *) foo;
 
@@ -4523,7 +4537,12 @@
 
 struct kmem_cache *btrfs_cache_create(const char *name, size_t size,
 				       unsigned long extra_flags,
-				       void (*ctor)(void *))
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 27)
+				       void (*ctor)(void *)
+#else
+				       void (*ctor)(struct kmem_cache *, void*)
+#endif
+)
 {
 	return kmem_cache_create(name, size, 0, (SLAB_RECLAIM_ACCOUNT |
 				 SLAB_MEM_SPREAD | extra_flags), ctor);
@@ -4942,7 +4961,12 @@
 	return __set_page_dirty_nobuffers(page);
 }
 
+#if LINUX_VERSION_CODE > KERNEL_VERSION(2, 6, 26)
 static int btrfs_permission(struct inode *inode, int mask)
+#else
+static int btrfs_permission(struct inode *inode, int mask,
+			    struct nameidata *nd)
+#endif
 {
 	if (btrfs_test_flag(inode, READONLY) && (mask & MAY_WRITE))
 		return -EACCES;
@@ -5036,7 +5060,9 @@
 	.removexattr	= btrfs_removexattr,
 	.permission	= btrfs_permission,
 	.fallocate	= btrfs_fallocate,
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 29)
 	.fiemap		= btrfs_fiemap,
+#endif
 };
 static struct inode_operations btrfs_special_inode_operations = {
 	.getattr	= btrfs_getattr,
diff -Naur btrfs-orig/ioctl.c btrfs/ioctl.c
--- btrfs-orig/ioctl.c	2009-02-26 13:07:07.000000000 -0500
+++ btrfs/ioctl.c	2009-02-26 13:09:56.000000000 -0500
@@ -240,7 +240,11 @@
 		return -EEXIST;
 	if (IS_DEADDIR(dir))
 		return -ENOENT;
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 27)
 	return inode_permission(dir, MAY_WRITE | MAY_EXEC);
+#else
+	return permission(dir, MAY_WRITE | MAY_EXEC, NULL);
+#endif
 }
 
 /*
diff -Naur btrfs-orig/super.c btrfs/super.c
--- btrfs-orig/super.c	2009-02-26 13:07:10.000000000 -0500
+++ btrfs/super.c	2009-02-26 13:09:56.000000000 -0500
@@ -38,6 +38,7 @@
 #include <linux/namei.h>
 #include <linux/miscdevice.h>
 #include <linux/magic.h>
+#include <linux/version.h>
 #include "compat.h"
 #include "ctree.h"
 #include "disk-io.h"
@@ -51,6 +52,9 @@
 #include "export.h"
 #include "compression.h"
 
+#ifndef BTRFS_SUPER_MAGIC
+#define BTRFS_SUPER_MAGIC	0x9123683E
+#endif
 
 static struct super_operations btrfs_super_ops;
 
@@ -609,6 +613,8 @@
 	return ret;
 }
 
+
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 29)
 static int btrfs_freeze(struct super_block *sb)
 {
 	struct btrfs_root *root = btrfs_sb(sb);
@@ -617,6 +623,7 @@
 	return 0;
 }
 
+
 static int btrfs_unfreeze(struct super_block *sb)
 {
 	struct btrfs_root *root = btrfs_sb(sb);
@@ -625,6 +632,27 @@
 	return 0;
 }
 
+
+#else
+
+
+static void btrfs_write_super_lockfs(struct super_block *sb)
+{
+	struct btrfs_root *root = btrfs_sb(sb);
+	mutex_lock(&root->fs_info->transaction_kthread_mutex);
+	mutex_lock(&root->fs_info->cleaner_mutex);
+}
+
+
+static void btrfs_unlockfs(struct super_block *sb)
+{
+	struct btrfs_root *root = btrfs_sb(sb);
+	mutex_unlock(&root->fs_info->cleaner_mutex);
+	mutex_unlock(&root->fs_info->transaction_kthread_mutex);
+}
+#endif
+
+
 static struct super_operations btrfs_super_ops = {
 	.delete_inode	= btrfs_delete_inode,
 	.put_super	= btrfs_put_super,
@@ -637,8 +665,13 @@
 	.destroy_inode	= btrfs_destroy_inode,
 	.statfs		= btrfs_statfs,
 	.remount_fs	= btrfs_remount,
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 29)
 	.freeze_fs	= btrfs_freeze,
 	.unfreeze_fs	= btrfs_unfreeze,
+#else
+	.write_super_lockfs	= btrfs_write_super_lockfs,
+	.unlockfs		= btrfs_unlockfs,
+#endif
 };
 
 static const struct file_operations btrfs_ctl_fops = {
