Received: from va-2-42.ptr.blmpb.com (va-2-42.ptr.blmpb.com [209.127.231.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E72757EA
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Aug 2026 06:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787554248; cv=none; b=oCyo2Uge/fG5TMFl7IHASdrZN4yPg5BmgWXpw+Txxbk+dizCLJM1iBEahQid16bGzlkBqFhwi7FMpUoxJso+cHQUyfjbm68z3RudZ1xgZ0ERTJgrwVlMyCtJwcqrqXY/IG2GuLMEMGampYn6m4sfLPIhNF1uIDiQgUii+5NGI9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787554248; c=relaxed/simple;
	bh=nAnTwgasqirSK/V3Ghtt/mvr4ZlnffQ7m2gmkKQqUXk=;
	h=To:Subject:References:Content-Type:From:Cc:Date:Mime-Version:
	 Message-Id:In-Reply-To; b=EQzeQwJx6PWo5pqmGex30WpI/U3XXBbgs9BaXByT+C0sTQ48rrIIonu2cgndV8rSrKM51rBjtnDDkrnFAy3C6enUnDslvy+4U7yda5QWkjaM8v3zkPAEHSgzbblHh8FwdoHkfzn7ZOb8GDkOQ7JohTJrr20VO7BoZe0wodAShYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=MiNaeQzK; arc=none smtp.client-ip=209.127.231.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="MiNaeQzK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1787554235;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=bWy0SWXPUBtavVarZmI/X4kvFHTnlkgS7NNwYPHR+n8=;
 b=MiNaeQzKD2gGLuTUu6fkRaIvUitEyio/LOgtIO83/qrM5qpxVUmr68fo4Qkw91eBuBeBLH
 ik//d+yg1iop9bem49cpr6hYaublz0eFSECdmY8DyEB43fl7eJqnos79C6oGXPP3Uf46kE
 NDGgzWt32uLdWdnd2k97UNqdV7xGuQk5G4IKQCdnKz7b1UZdzrJR1WACsIbiLylh4ALmJO
 4e6iv4HMNKhl53b17TsC2g2BeY1j3A4dHhz4RX3rE9zey0GvE36AeSYwnfXXVd032orBeB
 IZUlya7dFGYmfSz/p2h5JWGoyCDKKGnWwMl98uB3SXZVGuMxiipjt/27NhAwfg==
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/4] btrfs: zoned: recover active non-data block group roles on mount
References: <cover.1787551793.git.zhudongjiang@fygo.io>
Content-Type: text/plain; charset=UTF-8
From: "Dongjiang Zhu" <zhudongjiang@fygo.io>
Received: from pdzhu.teiron-inc.cn ([183.34.169.70]) by smtp.larksuite.com with ESMTPS; Mon, 24 Aug 2026 06:50:34 +0000
Cc: <johannes.thumshirn@wdc.com>, <naohiro.aota@wdc.com>
Date: Mon, 24 Aug 2026 14:49:54 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.5
Message-Id: <8956aae5225383d3c9ec3b08a3a9d42da1396eb2.1787551793.git.zhudongjiang@fygo.io>
In-Reply-To: <cover.1787551793.git.zhudongjiang@fygo.io>
Content-Transfer-Encoding: 7bit
X-Original-From: Dongjiang Zhu <zhudongjiang@fygo.io>
X-Lms-Return-Path: <lba+26a8be9bb+79fb95+vger.kernel.org+zhudongjiang@fygo.io>

[BUG]
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

[CAUSE]
active_meta_bg and active_system_bg assign active block groups to the
normal metadata and system write roles.  These runtime-only pointers are
reset to NULL on every mount.

Mount reconstructs partially used sequential block groups in
zone_active_bgs and adjusts their reservations, but does not recover the
role assignments.

The write-time pivot can finish the previous block group only when the
corresponding role pointer is set.  If it is NULL, activation proceeds
without releasing an already active block group of the same role.

[FIX]
Recover one active block group for the normal metadata role and one for
the system role from zone_active_bgs.  For each role, keep the block group
with the largest writable tail and finish the others.

The tree-log block group role is runtime-only and cannot be recovered
after a remount.  Use the selected metadata block group for the normal
metadata role and leave one metadata reservation for a new tree-log
block group.

Run the recovery on every mount.  ZONE_FINISH preserves existing extents
but abandons the unused tail, so account that tail as zone unusable
immediately.

Assisted-by: LLM
Signed-off-by: Dongjiang Zhu <zhudongjiang@fygo.io>
---
 fs/btrfs/disk-io.c |  7 +++-
 fs/btrfs/fs.h      |  4 +++
 fs/btrfs/zoned.c   | 90 ++++++++++++++++++++++++++++++++++++++++++----
 fs/btrfs/zoned.h   |  7 ++--
 4 files changed, 98 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 819727460bcf..9092487171ad 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3702,7 +3702,12 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 
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
diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index 10e15a319b93..aa3d6b66495e 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -931,6 +931,10 @@ struct btrfs_fs_info {
 	u64 data_reloc_bg;
 	struct mutex zoned_data_reloc_io_lock;
 
+	/*
+	 * Active block groups for normal metadata and system writes. Mount
+	 * recovery restores one block group for each role and finishes any extras.
+	 */
 	struct btrfs_block_group *active_meta_bg;
 	struct btrfs_block_group *active_system_bg;
 
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index bd079d3b31ba..7d91c074a24a 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -3050,22 +3050,73 @@ int btrfs_zoned_activate_one_bg(struct btrfs_space_info *space_info, bool do_fin
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
+		tail_unusable = block_group->zone_capacity - block_group->alloc_offset;
+
+		ret = do_zone_finish(block_group, true);
+		if (!ret) {
+			struct btrfs_space_info *space_info = block_group->space_info;
+
+			/* Account for the unused tail abandoned by ZONE_FINISH. */
+			spin_lock(&space_info->lock);
+			block_group->zone_unusable += tail_unusable;
+			btrfs_space_info_update_bytes_zone_unusable(space_info,
+								    tail_unusable);
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
@@ -3087,14 +3138,35 @@ void btrfs_check_active_zone_reservation(struct btrfs_fs_info *fs_info)
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
+		avail = block_group->zone_capacity - block_group->alloc_offset;
+		if (!*active_bg || avail > *active_avail) {
+			if (*active_bg)
+				btrfs_put_block_group(*active_bg);
+			*active_bg = block_group;
+			*active_avail = avail;
+			btrfs_get_block_group(*active_bg);
+		}
 
 		for (int i = 0; i < map->num_stripes; i++) {
 			struct btrfs_device *device = map->stripes[i].dev;
@@ -3108,7 +3180,11 @@ void btrfs_check_active_zone_reservation(struct btrfs_fs_info *fs_info)
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
