Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:43833 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751173AbeF0ERq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Jun 2018 00:17:46 -0400
From: Chengguang Xu <cgxu519@gmx.com>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Chengguang Xu <cgxu519@gmx.com>
Subject: [PATCH v4 4/5] btrfs: avoid error code overriding in btrfs_get_acl()
Date: Wed, 27 Jun 2018 12:16:37 +0800
Message-Id: <20180627041638.13210-5-cgxu519@gmx.com>
In-Reply-To: <20180627041638.13210-1-cgxu519@gmx.com>
References: <20180627041638.13210-1-cgxu519@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's no good to override error code when failing from
btrfs_getxattr() in btrfs_get_acl() because it will hide
real root cause.

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
index a1d7211c8884..7d673ec9e54a 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -45,7 +45,7 @@ struct posix_acl *btrfs_get_acl(struct inode *inode, int type)
 	} else if (size == -ENODATA || size == 0) {
 		acl = NULL;
 	} else {
-		acl = ERR_PTR(-EIO);
+		acl = ERR_PTR(size);
 	}
 	kfree(value);
 
-- 
2.17.1

