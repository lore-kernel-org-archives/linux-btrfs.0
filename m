Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:42749 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbaAAFVK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Jan 2014 00:21:10 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Nazarewicz <mina86@mina86.com>
Subject: [PATCH RESEND] btrfs: remove dead code
Date: Wed,  1 Jan 2014 06:19:49 +0100
Message-Id: <1388553589-26778-1-git-send-email-mina86@mina86.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[commit 8185554d: fix incorrect inode acl reset] introduced a dead
code by adding a condition which can never be true to an else
branch.  The condition can never be true because it is already
checked by a previous if statement which causes function to return.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
Reviewed-By: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/acl.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index 0890c83..460f36b 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -225,13 +225,8 @@ int btrfs_init_acl(struct btrfs_trans_handle *trans,
 		ret = posix_acl_create(&acl, GFP_NOFS, &inode->i_mode);
 		if (ret < 0)
 			return ret;
-
-		if (ret > 0) {
-			/* we need an acl */
+		if (ret > 0) /* we need an acl */
 			ret = btrfs_set_acl(trans, inode, acl, ACL_TYPE_ACCESS);
-		} else if (ret < 0) {
-			cache_no_acl(inode);
-		}
 	} else {
 		cache_no_acl(inode);
 	}
-- 
1.8.4

