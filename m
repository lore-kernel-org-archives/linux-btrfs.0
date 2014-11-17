Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:58628 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbaKQKhZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Nov 2014 05:37:25 -0500
Received: by mail-pa0-f50.google.com with SMTP id bj1so1774619pad.23
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Nov 2014 02:37:25 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org,
        <linux-fsdevel@vger.kernel.org>, Omar Sandoval <osandov@osandov.com>
Subject: [RFC PATCH 4/6] btrfs: don't check the cleancache for swapcache pages
Date: Mon, 17 Nov 2014 02:36:57 -0800
Message-Id: <b9e866a91033cfd0a04b9688e9de352220b680ca.1416219974.git.osandov@osandov.com>
In-Reply-To: <cover.1416219974.git.osandov@osandov.com>
References: <cover.1416219974.git.osandov@osandov.com>
In-Reply-To: <cover.1416219974.git.osandov@osandov.com>
References: <cover.1416219974.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Omar Sandoval <osandov@osandov.com>
---
 fs/btrfs/extent_io.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 54b2d00..b8dc256 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2904,13 +2904,14 @@ static int __do_readpage(struct extent_io_tree *tree,
 	size_t disk_io_size;
 	size_t blocksize = inode->i_sb->s_blocksize;
 	unsigned long this_bio_flag = *bio_flags & EXTENT_BIO_PARENT_LOCKED;
+	int swapcache = PageSwapCache(page);
 
-	if (likely(!PageSwapCache(page)))
+	if (likely(!swapcache))
 		set_page_extent_mapped(page);
 
 	end = page_end;
 	if (!PageUptodate(page)) {
-		if (cleancache_get_page(page) == 0) {
+		if (likely(!swapcache) && cleancache_get_page(page) == 0) {
 			BUG_ON(blocksize != PAGE_SIZE);
 			unlock_extent(tree, start, end);
 			goto out;
-- 
2.1.3

