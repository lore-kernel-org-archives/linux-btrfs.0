Return-Path: <SRS0=lg0L=OQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	T_DKIMWL_WL_HIGH,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D7D2C07E85
	for <linux-btrfs@archiver.kernel.org>; Fri,  7 Dec 2018 13:25:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAEE720837
	for <linux-btrfs@archiver.kernel.org>; Fri,  7 Dec 2018 13:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544189100;
	bh=0cggkTrLl1YcAz55UO2ciOsS57aBI9qg+FUyAduviys=;
	h=From:To:Subject:Date:List-ID:From;
	b=jl2KfGz/9vk6J/Rqide6MSg/sPjZmj0TBNnTmkbQc9guY+Hi2JDr1sh2GDUr5Ah+V
	 lRBcsnbu+U01Na3HrGolVwj/4kBDNzFnWYN3xnvPmCLTlPQgUUX/f+O+IxpJiNVOuN
	 ckrqp5TkLnfVqX4m3ikymliN76iGBSI7g5avvrgk=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DAEE720837
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726021AbeLGNY6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 7 Dec 2018 08:24:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:58364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725997AbeLGNY6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Dec 2018 08:24:58 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 197A620837
        for <linux-btrfs@vger.kernel.org>; Fri,  7 Dec 2018 13:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1544189096;
        bh=0cggkTrLl1YcAz55UO2ciOsS57aBI9qg+FUyAduviys=;
        h=From:To:Subject:Date:From;
        b=uIAGZdnkRhbZ7E97l+Kuwk20QHfC1VLDCGvN3ZdGm7I/tt3ZiAGUY3pyQnJzTTvEa
         vaQnqceqadjnSuXQAcLj4TnB2+F+t1pFGi5Gm2HzBtN0NSAj2JYmO57XpsVe5wscfz
         463yA06hPIdSPmXcwkdxDT08kWK4/w89PuKl8HWQ=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: use generic_remap_file_range_prep() for cloning and deduplication
Date:   Fri,  7 Dec 2018 13:24:53 +0000
Message-Id: <20181207132453.5455-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

Since cloning and deduplication are no longer Btrfs specific operations, we
now have generic code to handle parameter validation, compare file ranges
used for deduplication, clear capabilities when cloning, etc. This change
makes Btrfs use it, eliminating a lot of code in Btrfs and also fixing a
few bugs, such as:

1) When cloning, the destination file's capabilities were not dropped
   (the fstest generic/513 tests this);

2) We were not checking if the destination file is immutable;

3) Not checking if either the source or destination files are swap
   files (swap file support is coming soon for Btrfs);

4) System limits were not checked (resource limits and O_LARGEFILE).

Note that the generic helper generic_remap_file_range_prep() does start
and waits for writeback by calling filemap_write_and_wait_range(), however
that is not enough for Btrfs for two reasons:

1) With compression, we need to start writeback twice in order to get the
   pages marked for writeback and ordered extents created;

2) filemap_write_and_wait_range() (and all its other variants) only waits
   for the IO to complete, but we need to wait for the ordered extents to
   finish, so that when we do the actual reflinking operations the file
   extent items are in the fs tree. This is also important due to the fact
   that the generic helper, for the deduplication case, compares the
   contents of the pages in the requested range, which might require
   reading extents from disk in the very unlikely case that pages get
   invalidated after writeback finishes (so the file extent items must be
   up to date in the fs tree).

Since these reasons are specific to Btrfs we have to do it in the Btrfs
code before calling generic_remap_file_range_prep(). This also results in
a more simple way of dealing with existing delalloc in the source/target
ranges, specially for the deduplication case where we used to lock all the
pages first and then if we found any dealloc for the range, or ordered
extent, we would unlock the pages trigger writeback and wait for ordered
extents to complete, then lock all the pages again and check if
deduplication can be done. So now we get a simpler approach: lock the
inodes, then trigger writeback and then wait for ordered extents to
complete.

