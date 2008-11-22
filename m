From: Sage Weil <sage@newdream.net>
Subject: [PATCH] btrfs: remove unneeded btrfs_start_delalloc_inodes call
Date: Fri, 21 Nov 2008 21:44:07 -0800
Message-ID: <1227332647-1501-2-git-send-email-sage@newdream.net>
References: <1227332647-1501-1-git-send-email-sage@newdream.net>
Cc: Sage Weil <sage@newdream.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1227332647-1501-1-git-send-email-sage@newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

It is called by btrfs_sync_fs.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/btrfs/ioctl.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index f3d6845..35f650e 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1142,7 +1142,6 @@ long btrfs_ioctl(struct file *file, unsigned int
 	case BTRFS_IOC_TRANS_END:
 		return btrfs_ioctl_trans_end(file);
 	case BTRFS_IOC_SYNC:
-		btrfs_start_delalloc_inodes(root);
 		btrfs_sync_fs(file->f_dentry->d_sb, 1);
 		return 0;
 	}
-- 
1.5.6.5

