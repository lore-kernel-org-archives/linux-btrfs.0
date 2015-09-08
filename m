Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:47953 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752104AbbIIFF2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Sep 2015 01:05:28 -0400
Received: from localhost.localdomain (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t888dQvI019126
	for <linux-btrfs@vger.kernel.org>; Tue, 8 Sep 2015 16:39:52 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 19/19] btrfs: qgroup: Add handler for NOCOW and inline
Date: Tue,  8 Sep 2015 16:37:36 +0800
Message-Id: <1441701456-8034-20-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1441701456-8034-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1441701456-8034-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For NOCOW and inline case, there will be no delayed_ref created for
them, so we should free their reserved data space at proper
time(finish_ordered_io for NOCOW and cow_file_inline for inline).

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c |  7 ++++++-
 fs/btrfs/inode.c       | 15 +++++++++++++++
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index ab1b1a1..ca15bd3 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4055,7 +4055,12 @@ int btrfs_check_data_free_space(struct inode *inode, u64 start, u64 len)
 	if (ret < 0)
 		return ret;
 
-	/* Use new btrfs_qgroup_reserve_data to reserve precious data space */
+	/*
+	 * Use new btrfs_qgroup_reserve_data to reserve precious data space
+	 *
+	 * TODO: Find a good method to avoid reserve data space for NOCOW
+	 * range, but don't impact performance on quota disable case.
+	 */
 	ret = btrfs_qgroup_reserve_data(inode, start, len);
 	return ret;
 }
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 8c09197..9b783e6 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -310,6 +310,13 @@ static noinline int cow_file_range_inline(struct btrfs_root *root,
 	btrfs_delalloc_release_metadata(inode, end + 1 - start);
 	btrfs_drop_extent_cache(inode, start, aligned_end - 1, 0);
 out:
+	/*
+	 * Don't forget to free the reserved space, as for inlined extent
+	 * it won't count as data extent, free them directly here.
+	 * And at reserve time, it's always aligned to page size, so
+	 * just free one page here.
+	 */
+	btrfs_qgroup_free_data(inode, 0, PAGE_CACHE_SIZE);
 	btrfs_free_path(path);
 	btrfs_end_transaction(trans, root);
 	return ret;
@@ -2831,6 +2838,14 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 
 	if (test_bit(BTRFS_ORDERED_NOCOW, &ordered_extent->flags)) {
 		BUG_ON(!list_empty(&ordered_extent->list)); /* Logic error */
+
+		/*
+		 * For mwrite(mmap + memset to write) case, we still reserve
+		 * space for NOCOW range.
+		 * As NOCOW won't cause a new delayed ref, just free the space
+		 */
+		btrfs_qgroup_free_data(inode, ordered_extent->file_offset,
+				       ordered_extent->len);
 		btrfs_ordered_update_i_size(inode, 0, ordered_extent);
 		if (nolock)
 			trans = btrfs_join_transaction_nolock(root);
-- 
2.5.1

