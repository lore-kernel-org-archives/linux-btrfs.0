Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:18140 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754873Ab3KUNmP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Nov 2013 08:42:15 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rALDgCfS019713
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Nov 2013 21:42:12 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/5] Btrfs: wake up the tasks that wait for the io earlier
Date: Thu, 21 Nov 2013 21:43:14 +0800
Message-Id: <1385041398-8521-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The tasks that wait for the IO_DONE flag just care about the io of the dirty
pages, so it is better to wake up them immediately after all the pages are
written, not the whole process of the io completes.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ordered-data.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index eb5bac4..1bd7002 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -348,10 +348,13 @@ int btrfs_dec_test_first_ordered_pending(struct inode *inode,
 	if (!uptodate)
 		set_bit(BTRFS_ORDERED_IOERR, &entry->flags);
 
-	if (entry->bytes_left == 0)
+	if (entry->bytes_left == 0) {
 		ret = test_and_set_bit(BTRFS_ORDERED_IO_DONE, &entry->flags);
-	else
+		if (waitqueue_active(&entry->wait))
+			wake_up(&entry->wait);
+	} else {
 		ret = 1;
+	}
 out:
 	if (!ret && cached && entry) {
 		*cached = entry;
@@ -408,10 +411,13 @@ have_entry:
 	if (!uptodate)
 		set_bit(BTRFS_ORDERED_IOERR, &entry->flags);
 
-	if (entry->bytes_left == 0)
+	if (entry->bytes_left == 0) {
 		ret = test_and_set_bit(BTRFS_ORDERED_IO_DONE, &entry->flags);
-	else
+		if (waitqueue_active(&entry->wait))
+			wake_up(&entry->wait);
+	} else {
 		ret = 1;
+	}
 out:
 	if (!ret && cached && entry) {
 		*cached = entry;
-- 
1.8.3.1

