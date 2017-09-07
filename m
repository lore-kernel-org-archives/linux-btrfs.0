Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34911 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755161AbdIGSYO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Sep 2017 14:24:14 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v87IODvL012040
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 7 Sep 2017 18:24:13 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v87IODB1008844
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 7 Sep 2017 18:24:13 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v87IODgw003199
        for <linux-btrfs@vger.kernel.org>; Thu, 7 Sep 2017 18:24:13 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] Btrfs: do not make defrag wait on async_delalloc_pages
Date: Thu,  7 Sep 2017 11:22:21 -0600
Message-Id: <20170907172222.20444-3-bo.li.liu@oracle.com>
In-Reply-To: <20170907172222.20444-1-bo.li.liu@oracle.com>
References: <20170907172222.20444-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

By setting compression for a defrag task, the task will start IO at
the end of defrag.

After the combo of filemap_flush(), we've already made sure that
dirty pages have made progress via async compress thread because the
second filemap_flush() will wait for page lock, which won't be
unlocked until those pages have been marked as writeback and ordered
extents have been queued.

And this is for per-inode defrag, it's not helpful to wait on a global
%async_delalloc_pages and %nr_async_submits from fs_info.

Although waiting on %nr_async_submits means that all bios are
submitted down to per-device schedule IO lists, it doesn't wait for
their completions, thus users still need to do fsync/sync to make sure
the data is on disk.  While with this change, it makes sure that pages
have been marked with writeback bits and will be submitted
asynchronously shortly, therefore, the behavior of defrag option '-c'
remains unchanged.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ioctl.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index fa1b78c..6dbedd8 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1449,21 +1449,6 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 			filemap_flush(inode->i_mapping);
 	}
 
-	if ((range->flags & BTRFS_DEFRAG_RANGE_COMPRESS)) {
-		/* the filemap_flush will queue IO into the worker threads, but
-		 * we have to make sure the IO is actually started and that
-		 * ordered extents get created before we return
-		 */
-		atomic_inc(&fs_info->async_submit_draining);
-		while (atomic_read(&fs_info->nr_async_submits) ||
-		       atomic_read(&fs_info->async_delalloc_pages)) {
-			wait_event(fs_info->async_submit_wait,
-				   (atomic_read(&fs_info->nr_async_submits) == 0 &&
-				    atomic_read(&fs_info->async_delalloc_pages) == 0));
-		}
-		atomic_dec(&fs_info->async_submit_draining);
-	}
-
 	if (range->compress_type == BTRFS_COMPRESS_LZO) {
 		btrfs_set_fs_incompat(fs_info, COMPRESS_LZO);
 	}
-- 
2.9.4

