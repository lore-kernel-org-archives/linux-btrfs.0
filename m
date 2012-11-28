Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23203 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471Ab2K1KpA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 Nov 2012 05:45:00 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Arendt <admin@prnet.org>
Subject: [PATCH 2/2] Btrfs: don't add a NULL extended attribute
Date: Wed, 28 Nov 2012 18:43:12 +0800
Message-Id: <1354099392-2820-2-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1354099392-2820-1-git-send-email-bo.li.liu@oracle.com>
References: <1354099392-2820-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Passing a null extended attribute value means to remove the attribute,
but we don't have to add a new NULL extended attribute.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/xattr.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index 3f4e2d6..be8376a 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -122,6 +122,16 @@ static int do_setxattr(struct btrfs_trans_handle *trans,
 		 */
 		if (!value)
 			goto out;
+	} else {
+		di = btrfs_lookup_xattr(NULL, root, path, btrfs_ino(inode),
+					name, name_len, 0);
+		if (IS_ERR(di)) {
+			ret = PTR_ERR(di);
+			goto out;
+		}
+		if (!di && !value)
+			goto out;
+		btrfs_release_path(path);
 	}
 
 again:
-- 
1.7.7.6

