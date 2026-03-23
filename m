Received: from mail.burntcomma.com (mail2.burntcomma.com [217.169.27.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AAA23C73E1
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2026 17:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.169.27.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774286854; cv=none; b=D1wxJ2qRk1kLSQ7Rm0BFjoJh+Jx/hqA5or69sKJZAt9Pb6fnPr89iM+5C+P+v41fZUrg/8fGNJquC9xJo9a7A44NufG2MtPMQTbe6mzGt/sGqiTw+SftWAzN2Lm2bN7Za94Tj1lZDvHCtsgNKlmWrgSVOyiKSqH67tQwCJ0eZN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774286854; c=relaxed/simple;
	bh=0QTENy73cfbSRGMBHLmqodMDkoTb6nuHdXFLMwMZfNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:Mime-Version; b=c5ksJlJ8c09BOkFC8kuRTtR0WNmpeQtqSpplrnIKqg+gKZhsceyPeVPYYMXFdNuh9HHsL+qObTNjw6iNoyaBGBU/1+Fog8me8zxlJYenNwLQYWNVANrpDn279fz57vyNrq351FkpvfcT66Tjcd6qHVPhhls5L/uA47d8Z3pGhKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com; spf=pass smtp.mailfrom=harmstone.com; dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b=2DGhf7NH; arc=none smtp.client-ip=217.169.27.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=harmstone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b="2DGhf7NH"
Received: from beren (beren.burntcomma.com [IPv6:2a02:8012:8cf0:0:ce28:aaff:fe0d:6db2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.burntcomma.com (Postfix) with ESMTPSA id 241CE313F96;
	Mon, 23 Mar 2026 17:27:30 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=harmstone.com;
	s=mail; t=1774286850;
	bh=ZfChC3RYWYUu2m8EoPU97YgE7NvL7VaaqCI81VUnRKY=;
	h=From:To:Cc:Subject:Date;
	b=2DGhf7NH1sIKM+raQjXZNczmLSc2NrQP3uvMIr9EV8NkKUtJ75mCBAatm3TjFuDH2
	 DQa4FLL3CzgzyLGaH7h4Gj6rh3OxhbVq1QWOmw4hoCGFxnUmbHN/Zg+9VANzgqcx/x
	 yDuVvVkSNbg0DPZbt+LmL1qjP5xrgzUiVUUpE2EU=
From: Mark Harmstone <mark@harmstone.com>
To: linux-btrfs@vger.kernel.org
Cc: Mark Harmstone <mark@harmstone.com>
Subject: [PATCH] btrfs: check remap-tree flags in btrfs_check_chunk_valid()
Date: Mon, 23 Mar 2026 17:27:23 +0000
Message-ID: <20260323172729.152556-1-mark@harmstone.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a check to btrfs_check_chunk_valid() that the METADATA_REMAP and
REMAPPED flags are only set if the REMAP_TREE incompat flag is also set.

Signed-off-by: Mark Harmstone <mark@harmstone.com>
---
 fs/btrfs/tree-checker.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 495d1dd61e66c2..f0152ccf95f680 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -999,6 +999,20 @@ int btrfs_check_chunk_valid(const struct btrfs_fs_info *fs_info,
 		}
 	}
 
+	if (unlikely((type & BTRFS_BLOCK_GROUP_METADATA_REMAP) &&
+		     !(features & BTRFS_FEATURE_INCOMPAT_REMAP_TREE))) {
+		chunk_err(fs_info, leaf, chunk, logical,
+		"METADATA_REMAP chunk type without REMAP_TREE incompat bit");
+		return -EUCLEAN;
+	}
+
+	if (unlikely(remapped &&
+		     !(features & BTRFS_FEATURE_INCOMPAT_REMAP_TREE))) {
+		chunk_err(fs_info, leaf, chunk, logical,
+		"REMAPPED chunk flag without REMAP_TREE incompat bit");
+		return -EUCLEAN;
+	}
+
 	if (!remapped &&
 	    !valid_stripe_count(type & BTRFS_BLOCK_GROUP_PROFILE_MASK,
 				num_stripes, sub_stripes)) {
-- 
2.52.0

