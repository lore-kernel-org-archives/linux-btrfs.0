Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.synology.com ([59.124.41.242]:29484 "EHLO
	mail.synology.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbbBDMKq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Feb 2015 07:10:46 -0500
From: Forrest Liu <forrestl@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: Forrest Liu <forrestl@synology.com>, Chien-Kuan Yeh <ckya@synology.com>
Subject: [PATCH v2] Btrfs: btrfs_release_extent_buffer_page didn't free pages of dummy extent
Date: Wed,  4 Feb 2015 20:10:37 +0800
Message-Id: <1423051837-25290-1-git-send-email-forrestl@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_release_extent_buffer_page() can't handle dummy extent that
allocated by btrfs_clone_extent_buffer() properly.

Reference count of pages that allocated by btrfs_clone_extent_buffer()
was 2, 1 by alloc_page(), and another by attach_extent_buffer_page().

Signed-off-by: Chien-Kuan Yeh <ckya@synology.com>
Signed-off-by: Forrest Liu <forrestl@synology.com>
---
changelog:
v2: do not call PagePrivate() if page is NULL 

 fs/btrfs/extent_io.c | 51 ++++++++++++++++++++++++++-------------------------
 1 file changed, 26 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 790dbae..9de93ee 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4554,36 +4554,37 @@ static void btrfs_release_extent_buffer_page(struct extent_buffer *eb)
 	do {
 		index--;
 		page = eb->pages[index];
-		if (page && mapped) {
+		if (!page)
+			continue;
+		if (mapped)
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
-			spin_unlock(&page->mapping->private_lock);
-
-		}
-		if (page) {
-			/* One for when we alloced the page */
+			ClearPagePrivate(page);
+			set_page_private(page, 0);
+			/* One for the page private */
 			page_cache_release(page);
 		}
+
+		if (mapped)
+			spin_unlock(&page->mapping->private_lock);
+
+		/* One for when we alloced the page */
+		page_cache_release(page);
 	} while (index != 0);
 }
 
-- 
1.9.1

