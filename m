Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF60412C07
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Jul 2026 11:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784203047; cv=none; b=hnii4y0VUJTnONaAsQchxhMP/BYtk5H7HzMuBA8/R+OxMD/6Uj45tMMgZEw8oXRN61toqombWUgynpA0azOMfVs+0Ton7vwLIkZntp8Bx92N16Ek/bN11rfSXyiRdr3MxRY427zPiyuiMQHBiPVGJFZl+tEXHtvDoqBjeRBX8i4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784203047; c=relaxed/simple;
	bh=1Jumv+mpK0EOE59bmBaUeqJapx6yg7agO+pAUTBg2FE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jZkwgmxERp/3GvMtKeJd+iGnYPH8/+C/wwKmAtJAO9U0PSiVEFuL+/H5xTV59q7RdFqg4Mn0Wp+oJ8wytSEJNPZtzK83qPNXnEmRqH6kZTmjPOjAYcKZbWXx20gueMBFGW5T3xQYL/jroLmfFi+Fo7lkiz2gEzwttf4B/l6nsog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=NwtswvjE; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="NwtswvjE"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1784203044; x=1815739044;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1Jumv+mpK0EOE59bmBaUeqJapx6yg7agO+pAUTBg2FE=;
  b=NwtswvjEPz/d+M7+g2EwH8TXWPIDGhCiZzEIpht7nYiJ2TF/HtOv2OEt
   kJY8i2x4Mi+wjMF7UYomy1NFqvjAHL1TyOVrjXj00//EniMv5ecI5HwBW
   dZLuELWC3pecomMwnk53nTQqokCrK9cJhdFqrHPo1v9XBiEYIv9Xg+A2W
   +J3yHf99PzbcUMZ0BCdiSDFM2gz/gb1AvebWeg+pS8I2Y8Gu91XasxaDm
   IyBsteQZqEpqMNLnGcPjj7eYB3hS+aVwiPP3QLSg0S73FSZUrqixENxMp
   LtnQ6xJYXcPJztN8Bq2AQ6AR7wC/YVIgXchmo1TLB0JRrAMdWm30kMc01
   w==;
X-CSE-ConnectionGUID: V4oTLy/HQfy5JAUFsCXsrQ==
X-CSE-MsgGUID: 55MUFdhuSHKpPScDq+NnXw==
X-IronPort-AV: E=Sophos;i="6.25,167,1779120000"; 
   d="scan'208";a="150860087"
Received: from unknown (HELO uls-op-esad3-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 16 Jul 2026 19:57:14 +0800
X-CSE-ConnectionGUID: 4t2pfiEDR2+7I50xhSdU4g==
X-CSE-MsgGUID: FPXPmfq7SH6qAoTO6TpEZg==
IronPort-SDR: 6a58c716_RAvC2M65BIpCET0evY3NJNxwhqZOeO4oRz7UwhjAgGWmNEQ
 H+HPJgQJXiaW2MFHtVwbOSGhJg1g21VsNTacSMw==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad3-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 16 Jul 2026 04:57:10 -0700
X-CSE-ConnectionGUID: nT2iSwagQPiELHzFPDOHBA==
X-CSE-MsgGUID: 1bvqhffdRZWw0/nowfrglA==
WDCIronportException: Internal
Received: from wdap-fln31fg1cp.ad.shared (HELO neo.wdc.com) ([10.224.28.153])
  by uls-op-esai1-o.wdc.com with ESMTP; 16 Jul 2026 04:57:09 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 5/5] btrfs: zoned: avoid ordered_operations_mutex when finishing a zone
Date: Thu, 16 Jul 2026 13:56:56 +0200
Message-ID: <20260716115656.1319295-6-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260716115656.1319295-1-johannes.thumshirn@wdc.com>
References: <20260716115656.1319295-1-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On a zoned filesystem with no free active zones, a data allocation finishes a
block group to make room:

  cow_file_range -> btrfs_reserve_extent -> find_free_extent ->
  btrfs_zone_finish_one_bg -> do_zone_finish ->
  btrfs_wait_ordered_roots -> mutex_lock(&fs_info->ordered_operations_mutex)

This can be reached from an ordered extent flush worker
(btrfs_run_ordered_extent_work) which is run and waited for by
btrfs_wait_ordered_roots() while it holds ordered_operations_mutex:

  btrfs_async_reclaim_metadata_space -> flush_space ->
  btrfs_wait_ordered_roots -> mutex_lock(&fs_info->ordered_operations_mutex)
                           -> wait for the flush work to complete

The flush worker then blocks on the same, non-recursive mutex the reclaim
task holds while waiting for that very worker, so the filesystem deadlocks.
It was observed as a hang in generic/048:

  INFO: task kworker/u36:8 blocked for more than 120 seconds.
   btrfs_wait_ordered_roots -> flush_space -> btrfs_async_reclaim_metadata_space
  INFO: task kworker/u34:6 is blocked on a mutex likely owned by kworker/u36:8
   btrfs_wait_ordered_roots -> do_zone_finish -> btrfs_zone_finish_one_bg ->
   find_free_extent -> cow_file_range

