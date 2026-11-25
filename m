Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795602113;
	b=uTFFOLm/xFQM5wH9/B0n4qgrIEsdCrPD16qUEyx9+RnP2Wp+jgqQTIX4eb0owx4XovHz
	 XsMsY0k+vm4BdNPBSkNlu1J5EoBimo6Ss1eaS84KXz0FWJVJaAyQMZ4aXzkYsvznUKX8i
	 oul+uWYB7uyaJkvJHOA+tntlkMuPIE0l7NhovZd2//PScN4C9/D9dYySDLYn2jvgYIBEx
	 xbMXBm2LeSmrpwIvZjPvQ/bNcNJcc2NrVSrDTICkEvsJ+7hJNLzN4sRhis0RXrOwAX8h7
	 dbhdvDDpKYnSHQbNBouffLuJdxr2WzlaSs4BWPvc1VrdNj9pptZHwU2JfKgXGFuXVLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795602113;
	h=DMARC-Filter:DKIM-Signature:To:Cc:Subject:Mime-Version:X-Mailer:
	 References:Content-Transfer-Encoding:X-Original-From:Date:Message-Id:
	 Received:X-Lms-Return-Path:From:In-Reply-To:Content-Type;
	bh=74IYD0jjE43lFnUB4OzgSTrsCoSkmTOteK0B/h+tByI=;
	b=Y+C4ed6DQ/lM4sCaDY2PNc8qBChyErW//iw9g24IHmYHDawDEPT0kF7pOTTyaNcZP6sh
	 0sC7doWOQPtOgTM6HQvKZ1jFx81H1qFMizOPOY2VjNhCo1kOf7RTPVZiJxC1/vE+2Y8bU
	 qPGhd81lrIr6Fw1YqS5/eDeRoGtw2orPqJhifi1Dz93RpPOaOTj1l/nEKKlEhgjv0zt43
	 66bH55/Gfu4X72O/1ADgFoZ9TUdRguK3cRPkoUv6jXQrFMwCw3xqUcYQI/iTm1Mvy9JmI
	 CFadlEyDLRVDcuoRNC9BOa39YeRzs7crgZvulTN79x9Tt7aBg+oUmK4jZPHqrusy2YQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fygo.io;
	spf=pass smtp.mailfrom=fygo.io;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=icWctasZ;
	arc=none smtp.remote-ip=209.127.231.46
