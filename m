Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D0D43CF21B
	for <linux-btrfs@vger.kernel.org>; Tue,  9 Jun 2026 11:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781006081; cv=none; b=q55EVrjIzk/ELE2AGCKhc9vQbM/PJQFW9qulPCqLrbvs573XR3NQQvn/u3Afo7aVAfBqI0uWdgrkl1Yr+eP6sxy5gwhnADa6ZZ34dCtTHPgr0cFbr+F0N0oCddXHgLAD+OY56rIiX0MpLlc3K+LxBgbpJRyUQ87NHyebveJj3Xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781006081; c=relaxed/simple;
	bh=et6WTotgNiMLPXi0qPpbQ3DX6HBXU/HjA94fDqFR02A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=luzHP78kD5i3XavKYb7xAbm3JH5rp3d1AfclafXjayE9cl03t2UMwgY3A25zlo6ajln6wCW8GWSqBgCj+Q3+PwMWR2IG6CWcMFZqmexfUUzdEU0hlvRO2dMdwRDPhObaI0Mfijw8Rcr7MpZG121ySn/VZnc+brkXsfdgl7wOeXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=A+6sZUaD; arc=none smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="A+6sZUaD"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1781006080; x=1812542080;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=et6WTotgNiMLPXi0qPpbQ3DX6HBXU/HjA94fDqFR02A=;
  b=A+6sZUaDmQcIh6w2ojDA4l4gzRQX56fEGJUlRxgAbGP8rFE1fFJBo491
   OYUIX+G/tuTdCAK6+CeVPZ2wSR6apxX7HayNF+cYLdt94t3SO7pG9ECV2
   ci6MljjSeZpC1BhFeFZa6shHxraf6uyoSwAd2+vN4jYBFXFhP5A8IucZY
   mU3gzd9uaLcvfG9oxeEPALXxJAieZb/RkhjyyVQZ8ZbxwBA3adsGF0fnF
   bxh8zIOH9HXonPcUuFYJknBVWgR9pmz1uBGPgxTts+FLVtnzXmdH9ZjNg
   Y47YRu1+jOMBffckXJPQoi0fj+TZv8A7xmrfDn4najKC8Z0t+RWwyAjl9
   A==;
X-CSE-ConnectionGUID: PejWqqzMRIa6fRpfjzQAwg==
X-CSE-MsgGUID: tbyNy7mRSTOrf5215PiXLQ==
X-IronPort-AV: E=Sophos;i="6.24,196,1774281600"; 
   d="scan'208";a="148753917"
Received: from unknown (HELO uls-op-esad1-o.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 09 Jun 2026 19:53:31 +0800
X-CSE-ConnectionGUID: s+OWMK/oSIeRvpZ7YS5YCA==
X-CSE-MsgGUID: Nl1hegZRSc65EMDleeNxzg==
IronPort-SDR: 6a27fe9d_vZnkuyy4owv8OA/QUVJJNCTj6mEwrMuhGa7Ca+yT7+Q1QAL
 EfxYrcXs70tVAYKsYTPUOcUR21zt1t9ZLa9ftOw==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad1-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 Jun 2026 04:53:01 -0700
X-CSE-ConnectionGUID: C1EUeNngQASbUZHU7ucJ1Q==
X-CSE-MsgGUID: +Lva0HLDRvKitqV8eVR+2Q==
WDCIronportException: Internal
Received: from wdap-5u5psmua2u.ad.shared (HELO neo.wdc.com) ([10.224.28.85])
  by uls-op-esai1-o.wdc.com with ESMTP; 09 Jun 2026 04:52:59 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Johannes Thumshirn <joahnnes.thumshirn@wdc.com>
Subject: [PATCH] btrfs: zoned: fix assertion in btrfs_zoned_reserve_data_reloc_bg
Date: Tue,  9 Jun 2026 13:52:51 +0200
Message-ID: <20260609115251.49325-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove the assertion that we've have a non-empty block-group list because
we've picked the 2nd empty block-group. It's not valid anymore.

Fixes: 06e6e8cc17bd ("btrfs: zoned: always set data_relocation_bg")
Singed-off-by: Johannes Thumshirn <joahnnes.thumshirn@wdc.com>
---
I have no idea why fstests didn't catch that trivial bug...
Anyways needs to be folded in
---
 fs/btrfs/zoned.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 0f87701e38e3..97f06dd01693 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2813,8 +2813,6 @@ void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info)
 
 			down_write(&space_info->groups_sem);
 			list_del_init(&bg->list);
-			/* We can assume this as we choose the second empty one. */
-			ASSERT(!list_empty(&space_info->block_groups[index]));
 			up_write(&space_info->groups_sem);
 
 			spin_lock(&space_info->lock);
-- 
2.54.0

