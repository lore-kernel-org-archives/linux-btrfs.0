From: Dan Carpenter <error27@gmail.com>
Subject: [patch 10/11] btrfs: handle ERR_PTR from posix_acl_from_xattr()
Date: Sat, 29 May 2010 11:48:35 +0200
Message-ID: <20100529094835.GK5483@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Al Viro <viro@zeniv.linux.org.uk>,
	Stephen Hemminger <shemminger@vyatta.com>,
	Joel Becker <joel.becker@oracle.com>,
	James Morris <jmorris@namei.org>,
	Chris Mason <chris.mason@oracle.com>,
	kernel-janitors@vger.kernel.org
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

posix_acl_from_xattr() returns both ERR_PTRs and null, but it's OK to
pass null values to set_cached_acl()

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index 8d432cd..e24a19a 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -60,6 +60,8 @@ static struct posix_acl *btrfs_get_acl(struct inode *inode, int type)
 		size = __btrfs_getxattr(inode, name, value, size);
 		if (size > 0) {
 			acl = posix_acl_from_xattr(value, size);
+			if (IS_ERR(acl))
+				return acl;
 			set_cached_acl(inode, type, acl);
 		}
 		kfree(value);