Received: from va-2-46.ptr.blmpb.com (va-2-46.ptr.blmpb.com [209.127.231.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6E9606A688
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 10:21:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4F6E9606A688
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=icWctasZ
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1795602107;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=74IYD0jjE43lFnUB4OzgSTrsCoSkmTOteK0B/h+tByI=;
 b=icWctasZn5tEev80YROE605nFafATHQTdHF1SBerUyGYCPX4goDhdhXhYjCiZVlHBhVUDI
 Fsx8tzGYYGYM5Y5vhjV6tfpuWGhXV4TaDQDamQA3BDRwpXQRxPVbHQczojmxScI94KHePz
 kBZjVet8rjo/k7jBEE7RnSO8Mr5sF+9duAwLdmx+mxbnt4bGtW1kItX9dLMZJ+urQi2Aeu
 RryN3BnN95162bhZc31XHvkrwdpl7gfsMmFT+F4WO7SYMi4dxgU6l3W3jMly+pCb3/K+Yf
 i3Aom4x18hiqkkASsGUAEK1pkuP+GmlriDyxgVjmUi1b/rgsiqXycUqaNoDHmA==
To: <linux-btrfs@vger.kernel.org>
Cc: <johannes.thumshirn@wdc.com>, <naohiro.aota@wdc.com>, 
	<a2jphilipp@gmail.com>
Subject: [PATCH v4 4/4] btrfs: zoned: serialize zone finishing per block group
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.5
References: <cover.1795600611.git.zhudongjiang@fygo.io>
Content-Transfer-Encoding: 7bit
X-Original-From: Dongjiang Zhu <zhudongjiang@fygo.io>
Date: Wed, 25 Nov 2026 18:21:31 +0800
Message-Id: <d570243c5583a97474731adb2a2035fe647abb57.1795600611.git.zhudongjiang@fygo.io>
Received: from pdzhu.teiron-inc.cn ([183.34.165.116]) by smtp.larksuite.com with ESMTPS; Wed, 25 Nov 2026 10:21:46 +0000
X-Lms-Return-Path: <lba+26b06b6bb+4a130b+vger.kernel.org+zhudongjiang@fygo.io>
From: "Dongjiang Zhu" <zhudongjiang@fygo.io>
In-Reply-To: <cover.1795600611.git.zhudongjiang@fygo.io>
Content-Type: text/plain; charset=UTF-8

On an HC620 with max_active_zones=128, buffered writes occupied all 128
active-zone slots. A metadata-heavy create/delete workload followed by
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

Thread B treats the cleared active bit as a completed finish, although
thread A has not yet returned the active-zone slot.

Add ZONE_FINISHING to serialize finishers per block group. Keep
ZONE_IS_ACTIVE set until the device operations and active-list cleanup
are complete, then wake waiting finishers. Release any temporary
read-only reference acquired by a waiting caller.

Assisted-by: LLM
Tested-by: Jochen Philipp <a2jphilipp@gmail.com>
Signed-off-by: Dongjiang Zhu <zhudongjiang@fygo.io>
---
 fs/btrfs/block-group.h |  1 +
 fs/btrfs/zoned.c       | 31 ++++++++++++++++++++++++++++++-
 2 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/block-group.h b/fs/btrfs/block-group.h
index d567ed822e55..31aca6424d54 100644
--- a/fs/btrfs/block-group.h
+++ b/fs/btrfs/block-group.h
@@ -88,6 +88,7 @@ enum btrfs_block_group_flags {
 	BLOCK_GROUP_FLAG_NEW,
 	BLOCK_GROUP_FLAG_FULLY_REMAPPED,
 	BLOCK_GROUP_FLAG_STRIPE_REMOVAL_PENDING,
+	BLOCK_GROUP_FLAG_ZONE_FINISHING,
 };
 
 enum btrfs_caching_type {
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 2d02d6fd2526..14ea819831b6 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2589,6 +2589,7 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
 	const bool is_metadata = (block_group->flags &
 			(BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM));
 	struct btrfs_dev_replace *dev_replace = &fs_info->dev_replace;
+	bool bg_ro = false;
 	int ret = 0;
 	int i;
 
@@ -2600,6 +2601,12 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
 		return 0;
 	}
 
+	if (test_bit(BLOCK_GROUP_FLAG_ZONE_FINISHING, &block_group->runtime_flags)) {
+		spin_unlock(&block_group->lock);
+		spin_unlock(&space_info->lock);
+		goto wait_finish;
+	}
+
 	/* Check if we have unwritten allocated space */
 	if (is_metadata &&
 	    block_group->start + block_group->alloc_offset > block_group->meta_write_pointer) {
@@ -2630,6 +2637,7 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
 		ret = btrfs_inc_block_group_ro(block_group, false);
 		if (ret)
 			return ret;
+		bg_ro = true;
 
 		/* Ensure all writes in this block group finish */
 		btrfs_wait_block_group_reservations(block_group);
@@ -2655,6 +2663,13 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
 			return 0;
 		}
 
+		if (test_bit(BLOCK_GROUP_FLAG_ZONE_FINISHING,
+			     &block_group->runtime_flags)) {
+			spin_unlock(&block_group->lock);
+			spin_unlock(&space_info->lock);
+			goto wait_finish;
+		}
+
 		if (block_group->reserved ||
 		    test_bit(BLOCK_GROUP_FLAG_ZONED_DATA_RELOC,
 			     &block_group->runtime_flags)) {
@@ -2676,7 +2691,7 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
 		btrfs_space_info_update_bytes_zone_unusable(space_info, tail_unusable);
 	}
 
-	clear_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &block_group->runtime_flags);
+	set_bit(BLOCK_GROUP_FLAG_ZONE_FINISHING, &block_group->runtime_flags);
 	block_group->alloc_offset = block_group->zone_capacity;
 	if (block_group->flags & (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM))
 		block_group->meta_write_pointer = block_group->start +
@@ -2700,8 +2715,13 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
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
@@ -2710,6 +2730,15 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
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
