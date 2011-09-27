From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: only inherit btrfs specific flags when creating files
Date: Tue, 27 Sep 2011 11:02:27 -0400
Message-ID: <1317135747-8198-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Xfstests 79 was failing because we were inheriting the S_APPEND flag when we
weren't supposed to.  There isn't any specific documentation on this so I'm
taking the test as the standard of how things work, and having S_APPEND set on a
directory doesn't mean that S_APPEND gets inherited by its children according to
this test.  So only inherit btrfs specific things.  This will let us set
compress/nocompress on specific directories and everything in the directories
will inherit this flag, same with nodatacow.  With this patch test 79 passes.
Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/ioctl.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 24fd75b..d2b53eb 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -117,7 +117,7 @@ void btrfs_update_iflags(struct inode *inode)
 /*
  * Inherit flags from the parent inode.
  *
- * Unlike extN we don't have any flags we don't want to inherit currently.
+ * Currently only the compression flags and the cow flags are inherited.
  */
 void btrfs_inherit_iflags(struct inode *inode, struct inode *dir)
 {
@@ -128,12 +128,17 @@ void btrfs_inherit_iflags(struct inode *inode, struct inode *dir)
 
 	flags = BTRFS_I(dir)->flags;
 
-	if (S_ISREG(inode->i_mode))
-		flags &= ~BTRFS_INODE_DIRSYNC;
-	else if (!S_ISDIR(inode->i_mode))
-		flags &= (BTRFS_INODE_NODUMP | BTRFS_INODE_NOATIME);
+	if (flags & BTRFS_INODE_NOCOMPRESS) {
+		BTRFS_I(inode)->flags &= ~BTRFS_INODE_COMPRESS;
+		BTRFS_I(inode)->flags |= BTRFS_INODE_NOCOMPRESS;
+	} else if (flags & BTRFS_INODE_COMPRESS) {
+		BTRFS_I(inode)->flags &= ~BTRFS_INODE_NOCOMPRESS;
+		BTRFS_I(inode)->flags |= BTRFS_INODE_COMPRESS;
+	}
+
+	if (flags & BTRFS_INODE_NODATACOW)
+		BTRFS_I(inode)->flags |= BTRFS_INODE_NODATACOW;
 
-	BTRFS_I(inode)->flags = flags;
 	btrfs_update_iflags(inode);
 }
 
-- 
1.7.5.2

