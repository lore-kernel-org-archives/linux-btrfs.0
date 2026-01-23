Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB8434405F
	for <linux-btrfs@vger.kernel.org>; Fri, 23 Jan 2026 08:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769156082; cv=none; b=Vz0PrxRxMp8QZv/dIXDp727GCAq2WLdIY81/X7KYM1H0e7VJnMVz62oDxIS3Y/fsOZOyy1vzC62j9AxORGm5mIe2qxMQ38XvvfpnqruGLjbZNEQTqc78gg+5W9DSOblABh9HsTXxG0czmnYLaPeZFDPvMS3PFt1oYMyqcLjgXV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769156082; c=relaxed/simple;
	bh=abCu5VWLnJRWz7CswJ4q7NxtKPtJA7Gxu94pu3xj+VI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=T9fZfDAaiTJOjydBI8fL5zJp4TOr2Ke9J6fPu5g6rkAve3UTJ6BaqM3DrgjrFnAILDx+llPZcuN1M5oK0rquas8MKgAkLS6hNFkVoq3ENh5w/yPvEmCIaI3gx0LDBVAOfaxsR+6sk2qXV1h/ydHhYO/kHBgfp0VKadxXg0BfWLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Dqh2zM16; arc=none smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Dqh2zM16"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1769156081; x=1800692081;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=abCu5VWLnJRWz7CswJ4q7NxtKPtJA7Gxu94pu3xj+VI=;
  b=Dqh2zM16md9XbtpjZVFLCNK9XW4qFuBTly5ovY221imrrQIvNQlChWAu
   LUQeob28GQTFSGe3eoN+uXBKOCQc++5FomzxTiB0XHw1wCjFPJGeua2nb
   Vs7PwvQYdgAyf541Kos7fCe5hyH7QPxVHvgvuCsMh2AbuyM5GSTt58i7I
   PVGgrxkiQSOOzCMJFmksTj9tJCH1UkKjIJNC7T2FIdJUAxSN4sG9rMlGH
   N1H7lwOn8CHwAgb7Dy0Y3lxtjIwEX8/F+LNVtDAknuZfzG6rLlCzR5Jdk
   GEFsNKgtnOIlFz1IPpXVt+FyZAsd/oRg758oybn/OCAU6L74Ook3OUjyu
   g==;
X-CSE-ConnectionGUID: 10SLQpZ/QRuf1IbFv3ikRQ==
X-CSE-MsgGUID: IFgrr37ARlCLCx+u6PpRtw==
X-IronPort-AV: E=Sophos;i="6.21,248,1763395200"; 
   d="scan'208";a="139075300"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 23 Jan 2026 16:14:34 +0800
IronPort-SDR: 69732dea_hMG5f0TZ9J7QEImSzUGBSlUsg4RSNLjIysuBnPXiiaIEJGU
 OF9c7uoeshhGLrRK6L1zJ6Vm0uRRkLG+jVLRXtA==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 Jan 2026 00:14:34 -0800
WDCIronportException: Internal
Received: from unknown (HELO neo.fritz.box) ([10.224.28.65])
  by uls-op-cesaip02.wdc.com with ESMTP; 23 Jan 2026 00:14:32 -0800
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH] btrfs-progs: zoned: fix loading of DUP block-groups with mismatching alloc_offsets
Date: Fri, 23 Jan 2026 09:14:28 +0100
Message-ID: <20260123081428.473986-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When loading DUP block-groups where one of the backing zones is on a
conventional zone and one is on a sequential zone,
btrfs_load_block_group_dup() returns with -EIO as the allocation offsets
of both block-groups differ.

In case only one zone is conventional and the other zone is sequential,
set the alloc_offset to the write pointer location of the sequential
zone.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 kernel-shared/zoned.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/kernel-shared/zoned.c b/kernel-shared/zoned.c
index b2e14f1d5999..18fb7eb511d3 100644
--- a/kernel-shared/zoned.c
+++ b/kernel-shared/zoned.c
@@ -1011,10 +1011,19 @@ static int btrfs_load_block_group_dup(struct btrfs_fs_info *fs_info,
 		return -EIO;
 	}
 
-	if (zone_info[0].alloc_offset == WP_CONVENTIONAL)
-		zone_info[0].alloc_offset = last_alloc;
-	if (zone_info[1].alloc_offset == WP_CONVENTIONAL)
-		zone_info[1].alloc_offset = last_alloc;
+	if (zone_info[0].alloc_offset == WP_CONVENTIONAL) {
+		if (last_alloc == 0 && zone_info[1].alloc_offset != WP_CONVENTIONAL)
+			zone_info[0].alloc_offset = zone_info[1].alloc_offset;
+		else
+			zone_info[0].alloc_offset = last_alloc;
+	}
+
+	if (zone_info[1].alloc_offset == WP_CONVENTIONAL) {
+		if (last_alloc == 0 && zone_info[0].alloc_offset != WP_CONVENTIONAL)
+			zone_info[1].alloc_offset = zone_info[0].alloc_offset;
+		else
+			zone_info[1].alloc_offset = last_alloc;
+	}
 
 	if (zone_info[0].alloc_offset != zone_info[1].alloc_offset) {
 		btrfs_err(fs_info,
-- 
2.52.0

