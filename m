Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABAC620D4FF
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2026 12:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.143.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781697931; cv=none; b=aKkSmKvpoBa8Yt9SS9BM4s6iY2iu9cWruWzmJ5YS9rKwlRpKY66G5yaqhBRE38RLHh3lqWB+xedToWY31rGn7u8KuRijYPwTB7eXawD6faJuUlxoWj0QM0M0vB8A4plQBsGQJa2R5MAwp3CaziwFsKukl84BKgV/IxpY5OPs710=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781697931; c=relaxed/simple;
	bh=7P+ODEnhDSLGJniiUprwoSCa1wSYVUj3exgdE2eifp0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eoDnBY/ecb60uD7qtSdxoA4DwDY0kEfudT8AY5w0NzSmXbtLTQwNKkpqFcdI/oRWxKkhhX16pC+cAWbMs+WAV/7ZT2WykdfyaeTx0PyX4P3Uon8fptcpkv7jFnaTtbdACbvA4e4F8lOms6rWji3/3rISRB6gHuQRmjcfGGTtwYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=PNnQHQh9; arc=none smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="PNnQHQh9"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1781697930; x=1813233930;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=7P+ODEnhDSLGJniiUprwoSCa1wSYVUj3exgdE2eifp0=;
  b=PNnQHQh9GLvUKNNUuSCTfQGyVFo6oOVQ4VtVjGxi1q2ukvN4ICwwYRi2
   4EZpxnv6Dawk5bH7X2++/tyIgeFQmyDk7FeRcKlLc0fnqQlbexhpNHIOo
   lcxVrrYJxOWV574DldfCpkuVDrJnSpJTnUMbR5T4C4EauOnWspDJtwuWS
   BZjnENo0G1LaHrkpCWCDzERuTMUnm9IWEmvKMouGlZtHdnaoZmmZBN+Ra
   dboY6tIdkgQHQFC9MEv9erlxdAZQvvZ8O/mAT8Ppl0ZI3TqliO+abUOsK
   fLaAhi8ulysjZKOZL5Qa3XXDUauZkBi5xL8hUAvmHT8hNcOhxL2zmSo1h
   w==;
X-CSE-ConnectionGUID: It0Bmc0BSkm46N2agRLRew==
X-CSE-MsgGUID: 28SkVlEyTZeTWKEUkxnCyQ==
X-IronPort-AV: E=Sophos;i="6.24,209,1774281600"; 
   d="scan'208";a="150212121"
Received: from unknown (HELO uls-op-esad1-o.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 17 Jun 2026 20:05:24 +0800
X-CSE-ConnectionGUID: c6X0OVaOQAOs8oRuYO0evQ==
X-CSE-MsgGUID: cfVa7zTGSoiULPIXCzXUmQ==
IronPort-SDR: 6a328d60_NDPKgLtPNuSG/e38be3jWEfHG83ma54x6HY9dcXC+Yi2gAO
 w+SNfjZ+7NbYGTEHBCsk9NDwHu3acChWQuLEaKg==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad1-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Jun 2026 05:04:47 -0700
X-CSE-ConnectionGUID: Vlv7ZEaDRQ2pW9QaSoO8DA==
X-CSE-MsgGUID: aGUtp0pBSuGCIrgoUFn2QA==
WDCIronportException: Internal
Received: from wdap-5pxzmrbogy.ad.shared (HELO neo.fritz.box) ([10.224.28.95])
  by uls-op-esai1-o.wdc.com with ESMTP; 17 Jun 2026 05:04:47 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH] btrfs: fix RAID stripe-tree lookup across leaf boundaries
Date: Wed, 17 Jun 2026 14:04:31 +0200
Message-ID: <20260617120431.381916-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

btrfs_get_raid_extent_offset() resolves the stripe extent containing a
logical address by searching for that address and, when there is no exact
match, stepping back to the preceding item - the containing extent begins
at or before logical. That step-back never crossed a leaf boundary: when
the search landed on the first slot of a leaf, the containing extent (the
last item of the previous leaf) was never examined and a perfectly valid
address returned -ENODATA, failing the read.

The problem stays unnoticed when lookups are stripe-aligned and the stripe
tree fits in a single leaf. A non-stripe-aligned read against a multi-leaf
stripe tree whose covering extent happens to be the last item of a leaf
hits it.

Step back with btrfs_previous_item() instead, which crosses into the
previous leaf correctly. If there is no previous item, re-search so the
forward scan starts at the item beginning at logical.

Fixes: 10e27980f2ff ("btrfs: lookup physical address from stripe extent")
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/raid-stripe-tree.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/raid-stripe-tree.c b/fs/btrfs/raid-stripe-tree.c
index 454a95bf542a..192bcad8282f 100644
--- a/fs/btrfs/raid-stripe-tree.c
+++ b/fs/btrfs/raid-stripe-tree.c
@@ -430,9 +430,26 @@ int btrfs_get_raid_extent_offset(struct btrfs_fs_info *fs_info,
 	ret = btrfs_search_slot(NULL, stripe_root, &stripe_key, path, 0, 0);
 	if (ret < 0)
 		return ret;
-	if (ret) {
-		if (path->slots[0] != 0)
-			path->slots[0]--;
+	if (ret > 0) {
+		/*
+		 * The exact key is not present, so the stripe extent that may
+		 * contain @logical is the previous item.
+		 *
+		 * If there is no previous item, the covering extent (if any) is
+		 * the one we landed on (its objectid == logical), so re-search
+		 * to position there for the forward scan below.
+		 */
+		ret = btrfs_previous_item(stripe_root, path, 0,
+					  BTRFS_RAID_STRIPE_KEY);
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

