Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48242 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752312AbdLGKoe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 Dec 2017 05:44:34 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 792C5ABCF
        for <linux-btrfs@vger.kernel.org>; Thu,  7 Dec 2017 10:44:33 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [RFC PATCH] btrfs: Handle btrfs_set_extent_delalloc failure in relocate_file_extent_cluster
Date: Thu,  7 Dec 2017 12:44:30 +0200
Message-Id: <1512643470-15281-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---

Hello, 

THis is rfc since I'm not entirely sure the cleanup sequence currently is 
sufficient so ideas are welcome. I have the feeling we need to do something
with the page: 

* SetPageError
* ClearPageUptodate
* Something else? 


 fs/btrfs/relocation.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index f0c3f00e97cb..b8614cd60ca6 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3268,12 +3268,23 @@ static int relocate_file_extent_cluster(struct inode *inode,
 			nr++;
 		}
 
-		btrfs_set_extent_delalloc(inode, page_start, page_end, 0, NULL,
-					  0);
+		ret = btrfs_set_extent_delalloc(inode, page_start, page_end, 0,
+						NULL, 0);
+		if (ret) {
+			unlock_page(page);
+			put_page(page);
+			btrfs_delalloc_release_metadata(BTRFS_I(inode),
+							 PAGE_SIZE);
+			btrfs_delalloc_release_extents(BTRFS_I(inode),
+			                               PAGE_SIZE);
+			unlock_extent(&BTRFS_I(inode)->io_tree, page_start,
+				      page_end);
+			goto out;
+
+		}
 		set_page_dirty(page);
 
-		unlock_extent(&BTRFS_I(inode)->io_tree,
-			      page_start, page_end);
+		unlock_extent(&BTRFS_I(inode)->io_tree, page_start, page_end);
 		unlock_page(page);
 		put_page(page);
 
-- 
2.7.4

