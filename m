From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] btrfs: return EINVAL if start > total_bytes in fitrim ioctl
Date: Mon,  5 Sep 2011 16:34:54 +0200
Message-ID: <1315233294-27240-1-git-send-email-lczerner@redhat.com>
Cc: jbacik@redhat.com, Lukas Czerner <lczerner@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We should retirn EINVAL if the start is beyond the end of the file
system in the btrfs_ioctl_fitrim(). Fix that by adding the appropriate
check for it.

Also in the btrfs_trim_fs() it is possible that len+start might overflow
if big values are passed. Fix it by decrementing the len so that start+len
is equal to the file system size in the worst case.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/btrfs/ioctl.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 970977a..ad890ee 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -277,6 +277,7 @@ static noinline int btrfs_ioctl_fitrim(struct file *file, void __user *arg)
 	struct fstrim_range range;
 	u64 minlen = ULLONG_MAX;
 	u64 num_devices = 0;
+	u64 total_bytes = btrfs_super_total_bytes(&root->fs_info->super_copy);
 	int ret;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -295,12 +296,15 @@ static noinline int btrfs_ioctl_fitrim(struct file *file, void __user *arg)
 		}
 	}
 	rcu_read_unlock();
+
 	if (!num_devices)
 		return -EOPNOTSUPP;
-
 	if (copy_from_user(&range, arg, sizeof(range)))
 		return -EFAULT;
+	if (range.start > total_bytes)
+		return -EINVAL;
 
+	range.len = min(range.len, total_bytes - range.start);
 	range.minlen = max(range.minlen, minlen);
 	ret = btrfs_trim_fs(root, &range);
 	if (ret < 0)
-- 
1.7.4.4

