Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:54395 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab3GBOk3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Jul 2013 10:40:29 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 76F1F7C0695
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Jul 2013 08:40:29 -0600 (MDT)
Received: from CAS2.int.fusionio.com (cas2.int.fusionio.com [10.101.1.41]) by mx1.fusionio.com with ESMTP id I8R1ALYZEXz9AInN (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 02 Jul 2013 08:40:29 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: wait ordered range before doing direct io
Date: Tue, 2 Jul 2013 10:40:26 -0400
Message-ID: <1372776026-5480-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

My recent truncate patch uncovered this bug, but I can reproduce it without the
truncate patch.  If you mount with -o compress-force, do a direct write to some
area, do a buffered write to some other area, and then do a direct read you will
get the wrong data for where you did the buffered write.  This is because the
generic direct io helpers only call filemap_write_and_wait once, and for
compression we need it twice.  So to be safe add the btrfs_wait_ordered_range to
the start of the direct io function to make sure any compressed writes have
truly been written.  This patch makes xfstests 130 pass when you mount with -o
compress-force=lzo.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/inode.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b7fa96f..4384c7c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7254,8 +7254,16 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
 	atomic_inc(&inode->i_dio_count);
 	smp_mb__after_atomic_inc();
 
+	/*
+	 * The generic stuff only does filemap_write_and_wait_range, which isn't
+	 * enough if we've written compressed pages to this area, so we need to
+	 * call btrfs_wait_ordered_range to make absolutely sure that any
+	 * outstanding dirty pages are on disk.
+	 */
+	count = iov_length(iov, nr_segs);
+	btrfs_wait_ordered_range(inode, offset, count);
+
 	if (rw & WRITE) {
-		count = iov_length(iov, nr_segs);
 		/*
 		 * If the write DIO is beyond the EOF, we need update
 		 * the isize, but it is protected by i_mutex. So we can
-- 
1.7.7.6

