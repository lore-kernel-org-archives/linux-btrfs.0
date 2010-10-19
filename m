From: Sage Weil <sage@newdream.net>
Subject: [PATCH 3/3] Btrfs: fix lockdep warning on clone ioctl
Date: Tue, 19 Oct 2010 15:22:12 -0700
Message-ID: <1287526932-28369-4-git-send-email-sage@newdream.net>
References: <1287526932-28369-1-git-send-email-sage@newdream.net>
Cc: Sage Weil <sage@newdream.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1287526932-28369-1-git-send-email-sage@newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

I'm no lockdep expert, but this appears to make the lockdep warning go
away for the i_mutex locking in the clone ioctl.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/btrfs/ioctl.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index f4a3dde..3f27529 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1502,11 +1502,11 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 	path->reada = 2;
 
 	if (inode < src) {
-		mutex_lock(&inode->i_mutex);
-		mutex_lock(&src->i_mutex);
+		mutex_lock_nested(&inode->i_mutex, I_MUTEX_PARENT);
+		mutex_lock_nested(&src->i_mutex, I_MUTEX_CHILD);
 	} else {
-		mutex_lock(&src->i_mutex);
-		mutex_lock(&inode->i_mutex);
+		mutex_lock_nested(&src->i_mutex, I_MUTEX_PARENT);
+		mutex_lock_nested(&inode->i_mutex, I_MUTEX_CHILD);
 	}
 
 	/* determine range to clone */
-- 
1.7.0.4

