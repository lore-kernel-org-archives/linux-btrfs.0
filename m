Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60843 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752720AbcGDEgC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Jul 2016 00:36:02 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u644Yh2D015873
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Jul 2016 00:36:02 -0400
Received: from e19.ny.us.ibm.com (e19.ny.us.ibm.com [129.33.205.209])
	by mx0a-001b2d01.pphosted.com with ESMTP id 23x9ppexy4-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 04 Jul 2016 00:36:02 -0400
Received: from localhost
	by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 4 Jul 2016 00:36:01 -0400
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.com
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org
Subject: [PATCH V20 16/19] Btrfs: subpage-blocksize: Make file extent relocate code subpage blocksize aware
Date: Mon,  4 Jul 2016 10:04:36 +0530
In-Reply-To: <1467606879-14181-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1467606879-14181-1-git-send-email-chandan@linux.vnet.ibm.com>
Message-Id: <1467606879-14181-17-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The file extent relocation code currently assumes blocksize to be same
as PAGE_SIZE. This commit adds code to support subpage blocksize
scenario.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/relocation.c | 89 ++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 70 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 05b88f8..fc0ac5d 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3106,14 +3106,19 @@ static int relocate_file_extent_cluster(struct inode *inode,
 {
 	u64 page_start;
 	u64 page_end;
+	u64 block_start;
 	u64 offset = BTRFS_I(inode)->index_cnt;
+	u64 blocksize = BTRFS_I(inode)->root->sectorsize;
+	u64 reserved_space;
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
@@ -3133,13 +3138,19 @@ static int relocate_file_extent_cluster(struct inode *inode,
 	if (ret)
 		goto out;
 
+	page_start = cluster->start - offset;
+	page_end = min_t(u64, round_down(page_start, PAGE_SIZE) + PAGE_SIZE - 1,
+			cluster->end - offset);
+
 	index = (cluster->start - offset) >> PAGE_SHIFT;
 	last_index = (cluster->end - offset) >> PAGE_SHIFT;
 	while (index <= last_index) {
-		ret = btrfs_delalloc_reserve_metadata(inode, PAGE_SIZE);
+		reserved_space = page_end - page_start + 1;
+
+		ret = btrfs_delalloc_reserve_metadata(inode, reserved_space);
 		if (ret)
 			goto out;
-
+again:
 		page = find_lock_page(inode->i_mapping, index);
 		if (!page) {
 			page_cache_sync_readahead(inode->i_mapping,
@@ -3149,7 +3160,7 @@ static int relocate_file_extent_cluster(struct inode *inode,
 						   mask);
 			if (!page) {
 				btrfs_delalloc_release_metadata(inode,
-							PAGE_SIZE);
+								reserved_space);
 				ret = -ENOMEM;
 				goto out;
 			}
@@ -3161,6 +3172,37 @@ static int relocate_file_extent_cluster(struct inode *inode,
 						   last_index + 1 - index);
 		}
 
+		if (PageDirty(page)) {
+			u64 pg_offset = page_offset(page);
+
+			unlock_page(page);
+			put_page(page);
+			ret = btrfs_fdatawrite_range(inode, pg_offset,
+							page_start - 1);
+			if (ret) {
+				btrfs_delalloc_release_metadata(inode,
+								reserved_space);
+				goto out;
+			}
+
+			ret = filemap_fdatawait_range(inode->i_mapping,
+						pg_offset, page_start - 1);
+			if (ret) {
+				btrfs_delalloc_release_metadata(inode,
+								reserved_space);
+				goto out;
+			}
+
+			goto again;
+		}
+
+		if (BTRFS_I(inode)->root->sectorsize < PAGE_SIZE) {
+			ClearPageUptodate(page);
+			if (page->private)
+				clear_page_blks_state(page, 1 << BLK_STATE_UPTODATE,
+						page_start, page_end);
+		}
+
 		if (!PageUptodate(page)) {
 			btrfs_readpage(NULL, page);
 			lock_page(page);
@@ -3168,41 +3210,50 @@ static int relocate_file_extent_cluster(struct inode *inode,
 				unlock_page(page);
 				put_page(page);
 				btrfs_delalloc_release_metadata(inode,
-							PAGE_SIZE);
+								reserved_space);
 				ret = -EIO;
 				goto out;
 			}
 		}
 
-		page_start = page_offset(page);
-		page_end = page_start + PAGE_SIZE - 1;
-
 		lock_extent(&BTRFS_I(inode)->io_tree, page_start, page_end);
 
 		set_page_extent_mapped(page);
 
-		if (nr < cluster->nr &&
-		    page_start + offset == cluster->boundary[nr]) {
-			set_extent_bits(&BTRFS_I(inode)->io_tree,
-					page_start, page_end,
-					EXTENT_BOUNDARY);
-			nr++;
+		nr_blocks = (page_end + 1 - page_start) >> inode->i_blkbits;
+
+		block_start = page_start;
+		for (i = 0; i < nr_blocks; i++) {
+			if (nr < cluster->nr &&
+				block_start + offset == cluster->boundary[nr]) {
+				set_extent_bits(&BTRFS_I(inode)->io_tree,
+						block_start, block_start + blocksize - 1,
+						EXTENT_BOUNDARY);
+				nr++;
+			}
+
+			block_start += blocksize;
 		}
 
 		btrfs_set_extent_delalloc(inode, page_start, page_end, NULL);
-		set_page_blks_state(page,
-				1 << BLK_STATE_DIRTY | 1 << BLK_STATE_UPTODATE,
-				page_start, page_end);
-		set_page_dirty(page);
+		if (blocksize < PAGE_SIZE)
+			set_page_blks_state(page,
+					1 << BLK_STATE_DIRTY | 1 << BLK_STATE_UPTODATE,
+					page_start, page_end);
 
-		unlock_extent(&BTRFS_I(inode)->io_tree,
-			      page_start, page_end);
+		unlock_extent(&BTRFS_I(inode)->io_tree, page_start, page_end);
+
+		set_page_dirty(page);
 		unlock_page(page);
 		put_page(page);
 
 		index++;
 		balance_dirty_pages_ratelimited(inode->i_mapping);
 		btrfs_throttle(BTRFS_I(inode)->root);
+
+		page_start = page_end + 1;
+		page_end = min_t(u64, page_start + PAGE_SIZE - 1,
+				cluster->end - offset);
 	}
 	WARN_ON(nr != cluster->nr);
 out:
-- 
2.5.5

