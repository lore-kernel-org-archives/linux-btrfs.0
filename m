Received: from va-2-18.ptr.blmpb.com (va-2-18.ptr.blmpb.com [209.127.231.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D898E34CDD
	for <linux-btrfs@vger.kernel.org>; Wed, 26 Aug 2026 04:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787718599; cv=none; b=a+ZRk7t1ylNTJJbJUCvj7LzrKG3UF6375SwRzVlI7PJLC+sZgjNRHTg6S0aOgoFYZNXbu4JQaTmY1uvIwGr1Aa3l+6H/5aErku5WpBUIu0fMO8QfzmNSjNJ4PUo7f+Hh4/LNzCnOdp6GukBMO9+U4sG0dhP4njKnId8z6aR4pXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787718599; c=relaxed/simple;
	bh=8kJWEODLy2Q+DKKZ7hj5h4QFa/D2Xddfg8YbSI91b68=;
	h=From:Date:Message-Id:Mime-Version:In-Reply-To:To:Subject:Cc:
	 References:Content-Type; b=Hr9FlarELe61nfp1OCcRirfOw3ElOhM93Q+QG7D0Vfi6rVfVwPhN5SspY34VnJJkKSXn9w1BmVCYboMqxHggvMtgEEl8/bVX6MiShXYVoUTbJQDhHmxCHzkDhTDOdE2ckdI+hQSq6OAIpuZrShZcXmWnwPsKsxmUywxbllKF0w4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=QbSXMeG7; arc=none smtp.client-ip=209.127.231.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="QbSXMeG7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1787718473;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=JvCYF//PQ4ankWxvi3YLAWSTCB1X2KeRZlDd6ojCWv4=;
 b=QbSXMeG7SR1/BlCmtiyJBb3bJGXhs5sZMRgCGYlQ/Pw58rwuNa6w+9150zbUoOTExoWXYZ
 IfHxw93VvldhKgYibJ1dLNM80RKUI7KRlJyBgfiF9qa8bv1HLc8Qtpb/s7XWjlJh7b6fVH
 TrlWQ/Jz74RYr4kisioIP71EqXwHaXnYbGoG0HePH6PryqGim0Tx1Cjzh112AoUnIPN/60
 zoHR+lnOubwuQshRGBFpHH5CiM9tBeGLdDqfCbw02eYhYaCZFmskHV7q2I59BwH9ghN3Y1
 85KQRtzsXGjJte1llvyv/F5clihI9HwKUCl30yNZnnSZZuvvS+GMrjlI//uzhQ==
X-Mailer: git-send-email 2.39.5
Received: from pdzhu.teiron-inc.cn ([14.21.231.246]) by smtp.larksuite.com with ESMTPS; Wed, 26 Aug 2026 04:27:52 +0000
X-Lms-Return-Path: <lba+26a8e6b49+6e387e+vger.kernel.org+zhudongjiang@fygo.io>
From: "Dongjiang Zhu" <zhudongjiang@fygo.io>
Date: Wed, 26 Aug 2026 12:27:26 +0800
Message-Id: <cbe8563498c69d8355ed2404be45206148184ad4.1787717573.git.zhudongjiang@fygo.io>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
In-Reply-To: <cover.1787717573.git.zhudongjiang@fygo.io>
X-Original-From: Dongjiang Zhu <zhudongjiang@fygo.io>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 3/4] btrfs: zoned: remove obsolete non-data block group activation helper
Content-Transfer-Encoding: 7bit
Cc: <johannes.thumshirn@wdc.com>, <naohiro.aota@wdc.com>
References: <cover.1787717573.git.zhudongjiang@fygo.io>
Content-Type: text/plain; charset=UTF-8

On an HC620 with max_active_zones=128, file writes occupied all 128
active-zone slots.  With four direct-I/O writers still running, starting
a balance with

  btrfs balance start -f -dusage=0 -musage=0 -susage=100 <mountpoint>

left the balance task blocked in D state.  SysRq-w reported:

  task:btrfs           state:D stack:0     pid:8145
  Call Trace:
   <TASK>
   __schedule+0x50e/0xfe0
   schedule+0x22/0xa0
   schedule_preempt_disabled+0x10/0x20
   __mutex_lock.constprop.0+0x380/0x920
   btrfs_inc_block_group_ro+0x6a/0x270 [btrfs]
   do_zone_finish+0x2b6/0x4c0 [btrfs]
   btrfs_zone_finish_one_bg+0x184/0x1f0 [btrfs]
   btrfs_zoned_activate_one_bg+0x189/0x1d0 [btrfs]
   reserve_chunk_space+0xdb/0x180 [btrfs]
   btrfs_inc_block_group_ro+0x252/0x270 [btrfs]
   btrfs_relocate_block_group+0xc2/0x2260 [btrfs]
   btrfs_relocate_chunk+0x39/0x1c0 [btrfs]
   btrfs_balance+0x911/0x1810 [btrfs]
   </TASK>

The blocked balance task also stalls transaction commit and data writers,
so the filesystem can no longer make write progress or unmount cleanly.

This happens because the outer btrfs_inc_block_group_ro() holds
ro_block_group_mutex while reserve_chunk_space() tries to activate a
system block group.  When no active-zone slot is available,
btrfs_zoned_activate_one_bg() starts finishing a partially written data
block group.

do_zone_finish() then enters btrfs_inc_block_group_ro() again.  The same
task waits for ro_block_group_mutex that it already holds and
self-deadlocks.

Remove the two allocation-time activation calls and their helper for two
reasons:

1. They were added for active_total_bytes accounting, which no longer
   exists.  Metadata and system block groups are now activated at write
   time, and both callers already handle no block group being activated.

2. Allocation-time activation bypasses the role pivot.  If A is the
   current system block group, activating B consumes another active-zone
   slot instead of finishing A.  If no slot is available, the helper
   tries to finish an unrelated data block group, creating the recursive
   path above.

With these activation paths removed, the first write to a sequential
metadata or system block group enters check_bg_is_active(), which finishes
the previous block group for that role before activating the new one.

Assisted-by: LLM
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Dongjiang Zhu <zhudongjiang@fygo.io>
---
 fs/btrfs/block-group.c | 38 +++++++++-----------------------
 fs/btrfs/zoned.c       | 50 ------------------------------------------
 fs/btrfs/zoned.h       |  8 -------
 3 files changed, 10 insertions(+), 86 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 830460a40e86..c58bac5cb134 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -3219,13 +3219,6 @@ int btrfs_inc_block_group_ro(struct btrfs_block_group *cache,
 
 	alloc_flags = btrfs_get_alloc_profile(fs_info, space_info->flags);
 	ret = btrfs_chunk_alloc(trans, space_info, alloc_flags, CHUNK_ALLOC_FORCE);
-	if (ret < 0)
-		goto out;
-	/*
-	 * We have allocated a new chunk. We also need to activate that chunk to
-	 * grant metadata tickets for zoned filesystem.
-	 */
-	ret = btrfs_zoned_activate_one_bg(space_info, true);
 	if (ret < 0)
 		goto out;
 
@@ -4537,29 +4530,18 @@ static void reserve_chunk_space(struct btrfs_trans_handle *trans,
 		if (IS_ERR(bg)) {
 			ret = PTR_ERR(bg);
 		} else {
-			int activate_ret;
-
 			/*
-			 * We have a new chunk. We also need to activate it for
-			 * zoned filesystem.
+			 * If we fail to add the chunk item here, we end
+			 * up trying again at phase 2 of chunk allocation,
+			 * at btrfs_create_pending_block_groups(). So
+			 * ignore any error here. An ENOSPC here could
+			 * happen, due to the cases described at
+			 * do_chunk_alloc() - the system block group we
+			 * just created was just turned into RO mode by a
+			 * scrub for example, or a running discard
+			 * temporarily removed its free space entries, etc.
 			 */
-			activate_ret = btrfs_zoned_activate_one_bg(info, true);
-			if (activate_ret < 0) {
-				ret = activate_ret;
-			} else {
-				/*
-				 * If we fail to add the chunk item here, we end
-				 * up trying again at phase 2 of chunk allocation,
-				 * at btrfs_create_pending_block_groups(). So
-				 * ignore any error here. An ENOSPC here could
-				 * happen, due to the cases described at
-				 * do_chunk_alloc() - the system block group we
-				 * just created was just turned into RO mode by a
-				 * scrub for example, or a running discard
-				 * temporarily removed its free space entries, etc.
-				 */
-				btrfs_chunk_alloc_add_chunk_item(trans, bg);
-			}
+			btrfs_chunk_alloc_add_chunk_item(trans, bg);
 		}
 	}
 
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index ee7d518bec15..63d59b015829 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -3006,56 +3006,6 @@ int btrfs_zone_finish_one_bg(struct btrfs_fs_info *fs_info)
 	return ret < 0 ? ret : 1;
 }
 
-int btrfs_zoned_activate_one_bg(struct btrfs_space_info *space_info, bool do_finish)
-{
-	struct btrfs_fs_info *fs_info = space_info->fs_info;
-	struct btrfs_block_group *bg;
-	int index;
-
-	if (!btrfs_is_zoned(fs_info) || (space_info->flags & BTRFS_BLOCK_GROUP_DATA))
-		return 0;
-
-	for (;;) {
-		int ret;
-		bool need_finish = false;
-
-		down_read(&space_info->groups_sem);
-		for (index = 0; index < BTRFS_NR_RAID_TYPES; index++) {
-			list_for_each_entry(bg, &space_info->block_groups[index],
-					    list) {
-				if (!spin_trylock(&bg->lock))
-					continue;
-				if (btrfs_zoned_bg_is_full(bg) ||
-				    test_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE,
-					     &bg->runtime_flags)) {
-					spin_unlock(&bg->lock);
-					continue;
-				}
-				spin_unlock(&bg->lock);
-
-				if (btrfs_zone_activate(bg)) {
-					up_read(&space_info->groups_sem);
-					return 1;
-				}
-
-				need_finish = true;
-			}
-		}
-		up_read(&space_info->groups_sem);
-
-		if (!do_finish || !need_finish)
-			break;
-
-		ret = btrfs_zone_finish_one_bg(fs_info);
-		if (ret == 0)
-			break;
-		if (ret < 0)
-			return ret;
-	}
-
-	return 0;
-}
-
 static int finish_extra_active_nondata_bgs(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_block_group *block_group;
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index 934a9368ed15..dc7c453fc979 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -94,7 +94,6 @@ bool btrfs_zoned_should_reclaim(const struct btrfs_fs_info *fs_info);
 void btrfs_zoned_release_data_reloc_bg(struct btrfs_fs_info *fs_info, u64 logical,
 				       u64 length);
 int btrfs_zone_finish_one_bg(struct btrfs_fs_info *fs_info);
-int btrfs_zoned_activate_one_bg(struct btrfs_space_info *space_info, bool do_finish);
 int btrfs_restore_active_nondata_bgs(struct btrfs_fs_info *fs_info);
 int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num_bytes);
 void btrfs_show_zoned_stats(struct btrfs_fs_info *fs_info, struct seq_file *seq);
@@ -272,13 +271,6 @@ static inline int btrfs_zone_finish_one_bg(struct btrfs_fs_info *fs_info)
 	return 1;
 }
 
-static inline int btrfs_zoned_activate_one_bg(struct btrfs_space_info *space_info,
-					      bool do_finish)
-{
-	/* Consider all the block groups are active */
-	return 0;
-}
-
 static inline int btrfs_restore_active_nondata_bgs(struct btrfs_fs_info *fs_info)
 {
 	return 0;
-- 
2.39.5
