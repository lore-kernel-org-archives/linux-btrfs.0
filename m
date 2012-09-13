Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:63237 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757526Ab2IMLAk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Sep 2012 07:00:40 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q8DArrfF031096
	for <linux-btrfs@vger.kernel.org>; Thu, 13 Sep 2012 18:53:53 +0800
Message-ID: <5051BB3B.5020201@cn.fujitsu.com>
Date: Thu, 13 Sep 2012 18:53:47 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/2] Revert "Btrfs: do not do filemap_write_and_wait_range
 in fsync"
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This reverts commit 0885ef5b5601e9b007c383e77c172769b1f214fd

After applying the above patch, the performance slowed down because the dirty
page flush can only be done by one task, so revert it.

The following is the test result of sysbench:
	Before		After
	24MB/s		39MB/s

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/file.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 1a5f76b..1ea5c39 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1513,12 +1513,20 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 
 	trace_btrfs_sync_file(file, datasync);
 
+	/*
+	 * We write the dirty pages in the range and wait until they complete
+	 * out of the ->i_mutex. If so, we can flush the dirty pages by
+	 * multi-task, and make the performance up.
+	 */
+	ret = filemap_write_and_wait_range(inode->i_mapping, start, end);
+	if (ret)
+		return ret;
+
 	mutex_lock(&inode->i_mutex);
 
 	/*
-	 * we wait first, since the writeback may change the inode, also wait
-	 * ordered range does a filemape_write_and_wait_range which is why we
-	 * don't do it above like other file systems.
+	 * We flush the dirty pages again to avoid some dirty pages in the
+	 * range being left.
 	 */
 	atomic_inc(&root->log_batch);
 	btrfs_wait_ordered_range(inode, start, end);
-- 
1.7.6.5
