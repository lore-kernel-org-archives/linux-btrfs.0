From: Shi Weihua <shiwh@cn.fujitsu.com>
Subject: [PATCH] btrfs: should add a permission check for setfacl
Date: Tue, 18 May 2010 08:50:32 +0800
Message-ID: <4BF1E458.7060500@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Cc: linux-btrfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: chris.mason@oracle.com, "Yan, Zheng" <zheng.yan@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

On btrfs, do the following
------------------
# su user1
# cd btrfs-part/
# touch aaa
# getfacl aaa
  # file: aaa
  # owner: user1
  # group: user1
  user::rw-
  group::rw-
  other::r--
# su user2
# cd btrfs-part/
# setfacl -m u::rwx aaa
# getfacl aaa
  # file: aaa
  # owner: user1
  # group: user1
  user::rwx           <- successed to setfacl
  group::rw-
  other::r--
------------------
but we should prohibit it that user2 changing user1's acl.
In fact, on ext3 and other fs, a message occurs:
  setfacl: aaa: Operation not permitted

This patch fixed it.
Signed-off-by: Shi Weihua <shiwh@cn.fujitsu.com>
---
diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index da3133c..12d7be8 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -159,6 +159,9 @@ static int btrfs_xattr_set_acl(struct inode *inode, int type,
 	int ret;
 	struct posix_acl *acl = NULL;
 
+	if (!is_owner_or_cap(inode))
+		return -EPERM;
+
 	if (value) {
 		acl = posix_acl_from_xattr(value, size);
 		if (acl == NULL) {
