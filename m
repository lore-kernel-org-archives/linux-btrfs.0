Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:38533 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934071AbeFVC7f (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Jun 2018 22:59:35 -0400
From: Chengguang Xu <cgxu519@gmx.com>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Chengguang Xu <cgxu519@gmx.com>
Subject: [PATCH] btrfs: treat -ERANGE as an error case in btrfs_get_acl()
Date: Fri, 22 Jun 2018 10:58:16 +0800
Message-Id: <20180622025816.29239-1-cgxu519@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently, when encoutering -ERANGE in btrfs_get_acl(),
just set acl to NULL so that we cannot get proper
acl information but the operation looks successful.

This patch treats -ERANGE as an error case and meanwhile
print real errno before translating errno to -EIO.

Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
---
 fs/btrfs/acl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index 15e1dfef56a5..7b3a83dd917c 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -42,9 +42,10 @@ struct posix_acl *btrfs_get_acl(struct inode *inode, int type)
 	}
 	if (size > 0) {
 		acl = posix_acl_from_xattr(&init_user_ns, value, size);
-	} else if (size == -ERANGE || size == -ENODATA || size == 0) {
+	} else if (size == -ENODATA || size == 0) {
 		acl = NULL;
 	} else {
+		pr_err_ratelimited("BTRFS: get acl failed, err=%d\n", size);
 		acl = ERR_PTR(-EIO);
 	}
 	kfree(value);
-- 
2.17.1

