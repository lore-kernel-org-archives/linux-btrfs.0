Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795602111;
	b=TKwN2yBij6CzfdBjRu4g57giMIyncTuYuWrZ18d34Rp8cMkM0GT0ZVCBJBGV9Sh9tbi1
	 jeccog3CoHN7+vC+fj5sVG0j/Bc27MU5WWOqPnaaUloEmUHLLRYL3DPEOFijwy1dIubHE
	 zSb8w+VnUu1jtr6fRLWEclt5I3z4Z+6OkxkjT9hTs073ZC344b6X48sVmy4M+WELw6P1b
	 NY6IMkioIjkLYePfKDogIPRxQ/MPz21soa0M4Cdo84T9I63IO+ibJBydgia101IXrbWpa
	 NxwCSZTpgpDm5WAMGVDvwmhIQBhkm20yb1dapDwYP9wpeSm6tKldLyVV0YCbRGIKRvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795602111;
	h=DMARC-Filter:DKIM-Signature:Cc:Subject:Date:
	 Content-Transfer-Encoding:To:Mime-Version:In-Reply-To:Content-Type:
	 From:References:X-Lms-Return-Path:X-Mailer:Message-Id:X-Original-From:
	 Received;
	bh=+ytd7l5OSiMjKhhw1oPWlJfb3BbUe2tLkY82xiUfAQk=;
	b=zd8hIa2SMCabyruJ7V3itl1TfL47xqhHIRET2japAnE0hswwyC4Jo84foav+Qr86Sknq
	 yL+/yHvOvkQPVr8+/LoJ5H4JNziL9drDzWycWqdsPTPaWGjxj0zWc9YRD0A0Tm+rgQT2k
	 kSBZEfCm+9LK1uupMFgb537sHlR0rIPhojwKGcA+xzUHhJr+aOCYWXq1bVwfgQ9N+0Ozr
	 0Alc7BWt2U46W3Ctz2HD7GrAp2O7simWBi9I6NJdRTF1Qqt3wwWAMXrWjkVZ9BValRFnu
	 lwiEyNKJKG1XK7ECjKppmYf2Jbz5FH2t1xBGNVU4WFVcMZ4Lbtx1uLoxWN2QXhtLlJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fygo.io;
	spf=pass smtp.mailfrom=fygo.io;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=LKLLl7TR;
	arc=none smtp.remote-ip=209.127.231.48
Received: from va-2-48.ptr.blmpb.com (va-2-48.ptr.blmpb.com [209.127.231.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF27606A6BB
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 10:21:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4AF27606A6BB
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=LKLLl7TR
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1795602102;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=+ytd7l5OSiMjKhhw1oPWlJfb3BbUe2tLkY82xiUfAQk=;
 b=LKLLl7TRF4Yx+Z3d3WLkoFn2Vpp8PjjkAELLpx1mEB97IA5sP+iiWV0ExsbLNHp73QXSt9
 CVuu8bJJw/OG6ZHCrPf07ddKsaV5eyApZbcHlJ2CxmgonILKDv6d9vvvIdlyvXXCgz0fNQ
 KGMa/+WMMWk6kG3QIQp37Lht+hNW69wodXXj6GChlk7n1Li0VapwiVvN2TyX/zW+AppQxP
 5QHfULndkF4nFMrUOiCmjrtHKtDMbw63Sl5xVChXl1+Jek2WYJQ02rt1mvZZwQupiPNIVE
 Xp/GMt+N8ie81Xni9stDiTh7tDFYK6YmTVYjclGJw7StgrRynk6xBlyjrUq7ZQ==
Cc: <johannes.thumshirn@wdc.com>, <naohiro.aota@wdc.com>, 
	<a2jphilipp@gmail.com>
Subject: [PATCH v4 1/4] btrfs: zoned: track only sequential zones as active
Date: Wed, 25 Nov 2026 18:21:28 +0800
Content-Transfer-Encoding: 7bit
To: <linux-btrfs@vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
In-Reply-To: <cover.1795600611.git.zhudongjiang@fygo.io>
Content-Type: text/plain; charset=UTF-8
From: "Dongjiang Zhu" <zhudongjiang@fygo.io>
References: <cover.1795600611.git.zhudongjiang@fygo.io>
X-Lms-Return-Path: <lba+26b06b6b5+0ebbf1+vger.kernel.org+zhudongjiang@fygo.io>
X-Mailer: git-send-email 2.39.5
Message-Id: <87fe3eadb8605794000152b860b0a1559c5d1fbb.1795600611.git.zhudongjiang@fygo.io>
X-Original-From: Dongjiang Zhu <zhudongjiang@fygo.io>
Received: from pdzhu.teiron-inc.cn ([183.34.165.116]) by smtp.larksuite.com with ESMTPS; Wed, 25 Nov 2026 10:21:40 +0000

Conventional zones do not consume hardware active-zone slots, but
conventional stripes can still be included in runtime accounting.
This complicates active-zone state management and increases the
risk of accounting errors. Simplify the accounting by tracking
only sequential zones as active.

Assisted-by: LLM
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Tested-by: Jochen Philipp <a2jphilipp@gmail.com>
Signed-off-by: Dongjiang Zhu <zhudongjiang@fygo.io>
---
 fs/btrfs/zoned.c | 48 +++++++++++++++++++++++++++++++++---------------
 1 file changed, 33 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index e6ce6f05ad75..3475e7785f58 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1980,7 +1980,6 @@ int btrfs_load_block_group_zone_info(struct btrfs_block_group *cache, bool new)
 		} else if (map->num_stripes == num_conventional) {
 			cache->alloc_offset = last_alloc;
 			cache->zone_capacity = cache->length;
-			set_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &cache->runtime_flags);
 			goto out;
 		}
 	}
