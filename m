From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH] create/destroy io workqueues on module init/exit
Date: Mon, 16 Jun 2008 13:54:23 -0400
Message-ID: <20080616175423.GA17364@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Theres a problem with btrfs where if you have more than one btrfs fs's mounted,
if you unmount one of the fs's, and then do some work on the other fs, the box
will panic.  This is because in close_ctree() we destroy the two global io
workqueues, even though we're still using them for the other fs.  This patch
moves the creation/destruction of the workqueues to the init/exit parts of the
btrfs module.  I tested with this patch and my panic went away.  Thanks,

Signed-off-by: Josef Bacik <jbacik@redhat.com>


diff -r 9da425337329 disk-io.c
--- a/disk-io.c	Mon Jun 09 09:35:50 2008 -0400
+++ b/disk-io.c	Mon Jun 16 20:56:07 2008 -0400
@@ -1127,6 +1127,28 @@ static void btrfs_async_submit_work(stru
 	}
 }
 
+int btrfs_start_io_workqueues(void)
+{
+	end_io_workqueue = create_workqueue("btrfs-end-io");
+
+	if (!end_io_workqueue)
+		return 1;
+
+	async_submit_workqueue = create_workqueue("btrfs-async-submit");
+	if (!async_submit_workqueue) {
+		destroy_workqueue(async_submit_workqueue);
+		return 1;
+	}
+
+	return 0;
+}
+
+void btrfs_destroy_io_workqueues(void)
+{
+	destroy_workqueue(async_submit_workqueue);
+	destroy_workqueue(end_io_workqueue);
+}
+
 struct btrfs_root *open_ctree(struct super_block *sb,
 			      struct btrfs_fs_devices *fs_devices,
 			      char *options)
@@ -1155,9 +1177,6 @@ struct btrfs_root *open_ctree(struct sup
 		err = -ENOMEM;
 		goto fail;
 	}
-	end_io_workqueue = create_workqueue("btrfs-end-io");
-	BUG_ON(!end_io_workqueue);
-	async_submit_workqueue = create_workqueue("btrfs-async-submit");
 
 	INIT_RADIX_TREE(&fs_info->fs_roots_radix, GFP_NOFS);
 	INIT_LIST_HEAD(&fs_info->trans_list);
@@ -1626,10 +1645,7 @@ int close_ctree(struct btrfs_root *root)
 	truncate_inode_pages(fs_info->btree_inode->i_mapping, 0);
 
 	flush_workqueue(async_submit_workqueue);
-	destroy_workqueue(async_submit_workqueue);
-
 	flush_workqueue(end_io_workqueue);
-	destroy_workqueue(end_io_workqueue);
 
 	iput(fs_info->btree_inode);
 #if 0
diff -r 9da425337329 disk-io.h
--- a/disk-io.h	Mon Jun 09 09:35:50 2008 -0400
+++ b/disk-io.h	Mon Jun 16 20:56:07 2008 -0400
@@ -79,4 +79,6 @@ int btrfs_wq_submit_bio(struct btrfs_fs_
 int btrfs_wq_submit_bio(struct btrfs_fs_info *fs_info, struct inode *inode,
 			int rw, struct bio *bio, int mirror_num,
 			extent_submit_bio_hook_t *submit_bio_hook);
+int btrfs_start_io_workqueues(void);
+void btrfs_destroy_io_workqueues(void);
 #endif
diff -r 9da425337329 super.c
--- a/super.c	Mon Jun 09 09:35:50 2008 -0400
+++ b/super.c	Mon Jun 16 20:56:07 2008 -0400
@@ -548,6 +548,10 @@ static int __init init_btrfs_fs(void)
 	if (err)
 		goto free_extent_io;
 
+	err = btrfs_start_io_workqueues();
+	if (err)
+		goto free_extent_map;
+
 	err = btrfs_interface_init();
 	if (err)
 		goto free_extent_map;
@@ -576,6 +580,7 @@ static void __exit exit_btrfs_fs(void)
 	btrfs_destroy_cachep();
 	extent_map_exit();
 	extent_io_exit();
+	btrfs_destroy_io_workqueues();
 	btrfs_interface_exit();
 	unregister_filesystem(&btrfs_fs_type);
 	btrfs_exit_sysfs();