So make btrfs use generic_remap_file_range_prep() (XFS and OCFS2 use it)
to eliminate duplicated code, fix a few bugs and benefit from future bug
fixes done there - for example the recent clone and dedupe bugs involving
reflinking a partial EOF block got a counterpart fix in the generic helpe,
since it affected all filesystems supporting these operations, so we no
longer need special checks in Btrfs for them.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ioctl.c | 615 ++++++++++++-------------------------------------------
 1 file changed, 132 insertions(+), 483 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 802a628e9f7d..261e116dddb2 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3191,92 +3191,6 @@ static long btrfs_ioctl_dev_info(struct btrfs_fs_info *fs_info,
 	return ret;
 }
 
-static struct page *extent_same_get_page(struct inode *inode, pgoff_t index)
-{
-	struct page *page;
-
-	page = grab_cache_page(inode->i_mapping, index);
-	if (!page)
-		return ERR_PTR(-ENOMEM);
-
-	if (!PageUptodate(page)) {
-		int ret;
-
-		ret = btrfs_readpage(NULL, page);
-		if (ret)
-			return ERR_PTR(ret);
-		lock_page(page);
-		if (!PageUptodate(page)) {
-			unlock_page(page);
-			put_page(page);
-			return ERR_PTR(-EIO);
-		}
-		if (page->mapping != inode->i_mapping) {
-			unlock_page(page);
-			put_page(page);
-			return ERR_PTR(-EAGAIN);
-		}
-	}
-
-	return page;
-}
-
-static int gather_extent_pages(struct inode *inode, struct page **pages,
-			       int num_pages, u64 off)
-{
-	int i;
-	pgoff_t index = off >> PAGE_SHIFT;
-
-	for (i = 0; i < num_pages; i++) {
-again:
-		pages[i] = extent_same_get_page(inode, index + i);
-		if (IS_ERR(pages[i])) {
-			int err = PTR_ERR(pages[i]);
-
-			if (err == -EAGAIN)
-				goto again;
-			pages[i] = NULL;
-			return err;
-		}
-	}
-	return 0;
-}
-
-static int lock_extent_range(struct inode *inode, u64 off, u64 len,
-			     bool retry_range_locking)
-{
-	/*
-	 * Do any pending delalloc/csum calculations on inode, one way or
-	 * another, and lock file content.
-	 * The locking order is:
-	 *
-	 *   1) pages
-	 *   2) range in the inode's io tree
-	 */
-	while (1) {
-		struct btrfs_ordered_extent *ordered;
-		lock_extent(&BTRFS_I(inode)->io_tree, off, off + len - 1);
-		ordered = btrfs_lookup_first_ordered_extent(inode,
-							    off + len - 1);
-		if ((!ordered ||
-		     ordered->file_offset + ordered->len <= off ||
-		     ordered->file_offset >= off + len) &&
-		    !test_range_bit(&BTRFS_I(inode)->io_tree, off,
-				    off + len - 1, EXTENT_DELALLOC, 0, NULL)) {
-			if (ordered)
-				btrfs_put_ordered_extent(ordered);
-			break;
-		}
-		unlock_extent(&BTRFS_I(inode)->io_tree, off, off + len - 1);
-		if (ordered)
-			btrfs_put_ordered_extent(ordered);
-		if (!retry_range_locking)
-			return -EAGAIN;
-		btrfs_wait_ordered_range(inode, off, len);
-	}
-	return 0;
-}
-
 static void btrfs_double_inode_unlock(struct inode *inode1, struct inode *inode2)
 {
 	inode_unlock(inode1);
@@ -3292,261 +3206,32 @@ static void btrfs_double_inode_lock(struct inode *inode1, struct inode *inode2)
 	inode_lock_nested(inode2, I_MUTEX_CHILD);
 }
 
