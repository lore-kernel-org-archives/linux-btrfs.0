Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47971 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739Ab2KAGj4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Nov 2012 02:39:56 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by aserp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id qA16dsaR004270
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 1 Nov 2012 06:39:55 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id qA16dsWQ016363
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 1 Nov 2012 06:39:54 GMT
Received: from abhmt104.oracle.com (abhmt104.oracle.com [141.146.116.56])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id qA16dr0g012139
	for <linux-btrfs@vger.kernel.org>; Thu, 1 Nov 2012 01:39:53 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] Btrfs: cleanup for btrfs_wait_order_range
Date: Thu,  1 Nov 2012 14:38:49 +0800
Message-Id: <1351751929-1715-3-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1351751929-1715-1-git-send-email-bo.li.liu@oracle.com>
References: <1351751929-1715-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Variable 'found' is no more used.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ordered-data.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 7772f02..7f75bea 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -606,7 +606,6 @@ void btrfs_wait_ordered_range(struct inode *inode, u64 start, u64 len)
 	u64 end;
 	u64 orig_end;
 	struct btrfs_ordered_extent *ordered;
-	int found;
 
 	if (start + len < start) {
 		orig_end = INT_LIMIT(loff_t);
@@ -642,7 +641,6 @@ void btrfs_wait_ordered_range(struct inode *inode, u64 start, u64 len)
 	filemap_fdatawait_range(inode->i_mapping, start, orig_end);
 
 	end = orig_end;
-	found = 0;
 	while (1) {
 		ordered = btrfs_lookup_first_ordered_extent(inode, end);
 		if (!ordered)
@@ -655,7 +653,6 @@ void btrfs_wait_ordered_range(struct inode *inode, u64 start, u64 len)
 			btrfs_put_ordered_extent(ordered);
 			break;
 		}
-		found++;
 		btrfs_start_ordered_extent(inode, ordered, 1);
 		end = ordered->file_offset;
 		btrfs_put_ordered_extent(ordered);
-- 
1.7.7.6

