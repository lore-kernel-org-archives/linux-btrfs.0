Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.57
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795602109;
	b=m5gN/wgqHQYBPuXGsr2yl1KcwtcLEudhw5ycvX/Rth+vTgEEEncbs8T6mgg+PA/azlkF
	 sKGEGHILpEcLFXlbhbxIMw08JfjCsnwOPUddneDIFowDqY6AjUmoKBc2C1S+4mAfmcXNu
	 /EN1030hIyJwvq2N/ha99yUGKF6+hmxZ3w9F5VUgtmZY2BqPrOxQnqQympwvzpTRvHEzD
	 a1EPNjGB2sQ1srqeMun7j9qlDJuSzanFJfuo3Sk7sMNde3l0NwdzfKLHytOnsUb2N81CO
	 JtIcW7A06kkznnca4FwbOqZtMRbjzShRrw8hHfMnM+4uh6GUyaugbfoe+ltzrlCRXkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795602109;
	h=DMARC-Filter:DKIM-Signature:X-Original-From:X-Mailer:Message-Id:
	 Mime-Version:Received:In-Reply-To:References:Content-Type:To:Cc:From:
	 X-Lms-Return-Path:Content-Transfer-Encoding:Subject:Date;
	bh=L62KNfpHbIneAwakMwV+2O+kVGmhxi64p2AGXUShSWA=;
	b=2GhCfASpgA64cYZ3sbKskdm6WZKmvVv5iiKvIqMb1VRG3/Q28jIHQI8y9M+Ho+wXTBbC
	 hegJK6D9m0ZHga1sahTyf/OOD2QRAPwwPYkGt3H6j7gmsl12AmlA1BYVQBd/mkUD2abRv
	 ZKd3j3WdrHLApHJxGYQrunDevIp4OdHY8cSJe+KbtEgty0upenlSRv6YkZoTpvEpr3wMt
	 ubXVbBWe9K39Ta4XZUnjrMClJGh7YtGjtxmBzBHBUmv0jhSDpPeFoF3mpkXC5ConozaHZ
	 1+OjQyqkDLNNEiqMp9SgQYBOJ8c+KrXlQPvSx6IVg5oYukA6sykyQ+4w+LdRNd7NPxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fygo.io;
	spf=pass smtp.mailfrom=fygo.io;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=pQrtxzFM;
	arc=none smtp.remote-ip=209.127.231.57
Received: from va-2-57.ptr.blmpb.com (va-2-57.ptr.blmpb.com [209.127.231.57])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C2B606A32A
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 10:21:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B9C2B606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=pQrtxzFM
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1795602103;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=L62KNfpHbIneAwakMwV+2O+kVGmhxi64p2AGXUShSWA=;
 b=pQrtxzFMJawyLPQoCfKTliPM2PeeqkpMVNM5kDfE95cxlesQDgA7LSxQyM9V/Phrt1039j
 BY6vrmE6GaElnR5oXrBIOCR0vUVsjAz/9JRno18zjGgQehXNKj9MLGtv+LuAmRyqHKCB0X
 NzRCqpeZe/atxkJABwEvWc+cuaR7B61PEmtdhZtgMFP+rXSaLIv9c2v7apQPTabgEldVCB
 764cs0chFT+2DsE4xBM9LdcG0dbVaessxTMG4KK0Rb6cVcwKZoNTFWpKmZYqJYOXmIwrmm
 VS2/EvUBssPufIWl8wlY8ZCxiqfIAOpMWSBoGxhBWHui2VGXtEYmjOpuChrSHw==
X-Original-From: Dongjiang Zhu <zhudongjiang@fygo.io>
X-Mailer: git-send-email 2.39.5
Message-Id: <c543a0d6c901fa781c6ab2db4db102691183275d.1795600611.git.zhudongjiang@fygo.io>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Received: from pdzhu.teiron-inc.cn ([183.34.165.116]) by smtp.larksuite.com with ESMTPS; Wed, 25 Nov 2026 10:21:42 +0000
In-Reply-To: <cover.1795600611.git.zhudongjiang@fygo.io>
References: <cover.1795600611.git.zhudongjiang@fygo.io>
Content-Type: text/plain; charset=UTF-8
To: <linux-btrfs@vger.kernel.org>
Cc: <johannes.thumshirn@wdc.com>, <naohiro.aota@wdc.com>, 
	<a2jphilipp@gmail.com>
From: "Dongjiang Zhu" <zhudongjiang@fygo.io>
X-Lms-Return-Path: <lba+26b06b6b7+b3ecbb+vger.kernel.org+zhudongjiang@fygo.io>
Content-Transfer-Encoding: 7bit
Subject: [PATCH v4 2/4] btrfs: zoned: recover active non-data block group roles on mount
Date: Wed, 25 Nov 2026 18:21:29 +0800

Mount restores active sequential non-data block groups and their
reservations, but leaves active_meta_bg and active_system_bg unset.
Writing to a recovered block group does not set its role pointer:
check_bg_is_active() returns early because ZONE_IS_ACTIVE is already
set, skipping the role assignment.

These block groups can still be finished through other paths, but
metadata/system write-time switching cannot identify the previous
block group when the corresponding role pointer is NULL.

Restore these roles during mount so write-time switching can identify
and finish the previous non-data block group.

Keep the active block group with the largest writable tail for each
metadata/system role and finish the others. Since the tree-log role
is not persisted, leave a reservation for a new tree-log block group.

Account for the abandoned tails in do_zone_finish().

