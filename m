Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49643 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224AbaGPHhS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Jul 2014 03:37:18 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s6G7bHEt016974
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Jul 2014 07:37:18 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s6G7bGiD021450
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Jul 2014 07:37:16 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s6G7bGF3008384
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Jul 2014 07:37:16 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2] Btrfs: fix abnormal long waiting in fsync
Date: Wed, 16 Jul 2014 15:37:05 +0800
Message-Id: <1405496225-22416-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1405416674-17208-1-git-send-email-bo.li.liu@oracle.com>
References: <1405416674-17208-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

xfstests generic/127 detected this problem.

With commit 7fc34a62ca4434a79c68e23e70ed26111b7a4cf8, now fsync will only flush
data within the passed range.  This is the cause of the above problem,
-- btrfs's fsync has a stage called 'sync log' which will wait for all the
ordered extents it've recorded to finish.

In xfstests/generic/127, with mixed operations such as truncate, fallocate,
punch hole, and mapwrite, we get some pre-allocated extents, and mapwrite will
mmap, and then msync.  And I find that msync will wait for quite a long time
(about 20s in my case), thanks to ftrace, it turns out that the previous
fallocate calls 'btrfs_wait_ordered_range()' to flush dirty pages, but as the
range of dirty pages may be larger than 'btrfs_wait_ordered_range()' wants,
there can be some ordered extents created but not getting corresponding pages
flushed, then they're left in memory until we fsync which runs into the
stage 'sync log', and fsync will just wait for the system writeback thread
to flush those pages and get ordered extents finished, so the latency is
inevitable.

This adds a flush similar to btrfs_start_ordered_extent() in
btrfs_wait_logged_extents() to fix that.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v2: 
   Move flush part into btrfs_wait_logged_extents() to get the flush range
   more precise.

 fs/btrfs/ordered-data.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index e12441c..3b52a76 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -484,8 +484,16 @@ void btrfs_wait_logged_extents(struct btrfs_root *log, u64 transid)
 					   log_list);
 		list_del_init(&ordered->log_list);
 		spin_unlock_irq(&log->log_extents_lock[index]);
+
+		WARN_ON(!ordered->inode);
+		if (!test_bit(BTRFS_ORDERED_DIRECT, &ordered->flags))
+			filemap_fdatawrite_range(ordered->inode->i_mapping,
+				ordered->file_offset,
+				ordered->file_offset + ordered->len - 1);
+
 		wait_event(ordered->wait, test_bit(BTRFS_ORDERED_IO_DONE,
 						   &ordered->flags));
+
 		btrfs_put_ordered_extent(ordered);
 		spin_lock_irq(&log->log_extents_lock[index]);
 	}
-- 
1.8.1.4

