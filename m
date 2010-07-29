From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 2/7] btrfs/acl: fix btrfs_xattr_acl_set()
Date: Thu, 29 Jul 2010 16:27:16 +0800
Message-ID: <4C513B64.6020805@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>,
	Yan Zheng <zheng.yan@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

- cleanup unnecessary code
- add validity check for acl

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/acl.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index 2f4f65a..bb35580 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -169,16 +169,17 @@ static int btrfs_xattr_acl_set(struct dentry *dentry, const char *name,
 
 	if (value) {
 		acl = posix_acl_from_xattr(value, size);
-		if (acl == NULL) {
-			value = NULL;
-			size = 0;
-		} else if (IS_ERR(acl)) {
+		if (acl) {
+			ret = posix_acl_valid(acl);
+			if (ret)
+				goto out;
+		} else if (IS_ERR(acl))
 			return PTR_ERR(acl);
-		}
 	}
 
 	ret = btrfs_set_acl(NULL, dentry->d_inode, acl, type);
 
+out:
 	posix_acl_release(acl);
 
 	return ret;
-- 
1.7.0.1