-static void btrfs_double_extent_unlock(struct inode *inode1, u64 loff1,
-				      struct inode *inode2, u64 loff2, u64 len)
-{
-	unlock_extent(&BTRFS_I(inode1)->io_tree, loff1, loff1 + len - 1);
-	unlock_extent(&BTRFS_I(inode2)->io_tree, loff2, loff2 + len - 1);
-}
-
-static int btrfs_double_extent_lock(struct inode *inode1, u64 loff1,
-				    struct inode *inode2, u64 loff2, u64 len,
-				    bool retry_range_locking)
-{
-	int ret;
-
-	if (inode1 < inode2) {
-		swap(inode1, inode2);
-		swap(loff1, loff2);
-	}
-	ret = lock_extent_range(inode1, loff1, len, retry_range_locking);
-	if (ret)
-		return ret;
-	ret = lock_extent_range(inode2, loff2, len, retry_range_locking);
-	if (ret)
-		unlock_extent(&BTRFS_I(inode1)->io_tree, loff1,
-			      loff1 + len - 1);
-	return ret;
-}
-
-struct cmp_pages {
-	int		num_pages;
-	struct page	**src_pages;
-	struct page	**dst_pages;
-};
-
-static void btrfs_cmp_data_free(struct cmp_pages *cmp)
-{
-	int i;
-	struct page *pg;
-
-	for (i = 0; i < cmp->num_pages; i++) {
-		pg = cmp->src_pages[i];
-		if (pg) {
-			unlock_page(pg);
-			put_page(pg);
-			cmp->src_pages[i] = NULL;
-		}
-		pg = cmp->dst_pages[i];
-		if (pg) {
-			unlock_page(pg);
-			put_page(pg);
-			cmp->dst_pages[i] = NULL;
-		}
-	}
-}
-
-static int btrfs_cmp_data_prepare(struct inode *src, u64 loff,
-				  struct inode *dst, u64 dst_loff,
-				  u64 len, struct cmp_pages *cmp)
-{
-	int ret;
-	int num_pages = PAGE_ALIGN(len) >> PAGE_SHIFT;
-
-	cmp->num_pages = num_pages;
-
-	ret = gather_extent_pages(src, cmp->src_pages, num_pages, loff);
-	if (ret)
-		goto out;
-
-	ret = gather_extent_pages(dst, cmp->dst_pages, num_pages, dst_loff);
-
-out:
-	if (ret)
-		btrfs_cmp_data_free(cmp);
-	return ret;
-}
-
-static int btrfs_cmp_data(u64 len, struct cmp_pages *cmp)
-{
-	int ret = 0;
-	int i;
-	struct page *src_page, *dst_page;
-	unsigned int cmp_len = PAGE_SIZE;
-	void *addr, *dst_addr;
-
-	i = 0;
-	while (len) {
-		if (len < PAGE_SIZE)
-			cmp_len = len;
-
-		BUG_ON(i >= cmp->num_pages);
-
-		src_page = cmp->src_pages[i];
-		dst_page = cmp->dst_pages[i];
-		ASSERT(PageLocked(src_page));
-		ASSERT(PageLocked(dst_page));
-
-		addr = kmap_atomic(src_page);
-		dst_addr = kmap_atomic(dst_page);
-
-		flush_dcache_page(src_page);
-		flush_dcache_page(dst_page);
-
-		if (memcmp(addr, dst_addr, cmp_len))
-			ret = -EBADE;
-
-		kunmap_atomic(addr);
-		kunmap_atomic(dst_addr);
-
-		if (ret)
-			break;
-
-		len -= cmp_len;
-		i++;
-	}
-
-	return ret;
-}
-
-static int extent_same_check_offsets(struct inode *inode, u64 off, u64 *plen,
-				     u64 olen)
-{
-	u64 len = *plen;
-	u64 bs = BTRFS_I(inode)->root->fs_info->sb->s_blocksize;
-
-	if (off + olen > inode->i_size || off + olen < off)
-		return -EINVAL;
-
-	/* if we extend to eof, continue to block boundary */
-	if (off + len == inode->i_size)
-		*plen = len = ALIGN(inode->i_size, bs) - off;
-
-	/* Check that we are block aligned - btrfs_clone() requires this */
-	if (!IS_ALIGNED(off, bs) || !IS_ALIGNED(off + len, bs))
-		return -EINVAL;
-
-	return 0;
-}
-
 static int btrfs_extent_same_range(struct inode *src, u64 loff, u64 olen,
-				   struct inode *dst, u64 dst_loff,
-				   struct cmp_pages *cmp)
+				   struct inode *dst, u64 dst_loff)
 {
+	u64 bs = BTRFS_I(src)->root->fs_info->sb->s_blocksize;
 	int ret;
 	u64 len = olen;
-	bool same_inode = (src == dst);
-	u64 same_lock_start = 0;
-	u64 same_lock_len = 0;
-
-	ret = extent_same_check_offsets(src, loff, &len, olen);
-	if (ret)
-		return ret;
-
-	ret = extent_same_check_offsets(dst, dst_loff, &len, olen);
-	if (ret)
-		return ret;
-
-	if (same_inode) {
-		/*
-		 * Single inode case wants the same checks, except we
-		 * don't want our length pushed out past i_size as
-		 * comparing that data range makes no sense.
-		 *
-		 * extent_same_check_offsets() will do this for an
-		 * unaligned length at i_size, so catch it here and
-		 * reject the request.
-		 *
-		 * This effectively means we require aligned extents
-		 * for the single-inode case, whereas the other cases
-		 * allow an unaligned length so long as it ends at
-		 * i_size.
-		 */
-		if (len != olen)
-			return -EINVAL;
-
-		/* Check for overlapping ranges */
-		if (dst_loff + len > loff && dst_loff < loff + len)
-			return -EINVAL;
-
-		same_lock_start = min_t(u64, loff, dst_loff);
-		same_lock_len = max_t(u64, loff, dst_loff) + len - same_lock_start;
-	} else {
-		/*
-		 * If the source and destination inodes are different, the
-		 * source's range end offset matches the source's i_size, that
-		 * i_size is not a multiple of the sector size, and the
-		 * destination range does not go past the destination's i_size,
-		 * we must round down the length to the nearest sector size
-		 * multiple. If we don't do this adjustment we end replacing
-		 * with zeroes the bytes in the range that starts at the
-		 * deduplication range's end offset and ends at the next sector
-		 * size multiple.
-		 */
-		if (loff + olen == i_size_read(src) &&
-		    dst_loff + len < i_size_read(dst)) {
-			const u64 sz = BTRFS_I(src)->root->fs_info->sectorsize;
-
-			len = round_down(i_size_read(src), sz) - loff;
-			if (len == 0)
-				return 0;
-			olen = len;
-		}
-	}
-
-again:
-	ret = btrfs_cmp_data_prepare(src, loff, dst, dst_loff, olen, cmp);
-	if (ret)
-		return ret;
 
-	if (same_inode)
-		ret = lock_extent_range(src, same_lock_start, same_lock_len,
-					false);
-	else
-		ret = btrfs_double_extent_lock(src, loff, dst, dst_loff, len,
-					       false);
+	if (loff + len == src->i_size)
+		len = ALIGN(src->i_size, bs) - loff;
 	/*
-	 * If one of the inodes has dirty pages in the respective range or
-	 * ordered extents, we need to flush dellaloc and wait for all ordered
-	 * extents in the range. We must unlock the pages and the ranges in the
-	 * io trees to avoid deadlocks when flushing delalloc (requires locking
-	 * pages) and when waiting for ordered extents to complete (they require
-	 * range locking).
+	 * For same inode case we don't want our length pushed out past i_size
+	 * as comparing that data range makes no sense.
+	 *
+	 * This effectively means we require aligned extents for the single
+	 * inode case, whereas the other cases allow an unaligned length so long
+	 * as it ends at i_size.
 	 */
-	if (ret == -EAGAIN) {
-		/*
-		 * Ranges in the io trees already unlocked. Now unlock all
-		 * pages before waiting for all IO to complete.
-		 */
-		btrfs_cmp_data_free(cmp);
-		if (same_inode) {
-			btrfs_wait_ordered_range(src, same_lock_start,
-						 same_lock_len);
-		} else {
-			btrfs_wait_ordered_range(src, loff, len);
-			btrfs_wait_ordered_range(dst, dst_loff, len);
-		}
-		goto again;
-	}
-	ASSERT(ret == 0);
-	if (WARN_ON(ret)) {
-		/* ranges in the io trees already unlocked */
-		btrfs_cmp_data_free(cmp);
-		return ret;
-	}
-
-	/* pass original length for comparison so we stay within i_size */
-	ret = btrfs_cmp_data(olen, cmp);
-	if (ret == 0)
-		ret = btrfs_clone(src, dst, loff, olen, len, dst_loff, 1);
-
-	if (same_inode)
-		unlock_extent(&BTRFS_I(src)->io_tree, same_lock_start,
-			      same_lock_start + same_lock_len - 1);
-	else
-		btrfs_double_extent_unlock(src, loff, dst, dst_loff, len);
+	if (dst == src && len != olen)
+		return -EINVAL;
 
-	btrfs_cmp_data_free(cmp);
+	/*
+	 * Lock destination range to serialize with concurrent readpages().
+	 */
+	lock_extent(&BTRFS_I(dst)->io_tree, dst_loff, dst_loff + len - 1);
+	ret = btrfs_clone(src, dst, loff, olen, len, dst_loff, 1);
+	unlock_extent(&BTRFS_I(dst)->io_tree, dst_loff, dst_loff + len - 1);
 
 	return ret;
 }
