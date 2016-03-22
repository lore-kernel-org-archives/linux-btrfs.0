Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:47035 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758096AbcCVBim (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 21:38:42 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v8 19/27] btrfs: try more times to alloc metadata reserve space
Date: Tue, 22 Mar 2016 09:35:44 +0800
Message-Id: <1458610552-9845-20-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1458610552-9845-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1458610552-9845-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

In btrfs_delalloc_reserve_metadata(), the number of metadata bytes we try
to reserve is calculated by the difference between outstanding_extents and
reserved_extents.

When reserve_metadata_bytes() fails to reserve desited metadata space,
it has already done some reclaim work, such as write ordered extents.

In that case, outstanding_extents and reserved_extents may already
changed, and we may reserve enough metadata space then.

So this patch will try to call reserve_metadata_bytes() at most 3 times
to ensure we really run out of space.

Such false ENOSPC is mainly caused by small file extents and time
consuming delalloc functions, which mainly affects in-band
de-duplication. (Compress should also be affected, but LZO/zlib is
faster than SHA256, so still harder to trigger than dedupe).

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index dabd721..016d2ec 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2421,7 +2421,7 @@ static int run_one_delayed_ref(struct btrfs_trans_handle *trans,
 				 * a new extent is revered, then deleted
 				 * in one tran, and inc/dec get merged to 0.
 				 *
-				 * In this case, we need to remove its dedup
+				 * In this case, we need to remove its dedupe
 				 * hash.
 				 */
 				btrfs_dedupe_del(trans, fs_info, node->bytenr);
@@ -5675,6 +5675,7 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 	bool delalloc_lock = true;
 	u64 to_free = 0;
 	unsigned dropped;
+	int loops = 0;
 
 	/* If we are a free space inode we need to not flush since we will be in
 	 * the middle of a transaction commit.  We also don't need the delalloc
@@ -5690,11 +5691,12 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 	    btrfs_transaction_in_commit(root->fs_info))
 		schedule_timeout(1);
 
+	num_bytes = ALIGN(num_bytes, root->sectorsize);
+
+again:
 	if (delalloc_lock)
 		mutex_lock(&BTRFS_I(inode)->delalloc_mutex);
 
-	num_bytes = ALIGN(num_bytes, root->sectorsize);
-
 	spin_lock(&BTRFS_I(inode)->lock);
 	nr_extents = (unsigned)div64_u64(num_bytes +
 					 BTRFS_MAX_EXTENT_SIZE - 1,
@@ -5815,6 +5817,23 @@ out_fail:
 	}
 	if (delalloc_lock)
 		mutex_unlock(&BTRFS_I(inode)->delalloc_mutex);
+	/*
+	 * The number of metadata bytes is calculated by the difference
+	 * between outstanding_extents and reserved_extents. Sometimes though
+	 * reserve_metadata_bytes() fails to reserve the wanted metadata bytes,
+	 * indeed it has already done some work to reclaim metadata space, hence
+	 * both outstanding_extents and reserved_extents would have changed and
+	 * the bytes we try to reserve would also has changed(may be smaller).
+	 * So here we try to reserve again. This is much useful for online
+	 * dedupe, which will easily eat almost all meta space.
+	 *
+	 * XXX: Indeed here 3 is arbitrarily choosed, it's a good workaround for
+	 * online dedupe, later we should find a better method to avoid dedupe
+	 * enospc issue.
+	 */
+	if (unlikely(ret == -ENOSPC && loops++ < 3))
+		goto again;
+
 	return ret;
 }
 
-- 
2.7.3



