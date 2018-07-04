Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53386 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753213AbeGDHYz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 4 Jul 2018 03:24:55 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 383B4ACEA
        for <linux-btrfs@vger.kernel.org>; Wed,  4 Jul 2018 07:24:54 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 1/2] btrfs: Simplify page unlocking in alloc_extent_buffer
Date: Wed,  4 Jul 2018 10:24:51 +0300
Message-Id: <1530689092-18090-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Current version of the page unlocking code was added in
727011e07cbd ("Btrfs: allow metadata blocks larger than the page size")
but even in this commit that particular flag was never used per-se. In
fact, btrfs only uses PageChecked for data pages to identify pages
which have been dirtied but don't have ORDERED bit set. For more
information see 247e743cbe6e ("Btrfs: Use async helpers to deal with
pages that have been improperly dirtied"). However, this doesn't apply
to extent buffer pages. The important bit here is that the pages are
unlocked AFTER the extent buffer has been properly recorded in the
radix tree to avoid races with btree_releasepage. Let's exploit this
fact and simplify the page unlocking sequence by unlocking the pages
in-order and removing the redundant PageChecked flag setting/clearing.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent_io.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index d0482832bd6b..2f5c6721d3bc 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -5039,13 +5039,8 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
 	 * after the extent buffer is in the radix tree so
 	 * it doesn't get lost
 	 */
-	SetPageChecked(eb->pages[0]);
-	for (i = 1; i < num_pages; i++) {
-		p = eb->pages[i];
-		ClearPageChecked(p);
-		unlock_page(p);
-	}
-	unlock_page(eb->pages[0]);
+	for (i = 0; i < num_pages; i++)
+		unlock_page(eb->pages[i]);
 	return eb;
 
 free_eb:
-- 
2.7.4

