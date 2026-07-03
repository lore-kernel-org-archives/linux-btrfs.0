Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA7CD385D6B;
	Fri,  3 Jul 2026 08:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783068469; cv=none; b=NH2n10zq+XZSiR24HEE7mir205ZqZjsm34Kbks7O577IhG9RylfN2vtByvxpGT8iombHMWMaQ85+2NWPaglFjoS0o/HDXLxWJZMqSdnvLQeds4dzW8dN8sw09N+W6iz+iPnP9/OBEB+Vr/yqpONXO8WCb1BEw4Usjc3M48u+leY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783068469; c=relaxed/simple;
	bh=w0fsexi7MXFeOO/xpoXkxYO8P4fqzMLwCCWXGi46M7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ljhewm8b+0OUUV1rGU9AbsogcDtpYrHqiE+of70gjN56wDCCMrNlJFLrt3jp4c+4VJOv0T40w0wSywVjw5s9cGEI2lB5Kit+1FyiDMR2JwQhlshlrUJOM7LUOaRQQPn64n1UamrqfeFmBv50qiIuoOL5hmc/j/qM9eRJ3BquwTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=A8FNESOM; arc=none smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="A8FNESOM"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1783068468; x=1814604468;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=w0fsexi7MXFeOO/xpoXkxYO8P4fqzMLwCCWXGi46M7Y=;
  b=A8FNESOMHLIXM12GNLSRqC1EujAR8+gve0isWguvV6khXWhVHknMUFyL
   CMo/w1dhRdTnw1kLBBKxXfXBI03GoqQeJFW/wF6nSmrHNE4l1iZ9ZAxjT
   fMuk8rnIGElwQlvbmlmLg3ILEqeB3xFeiWbUef6mTNygXmOQT5HvGTsle
   3088LmSuncHsVDMfXtLO6jhrK5kNpxkcQvxcrJZCZrxdgZJJCIqZZZ6LG
   USp3G5QfMllxsD2L9HwI+pbcHhdVIevwxRHEWepxzvyzQA4ea5yz6Iamm
   W7sfdrDx2KjCAxUjIunWEMjw0UbMNx+XJTz8vzlSgZYZnVBZnR5UWCWXj
   A==;
X-CSE-ConnectionGUID: nLx0nX/aT+ad1jWYn8yufQ==
X-CSE-MsgGUID: NTYvehg9QBmEJ0bIWLh/dw==
X-IronPort-AV: E=Sophos;i="6.25,145,1779120000"; 
   d="scan'208";a="146156545"
Received: from unknown (HELO uls-op-esad1-o.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 03 Jul 2026 16:46:39 +0800
X-CSE-ConnectionGUID: 2o3jtba8QFqyvKqxWNpalg==
X-CSE-MsgGUID: wX43H3AhT1yyKFrVBqOyCg==
IronPort-SDR: 6a4776ca_389QZrYmFe4dZYXsDIK0pkMFQu7PAIunTztzKA8HaEuGvvg
 WJ9y0n/AnLRpQ9ftY6HQnpIZh+Be+ZivmtCNt1w==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad1-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 03 Jul 2026 01:46:02 -0700
X-CSE-ConnectionGUID: Y3VWgAeaRiuXi/yd5oSxAA==
X-CSE-MsgGUID: /2b9ukckQzqgzNxkr+o39w==
WDCIronportException: Internal
Received: from wdap-kpvfcmq4pw.ad.shared (HELO neo.wdc.com) ([10.224.28.134])
  by uls-op-esai1-o.wdc.com with ESMTP; 03 Jul 2026 01:46:01 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	stable@vger.kernel.org
Subject: [PATCH] btrfs: zoned: reset active_meta_bg on zone finish
Date: Fri,  3 Jul 2026 10:45:59 +0200
Message-ID: <20260703084559.136605-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

do_zone_finish() clears BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE and removes the
block group from zone_active_bgs, but only the path in
check_bg_is_active() resets fs_info->active_meta_bg / active_system_bg.
Any other finish path leaves active_meta_bg / active_system_bg pointing
at an inactive, fully written block group.

Reset the corresponding active_{meta,system}_bg pointer in do_zone_finish()
so it can never go stale.

Fixes: 13bb483d32ab ("btrfs: zoned: activate metadata block group on write time")
Cc: stable@vger.kernel.org
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 44a13ed6b8b2..c8c850de1702 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2539,6 +2539,7 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
 	const bool is_metadata = (block_group->flags &
 			(BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM));
 	struct btrfs_dev_replace *dev_replace = &fs_info->dev_replace;
+	struct btrfs_block_group **active_bg = NULL;
 	int ret = 0;
 	int i;
 
@@ -2636,6 +2637,20 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
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

