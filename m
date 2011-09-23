From: H Hartley Sweeten <hartleys@visionengravers.com>
Subject: [PATCH] btrfs/xattr.c: quiet sparse noise
Date: Thu, 22 Sep 2011 18:50:19 -0700
Message-ID: <201109221850.19938.hartleys@visionengravers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Cc: <linux-btrfs@vger.kernel.org>, <chris.mason@oracle.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Quiet the sparse noise:

warning: symbol 'btrfs_initxattrs' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Chris Mason <chris.mason@oracle.com>

---

diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index 6196e1a..e878463 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -374,8 +374,8 @@ int btrfs_removexattr(struct dentry *dentry, const char *name)
 				XATTR_REPLACE);
 }
 
-int btrfs_initxattrs(struct inode *inode, const struct xattr *xattr_array,
-		     void *fs_info)
+static int btrfs_initxattrs(struct inode *inode,
+			    const struct xattr *xattr_array, void *fs_info)
 {
 	const struct xattr *xattr;
 	struct btrfs_trans_handle *trans = fs_info;
