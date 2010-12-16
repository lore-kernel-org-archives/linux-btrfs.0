From: Mariusz Kozlowski <mk@lab.zgora.pl>
Subject: [PATCH v2] btrfs: fix memory leak on error path in btrfs_get_acl()
Date: Thu, 16 Dec 2010 07:10:18 +0100
Message-ID: <1292479818-5135-1-git-send-email-mk@lab.zgora.pl>
References: <20101216055637.GA4826@mako-laptop>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Mariusz Kozlowski <mk@lab.zgora.pl>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101216055637.GA4826@mako-laptop>
List-ID: <linux-btrfs.vger.kernel.org>

If posix_acl_from_xattr() fails we leak memory stored in 'value'.

Signed-off-by: Mariusz Kozlowski <mk@lab.zgora.pl>
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
1.7.0.4

