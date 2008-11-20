From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH] fix panic on error during mount
Date: Thu, 20 Nov 2008 14:23:10 -0500
Message-ID: <20081120192309.GE3013@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

This needs to be applied on top of my previous patches, but is needed for more
than just my new stuff.  We're going to the wrong label when we have an error,
we try to stop the workers, but they are started below all of this code.  This
fixes it so we go to the right error label and not panic when we fail one of
these cases.  Thank you,

Signed-off-by: Josef Bacik <jbacik@redhat.com>

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 58ce2a0..6047858 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1578,12 +1578,12 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 
 	disk_super = &fs_info->super_copy;
 	if (!btrfs_super_root(disk_super))
-		goto fail_sb_buffer;
+		goto fail_iput;
 
 	ret = btrfs_parse_options(tree_root, options);
 	if (ret) {
 		err = ret;
-		goto fail_sb_buffer;
+		goto fail_iput;
 	}
 
 	features = btrfs_super_incompat_flags(disk_super) &
@@ -1593,7 +1593,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 		       "unsupported optional features (%Lx).\n",
 		       features);
 		err = -EINVAL;
-		goto fail_sb_buffer;
+		goto fail_iput;
 	}
 
 	features = btrfs_super_compat_ro_flags(disk_super) &
@@ -1603,7 +1603,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 		       "unsupported option features (%Lx).\n",
 		       features);
 		err = -EINVAL;
-		goto fail_sb_buffer;
+		goto fail_iput;
 	}
 
 	/*
