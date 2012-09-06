Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:14691 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757635Ab2IFKot (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Sep 2012 06:44:49 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q86A59AY017666
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Sep 2012 18:05:12 +0800
Message-ID: <50487549.5040206@cn.fujitsu.com>
Date: Thu, 06 Sep 2012 18:04:57 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH V4 12/12] Btrfs: fix wrong size for the reservation when doing,
 file pre-allocation.
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <50487434.1010305@cn.fujitsu.com>

When we ran fsstress(a program in xfstests), the filesystem hung up when it
is full. It was because the space reserved in btrfs_fallocate() was wrong,
btrfs_fallocate() just used the size of the pre-allocation to reserve the
space, didn't took the block size aligning into account, so the size of
the reserved space was less than the allocated space, it caused the over
reserve problem and made the filesystem hung up when invoking cow_file_range().
Fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v1 -> v4:
- new patch.
---
 fs/btrfs/file.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index af888da..1a5f76b 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1640,7 +1640,7 @@ static long btrfs_fallocate(struct file *file, int mode,
 	 * Make sure we have enough space before we do the
 	 * allocation.
 	 */
-	ret = btrfs_check_data_free_space(inode, len);
+	ret = btrfs_check_data_free_space(inode, alloc_end - alloc_start + 1);
 	if (ret)
 		return ret;
 
@@ -1747,7 +1747,7 @@ static long btrfs_fallocate(struct file *file, int mode,
 out:
 	mutex_unlock(&inode->i_mutex);
 	/* Let go of our reservation. */
-	btrfs_free_reserved_data_space(inode, len);
+	btrfs_free_reserved_data_space(inode, alloc_end - alloc_start + 1);
 	return ret;
 }
 
-- 
1.7.6.5
