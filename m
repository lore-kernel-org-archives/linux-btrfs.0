From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 10/12] Btrfs: Don't return acl info when mounting with noacl
 option
Date: Thu, 27 Jan 2011 16:45:29 +0800
Message-ID: <4D4130A9.70701@cn.fujitsu.com>
References: <4D412FE6.7050101@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	Miao Xie <miaox@cn.fujitsu.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D412FE6.7050101@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

From: Miao Xie <miaox@cn.fujitsu.com>

Steps to reproduce:

  # mkfs.btrfs /dev/sda2
  # mount /dev/sda2 /mnt
  # touch /mnt/file0
  # setfacl -m 'u:root:x,g::x,o::x' /mnt/file0
  # umount /mnt
  # mount /dev/sda2 -o noacl /mnt
  # getfacl /mnt/file0
  ...
  user::rw-
  user:root:--x
  group::--x
  mask::--x
  other::--x

The output should be:

  user::rw-
  group::--x
  other::--x

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/acl.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index 2222d16..3c52fc8 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -37,6 +37,9 @@ static struct posix_acl *btrfs_get_acl(struct inode *inode, int type)
 	char *value = NULL;
 	struct posix_acl *acl;
 
+	if (!IS_POSIXACL(inode))
+		return NULL;
+
 	acl = get_cached_acl(inode, type);
 	if (acl != ACL_NOT_CACHED)
 		return acl;
@@ -82,6 +85,9 @@ static int btrfs_xattr_acl_get(struct dentry *dentry, const char *name,
 	struct posix_acl *acl;
 	int ret = 0;
 
+	if (!IS_POSIXACL(dentry->d_inode))
+		return -EOPNOTSUPP;
+
 	acl = btrfs_get_acl(dentry->d_inode, type);
 
 	if (IS_ERR(acl))
-- 
1.6.3
