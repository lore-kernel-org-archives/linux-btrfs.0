Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47962 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739Ab2KAGjw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Nov 2012 02:39:52 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id qA16dpEG004258
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 1 Nov 2012 06:39:51 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id qA16doBP014644
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 1 Nov 2012 06:39:51 GMT
Received: from abhmt104.oracle.com (abhmt104.oracle.com [141.146.116.56])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id qA16do8j012119
	for <linux-btrfs@vger.kernel.org>; Thu, 1 Nov 2012 01:39:50 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] Btrfs: do not log extents when we only log new names
Date: Thu,  1 Nov 2012 14:38:47 +0800
Message-Id: <1351751929-1715-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we log new names, we need to log just enough to recreate the inode
during log replay, and there is no need to log extents along with it.

This actually fixes a bug revealed by xfstests 241, where it shows
that we're logging some extents that have not updated metadata,
so we don't get proper EXTENT_DATA items to be copied to log tree.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/tree-log.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 81e407d..4ec41ec 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3435,7 +3435,8 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 			ret = btrfs_truncate_inode_items(trans, log,
 							 inode, 0, 0);
 		} else {
-			fast_search = true;
+			if (inode_only == LOG_INODE_ALL)
+				fast_search = true;
 			max_key.type = BTRFS_XATTR_ITEM_KEY;
 			ret = drop_objectid_items(trans, log, path, ino,
 						  BTRFS_XATTR_ITEM_KEY);
-- 
1.7.7.6