@@ -3557,58 +3242,24 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
 			     struct inode *dst, u64 dst_loff)
 {
 	int ret;
-	struct cmp_pages cmp;
 	int num_pages = PAGE_ALIGN(BTRFS_MAX_DEDUPE_LEN) >> PAGE_SHIFT;
-	bool same_inode = (src == dst);
 	u64 i, tail_len, chunk_count;
 
-	if (olen == 0)
-		return 0;
-
-	if (same_inode)
-		inode_lock(src);
-	else
-		btrfs_double_inode_lock(src, dst);
-
 	/* don't make the dst file partly checksummed */
 	if ((BTRFS_I(src)->flags & BTRFS_INODE_NODATASUM) !=
-	    (BTRFS_I(dst)->flags & BTRFS_INODE_NODATASUM)) {
-		ret = -EINVAL;
-		goto out_unlock;
-	}
+	    (BTRFS_I(dst)->flags & BTRFS_INODE_NODATASUM))
+		return -EINVAL;
 
 	tail_len = olen % BTRFS_MAX_DEDUPE_LEN;
 	chunk_count = div_u64(olen, BTRFS_MAX_DEDUPE_LEN);
 	if (chunk_count == 0)
 		num_pages = PAGE_ALIGN(tail_len) >> PAGE_SHIFT;
 
