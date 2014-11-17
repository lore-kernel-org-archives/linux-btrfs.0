Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:47671 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506AbaKQKhY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Nov 2014 05:37:24 -0500
Received: by mail-pa0-f42.google.com with SMTP id et14so7195716pad.15
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Nov 2014 02:37:24 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org,
        <linux-fsdevel@vger.kernel.org>, Omar Sandoval <osandov@osandov.com>
Subject: [RFC PATCH 3/6] btrfs: don't set ->private on swapcache pages
Date: Mon, 17 Nov 2014 02:36:56 -0800
Message-Id: <320c5b270669c235c5513b5f5763a529abcf88dd.1416219974.git.osandov@osandov.com>
In-Reply-To: <cover.1416219974.git.osandov@osandov.com>
References: <cover.1416219974.git.osandov@osandov.com>
In-Reply-To: <cover.1416219974.git.osandov@osandov.com>
References: <cover.1416219974.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Swapcache pages use ->private to store the swp_entry_t; overwriting it is sure
to cause insanity.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
---
 fs/btrfs/extent_io.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 9b67b37..54b2d00 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2824,6 +2824,7 @@ static int submit_extent_page(int rw, struct extent_io_tree *tree,
 static void attach_extent_buffer_page(struct extent_buffer *eb,
 				      struct page *page)
 {
+	BUG_ON(PageSwapCache(page));
 	if (!PagePrivate(page)) {
 		SetPagePrivate(page);
 		page_cache_get(page);
@@ -2835,6 +2836,7 @@ static void attach_extent_buffer_page(struct extent_buffer *eb,
 
 void set_page_extent_mapped(struct page *page)
 {
+	BUG_ON(PageSwapCache(page));
 	if (!PagePrivate(page)) {
 		SetPagePrivate(page);
 		page_cache_get(page);
@@ -2903,7 +2905,8 @@ static int __do_readpage(struct extent_io_tree *tree,
 	size_t blocksize = inode->i_sb->s_blocksize;
 	unsigned long this_bio_flag = *bio_flags & EXTENT_BIO_PARENT_LOCKED;
 
-	set_page_extent_mapped(page);
+	if (likely(!PageSwapCache(page)))
+		set_page_extent_mapped(page);
 
 	end = page_end;
 	if (!PageUptodate(page)) {
-- 
2.1.3

