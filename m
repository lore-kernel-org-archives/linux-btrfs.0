From: Jan Engelhardt <jengelh@medozas.de>
Subject: btrfs-bdi.patch
Date: Sun, 1 Jun 2008 21:04:57 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0806012104200.4055@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


This one has not been applied for btrfs 0.15 yet.

---
 btrfs/disk-io.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: btrfs-0.14/btrfs/disk-io.c
===================================================================
--- btrfs-0.14.orig/btrfs/disk-io.c
+++ btrfs-0.14/btrfs/disk-io.c
@@ -968,7 +968,7 @@ void btrfs_unplug_io_fn(struct backing_d
 
 static int setup_bdi(struct btrfs_fs_info *info, struct backing_dev_info *bdi)
 {
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,23)
+#if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,23)
 	bdi_init(bdi);
 #endif
 	bdi->ra_pages	= default_backing_dev_info.ra_pages;
@@ -1349,7 +1349,7 @@ fail:
 
 	kfree(extent_root);
 	kfree(tree_root);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,23)
+#if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,23)
 	bdi_destroy(&fs_info->bdi);
 #endif
 	kfree(fs_info);
@@ -1608,7 +1608,7 @@ int close_ctree(struct btrfs_root *root)
 	close_all_devices(fs_info);
 	btrfs_mapping_tree_free(&fs_info->mapping_tree);
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,23)
+#if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,23)
 	bdi_destroy(&fs_info->bdi);
 #endif
 

