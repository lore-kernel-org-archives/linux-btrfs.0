Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:35264 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751807AbdBIIbC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Feb 2017 03:31:02 -0500
Received: by mail-pg0-f65.google.com with SMTP id 204so17335491pge.2
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Feb 2017 00:30:57 -0800 (PST)
From: Takafumi Kubota <takafumi.kubota1012@sslab.ics.keio.ac.jp>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-kernel@vger.kernel.org,
        bo.li.liu@oracle.com, naota@elisp.net,
        Takafumi Kubota <takafumi.kubota1012@sslab.ics.keio.ac.jp>,
        David Sterba <dsterba@suse.cz>
Subject: [PATCH v2] Btrfs: add another missing end_page_writeback on submit_extent_page failure
Date: Thu,  9 Feb 2017 17:24:33 +0900
Message-Id: <1486628673-30631-1-git-send-email-takafumi.kubota1012@sslab.ics.keio.ac.jp>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If btrfs_bio_alloc fails in submit_extent_page, submit_extent_page returns
without clearing the writeback bit of the failed page.

__extent_writepage_io, that is a caller of submit_extent_page,
does not clear the remaining writeback bit anywhere.
As a result, this will cause the hang at filemap_fdatawait_range,
because it waits the writeback bit to be cleared from the failed page.
So, we have to call end_page_writeback to clear the writeback bit.

For reproducing the hang, we inject a fault like

   if (should_failtest()) { // I define should_failtest()
        bio = NULL;
   }
   else {
        bio = btrfs_bio_alloc(...);
   }

in submit_extent_page.

We should also check whether page has the bit before end_page_writeback,
to avoid the conflict against the other end_page_writeback in bio_endio.
Thus, we add PageWriteback checks not only in __extent_writepage_io,
but also in write_one_eb too, because it misses the check.

Signed-off-by: Takafumi Kubota <takafumi.kubota1012@sslab.ics.keio.ac.jp>
Reviewed-by: Liu Bo <bo.li.liu@oracle.com>
Cc: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/extent_io.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 4ac383a..aa1908a 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3445,8 +3445,11 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
 					 bdev, &epd->bio, max_nr,
 					 end_bio_extent_writepage,
 					 0, 0, 0, false);
-		if (ret)
+		if (ret) {
 			SetPageError(page);
+			if (PageWriteback(page))
+				end_page_writeback(page);
+		}
 
 		cur = cur + iosize;
 		pg_offset += iosize;
@@ -3767,7 +3770,8 @@ static noinline_for_stack int write_one_eb(struct extent_buffer *eb,
 		epd->bio_flags = bio_flags;
 		if (ret) {
 			set_btree_ioerr(p);
-			end_page_writeback(p);
+			if (PageWriteback(p))
+				end_page_writeback(p);
 			if (atomic_sub_and_test(num_pages - i, &eb->io_pages))
 				end_extent_buffer_writeback(eb);
 			ret = -EIO;
-- 
1.9.3

