From: Shi Weihua <shiwh@cn.fujitsu.com>
Subject: [PATCH] btrfs: prohibit a operation of changing acl's mask when noacl
 mount option used
Date: Tue, 18 May 2010 08:51:54 +0800
Message-ID: <4BF1E4AA.9090709@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Cc: linux-btrfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: chris.mason@oracle.com, "Yan, Zheng" <zheng.yan@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

when used Posix File System Test Suite(pjd-fstest) to test btrfs, 
some cases about setfacl failed when noacl mount option used.
I simplified used commands in pjd-fstest, and the following steps 
can reproduce it.
------------------------
# cd btrfs-part/
# mkdir aaa
# setfacl -m m::rw aaa    <- successed, but not expected by pjd-fstest.
------------------------
I checked ext3, a warning message occured, like as:
  setfacl: aaa/: Operation not supported
Certainly, it's expected by pjd-fstest.

So, i compared acl.c of btrfs and ext3. Based on that, a patch created.
Fortunately, it works.

Signed-off-by: Shi Weihua <shiwh@cn.fujitsu.com>
---
diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index da3133c..f2e09c2 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -159,6 +159,9 @@ static int btrfs_xattr_set_acl(struct inode *inode, int type,
 	int ret;
 	struct posix_acl *acl = NULL;
 
+	if (!IS_POSIXACL(inode))
+		return -EOPNOTSUPP;
+
 	if (value) {
 		acl = posix_acl_from_xattr(value, size);
 		if (acl == NULL) {




