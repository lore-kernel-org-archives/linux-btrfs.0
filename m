Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:37965 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751060AbeF0ERf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Jun 2018 00:17:35 -0400
From: Chengguang Xu <cgxu519@gmx.com>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Chengguang Xu <cgxu519@gmx.com>
Subject: [PATCH v4 1/5] btrfs: return error instead of crash when detecting unexpected type in btrfs_get_acl()
Date: Wed, 27 Jun 2018 12:16:34 +0800
Message-Id: <20180627041638.13210-2-cgxu519@gmx.com>
In-Reply-To: <20180627041638.13210-1-cgxu519@gmx.com>
References: <20180627041638.13210-1-cgxu519@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The caller of btrfs_get_acl() checks error condition so there is no
impact from this change. In practice there is no chance to get into
default case of switch statement because VFS has already checked
the type.

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
index 15e1dfef56a5..60f83a3bd77c 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -30,7 +30,7 @@ struct posix_acl *btrfs_get_acl(struct inode *inode, int type)
 		name = XATTR_NAME_POSIX_ACL_DEFAULT;
 		break;
 	default:
-		BUG();
+		return ERR_PTR(-EINVAL);
 	}
 
 	size = btrfs_getxattr(inode, name, "", 0);
-- 
2.17.1

