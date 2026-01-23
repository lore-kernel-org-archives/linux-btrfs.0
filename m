Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E43527FB3A
	for <linux-btrfs@vger.kernel.org>; Fri, 23 Jan 2026 12:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.143.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769172131; cv=none; b=Ocwn3XGaNUDLbpkUenZBumk3USVi1Kxz9QhGXg4KzMnVul93GbwWEKHtY82LIUJL+aQTr9bC54/nAboN+Hm4grk4J7jt1Tmc6f5bePq244rKgWOHPMi5E6d9O9rVbF5FKl7pooPheSK4nAYWS6zjAwq5AtVcDKc0ImGOY9nNkOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769172131; c=relaxed/simple;
	bh=Yrebee8Wppo8VRjKXHn5pniEdESXIoc/WeHwe3Pocx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MhnvPJp4nIKC8iAwfVMXi9lw5zBlS3JwWfrfF5TELv4mFvofxEwRJQjASoA5vBtimyhTeJqWolio2HYeKTsEMQJxr4iVWegCoukgzWRboR17wputqhw97hegy2eG5B04pqBoLOhIUeIRXq1d1fTU/6LnnLBGV3iyRv9HomdnMpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=KmBIhqrA; arc=none smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="KmBIhqrA"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1769172129; x=1800708129;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Yrebee8Wppo8VRjKXHn5pniEdESXIoc/WeHwe3Pocx4=;
  b=KmBIhqrABJZ3p6ilp4SiDTWFVO8ZPjjE5H5kjQN8n5lqjYlC0OOUtd2H
   Ljyza0bm62kbV1Tkhss5egRFH3wmnFque3c+11b4+1SoPfXt60zXHpxvB
   RWN5AyEzvO7r6YXNXrooUNKBfwcCbTfcuvfF8dyxFV+gVPUg7v+oGuk3f
   ePmD4/6phpHw/ui2CZqe/dAtTgqu74xZ4xuFyRbK4ck9A/n3VJaEBxc7R
   xo+jBikttNCDZZc1V4vrmYHFZK5zrmJ1CwNjmW0aJ6Umzm0RuH2Cycy73
   ob1LuPx4wO+t0mO7/fddHgwgOkrMeZA+R9P2TgcstTQiNJYgobZT1yT9Q
   Q==;
X-CSE-ConnectionGUID: itIO3jUtROuZ6M2jX0YUdA==
X-CSE-MsgGUID: KnwMCzbxSNKfrfbhgPhhJA==
X-IronPort-AV: E=Sophos;i="6.21,248,1763395200"; 
   d="scan'208";a="140524246"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep03.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 23 Jan 2026 20:42:04 +0800
IronPort-SDR: 69736c9d_AjWnJq+zIVV29hyj5CdJn0Exd1UmKPRo8NdxPZsZw89h/mj
 rdl95NmpCTOzcFw8R8aL3jgtLnsCLN5bZXIJu2g==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep03.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 Jan 2026 04:42:05 -0800
WDCIronportException: Internal
Received: from 5cg2075g8f.ad.shared (HELO naota-xeon) ([10.224.105.93])
  by uls-op-cesaip02.wdc.com with ESMTP; 23 Jan 2026 04:42:05 -0800
From: Naohiro Aota <naohiro.aota@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>
Subject: [PATCH 1/2] btrfs: zoned: fixup last alloc pointer after extent removal for DUP
Date: Fri, 23 Jan 2026 21:41:35 +0900
Message-ID: <20260123124136.4110463-2-naohiro.aota@wdc.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260123124136.4110463-1-naohiro.aota@wdc.com>
References: <20260123124136.4110463-1-naohiro.aota@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a block group is composed of a sequential write zone and a conventional
zone, we recover the (pseudo) write pointer of the conventional zone using the
end of the last allocated position.

However, if the last extent in a block group is removed, the last extent
position will be smaller than the other real write pointer position. Then, that
will cause an error due to mismatch of the write pointers.

We can fixup this case by moving the alloc_offset to the corresponding write
pointer position.

Fixes: c0d90a79e8e6 ("btrfs: zoned: fix alloc_offset calculation for partly conventional block groups")
CC: stable@vger.kernel.org # 6.16+
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
---
 fs/btrfs/zoned.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 714f45045c84..a10e1076c881 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1450,6 +1450,20 @@ static int btrfs_load_block_group_dup(struct btrfs_block_group *bg,
 		return -EIO;
 	}
 
+	/*
+	 * When the last extent is removed, last_alloc can be smaller than the other write
+	 * pointer. In that case, last_alloc should be moved to the corresponding write
+	 * pointer position.
+	 */
+	for (int i = 0; i < map->num_stripes; i++) {
+		if (zone_info[i].alloc_offset == WP_CONVENTIONAL)
+			continue;
+		if (last_alloc <= zone_info[i].alloc_offset) {
+			last_alloc = zone_info[i].alloc_offset;
+			break;
+		}
+	}
+
 	if (zone_info[0].alloc_offset == WP_CONVENTIONAL)
 		zone_info[0].alloc_offset = last_alloc;
 
-- 
2.52.0

