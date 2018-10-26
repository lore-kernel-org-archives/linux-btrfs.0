Return-Path: <SRS0=9Rtw=NG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85AFDC6786E
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Oct 2018 11:13:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E0862075D
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Oct 2018 11:13:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3E0862075D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727475AbeJZTui (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 26 Oct 2018 15:50:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:51626 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727265AbeJZTui (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Oct 2018 15:50:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 74126AE86
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Oct 2018 11:13:55 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     dsterba@suse.com
Cc:     linux-btrfs@vger.kernel.org, wqu@suse.com,
        Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Fix error handling in btrfs_cleanup_ordered_extents
Date:   Fri, 26 Oct 2018 14:13:47 +0300
Message-Id: <1540552427-8108-1-git-send-email-nborisov@suse.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Running btrfs/124 in a loop hung up on me sporadically with the
following call trace:

	btrfs           D    0  5760   5324 0x00000000
	Call Trace:
	 ? __schedule+0x243/0x800
	 schedule+0x33/0x90
	 btrfs_start_ordered_extent+0x10c/0x1b0 [btrfs]
	 ? wait_woken+0xa0/0xa0
	 btrfs_wait_ordered_range+0xbb/0x100 [btrfs]
	 btrfs_relocate_block_group+0x1ff/0x230 [btrfs]
	 btrfs_relocate_chunk+0x49/0x100 [btrfs]
	 btrfs_balance+0xbeb/0x1740 [btrfs]
	 btrfs_ioctl_balance+0x2ee/0x380 [btrfs]
	 btrfs_ioctl+0x1691/0x3110 [btrfs]
	 ? lockdep_hardirqs_on+0xed/0x180
	 ? __handle_mm_fault+0x8e7/0xfb0
	 ? _raw_spin_unlock+0x24/0x30
	 ? __handle_mm_fault+0x8e7/0xfb0
	 ? do_vfs_ioctl+0xa5/0x6e0
	 ? btrfs_ioctl_get_supported_features+0x30/0x30 [btrfs]
	 do_vfs_ioctl+0xa5/0x6e0
	 ? entry_SYSCALL_64_after_hwframe+0x3e/0xbe
	 ksys_ioctl+0x3a/0x70
	 __x64_sys_ioctl+0x16/0x20
	 do_syscall_64+0x60/0x1b0
	 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Turns out during page writeback it's possible that the code in
writepage_delalloc can instantiate a delalloc range which doesn't
belong to the page currently being written back. This happens since
find_lock_delalloc_range returns up to BTRFS_MAX_EXTENT_SIZE delalloc range
when asked and doens't really consider the range of the passed page. When such
a foregin range is found the code proceeds to run_delalloc_range and calls the
appropriate function to fill the delalloc and create ordered extents. If,
however, a failure occurs while this operation is in effect then the clean up
code in btrfs_cleanup_ordered_extents will be called. This function has the
wrong assumption that caller of run_delalloc_range always properly cleans the
first page of the range hence when it calls __endio_write_update_ordered it
explicitly ommits the first page of the delalloc range. This is wrong because
this function could be cleaning a delalloc range that doesn't belong to the
current page. This in turn means that the page cleanup code in 
__extent_writepage will not really free the initial page for the range, leaving
a hanging ordered extent with bytes_left set to 4k. This bug has been present
ever since the original introduction of the cleanup code in 524272607e88.

Fix this by correctly checking whether the current page belongs to the
range being instantiated and if so correctly adjust the range parameters
passed for cleaning up. If it doesn't, then just clean the whole OE
range directly. 

524272607e88 ("btrfs: Handle delalloc error correctly to avoid ordered extent hang")
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
With this patch I can no longer get btrfs/124 to hang nor do I see any 
regressions in xfstest. 

Furthermore, this needs to go in stable since v4.12

 fs/btrfs/inode.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index de4e3a9563f7..f6a96da2f2ea 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -109,17 +109,17 @@ static void __endio_write_update_ordered(struct inode *inode,
  * extent_clear_unlock_delalloc() to clear both the bits EXTENT_DO_ACCOUNTING
  * and EXTENT_DELALLOC simultaneously, because that causes the reserved metadata
  * to be released, which we want to happen only when finishing the ordered
- * extent (btrfs_finish_ordered_io()). Also note that the caller of the
- * fill_delalloc() callback already does proper cleanup for the first page of
- * the range, that is, it invokes the callback writepage_end_io_hook() for the
- * range of the first page.
+ * extent (btrfs_finish_ordered_io()).
  */
 static inline void btrfs_cleanup_ordered_extents(struct inode *inode,
-						 const u64 offset,
-						 const u64 bytes)
+						 struct page *locked_page,
+						 u64 offset, u64 bytes)
 {
 	unsigned long index = offset >> PAGE_SHIFT;
 	unsigned long end_index = (offset + bytes - 1) >> PAGE_SHIFT;
+	u64 page_start = page_offset(locked_page);
+	u64 page_end = page_start + PAGE_SIZE - 1;
+
 	struct page *page;
 
 	while (index <= end_index) {
@@ -130,8 +130,18 @@ static inline void btrfs_cleanup_ordered_extents(struct inode *inode,
 		ClearPagePrivate2(page);
 		put_page(page);
 	}
-	return __endio_write_update_ordered(inode, offset + PAGE_SIZE,
-					    bytes - PAGE_SIZE, false);
+
+	/*
+	 * In case this page belongs to the delalloc range being instantiated
+	 * then skip it, since the first page of a range is going to be
+	 * properly cleaned up by the caller of run_delalloc_range
+	 */
+	if (page_start >= offset && page_end <= (offset + bytes - 1) {
+		offset += PAGE_SIZE;
+		bytes -= PAGE_SIZE;
+	}
+
+	return __endio_write_update_ordered(inode, offset, bytes, false);
 }
 
 static int btrfs_dirty_inode(struct inode *inode);
@@ -1605,7 +1615,8 @@ static int run_delalloc_range(void *private_data, struct page *locked_page,
 					   write_flags);
 	}
 	if (ret)
-		btrfs_cleanup_ordered_extents(inode, start, end - start + 1);
+		btrfs_cleanup_ordered_extents(inode, locked_page, start,
+					      end - start + 1);
 	return ret;
 }
 
-- 
2.7.4

