From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] btrfs: Fix a memleak on failed posix acl conversion
Date: Mon, 19 Jul 2010 19:28:44 +0530
Message-ID: <1279547924-25141-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-btrfs@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/btrfs/acl.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index 2222d16..6d1410e 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -60,8 +60,10 @@ static struct posix_acl *btrfs_get_acl(struct inode *inode, int type)
 		size = __btrfs_getxattr(inode, name, value, size);
 		if (size > 0) {
 			acl = posix_acl_from_xattr(value, size);
-			if (IS_ERR(acl))
+			if (IS_ERR(acl)) {
+				kfree(value);
 				return acl;
+			}
 			set_cached_acl(inode, type, acl);
 		}
 		kfree(value);
-- 
1.7.2.rc3.43.g24e7a

