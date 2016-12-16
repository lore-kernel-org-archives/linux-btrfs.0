Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:35450 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754045AbcLPGqJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Dec 2016 01:46:09 -0500
Received: by mail-pg0-f67.google.com with SMTP id p66so8720101pga.2
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Dec 2016 22:45:43 -0800 (PST)
From: Takafumi Kubota <takafumi.kubota1012@sslab.ics.keio.ac.jp>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-kernel@vger.kernel.org,
        fdmanana@suse.com, naota@elisp.net,
        Takafumi Kubota <takafumi.kubota1012@sslab.ics.keio.ac.jp>
Subject: [PATCH] Btrfs: add another missing end_page_writeback on submit_extent_page failure
Date: Fri, 16 Dec 2016 15:41:50 +0900
Message-Id: <1481870510-44290-1-git-send-email-takafumi.kubota1012@sslab.ics.keio.ac.jp>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is actually inspired by Filipe's patch(55e3bd2e0c2e1).

When submit_extent_page() in __extent_writepage_io() fails,
Btrfs misses clearing a writeback bit of the failed page.
This causes the false under-writeback page.
Then, another sync task hangs in filemap_fdatawait_range(),
because it waits the false under-writeback page.

CPU0                            CPU1

__extent_writepage_io()
  ret = submit_extent_page() // fail

  if (ret)
    SetPageError(page)
    // miss clearing the writeback bit

                                sync()
                                  ...
                                  filemap_fdatawait_range()
                                    wait_on_page_writeback(page);
                                    // wait the false under-writeback page

Signed-off-by: Takafumi Kubota <takafumi.kubota1012@sslab.ics.keio.ac.jp>
---
 fs/btrfs/extent_io.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 1e67723..ef9793b 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3443,8 +3443,10 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
 					 bdev, &epd->bio, max_nr,
 					 end_bio_extent_writepage,
 					 0, 0, 0, false);
-		if (ret)
+		if (ret) {
 			SetPageError(page);
+			end_page_writeback(page);
+		}
 
 		cur = cur + iosize;
 		pg_offset += iosize;
-- 
1.9.3

