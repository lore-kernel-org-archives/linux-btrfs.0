Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17658 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486Ab3L3INb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Dec 2013 03:13:31 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Marcel Ritter <ritter.marcel@gmail.com>,
        Christian Robert <christian.robert@polymtl.ca>,
        "alanqk@gmail.com" <alanqk@gmail.com>
Subject: [PATCH v8 13/14] Btrfs: fix dedupe 'ENOSPC' problem
Date: Mon, 30 Dec 2013 16:12:53 +0800
Message-Id: <1388391175-29539-14-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1388391175-29539-1-git-send-email-bo.li.liu@oracle.com>
References: <1388391175-29539-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With dedupe, writes are likely to produce metadata but no data, which means
producing more delayed_refs, and this can ends up aborting a transaction
because it needs to allocate enough free space from global_rsv to turn
delayed_refs into real extent tree's nodes/leaves and global_rsv is used up.

So we must take the worst case for throttling delayed refs in this dedup case,
ie, allocating one leaf on each delayed ref head update.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent-tree.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index f14db92..df3a645 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2661,6 +2661,19 @@ static inline u64 heads_to_leaves(struct btrfs_root *root, u64 heads)
 {
 	u64 num_bytes;
 
+	/*
+	 * For deduplication it's a special case where we must be very careful
+	 * on throttling the number of delayed_refs, just because with dedupe,
+	 * we're likely to produce _only_ metadata but no data, which results in
+	 * quite a lot of delayed_refs, and consequently global_rsv may be used
+	 * up and we get a RO btrfs.
+	 *
+	 * So we have to take the worst case -- one leaf for updating a ref head
+	 * and its related refs.
+	 */
+	if (root->fs_info->dedup_bs != 0)
+		return heads;
+
 	num_bytes = heads * (sizeof(struct btrfs_extent_item) +
 			     sizeof(struct btrfs_extent_inline_ref));
 	if (!btrfs_fs_incompat(root->fs_info, SKINNY_METADATA))
-- 
1.8.2.1

