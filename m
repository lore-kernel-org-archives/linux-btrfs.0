Received: from va-2-20.ptr.blmpb.com (va-2-20.ptr.blmpb.com [209.127.231.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666DD34CDD
	for <linux-btrfs@vger.kernel.org>; Wed, 26 Aug 2026 04:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787718492; cv=none; b=sEEUz0Q9lVRxvtMZkdwFOTppg+m7h80PjClW4ldlOaKvuHVSaLcTYIn+NS5i6IwvbACvJpch+LcoKZqMtlbOBXtXWTTyrGEAzxBdtkV666iufQ9LuvuQ893YzV69Vcqq339WLK4ahiANBwVnutmHIRk8xzj5TUcqVtI+G+sp+4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787718492; c=relaxed/simple;
	bh=m5dULoPAGbIF6NEgZKDQj/BjPwWcu+UndPKh0Tt/h2M=;
	h=References:To:Subject:Message-Id:Content-Type:Cc:From:Date:
	 Mime-Version:In-Reply-To; b=uT3Srjt+l9Ih/mT1n/qfppY5turKelx+IiQZCKNsVvPnGV0bE4EnTcWaHcFrRNfGsHw5WiuljWm1vnmBGQ9tsBChowjJ5ZWwAhkgKecUCHvmaRkr01+pDkMJI8ySWXi7mihSINtiamrdaMokehM+huJGmC4JKgrLevqmoEkQuOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=MvaHC4kc; arc=none smtp.client-ip=209.127.231.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="MvaHC4kc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1787718477;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=RfYA12pJKWw2yymP+Fx4786hmad4nlCwlwa0b7mpuy8=;
 b=MvaHC4kclwhsUOmM6nEeMONzgaORTYb/Y4YYLV08O7qJEr3lXa0QaQeB3tHbzSJCflhDXR
 KZbXuX0lwP06B1aZDbvQp4KOxUZPnLga+PcXg8giK/yk30OqDK5XJ/QwevzimoV5I5/Qs9
 XHADywx+kmW1lai77ee6sfzG48oXRWy9Uup4Et39V6uVibQLJpIO2cQFtmLDaZCI30yRKN
 Gib6HlqDRX0ayjbkIFTR82sAbZdiR0L2tCPRPv37SYQTnSXECMWy3WvjdzWQgN00fkOeXx
 3PptRZ+mKAfbdiRus6DHSTItUcRkkQmlSs4jZbNlol/VVzktsEA0f6gA5johWw==
X-Lms-Return-Path: <lba+26a8e6b4c+206b8f+vger.kernel.org+zhudongjiang@fygo.io>
Received: from pdzhu.teiron-inc.cn ([14.21.231.246]) by smtp.larksuite.com with ESMTPS; Wed, 26 Aug 2026 04:27:55 +0000
References: <cover.1787717573.git.zhudongjiang@fygo.io>
Content-Transfer-Encoding: 7bit
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 4/4] btrfs: zoned: serialize zone finishing per block group
Message-Id: <330dae33bc99c90775a855a8bedfe6230ca6b714.1787717573.git.zhudongjiang@fygo.io>
X-Original-From: Dongjiang Zhu <zhudongjiang@fygo.io>
Content-Type: text/plain; charset=UTF-8
Cc: <johannes.thumshirn@wdc.com>, <naohiro.aota@wdc.com>
From: "Dongjiang Zhu" <zhudongjiang@fygo.io>
Date: Wed, 26 Aug 2026 12:27:27 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1787717573.git.zhudongjiang@fygo.io>

On an HC620 with max_active_zones=128, buffered writes occupied all 128
active-zone slots.  A metadata-heavy create/delete workload followed by
sync then forced a metadata block group switch.

A kernel with additional zone finish tracing reported:

  zoned-debug: finish clear-runtime bg=140928614400 caller=btrfs_zone_finish_endio_workfn comm=kworker/u8:7
  zoned-debug: finish early-inactive bg=140928614400 caller=btrfs_check_meta_write_pointer comm=sync
  zoned-debug: pivot finish ret=0 old_bg=140928614400 new_bg=339839287296
  zoned-debug: activate fail slot bg=339839287296 type=metadata left=0 max_active=128 comm=sync
  zoned-debug: finish zone-mgmt bg=140928614400 ret=0 left=0 caller=btrfs_zone_finish_endio_workfn comm=kworker/u8:7
  BTRFS error (device sdb): error while writing out transaction: -EAGAIN
  BTRFS error (device sdb state A): Transaction 67 aborted (-EAGAIN)
  BTRFS info (device sdb state EA): forced readonly
  zoned-debug: clear-active dev=/dev/sdb pos=140928614400 left=1 max_active=128

The transaction was aborted before the old block group returned its
active-zone slot, forcing the filesystem read-only.

This happens because do_zone_finish() clears
BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE before issuing the zone finish operation.
This allows the following interleaving:

  Thread A, endio worker              Thread B, transaction writeback

  clear ZONE_IS_ACTIVE
  call_zone_finish(old)
                                        observe old as inactive
                                        return from do_zone_finish(old)
                                        activate(new)
                                        fail with left == 0
  clear the device active bit
  increment active_zones_left

Thread B treats the cleared active bit as a completed finish while thread
A is still performing the device operation.

Simply moving the active-bit clear after call_zone_finish() is not
sufficient because it does not serialize finishers.  Two callers can
still observe the block group as active and finish it concurrently.  For
a non-data block group, both increment reserved_active_zones, while
active_zones_left is incremented only once.  This breaks the invariant
that the two counters are restored together.

Therefore, add BLOCK_GROUP_FLAG_ZONE_FINISHING and keep ZONE_IS_ACTIVE set
until the zone finish operation and active-list cleanup are complete.

Concurrent finishers wait for ZONE_FINISHING to be cleared instead of
returning early.  Wake them after clearing ZONE_IS_ACTIVE and removing
the block group from the active list.  If a waiter acquired a temporary
read-only reference, release it after the wait.

Assisted-by: LLM
Signed-off-by: Dongjiang Zhu <zhudongjiang@fygo.io>
---
 fs/btrfs/block-group.h |  1 +
 fs/btrfs/zoned.c       | 29 ++++++++++++++++++++++++++++-
 2 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/block-group.h b/fs/btrfs/block-group.h
index 37ab8b7eee9c..d8ae56f3956d 100644
--- a/fs/btrfs/block-group.h
+++ b/fs/btrfs/block-group.h
@@ -99,6 +99,7 @@ enum btrfs_block_group_flags {
 	BLOCK_GROUP_FLAG_NEW,
 	BLOCK_GROUP_FLAG_FULLY_REMAPPED,
 	BLOCK_GROUP_FLAG_STRIPE_REMOVAL_PENDING,
+	BLOCK_GROUP_FLAG_ZONE_FINISHING,
 };
 
 enum btrfs_caching_type {
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 63d59b015829..bc09447caf10 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2564,6 +2564,7 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
 	const bool is_metadata = (block_group->flags &
 			(BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM));
 	struct btrfs_dev_replace *dev_replace = &fs_info->dev_replace;
+	bool bg_ro = false;
 	int ret = 0;
 	int i;
 
@@ -2573,6 +2574,11 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
 		return 0;
 	}
 
+	if (test_bit(BLOCK_GROUP_FLAG_ZONE_FINISHING, &block_group->runtime_flags)) {
+		spin_unlock(&block_group->lock);
+		goto wait_finish;
+	}
+
 	/* Check if we have unwritten allocated space */
 	if (is_metadata &&
 	    block_group->start + block_group->alloc_offset > block_group->meta_write_pointer) {
@@ -2597,6 +2603,7 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
 		ret = btrfs_inc_block_group_ro(block_group, false);
 		if (ret)
 			return ret;
+		bg_ro = true;
 
 		/* Ensure all writes in this block group finish */
 		btrfs_wait_block_group_reservations(block_group);
@@ -2619,6 +2626,12 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
 			return 0;
 		}
 
+		if (test_bit(BLOCK_GROUP_FLAG_ZONE_FINISHING,
+			     &block_group->runtime_flags)) {
+			spin_unlock(&block_group->lock);
+			goto wait_finish;
+		}
+
 		if (block_group->reserved ||
 		    test_bit(BLOCK_GROUP_FLAG_ZONED_DATA_RELOC,
 			     &block_group->runtime_flags)) {
@@ -2628,7 +2641,7 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
 		}
 	}
 
