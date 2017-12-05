Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58369 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752042AbdLEHyQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Dec 2017 02:54:16 -0500
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>, stable@vger.kernel.org
Subject: [PATCH] btrfs: Handle btrfs_set_extent_delalloc failure
Date: Tue,  5 Dec 2017 09:29:19 +0200
Message-Id: <1512458959-20473-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function was introduced by 247e743cbe6e ("Btrfs: Use async helpers to deal
with pages that have been improperly dirtied") and it didn't do any error
handling then. This function might very well fail in ENOMEM situation, yet
it's not handled, this could lead to inconsistent state. So let's handle the
failure by setting the mapping error bit.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Cc: stable@vger.kernel.org
---
 fs/btrfs/inode.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 993061f83067..7a5a46fefdb4 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2098,8 +2098,15 @@ static void btrfs_writepage_fixup_worker(struct btrfs_work *work)
 		goto out;
 	 }
 
-	btrfs_set_extent_delalloc(inode, page_start, page_end, 0, &cached_state,
-				  0);
+	ret = btrfs_set_extent_delalloc(inode, page_start, page_end, 0,
+					&cached_state, 0);
+	if (ret) {
+		mapping_set_error(page->mapping, ret);
+		end_extent_writepage(page, ret, page_start, page_end);
+		ClearPageChecked(page);
+		goto out;
+	 }
+
 	ClearPageChecked(page);
 	set_page_dirty(page);
 	btrfs_delalloc_release_extents(BTRFS_I(inode), PAGE_SIZE);
-- 
2.7.4

