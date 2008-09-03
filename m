From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] btrfs: trivial sparse fixes
Date: Wed, 3 Sep 2008 20:16:24 +0200
Message-ID: <20080903181624.GA17704@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Fix a bunch of trivial sparse complaints.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: btrfs-unstable/ctree.c
===================================================================
--- btrfs-unstable.orig/ctree.c	2008-08-31 15:35:50.000000000 -0300
+++ btrfs-unstable/ctree.c	2008-08-31 15:46:30.000000000 -0300
@@ -2741,7 +2741,6 @@ int btrfs_insert_empty_items(struct btrf
 	BUG_ON(slot < 0);
 
 	if (slot != nritems) {
-		int i;
 		unsigned int old_data = btrfs_item_end_nr(leaf, slot);
 
 		if (old_data < data_end) {
@@ -2905,7 +2904,6 @@ int btrfs_del_items(struct btrfs_trans_h
 	nritems = btrfs_header_nritems(leaf);
 
 	if (slot + nr != nritems) {
-		int i;
 		int data_end = leaf_data_end(root, leaf);
 
 		memmove_extent_buffer(leaf, btrfs_leaf_data(leaf) +
Index: btrfs-unstable/extent_io.c
===================================================================
--- btrfs-unstable.orig/extent_io.c	2008-08-31 15:34:32.000000000 -0300
+++ btrfs-unstable/extent_io.c	2008-08-31 15:35:12.000000000 -0300
@@ -3393,10 +3393,8 @@ int try_release_extent_buffer(struct ext
 	}
 	/* at this point we can safely release the extent buffer */
 	num_pages = num_extent_pages(eb->start, eb->len);
-	for (i = 0; i < num_pages; i++) {
-		struct page *page = extent_buffer_page(eb, i);
-		page_cache_release(page);
-	}
+	for (i = 0; i < num_pages; i++)
+		page_cache_release(extent_buffer_page(eb, i));
 	rb_erase(&eb->rb_node, &tree->buffer);
 	__free_extent_buffer(eb);
 out:
Index: btrfs-unstable/ioctl.c
===================================================================
--- btrfs-unstable.orig/ioctl.c	2008-08-31 15:34:13.000000000 -0300
+++ btrfs-unstable/ioctl.c	2008-08-31 15:34:17.000000000 -0300
@@ -739,7 +739,7 @@ long btrfs_ioctl_trans_end(struct file *
 		goto out;
 	}
 	btrfs_end_transaction(trans, root);
-	file->private_data = 0;
+	file->private_data = NULL;
 
 	mutex_lock(&root->fs_info->trans_mutex);
 	root->fs_info->open_ioctl_trans--;
Index: btrfs-unstable/sysfs.c
===================================================================
--- btrfs-unstable.orig/sysfs.c	2008-08-31 15:35:31.000000000 -0300
+++ btrfs-unstable/sysfs.c	2008-08-31 15:35:44.000000000 -0300
@@ -254,7 +254,7 @@ void btrfs_sysfs_del_super(struct btrfs_
 	wait_for_completion(&fs->kobj_unregister);
 }
 
-int btrfs_init_sysfs()
+int btrfs_init_sysfs(void)
 {
 	btrfs_kset = kset_create_and_add("btrfs", NULL, fs_kobj);
 	if (!btrfs_kset)
@@ -262,7 +262,7 @@ int btrfs_init_sysfs()
 	return 0;
 }
 
-void btrfs_exit_sysfs()
+void btrfs_exit_sysfs(void)
 {
 	kset_unregister(btrfs_kset);
 }
@@ -289,12 +289,12 @@ void btrfs_sysfs_del_super(struct btrfs_
 	return;
 }
 
-int btrfs_init_sysfs()
+int btrfs_init_sysfs(void)
 {
 	return 0;
 }
 
-void btrfs_exit_sysfs()
+void btrfs_exit_sysfs(void)
 {
 	return;
 }
