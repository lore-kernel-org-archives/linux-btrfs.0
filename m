Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:27366 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752706AbcGDEfm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Jul 2016 00:35:42 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u644Xe3w128364
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Jul 2016 00:35:41 -0400
Received: from e18.ny.us.ibm.com (e18.ny.us.ibm.com [129.33.205.208])
	by mx0a-001b2d01.pphosted.com with ESMTP id 23xa4bpepx-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 04 Jul 2016 00:35:41 -0400
Received: from localhost
	by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 4 Jul 2016 00:35:40 -0400
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.com
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org
Subject: [PATCH V20 10/19] Btrfs: subpage-blocksize: btrfs_punch_hole: Fix uptodate blocks check
Date: Mon,  4 Jul 2016 10:04:30 +0530
In-Reply-To: <1467606879-14181-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1467606879-14181-1-git-send-email-chandan@linux.vnet.ibm.com>
Message-Id: <1467606879-14181-11-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In case of subpage-blocksize, the file blocks to be punched may map only
part of a page. For file blocks inside such pages, we need to check for
the presence of BLK_STATE_UPTODATE flag.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/file.c | 89 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 88 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 38f5e8e..89ded7b 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2335,6 +2335,8 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	struct btrfs_path *path;
 	struct btrfs_block_rsv *rsv;
 	struct btrfs_trans_handle *trans;
+	struct address_space *mapping = inode->i_mapping;
+	pgoff_t start_index, end_index;
 	u64 lockstart;
 	u64 lockend;
 	u64 tail_start;
@@ -2347,6 +2349,7 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	int err = 0;
 	unsigned int rsv_count;
 	bool same_block;
+	bool same_page;
 	bool no_holes = btrfs_fs_incompat(root->fs_info, NO_HOLES);
 	u64 ino_size;
 	bool truncated_block = false;
@@ -2443,11 +2446,45 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 		goto out_only_mutex;
 	}
 
+	start_index = lockstart >> PAGE_SHIFT;
+	end_index = lockend >> PAGE_SHIFT;
+
+	same_page = lockstart >> PAGE_SHIFT
+		== lockend >> PAGE_SHIFT;
+
 	while (1) {
 		struct btrfs_ordered_extent *ordered;
+		struct page *start_page = NULL;
+		struct page *end_page = NULL;
+		u64 nr_pages;
+		int start_page_blks_uptodate;
+		int end_page_blks_uptodate;
 
 		truncate_pagecache_range(inode, lockstart, lockend);
 
+		if (lockstart & (PAGE_SIZE - 1)) {
+			start_page = find_or_create_page(mapping, start_index,
+							GFP_NOFS);
+			if (!start_page) {
+				inode_unlock(inode);
+				return -ENOMEM;
+			}
+		}
+
+		if (!same_page && ((lockend + 1) & (PAGE_SIZE - 1))) {
+			end_page = find_or_create_page(mapping, end_index,
+						GFP_NOFS);
+			if (!end_page) {
+				if (start_page) {
+					unlock_page(start_page);
+					put_page(start_page);
+				}
+				inode_unlock(inode);
+				return -ENOMEM;
+			}
+		}
+
+
 		lock_extent_bits(&BTRFS_I(inode)->io_tree, lockstart, lockend,
 				 &cached_state);
 		ordered = btrfs_lookup_first_ordered_extent(inode, lockend);
@@ -2457,18 +2494,68 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 		 * and nobody raced in and read a page in this range, if we did
 		 * we need to try again.
 		 */
+		nr_pages = round_up(lockend, PAGE_SIZE)
+			- round_down(lockstart, PAGE_SIZE);
+		nr_pages >>= PAGE_SHIFT;
+
+		start_page_blks_uptodate = 0;
+		end_page_blks_uptodate = 0;
+		if (root->sectorsize < PAGE_SIZE) {
+			u64 page_end;
+
+			page_end = round_down(lockstart, PAGE_SIZE)
+				+ PAGE_SIZE - 1;
+			page_end = min(page_end, lockend);
+			if (start_page
+				&& PagePrivate(start_page)
+				&& test_page_blks_state(start_page, 1 << BLK_STATE_UPTODATE,
+							lockstart, page_end, 0))
+				start_page_blks_uptodate = 1;
+			if (end_page
+				&& PagePrivate(end_page)
+				&& test_page_blks_state(end_page, 1 << BLK_STATE_UPTODATE,
+							page_offset(end_page), lockend, 0))
+				end_page_blks_uptodate = 1;
+		} else {
+			if (start_page && PagePrivate(start_page)
+				&& PageUptodate(start_page))
+				start_page_blks_uptodate = 1;
+			if (end_page && PagePrivate(end_page)
+				&& PageUptodate(end_page))
+				end_page_blks_uptodate = 1;
+		}
+
 		if ((!ordered ||
 		    (ordered->file_offset + ordered->len <= lockstart ||
 		     ordered->file_offset > lockend)) &&
-		     !btrfs_page_exists_in_range(inode, lockstart, lockend)) {
+		     (!start_page_blks_uptodate && !end_page_blks_uptodate &&
+			!(nr_pages > 2 && btrfs_page_exists_in_range(inode,
+					 round_up(lockstart, PAGE_SIZE),
+					 round_down(lockend, PAGE_SIZE) - 1)))) {
 			if (ordered)
 				btrfs_put_ordered_extent(ordered);
+			if (end_page) {
+				unlock_page(end_page);
+				put_page(end_page);
+			}
+			if (start_page) {
+				unlock_page(start_page);
+				put_page(start_page);
+			}
 			break;
 		}
 		if (ordered)
 			btrfs_put_ordered_extent(ordered);
 		unlock_extent_cached(&BTRFS_I(inode)->io_tree, lockstart,
 				     lockend, &cached_state, GFP_NOFS);
+		if (end_page) {
+			unlock_page(end_page);
+			put_page(end_page);
+		}
+		if (start_page) {
+			unlock_page(start_page);
+			put_page(start_page);
+		}
 		ret = btrfs_wait_ordered_range(inode, lockstart,
 					       lockend - lockstart + 1);
 		if (ret) {
-- 
2.5.5

