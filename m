Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD1C3B47CB
	for <linux-btrfs@vger.kernel.org>; Fri, 22 May 2026 09:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779440595; cv=none; b=mzbPlyCkR2VR7Oncxce/301xPX4Z/kw/41Zr/6nANDC8zNJ/EAuyWIXCqhmeOzQArhsVQ481faDjcJ6d6y6rdACotL8qn0/ClFwFs9PMCeUFNEGK5BRTH/BZORxVX6HEYdDSljl93nRB6sjx7tTs5IJCIux/ZtNmyOtMZFWeFtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779440595; c=relaxed/simple;
	bh=U/N0nBTZOO5vlatdpgDs+jt3pEySzf1xCxNn0CkQoR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o4xfBSGKXgpx17JQBZT+O6c34I1v0N/W5Ma+eyHAoE7KRMNsvYihZs2O8cQ0tGo8LVIbbdnFgggA4/oO6SZ4xjLhdPSXIvEBhbRxO8m06IUSXRrFnoLzP1cQr8GjV3BYtMvrPY28yCR5SRkR/fXdMT8g1OZ3lEQTULQHsoRYZS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=inTw6/04; arc=none smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="inTw6/04"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1779440595; x=1810976595;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=U/N0nBTZOO5vlatdpgDs+jt3pEySzf1xCxNn0CkQoR0=;
  b=inTw6/04g7XSD7SMdRLaMtJk7yLOjN+dwDYelbQOAFIL1xq3Gtb32V45
   CfcNHqnN+z7suG//pxBzyzgEuH/r2BLxrouoEcofWyeDhXdh/AGStYevR
   Zg//eULII2Y+QgiCDd1kuhNp7fSXpA8eXAiZRXeDOJ4wz0RERe+unA4M8
   VEkABhrxThTaE4byxDM5LEJj+R7t3HVHcT4eB8QNUhJMAZOufmioreigf
   Vx2hYbQvtQM5X9ZUbwSNpWRPgVNB+ELEBIH1Mm7ljePcyKSsfQRwCnXAx
   FlZzQx1akZgjKz5cCUKlhSfggVJgwvybsR1pYEBhItrkxXpzwM3yjdKkx
   w==;
X-CSE-ConnectionGUID: AqXsZMnsS1qEMIzAVQkKOA==
X-CSE-MsgGUID: muHztfN6TPujIOys4UlSoQ==
X-IronPort-AV: E=Sophos;i="6.24,162,1774281600"; 
   d="scan'208";a="147475595"
Received: from unknown (HELO uls-op-esad1-o.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 22 May 2026 17:03:08 +0800
X-CSE-ConnectionGUID: Et/9aVXnQZygkiaV1Qd7CQ==
X-CSE-MsgGUID: ADJw13+HS2SWh8WQbgR1Hg==
IronPort-SDR: 6a101bcb_OdGfTUazRckC+KkyaI1/dh3Fpznzs47PmCB3KdJ9oCZoygO
 5x/SZbhd0H18e/evAg5JkcWnraf0R4UZk7X8CYg==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad1-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 22 May 2026 02:03:06 -0700
X-CSE-ConnectionGUID: 05AoVYfKRJWm90/Dx/E33A==
X-CSE-MsgGUID: SXVrRMXRRCOfAbplnIec2g==
WDCIronportException: Internal
Received: from wdap-b6euub3vgq.ad.shared (HELO neo.wdc.com) ([10.224.19.8])
  by uls-op-esai1-o.wdc.com with ESMTP; 22 May 2026 02:03:04 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Hans Holmberg <Hans.Holmberg@wdc.com>,
	Boris Burkov <boris@bur.io>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v3 3/5] btrfs: zoned: always set data_relocation_bg
Date: Fri, 22 May 2026 11:02:45 +0200
Message-ID: <20260522090247.27445-4-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260522090247.27445-1-johannes.thumshirn@wdc.com>
References: <20260522090247.27445-1-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When searching for a data relocation block-group on mount,
btrfs_zoned_reserve_data_reloc_bg() is looking for the first empty DATA
block-group. But it first checks if the block-group is empty and if yes
continues the search, and then checks if it is the first DATA block-group.

There is actually no point in looking for the second empty DATA block
group as new DATA allocations will just allocate a new chunk for it. Pick
the first DATA block-group without any allocations done and set it as
relocation block-group.

Singed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 16dd87aa06f2..a4d2fb774f72 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2763,7 +2763,6 @@ void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info)
 	struct btrfs_block_group *bg;
 	struct list_head *bg_list;
 	u64 alloc_flags;
-	bool first = true;
 	bool did_chunk_alloc = false;
 	int index;
 	int ret;
@@ -2784,13 +2783,9 @@ void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info)
 again:
 	bg_list = &space_info->block_groups[index];
 	list_for_each_entry(bg, bg_list, list) {
-		if (bg->alloc_offset != 0)
-			continue;
 
-		if (first) {
-			first = false;
+		if (bg->alloc_offset != 0)
 			continue;
-		}
 
 		if (space_info == data_sinfo) {
 			/* Migrate the block group to the data relocation space_info. */
@@ -2849,7 +2844,6 @@ void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info)
 		 * We allocated a new block group in the data relocation space_info. We
 		 * can take that one.
 		 */
-		first = false;
 		did_chunk_alloc = true;
 		goto again;
 	}
-- 
2.54.0