@@ -2016,6 +2015,8 @@ int btrfs_load_block_group_zone_info(struct btrfs_block_group *cache, bool new)
 	if (!ret) {
 		cache->meta_write_pointer = cache->alloc_offset + cache->start;
 		if (test_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &cache->runtime_flags)) {
+			ASSERT(test_bit(BLOCK_GROUP_FLAG_SEQUENTIAL_ZONE,
+					&cache->runtime_flags));
 			spin_lock(&fs_info->zone_active_bgs_lock);
 			if (list_empty(&cache->active_bg_list)) {
 				btrfs_get_block_group(cache);
@@ -2211,6 +2212,9 @@ static bool check_bg_is_active(struct btrfs_eb_write_context *ctx,
 	if (test_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &block_group->runtime_flags))
 		return true;
 
+	if (!test_bit(BLOCK_GROUP_FLAG_SEQUENTIAL_ZONE, &block_group->runtime_flags))
+		return true;
+
 	if (fs_info->treelog_bg == block_group->start) {
 		if (!btrfs_zone_activate(block_group)) {
 			int ret_fin;
@@ -2407,6 +2411,18 @@ int btrfs_sync_zone_write_pointer(struct btrfs_device *tgt_dev, u64 logical,
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
@@ -2431,6 +2447,9 @@ bool btrfs_zone_activate(struct btrfs_block_group *block_group)
 	if (unlikely(btrfs_is_testing(fs_info)))
 		return true;
 
+	if (!test_bit(BLOCK_GROUP_FLAG_SEQUENTIAL_ZONE, &block_group->runtime_flags))
+		return true;
+
 	map = block_group->physical_map;
 
 	spin_lock(&fs_info->zone_active_bgs_lock);
@@ -2462,7 +2481,7 @@ bool btrfs_zone_activate(struct btrfs_block_group *block_group)
 		if (!device->bdev)
 			continue;
 
-		if (zinfo->max_active_zones == 0)
+		if (!btrfs_needs_active_zone_tracking(device, physical))
 			continue;
 
 		/*
@@ -2537,27 +2556,23 @@ static int call_zone_finish(struct btrfs_block_group *block_group,
 	struct btrfs_device *device = stripe->dev;
 	const u64 physical = stripe->physical;
 	struct btrfs_zoned_device_info *zinfo = device->zone_info;
+	unsigned int nofs_flags;
 	bool cleared;
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
 
 	cleared = btrfs_dev_clear_active_zone(device, physical);
 	if (!(block_group->flags & BTRFS_BLOCK_GROUP_DATA) && cleared)
@@ -3168,6 +3183,9 @@ void btrfs_check_active_zone_reservation(struct btrfs_fs_info *fs_info)
 			if (!device->bdev)
 				continue;
 
+			if (zinfo->max_active_zones == 0)
+				continue;
+
 			if (!test_bit(physical >> zinfo->zone_size_shift, zinfo->active_zones))
 				continue;
 
-- 
2.39.5
