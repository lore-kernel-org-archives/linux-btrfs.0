Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:25801 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754035Ab2K1K2b (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 Nov 2012 05:28:31 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id qASASUgo030435
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Nov 2012 18:28:30 +0800
Message-ID: <50B5E766.3010804@cn.fujitsu.com>
Date: Wed, 28 Nov 2012 18:28:54 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/2] Btrfs: fix off-by-one error of the reserved size of btrfs_allocate()
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

alloc_end is not the real end of the current extent, it is the start of the
next adjoining extent. So we needn't +1 when calculating the size the space
that is about to be reserved.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 641bbaa..bd5afcc 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2085,7 +2085,7 @@ static long btrfs_fallocate(struct file *file, int mode,
 	 * Make sure we have enough space before we do the
 	 * allocation.
 	 */
-	ret = btrfs_check_data_free_space(inode, alloc_end - alloc_start + 1);
+	ret = btrfs_check_data_free_space(inode, alloc_end - alloc_start);
 	if (ret)
 		return ret;
 
@@ -2192,7 +2192,7 @@ static long btrfs_fallocate(struct file *file, int mode,
 out:
 	mutex_unlock(&inode->i_mutex);
 	/* Let go of our reservation. */
-	btrfs_free_reserved_data_space(inode, alloc_end - alloc_start + 1);
+	btrfs_free_reserved_data_space(inode, alloc_end - alloc_start);
 	return ret;
 }
 
-- 
1.7.11.7
