Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44280 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754712AbaGQIIq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Jul 2014 04:08:46 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s6H88iF6018341
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Jul 2014 08:08:45 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by ucsinet22.oracle.com (8.14.5+Sun/8.14.5) with ESMTP id s6H88iPP022290
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Jul 2014 08:08:44 GMT
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
	by userz7022.oracle.com (8.14.5+Sun/8.14.4) with ESMTP id s6H88hvO022245
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Jul 2014 08:08:43 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH v3] Btrfs: fix abnormal long waiting in fsync
Date: Thu, 17 Jul 2014 16:08:36 +0800
Message-Id: <1405584516-16881-1-git-send-email-bo.li.liu@oracle.com>
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

Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v3:
   Add a check for IO_DONE flag to avoid unnecessary flush.
v2: 
   Move flush part into btrfs_wait_logged_extents() to get the flush range
   more precise.

 fs/btrfs/ordered-data.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index e12441c..7187b14 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -484,8 +484,19 @@ void btrfs_wait_logged_extents(struct btrfs_root *log, u64 transid)
 					   log_list);
 		list_del_init(&ordered->log_list);
 		spin_unlock_irq(&log->log_extents_lock[index]);
+
+		if (!test_bit(BTRFS_ORDERED_IO_DONE, &ordered->flags) &&
+		    !test_bit(BTRFS_ORDERED_DIRECT, &ordered->flags)) {
+			struct inode *inode = ordered->inode;
+			u64 start = ordered->file_offset;
+			u64 end = ordered->file_offset + ordered->len - 1;
+
+			WARN_ON(!inode);
+			filemap_fdatawrite_range(inode->i_mapping, start, end);
+		}
 		wait_event(ordered->wait, test_bit(BTRFS_ORDERED_IO_DONE,
 						   &ordered->flags));
+
 		btrfs_put_ordered_extent(ordered);
 		spin_lock_irq(&log->log_extents_lock[index]);
 	}
-- 
1.8.1.4

