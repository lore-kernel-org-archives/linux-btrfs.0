Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37257 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751447AbeAaPOH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Jan 2018 10:14:07 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 04B7AACDE
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Jan 2018 15:14:06 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v2] btrfs: Handle btrfs_set_extent_delalloc failure in relocate_file_extent_cluster
Date: Wed, 31 Jan 2018 17:14:02 +0200
Message-Id: <1517411642-6564-1-git-send-email-nborisov@suse.com>
In-Reply-To: <1517322767-3044-1-git-send-email-nborisov@suse.com>
References: <1517322767-3044-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Essentially duplicate the error handling from the above block which
handles the !PageUptodate(page) case and additionally clear
EXTENT_BOUNDARY.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: Josef Bacik <jbacik@fb.com>
---

V2: 
 * Remove unrelated whitespace fix 

 fs/btrfs/relocation.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index f0c3f00e97cb..cd2298d185dd 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3268,8 +3268,22 @@ static int relocate_file_extent_cluster(struct inode *inode,
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
 
 		unlock_extent(&BTRFS_I(inode)->io_tree,
-- 
2.7.4

