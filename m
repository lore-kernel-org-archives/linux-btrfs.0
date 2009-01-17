From: Qinghuang Feng <qhfeng.kernel@gmail.com>
Subject: [PATCH] Btrfs: fix bug in open_ctree()
Date: Sat, 17 Jan 2009 23:03:38 +0800
Message-ID: <4971f34f.011e6e0a.3bb4.ffff8ae9@mx.google.com>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1762321AbZAQPEM@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

a bug in open_ctree:

struct btrfs_root *open_ctree(..)
{
....
	if (!extent_root || !tree_root || !fs_info ||
	    !chunk_root || !dev_root || !csum_root) {
		err = -ENOMEM;
		goto fail;
//When code flow goes to "fail", fs_info may be NULL or uninitialized.
	}
....

fail:
	btrfs_close_devices(fs_info->fs_devices);// !
	btrfs_mapping_tree_free(&fs_info->mapping_tree);// !

	kfree(extent_root);
	kfree(tree_root);
	bdi_destroy(&fs_info->bdi);// !
...
)

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
---
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 81a3138..f860087 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1828,13 +1828,14 @@ fail_sb_buffer:
 fail_iput:
 	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
 	iput(fs_info->btree_inode);
-fail:
+
 	btrfs_close_devices(fs_info->fs_devices);
 	btrfs_mapping_tree_free(&fs_info->mapping_tree);
+	bdi_destroy(&fs_info->bdi);
 
+fail:
 	kfree(extent_root);
 	kfree(tree_root);
-	bdi_destroy(&fs_info->bdi);
 	kfree(fs_info);
 	kfree(chunk_root);
 	kfree(dev_root);
