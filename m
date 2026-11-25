Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.20
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795602114;
	b=GREnZA/rkXY/slQhxMWor6DRyHL09TZGGeviStqmwli6pIy39reMqtGjk/t7CVc11TB6
	 BaNVn6SkovOURQERUbCRdI4apx9lA4cpVAwaAXQ9GRu3GK8Jlr5D7NRjk90nBAkQ8piBB
	 jfi9+G3DaKsIZZOVF/RAsZZNmZGVudtEptRrYrm2K3w2DYwqAdk4KZ+TxwqCZGN4d9rzR
	 /DIBJYUNO6hYlKWBF9Hn2Y+aND1H936pBF0mChDr7v8YPtbC9MgodwSYcX2xpmpnj7s9O
	 diU8D36OpUv2xR/udrSmt6wQZ8jqmBvzcFwfNNrAmQ3YdyDb0pvaSaBmt4A0kZxL1Ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795602114;
	h=DMARC-Filter:DKIM-Signature:In-Reply-To:Subject:Date:Message-Id:
	 Mime-Version:X-Lms-Return-Path:Content-Transfer-Encoding:
	 X-Original-From:X-Mailer:References:To:Cc:From:Received:Content-Type;
	bh=GMFhQv+HZ7E5ZeGUlV2aNaVQx9n+Da6d3KAIiLLkJkY=;
	b=3qBje19lXNYNEAnMnzEDJaPbtgU48Nfz32H3elfOAsrj9HAqEx862ZVH4sML4TiOIpoq
	 cxCldEVUp65n/OwVgmVS5V699Gl5IV200VQP9jgonT+W+YIwnwPkm8uPU5IEsumZzBA6R
	 CoQq2RQdvsB0hpdEc5Mgis60kQK2JaDTh2sZXNLvYAVpmn29rX9jqomBv//JtVE5hTfmn
	 OG/oLT9SIF08t1xJxAeoHvoV1msXWDhA80zz5YmipXTPNfnwtBt8VRL8/cDfTTrbxpLq+
	 2uOqdFsmpBXzjY4KV4lxjqQWWV0ZLDqSGFI73bKnaGA5VeL7YHMLmHeatuDxJyvVw2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fygo.io;
	spf=pass smtp.mailfrom=fygo.io;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b="a8H/Ftim";
	arc=none smtp.remote-ip=209.127.231.20
Received: from va-2-20.ptr.blmpb.com (va-2-20.ptr.blmpb.com [209.127.231.20])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65CC60A2620
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 10:21:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E65CC60A2620
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=a8H/Ftim
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1795602106;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=GMFhQv+HZ7E5ZeGUlV2aNaVQx9n+Da6d3KAIiLLkJkY=;
 b=a8H/FtimRA3J4ijiK6oVNQZF0ESCgGJ6gjZaWZN2lhcgCd0RVfh+U3idK302unBLJfNuwQ
 l021NBLTUV/EGkffmpMU/fn6o9QdOyEj6w6jedOLSDN7z2i/e/sqF5P5sahqNfouGsBMsy
 B8EL+ujT7VuyPxTsZchxYHeQhhjU7ksRXgoANrwYSJ+z9R36shmcc0nNiEt4UTn9RPhf+D
 ssg/gOFkpWZur8M/zQmV/t4r22pBrc81DdN9KBXwG11bvoF+Z7SZfHFZ71TH6TJ+/DSkCD
 OM43hCuZMhXJs3U4jzT1LfKME1POXh1lTSq3jo54AUCslnfGkeoKIBelN/tnBA==
In-Reply-To: <cover.1795600611.git.zhudongjiang@fygo.io>
Subject: [PATCH v4 3/4] btrfs: zoned: remove obsolete non-data block group activation helper
Date: Wed, 25 Nov 2026 18:21:30 +0800
Message-Id: <e1ded853157efd30e734dc963503dd627e3f042a.1795600611.git.zhudongjiang@fygo.io>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26b06b6b9+5bf017+vger.kernel.org+zhudongjiang@fygo.io>
Content-Transfer-Encoding: 7bit
X-Original-From: Dongjiang Zhu <zhudongjiang@fygo.io>
X-Mailer: git-send-email 2.39.5
References: <cover.1795600611.git.zhudongjiang@fygo.io>
To: <linux-btrfs@vger.kernel.org>
Cc: <johannes.thumshirn@wdc.com>, <naohiro.aota@wdc.com>, 
	<a2jphilipp@gmail.com>
From: "Dongjiang Zhu" <zhudongjiang@fygo.io>
Received: from pdzhu.teiron-inc.cn ([183.34.165.116]) by smtp.larksuite.com with ESMTPS; Wed, 25 Nov 2026 10:21:44 +0000
Content-Type: text/plain; charset=UTF-8

On an HC620 with max_active_zones=128, file writes occupied all 128
active-zone slots. With four direct-I/O writers still running, starting
a balance with

  btrfs balance start -f -dusage=0 -musage=0 -susage=100 <mountpoint>

left the balance task blocked in D state. SysRq-w reported:

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
system block group. When no active-zone slot is available,
btrfs_zoned_activate_one_bg() starts finishing a partially written data
block group.

do_zone_finish() then enters btrfs_inc_block_group_ro() again. The same
task waits for ro_block_group_mutex that it already holds and
self-deadlocks.

These allocation-time activation calls were needed for
active_total_bytes accounting, which has been removed. Metadata and
system block groups can instead be activated during writeback.

Remove both calls and the unused helper. This avoids recursively
entering btrfs_inc_block_group_ro() while holding ro_block_group_mutex
and leaves activation to the writeback path, where normal metadata
and system block group switching is handled.

Assisted-by: LLM
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Tested-by: Jochen Philipp <a2jphilipp@gmail.com>
Signed-off-by: Dongjiang Zhu <zhudongjiang@fygo.io>
---
 fs/btrfs/block-group.c | 38 +++++++++-----------------------
 fs/btrfs/zoned.c       | 50 ------------------------------------------
 fs/btrfs/zoned.h       |  8 -------
 3 files changed, 10 insertions(+), 86 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index a40eedc65dd2..ff108c5de8fa 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -3212,13 +3212,6 @@ int btrfs_inc_block_group_ro(struct btrfs_block_group *cache,
 
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
 
@@ -4201,29 +4194,18 @@ static void reserve_chunk_space(struct btrfs_trans_handle *trans,
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
index 3853bc23d9bd..2d02d6fd2526 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -3102,56 +3102,6 @@ int btrfs_zone_finish_one_bg(struct btrfs_fs_info *fs_info)
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
index 8ed28e47d71b..7db5d5a250ed 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -99,7 +99,6 @@ bool btrfs_zoned_should_reclaim(const struct btrfs_fs_info *fs_info);
 void btrfs_zoned_release_data_reloc_bg(struct btrfs_fs_info *fs_info, u64 logical,
 				       u64 length);
 int btrfs_zone_finish_one_bg(struct btrfs_fs_info *fs_info);
-int btrfs_zoned_activate_one_bg(struct btrfs_space_info *space_info, bool do_finish);
 int btrfs_restore_active_nondata_bgs(struct btrfs_fs_info *fs_info);
 int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num_bytes);
 void btrfs_show_zoned_stats(struct btrfs_fs_info *fs_info, struct seq_file *seq);
@@ -279,13 +278,6 @@ static inline int btrfs_zone_finish_one_bg(struct btrfs_fs_info *fs_info)
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
