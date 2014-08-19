Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33017 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbaHSPcj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Aug 2014 11:32:39 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s7JFWcoA013682
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 19 Aug 2014 15:32:39 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by ucsinet22.oracle.com (8.14.5+Sun/8.14.5) with ESMTP id s7JFWbFT014348
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Tue, 19 Aug 2014 15:32:37 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s7JFWbU5009068
	for <linux-btrfs@vger.kernel.org>; Tue, 19 Aug 2014 15:32:37 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: cleanup the same name in end_bio_extent_readpage
Date: Tue, 19 Aug 2014 23:32:22 +0800
Message-Id: <1408462342-2581-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We've defined a 'offset' out of bio_for_each_segment_all.

This is just a clean rename, no function changes.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent_io.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 3af4966..7e27ba7 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2609,12 +2609,12 @@ readpage_ok:
 		if (likely(uptodate)) {
 			loff_t i_size = i_size_read(inode);
 			pgoff_t end_index = i_size >> PAGE_CACHE_SHIFT;
-			unsigned offset;
+			unsigned off;
 
 			/* Zero out the end if this page straddles i_size */
-			offset = i_size & (PAGE_CACHE_SIZE-1);
-			if (page->index == end_index && offset)
-				zero_user_segment(page, offset, PAGE_CACHE_SIZE);
+			off = i_size & (PAGE_CACHE_SIZE-1);
+			if (page->index == end_index && off)
+				zero_user_segment(page, off, PAGE_CACHE_SIZE);
 			SetPageUptodate(page);
 		} else {
 			ClearPageUptodate(page);
-- 
1.8.1.4

