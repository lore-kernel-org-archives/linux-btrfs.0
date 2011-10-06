From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: [PATCH] Btrfs: fix return value of btrfs_get_acl()
Date: Thu, 06 Oct 2011 13:37:08 +0900
Message-ID: <201110060437.AA00035@T-ITOH1.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

In btrfs_get_acl(), when the second __btrfs_getxattr() call fails,
acl is not correctly set.
Therefore, a wrong value might return to the caller.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/acl.c |   17 +++++++----------
 1 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index eb159aa..89b156d 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -59,22 +59,19 @@ struct posix_acl *btrfs_get_acl(struct inode *inode, int type)
 		if (!value)
 			return ERR_PTR(-ENOMEM);
 		size = __btrfs_getxattr(inode, name, value, size);
-		if (size > 0) {
-			acl = posix_acl_from_xattr(value, size);
-			if (IS_ERR(acl)) {
-				kfree(value);
-				return acl;
-			}
-			set_cached_acl(inode, type, acl);
-		}
-		kfree(value);
+	}
+	if (size > 0) {
+		acl = posix_acl_from_xattr(value, size);
 	} else if (size == -ENOENT || size == -ENODATA || size == 0) {
 		/* FIXME, who returns -ENOENT?  I think nobody */
 		acl = NULL;
-		set_cached_acl(inode, type, acl);
 	} else {
 		acl = ERR_PTR(-EIO);
 	}
+	kfree(value);
+
+	if (!IS_ERR(acl))
+		set_cached_acl(inode, type, acl);
 
 	return acl;
 }

