Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp07.in.ibm.com ([125.16.236.7]:49084 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717AbcDNIdn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Apr 2016 04:33:43 -0400
Received: from localhost
	by e28smtp07.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Thu, 14 Apr 2016 14:03:38 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay07.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u3E8XYqK30277766
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Apr 2016 14:03:34 +0530
Received: from d28av04.in.ibm.com (localhost [127.0.0.1])
	by d28av04.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u3E8XWqR021610
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Apr 2016 14:03:33 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, dsterba@suse.cz, clm@fb.com,
        jbacik@fb.com, chandan@mykolab.com, aneesh.kumar@linux.vnet.ibm.com
Subject: [PATCH V16 10/18] Btrfs: subpage-blocksize: btrfs_punch_hole: Fix uptodate blocks check
Date: Thu, 14 Apr 2016 14:02:47 +0530
Message-Id: <1460622775-20723-11-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1460622775-20723-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1460622775-20723-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In case of subpage-blocksize, the file blocks to be punched may map only
part of a page. For file blocks inside such pages, we need to check for
the presence of BLK_STATE_UPTODATE flag.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/file.c | 66 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 65 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index e2f0968..a17bcab 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2321,6 +2321,8 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	struct btrfs_path *path;
 	struct btrfs_block_rsv *rsv;
 	struct btrfs_trans_handle *trans;
+	struct address_space *mapping = inode->i_mapping;
+	pgoff_t start_index, end_index;
 	u64 lockstart;
 	u64 lockend;
 	u64 tail_start;
@@ -2333,6 +2335,7 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	int err = 0;
 	unsigned int rsv_count;
 	bool same_block;
+	bool same_page;
 	bool no_holes = btrfs_fs_incompat(root->fs_info, NO_HOLES);
 	u64 ino_size;
 	bool truncated_block = false;
@@ -2429,11 +2432,43 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 		goto out_only_mutex;
 	}
 
+	start_index = lockstart >> PAGE_CACHE_SHIFT;
+	end_index = lockend >> PAGE_CACHE_SHIFT;
+
+	same_page = lockstart >> PAGE_CACHE_SHIFT
+		== lockend >> PAGE_CACHE_SHIFT;
+
 	while (1) {
 		struct btrfs_ordered_extent *ordered;
+		struct page *start_page = NULL;
+		struct page *end_page = NULL;
+		u64 nr_pages;
 
 		truncate_pagecache_range(inode, lockstart, lockend);
 
+		if (lockstart & (PAGE_CACHE_SIZE - 1)) {
+			start_page = find_or_create_page(mapping, start_index,
+							GFP_NOFS);
+			if (!start_page) {
+				mutex_unlock(&inode->i_mutex);
+				return -ENOMEM;
+			}
+		}
+
+		if (!same_page && ((lockend + 1) & (PAGE_CACHE_SIZE - 1))) {
+			end_page = find_or_create_page(mapping, end_index,
+						GFP_NOFS);
+			if (!end_page) {
+				if (start_page) {
+					unlock_page(start_page);
+					page_cache_release(start_page);
+				}
+				mutex_unlock(&inode->i_mutex);
+				return -ENOMEM;
+			}
+		}
+
+
 		lock_extent_bits(&BTRFS_I(inode)->io_tree, lockstart, lockend,
 				 &cached_state);
 		ordered = btrfs_lookup_first_ordered_extent(inode, lockend);
@@ -2443,18 +2478,47 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 		 * and nobody raced in and read a page in this range, if we did
 		 * we need to try again.
 		 */
+		nr_pages = round_up(lockend, PAGE_CACHE_SIZE)
+			- round_down(lockstart, PAGE_CACHE_SIZE);
+		nr_pages >>= PAGE_CACHE_SHIFT;
+
 		if ((!ordered ||
 		    (ordered->file_offset + ordered->len <= lockstart ||
 		     ordered->file_offset > lockend)) &&
-		     !btrfs_page_exists_in_range(inode, lockstart, lockend)) {
+		     (!(start_page && PagePrivate(start_page) &&
+			test_page_blks_state(start_page, 1 << BLK_STATE_UPTODATE,
+			 lockstart,
+			 min(lockstart + PAGE_CACHE_SIZE - 1, lockend), 0)) &&
+		      !(end_page && PagePrivate(end_page) &&
+			test_page_blks_state(end_page, 1 << BLK_STATE_UPTODATE,
+			 page_offset(end_page), lockend, 0)) &&
+		      !(nr_pages > 2 && btrfs_page_exists_in_range(inode,
+					 round_up(lockstart, PAGE_CACHE_SIZE),
+					 round_down(lockend, PAGE_CACHE_SIZE) - 1)))) {
 			if (ordered)
 				btrfs_put_ordered_extent(ordered);
+			if (end_page) {
+				unlock_page(end_page);
+				page_cache_release(end_page);
+			}
+			if (start_page) {
+				unlock_page(start_page);
+				page_cache_release(start_page);
+			}
 			break;
 		}
 		if (ordered)
 			btrfs_put_ordered_extent(ordered);
 		unlock_extent_cached(&BTRFS_I(inode)->io_tree, lockstart,
 				     lockend, &cached_state, GFP_NOFS);
+		if (end_page) {
+			unlock_page(end_page);
+			page_cache_release(end_page);
+		}
+		if (start_page) {
+			unlock_page(start_page);
+			page_cache_release(start_page);
+		}
 		ret = btrfs_wait_ordered_range(inode, lockstart,
 					       lockend - lockstart + 1);
 		if (ret) {
-- 
2.1.0

