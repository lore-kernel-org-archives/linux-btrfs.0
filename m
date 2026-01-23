Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD16312816
	for <linux-btrfs@vger.kernel.org>; Fri, 23 Jan 2026 08:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769156053; cv=none; b=E7U8asE6cJ5gajfOcIRzSIn2wmxrtNK7jpq8rs/OBTbUM89UcnvNNrkI2bjQnloNhgd9DGk4BSBECp5hyFEAAr63hbtVl3M0Z91y6H/v+2BTfxQ/on8EDupreyOosfLLFS+fx9m1sN4JZWcJEzZjk9d5TGsYTiU5NPPxDqlq+uM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769156053; c=relaxed/simple;
	bh=b7Sm9kY62o9vxJD9Q9w5pyCd7fjCSAa5oMNTlhaGoAU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Dx8jUceKc7Ix0qAy8ilk9ZltnpCC9pSG2UrwbKmCriX2LxBRDNM4jryznUWf3cKbaME30RgrrkxJ7IWyGa4NDxjsWG2UJ05DIu2DmxYrwnN0TxgzKtzdZfylIJfFdNRR7u/E/D3kXB0JTngbsmNt1/fC5NqWCxGP0TETZGvajow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=o3+l4tbB; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="o3+l4tbB"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1769156051; x=1800692051;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=b7Sm9kY62o9vxJD9Q9w5pyCd7fjCSAa5oMNTlhaGoAU=;
  b=o3+l4tbBCoVcX3INMnon3i+zz++oSe5nLf4GqWtC4YgQfPRabywYZvTx
   ROCJexy4hhJ0RHL4DVJAWLofm4hXatwPT0IyllNxNgNCpo8T87h8brtNV
   RaGzmKBU9ryk0OCFtlh31jVEo9ECn5Iu3OijpYoqyqE2621jaAnzK3CwI
   aUWV6bbmg8MWsljKz0ZjP20z15rCudLDQchERW14DEMG5X0lsmz3kXjA8
   hv8srj0KgS9MRhWwl3lf8KV6iEucHsxUqz7ONCnc33t+iPi2xnx+bzi7c
   IHFbS248t6DkJkwL/0gwYeoDjLyxDqod51r+Ht3jb89RcYCeAWP7gaqnp
   Q==;
X-CSE-ConnectionGUID: KJ8SS+7oTkyvRxXMiVx7TA==
X-CSE-MsgGUID: HisFooCGQrq4/ViNWCiUpA==
X-IronPort-AV: E=Sophos;i="6.21,248,1763395200"; 
   d="scan'208";a="139335834"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep03.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 23 Jan 2026 16:14:10 +0800
IronPort-SDR: 69732dd2_0K+L8GifpLhTnw12tXqV7O7Zd5ECfqDG2YgemmplPwdl3Ez
 MBTDNfgfu4pvyQDNO9WlhVNUH9233r7nRpmQqPw==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep03.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 Jan 2026 00:14:11 -0800
WDCIronportException: Internal
Received: from unknown (HELO neo.fritz.box) ([10.224.28.65])
  by uls-op-cesaip02.wdc.com with ESMTP; 23 Jan 2026 00:14:09 -0800
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH] btrfs: zoned: fix loading of DUP block-groups with mismatching alloc_offsets
Date: Fri, 23 Jan 2026 09:14:04 +0100
Message-ID: <20260123081404.473948-1-johannes.thumshirn@wdc.com>
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

This is another example, why we should only allocate metadata from
conventional block-groups as long as there are still enough left for
use.

 fs/btrfs/zoned.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 92e6a65b2f9d..f74bd9099d8a 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1450,11 +1450,19 @@ static int btrfs_load_block_group_dup(struct btrfs_block_group *bg,
 		return -EIO;
 	}
 
-	if (zone_info[0].alloc_offset == WP_CONVENTIONAL)
-		zone_info[0].alloc_offset = last_alloc;
+	if (zone_info[0].alloc_offset == WP_CONVENTIONAL) {
+		if (last_alloc == 0 && zone_info[1].alloc_offset != WP_CONVENTIONAL)
+			zone_info[0].alloc_offset = zone_info[1].alloc_offset;
+		else
+			zone_info[0].alloc_offset = last_alloc;
+	}
 
-	if (zone_info[1].alloc_offset == WP_CONVENTIONAL)
-		zone_info[1].alloc_offset = last_alloc;
+	if (zone_info[1].alloc_offset == WP_CONVENTIONAL) {
+		if (last_alloc == 0 && zone_info[0].alloc_offset != WP_CONVENTIONAL)
+			zone_info[1].alloc_offset = zone_info[0].alloc_offset;
+		else
+			zone_info[1].alloc_offset = last_alloc;
+	}
 
 	if (unlikely(zone_info[0].alloc_offset != zone_info[1].alloc_offset)) {
 		btrfs_err(fs_info,
-- 
2.52.0

