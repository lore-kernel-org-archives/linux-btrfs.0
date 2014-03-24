Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:35980 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752249AbaCXKAe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Mar 2014 06:00:34 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s2OA0PVc026163
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Mar 2014 18:00:25 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] Btrfs: don't compress for a small write
Date: Mon, 24 Mar 2014 17:58:10 +0800
Message-Id: <1395655091-5318-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

To compress a small write(<=blocksize) dosen't save us
disk space at all, skip it can save us some compression time.

This patch can also fix wrong setting nocompression flag for
inode, say a case when @total_in is 4096, and then we get
@total_compressed 52,because we do aligment to page cache size
firstly, and then we get into conclusion @total_in=@total_compressed
thus we will clear this inode's compression flag.

An exception comes from inserting inline extent failure but we
still have @total_compressed < @total_in,so we will still reset
inode's flag, this is ok, because we don't have good compression
effect.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 fs/btrfs/inode.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0ec8766..d3eccd6 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -394,6 +394,15 @@ static noinline int compress_file_range(struct inode *inode,
 	    (start > 0 || end + 1 < BTRFS_I(inode)->disk_i_size))
 		btrfs_add_inode_defrag(NULL, inode);
 
+	/*
+	 * if this is a small write(<=blocksize), we don't save
+	 * disk space at all, don't compress which can save us some
+	 * compression time.
+	 */
+	if ((end - start + 1) <= blocksize &&
+	    (start > 0 || end + 1 < BTRFS_I(inode)->disk_i_size))
+		goto cleanup_and_bail_uncompressed;
+
 	actual_end = min_t(u64, isize, end + 1);
 again:
 	will_compress = 0;
-- 
1.9.0

