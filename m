Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:40500 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab3LKXlB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Dec 2013 18:41:01 -0500
Received: from /spool/local
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <sekharan@us.ibm.com>;
	Wed, 11 Dec 2013 16:41:00 -0700
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 6CAB41FF001A
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Dec 2013 16:40:35 -0700 (MST)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by b03cxnp08025.gho.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id rBBLd3dl6947182
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Dec 2013 22:39:03 +0100
Received: from d03av02.boulder.ibm.com (localhost [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id rBBNevBK031787
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Dec 2013 16:40:58 -0700
From: Chandra Seetharaman <sekharan@us.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 6/7] btrfs: subpagesize-blocksize: Handle relocation clusters appropriately
Date: Wed, 11 Dec 2013 17:38:41 -0600
Message-Id: <1386805122-23972-7-git-send-email-sekharan@us.ibm.com>
In-Reply-To: <1386805122-23972-1-git-send-email-sekharan@us.ibm.com>
References: <1386805122-23972-1-git-send-email-sekharan@us.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For relocation clusters boundaries are at blocks, hence in the case
of subpagesize-blocksize, we need to make sure the data in the page
is handled correctly with the cluster boundary.

This patch does that.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 fs/btrfs/relocation.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index ce459a7..fb5752a 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3149,11 +3149,13 @@ static int relocate_file_extent_cluster(struct inode *inode,
 		set_page_extent_mapped(page);
 
 		if (nr < cluster->nr &&
-		    page_start + offset == cluster->boundary[nr]) {
+		    page_start + offset <= cluster->boundary[nr] &&
+		    page_end + offset >= cluster->boundary[nr]) {
 			set_extent_bits(&BTRFS_I(inode)->io_tree,
 					page_start, page_end,
 					EXTENT_BOUNDARY, GFP_NOFS);
-			nr++;
+			while (page_end + offset < cluster->boundary[nr])
+				nr++;
 		}
 
 		btrfs_set_extent_delalloc(inode, page_start, page_end, NULL);
-- 
1.7.12.4

