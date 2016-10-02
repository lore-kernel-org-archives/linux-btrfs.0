Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50180 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751802AbcJBN0S (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 2 Oct 2016 09:26:18 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u92DNDVr105683
        for <linux-btrfs@vger.kernel.org>; Sun, 2 Oct 2016 09:26:18 -0400
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152])
        by mx0b-001b2d01.pphosted.com with ESMTP id 25t6s083dw-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Sun, 02 Oct 2016 09:26:17 -0400
Received: from localhost
        by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Sun, 2 Oct 2016 07:26:17 -0600
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.com
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org
Subject: [PATCH V21 18/19] Btrfs: subpage-blocksize: __btrfs_lookup_bio_sums: Set offset when moving to a new bio_vec
Date: Sun,  2 Oct 2016 18:54:27 +0530
In-Reply-To: <1475414668-25954-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1475414668-25954-1-git-send-email-chandan@linux.vnet.ibm.com>
Message-Id: <1475414668-25954-19-git-send-email-chandan@linux.vnet.ibm.com>
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
index d0d571c..8fc09c1 100644
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

