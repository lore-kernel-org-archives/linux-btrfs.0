Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 7.mo68.mail-out.ovh.net ([46.105.63.230]:49830 "EHLO
        7.mo68.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934820AbcLPQrQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Dec 2016 11:47:16 -0500
Received: from player737.ha.ovh.net (b9.ovh.net [213.186.33.59])
        by mo68.mail-out.ovh.net (Postfix) with ESMTP id B591015174
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Dec 2016 15:17:55 +0100 (CET)
From: Philippe Loctaux <phil@philippeloctaux.com>
To: clm@fb.com
Cc: jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, phil@philippeloctaux.com
Subject: [PATCH] btrfs: file.c: file cleanup
Date: Fri, 16 Dec 2016 15:17:33 +0100
Message-Id: <1481897853-13232-1-git-send-email-phil@philippeloctaux.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

cleaned up the file with checkpatch

Signed-off-by: Philippe Loctaux <phil@philippeloctaux.com>
---
 fs/btrfs/file.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 3a14c87..d131b8d 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -464,6 +464,7 @@ static noinline int btrfs_copy_from_user(loff_t pos, size_t write_bytes,
 static void btrfs_drop_pages(struct page **pages, size_t num_pages)
 {
 	size_t i;
+
 	for (i = 0; i < num_pages; i++) {
 		/* page checked is some magic around finding pages that
 		 * have been modified without going through btrfs_set_page_dirty
@@ -509,6 +510,7 @@ int btrfs_dirty_pages(struct btrfs_root *root, struct inode *inode,
 
 	for (i = 0; i < num_pages; i++) {
 		struct page *p = pages[i];
+
 		SetPageUptodate(p);
 		ClearPageChecked(p);
 		set_page_dirty(p);
@@ -1421,6 +1423,7 @@ lock_and_cleanup_extent_if_need(struct inode *inode, struct page **pages,
 
 	if (start_pos < inode->i_size) {
 		struct btrfs_ordered_extent *ordered;
+
 		lock_extent_bits(&BTRFS_I(inode)->io_tree,
 				 start_pos, last_pos, cached_state);
 		ordered = btrfs_lookup_ordered_range(inode, start_pos,
@@ -1481,9 +1484,8 @@ static noinline int check_can_nocow(struct inode *inode, loff_t pos,
 		lock_extent(&BTRFS_I(inode)->io_tree, lockstart, lockend);
 		ordered = btrfs_lookup_ordered_range(inode, lockstart,
 						     lockend - lockstart + 1);
-		if (!ordered) {
+		if (!ordered)
 			break;
-		}
 		unlock_extent(&BTRFS_I(inode)->io_tree, lockstart, lockend);
 		btrfs_start_ordered_extent(inode, ordered, 1);
 		btrfs_put_ordered_extent(ordered);
@@ -1495,7 +1497,7 @@ static noinline int check_can_nocow(struct inode *inode, loff_t pos,
 		ret = 0;
 		btrfs_end_write_no_snapshoting(root);
 	} else {
-		*write_bytes = min_t(size_t, *write_bytes ,
+		*write_bytes = min_t(size_t, *write_bytes,
 				     num_bytes - pos + lockstart);
 	}
 
@@ -1727,8 +1729,8 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 			btrfs_delalloc_release_metadata(inode, release_bytes);
 		} else {
 			btrfs_delalloc_release_space(inode,
-						round_down(pos, root->sectorsize),
-						release_bytes);
+					round_down(pos, root->sectorsize),
+					release_bytes);
 		}
 	}
 
@@ -1904,8 +1906,8 @@ int btrfs_release_file(struct inode *inode, struct file *filp)
 	 * application were using truncate to replace a file in place.
 	 */
 	if (test_and_clear_bit(BTRFS_INODE_ORDERED_DATA_CLOSE,
-			       &BTRFS_I(inode)->runtime_flags))
-			filemap_flush(inode->i_mapping);
+		&BTRFS_I(inode)->runtime_flags))
+		filemap_flush(inode->i_mapping);
 	return 0;
 }
 
@@ -1943,8 +1945,9 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	u64 len;
 
 	/*
-	 * The range length can be represented by u64, we have to do the typecasts
-	 * to avoid signed overflow if it's [0, LLONG_MAX] eg. from fsync()
+	 * The range length can be represented by u64, we have to do the
+	 * typecasts to avoid signed overflow if it's [0, LLONG_MAX]
+	 * eg. from fsync()
 	 */
 	len = (u64)end - (u64)start + 1;
 	trace_btrfs_sync_file(file, datasync);
@@ -2409,7 +2412,8 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	/* Check the aligned pages after the first unaligned page,
 	 * if offset != orig_start, which means the first unaligned page
 	 * including several following pages are already in holes,
-	 * the extra check can be skipped */
+	 * the extra check can be skipped
+	 */
 	if (offset == orig_start) {
 		/* after truncate page, check hole again */
 		len = offset + len - lockstart;
-- 
2.1.4