-	/*
-	 * If deduping ranges in the same inode, locking rules make it
-	 * mandatory to always lock pages in ascending order to avoid deadlocks
-	 * with concurrent tasks (such as starting writeback/delalloc).
-	 */
-	if (same_inode && dst_loff < loff)
-		swap(loff, dst_loff);
-
-	/*
-	 * We must gather up all the pages before we initiate our extent
-	 * locking. We use an array for the page pointers. Size of the array is
-	 * bounded by len, which is in turn bounded by BTRFS_MAX_DEDUPE_LEN.
-	 */
-	cmp.src_pages = kvmalloc_array(num_pages, sizeof(struct page *),
-				       GFP_KERNEL | __GFP_ZERO);
-	cmp.dst_pages = kvmalloc_array(num_pages, sizeof(struct page *),
-				       GFP_KERNEL | __GFP_ZERO);
-	if (!cmp.src_pages || !cmp.dst_pages) {
-		ret = -ENOMEM;
-		goto out_free;
-	}
-
 	for (i = 0; i < chunk_count; i++) {
 		ret = btrfs_extent_same_range(src, loff, BTRFS_MAX_DEDUPE_LEN,
-					      dst, dst_loff, &cmp);
+					      dst, dst_loff);
 		if (ret)
-			goto out_free;
+			return ret;
 
 		loff += BTRFS_MAX_DEDUPE_LEN;
 		dst_loff += BTRFS_MAX_DEDUPE_LEN;
