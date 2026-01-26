Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6985B22A4EB
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Jan 2026 05:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769406641; cv=none; b=A2/jcd881fRVERmtGMHlgH2mJbPoS4Yih7O4g86Q7EPbII/xaKxuTtRdwPBXUKhOumdSOUyP8LxMzTyj/7jPGIUKVaNvB3xSdoRRvwSXB1Qrq6YIQCJj/VWCdJejrHPqavHJon15MzmHHpOSjv3+h/GoroXvhdG3mXBn8zBqlaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769406641; c=relaxed/simple;
	bh=30B7JtCZG+sAiKahK/R1fm+w58MykB62NOgVPmsxC1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F/FT0GYUx+JimmxTS4G9THQ/dV9FjpnCTRjh8IYEwSU3rkjwoblTURVdmK6/uZci93VYRqaYEhxOOW4FEN3Yukk9vHCUjqsTx8yhty4S/QmIq9btIUDOwyXVtROWBYKWHj55XLDkH5PUZDQS7Qp+LJyaHMBzUry/9uhtGj+QUz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=KjhmlSkj; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="KjhmlSkj"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1769406640; x=1800942640;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=30B7JtCZG+sAiKahK/R1fm+w58MykB62NOgVPmsxC1g=;
  b=KjhmlSkjp7oqxxe0Q+Zh4RmBzzcBt9ph5bYsJAS+wSY9K2tQT1DarmW/
   4bTQOAemXnVqH9sFG3Q9xYilAWhaIB4SUreJUUOsvb8tKY6WdcFOT7kef
   B1Irudhf61Ku9QfS4VT3BRn8VpCB4MVKFKutt51rArJR7d2jGb+XFCmjB
   JHDjloCoTbPL9F75SCJ5TIJ8meXPLxHmrlSrQuCAqLnwrujpvEnsS64Kh
   CiQktpL7T7rB/f0HdhoJR+ZsdysGN8G5XAAJ5kjIQc3Ol/edEeA9cN+f0
   dosWaKhET/U7jY8iQkw3xQk0EsRs77J8sVpGVEjcJapSeZVDTlcYsBEas
   Q==;
X-CSE-ConnectionGUID: djTe03sCQGqzoJ5H790RlA==
X-CSE-MsgGUID: eLiGEjkGTsmTGt/NyKDCMQ==
X-IronPort-AV: E=Sophos;i="6.21,254,1763395200"; 
   d="scan'208";a="139468892"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep03.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 26 Jan 2026 13:50:32 +0800
IronPort-SDR: 697700a8_wVXZTV9wDeTZ1xeEfYnBHHw2cL3Q69FLXdfg+/aeCM0G87p
 djuzTBMS+kHaAtllQnDg6nllgbOlLfhTMhmpD/g==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep03.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Jan 2026 21:50:33 -0800
WDCIronportException: Internal
Received: from 5cg2075g8f.ad.shared (HELO naota-xeon) ([10.224.105.93])
  by uls-op-cesaip01.wdc.com with ESMTP; 25 Jan 2026 21:50:33 -0800
From: Naohiro Aota <naohiro.aota@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>
Subject: [PATCH v2 2/4] btrfs: add cleanup function for btrfs_free_chunk_map
Date: Mon, 26 Jan 2026 14:49:51 +0900
Message-ID: <20260126054953.2245883-3-naohiro.aota@wdc.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260126054953.2245883-1-naohiro.aota@wdc.com>
References: <20260126054953.2245883-1-naohiro.aota@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
---
 fs/btrfs/volumes.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index e4644352314a..8b88a21b16aa 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -633,6 +633,7 @@ static inline void btrfs_free_chunk_map(struct btrfs_chunk_map *map)
 		kfree(map);
 	}
 }
+DEFINE_FREE(btrfs_free_chunk_map, struct btrfs_chunk_map *, btrfs_free_chunk_map(_T))
 
 struct btrfs_balance_control {
 	struct btrfs_balance_args data;
-- 
2.52.0

