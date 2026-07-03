Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A4235F5ED;
	Fri,  3 Jul 2026 05:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.143.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783058111; cv=none; b=bLAppVsJH1/6coz7gm2kRnEspRBAH31UMgsQ7lTaLkO6P1mzXbvycMQRI5zYk7W3jUDeJSOi48c3FXfG2EkwX9uzanlJETr39IvEqrRsNcHUOKa8q2FhQgSxkN1CBssOA+w7UIqan6HLv5LBV71Rcp2mOSAL3+/CwyspAFUQDLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783058111; c=relaxed/simple;
	bh=cpYDhPRBOsCHWtbvTGNcTpiU1B1Su3/m7lFW71xVwyY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=azZiGUxafqQCSyt11aDRYatOjXmJUT5CQWdEjikU3YirU5uj3p7EWx03rbxHcthLm8HHlOaPdYWlzK70FARWaVwX7fTL81q5STAZZA2qKJ4goFFM/XMrtF85Ogq3ounWhxDxz/tfASmn30/4gei8AleT3mSK7Ls3PRDrsyAi2ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=gp9siDt6; arc=none smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="gp9siDt6"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1783058109; x=1814594109;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=cpYDhPRBOsCHWtbvTGNcTpiU1B1Su3/m7lFW71xVwyY=;
  b=gp9siDt6vM8Y+Yug2hRk2t5XKqUWTi6AxT8tEe9bWxpvABPEYwUi88Aa
   Xm31pHon+DjI47pA4WwzoI6lQWDKW7t++insQ1UTpLx16vxPjSDH1KDj0
   ZL0N2N6THitNz3prB8ZvHbQrBFEOxdkqEfQu31N1WFjdspeRN/OkKkN9r
   k+P9U53Hu3yHaqQuw8ThS+BJnkjnBisj+Ap6f3havscIBf8Q8OHELbLpP
   TXUbF3w/2fm2UOdgQn8kQCH5LFlsVhIpPPipgot57cejRcUtiKInQxWKy
   JX+2FKEpqaHf68+sQpnSFhoU47NF5AtmULdbzaPvZawf3eXiH5VlKQcVN
   A==;
X-CSE-ConnectionGUID: 6Sg3KzSnRASH9e9oDGzY/Q==
X-CSE-MsgGUID: ml53/CyrTsibPQrNvxy4tA==
X-IronPort-AV: E=Sophos;i="6.25,145,1779120000"; 
   d="scan'208";a="151204828"
Received: from unknown (HELO uls-op-esad2-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 03 Jul 2026 13:55:00 +0800
X-CSE-ConnectionGUID: f/kO9TsSQyCXh5gQu3BavQ==
X-CSE-MsgGUID: TVykZTGER9qp/71qdC0UfQ==
IronPort-SDR: 6a474ea9_X/JTLXgyKfR2vuMdJVeZp9/dslx7Ye4zETVnoHhacDn3Dtj
 6Dsignny3kAohFYAOf0cXGCNuCCInRyNQffaxQg==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad2-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 02 Jul 2026 22:54:48 -0700
X-CSE-ConnectionGUID: Rzov4/oRRMGQDk6493+6fg==
X-CSE-MsgGUID: nDiOL+egSIWZfhVkGpzETw==
WDCIronportException: Internal
Received: from c02g32sfmd6m.ad.shared (HELO neo.wdc.com) ([10.224.28.132])
  by uls-op-esai1-o.wdc.com with ESMTP; 02 Jul 2026 22:54:48 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	stable@vger.kernel.org
Subject: [PATCH] btrfs: zoned: reset meta_write_pointer on zone reset
Date: Fri,  3 Jul 2026 07:54:45 +0200
Message-ID: <20260703055445.117214-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

btrfs_reset_unused_block_groups() resets a block group's zone and sets
alloc_offset back to 0 so the space can be reused, but it leaves
meta_write_pointer pointing at the previous end of the zone.

Once the block group is reactivated and reused for metadata, newly
allocated tree blocks live before that stale write pointer.
btrfs_check_meta_write_pointer() then sees them behind the write pointer,
so they can never be written out in sequential order: the dirty extent
buffers are stranded and pin their btree_inode folios until unmount.

Reset meta_write_pointer back to the start of the block group for
metadata and system block groups.

Fixes: 453a73c3069a ("btrfs: zoned: reclaim unused zone by zone resetting")
Cc: stable@vger.kernel.org
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index ab7c3cc52599..765655473263 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -3218,6 +3218,17 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
 		reclaimed = bg->alloc_offset;
 		bg->zone_unusable = bg->length - bg->zone_capacity;
 		bg->alloc_offset = 0;
+		/*
+		 * The zone was just reset to empty, so alloc_offset went back to
+		 * the start of the zone. For metadata/system block groups the
+		 * write pointer must follow it back to the start of the zone;
+		 * otherwise it stays stale at the previous (finished) zone end,
+		 * and metadata written into the reused zone would sit behind the
+		 * write pointer, could never be written out in sequential order,
+		 * and would be stranded (pinning its folio) until unmount.
+		 */
+		if (bg->flags & (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM))
+			bg->meta_write_pointer = bg->start;
 		/*
 		 * This holds because we currently reset fully used then freed
 		 * block group.
-- 
2.54.0