The cycle has existed since data block group allocation started finishing
zones (commit 393f646e34c1 ("btrfs: zoned: finish least available block
group on data bg allocation")).

Add btrfs_wait_ordered_roots_nolock(), which waits for a block group's
ordered extents using the multi-waiter safe ordered->wait bit and never
takes ordered_operations_mutex or ordered_extent_mutex, and use it from
do_zone_finish(). The block group is already read-only there, so no new
ordered extents can appear in its range while we wait. This relies on the
preceding two patches keeping the ordered extent and root lists visible
(they no longer splice the lists away) so the walk cannot miss an in-flight
ordered extent.

Assisted-by: LLM (debugging, commit message)
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/ordered-data.c | 74 +++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/ordered-data.h |  2 ++
 fs/btrfs/zoned.c        |  8 +++--
 3 files changed, 82 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index ddd21aa5c640..12102fc76696 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -866,6 +866,80 @@ void btrfs_wait_ordered_roots(struct btrfs_fs_info *fs_info, u64 nr,
 	mutex_unlock(&fs_info->ordered_operations_mutex);
 }
 
+/*
+ * Wait for all ordered extents intersecting @bg to finish without taking
+ * ordered_operations_mutex or ordered_extent_mutex, so it is safe to call from
+ * the zone-finish path (which can run inside the ordered extent flush worker
+ * that a btrfs_wait_ordered_roots() caller is waiting for). @bg must be
+ * read-only, so its set of ordered extents only shrinks while we wait.
+ */
+void btrfs_wait_ordered_roots_nolock(struct btrfs_fs_info *fs_info,
+				     const struct btrfs_block_group *bg)
+{
+	const u64 range_start = bg->start;
+	const u64 range_end = bg->start + bg->length;
+	struct btrfs_root **roots;
+	struct btrfs_root *root;
+	int nr_roots = 0;
+	int cap = 0;
+	int i;
+
+	spin_lock(&fs_info->ordered_root_lock);
+	cap = list_count_nodes(&fs_info->ordered_roots);
+	spin_unlock(&fs_info->ordered_root_lock);
+	if (!cap)
+		return;
+
+	roots = kvmalloc_array(cap, sizeof(*roots), GFP_NOFS);
+	if (!roots) {
+		btrfs_wait_ordered_roots(fs_info, U64_MAX, bg);
+		return;
+	}
+
+	spin_lock(&fs_info->ordered_root_lock);
+	list_for_each_entry(root, &fs_info->ordered_roots, ordered_root) {
+		if (nr_roots >= cap)
+			break;
+		if (!btrfs_grab_root(root))
+			continue;
+		roots[nr_roots++] = root;
+	}
+	spin_unlock(&fs_info->ordered_root_lock);
+
+	for (i = 0; i < nr_roots; i++) {
+		root = roots[i];
+
+		while (true) {
+			struct btrfs_ordered_extent *found = NULL;
+			struct btrfs_ordered_extent *ordered;
+
+			spin_lock(&root->ordered_extent_lock);
+			list_for_each_entry(ordered, &root->ordered_extents,
+					    root_extent_list) {
+				if (test_bit(BTRFS_ORDERED_COMPLETE,
+					     &ordered->flags))
+					continue;
+				if (!ordered_in_range(ordered, range_start,
+						      range_end))
+					continue;
+				found = ordered;
+				refcount_inc(&found->refs);
+				break;
+			}
+			spin_unlock(&root->ordered_extent_lock);
+
+			if (!found)
+				break;
+
+			btrfs_start_ordered_extent(found);
+			btrfs_put_ordered_extent(found);
+			cond_resched();
+		}
+		btrfs_put_root(root);
+	}
+	kvfree(roots);
+}
+
 /*
  * Start IO and wait for a given ordered extent to finish.
  *
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index f4d0675bb9c3..d8280a7bccb1 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -220,6 +220,8 @@ u64 btrfs_wait_ordered_extents(struct btrfs_root *root, u64 nr,
 			       const struct btrfs_block_group *bg);
 void btrfs_wait_ordered_roots(struct btrfs_fs_info *fs_info, u64 nr,
 			      const struct btrfs_block_group *bg);
+void btrfs_wait_ordered_roots_nolock(struct btrfs_fs_info *fs_info,
+				     const struct btrfs_block_group *bg);
 void btrfs_lock_and_flush_ordered_range(struct btrfs_inode *inode, u64 start,
 					u64 end,
 					struct extent_state **cached_state);
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index a016cb471beb..3a3ef96dcc8b 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2585,8 +2585,12 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
 
 		/* Ensure all writes in this block group finish */
 		btrfs_wait_block_group_reservations(block_group);
-		/* No need to wait for NOCOW writers. Zoned mode does not allow that */
-		btrfs_wait_ordered_roots(fs_info, U64_MAX, block_group);
+		/*
+		 * No need to wait for NOCOW writers. Zoned mode does not allow
+		 * that. Use the lock-free variant as we can be called from the
+		 * allocator inside an ordered extent flush worker.
+		 */
+		btrfs_wait_ordered_roots_nolock(fs_info, block_group);
 		/* Wait for extent buffers to be written. */
 		if (is_metadata)
 			wait_eb_writebacks(block_group);
-- 
2.54.0

