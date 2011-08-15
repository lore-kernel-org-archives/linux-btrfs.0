From: Jeff Mahoney <jeffm@suse.de>
Subject: [PATCH] btrfs: btrfs_permission's RO check shouldn't apply to device
 nodes
Date: Mon, 15 Aug 2011 13:27:21 -0400
Message-ID: <4E4956F9.3020009@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Btrfs Development List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 This patch tightens the read-only access checks in btrfs_permission to
 match the constraints in inode_permission. Currently, even though the
 device node itself will be unmodified, read-write access to device nodes
 is denied to when the device node resides on a read-only subvolume or a
 is a file that has been marked read-only by the btrfs conversion utility.

 With this patch applied, the check only affects regular files,
 directories, and symlinks. It also restructures the code a bit so that
 we don't duplicate the MAY_WRITE check for both tests.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/inode.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7354,11 +7354,15 @@ static int btrfs_set_page_dirty(struct p
 static int btrfs_permission(struct inode *inode, int mask)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
+	umode_t mode = inode->i_mode;
 
-	if (btrfs_root_readonly(root) && (mask & MAY_WRITE))
-		return -EROFS;
-	if ((BTRFS_I(inode)->flags & BTRFS_INODE_READONLY) && (mask & MAY_WRITE))
-		return -EACCES;
+	if (mask & MAY_WRITE &&
+	    (S_ISREG(mode) || S_ISDIR(mode) || S_ISLNK(mode))) {
+		if (btrfs_root_readonly(root))
+			return -EROFS;
+		if (BTRFS_I(inode)->flags & BTRFS_INODE_READONLY)
+			return -EACCES;
+	}
 	return generic_permission(inode, mask);
 }
 
Jeff Mahoney
SUSE Labs
