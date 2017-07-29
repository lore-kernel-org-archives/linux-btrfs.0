Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:38121 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752987AbdG2A0f (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Jul 2017 20:26:35 -0400
Received: by mail-qt0-f193.google.com with SMTP id p3so14122654qtg.5
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Jul 2017 17:26:34 -0700 (PDT)
Date: Fri, 28 Jul 2017 21:26:29 -0300
From: Ernesto =?utf-8?Q?A=2E_Fern=C3=A1ndez?=
        <ernesto.mnd.fernandez@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>,
        Ernesto =?utf-8?Q?A=2E_Fern=C3=A1ndez?=
        <ernesto.mnd.fernandez@gmail.com>
Subject: [PATCH] btrfs: preserve i_mode if __btrfs_set_acl() fails
Message-ID: <20170729002626.GA6759@debian.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
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
__btrfs_set_acl and only changing the inode mode after it returns
successfully.

Signed-off-by: Ernesto A. Fernández <ernesto.mnd.fernandez@gmail.com>
---
This issue is covered by generic/449 in xfstests. Several filesystems
are affected; some of them have already applied patches:
  - fe26569 ext2: preserve i_mode if ext2_set_acl() fails
  - f070e5a jfs: preserve i_mode if __jfs_set_acl() fails
  - fcea8ae reiserfs: preserve i_mode if __reiserfs_set_acl() fails

 fs/btrfs/acl.c | 29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index 8d8370d..d041526 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -27,6 +27,7 @@
 #include "ctree.h"
 #include "btrfs_inode.h"
 #include "xattr.h"
+#include "transaction.h"
 
 struct posix_acl *btrfs_get_acl(struct inode *inode, int type)
 {
@@ -113,14 +114,36 @@ static int __btrfs_set_acl(struct btrfs_trans_handle *trans,
 
 int btrfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 {
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_trans_handle *trans;
 	int ret;
+	umode_t mode = inode->i_mode;
+
+	if (btrfs_root_readonly(root))
+		return -EROFS;
+
+	trans = btrfs_start_transaction(root, 2);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
 
 	if (type == ACL_TYPE_ACCESS && acl) {
-		ret = posix_acl_update_mode(inode, &inode->i_mode, &acl);
+		ret = posix_acl_update_mode(inode, &mode, &acl);
 		if (ret)
-			return ret;
+			goto out;
 	}
-	return __btrfs_set_acl(NULL, inode, acl, type);
+	ret = __btrfs_set_acl(trans, inode, acl, type);
+	if (ret)
+		goto out;
+
+	inode->i_mode = mode;
+	inode_inc_iversion(inode);
+	inode->i_ctime = current_time(inode);
+	set_bit(BTRFS_INODE_COPY_EVERYTHING, &BTRFS_I(inode)->runtime_flags);
+	ret = btrfs_update_inode(trans, root, inode);
+	BUG_ON(ret);
+out:
+	btrfs_end_transaction(trans);
+	return ret;
 }
 
 /*
-- 
2.1.4

