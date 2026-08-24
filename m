Received: from lf-2-16.ptr.blmpb.com (lf-2-16.ptr.blmpb.com [101.36.218.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A3C317145
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Aug 2026 06:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.36.218.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787554284; cv=none; b=aSK9VRNtrs9El5Oj7baWdvFlJEWOs8RcX2dNRbpA8qzJF8rMRbsF/7Iml5PF8aogHPUSnoFBez9oWTXxERV6XX2j8EsG8IWgm2BV0iwa8X9hCx5m7nhHquYXNx8vGfNmZrFQ2FVjhex9SAMQSGpu7hl65SP7ivPxHYT5YYpUi5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787554284; c=relaxed/simple;
	bh=o0aQiIHHVIyEknGxxA00g7dkW6/XrcDk0jiXi69Dk48=;
	h=To:Subject:Date:In-Reply-To:Content-Type:From:Message-Id:
	 Mime-Version:Cc:References; b=mm3fXPwNBUtHglAumzefXD70o7Pr0+Ugjhv+oCxppeb0MBfj9guMcu21nMu/f8hiv4WFnHUcmwoz4auFCuvHsDrnupvu6cigfxuEc4wk8YwKAjOMJrdBbrSa3kmt+r9DdyHE8vM2I9qcJajdJGl/mnJbqG6mpG8nFnXXo5adJyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=MZKwUMzt; arc=none smtp.client-ip=101.36.218.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="MZKwUMzt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1787554230;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=MWGCLSHNkhUZSBMUSRtdFtTq7m9CK7tlhhvUGW3yFOQ=;
 b=MZKwUMztaL0fpnHNe4YjeJeXUJJ8aD0QJdSBp/t8003TNK8POTA3lejb3MfFp6oIOmIRsf
 3Ysdn6oxafZma+fkIuLk77qUV341GC683jQv5w2mEuefeb2sbjtpLF6RgeRzL/iMlVjhBN
 9Ytm7lvbsxejpMzrRNC0m4ndTzc5kjowpBtSmz35OR+q9W2ZqKrYAEJHPLR6FGACtm3c0Y
 PktFs1Gx9xhSCEQnvveDf6OgBehtVmmunUzCgKLa4nR3YHKXnYDJ/ptUVNKyDm35DrUbLC
 veLlw/dXQPraZkOd5BSwHMGgq4WQP0Q/yKrcxVeSnmoThXG+8IA81EzvJ9FlMA==
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/4] btrfs: zoned: track only sequential zones as active
Date: Mon, 24 Aug 2026 14:49:53 +0800
Received: from pdzhu.teiron-inc.cn ([183.34.169.70]) by smtp.larksuite.com with ESMTPS; Mon, 24 Aug 2026 06:50:29 +0000
X-Lms-Return-Path: <lba+26a8be9b6+1fe132+vger.kernel.org+zhudongjiang@fygo.io>
In-Reply-To: <cover.1787551793.git.zhudongjiang@fygo.io>
Content-Type: text/plain; charset=UTF-8
From: "Dongjiang Zhu" <zhudongjiang@fygo.io>
Message-Id: <9b86d2db35ad9afc13069d6ee8fcf421c85ef030.1787551793.git.zhudongjiang@fygo.io>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: Dongjiang Zhu <zhudongjiang@fygo.io>
Content-Transfer-Encoding: 7bit
X-Mailer: git-send-email 2.39.5
Cc: <johannes.thumshirn@wdc.com>, <naohiro.aota@wdc.com>
References: <cover.1787551793.git.zhudongjiang@fygo.io>

[CAUSE]
The runtime activation and finish paths apply active-zone accounting to
both conventional and sequential stripes.

At mount, however, active_zones_left is rebuilt from device zone
conditions.  Conventional zones report NOT_WP and are therefore not
included.  Meanwhile, all-conventional block groups are marked active
and added to zone_active_bgs, so mount recovery still decreases
reserved_active_zones for their metadata and system stripes.

The two counters can therefore diverge across a remount.

[BUG]
Each unmatched reservation decrement lets data consume one more
sequential active-zone slot.  Once the reservation becomes negative,
data can exhaust all such slots.

A later transition from a conventional metadata or system target to a
sequential one can then fail, because finishing the conventional target
does not release a sequential active-zone slot.

If this happens during synchronous transaction writeback,
btrfs_check_meta_write_pointer() returns -EAGAIN.  The transaction is
then aborted and the filesystem is forced read-only.

The reservation mismatch was reproduced by creating small files with
large xattrs in batches, syncing them and remounting an HC620 filesystem
using SINGLE profiles:

  active_zones_left:     126
  reserved_active_zones: 3 -> -8

The active list contained one partially used conventional system block
group, nine full conventional metadata block groups and one partially
used conventional metadata block group.

[FIX]
Use sequential stripes as the unit of active-zone tracking.

Do not mark all-conventional block groups active.  Only sequential
stripes update the active-zone bitmap and non-data reservation during
activation, finish and mount recovery.

Assisted-by: LLM
Signed-off-by: Dongjiang Zhu <zhudongjiang@fygo.io>
---
 fs/btrfs/block-group.h |  6 +++++-
 fs/btrfs/zoned.c       | 48 +++++++++++++++++++++++++++++-------------
 2 files changed, 38 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/block-group.h b/fs/btrfs/block-group.h
index 69d56864d4ba..37ab8b7eee9c 100644
--- a/fs/btrfs/block-group.h
+++ b/fs/btrfs/block-group.h
@@ -80,13 +80,17 @@ enum btrfs_block_group_flags {
 	BLOCK_GROUP_FLAG_TO_COPY,
 	BLOCK_GROUP_FLAG_RELOCATING_REPAIR,
 	BLOCK_GROUP_FLAG_CHUNK_ITEM_INSERTED,
+	/*
+	 * Only block groups containing sequential zones can have this bit set;
+	 * conventional-only block groups never do.
+	 */
 	BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE,
 	BLOCK_GROUP_FLAG_ZONED_DATA_RELOC,
 	/* Does the block group need to be added to the free space tree? */
 	BLOCK_GROUP_FLAG_NEEDS_FREE_SPACE,
 	/* Set after we add a new block group to the free space tree. */
 	BLOCK_GROUP_FLAG_FREE_SPACE_ADDED,
-	/* Indicate that the block group is placed on a sequential zone */
+	/* Indicate that the block group contains at least one sequential zone. */
 	BLOCK_GROUP_FLAG_SEQUENTIAL_ZONE,
 	/*
 	 * Indicate that block group is in the list of new block groups of a
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 9d448cdd60c4..bd079d3b31ba 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1969,7 +1969,6 @@ int btrfs_load_block_group_zone_info(struct btrfs_block_group *cache, bool new)
 		} else if (map->num_stripes == num_conventional) {
 			cache->alloc_offset = last_alloc;
 			cache->zone_capacity = cache->length;
-			set_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &cache->runtime_flags);
 			goto out;
 		}
 	}
@@ -2005,6 +2004,8 @@ int btrfs_load_block_group_zone_info(struct btrfs_block_group *cache, bool new)
 	if (!ret) {
 		cache->meta_write_pointer = cache->alloc_offset + cache->start;
 		if (test_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &cache->runtime_flags)) {
+			ASSERT(test_bit(BLOCK_GROUP_FLAG_SEQUENTIAL_ZONE,
+					&cache->runtime_flags));
 			btrfs_get_block_group(cache);
 			spin_lock(&fs_info->zone_active_bgs_lock);
 			list_add_tail(&cache->active_bg_list,
@@ -2198,6 +2199,9 @@ static bool check_bg_is_active(struct btrfs_eb_write_context *ctx,
 	if (test_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &block_group->runtime_flags))
 		return true;
 
+	if (!test_bit(BLOCK_GROUP_FLAG_SEQUENTIAL_ZONE, &block_group->runtime_flags))
+		return true;
+
 	if (fs_info->treelog_bg == block_group->start) {
 		if (!btrfs_zone_activate(block_group)) {
 			int ret_fin;
@@ -2417,6 +2421,9 @@ bool btrfs_zone_activate(struct btrfs_block_group *block_group)
 	if (unlikely(btrfs_is_testing(fs_info)))
 		return true;
 
+	if (!test_bit(BLOCK_GROUP_FLAG_SEQUENTIAL_ZONE, &block_group->runtime_flags))
+		return true;
+
 	map = block_group->physical_map;
 
 	spin_lock(&fs_info->zone_active_bgs_lock);
@@ -2448,6 +2455,9 @@ bool btrfs_zone_activate(struct btrfs_block_group *block_group)
 		if (!device->bdev)
 			continue;
 
+		if (!btrfs_dev_is_sequential(device, physical))
+			continue;
+
 		if (zinfo->max_active_zones == 0)
 			continue;
 
@@ -2514,26 +2524,25 @@ static int call_zone_finish(struct btrfs_block_group *block_group,
 	struct btrfs_device *device = stripe->dev;
 	const u64 physical = stripe->physical;
 	struct btrfs_zoned_device_info *zinfo = device->zone_info;
+	unsigned int nofs_flags;
 	int ret;
 
 	if (!device->bdev)
 		return 0;
 
-	if (zinfo->max_active_zones == 0)
+	if (!btrfs_dev_is_sequential(device, physical))
 		return 0;
 
-	if (btrfs_dev_is_sequential(device, physical)) {
-		unsigned int nofs_flags;
-
-		nofs_flags = memalloc_nofs_save();
-		ret = blkdev_zone_mgmt(device->bdev, REQ_OP_ZONE_FINISH,
-				       physical >> SECTOR_SHIFT,
-				       zinfo->zone_size >> SECTOR_SHIFT);
-		memalloc_nofs_restore(nofs_flags);
+	if (zinfo->max_active_zones == 0)
+		return 0;
 
-		if (ret)
-			return ret;
-	}
+	nofs_flags = memalloc_nofs_save();
+	ret = blkdev_zone_mgmt(device->bdev, REQ_OP_ZONE_FINISH,
+			       physical >> SECTOR_SHIFT,
+			       zinfo->zone_size >> SECTOR_SHIFT);
+	memalloc_nofs_restore(nofs_flags);
+	if (ret)
+		return ret;
 
 	if (!(block_group->flags & BTRFS_BLOCK_GROUP_DATA))
 		zinfo->reserved_active_zones++;
@@ -3087,8 +3096,17 @@ void btrfs_check_active_zone_reservation(struct btrfs_fs_info *fs_info)
 		      (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM)))
 			continue;
 
-		for (int i = 0; i < map->num_stripes; i++)
-			map->stripes[i].dev->zone_info->reserved_active_zones--;
+		for (int i = 0; i < map->num_stripes; i++) {
+			struct btrfs_device *device = map->stripes[i].dev;
+			u64 physical = map->stripes[i].physical;
+
+			if (!device->bdev ||
+			    !btrfs_dev_is_sequential(device, physical) ||
+			    !device->zone_info->max_active_zones)
+				continue;
+
+			device->zone_info->reserved_active_zones--;
+		}
 	}
 	spin_unlock(&fs_info->zone_active_bgs_lock);
 }
-- 
2.39.5
