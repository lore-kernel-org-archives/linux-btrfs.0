Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([58.251.152.64]:5824 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193AbbIHIrK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Sep 2015 04:47:10 -0400
From: Sheng Yong <shengyong1@huawei.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs: trival fix of __btrfs_set_acl error handling
Date: Tue, 8 Sep 2015 08:46:42 +0000
Message-ID: <1441702002-109706-1-git-send-email-shengyong1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

* If the allocation failed, don't free to free it, even though kfree
  allows to free a NULL pointer.
* If posix_acl_to_xattr() failed, cleanup the allocation and return
  the error directly.

Signed-off-by: Sheng Yong <shengyong1@huawei.com>
---
 fs/btrfs/acl.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index 9a0124a..6d01d09 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -103,18 +103,18 @@ static int __btrfs_set_acl(struct btrfs_trans_handle *trans,
 	if (acl) {
 		size = posix_acl_xattr_size(acl->a_count);
 		value = kmalloc(size, GFP_NOFS);
-		if (!value) {
-			ret = -ENOMEM;
-			goto out;
-		}
+		if (!value)
+			return -ENOMEM;
 
 		ret = posix_acl_to_xattr(&init_user_ns, acl, value, size);
-		if (ret < 0)
-			goto out;
+		if (ret < 0) {
+			kfree(value);
+			return ret;
+		}
 	}
 
 	ret = __btrfs_setxattr(trans, inode, name, value, size, 0);
-out:
+
 	kfree(value);
 
 	if (!ret)
-- 
1.8.3.4

