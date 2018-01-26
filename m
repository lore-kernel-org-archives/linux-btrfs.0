Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57247 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751408AbeA0N0Z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 27 Jan 2018 08:26:25 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 23007AD4F
        for <linux-btrfs@vger.kernel.org>; Sat, 27 Jan 2018 13:22:04 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Handle btrfs_set_extent_delalloc failure in relocate_file_extent_cluster
Date: Fri, 26 Jan 2018 17:05:17 +0200
Message-Id: <1516979117-15117-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: Josef Bacik <jbacik@fb.com>
---

Based on off-list feadback from Josef I'm also clearing the EXTENT_BOUNDARY 
flag so we don't leak it. Otherwise it's okay. 

He said to add his Reviewed-by as long as the extent clearing bit is adjusted. 
 fs/btrfs/relocation.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index f0c3f00e97cb..8b2a31cef5cf 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3268,12 +3268,25 @@ static int relocate_file_extent_cluster(struct inode *inode,
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
+
+			clear_extent_bits(&BTRFS_I(inode)->io_tree,
+					  page_start, page_end,
+					  EXTENT_LOCKED | EXTENT_BOUNDARY);
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

