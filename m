Received: from mail.burntcomma.com (mail2.burntcomma.com [217.169.27.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 928003C7DF5
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2026 17:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.169.27.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774286760; cv=none; b=cX1b/VVfT6d6hMIFiYvw/zl6ie/LgQBPRYyPHdvujDCivNCowtNOXIlZJ1MNfnJ4LkpXy/ugTQyR4I+Or6MeQWq2aK4DPQ7h7Gl/2hpRhU68BQwyZMs1gHY7Q5CDKZCM72NmCa65BystRu+tJaKCuHZQ8fy82cquX3KE5ElaszY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774286760; c=relaxed/simple;
	bh=x/OnoaAO7bROKyZnQRQPNhiVmGtRGce3B0iVomcgtYw=;
	h=From:To:Cc:Subject:Date:Message-ID:Mime-Version; b=h+vPSVjzP+N9dEq1ueID3tDjMSrHF3El5HXJdkt2dxpJUmHAuZKC1XXM7QtEFGbcE8uMs0AeTWlsjRW33RtHfYVAARcn+FPGkkV5sNQaXv+2DjLzyxLvO10ypCnD8JkHAEwTv7DkPeLTGMchQK+xqnJ7p0v36S6SoezaR3xHbeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com; spf=pass smtp.mailfrom=harmstone.com; dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b=VCp0fD5i; arc=none smtp.client-ip=217.169.27.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=harmstone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b="VCp0fD5i"
Received: from beren (beren.burntcomma.com [IPv6:2a02:8012:8cf0:0:ce28:aaff:fe0d:6db2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.burntcomma.com (Postfix) with ESMTPSA id 1DAB9313F93;
	Mon, 23 Mar 2026 17:25:54 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=harmstone.com;
	s=mail; t=1774286754;
	bh=GjRiQUqYUAr243oTOJ/hl6Tog0btW3lFe513xg36I9A=;
	h=From:To:Cc:Subject:Date;
	b=VCp0fD5i8qF9SQJNuge8WwzFO6mIWk/AjYNgGYvWhEYl//vfWNov5UyEYykJ49DLf
	 UxN5/ktaNnTCYecFjTlemJYtrKrQzTuTsGP/rMiny4Xb3shV1NDQDpgOxz6ylgboJH
	 URW9nUn8Y3PJL9cxynCz3emtQOMA74JXulDtY7Ok=
From: Mark Harmstone <mark@harmstone.com>
To: linux-btrfs@vger.kernel.org
Cc: Mark Harmstone <mark@harmstone.com>
Subject: [PATCH] btrfs: add tree checker for items in remap tree
Date: Mon, 23 Mar 2026 17:25:47 +0000
Message-ID: <20260323172552.151985-1-mark@harmstone.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit

Add write-time checking of items in the remap tree, to catch errors
before they are written to disk.

We're checking:

* That remap items, remap backrefs, and identity remaps aren't written
  unless the REMAP_TREE incompat flag is set
* That identity remaps have a size of 0
* That remap items and remap backrefs have a size of sizeof(struct
  btrfs_remap_item)
* That the objectid for these items is aligned to the sector size
* That the offset for these items (i.e. the size of the remapping) isn't
  0 and is aligned to the sector size
* That objectid + offset doesn't overflow

Signed-off-by: Mark Harmstone <mark@harmstone.com>
---
 fs/btrfs/tree-checker.c | 70 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 70 insertions(+)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 495d1dd61e66c2..b19066e8ef522c 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1879,6 +1879,71 @@ static int check_raid_stripe_extent(const struct extent_buffer *leaf,
 	return 0;
 }
 
+static int check_remap_key(const struct extent_buffer *leaf,
+			   const struct btrfs_key *key, int slot)
+{
+	u32 item_size = btrfs_item_size(leaf, slot);
+	const u32 sectorsize = leaf->fs_info->sectorsize;
+	u64 end;
+
+	if (unlikely(!btrfs_fs_incompat(leaf->fs_info, REMAP_TREE))) {
+		generic_err(leaf, slot,
+		"remap key type %u present but REMAP_TREE incompat bit unset",
+			    key->type);
+		return -EUCLEAN;
+	}
+
+	switch (key->type) {
+	case BTRFS_IDENTITY_REMAP_KEY:
+		if (unlikely(item_size != 0)) {
+			generic_err(leaf, slot,
+		"invalid item size for IDENTITY_REMAP, have %u expect 0",
+				    item_size);
+			return -EUCLEAN;
+		}
+	break;
+	case BTRFS_REMAP_KEY:
+	case BTRFS_REMAP_BACKREF_KEY:
+		if (unlikely(item_size != sizeof(struct btrfs_remap_item))) {
+			generic_err(leaf, slot,
+		"invalid item size for remap key type %u, have %u expect %zu",
+				    key->type, item_size,
+				    sizeof(struct btrfs_remap_item));
+			return -EUCLEAN;
+		}
+		break;
+	}
+
+	if (unlikely(key->offset == 0)) {
+		generic_err(leaf, slot,
+			    "invalid remap key length, have 0 expect nonzero");
+		return -EUCLEAN;
+	}
+
+	if (unlikely(!IS_ALIGNED(key->objectid, sectorsize))) {
+		generic_err(leaf, slot,
+		"invalid remap key objectid, have %llu expect aligned to %u",
+			    key->objectid, sectorsize);
+		return -EUCLEAN;
+	}
+
+	if (unlikely(!IS_ALIGNED(key->offset, sectorsize))) {
+		generic_err(leaf, slot,
+		"invalid remap key offset (length), have %llu expect aligned to %u",
+			    key->offset, sectorsize);
+		return -EUCLEAN;
+	}
+
+	if (unlikely(check_add_overflow(key->objectid, key->offset, &end))) {
+		generic_err(leaf, slot,
+	"remap key overflow, objectid %llu + offset %llu wraps",
+			    key->objectid, key->offset);
+		return -EUCLEAN;
+	}
+
+	return 0;
+}
+
 static int check_dev_extent_item(const struct extent_buffer *leaf,
 				 const struct btrfs_key *key,
 				 int slot,
@@ -2130,6 +2195,11 @@ static enum btrfs_tree_block_status check_leaf_item(struct extent_buffer *leaf,
 	case BTRFS_FREE_SPACE_BITMAP_KEY:
 		ret = check_free_space_bitmap(leaf, key, slot);
 		break;
+	case BTRFS_IDENTITY_REMAP_KEY:
+	case BTRFS_REMAP_KEY:
+	case BTRFS_REMAP_BACKREF_KEY:
+		ret = check_remap_key(leaf, key, slot);
+		break;
 	}
 
 	if (unlikely(ret))
-- 
2.52.0

