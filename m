Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:45922 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749Ab2JHN00 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Oct 2012 09:26:26 -0400
Message-ID: <5072D477.3070303@gmail.com>
Date: Mon, 08 Oct 2012 21:26:15 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
MIME-Version: 1.0
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Btrfs: remove repeated eb->pages check in, disk-io.c/csum_dirty_buffer
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In csum_dirty_buffer, we first get eb from page->private.
Then we check if the page is the first page of eb. Later
we check it again. Remove the repeated check here.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 fs/btrfs/disk-io.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 22e98e0..8919c56 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -432,14 +432,12 @@ static int csum_dirty_buffer(struct btrfs_root *root, struct page *page)
 	tree = &BTRFS_I(page->mapping->host)->io_tree;

 	eb = (struct extent_buffer *)page->private;
-	if (page != eb->pages[0])
-		return 0;
-	found_start = btrfs_header_bytenr(eb);
-	if (found_start != start) {
+	if (page != eb->pages[0]) {
 		WARN_ON(1);
 		return 0;
 	}
-	if (eb->pages[0] != page) {
+	found_start = btrfs_header_bytenr(eb);
+	if (found_start != start) {
 		WARN_ON(1);
 		return 0;
 	}
-- 
1.7.5.4

