From: Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH] btrfs: return EXDEV when linking from different subvolumes
Date: Tue, 22 Mar 2011 10:20:26 -0700
Message-ID: <20110322172026.GO1703@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_link returns EPERM if a cross-subvolume link is attempted.

However, in this case I believe EXDEV to be the more appropriate value.
>From the link(2) man page:

EXDEV  oldpath and newpath are not on the same mounted file system.  (Linux
       permits a file system to be mounted at multiple points, but link()
       does not work across different mount points, even if the same file
       system is mounted on both.)

This matters because an application may have different behaviors based on
return codes.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>

---
 fs/btrfs/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 512c3d1..321ce4c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4809,7 +4809,7 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 
 	/* do not allow sys_link's with other subvols of the same device */
 	if (root->objectid != BTRFS_I(inode)->root->objectid)
-		return -EPERM;
+		return -EXDEV;
 
 	btrfs_inc_nlink(inode);
 	inode->i_ctime = CURRENT_TIME;
-- 
1.6.4.2

