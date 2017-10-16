Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55717 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750914AbdJPKn1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Oct 2017 06:43:27 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D3DD9AB0C
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Oct 2017 10:43:25 +0000 (UTC)
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH v2] btrfs: cleanup extent locking sequence
Date: Mon, 16 Oct 2017 05:43:21 -0500
Message-Id: <20171016104321.19182-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

Code cleanup for better understanding:
Variable needs_unlock to be called extent_locked to show state as opposed to
action. Changed the type to int, to reduce code in the critical
path.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

---
Changes since v1:
	fixed using extents_locked vs ret for error checks. Declared
	closer to use.

 fs/btrfs/file.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index f6c6754cf52d..aae589e0915a 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1590,7 +1590,6 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 	int ret = 0;
 	bool only_release_metadata = false;
 	bool force_page_uptodate = false;
-	bool need_unlock;
 
 	nrptrs = min(DIV_ROUND_UP(iov_iter_count(i), PAGE_SIZE),
 			PAGE_SIZE / (sizeof(struct page *)));
@@ -1613,6 +1612,7 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 		size_t copied;
 		size_t dirty_sectors;
 		size_t num_sectors;
+		int extents_locked;
 
 		WARN_ON(num_pages > nrptrs);
 
@@ -1670,7 +1670,6 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 		}
 
 		release_bytes = reserve_bytes;
-		need_unlock = false;
 again:
 		/*
 		 * This is going to setup the pages array with the number of
@@ -1683,16 +1682,15 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 		if (ret)
 			break;
 
-		ret = lock_and_cleanup_extent_if_need(BTRFS_I(inode), pages,
+		extents_locked = lock_and_cleanup_extent_if_need(
+				BTRFS_I(inode), pages,
 				num_pages, pos, write_bytes, &lockstart,
 				&lockend, &cached_state);
-		if (ret < 0) {
-			if (ret == -EAGAIN)
+		if (extents_locked < 0) {
+			if (extents_locked == -EAGAIN)
 				goto again;
+			ret = extents_locked;
 			break;
-		} else if (ret > 0) {
-			need_unlock = true;
-			ret = 0;
 		}
 
 		copied = btrfs_copy_from_user(pos, write_bytes, pages, i);
@@ -1754,7 +1752,7 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 		if (copied > 0)
 			ret = btrfs_dirty_pages(inode, pages, dirty_pages,
 						pos, copied, NULL);
-		if (need_unlock)
+		if (extents_locked)
 			unlock_extent_cached(&BTRFS_I(inode)->io_tree,
 					     lockstart, lockend, &cached_state,
 					     GFP_NOFS);
-- 
2.14.2

