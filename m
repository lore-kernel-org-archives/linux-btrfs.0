Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:49837 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966435Ab3DQOU5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Apr 2013 10:20:57 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 41E437C068F
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Apr 2013 08:20:57 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id o5AkCRxUGskWQon7 (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Wed, 17 Apr 2013 08:20:56 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: don't force pages under writeback to finish when aborting
Date: Wed, 17 Apr 2013 10:20:54 -0400
Message-ID: <1366208454-5893-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dave reported a BUG_ON() that happened in end_page_writeback() after an abort.
This happened because we unconditionally call end_page_writeback() in the endio
case, which is right.  However when we abort the transaction we will call
end_page_writeback() on any writeback pages we find, which is wrong.  We need to
lock the page and wait on page writeback to complete if it is.  There is nothing
unsafe about this since we are discarding the transaction anyway.  Thanks,

Reported-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/disk-io.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 66d036b..fa8438f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3815,10 +3815,9 @@ static int btrfs_destroy_marked_extents(struct btrfs_root *root,
 			if (eb)
 				ret = test_and_clear_bit(EXTENT_BUFFER_DIRTY,
 							 &eb->bflags);
-			if (PageWriteback(page))
-				end_page_writeback(page);
-
 			lock_page(page);
+
+			wait_on_page_writeback(page);
 			if (PageDirty(page)) {
 				clear_page_dirty_for_io(page);
 				spin_lock_irq(&page->mapping->tree_lock);
-- 
1.7.7.6

