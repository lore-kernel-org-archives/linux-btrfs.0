From: Sven Wegener <sven.wegener@stealer.net>
Subject: [PATCH] Add compability for kernels >=2.6.27-rc1
Date: Wed, 30 Jul 2008 21:11:34 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0807302100500.2294@titan.stealer.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Add a couple of #if's to follow API changes.

Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
---
 extent_io.c |   16 ++++++++++++++++
 file.c      |    4 ++++
 inode.c     |   12 ++++++++++--
 3 files changed, 30 insertions(+), 2 deletions(-)

Having passed the rc1 mark the API changes should be finished.

Other #if in the source use >version instead of >=version+1, so I use them 
too.

Patch is against the current unstable repository, but can applied with a 
slight modification (extent_io.c) to the stable repository too.

diff -r 59ec68fb1540 extent_io.c
--- a/extent_io.c	Wed Jul 30 10:29:12 2008 -0400
+++ b/extent_io.c	Wed Jul 30 19:00:28 2008 +0000
@@ -2649,9 +2649,17 @@
 	mapping = eb->first_page->mapping;
 	if (!mapping)
 		return NULL;
+#if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,26)
+	spin_lock_irq(&mapping->tree_lock);
+#else
 	read_lock_irq(&mapping->tree_lock);
+#endif
 	p = radix_tree_lookup(&mapping->page_tree, i);
+#if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,26)
+	spin_unlock_irq(&mapping->tree_lock);
+#else
 	read_unlock_irq(&mapping->tree_lock);
+#endif
 	return p;
 }
 
@@ -2843,13 +2851,21 @@
 			}
 		}
 		clear_page_dirty_for_io(page);
+#if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,26)
+		spin_lock_irq(&page->mapping->tree_lock);
+#else
 		read_lock_irq(&page->mapping->tree_lock);
+#endif
 		if (!PageDirty(page)) {
 			radix_tree_tag_clear(&page->mapping->page_tree,
 						page_index(page),
 						PAGECACHE_TAG_DIRTY);
 		}
+#if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,26)
+		spin_unlock_irq(&page->mapping->tree_lock);
+#else
 		read_unlock_irq(&page->mapping->tree_lock);
+#endif
 		unlock_page(page);
 	}
 	return 0;
diff -r 59ec68fb1540 file.c
--- a/file.c	Wed Jul 30 10:29:12 2008 -0400
+++ b/file.c	Wed Jul 30 19:00:28 2008 +0000
@@ -886,7 +886,11 @@
 #ifdef REMOVE_SUID_PATH
 	err = remove_suid(&file->f_path);
 #else
+#if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,26)
+	err = file_remove_suid(file);
+#else
 	err = remove_suid(fdentry(file));
+#endif
 #endif
 	if (err)
 		goto out_nolock;
diff -r 59ec68fb1540 inode.c
--- a/inode.c	Wed Jul 30 10:29:12 2008 -0400
+++ b/inode.c	Wed Jul 30 19:00:28 2008 +0000
@@ -3293,7 +3293,9 @@
 	kmem_cache_free(btrfs_inode_cachep, BTRFS_I(inode));
 }
 
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,23)
+#if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,26)
+static void init_once(void *foo)
+#elif LINUX_VERSION_CODE > KERNEL_VERSION(2,6,23)
 static void init_once(struct kmem_cache * cachep, void *foo)
 #else
 static void init_once(void * foo, struct kmem_cache * cachep,
@@ -3321,7 +3323,9 @@
 
 struct kmem_cache *btrfs_cache_create(const char *name, size_t size,
 				       unsigned long extra_flags,
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,23)
+#if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,26)
+				       void (*ctor)(void *)
+#elif LINUX_VERSION_CODE > KERNEL_VERSION(2,6,23)
 				       void (*ctor)(struct kmem_cache *, void *)
 #else
 				       void (*ctor)(void *, struct kmem_cache *,
@@ -3561,8 +3565,12 @@
 	return __set_page_dirty_nobuffers(page);
 }
 
+#if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,26)
+static int btrfs_permission(struct inode *inode, int mask)
+#else
 static int btrfs_permission(struct inode *inode, int mask,
 			    struct nameidata *nd)
+#endif
 {
 	if (btrfs_test_flag(inode, READONLY) && (mask & MAY_WRITE))
 		return -EACCES;
