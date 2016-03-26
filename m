Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40587 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbcCZCBi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Mar 2016 22:01:38 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id u2Q21bZT003242
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sat, 26 Mar 2016 02:01:37 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
	by aserv0021.oracle.com (8.13.8/8.13.8) with ESMTP id u2Q21aon007046
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sat, 26 Mar 2016 02:01:37 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
	by aserv0121.oracle.com (8.13.8/8.13.8) with ESMTP id u2Q21aAi018083
	for <linux-btrfs@vger.kernel.org>; Sat, 26 Mar 2016 02:01:36 GMT
From: Ashish Samant <ashish.samant@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: Cleanup compress_file_range()
Date: Fri, 25 Mar 2016 19:01:33 -0700
Message-Id: <1458957693-1347-1-git-send-email-ashish.samant@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Remove unnecessary checks in compress_file_range().

Signed-off-by: Ashish Samant <ashish.samant@oracle.com>
---
 fs/btrfs/inode.c | 79 +++++++++++++++++++++++++++-----------------------------
 1 file changed, 38 insertions(+), 41 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 41a5688..a528ce7 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -581,13 +581,30 @@ cont:
 		 * win, compare the page count read with the blocks on disk
 		 */
 		total_in = ALIGN(total_in, PAGE_CACHE_SIZE);
-		if (total_compressed >= total_in) {
+		if (total_compressed >= total_in)
 			will_compress = 0;
-		} else {
+		else {
 			num_bytes = total_in;
+			*num_added += 1;
+
+			/* the async work queues will take care of doing actual
+			 * allocation on disk for these compressed pages,
+			 * and will submit them to the elevator.
+			 */
+			add_async_extent(async_cow, start, num_bytes,
+					total_compressed, pages, nr_pages_ret,
+					compress_type);
+
+			if (start + num_bytes < end) {
+				start += num_bytes;
+				pages = NULL;
+				cond_resched();
+				goto again;
+			}
+			return;
 		}
 	}
-	if (!will_compress && pages) {
+	if (pages) {
 		/*
 		 * the compression code ran but failed to make things smaller,
 		 * free any pages it allocated and our page pointer array
@@ -603,47 +620,27 @@ cont:
 
 		/* flag the file so we don't compress in the future */
 		if (!btrfs_test_opt(root, FORCE_COMPRESS) &&
-		    !(BTRFS_I(inode)->force_compress)) {
+		    !(BTRFS_I(inode)->force_compress))
 			BTRFS_I(inode)->flags |= BTRFS_INODE_NOCOMPRESS;
-		}
 	}
-	if (will_compress) {
-		*num_added += 1;
-
-		/* the async work queues will take care of doing actual
-		 * allocation on disk for these compressed pages,
-		 * and will submit them to the elevator.
-		 */
-		add_async_extent(async_cow, start, num_bytes,
-				 total_compressed, pages, nr_pages_ret,
-				 compress_type);
-
-		if (start + num_bytes < end) {
-			start += num_bytes;
-			pages = NULL;
-			cond_resched();
-			goto again;
-		}
-	} else {
 cleanup_and_bail_uncompressed:
-		/*
-		 * No compression, but we still need to write the pages in
-		 * the file we've been given so far.  redirty the locked
-		 * page if it corresponds to our extent and set things up
-		 * for the async work queue to run cow_file_range to do
-		 * the normal delalloc dance
-		 */
-		if (page_offset(locked_page) >= start &&
-		    page_offset(locked_page) <= end) {
-			__set_page_dirty_nobuffers(locked_page);
-			/* unlocked later on in the async handlers */
-		}
-		if (redirty)
-			extent_range_redirty_for_io(inode, start, end);
-		add_async_extent(async_cow, start, end - start + 1,
-				 0, NULL, 0, BTRFS_COMPRESS_NONE);
-		*num_added += 1;
-	}
+	/*
+	 * No compression, but we still need to write the pages in
+	 * the file we've been given so far.  redirty the locked
+	 * page if it corresponds to our extent and set things up
+	 * for the async work queue to run cow_file_range to do
+	 * the normal delalloc dance
+	 */
+	if (page_offset(locked_page) >= start &&
+	    page_offset(locked_page) <= end)
+		__set_page_dirty_nobuffers(locked_page);
+		/* unlocked later on in the async handlers */
+
+	if (redirty)
+		extent_range_redirty_for_io(inode, start, end);
+	add_async_extent(async_cow, start, end - start + 1, 0, NULL, 0,
+			 BTRFS_COMPRESS_NONE);
+	*num_added += 1;
 
 	return;
 
-- 
1.9.1

