Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41187 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbaAIG52 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Jan 2014 01:57:28 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Josef Bacik <jbacik@fb.com>
Subject: [PATCH v2] Btrfs: release subvolume's block_rsv before transaction commit
Date: Thu,  9 Jan 2014 14:57:06 +0800
Message-Id: <1389250626-3461-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <52CD6D2A.9090900@fb.com>
References: <52CD6D2A.9090900@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We don't have to keep subvolume's block_rsv during transaction commit,
and within transaction commit, we may also need the free space reclaimed
from this block_rsv to process delayed refs.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v2: rebase onto the latest btrfs-next.

 fs/btrfs/ioctl.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 3970f32..332b624 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -436,7 +436,9 @@ static noinline int create_subvol(struct inode *dir,
 	trans = btrfs_start_transaction(root, 0);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
-		goto out;
+		btrfs_subvolume_release_metadata(root, &block_rsv,
+						 qgroup_reserved);
+		return ret;
 	}
 	trans->block_rsv = &block_rsv;
 	trans->bytes_reserved = block_rsv.size;
@@ -561,6 +563,8 @@ static noinline int create_subvol(struct inode *dir,
 fail:
 	trans->block_rsv = NULL;
 	trans->bytes_reserved = 0;
+	btrfs_subvolume_release_metadata(root, &block_rsv, qgroup_reserved);
+
 	if (async_transid) {
 		*async_transid = trans->transid;
 		err = btrfs_commit_transaction_async(trans, root, 1);
@@ -574,14 +578,10 @@ fail:
 
 	if (!ret) {
 		inode = btrfs_lookup_dentry(dir, dentry);
-		if (IS_ERR(inode)) {
-			ret = PTR_ERR(inode);
-			goto out;
-		}
+		if (IS_ERR(inode))
+			return PTR_ERR(inode);
 		d_instantiate(dentry, inode);
 	}
-out:
-	btrfs_subvolume_release_metadata(root, &block_rsv, qgroup_reserved);
 	return ret;
 }
 
-- 
1.8.1.4