@@ -3616,17 +3267,7 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
 
 	if (tail_len > 0)
 		ret = btrfs_extent_same_range(src, loff, tail_len, dst,
-					      dst_loff, &cmp);
-
-out_free:
-	kvfree(cmp.src_pages);
-	kvfree(cmp.dst_pages);
-
-out_unlock:
-	if (same_inode)
-		inode_unlock(src);
-	else
-		btrfs_double_inode_unlock(src, dst);
+					      dst_loff);
 
 	return ret;
 }
@@ -4213,11 +3854,9 @@ static noinline int btrfs_clone_files(struct file *file, struct file *file_src,
 	struct inode *inode = file_inode(file);
 	struct inode *src = file_inode(file_src);
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
-	struct btrfs_root *root = BTRFS_I(inode)->root;
 	int ret;
 	u64 len = olen;
 	u64 bs = fs_info->sb->s_blocksize;
-	int same_inode = src == inode;
 
 	/*
 	 * TODO:
@@ -4230,101 +3869,32 @@ static noinline int btrfs_clone_files(struct file *file, struct file *file_src,
 	 *   be either compressed or non-compressed.
 	 */
 
-	if (btrfs_root_readonly(root))
-		return -EROFS;
-
-	if (file_src->f_path.mnt != file->f_path.mnt ||
-	    src->i_sb != inode->i_sb)
-		return -EXDEV;
-
-	if (S_ISDIR(src->i_mode) || S_ISDIR(inode->i_mode))
-		return -EISDIR;
-
-	if (!same_inode) {
-		btrfs_double_inode_lock(src, inode);
-	} else {
-		inode_lock(src);
-	}
-
 	/* don't make the dst file partly checksummed */
 	if ((BTRFS_I(src)->flags & BTRFS_INODE_NODATASUM) !=
-	    (BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM)) {
-		ret = -EINVAL;
-		goto out_unlock;
-	}
+	    (BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM))
+		return -EINVAL;
 
-	/* determine range to clone */
-	ret = -EINVAL;
-	if (off + len > src->i_size || off + len < off)
-		goto out_unlock;
-	if (len == 0)
-		olen = len = src->i_size - off;
 	/*
-	 * If we extend to eof, continue to block boundary if and only if the
-	 * destination end offset matches the destination file's size, otherwise
-	 * we would be corrupting data by placing the eof block into the middle
-	 * of a file.
+	 * VFS's generic_remap_file_range_prep() protects us from cloning the
+	 * eof block into the middle of a file, which would result in corruption
+	 * if the file size is not blocksize aligned. So we don't need to check
+	 * for that case here.
 	 */
