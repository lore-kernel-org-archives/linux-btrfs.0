From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: [PATCH] Btrfs: cleanup error handling in btrfs_set_acl
Date: Mon, 05 Dec 2011 16:17:19 +0900
Message-ID: <201112050717.AA00040@T-ITOH1.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When kmalloc fails, it returns directly by ENOMEM instead
of 'goto out'.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/acl.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index 89b156d..3757995 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -136,10 +136,8 @@ static int btrfs_set_acl(struct btrfs_trans_handle *trans,
 	if (acl) {
 		size = posix_acl_xattr_size(acl->a_count);
 		value = kmalloc(size, GFP_NOFS);
-		if (!value) {
-			ret = -ENOMEM;
-			goto out;
-		}
+		if (!value)
+			return -ENOMEM;
 
 		ret = posix_acl_to_xattr(acl, value, size);
 		if (ret < 0)

