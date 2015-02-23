Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:34857 "EHLO
	prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751898AbbBWUBC (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Mon, 23 Feb 2015 15:01:02 -0500
From: Filipe Manana <fdmanana@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] Btrfs: do not ignore errors from btrfs_lookup_xattr in do_setxattr
Date: Mon, 23 Feb 2015 19:50:49 +0000
Message-Id: <1424721049-22110-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The return value from btrfs_lookup_xattr() can be a pointer encoding an
error, therefore deal with it. This fixes commit 5f5bc6b1e2d5
("Btrfs: make xattr replace operations atomic").

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/xattr.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index 47b1946..883b936 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -111,6 +111,8 @@ static int do_setxattr(struct btrfs_trans_handle *trans,
 					name, name_len, -1);
 		if (!di && (flags & XATTR_REPLACE))
 			ret = -ENODATA;
+		else if (IS_ERR(di))
+			ret = PTR_ERR(di);
 		else if (di)
 			ret = btrfs_delete_one_dir_name(trans, root, path, di);
 		goto out;
@@ -127,10 +129,12 @@ static int do_setxattr(struct btrfs_trans_handle *trans,
 		ASSERT(mutex_is_locked(&inode->i_mutex));
 		di = btrfs_lookup_xattr(NULL, root, path, btrfs_ino(inode),
 					name, name_len, 0);
-		if (!di) {
+		if (!di)
 			ret = -ENODATA;
+		else if (IS_ERR(di))
+			ret = PTR_ERR(di);
+		if (ret)
 			goto out;
-		}
 		btrfs_release_path(path);
 		di = NULL;
 	}
-- 
2.1.3