Assisted-by: LLM
Tested-by: Jochen Philipp <a2jphilipp@gmail.com>
Signed-off-by: Dongjiang Zhu <zhudongjiang@fygo.io>
---
 fs/btrfs/disk-io.c |   7 +++-
 fs/btrfs/zoned.c   | 102 +++++++++++++++++++++++++++++++++++++++++----
 fs/btrfs/zoned.h   |   7 +++-
 3 files changed, 106 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index fde9f4c4ea11..021dcd38b7be 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3768,7 +3768,12 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 
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
index 3475e7785f58..3853bc23d9bd 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2584,6 +2584,7 @@ static int call_zone_finish(struct btrfs_block_group *block_group,
 static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_written)
 {
 	struct btrfs_fs_info *fs_info = block_group->fs_info;
+	struct btrfs_space_info *space_info = block_group->space_info;
 	struct btrfs_chunk_map *map;
 	const bool is_metadata = (block_group->flags &
 			(BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM));
@@ -2591,9 +2592,11 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
 	int ret = 0;
 	int i;
 
+	spin_lock(&space_info->lock);
 	spin_lock(&block_group->lock);
 	if (!test_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &block_group->runtime_flags)) {
 		spin_unlock(&block_group->lock);
+		spin_unlock(&space_info->lock);
 		return 0;
 	}
 
@@ -2601,6 +2604,7 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
 	if (is_metadata &&
 	    block_group->start + block_group->alloc_offset > block_group->meta_write_pointer) {
 		spin_unlock(&block_group->lock);
+		spin_unlock(&space_info->lock);
 		return -EAGAIN;
 	}
 
@@ -2610,13 +2614,18 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
 	 * don't need to wait for the other IOs. This holds because we ensure
 	 * the sequential IO submissions using the ZONE_APPEND command for data
 	 * and block_group->meta_write_pointer for metadata.
+	 *
+	 * Mount-time cleanup also skips this, as there are no pending writes
+	 * or concurrent allocations.
 	 */
 	if (!fully_written) {
 		if (test_bit(BLOCK_GROUP_FLAG_ZONED_DATA_RELOC, &block_group->runtime_flags)) {
 			spin_unlock(&block_group->lock);
+			spin_unlock(&space_info->lock);
 			return -EAGAIN;
 		}
 		spin_unlock(&block_group->lock);
+		spin_unlock(&space_info->lock);
 
 		ret = btrfs_inc_block_group_ro(block_group, false);
 		if (ret)
@@ -2631,6 +2640,7 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
 		if (is_metadata)
 			wait_eb_writebacks(block_group);
 
+		spin_lock(&space_info->lock);
 		spin_lock(&block_group->lock);
 
 		/*
@@ -2640,6 +2650,7 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
 		if (!test_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE,
 			      &block_group->runtime_flags)) {
 			spin_unlock(&block_group->lock);
+			spin_unlock(&space_info->lock);
 			btrfs_dec_block_group_ro(block_group);
 			return 0;
 		}
@@ -2648,11 +2659,23 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
 		    test_bit(BLOCK_GROUP_FLAG_ZONED_DATA_RELOC,
 			     &block_group->runtime_flags)) {
 			spin_unlock(&block_group->lock);
+			spin_unlock(&space_info->lock);
 			btrfs_dec_block_group_ro(block_group);
 			return -EAGAIN;
 		}
 	}
 
+	/*
+	 * For read-only block groups, the tail is already accounted as
+	 * bytes_readonly.
+	 */
+	if (!block_group->ro) {
+		u64 tail_unusable = block_group->zone_capacity - block_group->alloc_offset;
+
+		block_group->zone_unusable += tail_unusable;
+		btrfs_space_info_update_bytes_zone_unusable(space_info, tail_unusable);
+	}
+
 	clear_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &block_group->runtime_flags);
 	block_group->alloc_offset = block_group->zone_capacity;
 	if (block_group->flags & (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM))
@@ -2662,6 +2685,7 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
 	btrfs_clear_treelog_bg(block_group);
 	btrfs_clear_data_reloc_bg(block_group);
 	spin_unlock(&block_group->lock);
+	spin_unlock(&space_info->lock);
 
 	down_read(&dev_replace->rwsem);
 	map = block_group->physical_map;
@@ -3128,22 +3152,58 @@ int btrfs_zoned_activate_one_bg(struct btrfs_space_info *space_info, bool do_fin
 	return 0;
 }
 
+static int finish_extra_active_nondata_bgs(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_block_group *block_group;
+	struct btrfs_block_group *next;
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
+		ret = do_zone_finish(block_group, true);
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
@@ -3165,14 +3225,38 @@ void btrfs_check_active_zone_reservation(struct btrfs_fs_info *fs_info)
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
@@ -3192,7 +3276,11 @@ void btrfs_check_active_zone_reservation(struct btrfs_fs_info *fs_info)
 			zinfo->reserved_active_zones--;
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
index 2225090839f3..8ed28e47d71b 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -100,7 +100,7 @@ void btrfs_zoned_release_data_reloc_bg(struct btrfs_fs_info *fs_info, u64 logica
 				       u64 length);
 int btrfs_zone_finish_one_bg(struct btrfs_fs_info *fs_info);
 int btrfs_zoned_activate_one_bg(struct btrfs_space_info *space_info, bool do_finish);
-void btrfs_check_active_zone_reservation(struct btrfs_fs_info *fs_info);
+int btrfs_restore_active_nondata_bgs(struct btrfs_fs_info *fs_info);
 int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num_bytes);
 void btrfs_show_zoned_stats(struct btrfs_fs_info *fs_info, struct seq_file *seq);
 
@@ -286,7 +286,10 @@ static inline int btrfs_zoned_activate_one_bg(struct btrfs_space_info *space_inf
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
