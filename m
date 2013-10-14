Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24424 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab3JNFBW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Oct 2013 01:01:22 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r9E51LSm006567
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Oct 2013 05:01:21 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r9E51K4O016726
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Oct 2013 05:01:20 GMT
Received: from abhmt102.oracle.com (abhmt102.oracle.com [141.146.116.54])
	by userz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r9E51J9A007334
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Oct 2013 05:01:20 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v7 12/13] Btrfs: fix a crash of dedup ref
Date: Mon, 14 Oct 2013 12:59:54 +0800
Message-Id: <1381726796-27191-13-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1381726796-27191-1-git-send-email-bo.li.liu@oracle.com>
References: <1381726796-27191-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The dedup reference is a special kind of delayed refs, and the delayed refs
are batched to be processed later.

If we find a matched dedup extent, then we queue an ADD delayed ref on it during
endio work, but there is already a DROP delayed ref queued there,

   t1                             t2                          t3
->writepage                                             commit transaction
  ->run_delalloc_dedup
     find_dedup
------------------------------------------------------------------------------
                                                           process_delayed refs
     add ordered extent
     submit pages
                              finish ordered io
                                insert file extents
                                queue delayed refs
                                queue dedup ref

This senario ends up with a crash because we're going to insert a ref on
a deleted extent.

To avoid the race, we need to wait for processing delayed refs before finding
matched dedup extents.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/file-item.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index ddb489e..8933e13 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -893,6 +893,8 @@ btrfs_find_dedup_extent(struct btrfs_root *root, struct btrfs_dedup_hash *hash)
 	struct extent_buffer *leaf;
 	struct btrfs_root *dedup_root;
 	struct btrfs_dedup_item *item;
+	struct btrfs_delayed_ref_root *delayed_refs;
+	struct btrfs_trans_handle *trans;
 	u64 hash_value;
 	u64 length;
 	u64 dedup_size;
@@ -911,6 +913,24 @@ btrfs_find_dedup_extent(struct btrfs_root *root, struct btrfs_dedup_hash *hash)
 	}
 	dedup_root = root->fs_info->dedup_root;
 
+	/*
+	 * This is for serializing the dedup reference add/remove,
+	 * the dedup reference is one of delayed refs, so it's likely
+	 * we find the dedup extent here but there is already a DROP ref
+	 * on it, and this ends up that we insert a ref on a deleted
+	 * extent and get crash.
+	 * Therefore, before finding matched dedup extents, we should
+	 * wait for delayed_ref running's finish.
+	 */
+	trans = btrfs_join_transaction(root);
+	if (!IS_ERR(trans)) {
+		delayed_refs = &trans->transaction->delayed_refs;
+		if (delayed_refs && atomic_read(&delayed_refs->procs_running_refs))
+			wait_event(delayed_refs->wait,
+				atomic_read(&delayed_refs->procs_running_refs) == 0);
+		btrfs_end_transaction(trans, root);
+	}
+
 	path = btrfs_alloc_path();
 	if (!path)
 		return 0;
-- 
1.7.7

