From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 04/19] btrfs: replace inode uid,gid,mode initialization with helper function
Date: Wed, 17 Feb 2010 21:38:24 +0300
Message-ID: <1266431904-9060-1-git-send-email-dmonakhov@openvz.org>
References: <1266431353-8549-1-git-send-email-dmonakhov@openvz.org>
Cc: linux-btrfs@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1266431353-8549-1-git-send-email-dmonakhov@openvz.org>
List-ID: <linux-btrfs.vger.kernel.org>


Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/btrfs/inode.c |   11 +----------
 1 files changed, 1 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 4deb280..ae4f64c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4145,16 +4145,7 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 	if (ret != 0)
 		goto fail;
 
-	inode->i_uid = current_fsuid();
-
-	if (dir && (dir->i_mode & S_ISGID)) {
-		inode->i_gid = dir->i_gid;
-		if (S_ISDIR(mode))
-			mode |= S_ISGID;
-	} else
-		inode->i_gid = current_fsgid();
-
-	inode->i_mode = mode;
+	inode_init_owner(inode, dir, mode);
 	inode->i_ino = objectid;
 	inode_set_bytes(inode, 0);
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
-- 
1.6.6

