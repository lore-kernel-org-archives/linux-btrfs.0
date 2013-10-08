Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:42081 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab3JHRcA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Oct 2013 13:32:00 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 718BD9A03DE
	for <linux-btrfs@vger.kernel.org>; Tue,  8 Oct 2013 11:31:59 -0600 (MDT)
Received: from CAS2.int.fusionio.com (cas2.int.fusionio.com [10.101.1.41]) by mx2.fusionio.com with ESMTP id MywPGVPkQi5bPocB (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 08 Oct 2013 11:31:58 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: limit delalloc pages outside of find_delalloc_range
Date: Tue, 8 Oct 2013 13:31:57 -0400
Message-ID: <1381253517-914-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Liu fixed part of this problem and unfortunately I steered him in slightly the
wrong direction and so didn't completely fix the problem.  The problem is we
limit the size of the delalloc range we are looking for to max bytes and then we
try to lock that range.  If we fail to lock the pages in that range we will
shrink the max bytes to a single page and re loop.  However if our first page is
inside of the delalloc range then we will end up limiting the end of the range
to a period before our first page.  This is illustrated below

[0 -------- delalloc range --------- 256mb]
                                  [page]

So find_delalloc_range will return with delalloc_start as 0 and end as 128mb,
and then we will notice that delalloc_start < *start and adjust it up, but not
adjust delalloc_end up, so things go sideways.  To fix this we need to not limit
the max bytes in find_delalloc_range, but in find_lock_delalloc_range and that
way we don't end up with this confusion.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/extent_io.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index b48942f..2bf6f46 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1491,10 +1491,8 @@ static noinline u64 find_delalloc_range(struct extent_io_tree *tree,
 		cur_start = state->end + 1;
 		node = rb_next(node);
 		total_bytes += state->end - state->start + 1;
-		if (total_bytes >= max_bytes) {
-			*end = *start + max_bytes - 1;
+		if (total_bytes >= max_bytes)
 			break;
-		}
 		if (!node)
 			break;
 	}
@@ -1636,10 +1634,9 @@ again:
 
 	/*
 	 * make sure to limit the number of pages we try to lock down
-	 * if we're looping.
 	 */
-	if (delalloc_end + 1 - delalloc_start > max_bytes && loops)
-		delalloc_end = delalloc_start + PAGE_CACHE_SIZE - 1;
+	if (delalloc_end + 1 - delalloc_start > max_bytes)
+		delalloc_end = delalloc_start + max_bytes - 1;
 
 	/* step two, lock all the pages after the page that has start */
 	ret = lock_delalloc_pages(inode, locked_page,
@@ -1650,8 +1647,7 @@ again:
 		 */
 		free_extent_state(cached_state);
 		if (!loops) {
-			unsigned long offset = (*start) & (PAGE_CACHE_SIZE - 1);
-			max_bytes = PAGE_CACHE_SIZE - offset;
+			max_bytes = PAGE_CACHE_SIZE;
 			loops = 1;
 			goto again;
 		} else {
-- 
1.8.3.1

