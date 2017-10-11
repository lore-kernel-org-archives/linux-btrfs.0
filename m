Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40036 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752099AbdJKC0z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Oct 2017 22:26:55 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B9632AAAD
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Oct 2017 02:26:53 +0000 (UTC)
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH] btrfs: cleanup extent locking sequence
Date: Tue, 10 Oct 2017 21:26:41 -0500
Message-Id: <20171011022641.21202-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

Code cleanup for better understanding:
needs_unlock to be called extent_locked to show state as opposed to
action.
Changed the variable to int, to reduce code in the critical path(code usually
executed).

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/btrfs/file.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index f6c6754cf52d..a3d006d14683 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1590,7 +1590,7 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 	int ret = 0;
 	bool only_release_metadata = false;
 	bool force_page_uptodate = false;
-	bool need_unlock;
+	int extents_locked;
 
 	nrptrs = min(DIV_ROUND_UP(iov_iter_count(i), PAGE_SIZE),
 			PAGE_SIZE / (sizeof(struct page *)));
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
+		if (extents_locked < 0) {
 			if (ret == -EAGAIN)
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

