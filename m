Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:37733 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751069AbeF0ERm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Jun 2018 00:17:42 -0400
From: Chengguang Xu <cgxu519@gmx.com>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Chengguang Xu <cgxu519@gmx.com>
Subject: [PATCH v4 2/5] btrfs: replace empty string with NULL when getting attribute length in btrfs_get_acl()
Date: Wed, 27 Jun 2018 12:16:35 +0800
Message-Id: <20180627041638.13210-3-cgxu519@gmx.com>
In-Reply-To: <20180627041638.13210-1-cgxu519@gmx.com>
References: <20180627041638.13210-1-cgxu519@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In btrfs_get_acl() the first call of btr_getxattr() is for getting
the length of attribute, the value buffer is never used in this
case. So it's better to replace empty string with NULL.

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
index 60f83a3bd77c..83fdd80c51c6 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -33,7 +33,7 @@ struct posix_acl *btrfs_get_acl(struct inode *inode, int type)
 		return ERR_PTR(-EINVAL);
 	}
 
-	size = btrfs_getxattr(inode, name, "", 0);
+	size = btrfs_getxattr(inode, name, NULL, 0);
 	if (size > 0) {
 		value = kzalloc(size, GFP_KERNEL);
 		if (!value)
-- 
2.17.1

