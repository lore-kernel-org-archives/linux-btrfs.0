Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:9645 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751469AbaCFFxf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Mar 2014 00:53:35 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s265rUda009848
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Mar 2014 13:53:31 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH V2 03/10] Btrfs: just do dirty page flush for the inode with compression before direct IO
Date: Thu, 6 Mar 2014 13:54:57 +0800
Message-Id: <1394085304-32589-3-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1394085304-32589-1-git-send-email-miaox@cn.fujitsu.com>
References: <1394085304-32589-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As the comment in the btrfs_direct_IO says, only the compressed pages need be
flush again to make sure they are on the disk, but the common pages needn't,
so we add a if statement to check if the inode has compressed pages or not,
if no, skip the flush.

And in order to prevent the write ranges from intersecting, we need wait for
the running ordered extents. But the current code waits for them twice, one
is done before the direct IO starts (in btrfs_wait_ordered_range()), the other
is before we get the blocks, it is unnecessary. because we can do the direct
IO without holding i_mutex, it means that the intersected ordered extents may
happen during the direct IO, the first wait can not avoid this problem. So we
use filemap_fdatawrite_range() instead of btrfs_wait_ordered_range() to remove
the first wait.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v1 -> v2:
- None.
---
 fs/btrfs/inode.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1af34d0..8c9522b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7401,15 +7401,15 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
 	smp_mb__after_atomic_inc();
 
 	/*
-	 * The generic stuff only does filemap_write_and_wait_range, which isn't
-	 * enough if we've written compressed pages to this area, so we need to
-	 * call btrfs_wait_ordered_range to make absolutely sure that any
-	 * outstanding dirty pages are on disk.
+	 * The generic stuff only does filemap_write_and_wait_range, which
+	 * isn't enough if we've written compressed pages to this area, so
+	 * we need to flush the dirty pages again to make absolutely sure
+	 * that any outstanding dirty pages are on disk.
 	 */
 	count = iov_length(iov, nr_segs);
-	ret = btrfs_wait_ordered_range(inode, offset, count);
-	if (ret)
-		return ret;
+	if (test_bit(BTRFS_INODE_HAS_ASYNC_EXTENT,
+		     &BTRFS_I(inode)->runtime_flags))
+		filemap_fdatawrite_range(inode->i_mapping, offset, count);
 
 	if (rw & WRITE) {
 		/*
-- 
1.8.1.4

