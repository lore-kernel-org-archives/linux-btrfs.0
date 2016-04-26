Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp08.in.ibm.com ([125.16.236.8]:48224 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924AbcDZN2T (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Apr 2016 09:28:19 -0400
Received: from localhost
	by e28smtp08.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Tue, 26 Apr 2016 18:58:16 +0530
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay04.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u3QDSGRA18940166
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Apr 2016 18:58:16 +0530
Received: from d28av02.in.ibm.com (localhost [127.0.0.1])
	by d28av02.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u3QDSBgM010080
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Apr 2016 18:58:13 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, dsterba@suse.cz, clm@fb.com,
        jbacik@fb.com, chandan@mykolab.com
Subject: [PATCH V18 17/18] Btrfs: subpage-blocksize: Make file extent relocate code subpage blocksize aware
Date: Tue, 26 Apr 2016 18:57:16 +0530
Message-Id: <1461677237-7703-18-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1461677237-7703-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1461677237-7703-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The file extent relocation code currently assumes blocksize to be same
as PAGE_SIZE. This commit adds code to support subpage blocksize
scenario.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/relocation.c | 73 +++++++++++++++++++++++++++++++++------------------
 1 file changed, 48 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 35fd62e..61a6414 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3103,14 +3103,19 @@ static int relocate_file_extent_cluster(struct inode *inode,
 {
 	u64 page_start;
 	u64 page_end;
+	u64 block_start;
+	u64 block_end;
 	u64 offset = BTRFS_I(inode)->index_cnt;
+	u64 blocksize = BTRFS_I(inode)->root->sectorsize;
 	unsigned long index;
 	unsigned long last_index;
 	struct page *page;
 	struct file_ra_state *ra;
 	gfp_t mask = btrfs_alloc_write_mask(inode->i_mapping);
+	int nr_blocks;
 	int nr = 0;
 	int ret = 0;
+	int i;
 
 	if (!cluster->nr)
 		return 0;
@@ -3130,13 +3135,13 @@ static int relocate_file_extent_cluster(struct inode *inode,
 	if (ret)
 		goto out;
 
+	page_start = cluster->start - offset;
+	page_end = min_t(u64, page_start + PAGE_SIZE - 1,
+			cluster->end - offset);
+
 	index = (cluster->start - offset) >> PAGE_SHIFT;
 	last_index = (cluster->end - offset) >> PAGE_SHIFT;
 	while (index <= last_index) {
-		ret = btrfs_delalloc_reserve_metadata(inode, PAGE_SIZE);
-		if (ret)
-			goto out;
-
 		page = find_lock_page(inode->i_mapping, index);
 		if (!page) {
 			page_cache_sync_readahead(inode->i_mapping,
@@ -3145,8 +3150,6 @@ static int relocate_file_extent_cluster(struct inode *inode,
 			page = find_or_create_page(inode->i_mapping, index,
 						   mask);
 			if (!page) {
-				btrfs_delalloc_release_metadata(inode,
-							PAGE_SIZE);
 				ret = -ENOMEM;
 				goto out;
 			}
@@ -3164,42 +3167,62 @@ static int relocate_file_extent_cluster(struct inode *inode,
 			if (!PageUptodate(page)) {
 				unlock_page(page);
 				put_page(page);
-				btrfs_delalloc_release_metadata(inode,
-							PAGE_SIZE);
 				ret = -EIO;
 				goto out;
 			}
 		}
 
-		page_start = page_offset(page);
-		page_end = page_start + PAGE_SIZE - 1;
+		nr_blocks = (page_end + 1 - page_start) >> inode->i_blkbits;
+		i = 0;
 
-		lock_extent(&BTRFS_I(inode)->io_tree, page_start, page_end);
+		while (i < nr_blocks) {
+			ret = btrfs_delalloc_reserve_metadata(inode, blocksize);
+			if (ret) {
+				if (i)
+					set_page_dirty(page);
+				unlock_page(page);
+				put_page(page);
+				goto out;
+			}
+
+			block_start = page_start + (i << inode->i_blkbits);
+			block_end = block_start + blocksize - 1;
+
+			lock_extent(&BTRFS_I(inode)->io_tree, block_start,
+				block_end);
+
+			set_page_extent_mapped(page);
 
-		set_page_extent_mapped(page);
+			if (nr < cluster->nr &&
+				block_start + offset == cluster->boundary[nr]) {
+				set_extent_bits(&BTRFS_I(inode)->io_tree,
+						block_start, block_end,
+						EXTENT_BOUNDARY, GFP_NOFS);
+				nr++;
+			}
+
+			btrfs_set_extent_delalloc(inode, block_start,
+						block_end, NULL);
+			set_page_blks_state(page,
+					1 << BLK_STATE_DIRTY | 1 << BLK_STATE_UPTODATE,
+					block_start, block_end);
 
-		if (nr < cluster->nr &&
-		    page_start + offset == cluster->boundary[nr]) {
-			set_extent_bits(&BTRFS_I(inode)->io_tree,
-					page_start, page_end,
-					EXTENT_BOUNDARY, GFP_NOFS);
-			nr++;
+			unlock_extent(&BTRFS_I(inode)->io_tree,
+				block_start, block_end);
+			i++;
 		}
 
-		btrfs_set_extent_delalloc(inode, page_start, page_end, NULL);
-		set_page_blks_state(page,
-				1 << BLK_STATE_DIRTY | 1 << BLK_STATE_UPTODATE,
-				page_start, page_end);
 		set_page_dirty(page);
-
-		unlock_extent(&BTRFS_I(inode)->io_tree,
-			      page_start, page_end);
 		unlock_page(page);
 		put_page(page);
 
 		index++;
 		balance_dirty_pages_ratelimited(inode->i_mapping);
 		btrfs_throttle(BTRFS_I(inode)->root);
+
+		page_start += PAGE_SIZE;
+		page_end = min_t(u64, page_start + PAGE_SIZE - 1,
+				cluster->end - offset);
 	}
 	WARN_ON(nr != cluster->nr);
 out:
-- 
2.1.0

