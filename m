Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E14438E126;
	Mon,  6 Jul 2026 11:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783335774; cv=none; b=oVx7ygQyeIEFJEq0JN5v57yDTYfoON9ZsxYUhsMVq8zq19CGf4Aow4xVN1BdSMJm16qtrsaZbdZo0Z6xbz4TiF9UXbjktush3dEmQ8g3+AD8J9r9IWzkTY481QOAwva+jr+tonHJYfSoefFFKSItvx6AzYtavaF5R5bYerattPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783335774; c=relaxed/simple;
	bh=SIgnQ/c46m89viwgiMNhwOml4Tt4n+xioz3+YQ6G898=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JxEzCFdV/9Ki8uYWDq95ZlmmzC5jiGcGzymD4uvh3jKhCQ6kMgEfDmHBcpe8VYyb+t/tEId/YdBGCEBgB6qo1Qk4i2ZxSDsu25HToP3tqmlRVrlfdWvg4MZNH/t/4igNn1T8FW1VWvgt5zYd4k9+5GgW80K9t8Jxbv1ShdiG4pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=auek1Yit; arc=none smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="auek1Yit"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1783335775; x=1814871775;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=SIgnQ/c46m89viwgiMNhwOml4Tt4n+xioz3+YQ6G898=;
  b=auek1YitsW+PXfiYuqvyhpPri3oaY+PPHnkSb6T8i50x3s1rF2LaC6uP
   JfCnLfRViDqDnxfd9pjL/vFaQofx6baLs2pDVwW43OgA9KgbtOQNAfmzL
   5GPEedlBayCOl4jcFzLGpcWxgvmGPzR8mlQsZqYtT3/yPp/bO73L4/q+U
   Y8KO2ldvi7X5848pgaencK8azB9GGjUx1tdsvTXFCDubNrxg0inmO6O+t
   qxEBz65oYp3hqfHgwmN5ul7UkDfRmLewRlk2FJSIB/7Su7GOJ58/fWe/e
   Er8mOd4D/uVJzCdv1yFi71h6W4rhFRg+JwZkyzkHVw83JcJ2MZ7ThSA0w
   g==;
X-CSE-ConnectionGUID: sLKCcQpVT1O8HfIc6M3DCg==
X-CSE-MsgGUID: fFUm+Q0wSvakYh/ddw0ZQA==
X-IronPort-AV: E=Sophos;i="6.25,149,1779120000"; 
   d="scan'208";a="149506415"
Received: from unknown (HELO uls-op-esad1-o.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 06 Jul 2026 19:02:49 +0800
X-CSE-ConnectionGUID: JFEAN1qiRCO0udeQq8/JSg==
X-CSE-MsgGUID: 2j/42uS4S+ic+K+4Flrh7g==
IronPort-SDR: 6a4b8b3b_va6S7SSEVMpfX7zcw4YDZwWwHwK9UT1Qh3ggBsCV+9Cf/2G
 x/YshRpdntbc2xDMoNhJlGQyBszZACjREnTJisg==
Received: from uls-op-esai2-o.wdc.com ([10.248.3.38])
  by uls-op-esad1-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Jul 2026 04:02:19 -0700
X-CSE-ConnectionGUID: bAfoFoTjSWOUdAB0uxOh1A==
X-CSE-MsgGUID: CITimRKzRVWFYdkzM789yw==
WDCIronportException: Internal
Received: from wdap-aswpwbowkq.ad.shared (HELO neo.fritz.box) ([10.224.26.2])
  by uls-op-esai2-o.wdc.com with ESMTP; 06 Jul 2026 04:02:18 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	stable@vger.kernel.org
Subject: [PATCH v3] btrfs: zoned: reset active_meta_bg on zone finish
Date: Mon,  6 Jul 2026 13:02:16 +0200
Message-ID: <20260706110216.232055-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

do_zone_finish() clears BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE and removes the
block group from zone_active_bgs, but only the pivot path in
check_bg_is_active() resets fs_info->active_meta_bg / active_system_bg.
Any other finish path (the async zone-finish endio work,
btrfs_zone_finish(), reclaim) then leaves active_meta_bg / active_system_bg
pointing at an inactive, fully written block group.

Reset the corresponding active_{meta,system}_bg pointer in do_zone_finish()
so it can never go stale.

Fixes: 13bb483d32ab ("btrfs: zoned: activate metadata block group on write time")
Cc: stable@vger.kernel.org
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
Changes to v2:
- Get reference to "tgt" inside check_bg_is_active() if it can actually
  vanish underneath us.

 fs/btrfs/zoned.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 97f06dd01693..fd578bef1f4f 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2213,6 +2213,7 @@ static bool check_bg_is_active(struct btrfs_eb_write_context *ctx,
 			}
 
 			/* Pivot active metadata/system block group. */
+			btrfs_get_block_group(tgt);
 			btrfs_zoned_meta_io_unlock(fs_info);
 			wait_eb_writebacks(tgt);
 			do_zone_finish(tgt, true);
@@ -2221,6 +2222,7 @@ static bool check_bg_is_active(struct btrfs_eb_write_context *ctx,
 				btrfs_put_block_group(tgt);
 				*active_bg = NULL;
 			}
+			btrfs_put_block_group(tgt);
 		}
 		if (!btrfs_zone_activate(block_group))
 			return false;
@@ -2535,6 +2537,7 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
 	const bool is_metadata = (block_group->flags &
 			(BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM));
 	struct btrfs_dev_replace *dev_replace = &fs_info->dev_replace;
+	struct btrfs_block_group **active_bg = NULL;
 	int ret = 0;
 	int i;
 
@@ -2632,6 +2635,20 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
 	/* For active_bg_list */
 	btrfs_put_block_group(block_group);
 
+	if (block_group->flags & BTRFS_BLOCK_GROUP_SYSTEM)
+		active_bg = &fs_info->active_system_bg;
+	else if (block_group->flags & BTRFS_BLOCK_GROUP_METADATA)
+		active_bg = &fs_info->active_meta_bg;
+
+	if (active_bg) {
+		btrfs_zoned_meta_io_lock(fs_info);
+		if (*active_bg == block_group) {
+			btrfs_put_block_group(block_group);
+			*active_bg = NULL;
+		}
+		btrfs_zoned_meta_io_unlock(fs_info);
+	}
+
 	clear_and_wake_up_bit(BTRFS_FS_NEED_ZONE_FINISH, &fs_info->flags);
 
 	return 0;
-- 
2.54.0

