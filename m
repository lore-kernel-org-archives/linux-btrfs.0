Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:50102 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804AbaJJIqO (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Fri, 10 Oct 2014 04:46:14 -0400
From: Filipe Manana <fdmanana@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [PATCH 1/2 v2] Btrfs: report error after failure inlining extent in compressed write path
Date: Fri, 10 Oct 2014 10:45:12 +0100
Message-Id: <1412934312-30816-1-git-send-email-fdmanana@suse.com>
In-Reply-To: <1412885744-16180-1-git-send-email-fdmanana@suse.com>
References: <1412885744-16180-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If cow_file_range_inline() failed, when called from compress_file_range(),
we were tagging the locked page for writeback, end its writeback and unlock it,
but not marking it with an error nor setting AS_EIO in inode's mapping flags.

This made it impossible for a caller of filemap_fdatawrite_range (writepages)
or filemap_fdatawait_range() to know that an error happened. And the return
value of compress_file_range() is useless because it's returned to a workqueue
task and not to the task calling filemap_fdatawrite_range (writepages).

This change applies on top of the previous patchset starting at the patch
titled:

    "[1/5] Btrfs: set page and mapping error on compressed write failure"

Which changed extent_clear_unlock_delalloc() to use SetPageError and
mapping_set_error().

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: Use SET_PAGE_ERROR only if ret < 0, obviously. Thanks btrfs/056.

 fs/btrfs/inode.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 7635b1d..2b09425 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -527,7 +527,10 @@ cont:
 		if (ret <= 0) {
 			unsigned long clear_flags = EXTENT_DELALLOC |
 				EXTENT_DEFRAG;
+			unsigned long page_error_op;
+
 			clear_flags |= (ret < 0) ? EXTENT_DO_ACCOUNTING : 0;
+			page_error_op = ret < 0 ? PAGE_SET_ERROR : 0;
 
 			/*
 			 * inline extent creation worked or returned error,
@@ -538,6 +541,7 @@ cont:
 						     clear_flags, PAGE_UNLOCK |
 						     PAGE_CLEAR_DIRTY |
 						     PAGE_SET_WRITEBACK |
+						     page_error_op |
 						     PAGE_END_WRITEBACK);
 			goto free_pages_out;
 		}
-- 
1.9.1

