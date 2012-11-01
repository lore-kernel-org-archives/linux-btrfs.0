Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38196 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739Ab2KAGjy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Nov 2012 02:39:54 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id qA16dqWm011144
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 1 Nov 2012 06:39:53 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id qA16dqZi005765
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 1 Nov 2012 06:39:52 GMT
Received: from abhmt104.oracle.com (abhmt104.oracle.com [141.146.116.56])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id qA16dq3Q012135
	for <linux-btrfs@vger.kernel.org>; Thu, 1 Nov 2012 01:39:52 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] Btrfs: get right arguments for btrfs_wait_ordered_range
Date: Thu,  1 Nov 2012 14:38:48 +0800
Message-Id: <1351751929-1715-2-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1351751929-1715-1-git-send-email-bo.li.liu@oracle.com>
References: <1351751929-1715-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_wait_ordered_range expects for 'len' instead of 'end'.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/file.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 9ab1bed..d2df981 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1562,7 +1562,7 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	 * range being left.
 	 */
 	atomic_inc(&root->log_batch);
-	btrfs_wait_ordered_range(inode, start, end);
+	btrfs_wait_ordered_range(inode, start, end - start + 1);
 	atomic_inc(&root->log_batch);
 
 	/*
-- 
1.7.7.6

