From: Josef Bacik <josef@redhat.com>
Subject: [PATCH 2/3] Btrfs: hold i_mutex when calling btrfs_log_dentry_safe
Date: Fri, 19 Nov 2010 15:36:10 -0500
Message-ID: <1290198971-21663-3-git-send-email-josef@redhat.com>
References: <1290198971-21663-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1290198971-21663-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Since we walk up the path logging all of the parts of the inode's path, we need
to hold i_mutex to make sure that the inode is not renamed while we're logging
everything.  btrfs_log_dentry_safe does dget_parent and all of that jazz, but we
may get unexpected results if the rename changes the inode's location while
we're higher up the path logging those dentries, so do this for safety reasons.
Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/file.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index e354c33..c1faded 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1047,8 +1047,14 @@ out:
 
 		if ((file->f_flags & O_DSYNC) || IS_SYNC(inode)) {
 			trans = btrfs_start_transaction(root, 0);
+			if (IS_ERR(trans)) {
+				num_written = PTR_ERR(trans);
+				goto done;
+			}
+			mutex_lock(&inode->i_mutex);
 			ret = btrfs_log_dentry_safe(trans, root,
 						    file->f_dentry);
+			mutex_unlock(&inode->i_mutex);
 			if (ret == 0) {
 				ret = btrfs_sync_log(trans, root);
 				if (ret == 0)
@@ -1067,6 +1073,7 @@ out:
 			     (start_pos + num_written - 1) >> PAGE_CACHE_SHIFT);
 		}
 	}
+done:
 	current->backing_dev_info = NULL;
 	return num_written ? num_written : err;
 }
-- 
1.6.6.1

