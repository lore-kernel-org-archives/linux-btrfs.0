Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29188 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab3L2NpC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 Dec 2013 08:45:02 -0500
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id rBTDj0KE023253
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sun, 29 Dec 2013 13:45:01 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rBTDj06R004339
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Sun, 29 Dec 2013 13:45:00 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rBTDixC0004333
	for <linux-btrfs@vger.kernel.org>; Sun, 29 Dec 2013 13:44:59 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] Btrfs: return free space to global_rsv as much as possible
Date: Sun, 29 Dec 2013 21:44:50 +0800
Message-Id: <1388324691-24507-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

@full is not protected within global_rsv.lock, so we may think global_rsv
is already full but in fact it's not, so we miss the opportunity to return
free space to global_rsv directly when we release other block_rsvs.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent-tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 9c01509..009980c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4637,7 +4637,7 @@ void btrfs_block_rsv_release(struct btrfs_root *root,
 			     u64 num_bytes)
 {
 	struct btrfs_block_rsv *global_rsv = &root->fs_info->global_block_rsv;
-	if (global_rsv->full || global_rsv == block_rsv ||
+	if (global_rsv == block_rsv ||
 	    block_rsv->space_info != global_rsv->space_info)
 		global_rsv = NULL;
 	block_rsv_release_bytes(root->fs_info, block_rsv, global_rsv,
-- 
1.8.2.1

