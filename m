Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5C335F607
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Jun 2026 09:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781859756; cv=none; b=JnpmNRvtlWNwDtbtUEJzRFq7Dzkrd1J0HS3+3KrgnTFaTpbOw28vx7Jhc/3BPX1a6ToxZaFT96R+wVj7aHJPMrJJR/4qd5MWuXBzNJg95uyv55f4FXdZnYTqeEt58+DZX5FN4wZyDUFfvrhyIXqteYLCXV/gGtuM5vDOkuhtnpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781859756; c=relaxed/simple;
	bh=QYgQtEBqxFeTRC9ZUSy8ZDzbF6YzXshMLSvIhMNx/7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DsEgH31abx3ULutx2SDhUIHwk5NPJhen2W/AfgscBlk0x2uj16twvP9cpJUsr/bsq2BAB3/dz7YQ+hOgNKYkKvM8lIvW3Z2w79nydz0OYTS5jh42g/spE/DccWOXC9MfKq3mCt8OwLmT7T4UGJIfYw2TVnSrrtX8VRUS3qrzUDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=C+f4xivY; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="C+f4xivY"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1781859754; x=1813395754;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QYgQtEBqxFeTRC9ZUSy8ZDzbF6YzXshMLSvIhMNx/7E=;
  b=C+f4xivYtiTXUuYPr6lg+kFBFEVtJGNgmryG0Eb+mqGWEMXHu3zxnCAb
   A1bgL5amOjpCeoc7cXIAdQQJ5kmTdbWwPlR4FmG6+q1z8KCZ3zvbtXZky
   fEGaMx2DU/wEs3SqYE/jqLWpWJv/lHXMV0I2x6QP3lrO1Fr7hjCHFnV7Q
   H7GTaEbBJW6HhtAMP4HUZkFgwP+Nkd1mWqNq+blclDySCaWCSsxaybTEv
   CKMpJizGyk0u2GRGWw3XLnyMu6J4A5PiG8OxrAHNmV4NMsf4T2BNOzmzR
   fVkVPwIasg58ymB60Uuur3Uw58Zs/ybWc3ovOM4opXoEs07tkBtVDk1lm
   g==;
X-CSE-ConnectionGUID: moZEX7aTRRulKyAQYCU62w==
X-CSE-MsgGUID: zr0CbD2fS1uWzS2yxYN3QA==
X-IronPort-AV: E=Sophos;i="6.24,213,1774281600"; 
   d="scan'208";a="147951279"
Received: from unknown (HELO uls-op-esad1-o.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jun 2026 17:02:27 +0800
X-CSE-ConnectionGUID: QRMz5uGXTlObZMkHNKytUQ==
X-CSE-MsgGUID: m8HODei8Q12Xgl2fuY+OiQ==
IronPort-SDR: 6a3505a2_G6qsdqCl6WldXmtge2xPskKK7W7RUbTN7KnccdllKO4+DyM
 Fq9wh34qWDyZ1cKrj6UcEauRYeNTzUGpW4v+dXg==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad1-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Jun 2026 02:02:26 -0700
X-CSE-ConnectionGUID: 99wyiJtsSXG9IGEcQ8/9Bg==
X-CSE-MsgGUID: cYlu89/uSPm6Jd/Ts9mI0A==
WDCIronportException: Internal
Received: from wdap-62juwqezoj.ad.shared (HELO neo.fritz.box) ([10.224.19.3])
  by uls-op-esai1-o.wdc.com with ESMTP; 19 Jun 2026 02:02:25 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [RFC 10/15] btrfs: fix RAID stripe-tree lookup across leaf boundaries
Date: Fri, 19 Jun 2026 11:02:05 +0200
Message-ID: <20260619090211.497100-11-johannes.thumshirn@wdc.com>
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

A stripe-tree lookup resolves the stripe extent containing a logical
address by searching for that address and stepping back to the preceding
item, since the containing extent begins at or before it. That step-back
was confined to a single leaf, so when the search landed on the first
slot of a leaf the containing extent - the last item of the previous
leaf - was never examined and a perfectly valid address returned
-ENODATA.

The flaw stayed latent while lookups were stripe-aligned and the tree
fit in one leaf. RAID5 relocation breaks both assumptions: it issues
non-stripe-aligned reads against a stripe tree large enough to span
several leaves, so the read fails, the data-reloc inode folio cannot be
made uptodate, and balance aborts with -EIO. Step back to the previous
item of the requested type instead, which crosses the leaf boundary
correctly and skips unrelated items such as the parity stripe.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/raid-stripe-tree.c | 31 ++++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/raid-stripe-tree.c b/fs/btrfs/raid-stripe-tree.c
index ebf416281274..30ea066161f6 100644
--- a/fs/btrfs/raid-stripe-tree.c
+++ b/fs/btrfs/raid-stripe-tree.c
@@ -450,13 +450,30 @@ static int btrfs_get_raid_extent(struct btrfs_fs_info *fs_info,
 	ret = btrfs_search_slot(NULL, stripe_root, &stripe_key, path, 0, 0);
 	if (ret < 0)
 		return ret;
-	if (ret) {
-		if (path->slots[0] != 0)
-			path->slots[0]--;
-
-		btrfs_item_key_to_cpu(path->nodes[0], &found_key, path->slots[0]);
-		if (found_key.type != type && path->slots[0] > 0)
-			path->slots[0]--;
+	if (ret > 0) {
+		/*
+		 * The exact key is not present, so the stripe extent that may
+		 * contain @logical is the previous item of @type. Use
+		 * btrfs_previous_item() to step back to it: it crosses into the
+		 * previous leaf when we landed on slot 0 of a leaf (a plain
+		 * slots[0]-- would stay in the current leaf and miss an item
+		 * that is the last one of the previous leaf), and it skips items
+		 * of a different type (e.g. the parity stripe).
+		 *
+		 * If there is no previous item of @type, the covering item (if
+		 * any) is the one we landed on (its objectid == logical), so
+		 * re-search to position there for the forward scan below.
+		 */
+		ret = btrfs_previous_item(stripe_root, path, 0, type);
+		if (ret < 0)
+			return ret;
+		if (ret > 0) {
+			btrfs_release_path(path);
+			ret = btrfs_search_slot(NULL, stripe_root, &stripe_key,
+						path, 0, 0);
+			if (ret < 0)
+				return ret;
+		}
 	}
 
 	while (1) {
-- 
2.54.0

