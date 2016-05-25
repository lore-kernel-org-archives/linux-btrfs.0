Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52357 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754875AbcEYOv5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 May 2016 10:51:57 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u4PEpda1014667
	for <linux-btrfs@vger.kernel.org>; Wed, 25 May 2016 07:51:55 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0b-00082601.pphosted.com with ESMTP id 234j8qyw5d-2
	(version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Wed, 25 May 2016 07:51:55 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>, <kernel-team@fb.com>
Subject: [PATCH] Btrfs: change how we calculate the global block rsv
Date: Wed, 25 May 2016 10:51:34 -0400
Message-ID: <1464187894-16902-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Traditionally we've calculated the global block rsv by guessing how much of the
metadata used amount was the extent tree, and then taking the data size and
figuring out how large the csum tree would have to be to hold that much data.

This is imprecise and falls down on MIXED file systems as we can't trust the
data used amount.  This resulted in failures for xfstests generic/333 because it
creates lots of clones, which explodes out the extent tree.  Our global reserve
calculations were woefully inaccurate in this case which meant we got into a
situation where we did not have enough reserved to do our work.

We know we only use the global block rsv for the extent, csum, and root trees,
so just get the bytes used for these trees and use that as the basis of our
global reserve.  Since these are not reference counted trees the bytes_used
value will be accurate.  This fixed the transaction aborts seen with
generic/333.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/extent-tree.c | 43 +++++++------------------------------------
 1 file changed, 7 insertions(+), 36 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 1213a59..fd11cd0 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5550,48 +5550,19 @@ void btrfs_block_rsv_release(struct btrfs_root *root,
 				num_bytes);
 }
 
-/*
- * helper to calculate size of global block reservation.
- * the desired value is sum of space used by extent tree,
- * checksum tree and root tree
- */
-static u64 calc_global_metadata_size(struct btrfs_fs_info *fs_info)
-{
-	struct btrfs_space_info *sinfo;
-	u64 num_bytes;
-	u64 meta_used;
-	u64 data_used;
-	int csum_size = btrfs_super_csum_size(fs_info->super_copy);
-
-	sinfo = __find_space_info(fs_info, BTRFS_BLOCK_GROUP_DATA);
-	spin_lock(&sinfo->lock);
-	data_used = sinfo->bytes_used;
-	spin_unlock(&sinfo->lock);
-
-	sinfo = __find_space_info(fs_info, BTRFS_BLOCK_GROUP_METADATA);
-	spin_lock(&sinfo->lock);
-	if (sinfo->flags & BTRFS_BLOCK_GROUP_DATA)
-		data_used = 0;
-	meta_used = sinfo->bytes_used;
-	spin_unlock(&sinfo->lock);
-
-	num_bytes = (data_used >> fs_info->sb->s_blocksize_bits) *
-		    csum_size * 2;
-	num_bytes += div_u64(data_used + meta_used, 50);
-
-	if (num_bytes * 3 > meta_used)
-		num_bytes = div_u64(meta_used, 3);
-
-	return ALIGN(num_bytes, fs_info->extent_root->nodesize << 10);
-}
-
 static void update_global_block_rsv(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_block_rsv *block_rsv = &fs_info->global_block_rsv;
 	struct btrfs_space_info *sinfo = block_rsv->space_info;
 	u64 num_bytes;
 
-	num_bytes = calc_global_metadata_size(fs_info);
+	/*
+	 * The global block rsv is based on the size of the extent tree, the
+	 * checksum tree and the root tree.
+	 */
+	num_bytes = btrfs_root_used(&fs_info->extent_root->root_item) +
+		btrfs_root_used(&fs_info->csum_root->root_item) +
+		btrfs_root_used(&fs_info->tree_root->root_item);
 
 	spin_lock(&sinfo->lock);
 	spin_lock(&block_rsv->lock);
-- 
1.8.3.1

