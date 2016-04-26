Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp04.in.ibm.com ([125.16.236.4]:44299 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbcDZN2I (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Apr 2016 09:28:08 -0400
Received: from localhost
	by e28smtp04.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Tue, 26 Apr 2016 18:58:05 +0530
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay10.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u3QDS2BA24772816
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Apr 2016 18:58:02 +0530
Received: from d28av02.in.ibm.com (localhost [127.0.0.1])
	by d28av02.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u3QDS0q6009670
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Apr 2016 18:58:02 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, dsterba@suse.cz, clm@fb.com,
        jbacik@fb.com, chandan@mykolab.com
Subject: [PATCH V18 03/18] Btrfs: subpage-blocksize: Make sure delalloc range intersects with the locked page's range
Date: Tue, 26 Apr 2016 18:57:02 +0530
Message-Id: <1461677237-7703-4-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1461677237-7703-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1461677237-7703-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

find_delalloc_range indirectly depends on EXTENT_UPTODDATE to make sure that
the delalloc range returned intersects with the file range mapped by the
page. Since we now track "uptodate" state in a per-page
bitmap (i.e. in btrfs_page_private->bstate), this commit makes an explicit
check to make sure that the delalloc range starts from within the file range
mapped by the page.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/extent_io.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 9b6c8e0..790ad09 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1568,6 +1568,7 @@ out:
  * 1 is returned if we find something, 0 if nothing was in the tree
  */
 static noinline u64 find_delalloc_range(struct extent_io_tree *tree,
+					struct page *locked_page,
 					u64 *start, u64 *end, u64 max_bytes,
 					struct extent_state **cached_state)
 {
@@ -1576,6 +1577,9 @@ static noinline u64 find_delalloc_range(struct extent_io_tree *tree,
 	u64 cur_start = *start;
 	u64 found = 0;
 	u64 total_bytes = 0;
+	u64 page_end;
+
+	page_end = page_offset(locked_page) + PAGE_SIZE - 1;
 
 	spin_lock(&tree->lock);
 
@@ -1596,7 +1600,8 @@ static noinline u64 find_delalloc_range(struct extent_io_tree *tree,
 			      (state->state & EXTENT_BOUNDARY))) {
 			goto out;
 		}
-		if (!(state->state & EXTENT_DELALLOC)) {
+		if (!(state->state & EXTENT_DELALLOC)
+			|| (page_end < state->start)) {
 			if (!found)
 				*end = state->end;
 			goto out;
@@ -1734,8 +1739,9 @@ again:
 	/* step one, find a bunch of delalloc bytes starting at start */
 	delalloc_start = *start;
 	delalloc_end = 0;
-	found = find_delalloc_range(tree, &delalloc_start, &delalloc_end,
-				    max_bytes, &cached_state);
+	found = find_delalloc_range(tree, locked_page,
+				&delalloc_start, &delalloc_end,
+				max_bytes, &cached_state);
 	if (!found || delalloc_end <= *start) {
 		*start = delalloc_start;
 		*end = delalloc_end;
-- 
2.1.0

