Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45856 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751683AbcGDEfQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Jul 2016 00:35:16 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u644XdWf017528
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Jul 2016 00:35:15 -0400
Received: from e19.ny.us.ibm.com (e19.ny.us.ibm.com [129.33.205.209])
	by mx0a-001b2d01.pphosted.com with ESMTP id 23x9mcenq2-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 04 Jul 2016 00:35:15 -0400
Received: from localhost
	by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 4 Jul 2016 00:35:15 -0400
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.com
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org
Subject: [PATCH V20 03/19] Btrfs: subpage-blocksize: Make sure delalloc range intersects with the locked page's range
Date: Mon,  4 Jul 2016 10:04:23 +0530
In-Reply-To: <1467606879-14181-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1467606879-14181-1-git-send-email-chandan@linux.vnet.ibm.com>
Message-Id: <1467606879-14181-4-git-send-email-chandan@linux.vnet.ibm.com>
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
index 0adbff5..f7d035b 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1581,6 +1581,7 @@ out:
  * 1 is returned if we find something, 0 if nothing was in the tree
  */
 static noinline u64 find_delalloc_range(struct extent_io_tree *tree,
+					struct page *locked_page,
 					u64 *start, u64 *end, u64 max_bytes,
 					struct extent_state **cached_state)
 {
@@ -1589,6 +1590,9 @@ static noinline u64 find_delalloc_range(struct extent_io_tree *tree,
 	u64 cur_start = *start;
 	u64 found = 0;
 	u64 total_bytes = 0;
+	u64 page_end;
+
+	page_end = page_offset(locked_page) + PAGE_SIZE - 1;
 
 	spin_lock(&tree->lock);
 
@@ -1609,7 +1613,8 @@ static noinline u64 find_delalloc_range(struct extent_io_tree *tree,
 			      (state->state & EXTENT_BOUNDARY))) {
 			goto out;
 		}
-		if (!(state->state & EXTENT_DELALLOC)) {
+		if (!(state->state & EXTENT_DELALLOC)
+			|| (page_end < state->start)) {
 			if (!found)
 				*end = state->end;
 			goto out;
@@ -1747,8 +1752,9 @@ again:
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
2.5.5

