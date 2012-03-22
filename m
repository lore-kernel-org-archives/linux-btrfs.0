From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 34/35] btrfs: enhance superblock sanity checks
Date: Wed, 21 Mar 2012 21:11:38 -0400
Message-ID: <20120322011137.776809504@suse.com>
References: <20120322011104.212214639@suse.com>
Cc: David Sterba <dsterba@suse.com>, David Sterba <dsterba@suse.cz>
To: Linux Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Validate checksum algorithm during mount and prevent BUG_ON later in
btrfs_super_csum_size.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/disk-io.c |   23 ++++++++++++++++++-----
 1 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 438993e..38c2ee1 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -48,7 +48,7 @@
 static struct extent_io_ops btree_extent_io_ops;
 static void end_workqueue_fn(struct btrfs_work *work);
 static void free_fs_root(struct btrfs_root *root);
-static void btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
+static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
 				    int read_only);
 static void btrfs_destroy_ordered_operations(struct btrfs_root *root);
 static void btrfs_destroy_ordered_extents(struct btrfs_root *root);
@@ -2135,7 +2135,12 @@ int open_ctree(struct super_block *sb,
 	/* check FS state, whether FS is broken. */
 	fs_info->fs_state |= btrfs_super_flags(disk_super);
 
-	btrfs_check_super_valid(fs_info, sb->s_flags & MS_RDONLY);
+	ret = btrfs_check_super_valid(fs_info, sb->s_flags & MS_RDONLY);
+	if (ret) {
+		printk(KERN_ERR "btrfs: superblock contains fatal errors\n");
+		err = ret;
+		goto fail_alloc;
+	}
 
 	/*
 	 * run through our array of backup supers and setup
@@ -3324,15 +3329,23 @@ out:
 	return 0;
 }
 
-static void btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
+static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
 			      int read_only)
 {
+	if (btrfs_super_csum_type(fs_info->super_copy) >= ARRAY_SIZE(btrfs_csum_sizes)) {
+		printk(KERN_ERR "btrfs: unsupported checksum algorithm\n");
+		return -EINVAL;
+	}
+
 	if (read_only)
-		return;
+		return 0;
 
-	if (fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR)
+	if (fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR) {
 		printk(KERN_WARNING "warning: mount fs with errors, "
 		       "running btrfsck is recommended\n");
+	}
+
+	return 0;
 }
 
 int btrfs_error_commit_super(struct btrfs_root *root)
-- 
1.7.9



