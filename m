Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:58459 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751438AbeFWGkD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 23 Jun 2018 02:40:03 -0400
From: Chengguang Xu <cgxu519@gmx.com>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Chengguang Xu <cgxu519@gmx.com>
Subject: [PATCH v2] btrfs: remove -ERANGE check and avoid errno overriding in btrfs_get_acl()
Date: Sat, 23 Jun 2018 14:38:58 +0800
Message-Id: <20180623063858.10395-1-cgxu519@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Remove -ERANGE error check because there is no chance to get into
this condition and meanwhile avoid overriding errno to -EIO in
btrfs_get_acl().

Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
---
v2:
- Avoid errno overriding instead of print error message in error case.
- Change commit log for better understanding.

 fs/btrfs/acl.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index 15e1dfef56a5..b71a875036af 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -40,13 +40,13 @@ struct posix_acl *btrfs_get_acl(struct inode *inode, int type)
 			return ERR_PTR(-ENOMEM);
 		size = btrfs_getxattr(inode, name, value, size);
 	}
-	if (size > 0) {
+	if (size > 0)
 		acl = posix_acl_from_xattr(&init_user_ns, value, size);
-	} else if (size == -ERANGE || size == -ENODATA || size == 0) {
+	else if (size == -ENODATA || size == 0)
 		acl = NULL;
-	} else {
-		acl = ERR_PTR(-EIO);
-	}
+	else
+		acl = ERR_PTR(size);
+
 	kfree(value);
 
 	return acl;
-- 
2.17.1

