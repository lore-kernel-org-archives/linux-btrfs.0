Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp08.in.ibm.com ([125.16.236.8]:38221 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810AbcDNNjS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Apr 2016 09:39:18 -0400
Received: from localhost
	by e28smtp08.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Thu, 14 Apr 2016 19:09:15 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay05.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u3EDdU9W4981022
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Apr 2016 19:09:31 +0530
Received: from d28av01.in.ibm.com (localhost [127.0.0.1])
	by d28av01.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u3EJ7FSn011176
	for <linux-btrfs@vger.kernel.org>; Fri, 15 Apr 2016 00:37:18 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, dsterba@suse.cz, clm@fb.com,
        jbacik@fb.com, chandan@mykolab.com, aneesh.kumar@linux.vnet.ibm.com
Subject: [PATCH V17 18/18] Btrfs: subpage-blocksize: __btrfs_lookup_bio_sums: Set offset when moving to a new bio_vec
Date: Thu, 14 Apr 2016 19:08:27 +0530
Message-Id: <1460641107-13834-19-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1460641107-13834-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1460641107-13834-1-git-send-email-chandan@linux.vnet.ibm.com>
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
index 7a7d6e2..472b069 100644
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
2.1.0

