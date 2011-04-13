From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 4/4] Btrfs: Check validity before setting an acl
Date: Wed, 13 Apr 2011 15:43:17 +0800
Message-ID: <4DA55415.4050805@cn.fujitsu.com>
References: <4DA553C9.2040807@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DA553C9.2040807@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

From: Miao Xie <miaox@cn.fujitsu.com>

Call posix_acl_valid() to check if an acl is valid or not.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/acl.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index 9c94934..a892bc2 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -178,16 +178,17 @@ static int btrfs_xattr_acl_set(struct dentry *dentry, const char *name,
 
 	if (value) {
 		acl = posix_acl_from_xattr(value, size);
-		if (acl == NULL) {
-			value = NULL;
-			size = 0;
+		if (acl) {
+			ret = posix_acl_valid(acl);
+			if (ret)
+				goto out;
 		} else if (IS_ERR(acl)) {
 			return PTR_ERR(acl);
 		}
 	}
 
 	ret = btrfs_set_acl(NULL, dentry->d_inode, acl, type);
-
+out:
 	posix_acl_release(acl);
 
 	return ret;
-- 
1.7.3.1
