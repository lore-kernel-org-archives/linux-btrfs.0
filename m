Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38534 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753925AbcCYR0K (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Mar 2016 13:26:10 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u2PHLi7H019882
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Mar 2016 10:26:09 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0a-00082601.pphosted.com with ESMTP id 21vv9h2976-1
	(version=TLSv1 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Mar 2016 10:26:09 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 03/14] Btrfs: always reserve metadata for delalloc extents
Date: Fri, 25 Mar 2016 13:25:49 -0400
Message-ID: <1458926760-17563-4-git-send-email-jbacik@fb.com>
In-Reply-To: <1458926760-17563-1-git-send-email-jbacik@fb.com>
References: <1458926760-17563-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are a few races in the metadata reservation stuff.  First we add the bytes
to the block_rsv well after we've set the bit on the inode saying that we have
space for it and after we've reserved the bytes.  So use the normal
btrfs_block_rsv_add helper for this case.  Secondly we can flush delalloc
extents when we try to reserve space for our write, which means that we could
have used up the space for the inode and we wouldn't know because we only check
before the reservation.  So instead make sure we are always reserving space for
the inode update, and then if we don't need it release those bytes afterward.
Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/extent-tree.c | 35 +++++++++++++----------------------
 1 file changed, 13 insertions(+), 22 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 06f4e7b..157a0b6 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5653,12 +5653,12 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 	u64 to_reserve = 0;
 	u64 csum_bytes;
 	unsigned nr_extents = 0;
-	int extra_reserve = 0;
 	enum btrfs_reserve_flush_enum flush = BTRFS_RESERVE_FLUSH_ALL;
 	int ret = 0;
 	bool delalloc_lock = true;
 	u64 to_free = 0;
 	unsigned dropped;
+	bool release_extra = false;
 
 	/* If we are a free space inode we need to not flush since we will be in
 	 * the middle of a transaction commit.  We also don't need the delalloc
@@ -5684,24 +5684,15 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 					 BTRFS_MAX_EXTENT_SIZE - 1,
 					 BTRFS_MAX_EXTENT_SIZE);
 	BTRFS_I(inode)->outstanding_extents += nr_extents;
-	nr_extents = 0;
 
+	nr_extents = 0;
 	if (BTRFS_I(inode)->outstanding_extents >
 	    BTRFS_I(inode)->reserved_extents)
-		nr_extents = BTRFS_I(inode)->outstanding_extents -
+		nr_extents += BTRFS_I(inode)->outstanding_extents -
 			BTRFS_I(inode)->reserved_extents;
 
-	/*
-	 * Add an item to reserve for updating the inode when we complete the
-	 * delalloc io.
-	 */
-	if (!test_bit(BTRFS_INODE_DELALLOC_META_RESERVED,
-		      &BTRFS_I(inode)->runtime_flags)) {
-		nr_extents++;
-		extra_reserve = 1;
-	}
-
-	to_reserve = btrfs_calc_trans_metadata_size(root, nr_extents);
+	/* We always want to reserve a slot for updating the inode. */
+	to_reserve = btrfs_calc_trans_metadata_size(root, nr_extents + 1);
 	to_reserve += calc_csum_metadata_size(inode, num_bytes, 1);
 	csum_bytes = BTRFS_I(inode)->csum_bytes;
 	spin_unlock(&BTRFS_I(inode)->lock);
@@ -5713,18 +5704,16 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 			goto out_fail;
 	}
 
-	ret = reserve_metadata_bytes(root, block_rsv, to_reserve, flush);
+	ret = btrfs_block_rsv_add(root, block_rsv, to_reserve, flush);
 	if (unlikely(ret)) {
 		btrfs_qgroup_free_meta(root, nr_extents * root->nodesize);
 		goto out_fail;
 	}
 
 	spin_lock(&BTRFS_I(inode)->lock);
-	if (extra_reserve) {
-		set_bit(BTRFS_INODE_DELALLOC_META_RESERVED,
-			&BTRFS_I(inode)->runtime_flags);
-		nr_extents--;
-	}
+	if (test_and_set_bit(BTRFS_INODE_DELALLOC_META_RESERVED,
+			     &BTRFS_I(inode)->runtime_flags))
+		release_extra = true;
 	BTRFS_I(inode)->reserved_extents += nr_extents;
 	spin_unlock(&BTRFS_I(inode)->lock);
 
@@ -5734,8 +5723,10 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 	if (to_reserve)
 		trace_btrfs_space_reservation(root->fs_info, "delalloc",
 					      btrfs_ino(inode), to_reserve, 1);
-	block_rsv_add_bytes(block_rsv, to_reserve, 1);
-
+	if (release_extra)
+		btrfs_block_rsv_release(root, block_rsv,
+					btrfs_calc_trans_metadata_size(root,
+								       1));
 	return 0;
 
 out_fail:
-- 
2.5.0

