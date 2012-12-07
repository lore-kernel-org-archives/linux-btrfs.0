Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44184 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722Ab2LGDNi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Dec 2012 22:13:38 -0500
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id qB73Dam4030339
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 7 Dec 2012 03:13:37 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id qB73DaUj015356
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 7 Dec 2012 03:13:36 GMT
Received: from abhmt117.oracle.com (abhmt117.oracle.com [141.146.116.69])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id qB73Dafg029651
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Dec 2012 21:13:36 -0600
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: no full sync flag on new inode when we do not reuse inode id
Date: Fri,  7 Dec 2012 11:11:54 +0800
Message-Id: <1354849914-14123-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we are not with inode_cache option, we won't reuse inode id, which
means all of inodes will own different inode id, thus we don't worry
about "reuse of inode id leads to log tree's corruption" thing.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/inode.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 95542a1..8f41ffd 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4717,7 +4717,9 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 	 * sync since it will be a full sync anyway and this will blow away the
 	 * old info in the log.
 	 */
-	set_bit(BTRFS_INODE_NEEDS_FULL_SYNC, &BTRFS_I(inode)->runtime_flags);
+	if (btrfs_test_opt(root, INODE_MAP_CACHE))
+		set_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
+			&BTRFS_I(inode)->runtime_flags);
 
 	if (S_ISDIR(mode))
 		owner = 0;
-- 
1.7.7.6

