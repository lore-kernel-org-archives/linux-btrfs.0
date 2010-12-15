From: Mariusz Kozlowski <mk@lab.zgora.pl>
Subject: [PATCH] btrfs: fix memory leak on error path in btrfs_get_acl()
Date: Wed, 15 Dec 2010 22:57:36 +0100
Message-ID: <1292450256-4544-1-git-send-email-mk@lab.zgora.pl>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Mariusz Kozlowski <mk@lab.zgora.pl>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

If posix_acl_from_xattr() fails we leak memory stored in 'value'.

Signed-off-by: Mariusz Kozlowski <mk@lab.zgora.pl>
---
 fs/btrfs/acl.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index 2222d16..11c9561 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -61,6 +61,7 @@ static struct posix_acl *btrfs_get_acl(struct inode *inode, int type)
 		if (size > 0) {
 			acl = posix_acl_from_xattr(value, size);
 			if (IS_ERR(acl))
+				kfree(value);
 				return acl;
 			set_cached_acl(inode, type, acl);
 		}
-- 
1.7.0.4
