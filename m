Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:7657 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751089AbaDAKEI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Apr 2014 06:04:08 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s31A45Zi012486
	for <linux-btrfs@vger.kernel.org>; Tue, 1 Apr 2014 18:04:05 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 1/2] Btrfs: don't compress for a small write
Date: Tue, 1 Apr 2014 18:01:42 +0800
Message-ID: <1396346503-24816-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

To compress a small file range(<=blocksize) that is not
an inline extent can not save disk space at all. skip it can
save us some cpu time.

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
v1->v2:
	make comments and change log more clear that we only skip
	small data that can not be inlined.(pointed by Chris)
---
 fs/btrfs/inode.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0ec8766..5cb3075 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -394,6 +394,14 @@ static noinline int compress_file_range(struct inode *inode,
 	    (start > 0 || end + 1 < BTRFS_I(inode)->disk_i_size))
 		btrfs_add_inode_defrag(NULL, inode);
 
+	/*
+	 * skip compression for a small file range(<=blocksize) that
+	 * isn't an inline extent, since it dosen't save disk space at all.
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

