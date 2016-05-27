Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:25705 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756332AbcE0RYV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 May 2016 13:24:21 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.16.0.11/8.16.0.11) with SMTP id u4RHLHbl024914
	for <linux-btrfs@vger.kernel.org>; Fri, 27 May 2016 10:24:20 -0700
Received: from maileast.thefacebook.com ([199.201.65.23])
	by m0089730.ppops.net with ESMTP id 236rfah47h-1
	(version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Fri, 27 May 2016 10:24:20 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>, <kernel-team@fb.com>
Subject: [PATCH] Btrfs: use FLUSH_LIMIT for relocation in reserve_metadata_bytes
Date: Fri, 27 May 2016 13:24:13 -0400
Message-ID: <1464369853-12614-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We used to allow you to set FLUSH_ALL and then just wouldn't do things like
commit transactions or wait on ordered extents if we noticed you were in a
transaction.  However now that all the flushing for FLUSH_ALL is asynchronous
we've lost the ability to tell, and we could end up deadlocking.  So instead use
FLUSH_LIMIT in reserve_metadata_bytes in relocation and then return -EAGAIN if
we error out to preserve the previous behavior.  I've also added an ASSERT() to
catch anybody else who tries to do this.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/extent-tree.c |  2 ++
 fs/btrfs/relocation.c  | 37 ++++++++++++++++++++-----------------
 2 files changed, 22 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 528b9a8..651a811 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5070,6 +5070,8 @@ static int __reserve_metadata_bytes(struct btrfs_root *root,
 	int ret = 0;
 
 	ASSERT(orig_bytes);
+	ASSERT(!current->journal_info || flush != BTRFS_RESERVE_FLUSH_ALL);
+
 	spin_lock(&space_info->lock);
 	ret = -ENOSPC;
 	used = space_info->bytes_used + space_info->bytes_reserved +
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 959cb4e..ca145fc 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2603,25 +2603,28 @@ static int reserve_metadata_space(struct btrfs_trans_handle *trans,
 
 	trans->block_rsv = rc->block_rsv;
 	rc->reserved_bytes += num_bytes;
+
+	/*
+	 * We are under a transaction here so we can only do limited flushing.
+	 * If we get an enospc just kick back -EAGAIN so we know to drop the
+	 * transaction and try to refill when we can flush all the things.
+	 */
 	ret = btrfs_block_rsv_refill(root, rc->block_rsv, num_bytes,
-				BTRFS_RESERVE_FLUSH_ALL);
+				BTRFS_RESERVE_FLUSH_LIMIT);
 	if (ret) {
-		if (ret == -EAGAIN) {
-			tmp = rc->extent_root->nodesize *
-				RELOCATION_RESERVED_NODES;
-			while (tmp <= rc->reserved_bytes)
-				tmp <<= 1;
-			/*
-			 * only one thread can access block_rsv at this point,
-			 * so we don't need hold lock to protect block_rsv.
-			 * we expand more reservation size here to allow enough
-			 * space for relocation and we will return eailer in
-			 * enospc case.
-			 */
-			rc->block_rsv->size = tmp + rc->extent_root->nodesize *
-					      RELOCATION_RESERVED_NODES;
-		}
-		return ret;
+		tmp = rc->extent_root->nodesize * RELOCATION_RESERVED_NODES;
+		while (tmp <= rc->reserved_bytes)
+			tmp <<= 1;
+		/*
+		 * only one thread can access block_rsv at this point,
+		 * so we don't need hold lock to protect block_rsv.
+		 * we expand more reservation size here to allow enough
+		 * space for relocation and we will return eailer in
+		 * enospc case.
+		 */
+		rc->block_rsv->size = tmp + rc->extent_root->nodesize *
+			RELOCATION_RESERVED_NODES;
+		return -EAGAIN;
 	}
 
 	return 0;
-- 
1.8.3.1

