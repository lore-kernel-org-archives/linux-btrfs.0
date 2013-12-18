Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:8691 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751320Ab3LRKvz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Dec 2013 05:51:55 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rBIApVEA019488
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Dec 2013 18:51:31 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: improve the performance fluctuating of the fsync
Date: Wed, 18 Dec 2013 18:52:44 +0800
Message-Id: <1387363964-20316-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In order to improve the performance of fsync, we use the outstanding
ordered extents to avoid looking up the checksum from the csum tree.
But we didn't filter out the ordered extents whose csum is still being
calculated, when we got those ordered extents, we had to wait for the
csum calculation. It made the performance dropped down suddenly. (On
my box, it drop down from 56MB/s to 4-10MB/s)

But actually, the csum calculation of the ordered extents which were
introduced by the current fsync had already completed. Those ordered
extents whose csum was being calculated didn't belong to the current
fsync, we can ignore them.

By this patch, the performance fluctuating doesn't happen, and the average
performance grows up by ~2%.

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
 fs/btrfs/ordered-data.c | 3 +++
 fs/btrfs/tree-log.c     | 2 --
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index b8c2ded..df87ed5 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -433,6 +433,9 @@ void btrfs_get_logged_extents(struct btrfs_root *log, struct inode *inode)
 	spin_lock_irq(&tree->lock);
 	for (n = rb_first(&tree->tree); n; n = rb_next(n)) {
 		ordered = rb_entry(n, struct btrfs_ordered_extent, rb_node);
+		if (ordered->csum_bytes_left)
+			continue;
+
 		spin_lock(&log->log_extents_lock[index]);
 		if (list_empty(&ordered->log_list)) {
 			list_add_tail(&ordered->log_list, &log->logged_list[index]);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index ba2f151..3eae2eb 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3631,8 +3631,6 @@ again:
 		 * start over after this.
 		 */
 
-		wait_event(ordered->wait, ordered->csum_bytes_left == 0);
-
 		list_for_each_entry(sum, &ordered->list, list) {
 			ret = btrfs_csum_file_blocks(trans, log, sum);
 			if (ret) {
-- 
1.8.3.1

