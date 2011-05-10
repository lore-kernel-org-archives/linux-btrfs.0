From: Sage Weil <sage@newdream.net>
Subject: [PATCH 10/18] btrfs: remove unnecessary dentry_unhash in rmdir/rename_dir
Date: Mon,  9 May 2011 21:43:28 -0700
Message-ID: <1305002616-16782-11-git-send-email-sage@newdream.net>
References: <1305002616-16782-1-git-send-email-sage@newdream.net>
Cc: Sage Weil <sage@newdream.net>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org
To: viro@ZenIV.linux.org.uk, hch@lst.de, linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1305002616-16782-1-git-send-email-sage@newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs has no problems with lingering references to unlinked directory
inodes.

CC: Chris Mason <chris.mason@oracle.com>
CC: linux-btrfs@vger.kernel.org
Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/btrfs/inode.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3a33ae3..7cd8ab0 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3062,8 +3062,6 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 	    inode->i_ino == BTRFS_FIRST_FREE_OBJECTID)
 		return -ENOTEMPTY;
 
-	dentry_unhash(dentry);
-
 	trans = __unlink_start_trans(dir, dentry);
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
@@ -6994,9 +6992,6 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	u64 root_objectid;
 	int ret;
 
-	if (new_inode && S_ISDIR(new_dentry->d_inode->i_mode))
-		dentry_unhash(new_dentry);
-
 	if (new_dir->i_ino == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID)
 		return -EPERM;
 
-- 
1.7.1

