Received: from mail.burntcomma.com (mail2.burntcomma.com [217.169.27.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9933C8728
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2026 17:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.169.27.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774286784; cv=none; b=ufNdpeUoFOveDPwjDVHkITczPha4DpXleocJ1yJrCrdjhrV+ilbxULt9k75fvom83/uHWhQw753gZcVD6kWChloFkrnLTIl7WONKRglwN4+afeM0PQZDvogt97WOkDWBL13U26HRpRPFNhofMWVA+MG2E6JAqx8/2qGLVHtS7zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774286784; c=relaxed/simple;
	bh=A5fVTZBe+Xsru0F+97PaZZ9AJ1CfM8llNGInxzpqNoE=;
	h=From:To:Cc:Subject:Date:Message-ID:Mime-Version; b=HdPmF4tTv0beegUD9zxC27SlezrlN9W86SpLh9eGbpNeD2zWVqklbwrfAjK3AVRzm3HFvw/ttzTXfLYY6Mnk3MC87eTbH8vEg1CLw9ZbfnpLLjyRLCubPfk//Uj1xN8vv71wXv/r+W5jQG+ywI2oQ30bZEZKl8+qKKcuX5WqQD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com; spf=pass smtp.mailfrom=harmstone.com; dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b=QtyIZB8J; arc=none smtp.client-ip=217.169.27.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=harmstone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b="QtyIZB8J"
Received: from beren (beren.burntcomma.com [IPv6:2a02:8012:8cf0:0:ce28:aaff:fe0d:6db2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.burntcomma.com (Postfix) with ESMTPSA id 36E23313F94;
	Mon, 23 Mar 2026 17:26:21 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=harmstone.com;
	s=mail; t=1774286781;
	bh=4sp1S2eNhRdRdVOAjxXzHMT81PexhMs/UQ6axJB1rac=;
	h=From:To:Cc:Subject:Date;
	b=QtyIZB8Jb3n82Kay5cDgywg9K9SmW8S78NbKP1gBqxav7QffHpSet4ZoIPbxBdg/F
	 +nR7szpMF73OfnPO031vBe9PpaJxE9ozJFn/f1aN/SXbnob15mtLLskUDMKxyKMGnQ
	 d7ayAvUoq8KvygZE4TnL0SLGAXZfmpcDeVy2cMVc=
From: Mark Harmstone <mark@harmstone.com>
To: linux-btrfs@vger.kernel.org
Cc: Mark Harmstone <mark@harmstone.com>
Subject: [PATCH] btrfs: add remap-tree checks to check_block_group_item()
Date: Mon, 23 Mar 2026 17:26:13 +0000
Message-ID: <20260323172619.152258-1-mark@harmstone.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit

Add some write-time checks for block group items relating to the remap
tree.

Here we're checking:
* That the REMAPPED or METADATA_REMAP flags aren't set unless the
  REMAP_TREE incompat flag is also set
* That `remap_bytes` isn't more than the size of the block group
* That `identity_remap_count` isn't more than the number of sectors in
  the block group

Signed-off-by: Mark Harmstone <mark@harmstone.com>
---
 fs/btrfs/tree-checker.c | 42 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 495d1dd61e66c2..cad23f3fadfd34 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -777,6 +777,48 @@ static int check_block_group_item(struct extent_buffer *leaf,
 			BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_DATA);
 		return -EUCLEAN;
 	}
+
+	if (unlikely(!btrfs_fs_incompat(fs_info, REMAP_TREE) &&
+		     type == BTRFS_BLOCK_GROUP_METADATA_REMAP)) {
+		block_group_err(leaf, slot,
+"invalid type, METADATA_REMAP set but REMAP_TREE incompat flag not set");
+		return -EUCLEAN;
+	}
+
+	if (unlikely(!btrfs_fs_incompat(fs_info, REMAP_TREE) &&
+		     flags & BTRFS_BLOCK_GROUP_REMAPPED)) {
+		block_group_err(leaf, slot,
+"invalid flags, REMAPPED set but REMAP_TREE incompat flag not set");
+		return -EUCLEAN;
+	}
+
+	if (item_size == sizeof(struct btrfs_block_group_item_v2)) {
+		struct btrfs_block_group_item_v2 *bgi2;
+		u64 remap_bytes;
+		u32 identity_remap_count;
+
+		bgi2 = btrfs_item_ptr(leaf, slot, struct btrfs_block_group_item_v2);
+
+		remap_bytes = btrfs_block_group_v2_remap_bytes(leaf, bgi2);
+
+		if (unlikely(remap_bytes > key->offset)) {
+			block_group_err(leaf, slot,
+				"invalid remap_bytes, have %llu expect [0, %llu]",
+					remap_bytes, key->offset);
+			return -EUCLEAN;
+		}
+
+		identity_remap_count = btrfs_block_group_v2_identity_remap_count(leaf, bgi2);
+		if (unlikely((u64)identity_remap_count >
+			     key->offset / fs_info->sectorsize)) {
+			block_group_err(leaf, slot,
+				"invalid identity_remap_count, have %u expect [0, %llu]",
+					identity_remap_count,
+					key->offset / fs_info->sectorsize);
+			return -EUCLEAN;
+		}
+	}
+
 	return 0;
 }
 
-- 
2.52.0

