Received: from mail.burntcomma.com (mail2.burntcomma.com [217.169.27.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 649F327C866
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Feb 2026 14:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.169.27.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771425221; cv=none; b=GStUHhiGGTBgmWL9zukQazqGcSRBaV6rOKGGbW2u8/k8fdK2kP5Ntwp5aG46vVsIzBNGCipKDvHlNX1CNKZi87KGzWANUVAvjinktnOcsSP6q5b9hr1QHmJZtt0lUqvO0m4KOCg9yixI/d5Gg2BOjBDHLoxYBd1p7GN+l97c67I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771425221; c=relaxed/simple;
	bh=LYu0oKLpGthsrpQugk54mWx+qi6tvmMVPj8SwKijGwE=;
	h=From:To:Cc:Subject:Date:Message-ID:Mime-Version; b=H0POVVqGXftNdTV5OoyP3JlNtR7Ma8ldBY6HMJ2L6zSQ1lKInI030qdqh3oqJmnJuKOtoje+5I2gTz9Yhlm/CIlk5OJr5i18qdLCifXCxaQLWwd1RHkUV9+KEANpaw+y1PHvAMOOcJbTeb7x/ymWO4LHRXqBPWY3uZDILyr5hYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com; spf=pass smtp.mailfrom=harmstone.com; dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b=wB0ChZ74; arc=none smtp.client-ip=217.169.27.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=harmstone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b="wB0ChZ74"
Received: from beren (beren.burntcomma.com [IPv6:2a02:8012:8cf0:0:ce28:aaff:fe0d:6db2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.burntcomma.com (Postfix) with ESMTPSA id C746B3037AE;
	Wed, 18 Feb 2026 14:33:38 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=harmstone.com;
	s=mail; t=1771425218;
	bh=6D/GRXWD5K8LBKfkHRsZNfakLG2vtubO73roeSRoJ0k=;
	h=From:To:Cc:Subject:Date;
	b=wB0ChZ74sFKXWBpPb+QiuB8Epx4AsbksXba7v7ZHMpfhvWSFXfWzwN4WCb6kmJDZM
	 ZWE5IWE2KldaBuI8T2MWg1y/9xoJ07AYzbzCEJBCZLkCxJ0qoFcRWtKCeKnLc6Ws2v
	 dre6mjhVyb7gsr9rTWUG3JWLFw/bZV2nA5WR9e0Q=
From: Mark Harmstone <mark@harmstone.com>
To: linux-btrfs@vger.kernel.org
Cc: Mark Harmstone <mark@harmstone.com>,
	Chris Mason <clm@fb.com>
Subject: [PATCH] btrfs: fix chunk map leaks in btrfs_map_block()
Date: Wed, 18 Feb 2026 14:33:29 +0000
Message-ID: <20260218143334.25014-1-mark@harmstone.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix the two early returns in btrfs_map_block() so that we can no longer
fail to put the chunk map after getting it.

Signed-off-by: Mark Harmstone <mark@harmstone.com>
Reported-by: Chris Mason <clm@fb.com>
---
 fs/btrfs/volumes.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 83e2834ea273..a1f0fccd552c 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7082,7 +7082,7 @@ int btrfs_map_block(struct btrfs_fs_info *fs_info, enum btrfs_map_op op,
 
 		ret = btrfs_translate_remap(fs_info, &new_logical, length);
 		if (ret)
-			return ret;
+			goto out;
 
 		if (new_logical != logical) {
 			btrfs_free_chunk_map(map);
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

