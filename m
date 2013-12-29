Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29191 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515Ab3L2NpC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 Dec 2013 08:45:02 -0500
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id rBTDj1uH023521
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sun, 29 Dec 2013 13:45:02 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rBTDj1o2013167
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Sun, 29 Dec 2013 13:45:01 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rBTDj1tW026277
	for <linux-btrfs@vger.kernel.org>; Sun, 29 Dec 2013 13:45:01 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] Btrfs: release subvolume's block_rsv before transaction commit
Date: Sun, 29 Dec 2013 21:44:51 +0800
Message-Id: <1388324691-24507-2-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1388324691-24507-1-git-send-email-bo.li.liu@oracle.com>
References: <1388324691-24507-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We don't have to keep subvolume's block_rsv during transaction commit,
and within transaction commit, we may also need the free space reclaimed
from this block_rsv to process delayed refs.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ioctl.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 21da576..347bf61 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -417,7 +417,8 @@ static noinline int create_subvol(struct inode *dir,
 	trans = btrfs_start_transaction(root, 0);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
-		goto out;
+		btrfs_subvolume_release_metadata(root, &block_rsv, qgroup_reserved);
+		return ret;
 	}
 	trans->block_rsv = &block_rsv;
 	trans->bytes_reserved = block_rsv.size;
@@ -542,6 +543,8 @@ static noinline int create_subvol(struct inode *dir,
 fail:
 	trans->block_rsv = NULL;
 	trans->bytes_reserved = 0;
+	btrfs_subvolume_release_metadata(root, &block_rsv, qgroup_reserved);
+
 	if (async_transid) {
 		*async_transid = trans->transid;
 		err = btrfs_commit_transaction_async(trans, root, 1);
@@ -555,8 +558,6 @@ fail:
 
 	if (!ret)
 		d_instantiate(dentry, btrfs_lookup_dentry(dir, dentry));
-out:
-	btrfs_subvolume_release_metadata(root, &block_rsv, qgroup_reserved);
 	return ret;
 }
 
-- 
1.8.2.1

