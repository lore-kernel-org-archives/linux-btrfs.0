Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:26089 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751818AbaANNQM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jan 2014 08:16:12 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s0ECUOnB015721
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Jan 2014 20:30:25 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH V2 1/4] Btrfs: filter the ordered extents that has been logged
Date: Tue, 14 Jan 2014 20:31:49 +0800
Message-Id: <1389702712-26638-2-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1389702712-26638-1-git-send-email-miaox@cn.fujitsu.com>
References: <1389702712-26638-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ordered-data.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 69582d5..e4c3d56 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -433,6 +433,8 @@ void btrfs_get_logged_extents(struct btrfs_root *log, struct inode *inode)
 	spin_lock_irq(&tree->lock);
 	for (n = rb_first(&tree->tree); n; n = rb_next(n)) {
 		ordered = rb_entry(n, struct btrfs_ordered_extent, rb_node);
+		if (test_bit(BTRFS_ORDERED_LOGGED_CSUM, &ordered->flags))
+			continue;
 		spin_lock(&log->log_extents_lock[index]);
 		if (list_empty(&ordered->log_list)) {
 			list_add_tail(&ordered->log_list, &log->logged_list[index]);
-- 
1.7.1

