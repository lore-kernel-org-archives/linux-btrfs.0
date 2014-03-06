Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:20803 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751477AbaCFFxi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Mar 2014 00:53:38 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s265rU1n009846
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Mar 2014 13:53:31 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH V2 02/10] Btrfs: wake up the tasks that wait for the io earlier
Date: Thu, 6 Mar 2014 13:54:56 +0800
Message-Id: <1394085304-32589-2-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1394085304-32589-1-git-send-email-miaox@cn.fujitsu.com>
References: <1394085304-32589-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The tasks that wait for the IO_DONE flag just care about the io of the dirty
pages, so it is better to wake up them immediately after all the pages are
written, not the whole process of the io completes.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v1 -> v2:
- None.
---
 fs/btrfs/ordered-data.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index a6ba75e..067e129 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -349,10 +349,13 @@ int btrfs_dec_test_first_ordered_pending(struct inode *inode,
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
@@ -410,10 +413,13 @@ have_entry:
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
1.8.1.4

