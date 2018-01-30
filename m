Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41611 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751707AbeA3Ocy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Jan 2018 09:32:54 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 64CE4AE40
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Jan 2018 14:32:53 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [RESEND PATCH] btrfs: Handle btrfs_set_extent_delalloc failure in relocate_file_extent_cluster
Date: Tue, 30 Jan 2018 16:32:47 +0200
Message-Id: <1517322767-3044-1-git-send-email-nborisov@suse.com>
In-Reply-To: <1516979117-15117-1-git-send-email-nborisov@suse.com>
References: <1516979117-15117-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Essentially duplicate the error handling from the above block which
handles the !PageUptodate(page) case and additionally clear
EXTENT_BOUNDARY.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: Josef Bacik <jbacik@fb.com>
---

Put description of the intended changes. 

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

