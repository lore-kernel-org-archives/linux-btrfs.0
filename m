Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:42047 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755200AbbDGPLN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 7 Apr 2015 11:11:13 -0400
Received: from pps.filterd (m0004003 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id t37F9NWn005785
	for <linux-btrfs@vger.kernel.org>; Tue, 7 Apr 2015 08:11:02 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0b-00082601.pphosted.com with ESMTP id 1tmh8mr424-19
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Tue, 07 Apr 2015 08:11:02 -0700
Date: Tue, 7 Apr 2015 11:09:42 -0400
From: Chris Mason <clm@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix use after free when close_ctree frees the
 orphan_rsv
Message-ID: <20150407150926.GA10738@ret.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Near the end of close_ctree, we're calling btrfs_free_block_rsv
to free up the orphan rsv.  The problem is this call updates the
space_info, which has already been freed.

This adds a new __ function that directly calls kfree instead of trying
to update the space infos.

Signed-off-by: Chris Mason <clm@fb.com>
---
 fs/btrfs/ctree.h   | 1 +
 fs/btrfs/disk-io.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index e1800d4..21032ed 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3488,6 +3488,7 @@ struct btrfs_block_rsv *btrfs_alloc_block_rsv(struct btrfs_root *root,
 					      unsigned short type);
 void btrfs_free_block_rsv(struct btrfs_root *root,
 			  struct btrfs_block_rsv *rsv);
+void __btrfs_free_block_rsv(struct btrfs_block_rsv *rsv);
 int btrfs_block_rsv_add(struct btrfs_root *root,
 			struct btrfs_block_rsv *block_rsv, u64 num_bytes,
 			enum btrfs_reserve_flush_enum flush);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index bb589b5..a123626 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3746,7 +3746,7 @@ void close_ctree(struct btrfs_root *root)
 
 	btrfs_free_stripe_hash_table(fs_info);
 
-	btrfs_free_block_rsv(root, root->orphan_block_rsv);
+	__btrfs_free_block_rsv(root->orphan_block_rsv);
 	root->orphan_block_rsv = NULL;
 
 	lock_chunks(root);
-- 
1.8.1

