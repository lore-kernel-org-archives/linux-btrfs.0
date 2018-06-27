Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60218 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933849AbeF0Nid (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Jun 2018 09:38:33 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CB6F4ABF3
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Jun 2018 13:38:32 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 1/4] btrfs: Refactor loop in btrfs_release_extent_buffer_page
Date: Wed, 27 Jun 2018 16:38:22 +0300
Message-Id: <1530106705-27186-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1530106705-27186-1-git-send-email-nborisov@suse.com>
References: <1530106705-27186-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The purpose of the function is to free all the pages comprising an
extent buffer. This can be achieved with a simple for loop rather than
the slitghly more involved 'do {} while' construct. So rewrite the
loop using a 'for' construct. Additionally we can never have an
extent_buffer that is 0 pages so remove the check for index == 0. No
functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent_io.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index cce6087d6880..4180a3b7e725 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4641,19 +4641,14 @@ int extent_buffer_under_io(struct extent_buffer *eb)
  */
 static void btrfs_release_extent_buffer_page(struct extent_buffer *eb)
 {
-	unsigned long index;
-	struct page *page;
+	int i;
 	int mapped = !test_bit(EXTENT_BUFFER_DUMMY, &eb->bflags);
 
 	BUG_ON(extent_buffer_under_io(eb));
 
-	index = num_extent_pages(eb->start, eb->len);
-	if (index == 0)
-		return;
+	for (i = 0; i < num_extent_pages(eb->start, eb->len); i++) {
+		struct page *page = eb->pages[i];
 
-	do {
-		index--;
-		page = eb->pages[index];
 		if (!page)
 			continue;
 		if (mapped)
@@ -4685,7 +4680,7 @@ static void btrfs_release_extent_buffer_page(struct extent_buffer *eb)
 
 		/* One for when we allocated the page */
 		put_page(page);
-	} while (index != 0);
+	}
 }
 
 /*
-- 
2.7.4

