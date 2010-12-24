From: Jesper Juhl <jj@chaosbits.net>
Subject: [PATCH] BTRFS: Don't leak memory in btrfs_get_acl()
Date: Fri, 24 Dec 2010 23:45:21 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1012242342280.28973@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Currrently we leak memory in btrfs_get_acl::btrfs_get_acl() if 
posix_acl_from_xattr() fails. With this patch we do not.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 acl.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)
diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index 2222d16..6d1410e 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -60,8 +60,10 @@ static struct posix_acl *btrfs_get_acl(struct inode *inode, int type)
 		size = __btrfs_getxattr(inode, name, value, size);
 		if (size > 0) {
 			acl = posix_acl_from_xattr(value, size);
-			if (IS_ERR(acl))
+			if (IS_ERR(acl)) {
+				kfree(value);
 				return acl;
+			}
 			set_cached_acl(inode, type, acl);
 		}
 		kfree(value);


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