-	if (off + len == src->i_size) {
-		if (!IS_ALIGNED(len, bs) && destoff + len < inode->i_size)
-			goto out_unlock;
+	if (off + len == src->i_size)
 		len = ALIGN(src->i_size, bs) - off;
-	}
-
-	if (len == 0) {
-		ret = 0;
-		goto out_unlock;
-	}
-
-	/* verify the end result is block aligned */
-	if (!IS_ALIGNED(off, bs) || !IS_ALIGNED(off + len, bs) ||
-	    !IS_ALIGNED(destoff, bs))
-		goto out_unlock;
-
-	/* verify if ranges are overlapped within the same file */
-	if (same_inode) {
-		if (destoff + len > off && destoff < off + len)
-			goto out_unlock;
-	}
 
 	if (destoff > inode->i_size) {
 		ret = btrfs_cont_expand(inode, inode->i_size, destoff);
 		if (ret)
-			goto out_unlock;
+			return ret;
 	}
 
 	/*
-	 * Lock the target range too. Right after we replace the file extent
-	 * items in the fs tree (which now point to the cloned data), we might
-	 * have a worker replace them with extent items relative to a write
-	 * operation that was issued before this clone operation (i.e. confront
-	 * with inode.c:btrfs_finish_ordered_io).
+	 * Lock destination range to serialize with concurrent readpages().
 	 */
-	if (same_inode) {
-		u64 lock_start = min_t(u64, off, destoff);
-		u64 lock_len = max_t(u64, off, destoff) + len - lock_start;
-
-		ret = lock_extent_range(src, lock_start, lock_len, true);
-	} else {
-		ret = btrfs_double_extent_lock(src, off, inode, destoff, len,
-					       true);
-	}
-	ASSERT(ret == 0);
-	if (WARN_ON(ret)) {
-		/* ranges in the io trees already unlocked */
-		goto out_unlock;
-	}
-
+	lock_extent(&BTRFS_I(inode)->io_tree, destoff, destoff + len - 1);
 	ret = btrfs_clone(src, inode, off, olen, len, destoff, 0);
-
-	if (same_inode) {
-		u64 lock_start = min_t(u64, off, destoff);
-		u64 lock_end = max_t(u64, off, destoff) + len - 1;
-
-		unlock_extent(&BTRFS_I(src)->io_tree, lock_start, lock_end);
-	} else {
-		btrfs_double_extent_unlock(src, off, inode, destoff, len);
-	}
+	unlock_extent(&BTRFS_I(inode)->io_tree, destoff, destoff + len - 1);
 	/*
 	 * Truncate page cache pages so that future reads will see the cloned
 	 * data immediately and not the previous data.
@@ -4332,11 +3902,90 @@ static noinline int btrfs_clone_files(struct file *file, struct file *file_src,
 	truncate_inode_pages_range(&inode->i_data,
 				round_down(destoff, PAGE_SIZE),
 				round_up(destoff + len, PAGE_SIZE) - 1);
-out_unlock:
+
+	return ret;
+}
+
+static int btrfs_remap_file_range_prep(struct file *file_in, loff_t pos_in,
+				       struct file *file_out, loff_t pos_out,
+				       loff_t *len, unsigned int remap_flags)
+{
+	struct inode *inode_in = file_inode(file_in);
+	struct inode *inode_out = file_inode(file_out);
+	u64 bs = BTRFS_I(inode_out)->root->fs_info->sb->s_blocksize;
+	bool same_inode = inode_out == inode_in;
+	u64 wb_len;
+	int ret;
+
+	if (!(remap_flags & REMAP_FILE_DEDUP)) {
+		struct btrfs_root *root_out = BTRFS_I(inode_out)->root;
+
+		if (btrfs_root_readonly(root_out))
+			return -EROFS;
+
+		if (file_in->f_path.mnt != file_out->f_path.mnt ||
+		    inode_in->i_sb != inode_out->i_sb)
+			return -EXDEV;
+
+		if (S_ISDIR(inode_in->i_mode) || S_ISDIR(inode_out->i_mode))
+			return -EISDIR;
+	}
+
+	if (same_inode)
+		inode_lock(inode_in);
+	else
+		btrfs_double_inode_lock(inode_in, inode_out);
+
+	/*
+	 * Now that the inodes are locked, we need to start writeback ourselves
+	 * and can not rely on the writeback from the VFS's generic helper
+	 * generic_remap_file_range_prep() because:
+	 *
+	 * 1) For compression we must call filemap_fdatawrite_range() range
+	 *    twice (btrfs_fdatawrite_range() does it for us), and the generic
+	 *    helper only calls it once;
+	 *
+	 * 2) filemap_fdatawrite_range(), called by the generic helper only
+	 *    waits for the writeback to complete, i.e. for IO to be done, and
+	 *    not for the ordered extents to complete. We need to wait for them
+	 *    to complete so that new file extent items are in the fs tree.
+	 */
+	if (*len == 0 && !(remap_flags & REMAP_FILE_DEDUP))
+		wb_len = ALIGN(inode_in->i_size, bs) - ALIGN_DOWN(pos_in, bs);
+	else
+		wb_len = ALIGN(*len, bs);
+
+	/*
+	 * Since we don't lock ranges, wait for ongoing lockless dio writes (as
+	 * any in progress could create its ordered extents after we wait for
+	 * existing ordered extents below).
+	 */
+	inode_dio_wait(inode_in);
 	if (!same_inode)
