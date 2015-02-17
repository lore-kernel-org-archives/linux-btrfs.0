Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:45956 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933705AbbBQKvb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Feb 2015 05:51:31 -0500
Received: by pdjz10 with SMTP id z10so42909893pdj.12
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Feb 2015 02:51:31 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Omar Sandoval <osandov@osandov.com>
Subject: [PATCH 2/3] btrfs: handle race on ENOMEM in alloc_extent_buffer
Date: Tue, 17 Feb 2015 02:51:08 -0800
Message-Id: <4fcdbbd7d6dc95598323b46dcf5db4356cb7dee8.1424168589.git.osandov@osandov.com>
In-Reply-To: <cover.1424168589.git.osandov@osandov.com>
References: <cover.1424168589.git.osandov@osandov.com>
In-Reply-To: <cover.1424168589.git.osandov@osandov.com>
References: <cover.1424168589.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Consider the following interleaving of overlapping calls to
alloc_extent_buffer:

Call 1:

- Successfully allocates a few pages with find_or_create_page
- find_or_create_page fails, goto free_eb
- Unlocks the allocated pages

Call 2:
- Calls find_or_create_page and gets a page in call 1's extent_buffer
- Finds that the page is already associated with an extent_buffer
- Grabs a reference to the half-written extent_buffer and calls
  mark_extent_buffer_accessed on it

mark_extent_buffer_accessed will then try to call mark_page_accessed on
a null page and panic.

The fix is to clear page->private of the half-written extent_buffer's
pages all at once while holding mapping->private_lock.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
---
 fs/btrfs/extent_io.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index c73df6a..6024db9 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4850,6 +4850,7 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
 				mark_extent_buffer_accessed(exists, p);
 				goto free_eb;
 			}
+			exists = NULL;
 
 			/*
 			 * Do this so attach doesn't complain and we need to
@@ -4913,13 +4914,24 @@ again:
 	return eb;
 
 free_eb:
+	spin_lock(&mapping->private_lock);
 	for (i = 0; i < num_pages; i++) {
-		if (eb->pages[i])
-			unlock_page(eb->pages[i]);
-	}
+		struct page *page = eb->pages[i];
 
+		if (page) {
+			unlock_page(page);
+			ClearPagePrivate(page);
+			set_page_private(page, 0);
+			/* One for the page private */
+			page_cache_release(page);
+			/* One for when we alloced the page */
+			page_cache_release(page);
+		}
+	}
+	spin_unlock(&mapping->private_lock);
 	WARN_ON(!atomic_dec_and_test(&eb->refs));
-	btrfs_release_extent_buffer(eb);
+	__free_extent_buffer(eb);
+
 	return exists;
 }
 
-- 
2.3.0

