Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:38385 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751173AbeF0ERw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Jun 2018 00:17:52 -0400
From: Chengguang Xu <cgxu519@gmx.com>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Chengguang Xu <cgxu519@gmx.com>
Subject: [PATCH v4 5/5] btrfs: remove unnecessary bracket in btrfs_get_acl()
Date: Wed, 27 Jun 2018 12:16:38 +0800
Message-Id: <20180627041638.13210-6-cgxu519@gmx.com>
In-Reply-To: <20180627041638.13210-1-cgxu519@gmx.com>
References: <20180627041638.13210-1-cgxu519@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's only coding style fix not functinal change.
When if/else has only one statement then the bracket
is not needed.

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

 fs/btrfs/acl.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index 7d673ec9e54a..3b66c957ea6f 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -40,13 +40,12 @@ struct posix_acl *btrfs_get_acl(struct inode *inode, int type)
 			return ERR_PTR(-ENOMEM);
 		size = btrfs_getxattr(inode, name, value, size);
 	}
-	if (size > 0) {
+	if (size > 0)
 		acl = posix_acl_from_xattr(&init_user_ns, value, size);
-	} else if (size == -ENODATA || size == 0) {
+	else if (size == -ENODATA || size == 0)
 		acl = NULL;
-	} else {
+	else
 		acl = ERR_PTR(size);
-	}
 	kfree(value);
 
 	return acl;
-- 
2.17.1

