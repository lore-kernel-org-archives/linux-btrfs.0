Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.synology.com ([59.124.41.242]:52796 "EHLO
	mail.synology.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932197AbbBBNEZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Feb 2015 08:04:25 -0500
From: Forrest Liu <forrestl@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: Forrest Liu <forrestl@synology.com>, Chien-Kuan Yeh <ckya@synology.com>
Subject: [PATCH] Btrfs: btrfs_release_extent_buffer_page() didn't free pages of dummy extent
Date: Mon,  2 Feb 2015 21:04:17 +0800
Message-Id: <1422882257-15449-1-git-send-email-forrestl@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_release_extent_buffer_page() can't handle dummy extent that
allocated by btrfs_clone_extent_buffer() properly.

Reference count of pages that allocated by btrfs_clone_extent_buffer()
was 2, 1 by alloc_page(), and another by attach_extent_buffer_page().

Signed-off-by: Chien-Kuan Yeh <ckya@synology.com>
Signed-off-by: Forrest Liu <forrestl@synology.com>
---
 fs/btrfs/extent_io.c | 43 ++++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index dab8af4..58a5183 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4555,32 +4555,33 @@ static void btrfs_release_extent_buffer_page(struct extent_buffer *eb)
 	do {
 		index--;
 		page = eb->pages[index];
-		if (page && mapped) {
+		if (page && mapped)
 			spin_lock(&page->mapping->private_lock);
+		/*
+		 * We do this since we'll remove the pages after we've
+		 * removed the eb from the radix tree, so we could race
+		 * and have this page now attached to the new eb.  So
+		 * only clear page_private if it's still connected to
+		 * this eb.
+		 */
+		if (PagePrivate(page) &&
+		    page->private == (unsigned long)eb) {
+			BUG_ON(test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags));
+			BUG_ON(PageDirty(page));
+			BUG_ON(PageWriteback(page));
 			/*
-			 * We do this since we'll remove the pages after we've
-			 * removed the eb from the radix tree, so we could race
-			 * and have this page now attached to the new eb.  So
-			 * only clear page_private if it's still connected to
-			 * this eb.
+			 * We need to make sure we haven't be attached
+			 * to a new eb.
 			 */
-			if (PagePrivate(page) &&
-			    page->private == (unsigned long)eb) {
-				BUG_ON(test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags));
-				BUG_ON(PageDirty(page));
-				BUG_ON(PageWriteback(page));
-				/*
-				 * We need to make sure we haven't be attached
-				 * to a new eb.
-				 */
-				ClearPagePrivate(page);
-				set_page_private(page, 0);
-				/* One for the page private */
-				page_cache_release(page);
-			}
+			ClearPagePrivate(page);
+			set_page_private(page, 0);
+			/* One for the page private */
+			page_cache_release(page);
+		}
+
+		if (page && mapped)
 			spin_unlock(&page->mapping->private_lock);
 
-		}
 		if (page) {
 			/* One for when we alloced the page */
 			page_cache_release(page);
-- 
1.9.1

