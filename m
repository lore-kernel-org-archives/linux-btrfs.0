Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:56739 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161148AbaKNPkB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Nov 2014 10:40:01 -0500
Received: from /spool/local
	by e23smtp07.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Sat, 15 Nov 2014 01:40:00 +1000
Received: from d23relay10.au.ibm.com (d23relay10.au.ibm.com [9.190.26.77])
	by d23dlp01.au.ibm.com (Postfix) with ESMTP id 19BC92CE8055
	for <linux-btrfs@vger.kernel.org>; Sat, 15 Nov 2014 02:39:57 +1100 (EST)
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay10.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id sAEFfgf924838280
	for <linux-btrfs@vger.kernel.org>; Sat, 15 Nov 2014 02:41:50 +1100
Received: from d23av03.au.ibm.com (localhost [127.0.0.1])
	by d23av03.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id sAEFdNao021974
	for <linux-btrfs@vger.kernel.org>; Sat, 15 Nov 2014 02:39:24 +1100
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, bo.li.liu@oracle.com, dsterba@suse.cz
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        aneesh.kumar@linux.vnet.ibm.com, linux-btrfs@vger.kernel.org,
        chandan@mykolab.com, steve.capper@linaro.org
Subject: [RFC PATCH V9 15/17] Btrfs: subpagesize-blocksize: Revert commit fc4adbff823f76577ece26dcb88bf6f8392dbd43.
Date: Fri, 14 Nov 2014 21:08:17 +0530
Message-Id: <1415979499-15821-16-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1415979499-15821-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1415979499-15821-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In subpagesize-blocksize, we have multiple blocks in a page. Checking for
existence of a page in the page cache isn't a sufficient check, since we
could be truncating a subset of the blocks mapped by the page.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/btrfs_inode.h |  2 --
 fs/btrfs/file.c        |  4 ++-
 fs/btrfs/inode.c       | 77 +++-----------------------------------------------
 3 files changed, 7 insertions(+), 76 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 43527fd..50497bf 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -278,6 +278,4 @@ static inline void btrfs_inode_resume_unlocked_dio(struct inode *inode)
 		  &BTRFS_I(inode)->runtime_flags);
 }
 
-bool btrfs_page_exists_in_range(struct inode *inode, loff_t start, loff_t end);
-
 #endif
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index b1e0d27..3707515 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2314,7 +2314,9 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 		if ((!ordered ||
 		    (ordered->file_offset + ordered->len <= lockstart ||
 		     ordered->file_offset > lockend)) &&
-		     !btrfs_page_exists_in_range(inode, lockstart, lockend)) {
+		     !test_range_bit(&BTRFS_I(inode)->io_tree, lockstart,
+				     lockend, EXTENT_UPTODATE, 0,
+				     cached_state)) {
 			if (ordered)
 				btrfs_put_ordered_extent(ordered);
 			break;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e0dd338..b236417 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6832,76 +6832,6 @@ out:
 	return ret;
 }
 
-bool btrfs_page_exists_in_range(struct inode *inode, loff_t start, loff_t end)
-{
-	struct radix_tree_root *root = &inode->i_mapping->page_tree;
-	int found = false;
-	void **pagep = NULL;
-	struct page *page = NULL;
-	int start_idx;
-	int end_idx;
-
-	start_idx = start >> PAGE_CACHE_SHIFT;
-
-	/*
-	 * end is the last byte in the last page.  end == start is legal
-	 */
-	end_idx = end >> PAGE_CACHE_SHIFT;
-
-	rcu_read_lock();
-
-	/* Most of the code in this while loop is lifted from
-	 * find_get_page.  It's been modified to begin searching from a
-	 * page and return just the first page found in that range.  If the
-	 * found idx is less than or equal to the end idx then we know that
-	 * a page exists.  If no pages are found or if those pages are
-	 * outside of the range then we're fine (yay!) */
-	while (page == NULL &&
-	       radix_tree_gang_lookup_slot(root, &pagep, NULL, start_idx, 1)) {
-		page = radix_tree_deref_slot(pagep);
-		if (unlikely(!page))
-			break;
-
-		if (radix_tree_exception(page)) {
-			if (radix_tree_deref_retry(page)) {
-				page = NULL;
-				continue;
-			}
-			/*
-			 * Otherwise, shmem/tmpfs must be storing a swap entry
-			 * here as an exceptional entry: so return it without
-			 * attempting to raise page count.
-			 */
-			page = NULL;
-			break; /* TODO: Is this relevant for this use case? */
-		}
-
-		if (!page_cache_get_speculative(page)) {
-			page = NULL;
-			continue;
-		}
-
-		/*
-		 * Has the page moved?
-		 * This is part of the lockless pagecache protocol. See
-		 * include/linux/pagemap.h for details.
-		 */
-		if (unlikely(page != *pagep)) {
-			page_cache_release(page);
-			page = NULL;
-		}
-	}
-
-	if (page) {
-		if (page->index <= end_idx)
-			found = true;
-		page_cache_release(page);
-	}
-
-	rcu_read_unlock();
-	return found;
-}
-
 static int lock_extent_direct(struct inode *inode, u64 lockstart, u64 lockend,
 			      struct extent_state **cached_state, int writing)
 {
@@ -6926,9 +6856,10 @@ static int lock_extent_direct(struct inode *inode, u64 lockstart, u64 lockend,
 		 * invalidate needs to happen so that reads after a write do not
 		 * get stale data.
 		 */
-		if (!ordered &&
-		    (!writing ||
-		     !btrfs_page_exists_in_range(inode, lockstart, lockend)))
+		if (!ordered && (!writing ||
+		    !test_range_bit(&BTRFS_I(inode)->io_tree,
+				    lockstart, lockend, EXTENT_UPTODATE, 0,
+				    *cached_state)))
 			break;
 
 		unlock_extent_cached(&BTRFS_I(inode)->io_tree, lockstart, lockend,
-- 
2.1.0

