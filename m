Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:50608 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbcBKRtH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Feb 2016 12:49:07 -0500
Received: from localhost
	by e23smtp06.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Fri, 12 Feb 2016 03:49:06 +1000
Received: from d23relay07.au.ibm.com (d23relay07.au.ibm.com [9.190.26.37])
	by d23dlp02.au.ibm.com (Postfix) with ESMTP id EC3AA2BB0057
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Feb 2016 04:49:02 +1100 (EST)
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay07.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u1BHmnEJ45219886
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Feb 2016 04:48:57 +1100
Received: from d23av03.au.ibm.com (localhost [127.0.0.1])
	by d23av03.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u1BHmUfq021160
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Feb 2016 04:48:30 +1100
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, bo.li.liu@oracle.com, dsterba@suse.cz
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org,
        chandan@mykolab.com
Subject: [PATCH V15 03/15] Btrfs: subpage-blocksize: Make sure delalloc range intersects with the locked page's range
Date: Thu, 11 Feb 2016 23:17:41 +0530
Message-Id: <1455212873-14829-4-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1455212873-14829-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1455212873-14829-1-git-send-email-chandan@linux.vnet.ibm.com>
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
index 3228446..da54e49 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1570,6 +1570,7 @@ out:
  * 1 is returned if we find something, 0 if nothing was in the tree
  */
 static noinline u64 find_delalloc_range(struct extent_io_tree *tree,
+					struct page *locked_page,
 					u64 *start, u64 *end, u64 max_bytes,
 					struct extent_state **cached_state)
 {
@@ -1578,6 +1579,9 @@ static noinline u64 find_delalloc_range(struct extent_io_tree *tree,
 	u64 cur_start = *start;
 	u64 found = 0;
 	u64 total_bytes = 0;
+	u64 page_end;
+
+	page_end = page_offset(locked_page) + PAGE_CACHE_SIZE - 1;
 
 	spin_lock(&tree->lock);
 
@@ -1598,7 +1602,8 @@ static noinline u64 find_delalloc_range(struct extent_io_tree *tree,
 			      (state->state & EXTENT_BOUNDARY))) {
 			goto out;
 		}
-		if (!(state->state & EXTENT_DELALLOC)) {
+		if (!(state->state & EXTENT_DELALLOC)
+			|| (page_end < state->start)) {
 			if (!found)
 				*end = state->end;
 			goto out;
@@ -1736,8 +1741,9 @@ again:
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

