From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 18/21] Btrfs: allow for resuming restriper after it was paused
Date: Tue, 23 Aug 2011 23:01:59 +0300
Message-ID: <1314129722-31601-19-git-send-email-idryomov@gmail.com>
References: <1314129722-31601-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>,
	Hugo Mills <hugo@carfax.org.uk>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1314129722-31601-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Implement an ioctl for resuming restriper.  We use the same heuristics
used when recovering restripe after a crash to try to start where we
left off last time.  If needed those parameters can be made configurable
through the userspace "resume" command in future.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/ioctl.c   |    2 ++
 fs/btrfs/ioctl.h   |    1 +
 fs/btrfs/volumes.c |   25 +++++++++++++++++++++++++
 fs/btrfs/volumes.h |    1 +
 4 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 61978ac..cb2f420 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2923,6 +2923,8 @@ static long btrfs_ioctl_restripe_ctl(struct btrfs_root *root,
 		return btrfs_cancel_restripe(root->fs_info);
 	case BTRFS_RESTRIPE_CTL_PAUSE:
 		return btrfs_pause_restripe(root->fs_info, 0);
+	case BTRFS_RESTRIPE_CTL_RESUME:
+		return btrfs_resume_restripe(root->fs_info);
 	}
 
 	return -EINVAL;
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index e468d5b..365d06c 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -111,6 +111,7 @@ struct btrfs_ioctl_fs_info_args {
 
 #define BTRFS_RESTRIPE_CTL_CANCEL	1
 #define BTRFS_RESTRIPE_CTL_PAUSE	2
+#define BTRFS_RESTRIPE_CTL_RESUME	3
 
 struct btrfs_restripe_args {
 	__u64 profiles;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 65deaa7..bfe2b03 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2898,6 +2898,31 @@ out:
 	return ret;
 }
 
+int btrfs_resume_restripe(struct btrfs_fs_info *fs_info)
+{
+	int ret;
+
+	if (fs_info->sb->s_flags & MS_RDONLY)
+		return -EROFS;
+
+	mutex_lock(&fs_info->restripe_mutex);
+	if (!fs_info->restripe_ctl) {
+		ret = -ENOTCONN;
+		goto out;
+	}
+
+	if (test_bit(RESTRIPE_RUNNING, &fs_info->restripe_state)) {
+		ret = -EINPROGRESS;
+		goto out;
+	}
+
+	ret = btrfs_restripe(fs_info->restripe_ctl, 1);
+
+out:
+	mutex_unlock(&fs_info->restripe_mutex);
+	return ret;
+}
+
 /*
  * shrinking a device means finding all of the device extents past
  * the new size, and then following the back refs to the chunks.
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index b8c234a..c0652c9 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -263,6 +263,7 @@ int btrfs_restripe(struct restripe_control *rctl, int resume);
 int btrfs_recover_restripe(struct btrfs_root *tree_root);
 int btrfs_cancel_restripe(struct btrfs_fs_info *fs_info);
 int btrfs_pause_restripe(struct btrfs_fs_info *fs_info, int unset);
+int btrfs_resume_restripe(struct btrfs_fs_info *fs_info);
 int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset);
 int find_free_dev_extent(struct btrfs_trans_handle *trans,
 			 struct btrfs_device *device, u64 num_bytes,
-- 
1.7.5.4

