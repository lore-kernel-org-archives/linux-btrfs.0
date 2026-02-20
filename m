Received: from mail.burntcomma.com (mail2.burntcomma.com [217.169.27.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5116F32D0EE;
	Fri, 20 Feb 2026 13:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.169.27.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771592540; cv=none; b=BCdog77wU7MhgXJQOCP4lFCVtsEUNcFALDT14TofQpKtvDk7nbr3kpvkgJyCpHpULgPj5Rje5b/DC5AabwnfIpHD0x1y3cLC0fFzBlNm1IxKTpwGEf7zkNz6vOughHT4sI/cP7x3LZgNljEq6w3urfHw/HYrj7fzJ1rC6LaZt4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771592540; c=relaxed/simple;
	bh=wqbcgzsIjkL1gdjoB4Y2V71ysOUwr8RE+kXxQOVrs3c=;
	h=From:To:Cc:Subject:Date:Message-ID:Mime-Version; b=attkGiaR9f4SuBluJQTq0Krsyep8zJ9AIqiWF6QjJTdXZ9zNX1+cgITuuqEyNdryIuTS4Dkl+g6dD/c8oUXtC9lAuGaFlw0auHk7OrSwlgoIVhEddz83FShlZc5FsUx3n41Y/qyFzMqEeVravBqOUexK7Woq2Fiw84/jztQR/TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com; spf=pass smtp.mailfrom=harmstone.com; dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b=Q1uSW4CK; arc=none smtp.client-ip=217.169.27.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=harmstone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b="Q1uSW4CK"
Received: from beren (beren.burntcomma.com [IPv6:2a02:8012:8cf0:0:ce28:aaff:fe0d:6db2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.burntcomma.com (Postfix) with ESMTPSA id 6DC513046C0;
	Fri, 20 Feb 2026 13:02:16 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=harmstone.com;
	s=mail; t=1771592536;
	bh=1M+N2jFeIV8nCRhpE07Jq2S9IKdqdYpMLIbYiHTQbMA=;
	h=From:To:Cc:Subject:Date;
	b=Q1uSW4CKX+SUeXOUFCExSYqL4jUJWhLFo/SGtDgBWUDw1y20MZBCfOMgnaJUPrNfT
	 SzLHiXZmTVIw9JtqfkVAcRXcUKL7H2Kucfk3C5SFgiI9PfTZRwVZTtvMeePmiRmsaj
	 3rU046SfWRLwfcoKyiXC6AbHtJiyQQetZS3w8HLQ=
From: Mark Harmstone <mark@harmstone.com>
To: linux-btrfs@vger.kernel.org,
	johannes.thumshirn@wdc.com,
	fdmanana@kernel.org
Cc: Mark Harmstone <mark@harmstone.com>,
	stable@vger.kernel.org
Subject: [PATCH] btrfs: fix chunk map leak in btrfs_map_block() after btrfs_chunk_map_num_copies()
Date: Fri, 20 Feb 2026 13:01:50 +0000
Message-ID: <20260220130209.5020-1-mark@harmstone.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix a chunk map leak in btrfs_map_block(): if we return early with -EINVAL,
we're not freeing the chunk map that we've just looked up.

Signed-off-by: Mark Harmstone <mark@harmstone.com>
Cc: stable@vger.kernel.org
Fixes: 0ae653fbec2b ("btrfs: reduce chunk_map lookups in btrfs_map_block()")
---
 fs/btrfs/volumes.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 1bd3464ccdd8..a1f0fccd552c 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7096,8 +7096,10 @@ int btrfs_map_block(struct btrfs_fs_info *fs_info, enum btrfs_map_op op,
 	}
 
 	num_copies = btrfs_chunk_map_num_copies(map);
-	if (io_geom.mirror_num > num_copies)
-		return -EINVAL;
+	if (io_geom.mirror_num > num_copies) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	map_offset = logical - map->start;
 	io_geom.raid56_full_stripe_start = (u64)-1;
-- 
2.52.0

