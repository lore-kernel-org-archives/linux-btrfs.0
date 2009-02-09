From: "Lee Trager" <lt73@cs.drexel.edu>
Subject: [PATCH] Backport to 2.6.27 and 2.6.26
Date: Mon, 9 Feb 2009 17:26:30 -0500
Message-ID: <20090209222630.GA12265@tux64-01>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch will allow btrfs-unstable-standalone to compile cleanly
against 2.6.27, 2.6.26, and possibly older(I havn't tested older then
26).

Signed-off-by: Lee Trager <lt73@cs.drexel.edu>

---
 compat.h      |   24 ++++++++++++++++++++++++
 export.h      |   28 ++++++++++++++++++++++++++++
 extent-tree.c |    4 ++++
 extent_io.c   |   12 ++++++++++++
 file.c        |    4 ++++
 inode.c       |   16 +++++++++++++++-
 ioctl.c       |    4 ++++
 7 files changed, 91 insertions(+), 1 deletions(-)

diff --git a/compat.h b/compat.h
index 7c4503e..eedf14c 100644
--- a/compat.h
+++ b/compat.h
@@ -4,4 +4,28 @@
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
diff --git a/export.h b/export.h
index 074348a..63b6a20 100644
--- a/export.h
+++ b/export.h
@@ -16,4 +16,32 @@ struct btrfs_fid {
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
diff --git a/extent-tree.c b/extent-tree.c
index 293da65..2113f5c 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -869,7 +869,11 @@ static noinline int remove_extent_backref(struct btrfs_trans_handle *trans,
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
 
diff --git a/extent_io.c b/extent_io.c
index e086d40..072165c 100644
--- a/extent_io.c
+++ b/extent_io.c
@@ -3078,13 +3078,21 @@ int clear_extent_buffer_dirty(struct extent_io_tree *tree,
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
@@ -3262,7 +3270,11 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
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
diff --git a/file.c b/file.c
index 9026833..f5377b6 100644
--- a/file.c
+++ b/file.c
@@ -1043,7 +1043,11 @@ static ssize_t btrfs_file_write(struct file *file, const char __user *buf,
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
diff --git a/inode.c b/inode.c
index 8adfe05..5eb9125 100644
--- a/inode.c
+++ b/inode.c
@@ -3457,8 +3457,13 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 	if (objectid > root->highest_inode)
 		root->highest_inode = objectid;
 
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 27)
 	inode->i_uid = current_fsuid();
 	inode->i_gid = current_fsgid();
+#else
+	inode->i_uid = current->fsuid;
+	inode->i_gid = current->fsgid;
+#endif
 	inode->i_mode = mode;
 	inode->i_ino = objectid;
 	inode_set_bytes(inode, 0);
@@ -4492,7 +4497,11 @@ void btrfs_destroy_inode(struct inode *inode)
 	kmem_cache_free(btrfs_inode_cachep, BTRFS_I(inode));
 }
 
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 27)
 static void init_once(void *foo)
+#else
+static void init_once(struct kmem_cache *bar, void *foo)
+#endif
 {
 	struct btrfs_inode *ei = (struct btrfs_inode *) foo;
 
@@ -4515,7 +4524,12 @@ void btrfs_destroy_cachep(void)
 
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
diff --git a/ioctl.c b/ioctl.c
index c2aa33e..3bb8807 100644
--- a/ioctl.c
+++ b/ioctl.c
@@ -241,7 +241,11 @@ static inline int btrfs_may_create(struct inode *dir, struct dentry *child)
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
-- 
1.5.6.3

