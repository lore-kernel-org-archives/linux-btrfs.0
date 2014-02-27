Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:18586 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751474AbaB0F4f (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Feb 2014 00:56:35 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s1R5uVRZ006350
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Feb 2014 13:56:31 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] Btrfs: don't skip the page flush since the enospc is not brought by it
Date: Thu, 27 Feb 2014 13:58:03 +0800
Message-Id: <1393480685-4320-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As we know, btrfs flushes the continuous pages as many as possible,
but if all the free spaces are small, we will allocate the spaces by
several times, and if there is something wrong with the space
reservation, it is very likely that some allocations succeed and
the others fail. But the current code doesn't take this case into
account, and set the error flag for the pages though their spaces
are allocated successfully. It introduces a problem that we can not
umount the fs after the above problem happens because we need wait
for the flush of those pages whose spaces are allocated. This patch
fixes the above problem, and makes the btrfs developers happy when
they investigate the problem of the space reservation.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/extent_io.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index fbe501d..97595ea 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3198,8 +3198,19 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 						       &nr_written);
 			/* File system has been set read-only */
 			if (ret) {
-				SetPageError(page);
-				goto done;
+				/*
+				 * Private2 means we allocate the space
+				 * for this page successfully, and enospc
+				 * error doesn't set the fs to be R/O, so
+				 * we can write out the page and needn't
+				 * set error flag for this page. If so, we
+				 * can prevent the umount task from being
+				 * blocked.
+				 */
+				if (!(ret == -ENOSPC && PagePrivate2(page))) {
+					SetPageError(page);
+					goto done;
+				}
 			}
 			/*
 			 * delalloc_end is already one less than the total
-- 
1.8.1.4

