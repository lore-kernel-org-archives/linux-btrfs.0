From: Sage Weil <sage@newdream.net>
Subject: [PATCH] btrfs: mnt_drop_write in ioctl_trans_end
Date: Thu, 11 Dec 2008 11:46:18 -0800
Message-ID: <1229024778-23019-1-git-send-email-sage@newdream.net>
Cc: Sage Weil <sage@newdream.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Add missing mnt_drop_write to match the mnt_want_write in
btrfs_ioctl_trans_start.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/btrfs/ioctl.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 6228b69..69c4a07 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1059,6 +1059,8 @@ long btrfs_ioctl_trans_end(struct file *file)
 	root->fs_info->open_ioctl_trans--;
 	mutex_unlock(&root->fs_info->trans_mutex);
 
+	mnt_drop_write(file->f_path.mnt);
+
 out:
 	return ret;
 }
-- 
1.5.6.5

