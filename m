Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44262 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752853AbcGDEgG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Jul 2016 00:36:06 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u644XiYj083580
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Jul 2016 00:36:05 -0400
Received: from e18.ny.us.ibm.com (e18.ny.us.ibm.com [129.33.205.208])
	by mx0a-001b2d01.pphosted.com with ESMTP id 23x7xe0vat-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 04 Jul 2016 00:36:05 -0400
Received: from localhost
	by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 4 Jul 2016 00:36:04 -0400
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.com
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org
Subject: [PATCH V20 17/19] Btrfs: subpage-blocksize: __btrfs_lookup_bio_sums: Set offset when moving to a new bio_vec
Date: Mon,  4 Jul 2016 10:04:37 +0530
In-Reply-To: <1467606879-14181-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1467606879-14181-1-git-send-email-chandan@linux.vnet.ibm.com>
Message-Id: <1467606879-14181-18-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In __btrfs_lookup_bio_sums() we set the file offset value at the
beginning of every iteration of the while loop. This is incorrect since
the blocks mapped by the current bvec->bv_page might not yet have been
completely processed.

This commit fixes the issue by setting the file offset value when we
move to the next bvec of the bio.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/file-item.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 62a81ee..fb6a7e8 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -222,11 +222,11 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
 	disk_bytenr = (u64)bio->bi_iter.bi_sector << 9;
 	if (dio)
 		offset = logical_offset;
+	else
+		offset = page_offset(bvec->bv_page) + bvec->bv_offset;
 
 	page_bytes_left = bvec->bv_len;
 	while (bio_index < bio->bi_vcnt) {
-		if (!dio)
-			offset = page_offset(bvec->bv_page) + bvec->bv_offset;
 		count = btrfs_find_ordered_sum(inode, offset, disk_bytenr,
 					       (u32 *)csum, nblocks);
 		if (count)
@@ -301,6 +301,9 @@ found:
 					goto done;
 				}
 				bvec++;
+				if (!dio)
+					offset = page_offset(bvec->bv_page)
+						+ bvec->bv_offset;
 				page_bytes_left = bvec->bv_len;
 			}
 
-- 
2.5.5

