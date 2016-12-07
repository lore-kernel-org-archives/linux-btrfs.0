Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43334 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932671AbcLGVhf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Dec 2016 16:37:35 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, Jan Kara <jack@suse.cz>,
        David Sterba <dsterba@suse.cz>
Subject: [PATCH 5/6] Btrfs: add mmap_sem to avoid race between page faults and truncate/hole_punch
Date: Wed,  7 Dec 2016 13:45:09 -0800
Message-Id: <1481147110-20048-6-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1481147110-20048-1-git-send-email-bo.li.liu@oracle.com>
References: <1481147110-20048-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

How to serialise page_faults against truncate/hole punch?

For truncate, we firstly update isize and then truncate pagecache in
order to avoid race against page fault.
For punch_hole, we use lock_extent and truncate pagecache.

Although we have these rules to avoid the race, it's not easy to understand how
they do that.  This adds a new rw_semaphore mmap_sem in inode and grab it for
writing over truncate, hole punching and for reading over page faults.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/btrfs_inode.h |  7 +++++++
 fs/btrfs/file.c        | 40 +++++++++++++++++++++++-----------------
 fs/btrfs/inode.c       | 14 ++++++++++++--
 3 files changed, 42 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 1a8fa46..f3674fd 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -195,6 +195,13 @@ struct btrfs_inode {
 	 */
 	struct rw_semaphore dio_sem;
 
+	/*
+	 * To serialise page fault with truncate/punch_hole operations.
+	 * We have to make sure that new page cannot be faulted in a section
+	 * of the inode that is being punched.
+	 */
+	struct rw_semaphore mmap_sem;
+
 	struct inode vfs_inode;
 };
 
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 2d6ee1e..a5c375a 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2298,11 +2298,12 @@ static int btrfs_filemap_page_mkwrite(struct vm_area_struct *vma,
 		goto out;
 	}
 
+	down_read(&BTRFS_I(inode)->mmap_sem);
 	if (IS_DAX(inode))
 		ret = iomap_dax_fault(vma, vmf, &btrfs_iomap_ops);
 	else
 		ret = btrfs_page_mkwrite(vma, vmf);
-
+	up_read(&BTRFS_I(inode)->mmap_sem);
 out:
 	sb_end_pagefault(inode->i_sb);
 	return ret;
@@ -2316,10 +2317,12 @@ static int btrfs_filemap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	if ((vmf->flags & FAULT_FLAG_WRITE) && IS_DAX(inode))
 		return btrfs_filemap_page_mkwrite(vma, vmf);
 
+	down_read(&BTRFS_I(inode)->mmap_sem);
 	if (IS_DAX(inode))
 		ret = iomap_dax_fault(vma, vmf, &btrfs_iomap_ops);
 	else
 		ret = filemap_fault(vma, vmf);
+	up_read(&BTRFS_I(inode)->mmap_sem);
 
 	return ret;
 }
@@ -2335,17 +2338,13 @@ static int btrfs_filemap_pfn_mkwrite(struct vm_area_struct *vma,
 	sb_start_pagefault(sb);
 	file_update_time(vma->vm_file);
 
-	/*
-	 * How to serialise against truncate/hole punch similar to page_mkwrite?
-	 * For truncate, we firstly update isize and then truncate pagecache in
-	 * order to avoid race against page fault.
-	 * For punch_hole, we use lock_extent and truncate pagecache.
-	 */
+	down_read(&BTRFS_I(inode)->mmap_sem);
 	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	if (vmf->pgoff >= size)
 		ret = VM_FAULT_SIGBUS;
 	else
 		ret = dax_pfn_mkwrite(vma, vmf);
+	up_read(&BTRFS_I(inode)->mmap_sem);
 
 	sb_end_pagefault(sb);
 	return ret;
@@ -2576,6 +2575,13 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 			     BTRFS_I(inode)->root->sectorsize) - 1;
 	same_block = (BTRFS_BYTES_TO_BLKS(root->fs_info, offset))
 		== (BTRFS_BYTES_TO_BLKS(root->fs_info, offset + len - 1));