-		btrfs_double_inode_unlock(src, inode);
+		inode_dio_wait(inode_out);
+
+	ret = btrfs_wait_ordered_range(inode_in, ALIGN_DOWN(pos_in, bs),
+				       wb_len);
+	if (ret < 0)
+		goto out_unlock;
+	ret = btrfs_wait_ordered_range(inode_out, ALIGN_DOWN(pos_out, bs),
+				       wb_len);
+	if (ret < 0)
+		goto out_unlock;
+
+	ret = generic_remap_file_range_prep(file_in, pos_in, file_out, pos_out,
+					    len, remap_flags);
+	if (ret < 0 || *len == 0)
+		goto out_unlock;
+
+	return 0;
+
+ out_unlock:
+	if (same_inode)
+		inode_unlock(inode_in);
 	else
-		inode_unlock(src);
+		btrfs_double_inode_unlock(inode_in, inode_out);
+
 	return ret;
 }
 
@@ -4344,29 +3993,29 @@ loff_t btrfs_remap_file_range(struct file *src_file, loff_t off,
 		struct file *dst_file, loff_t destoff, loff_t len,
 		unsigned int remap_flags)
 {
+	struct inode *src_inode = file_inode(src_file);
+	struct inode *dst_inode = file_inode(dst_file);
+	bool same_inode = dst_inode == src_inode;
 	int ret;
 
 	if (remap_flags & ~(REMAP_FILE_DEDUP | REMAP_FILE_ADVISORY))
 		return -EINVAL;
 
-	if (remap_flags & REMAP_FILE_DEDUP) {
-		struct inode *src = file_inode(src_file);
-		struct inode *dst = file_inode(dst_file);
-		u64 bs = BTRFS_I(src)->root->fs_info->sb->s_blocksize;
-
-		if (WARN_ON_ONCE(bs < PAGE_SIZE)) {
-			/*
-			 * Btrfs does not support blocksize < page_size. As a
-			 * result, btrfs_cmp_data() won't correctly handle
-			 * this situation without an update.
-			 */
-			return -EINVAL;
-		}
+	ret = btrfs_remap_file_range_prep(src_file, off, dst_file, destoff,
+					  &len, remap_flags);
+	if (ret < 0 || len == 0)
+		return ret;
 
-		ret = btrfs_extent_same(src, off, len, dst, destoff);
-	} else {
+	if (remap_flags & REMAP_FILE_DEDUP)
+		ret = btrfs_extent_same(src_inode, off, len, dst_inode, destoff);
+	else
 		ret = btrfs_clone_files(dst_file, src_file, off, len, destoff);
-	}
+
+	if (same_inode)
+		inode_unlock(src_inode);
+	else
+		btrfs_double_inode_unlock(src_inode, dst_inode);
+
 	return ret < 0 ? ret : len;
 }
 
-- 
2.11.0

