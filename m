From: Dan Carpenter <error27@gmail.com>
Subject: [patch] btrfs: add check for ERR_PTR()
Date: Wed, 21 Apr 2010 12:32:04 +0200
Message-ID: <20100421103204.GD29647@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Al Viro <viro@zeniv.linux.org.uk>,
	Joel Becker <joel.becker@oracle.com>,
	James Morris <jmorris@namei.org>,
	Christoph Hellwig <hch@lst.de>, linux-btrfs@vger.kernel.org,
	kernel-janitors@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

posix_acl_from_xattr() can sometimes return an ERR_PTR().

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index 6ef7b26..c6d84ce 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -60,7 +60,8 @@ static struct posix_acl *btrfs_get_acl(struct inode *inode, int type)
 		size = __btrfs_getxattr(inode, name, value, size);
 		if (size > 0) {
 			acl = posix_acl_from_xattr(value, size);
-			set_cached_acl(inode, type, acl);
+			if (!IS_ERR(acl))
+				set_cached_acl(inode, type, acl);
 		}
 		kfree(value);
 	} else if (size == -ENOENT || size == -ENODATA || size == 0) {
