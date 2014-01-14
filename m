Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:30785 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751826AbaANNQS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jan 2014 08:16:18 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s0ECUOnC015721
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Jan 2014 20:30:26 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH V2 4/4] Btrfs: flush the dirty pages of the ordered extent aggressively during logging csum
Date: Tue, 14 Jan 2014 20:31:52 +0800
Message-Id: <1389702712-26638-5-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1389702712-26638-1-git-send-email-miaox@cn.fujitsu.com>
References: <1389702712-26638-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The performance of fsync dropped down suddenly sometimes, the main reason
of this problem was that we might only flush part dirty pages in a ordered
extent, then got that ordered extent, wait for the csum calcucation. But if
no task flushed the left part, we would wait until the flusher flushed them,
sometimes we need wait for several seconds, it made the performance drop
down suddenly. (On my box, it drop down from 56MB/s to 4-10MB/s)

This patch improves the above problem by flushing left dirty pages aggressively.

Test Environment:
CPU:		2CPU * 2Cores
Memory:		4GB
Partition:	20GB(HDD)

Test Command:
 # sysbench --num-threads=8 --test=fileio --file-num=1 \
 > --file-total-size=8G --file-block-size=32768 \
 > --file-io-mode=sync --file-fsync-freq=100 \
 > --file-fsync-end=no --max-requests=10000 \
 > --file-test-mode=rndwr run

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/tree-log.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 251e6f4..944701b 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3470,7 +3470,11 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
 				     &ordered->flags))
 			continue;
 
-		wait_event(ordered->wait, ordered->csum_bytes_left == 0);
+		if (ordered->csum_bytes_left) {
+			btrfs_start_ordered_extent(inode, ordered, 0);
+			wait_event(ordered->wait,
+				   ordered->csum_bytes_left == 0);
+		}
 
 		list_for_each_entry(sum, &ordered->list, list) {
 			ret = btrfs_csum_file_blocks(trans, log, sum);
-- 
1.7.1

