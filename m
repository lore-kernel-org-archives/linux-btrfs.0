Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C674A35FF5B
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Jun 2026 09:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781859754; cv=none; b=dPq38kd2v+Rd3JSX2LAXvpvQoS0IPadN+ChB9hI4CI4hWnU8lvwMo+Th1PdvfnwlxYkYxV/8ItGB4ADlrYW33/pscBqeGK/G0r33IQSnZUIxCc11Ep7bBENa4yNR2Q1zVZ5DwyJD8lBu3A8a9wLBfJJT+0SvBjxpBDhTkJuL38I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781859754; c=relaxed/simple;
	bh=b1f6mWZ2vGreKKSPJ/26uEX2gvnS/6kpVKKCp7jugdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c+kMScFORm28uSzPoczBCVdKWTBJtc2qrwVud6FHcF3kKQD3L/5s9yK4y/i+tIYoJSJElVviN6HTUs6xMrY+7rp559wDWRrzPa6MNnnyVvFVw2aKIouKbzSyr3n+66dwINHBPWf2kep/LOfvxxgoZGoRU9Z+PgI09WbaM4HTuY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=D8uGBTBA; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="D8uGBTBA"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1781859752; x=1813395752;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=b1f6mWZ2vGreKKSPJ/26uEX2gvnS/6kpVKKCp7jugdM=;
  b=D8uGBTBAlh87aEkqkmRrAbLo2HAUVWUxXL+j9ORGechpJbANkHQDaPNS
   lplxFD9POBUQNO3pbPj4bzfGPLSP8zZhpzJoso2Ms2E4U6TRUcbl4Q0K1
   kNBhvSXuBrkwiZM/n+k4c3lzYds2NI0rIDX+sjDCSF0W/2yuc9MHkkOpv
   mTSEIZFgtBdj+4vN0q3HGp/7Q9A/2nvSvcKxvPABzSXULA+Rxt6kljLPr
   oYIl+uVFo0eQwEhEk9zmBkuchj0jfEwfH2+P4EtoKUJqggf0PG962nhSX
   gZZt6Qd1nUZ70Iplg8RtjSJcSWyRFAksn9c67wEKzw3N/+P5ZqNF6R7+d
   g==;
X-CSE-ConnectionGUID: QaLqGeewT4WWnWc0/ful/g==
X-CSE-MsgGUID: JqriNg4vQIeUtlWgh3gfkQ==
X-IronPort-AV: E=Sophos;i="6.24,213,1774281600"; 
   d="scan'208";a="147951276"
Received: from unknown (HELO uls-op-esad1-o.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jun 2026 17:02:27 +0800
X-CSE-ConnectionGUID: DNwDJYOtQ1yH1fga8grVDw==
X-CSE-MsgGUID: lSKIQ2mXR6OZuNTUNusfXA==
IronPort-SDR: 6a35059e_h4aCRIf1+0E2OQe/jSUU/7B/2nrAJn1ZAPOUgqmKZEyOnM0
 pJ/qKcYaFIDXVi2IRKPypHAaYdBQ/qFF2v/w3mA==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad1-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Jun 2026 02:02:22 -0700
X-CSE-ConnectionGUID: 5JTpON73S36Kyw0BMhxAsw==
X-CSE-MsgGUID: k8WqYdA0RLSYHtoZbkvpCg==
WDCIronportException: Internal
Received: from wdap-62juwqezoj.ad.shared (HELO neo.fritz.box) ([10.224.19.3])
  by uls-op-esai1-o.wdc.com with ESMTP; 19 Jun 2026 02:02:22 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [RFC 07/15] btrfs: don't call into regular raid56 if we're using RST
Date: Fri, 19 Jun 2026 11:02:02 +0200
Message-ID: <20260619090211.497100-8-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260619090211.497100-1-johannes.thumshirn@wdc.com>
References: <20260619090211.497100-1-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a RAID5/6 block-group is backed by the raid-stripe-tree the data and
parity stripes are mapped and submitted via the stripe-tree, not the
classic raid56 logic. Skip the regular RAID56 submission path for these
bios by testing bioc->use_rst.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/bio.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
index cc0bd03048ba..a16d11c6e251 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -577,7 +577,8 @@ static void btrfs_submit_bio(struct bio *bio, struct btrfs_io_context *bioc,
 		bio->bi_private = smap->dev;
 		bio->bi_end_io = btrfs_simple_end_io;
 		btrfs_submit_dev_bio(smap->dev, bio);
-	} else if (bioc->map_type & BTRFS_BLOCK_GROUP_RAID56_MASK) {
+	} else if (bioc->map_type & BTRFS_BLOCK_GROUP_RAID56_MASK &&
+		   !bioc->use_rst) {
 		/* Parity RAID write or read recovery. */
 		bio->bi_private = bioc;
 		bio->bi_end_io = btrfs_raid56_end_io;
-- 
2.54.0

