Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:60631 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751120AbeF0ERn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Jun 2018 00:17:43 -0400
From: Chengguang Xu <cgxu519@gmx.com>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Chengguang Xu <cgxu519@gmx.com>
Subject: [PATCH v4 3/5] btrfs: remove unnecessary -ERANGE check in btrfs_get_acl()
Date: Wed, 27 Jun 2018 12:16:36 +0800
Message-Id: <20180627041638.13210-4-cgxu519@gmx.com>
In-Reply-To: <20180627041638.13210-1-cgxu519@gmx.com>
References: <20180627041638.13210-1-cgxu519@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There is no chance to get into -ERANGE error condition because
we first call btrfs_getxattr to get the length of the attribute,
then we do a subsequent call with the size from the first call.
Between the 2 calls the size shouldn't change. So remove the
unnecessary -ERANGE error check.

Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
---
v4:
- Split patch to series.

v3:
- Fix some toher bad practices.
- Add more information to commit log.

v2:
- Avoid errno overriding instead of print error message in error case.
- Chagne commit log for better understanding.

 fs/btrfs/acl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index 83fdd80c51c6..a1d7211c8884 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -42,7 +42,7 @@ struct posix_acl *btrfs_get_acl(struct inode *inode, int type)
 	}
 	if (size > 0) {
 		acl = posix_acl_from_xattr(&init_user_ns, value, size);
-	} else if (size == -ERANGE || size == -ENODATA || size == 0) {
+	} else if (size == -ENODATA || size == 0) {
 		acl = NULL;
 	} else {
 		acl = ERR_PTR(-EIO);
-- 
2.17.1