-	clear_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &block_group->runtime_flags);
+	set_bit(BLOCK_GROUP_FLAG_ZONE_FINISHING, &block_group->runtime_flags);
 	block_group->alloc_offset = block_group->zone_capacity;
 	if (block_group->flags & (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM))
 		block_group->meta_write_pointer = block_group->start +
@@ -2652,8 +2665,13 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
 		btrfs_dec_block_group_ro(block_group);
 
 	spin_lock(&fs_info->zone_active_bgs_lock);
+	spin_lock(&block_group->lock);
+	clear_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &block_group->runtime_flags);
 	ASSERT(!list_empty(&block_group->active_bg_list));
 	list_del_init(&block_group->active_bg_list);
+	clear_and_wake_up_bit(BLOCK_GROUP_FLAG_ZONE_FINISHING,
+			      &block_group->runtime_flags);
+	spin_unlock(&block_group->lock);
 	spin_unlock(&fs_info->zone_active_bgs_lock);
 
 	/* For active_bg_list */
@@ -2662,6 +2680,15 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
 	clear_and_wake_up_bit(BTRFS_FS_NEED_ZONE_FINISH, &fs_info->flags);
 
 	return ret;
+
+wait_finish:
+	wait_on_bit_io(&block_group->runtime_flags,
+		       BLOCK_GROUP_FLAG_ZONE_FINISHING,
+		       TASK_UNINTERRUPTIBLE);
+	if (bg_ro)
+		btrfs_dec_block_group_ro(block_group);
+
+	return 0;
 }
 
 int btrfs_zone_finish(struct btrfs_block_group *block_group)
-- 
2.39.5
