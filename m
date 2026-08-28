Received: from va-2-54.ptr.blmpb.com (va-2-54.ptr.blmpb.com [209.127.231.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E985C39A066
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Aug 2026 03:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787889136; cv=none; b=gXV49qXz/wvORDdFwvo0f4DKGV2KFGfVd4lkqWtgtqLyLttWaIk15ZrxKj7C4nBzk1Tu6lUhPehu8nqLiv0zvLymg/Be0hqs+sQkgohGrvWkSt92P99lwfW89GHN7BcC0uWBdn/KZsfKFzXriOrRFPwn7u6YmEOYl7Uu8Sl1DNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787889136; c=relaxed/simple;
	bh=6VfQaBP7fZMZBV9psCHzc0AnVEHnx+II9UpNYvWFdZ8=;
	h=Mime-Version:Content-Type:Subject:Date:Message-Id:Cc:References:
	 To:From:In-Reply-To; b=caixDVNVWTOVhLTH1Gfb9o6sMCQN0cKS+fjKMitfHwLkLmue3a9CADdEiDBCf8ida7vucuTg1jFHYpZHomiITWdu0gG4YLHiFmFnePZ4D2YWlU8dPbFoRcJJnAvsEaKNa27vke3QLof/+0Ow6JYYUOl8Duf2E5BIO6C0nFQB47c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=BTXLo/hS; arc=none smtp.client-ip=209.127.231.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="BTXLo/hS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1787889121;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=cLLE6ReAuBPnUhR5t16bLGINj4wZ54nFHbfN+Q3yPeU=;
 b=BTXLo/hSTJApQgVa+JR8S9cDTtEjRycKRrjTRpyAyco8Z1FSseebzWtRYHlnoZ6rltaFqh
 siSugaIQfnOCu3sRjCxzmm2I77Vtxs9yVCSItZlw2lt52X48Lri5JOKr8iJyGSSvTJJ/2i
 lI3ZU4qe5V1Ac8hWZGMeQ47+SkwpHZnOejFFR1a0AFnsV+x46vnbk12qsR2UudL1uRda6K
 iyy5zV4te8gGl7uwCqDVFPNBZ0zOoDo9+X1kE0Y5PQh4luvHoiMvmKIWNgBLzKQGk+Hk5X
 KBIbdYtLsJ1H7uiHvVrueUyXLwGkUu5/wzE2njZT8LpbBXufJEeyCbtvHgcktg==
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH v3 1/4] btrfs: zoned: track only sequential zones as active
Date: Fri, 28 Aug 2026 11:51:37 +0800
Message-Id: <42a6a9e084182733b61a9d3dd66ad791aee71aaa.1787887776.git.zhudongjiang@fygo.io>
Received: from pdzhu.teiron-inc.cn ([14.21.226.247]) by smtp.larksuite.com with ESMTPS; Fri, 28 Aug 2026 03:51:59 +0000
Cc: <johannes.thumshirn@wdc.com>, <naohiro.aota@wdc.com>
References: <cover.1787887776.git.zhudongjiang@fygo.io>
X-Mailer: git-send-email 2.39.5
To: <linux-btrfs@vger.kernel.org>
From: "Dongjiang Zhu" <zhudongjiang@fygo.io>
In-Reply-To: <cover.1787887776.git.zhudongjiang@fygo.io>
Content-Transfer-Encoding: 7bit
X-Original-From: Dongjiang Zhu <zhudongjiang@fygo.io>
X-Lms-Return-Path: <lba+26a9105e0+fdc20c+vger.kernel.org+zhudongjiang@fygo.io>

The runtime activation and finish paths apply active-zone accounting to
both conventional and sequential stripes.

At mount, however, active_zones_left is rebuilt from device zone
conditions.  Conventional zones report NOT_WP and are therefore not
included.  Meanwhile, all-conventional block groups are marked active
and added to zone_active_bgs, so mount recovery still decreases
reserved_active_zones for their metadata and system stripes.

The two counters can therefore diverge across a remount.

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

To keep both counters based on the same physical resource, use
sequential stripes as the unit of active-zone tracking.  Accordingly, do
not mark all-conventional block groups active, and update the active-zone
bitmap and non-data reservation only for sequential stripes during
activation, finish and mount recovery.

Assisted-by: LLM
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Dongjiang Zhu <zhudongjiang@fygo.io>
---
 fs/btrfs/zoned.c | 59 ++++++++++++++++++++++++++++++++++--------------
 1 file changed, 42 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 9d448cdd60c4..0d964ada3ad4 100644
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
@@ -2394,6 +2398,18 @@ int btrfs_sync_zone_write_pointer(struct btrfs_device *tgt_dev, u64 logical,
 	return btrfs_zoned_issue_zeroout(tgt_dev, physical_pos, length);
 }
 
+static inline bool btrfs_needs_active_zone_tracking(struct btrfs_device *dev,
+						    u64 physical)
+{
+	if (!btrfs_dev_is_sequential(dev, physical))
+		return false;
+
+	if (dev->zone_info->max_active_zones == 0)
+		return false;
+
+	return true;
+}
+
 /*
  * Activate block group and underlying device zones
  *
@@ -2417,6 +2433,9 @@ bool btrfs_zone_activate(struct btrfs_block_group *block_group)
 	if (unlikely(btrfs_is_testing(fs_info)))
 		return true;
 
+	if (!test_bit(BLOCK_GROUP_FLAG_SEQUENTIAL_ZONE, &block_group->runtime_flags))
+		return true;
+
 	map = block_group->physical_map;
 
 	spin_lock(&fs_info->zone_active_bgs_lock);
@@ -2448,7 +2467,7 @@ bool btrfs_zone_activate(struct btrfs_block_group *block_group)
 		if (!device->bdev)
 			continue;
 
-		if (zinfo->max_active_zones == 0)
+		if (!btrfs_needs_active_zone_tracking(device, physical))
 			continue;
 
 		if (is_data)
@@ -2514,26 +2533,22 @@ static int call_zone_finish(struct btrfs_block_group *block_group,
 	struct btrfs_device *device = stripe->dev;
 	const u64 physical = stripe->physical;
 	struct btrfs_zoned_device_info *zinfo = device->zone_info;
+	unsigned int nofs_flags;
 	int ret;
 
 	if (!device->bdev)
 		return 0;
 
-	if (zinfo->max_active_zones == 0)
+	if (!btrfs_needs_active_zone_tracking(device, physical))
 		return 0;
 
-	if (btrfs_dev_is_sequential(device, physical)) {
-		unsigned int nofs_flags;
-
-		nofs_flags = memalloc_nofs_save();
-		ret = blkdev_zone_mgmt(device->bdev, REQ_OP_ZONE_FINISH,
-				       physical >> SECTOR_SHIFT,
-				       zinfo->zone_size >> SECTOR_SHIFT);
-		memalloc_nofs_restore(nofs_flags);
-
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
@@ -3087,8 +3102,18 @@ void btrfs_check_active_zone_reservation(struct btrfs_fs_info *fs_info)
 		      (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM)))
 			continue;
 
-		for (int i = 0; i < map->num_stripes; i++)
-			map->stripes[i].dev->zone_info->reserved_active_zones--;
+		for (int i = 0; i < map->num_stripes; i++) {
+			struct btrfs_device *device = map->stripes[i].dev;
+			u64 physical = map->stripes[i].physical;
+
+			if (!device->bdev)
+				continue;
+
+			if (!btrfs_needs_active_zone_tracking(device, physical))
+				continue;
+
+			device->zone_info->reserved_active_zones--;
+		}
 	}
 	spin_unlock(&fs_info->zone_active_bgs_lock);
 }
-- 
2.39.5
