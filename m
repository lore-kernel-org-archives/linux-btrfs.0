From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 3/7] btrfs/acl: add noacl check for btrfs_get_acl()
Date: Thu, 29 Jul 2010 16:28:28 +0800
Message-ID: <4C513BAC.8050904@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>,
	Yan Zheng <zheng.yan@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

btrfs returned the acl info though it was mounted with "noacl" option.

Steps to reproduce:
 # mkfs.btrfs /dev/sda2
 # mount /dev/sda2 /mnt
 # touch /mnt/file0
 # setfacl -m 'u:root:x,g::x,o::x' /mnt/file0
 # umount /mnt
 # mount /dev/sda2 -o noacl /mnt
 # getfacl /mnt/file0

we add a noacl check for btrfs_get_acl() to fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/acl.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index bb35580..b070f58 100644
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
-- 
1.7.0.1
