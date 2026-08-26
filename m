Received: from va-2-54.ptr.blmpb.com (va-2-54.ptr.blmpb.com [209.127.231.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13416330676
	for <linux-btrfs@vger.kernel.org>; Wed, 26 Aug 2026 04:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787718482; cv=none; b=Z3MIhUjUKaCTvFag2NrzOOHWPY3tBNAZC11rRc7U20yUkRAnVC8QHGidF1UIVJOZClfukJH18VLuNU5lVNEWWHy/25gZm4p1ctEm+1IqSt7VuXO7ONsUV8r7fwoHCw+Lhg1RBP8fS6PwY8rOS7FehZ8o6gPXu9MFP4lhAIi//Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787718482; c=relaxed/simple;
	bh=XDeEjnN5QkjTpVxbZiiWOyluHMP618zNVbSWhVl5gGY=;
	h=In-Reply-To:Date:Mime-Version:Content-Type:Cc:Subject:Message-Id:
	 To:From:References; b=bSYxYPUHsuGoO0QAczKMMgEngIJhx82zAOyMH1znerVbIIR0rBV4Iko/ibvvcZoYLDfKTNkKc0pLf45s7LXKsrIEfqVXEAcOnTrZC3fai2kxWJqstlXJiTsFDkKEe7rLlREPZntHv2vf2KKNts/JCN1pZ2KRe2a3fG5dPDtssrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=IrO1bCc9; arc=none smtp.client-ip=209.127.231.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="IrO1bCc9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1787718470;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=StsSpPNGmEncF02E/+pDPJTZ08OiqOFknrFpmg1v9ew=;
 b=IrO1bCc9LcGbrVicMky90T3R03X5pnmuviwvnNwzZB1h7tbVsDSX4JaP4mtSHOwPegVwjr
 XZu2lqwVZyxhir8NGljLqTdyOrTyyCrqszjClA2eAiu2Fia1aCwnwHbr6vOjmVseRYx334
 wDvDiaXMG9I2tIRsCnq0p1CxMs4bKpiyMCY/xcv0IVsa0yKBNDLI1A9uK2ZpwRvt/3qXbx
 5YoXeaGc8IQbHMO25lKTD4CXcGkr7i34A/vfVto1ake5rFchl7kMaQHl4WP3ccL8nhFaVC
 QhWkMzlzFmy2GukD8pvt5D0N8oa/spcozkSYykUmUN5e4l2vfv7ioOF3+UfiKA==
X-Lms-Return-Path: <lba+26a8e6b45+a9eac4+vger.kernel.org+zhudongjiang@fygo.io>
In-Reply-To: <cover.1787717573.git.zhudongjiang@fygo.io>
Date: Wed, 26 Aug 2026 12:27:25 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from pdzhu.teiron-inc.cn ([14.21.231.246]) by smtp.larksuite.com with ESMTPS; Wed, 26 Aug 2026 04:27:48 +0000
X-Original-From: Dongjiang Zhu <zhudongjiang@fygo.io>
X-Mailer: git-send-email 2.39.5
Content-Type: text/plain; charset=UTF-8
Cc: <johannes.thumshirn@wdc.com>, <naohiro.aota@wdc.com>
Subject: [PATCH v2 2/4] btrfs: zoned: recover active non-data block group roles on mount
Message-Id: <c16a88e2d1d88a1c3f7cac48776e5f9a7bb29490.1787717573.git.zhudongjiang@fygo.io>
Content-Transfer-Encoding: 7bit
To: <linux-btrfs@vger.kernel.org>
From: "Dongjiang Zhu" <zhudongjiang@fygo.io>
References: <cover.1787717573.git.zhudongjiang@fygo.io>

After a remount, a later write can activate a new metadata or system
block group without finishing the recovered one.  Repeating this across
remounts consumes additional active-zone slots and reservations, and can
eventually exhaust all active-zone slots.

Once no slot is available, activation of a metadata or system block group
fails.  During synchronous transaction writeback this propagates as
-EAGAIN, aborting the transaction and forcing the filesystem read-only.

A remount/fsync/remount reproducer on an HC620 left two partially used
sequential metadata block groups active while active_meta_bg remained
NULL:

  bg=343865819136 alloc=176095232 cap=268435456
  bg=344402690048 alloc=3260416   cap=268435456

active_meta_bg and active_system_bg assign active block groups to the
normal metadata and system write roles.  These runtime-only pointers are
reset to NULL on every mount.

Mount reconstructs partially used sequential block groups in
zone_active_bgs and adjusts their reservations, but does not recover the
role assignments.

The write-time pivot can finish the previous block group only when the
corresponding role pointer is set.  If it is NULL, activation proceeds
without releasing an already active block group of the same role.

Restore the role assignments by selecting one active block group for the
normal metadata role and one for the system role from zone_active_bgs.
For each role, keep the block group with the largest writable tail and
finish the others.

The tree-log block group role is runtime-only and cannot be recovered
after a remount.  Use the selected metadata block group for the normal
metadata role and leave one metadata reservation for a new tree-log block
group.

Run the recovery on every mount.  ZONE_FINISH preserves existing extents
but abandons the unused tail, so account that tail as zone unusable
immediately.

Assisted-by: LLM
Signed-off-by: Dongjiang Zhu <zhudongjiang@fygo.io>
---
 fs/btrfs/disk-io.c |  7 +++-
 fs/btrfs/zoned.c   | 97 ++++++++++++++++++++++++++++++++++++++++++----
 fs/btrfs/zoned.h   |  7 +++-
 3 files changed, 101 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index e6bbb0b1b38c..cd1f46ec62f0 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3713,7 +3713,12 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 
 	btrfs_free_zone_cache(fs_info);
 
-	btrfs_check_active_zone_reservation(fs_info);
+	ret = btrfs_restore_active_nondata_bgs(fs_info);
+	if (ret) {
+		btrfs_err(fs_info, "failed to restore active non-data block groups: %pe",
+			  ERR_PTR(ret));
+		goto fail_sysfs;
+	}
 
 	if (!sb_rdonly(sb) && fs_info->fs_devices->missing_devices &&
 	    !btrfs_check_rw_degradable(fs_info, NULL)) {
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 0d964ada3ad4..ee7d518bec15 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -3056,22 +3056,77 @@ int btrfs_zoned_activate_one_bg(struct btrfs_space_info *space_info, bool do_fin
 	return 0;
 }
 
+static int finish_extra_active_nondata_bgs(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_block_group *block_group;
+	struct btrfs_block_group *next;
+	u64 tail_unusable;
+	int ret;
+
+	list_for_each_entry_safe(block_group, next, &fs_info->zone_active_bgs,
+				 active_bg_list) {
+		if (!(block_group->flags &
+		      (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM)))
+			continue;
+
+		if (block_group == fs_info->active_meta_bg ||
+		    block_group == fs_info->active_system_bg)
+			continue;
+
+		btrfs_get_block_group(block_group);
+		spin_lock(&block_group->lock);
+		tail_unusable = block_group->zone_capacity - block_group->alloc_offset;
+		spin_unlock(&block_group->lock);
+
+		ret = do_zone_finish(block_group, true);
+		if (!ret) {
+			struct btrfs_space_info *space_info = block_group->space_info;
+
+			/* Account for the unused tail abandoned by ZONE_FINISH. */
+			spin_lock(&space_info->lock);
+			spin_lock(&block_group->lock);
+			block_group->zone_unusable += tail_unusable;
+			btrfs_space_info_update_bytes_zone_unusable(space_info,
+								    tail_unusable);
+			spin_unlock(&block_group->lock);
+			spin_unlock(&space_info->lock);
+		}
+		btrfs_put_block_group(block_group);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 /*
- * Reserve zones for one metadata block group, one tree-log block group, and one
- * system block group.
+ * Restore one active block group for normal metadata and system writes.
+ *
+ * The tree-log block group identity is not persisted, so recovered active
+ * metadata block groups cannot be distinguished by their previous role. Keep
+ * one for the normal metadata role and leave one reservation for a new
+ * tree-log block group.
+ *
+ * Older kernels rebuilt zone_active_bgs at mount without recovering the role
+ * assignments, which could result in multiple active metadata or system block
+ * groups. Finish all but the selected block group for each role.
  */
-void btrfs_check_active_zone_reservation(struct btrfs_fs_info *fs_info)
+int btrfs_restore_active_nondata_bgs(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
 	struct btrfs_block_group *block_group;
+	struct btrfs_block_group *active_meta_bg = NULL;
+	struct btrfs_block_group *active_system_bg = NULL;
 	struct btrfs_device *device;
+	u64 active_meta_avail = 0;
+	u64 active_system_avail = 0;
 	/* Reserve zones for normal SINGLE metadata and tree-log block group. */
 	unsigned int metadata_reserve = 2;
 	/* Reserve a zone for SINGLE system block group. */
 	unsigned int system_reserve = 1;
 
 	if (!test_bit(BTRFS_FS_ACTIVE_ZONE_TRACKING, &fs_info->flags))
-		return;
+		return 0;
 
 	/*
 	 * This function is called from the mount context. So, there is no
@@ -3093,14 +3148,38 @@ void btrfs_check_active_zone_reservation(struct btrfs_fs_info *fs_info)
 	}
 	mutex_unlock(&fs_devices->device_list_mutex);
 
-	/* Release reservation for currently active block groups. */
+	/*
+	 * Account all active non-data block groups before selecting one for each role.
+	 * Finishing the extra block groups releases their reservations again.
+	 */
 	spin_lock(&fs_info->zone_active_bgs_lock);
 	list_for_each_entry(block_group, &fs_info->zone_active_bgs, active_bg_list) {
 		struct btrfs_chunk_map *map = block_group->physical_map;
+		struct btrfs_block_group **active_bg;
+		u64 *active_avail;
+		u64 avail;
 
-		if (!(block_group->flags &
-		      (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM)))
+		if (block_group->flags & BTRFS_BLOCK_GROUP_METADATA) {
+			active_bg = &active_meta_bg;
+			active_avail = &active_meta_avail;
+		} else if (block_group->flags & BTRFS_BLOCK_GROUP_SYSTEM) {
+			active_bg = &active_system_bg;
+			active_avail = &active_system_avail;
+		} else {
 			continue;
+		}
+
+		spin_lock(&block_group->lock);
+		avail = block_group->zone_capacity - block_group->alloc_offset;
+		spin_unlock(&block_group->lock);
+
+		if (!*active_bg || avail > *active_avail) {
+			if (*active_bg)
+				btrfs_put_block_group(*active_bg);
+			*active_bg = block_group;
+			*active_avail = avail;
+			btrfs_get_block_group(*active_bg);
+		}
 
 		for (int i = 0; i < map->num_stripes; i++) {
 			struct btrfs_device *device = map->stripes[i].dev;
@@ -3115,7 +3194,11 @@ void btrfs_check_active_zone_reservation(struct btrfs_fs_info *fs_info)
 			device->zone_info->reserved_active_zones--;
 		}
 	}
+	fs_info->active_meta_bg = active_meta_bg;
+	fs_info->active_system_bg = active_system_bg;
 	spin_unlock(&fs_info->zone_active_bgs_lock);
+
+	return finish_extra_active_nondata_bgs(fs_info);
 }
 
 /*
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index 8e21a836f858..934a9368ed15 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -95,7 +95,7 @@ void btrfs_zoned_release_data_reloc_bg(struct btrfs_fs_info *fs_info, u64 logica
 				       u64 length);
 int btrfs_zone_finish_one_bg(struct btrfs_fs_info *fs_info);
 int btrfs_zoned_activate_one_bg(struct btrfs_space_info *space_info, bool do_finish);
-void btrfs_check_active_zone_reservation(struct btrfs_fs_info *fs_info);
+int btrfs_restore_active_nondata_bgs(struct btrfs_fs_info *fs_info);
 int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num_bytes);
 void btrfs_show_zoned_stats(struct btrfs_fs_info *fs_info, struct seq_file *seq);
 
@@ -279,7 +279,10 @@ static inline int btrfs_zoned_activate_one_bg(struct btrfs_space_info *space_inf
 	return 0;
 }
 
-static inline void btrfs_check_active_zone_reservation(struct btrfs_fs_info *fs_info) { }
+static inline int btrfs_restore_active_nondata_bgs(struct btrfs_fs_info *fs_info)
+{
+	return 0;
+}
 
 static inline int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info,
 						  u64 num_bytes)
-- 
2.39.5
