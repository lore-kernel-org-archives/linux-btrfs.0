Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:16652 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751398AbdCXXtM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Mar 2017 19:49:12 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] Btrfs: set scrub page's io_error if failing to submit io
Date: Fri, 24 Mar 2017 16:48:00 -0700
Message-Id: <1490399280-2624-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Otherwise, we may later skip this page when repairing bad copy from
good copy.

Cc: David Sterba <dsterba@suse.cz>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/scrub.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index b0251eb..026c2b8 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1497,14 +1497,18 @@ static void scrub_recheck_block(struct btrfs_fs_info *fs_info,
 
 		bio_add_page(bio, page->page, PAGE_SIZE, 0);
 		if (!retry_failed_mirror && scrub_is_page_on_raid56(page)) {
-			if (scrub_submit_raid56_bio_wait(fs_info, bio, page))
+			if (scrub_submit_raid56_bio_wait(fs_info, bio, page)) {
+				page->io_error = 1;
 				sblock->no_io_error_seen = 0;
+			}
 		} else {
 			bio->bi_iter.bi_sector = page->physical >> 9;
 			bio_set_op_attrs(bio, REQ_OP_READ, 0);
 
-			if (btrfsic_submit_bio_wait(bio))
+			if (btrfsic_submit_bio_wait(bio)) {
+				page->io_error = 1;
 				sblock->no_io_error_seen = 0;
+			}
 		}
 
 		bio_put(bio);
-- 
2.5.5

