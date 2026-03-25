Received: from mail.burntcomma.com (mail2.burntcomma.com [217.169.27.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F01703D5646
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Mar 2026 12:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.169.27.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774443240; cv=none; b=mDfXOiWQvdtWly7ZZ7CRC0J8LSvFhZCKncD6A2ZbbTks2i+PiGDyPuRZ7PD8WlQoN8kFPEf4k2DYJbt/ayVNEo5qAVsexbeeVnqwkHbU1bY3kV4yGOBlM3eUXpM1FkKrtu6OU2bkvplsrDSrUW9JcKm8q6AEg2Of+ta6Si1KJ9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774443240; c=relaxed/simple;
	bh=TWlM1gxd6Ysd13vsnGBl9MnJvZhhTKloQ53IzYp/UGU=;
	h=From:To:Cc:Subject:Date:Message-ID:Mime-Version; b=U6zjYgz7LrpIt6gZFsDTzMHrhVfOHYNnareaO1yf9f3SopywiKGPzLJSM5Nb1cVntbeJ5w6J77n5yoS5eX8Ezojvx8RFrtdxDf/5HyD1t3+RXHEXl/r2W0oY+iE9XuqSX/ClZGMfG8rQCLFTo3KEtZzh0lVnR0LV9OAZ+B6MiDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com; spf=pass smtp.mailfrom=harmstone.com; dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b=DZlV/SqJ; arc=none smtp.client-ip=217.169.27.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=harmstone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b="DZlV/SqJ"
Received: from beren (beren.burntcomma.com [IPv6:2a02:8012:8cf0:0:ce28:aaff:fe0d:6db2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.burntcomma.com (Postfix) with ESMTPSA id 8D12D314E23;
	Wed, 25 Mar 2026 12:53:53 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=harmstone.com;
	s=mail; t=1774443233;
	bh=RrY6xLgrHExws+uVlgSk3fZlCbIqedDlqCcIinqrnfA=;
	h=From:To:Cc:Subject:Date;
	b=DZlV/SqJtJ7lA8LUkgIMSv7zeZhJhVk3f2RLJ3RRNgCL64+r8XJSCaelRMA/aRsMU
	 ywWYuAMyAWO8zEe/Jcw7SkHBsUOqdqWY3sQFi5sCS3J7K3WQ2szzYKv5pC8gRr3xuW
	 ytuuk6yxa/X+qbds6Bq6YNJJpUTd92zL8Yn0eR80=
From: Mark Harmstone <mark@harmstone.com>
To: linux-btrfs@vger.kernel.org
Cc: Mark Harmstone <mark@harmstone.com>
Subject: [PATCH v2] btrfs: add remap-tree checks to check_block_group_item()
Date: Wed, 25 Mar 2026 12:53:43 +0000
Message-ID: <20260325125349.123889-1-mark@harmstone.com>
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
The original version used a 64-bit division, which is not implemented on
32-bit arches - this changes it to a right shift instead.

 fs/btrfs/tree-checker.c | 42 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 6117381e4d57f7..75c4b9eedaf9f0 100644
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
+			     key->offset >> fs_info->sectorsize_bits)) {
+			block_group_err(leaf, slot,
+				"invalid identity_remap_count, have %u expect [0, %llu]",
+					identity_remap_count,
+					key->offset >> fs_info->sectorsize_bits);
+			return -EUCLEAN;
+		}
+	}
+
 	return 0;
 }
 
-- 
2.52.0

