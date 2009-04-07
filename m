From: Dan Carpenter <error27@gmail.com>
Subject: [patch] error handling of ERR_PTR() returns
Date: Tue, 7 Apr 2009 16:38:42 +0300 (EAT)
Message-ID: <alpine.DEB.2.00.0904071632560.1465@bicker>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

There are a couple functions which return ERR_PTR as well as NULL.  The 
caller needs to handle both.

Smatch also complains about the handling of alloc_extent_map() but as far 
as I can see that doesn't actually return an ERR_PTR.

Compile tested on 2.6.29.

regards,
dan carpenter

--- orig/fs/btrfs/disk-io.c	2009-04-07 16:15:36.000000000 +0300
+++ devel/fs/btrfs/disk-io.c	2009-04-07 16:23:33.000000000 +0300
@@ -123,7 +123,7 @@
 
 	spin_lock(&em_tree->lock);
 	em = lookup_extent_mapping(em_tree, start, len);
-	if (em) {
+	if (!IS_ERR(em) && em) {
 		em->bdev =
 			BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev;
 		spin_unlock(&em_tree->lock);
@@ -1216,8 +1216,8 @@
 	int ret;
 
 	root = btrfs_read_fs_root_no_name(fs_info, location);
-	if (!root)
-		return NULL;
+	if (!root || IS_ERR(root))
+		return root;
 
 	if (root->in_sysfs)
 		return root;
@@ -1324,7 +1324,7 @@
 	spin_lock(&em_tree->lock);
 	em = lookup_extent_mapping(em_tree, offset, PAGE_CACHE_SIZE);
 	spin_unlock(&em_tree->lock);
-	if (!em) {
+	if (!em || IS_ERR(em)) {
 		__unplug_io_fn(bdi, page);
 		return;
 	}
