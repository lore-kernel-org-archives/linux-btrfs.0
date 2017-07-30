Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:37283 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752698AbdG3CSp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 29 Jul 2017 22:18:45 -0400
Received: by mail-qt0-f195.google.com with SMTP id d10so14483683qtb.4
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Jul 2017 19:18:45 -0700 (PDT)
Date: Sat, 29 Jul 2017 23:18:39 -0300
From: Ernesto =?utf-8?Q?A=2E_Fern=C3=A1ndez?=
        <ernesto.mnd.fernandez@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>,
        Ernesto =?utf-8?Q?A=2E_Fern=C3=A1ndez?=
        <ernesto.mnd.fernandez@gmail.com>
Subject: [PATCH v2] btrfs: preserve i_mode if __btrfs_set_acl() fails
Message-ID: <20170730021838.GA4565@debian.home>
References: <20170729002626.GA6759@debian.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20170729002626.GA6759@debian.home>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When changing a file's acl mask, btrfs_set_acl() will first set the
group bits of i_mode to the value of the mask, and only then set the
actual extended attribute representing the new acl.

If the second part fails (due to lack of space, for example) and the
file had no acl attribute to begin with, the system will from now on
assume that the mask permission bits are actual group permission bits,
potentially granting access to the wrong users.

Prevent this by starting the journal transaction before calling
__btrfs_set_acl and only changing the inode mode after the acl is set
successfully.

Signed-off-by: Ernesto A. Fernández <ernesto.mnd.fernandez@gmail.com>
---
Changes in v2:
  - Take the code that checks if we are setting a default acl on something
    that is not a dir, remove it from the __btrfs_set_acl function, and
    place it in btrfs_set_acl instead. This should fix the issue pointed out
    by Josef Bacik, that I was sometimes updating the inode even when there
    was no change.
  - Don't call BUG_ON when the inode failed to update. Also requested by
    Josef Bacik. It should be noted that __btrfs_setxattr was already
    calling BUG_ON before my patch; that has not been changed.

 fs/btrfs/acl.c | 31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index 8d8370d..f62e8ac 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -27,6 +27,7 @@
 #include "ctree.h"
 #include "btrfs_inode.h"
 #include "xattr.h"
+#include "transaction.h"
 
 struct posix_acl *btrfs_get_acl(struct inode *inode, int type)
 {
@@ -80,8 +81,6 @@ static int __btrfs_set_acl(struct btrfs_trans_handle *trans,
 		name = XATTR_NAME_POSIX_ACL_ACCESS;
 		break;
 	case ACL_TYPE_DEFAULT:
-		if (!S_ISDIR(inode->i_mode))
-			return acl ? -EINVAL : 0;
 		name = XATTR_NAME_POSIX_ACL_DEFAULT;
 		break;
 	default:
@@ -113,14 +112,38 @@ static int __btrfs_set_acl(struct btrfs_trans_handle *trans,
 
 int btrfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 {
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_trans_handle *trans;
 	int ret;
+	umode_t mode = inode->i_mode;
 
+	if (type == ACL_TYPE_DEFAULT && !S_ISDIR(inode->i_mode))
+		return acl ? -EINVAL : 0;
 	if (type == ACL_TYPE_ACCESS && acl) {
-		ret = posix_acl_update_mode(inode, &inode->i_mode, &acl);
+		ret = posix_acl_update_mode(inode, &mode, &acl);
 		if (ret)
 			return ret;
 	}
-	return __btrfs_set_acl(NULL, inode, acl, type);
+
+	if (btrfs_root_readonly(root))
+		return -EROFS;
+
+	trans = btrfs_start_transaction(root, 2);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
+
+	ret = __btrfs_set_acl(trans, inode, acl, type);
+	if (ret)
+		goto out;
+
+	inode->i_mode = mode;
+	inode_inc_iversion(inode);
+	inode->i_ctime = current_time(inode);
+	set_bit(BTRFS_INODE_COPY_EVERYTHING, &BTRFS_I(inode)->runtime_flags);
+	ret = btrfs_update_inode(trans, root, inode);
+out:
+	btrfs_end_transaction(trans);
+	return ret;
 }
 
 /*
-- 
2.1.4


