Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56774 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754780AbeCHOfe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Mar 2018 09:35:34 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 55E50AE19
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Mar 2018 14:35:33 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 03/22] btrfs: remove redundant variable in __do_readpage
Date: Thu,  8 Mar 2018 15:33:13 +0100
Message-Id: <696c936f5e73d85fd561f7951b669df87ffedafe.1520518876.git.dsterba@suse.com>
In-Reply-To: <cover.1520518876.git.dsterba@suse.com>
References: <cover.1520518876.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The value of page_end is only stored to end, no other use.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 36514baa661e..ffcbdb2390a1 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2888,8 +2888,7 @@ static int __do_readpage(struct extent_io_tree *tree,
 {
 	struct inode *inode = page->mapping->host;
 	u64 start = page_offset(page);
-	u64 page_end = start + PAGE_SIZE - 1;
-	u64 end;
+	const u64 end = start + PAGE_SIZE - 1;
 	u64 cur = start;
 	u64 extent_offset;
 	u64 last_byte = i_size_read(inode);
@@ -2909,7 +2908,6 @@ static int __do_readpage(struct extent_io_tree *tree,
 
 	set_page_extent_mapped(page);
 
-	end = page_end;
 	if (!PageUptodate(page)) {
 		if (cleancache_get_page(page) == 0) {
 			BUG_ON(blocksize != PAGE_SIZE);
-- 
2.16.2

