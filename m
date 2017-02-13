Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41621 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752301AbdBMJem (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Feb 2017 04:34:42 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 84061ABD3
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Feb 2017 09:34:36 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 15/29] btrfs: remove unused parameter from update_nr_written
Date: Mon, 13 Feb 2017 10:34:07 +0100
Message-Id: <8eb2ad192a76e19472e34c98518508943246d4cd.1486977712.git.dsterba@suse.com>
In-Reply-To: <cover.1486977711.git.dsterba@suse.com>
References: <cover.1486977711.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The logic has been updated in "Btrfs: make mapping->writeback_index
point to the last written page" (a91326679f2a0a4c2) and page is not
needed anymore.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 00f3be5c4f2d..f683fa5a4b91 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3203,7 +3203,7 @@ int extent_read_full_page(struct extent_io_tree *tree, struct page *page,
 	return ret;
 }
 
-static void update_nr_written(struct page *page, struct writeback_control *wbc,
+static void update_nr_written(struct writeback_control *wbc,
 			      unsigned long nr_written)
 {
 	wbc->nr_to_write -= nr_written;
@@ -3341,7 +3341,7 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
 			else
 				redirty_page_for_writepage(wbc, page);
 
-			update_nr_written(page, wbc, nr_written);
+			update_nr_written(wbc, nr_written);
 			unlock_page(page);
 			return 1;
 		}
@@ -3351,7 +3351,7 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
 	 * we don't want to touch the inode after unlocking the page,
 	 * so we update the mapping writeback index now
 	 */
-	update_nr_written(page, wbc, nr_written + 1);
+	update_nr_written(wbc, nr_written + 1);
 
 	end = page_end;
 	if (i_size <= start) {
@@ -3764,7 +3764,7 @@ static noinline_for_stack int write_one_eb(struct extent_buffer *eb,
 			break;
 		}
 		offset += PAGE_SIZE;
-		update_nr_written(p, wbc, 1);
+		update_nr_written(wbc, 1);
 		unlock_page(p);
 	}
 
-- 
2.10.1

