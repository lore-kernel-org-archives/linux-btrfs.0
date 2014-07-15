Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32497 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757895AbaGOJbX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Jul 2014 05:31:23 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s6F9VMVT004634
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Jul 2014 09:31:22 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s6F9VL2A002118
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Jul 2014 09:31:22 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s6F9VL06002112
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Jul 2014 09:31:21 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix abnormal long waiting in fsync
Date: Tue, 15 Jul 2014 17:31:14 +0800
Message-Id: <1405416674-17208-1-git-send-email-bo.li.liu@oracle.com>
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

This adds a non-blocked flush, filemap_flush(), in btrfs_sync_file() to fix
that.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/file.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 1f2b99c..1af395d 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2002,6 +2002,8 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 
 	if (ret != BTRFS_NO_LOG_SYNC) {
 		if (!ret) {
+			filemap_flush(inode->i_mapping);
+
 			ret = btrfs_sync_log(trans, root, &ctx);
 			if (!ret) {
 				ret = btrfs_end_transaction(trans, root);
-- 
1.8.1.4

