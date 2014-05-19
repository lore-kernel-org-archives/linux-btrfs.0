Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [119.145.14.64] ([119.145.14.64]:6080 "EHLO
	szxga01-in.huawei.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752732AbaESG1U (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 May 2014 02:27:20 -0400
Message-ID: <5379A412.3050806@huawei.com>
Date: Mon, 19 May 2014 14:26:26 +0800
From: Zhang Zhen <zhenzhang.zhang@huawei.com>
MIME-Version: 1.0
To: <clm@fb.com>, <jbacik@fb.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs: remove a FIXME in btrfs_get_acl()
References: <1400480536-18691-1-git-send-email-zhenzhang.zhang@huawei.com>
In-Reply-To: <1400480536-18691-1-git-send-email-zhenzhang.zhang@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There is no function returns a value of -ENOENT, so the check is
useless.
Remove it, and the redundant braces.

Signed-off-by: Zhang Zhen <zhenzhang.zhang@huawei.com>
---
 fs/btrfs/acl.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index ff9b399..cae7480 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -53,14 +53,12 @@ struct posix_acl *btrfs_get_acl(struct inode *inode, int type)
 			return ERR_PTR(-ENOMEM);
 		size = __btrfs_getxattr(inode, name, value, size);
 	}
-	if (size > 0) {
+	if (size > 0)
 		acl = posix_acl_from_xattr(&init_user_ns, value, size);
-	} else if (size == -ENOENT || size == -ENODATA || size == 0) {
-		/* FIXME, who returns -ENOENT?  I think nobody */
+	else if (size == -ENODATA || size == 0)
 		acl = NULL;
-	} else {
+	else
 		acl = ERR_PTR(-EIO);
-	}
 	kfree(value);

 	if (!IS_ERR(acl))
-- 
1.8.1.2


.




