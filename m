Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D853E556C;
	Mon,  6 Jul 2026 06:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783318886; cv=none; b=LY8pO1OjAmipK1G7Sc+AH85DkJyB5wu2N524bmjRDgP4Dl3keTj9BptWhsI84IGC9TiRhwaLnSCM5WFZcsgkG48rMlNetZJCQkBus3b+EinnNtg9kC3UCVW8F/ux51IKek6AdYUDuKzd667Q8nQhtLJDWdOPInLc9MILQazrzWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783318886; c=relaxed/simple;
	bh=ikUhVQnTMJSopKB+F0E3cbUbMEJH4HzD7xnb+RxScpE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jHyVb8p+6f3xb79afA2PJatoswlFuEef9anwnsWGLf0K3yy/pLRTznWW9FX1koM1haUU3Znw4PtacC65JwYH2CV5zseNYyfMSb3TKEAQDmfjS3iDiRJPCYT1wX9w7tJBTsFcBU7OIV3VdwvX6OYUjkB9aqXNklvRs3oxZ8KMv9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=i/oAUghc; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="i/oAUghc"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1783318871; x=1814854871;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ikUhVQnTMJSopKB+F0E3cbUbMEJH4HzD7xnb+RxScpE=;
  b=i/oAUghcqdjykt1t2OWEBanJWBOKToGLwugrkTi54iW2J+z0E6dagRE9
   YFyIu9RL4wA+2PsTHqhhEAqtoIi36+e+e/gz0P4n4qFjsdrFONKv+n1iy
   3tMMDjT2KB/+hGtAWuegckGgb7SEP3RCht9Tg8L1vbTfxvoDQSdZbXR33
   v78QqG+KebeGs6lcpWZFzHh4u27UubegmWZUZQwXVpZbEkTjqnAGHFcEy
   fH/XmIofBwU7i7Qu1Hzs+tYKAX/L2K7Y6rjJTR0Hqi97QDJygHRIVT95Y
   34CGn5gS32sfAbnWWQSwnQWGvy5JXqk/OW0sQt+GRYUjyidAskePLwrxf
   A==;
X-CSE-ConnectionGUID: zOATdDcsQb+OPt9wTcTGUQ==
X-CSE-MsgGUID: ua2e7c58S2+c8ddnImppzA==
X-IronPort-AV: E=Sophos;i="6.25,149,1779120000"; 
   d="scan'208";a="148918923"
Received: from unknown (HELO uls-op-esad1-o.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 06 Jul 2026 14:21:05 +0800
X-CSE-ConnectionGUID: gkhxHh3ARwWjFSe3gf9feA==
X-CSE-MsgGUID: 5jCYt0xoSc+PhWgwIhtQDw==
IronPort-SDR: 6a4b4933_TWkLuEmIzLY8WyPwP800PJHJ73S6iZlMD02UpEPBPXol2BJ
 XpnxCfBFIC6go1Jd386txhvvdfkvSyAPRv7UGAA==
Received: from uls-op-esai2-o.wdc.com ([10.248.3.38])
  by uls-op-esad1-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Jul 2026 23:20:34 -0700
X-CSE-ConnectionGUID: 8fsGMs3+S9ez9gjdUWAwVw==
X-CSE-MsgGUID: sgOBpTsaRr2je19UD2pMAw==
WDCIronportException: Internal
Received: from wdap-aswpwbowkq.ad.shared (HELO neo.wdc.com) ([10.224.26.2])
  by uls-op-esai2-o.wdc.com with ESMTP; 05 Jul 2026 23:20:34 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] btrfs: zoned: reset active_meta_bg on zone finish
Date: Mon,  6 Jul 2026 08:20:31 +0200
Message-ID: <20260706062031.185284-1-johannes.thumshirn@wdc.com>
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
Changes to v1:
- Get reference to block-group before calling check_bg_is_active() to
  avoid possible UAF (sashiko).

 fs/btrfs/zoned.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 97f06dd01693..70997470fa84 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2270,6 +2270,7 @@ int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
 
 	if (block_group->meta_write_pointer == eb->start) {
 		struct btrfs_block_group **tgt;
+		bool active;
 
 		if (!test_bit(BTRFS_FS_ACTIVE_ZONE_TRACKING, &fs_info->flags))
 			return 0;
@@ -2278,7 +2279,12 @@ int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
 			tgt = &fs_info->active_system_bg;
 		else
 			tgt = &fs_info->active_meta_bg;
-		if (check_bg_is_active(ctx, tgt))
+
+		btrfs_get_block_group(*tgt);
+		active = check_bg_is_active(ctx, tgt);
+		btrfs_put_block_group(*tgt);
+
+		if (active)
 			return 0;
 	}
 
@@ -2535,6 +2541,7 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
 	const bool is_metadata = (block_group->flags &
 			(BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM));
 	struct btrfs_dev_replace *dev_replace = &fs_info->dev_replace;
+	struct btrfs_block_group **active_bg = NULL;
 	int ret = 0;
 	int i;
 
@@ -2632,6 +2639,20 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
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

