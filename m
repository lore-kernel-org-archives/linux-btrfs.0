From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 20/21] Btrfs: allow for resuming restriper after it was paused
Date: Fri,  6 Jan 2012 16:31:08 +0200
Message-ID: <1325860269-15013-21-git-send-email-idryomov@gmail.com>
References: <1325860269-15013-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1325860269-15013-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Implement an ioctl for resuming restriper.  We use the same heuristics
used when recovering balance after a crash to try to start where we left
off last time.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/ioctl.c   |    2 ++
 fs/btrfs/ioctl.h   |    1 +
 fs/btrfs/volumes.c |   27 +++++++++++++++++++++++++++
 fs/btrfs/volumes.h |    1 +
 4 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index d47ff8e..a83b1a5 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3133,6 +3133,8 @@ static long btrfs_ioctl_balance_ctl(struct btrfs_root *root, int cmd)
 		return btrfs_pause_balance(root->fs_info);
 	case BTRFS_BALANCE_CTL_CANCEL:
 		return btrfs_cancel_balance(root->fs_info);
+	case BTRFS_BALANCE_CTL_RESUME:
+		return btrfs_resume_balance(root->fs_info);
 	}
 
 	return -EINVAL;
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 33ec6d8..c691ef4 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -112,6 +112,7 @@ struct btrfs_ioctl_fs_info_args {
 /* balance control ioctl modes */
 #define BTRFS_BALANCE_CTL_PAUSE		1
 #define BTRFS_BALANCE_CTL_CANCEL	2
+#define BTRFS_BALANCE_CTL_RESUME	3
 
 /*
  * this is packed, because it should be exactly the same as its disk
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f7248c9..d907635 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2859,6 +2859,33 @@ int btrfs_cancel_balance(struct btrfs_fs_info *fs_info)
 	return 0;
 }
 
+int btrfs_resume_balance(struct btrfs_fs_info *fs_info)
+{
+	int ret;
+
+	if (fs_info->sb->s_flags & MS_RDONLY)
+		return -EROFS;
+
+	mutex_lock(&fs_info->volume_mutex);
+	mutex_lock(&fs_info->balance_mutex);
+
+	if (!fs_info->balance_ctl) {
+		ret = -ENOTCONN;
+		goto out;
+	}
+
+	if (atomic_read(&fs_info->balance_running)) {
+		ret = -EINPROGRESS;
+		goto out;
+	}
+
+	ret = btrfs_balance(fs_info->balance_ctl, 1);
+out:
+	mutex_unlock(&fs_info->balance_mutex);
+	mutex_unlock(&fs_info->volume_mutex);
+	return ret;
+}
+
 /*
  * shrinking a device means finding all of the device extents past
  * the new size, and then following the back refs to the chunks.
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 4429efc..6271d8e 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -273,6 +273,7 @@ int btrfs_balance(struct btrfs_balance_control *rctl, int resume);
 int btrfs_recover_balance(struct btrfs_root *tree_root);
 int btrfs_pause_balance(struct btrfs_fs_info *fs_info);
 int btrfs_cancel_balance(struct btrfs_fs_info *fs_info);
+int btrfs_resume_balance(struct btrfs_fs_info *fs_info);
 int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset);
 int find_free_dev_extent(struct btrfs_trans_handle *trans,
 			 struct btrfs_device *device, u64 num_bytes,
-- 
1.7.6.3

