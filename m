Return-Path: <SRS0=CLOi=OA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEF01C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 15:10:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85DED21479
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 15:10:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 85DED21479
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729904AbeKVBpq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 21 Nov 2018 20:45:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:49762 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729128AbeKVBpq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Nov 2018 20:45:46 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 91E8BAF09
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Nov 2018 15:10:54 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCHv3] btrfs: Fix error handling in btrfs_cleanup_ordered_extents
Date:   Wed, 21 Nov 2018 17:10:52 +0200
Message-Id: <20181121151052.18744-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
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

This happens because during page writeback it's valid for
writepage_delalloc to instantiate a delalloc range which doesn't
belong to the page currently being written back.

The reason this case is valid is due to find_lock_delalloc_range
returning any available range after the passed delalloc_start and
ignorting whether the page under writeback is within that range.
In turn ordered extents (OE) are always created for the returned range
from find_lock_delalloc_range. If, however, a failure occurs while OE
are being created then the clean up code in btrfs_cleanup_ordered_extents
will be called.

Unfortunately the code in btrfs_cleanup_ordered_extents doesn't consider
the case of such 'foreign' range being processed and instead it always
assumes that the range OE are created for belongs to the page. This
leads to the first page of such foregin range to not be cleaned up since
it's deliberately missed skipped by the current cleaning up code.

Fix this by correctly checking whether the current page belongs to the
range being instantiated and if so adjsut the range parameters
passed for cleaning up. If it doesn't, then just clean the whole OE
range directly.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
---
V3:
 * Re-worded the commit for easier comprehension
 * Added RB tag from Josef

V2:
 * Fix compilation failure due to missing parentheses
 * Fixed the "Fixes" tag.
 fs/btrfs/inode.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a0fc564626df..9f65f131f244 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -110,17 +110,17 @@ static void __endio_write_update_ordered(struct inode *inode,
  * extent_clear_unlock_delalloc() to clear both the bits EXTENT_DO_ACCOUNTING
  * and EXTENT_DELALLOC simultaneously, because that causes the reserved metadata
  * to be released, which we want to happen only when finishing the ordered
- * extent (btrfs_finish_ordered_io()). Also note that the caller of
- * btrfs_run_delalloc_range already does proper cleanup for the first page of
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
@@ -131,8 +131,18 @@ static inline void btrfs_cleanup_ordered_extents(struct inode *inode,
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
+	if (page_start >= offset && page_end <= (offset + bytes - 1)) {
+		offset += PAGE_SIZE;
+		bytes -= PAGE_SIZE;
+	}
+
+	return __endio_write_update_ordered(inode, offset, bytes, false);
 }
 
 static int btrfs_dirty_inode(struct inode *inode);
@@ -1605,7 +1615,8 @@ int btrfs_run_delalloc_range(void *private_data, struct page *locked_page,
 					   write_flags);
 	}
 	if (ret)
-		btrfs_cleanup_ordered_extents(inode, start, end - start + 1);
+		btrfs_cleanup_ordered_extents(inode, locked_page, start,
+					      end - start + 1);
 	return ret;
 }
 
-- 
2.17.1