+
+	/*
+	 * Prevent page faults from reinstantiating pages we have released
+	 * from page cache.
+	 */
+	down_write(&BTRFS_I(inode)->mmap_sem);
+
 	/*
 	 * We needn't truncate any block which is beyond the end of the file
 	 * because we are sure there is no data there.
@@ -2591,17 +2597,15 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 		} else {
 			ret = 0;
 		}
-		goto out_only_mutex;
+		goto out_mmap;
 	}
 
 	/* zero back part of the first block */
 	if (offset < ino_size) {
 		truncated_block = true;
 		ret = btrfs_truncate_block(inode, offset, 0, 0);
-		if (ret) {
-			inode_unlock(inode);
-			return ret;
-		}
+		if (ret)
+			goto out_mmap;
 	}
 
 	/* Check the aligned pages after the first unaligned page,
@@ -2614,10 +2618,10 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 		offset = lockstart;
 		ret = find_first_non_hole(inode, &offset, &len);
 		if (ret < 0)
-			goto out_only_mutex;
+			goto out_mmap;
 		if (ret && !len) {
 			ret = 0;
-			goto out_only_mutex;
+			goto out_mmap;
 		}
 		lockstart = offset;
 	}
@@ -2628,7 +2632,7 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	if (tail_len) {
 		ret = find_first_non_hole(inode, &tail_start, &tail_len);
 		if (unlikely(ret < 0))
-			goto out_only_mutex;
+			goto out_mmap;
 		if (!ret) {
 			/* zero the front end of the last page */
 			if (tail_start + tail_len < ino_size) {
@@ -2637,14 +2641,14 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 							tail_start + tail_len,
 							0, 1);
 				if (ret)
-					goto out_only_mutex;
+					goto out_mmap;
 			}
 		}
 	}
 
 	if (lockend < lockstart) {
 		ret = 0;
-		goto out_only_mutex;
+		goto out_mmap;
 	}
 
 	while (1) {
@@ -2814,6 +2818,8 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 out:
 	unlock_extent_cached(&BTRFS_I(inode)->io_tree, lockstart, lockend,
 			     &cached_state, GFP_NOFS);
+out_mmap:
+	up_write(&BTRFS_I(inode)->mmap_sem);
 out_only_mutex:
 	if (!updated_inode && truncated_block && !ret && !err) {
 		/*
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 227ee4e..9851422 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5069,14 +5069,21 @@ static int btrfs_setsize(struct inode *inode, struct iattr *attr)
 		if (ret)
 			return ret;
 
-		/* we don't support swapfiles, so vmtruncate shouldn't fail */
-		truncate_setsize(inode, newsize);
+		/*
+		 * Update isize first so that if upcoming unlock dio read won't
+		 * race with truncate if they are beyond new isize.
+		 */
+		i_size_write(inode, newsize);
 
 		/* Disable nonlocked read DIO to avoid the end less truncate */
 		btrfs_inode_block_unlocked_dio(inode);
 		inode_dio_wait(inode);
 		btrfs_inode_resume_unlocked_dio(inode);
 
+		down_write(&BTRFS_I(inode)->mmap_sem);
+		/* we don't support swapfiles, so vmtruncate shouldn't fail */
+		truncate_pagecache(inode, newsize);
+
 		ret = btrfs_truncate(inode);
 		if (ret && inode->i_nlink) {
 			int err;
@@ -5089,6 +5096,7 @@ static int btrfs_setsize(struct inode *inode, struct iattr *attr)
 			 */
 			trans = btrfs_join_transaction(root);
 			if (IS_ERR(trans)) {
+				up_write(&BTRFS_I(inode)->mmap_sem);
 				btrfs_orphan_del(NULL, inode);
 				return ret;
 			}
@@ -5109,6 +5117,7 @@ static int btrfs_setsize(struct inode *inode, struct iattr *attr)
 			if (IS_DAX(inode))
 				ret = btrfs_truncate_block(inode, newsize, 0, 0);
 		}
+		up_write(&BTRFS_I(inode)->mmap_sem);
 	}
 
 	return ret;
@@ -9877,6 +9886,7 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 	INIT_LIST_HEAD(&ei->delayed_iput);
 	RB_CLEAR_NODE(&ei->rb_node);
 	init_rwsem(&ei->dio_sem);
+	init_rwsem(&ei->mmap_sem);
 
 	return inode;
 }
-- 
2.5.5

