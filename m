Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.synology.com ([59.124.41.242]:48062 "EHLO
	mail.synology.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759523AbbBIJbz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Feb 2015 04:31:55 -0500
From: Forrest Liu <forrestl@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: Forrest Liu <forrestl@synology.com>, Chien-Kuan Yeh <ckya@synology.com>
Subject: [PATCH v3] Btrfs: btrfs_release_extent_buffer_page didn't free pages of dummy extent
Date: Mon,  9 Feb 2015 17:31:45 +0800
Message-Id: <1423474305-26751-1-git-send-email-forrestl@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_release_extent_buffer_page() can't handle dummy extent that
allocated by btrfs_clone_extent_buffer() properly. That is because
reference count of pages that allocated by btrfs_clone_extent_buffer()
was 2, 1 by alloc_page(), and another by attach_extent_buffer_page().

Running following command repeatly can check this memory leak problem

    btrfs inspect-internal inode-resolve 256 /mnt/btrfs

Signed-off-by: Chien-Kuan Yeh <ckya@synology.com>
Signed-off-by: Forrest Liu <forrestl@synology.com>
---
V2: do not call PagePrivate if page is NULL
V3: add reproducing step in commit message

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

