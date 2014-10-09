Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:36871 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbaJITQY (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Thu, 9 Oct 2014 15:16:24 -0400
From: Filipe Manana <fdmanana@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [PATCH 1/2] Btrfs: report error after failure inlining extent in compressed write path
Date: Thu,  9 Oct 2014 21:15:43 +0100
Message-Id: <1412885744-16180-1-git-send-email-fdmanana@suse.com>
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
 fs/btrfs/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 7635b1d..b91a171 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -538,6 +538,7 @@ cont:
 						     clear_flags, PAGE_UNLOCK |
 						     PAGE_CLEAR_DIRTY |
 						     PAGE_SET_WRITEBACK |
+						     PAGE_SET_ERROR |
 						     PAGE_END_WRITEBACK);
 			goto free_pages_out;
 		}
-- 
1.9.1

