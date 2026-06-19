Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3715A345731
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Jun 2026 09:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781859758; cv=none; b=GTwmdgp1NxQTs/PU8lcAYw2qsp0/HjgBK05sbODE1R2F4ijlPqfoyHXG03z9Lk5y6TiZdYMqOUYp8VN7IsD5FehKfk8ZqDi32fxiet16CSpw4Dpzcqg7EY94vJJ9G6D+a+a1X6Kac9iWv7tDVQB7UA2sEbhF3kX6DgAxT/MsVrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781859758; c=relaxed/simple;
	bh=QDMrPVjmd70GsMw5L4rG57djAH3La7oXP3NcgfK0cBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Avfs4VLggnPvTXVcxOo9/mbdWDX03GuGDETbg8a3U5wN86LTCZzWqK11HvW0+69Iot2WqKcLh0RNx4TzzxtP8iVwvqc2aaVGkY3FLTKuGv7vCMqlura6VPFzLtLrhEUdHQ1FyNZh4A4/0Wu24j9W5x88Tsruj9AidrJZnE02iUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=niJkAc/V; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="niJkAc/V"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1781859757; x=1813395757;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QDMrPVjmd70GsMw5L4rG57djAH3La7oXP3NcgfK0cBc=;
  b=niJkAc/ViktCQcD8v/xXpqR6wEwkNUoD+evHme9pYjONPnXGPeH/+s/E
   QDUyR0vTS+3TDCVzW5dNGr7rcA1u5XfM+f4t/ImOBimelzNmgSQRx82Uk
   iOtfx7xUGhDTaBohtVh2bhnJ8AOXvqEblJtrSQnsq95MXhjqkIyX1epCZ
   ysj72Py8B0wkiL/UtE3ixRWJTnk0uEgNShik/zd6cqEBZDW6sTo5+sTCS
   WiteADSh7auEqWBgZR7k9KHeKvf/upLcjgD5TIG4SQ6B0OHXLAX2HzN1Q
   wnFPl7gSSmN6dNaZJAyZxn/TmuuCRTRZwF9u7rf28h75wto9k4qhcekLU
   Q==;
X-CSE-ConnectionGUID: j8k9AKRqQj+FYHoAu3Ercw==
X-CSE-MsgGUID: uh6fCzHjSpC5ozixJ7f1bQ==
X-IronPort-AV: E=Sophos;i="6.24,213,1774281600"; 
   d="scan'208";a="147951285"
Received: from unknown (HELO uls-op-esad1-o.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jun 2026 17:02:31 +0800
X-CSE-ConnectionGUID: AJ/559dqQZqYxdM0wfTtIw==
X-CSE-MsgGUID: GD51dkjsTzGVBE680ddVXA==
IronPort-SDR: 6a3505a5_in9yinlICrfGuqUWHbJ9X+uxEMozNntL152Te9esI2BhDWm
 X+2OTYoRIOBgrRWChhm1U3nv82UAhSZR2DqX+YA==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad1-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Jun 2026 02:02:29 -0700
X-CSE-ConnectionGUID: Afa59OnXRKu6dq8cTZQCrA==
X-CSE-MsgGUID: ZioSBsQMQQOXFNAP7ZICOg==
WDCIronportException: Internal
Received: from wdap-62juwqezoj.ad.shared (HELO neo.fritz.box) ([10.224.19.3])
  by uls-op-esai1-o.wdc.com with ESMTP; 19 Jun 2026 02:02:29 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [RFC 13/15] btrfs: implement delete of parity stripes
Date: Fri, 19 Jun 2026 11:02:08 +0200
Message-ID: <20260619090211.497100-14-johannes.thumshirn@wdc.com>
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

Deleting a data extent on a RAID56 stripe-tree block-group must also remove
the parity stripe-tree item covering it, otherwise a stale parity item is
left behind. The logical to physical mapping is linear for both key types,
so the existing arithmetic in the partial deletion paths is valid for the
parity item as well.

The parity is computed over all of a full stripe's data columns, so freeing
only part of such a stripe - punching a hole, or freeing one of several
extents that share it - must not trim the parity item or drop the freed
column's data item: the parity bytes on disk still encode the freed column,
so a later degraded read of a *surviving* column would reconstruct from
parity that no longer matches the live data and silently return garbage.
Reconstructing any column requires both the parity and every sibling data
column's stripe item, so none of them may be removed while any column of the
stripe is still referenced.

Restrict the deletion to the full stripes entirely covered by the freed
range and leave partially freed stripes intact. Stripes that become fully
free through a sequence of partial frees are reclaimed later, when the
emptied block group is removed (after relocation has rewritten any survivors
as fresh full stripes), so nothing is leaked.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/block-group.c      | 15 ++++++++
 fs/btrfs/raid-stripe-tree.c | 74 +++++++++++++++++++++++++++++++++----
 2 files changed, 82 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 5fc0c20d8e51..6e237f34d5f3 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -21,6 +21,7 @@
 #include "fs.h"
 #include "accessors.h"
 #include "extent-tree.h"
+#include "raid-stripe-tree.h"
 
 static struct kmem_cache *block_group_cache;
 static struct kmem_cache *free_space_ctl_cache;
@@ -1167,6 +1168,20 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 	btrfs_free_ref_tree_range(fs_info, block_group->start,
 				  block_group->length);
 
+	/*
+	 * On RAID stripe-tree filesystems a partial-stripe free deliberately
+	 * keeps the stripe's data and parity items around (so degraded reads of
+	 * the surviving columns still reconstruct correctly). The block group
+	 * is now empty and about to go away, so this is where those retained
+	 * items are finally reclaimed.
+	 */
+	ret = btrfs_delete_raid_extent(trans, block_group->start,
+				       block_group->length);
+	if (ret) {
+		btrfs_abort_transaction(trans, ret);
+		goto out;
+	}
+
 	index = btrfs_bg_flags_to_raid_index(block_group->flags);
 
 	/* make sure this block group isn't part of an allocation cluster */
diff --git a/fs/btrfs/raid-stripe-tree.c b/fs/btrfs/raid-stripe-tree.c
index 513bb5bba2ef..310c5b906cfa 100644
--- a/fs/btrfs/raid-stripe-tree.c
+++ b/fs/btrfs/raid-stripe-tree.c
@@ -12,6 +12,7 @@
 #include "disk-io.h"
 #include "raid-stripe-tree.h"
 #include "volumes.h"
+#include "raid56.h"
 #include "print-tree.h"
 #include "zoned.h"
 #include "ordered-data.h"
@@ -28,13 +29,14 @@ static int btrfs_partially_delete_raid_extent(struct btrfs_trans_handle *trans,
 	size_t item_size;
 	struct btrfs_key newkey = {
 		.objectid = oldkey->objectid + frontpad,
-		.type = BTRFS_RAID_STRIPE_KEY,
+		.type = oldkey->type,
 		.offset = newlen,
 	};
 	int ret;
 
 	ASSERT(newlen > 0);
-	ASSERT(oldkey->type == BTRFS_RAID_STRIPE_KEY);
+	ASSERT(oldkey->type == BTRFS_RAID_STRIPE_KEY ||
+	       oldkey->type == BTRFS_RAID_STRIPE_PARITY_KEY);
 
 	leaf = path->nodes[0];
 	slot = path->slots[0];
@@ -65,7 +67,8 @@ static int btrfs_partially_delete_raid_extent(struct btrfs_trans_handle *trans,
 	return btrfs_insert_item(trans, stripe_root, &newkey, newitem, item_size);
 }
 
-int btrfs_delete_raid_extent(struct btrfs_trans_handle *trans, u64 start, u64 length)
+static int __btrfs_delete_raid_extent(struct btrfs_trans_handle *trans,
+				      u64 start, u64 length, u8 type)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_root *stripe_root = fs_info->stripe_root;
@@ -100,7 +103,7 @@ int btrfs_delete_raid_extent(struct btrfs_trans_handle *trans, u64 start, u64 le
 
 	while (1) {
 		key.objectid = start;
-		key.type = BTRFS_RAID_STRIPE_KEY;
+		key.type = type;
 		key.offset = (u64)-1;
 
 		ret = btrfs_search_slot(trans, stripe_root, &key, path, -1, 1);
@@ -142,7 +145,7 @@ int btrfs_delete_raid_extent(struct btrfs_trans_handle *trans, u64 start, u64 le
 		if (found_start > start) {
 			if (slot == 0) {
 				ret = btrfs_previous_item(stripe_root, path, 0,
-							  BTRFS_RAID_STRIPE_KEY);
+							  type);
 				if (ret) {
 					if (ret > 0)
 						ret = -ENOENT;
@@ -163,7 +166,7 @@ int btrfs_delete_raid_extent(struct btrfs_trans_handle *trans, u64 start, u64 le
 			}
 		}
 
-		if (key.type != BTRFS_RAID_STRIPE_KEY)
+		if (key.type != type)
 			break;
 
 		/* That stripe ends before we start, we're done. */
@@ -191,7 +194,7 @@ int btrfs_delete_raid_extent(struct btrfs_trans_handle *trans, u64 start, u64 le
 			struct btrfs_stripe_extent *extent;
 			struct btrfs_key newkey = {
 				.objectid = end,
-				.type = BTRFS_RAID_STRIPE_KEY,
+				.type = type,
 				.offset = diff_end,
 			};
 
@@ -297,6 +300,63 @@ int btrfs_delete_raid_extent(struct btrfs_trans_handle *trans, u64 start, u64 le
 	return ret;
 }
 
+int btrfs_delete_raid_extent(struct btrfs_trans_handle *trans, u64 start, u64 length)
+{
+	struct btrfs_chunk_map *map;
+	bool has_parity = false;
+	int ret;
+
+	map = btrfs_find_chunk_map(trans->fs_info, start, length);
+	has_parity = map && btrfs_nr_parity_stripes(map->type);
+
+	if (has_parity) {
+		const u64 full_stripe = (u64)nr_data_stripes(map) * BTRFS_STRIPE_LEN;
+		u64 chunk_start = map->start;
+		u64 rel_start = start - chunk_start;
+		u64 rel_end = start + length - chunk_start;
+		u64 aligned_start, aligned_end;
+
+		btrfs_free_chunk_map(map);
+
+		/*
+		 * On a parity profile, freeing only part of a full stripe (a
+		 * hole punch, or freeing one of several extents that share a
+		 * stripe) must NOT touch the stripe tree: the on-disk parity
+		 * was computed over all of the stripe's data columns, so
+		 * trimming the parity item or dropping a freed column's data
+		 * item would make a degraded read of the *surviving* columns
+		 * reconstruct garbage. Instead retain both the data and parity
+		 * items and only delete them once the whole stripe is free.
+		 *
+		 * Restrict the deletion to the full stripes entirely covered by
+		 * [start, start + length); the leftover items of partially freed
+		 * stripes are reclaimed when the block group is removed (after
+		 * relocation rewrites the surviving data as fresh full stripes).
+		 */
+		aligned_start = roundup(rel_start, full_stripe);
+		aligned_end = rounddown(rel_end, full_stripe);
+		if (aligned_start >= aligned_end)
+			return 0;
+
+		start = chunk_start + aligned_start;
+		length = aligned_end - aligned_start;
+
+		ret = __btrfs_delete_raid_extent(trans, start, length,
+						 BTRFS_RAID_STRIPE_PARITY_KEY);
+		if (ret)
+			return ret;
+
+		return __btrfs_delete_raid_extent(trans, start, length,
+						  BTRFS_RAID_STRIPE_KEY);
+	}
+
+	btrfs_free_chunk_map(map);
+
+	return __btrfs_delete_raid_extent(trans, start, length,
+					  BTRFS_RAID_STRIPE_KEY);
+}
+
+
 static int update_raid_extent_item(struct btrfs_trans_handle *trans,
 				   struct btrfs_key *key,
 				   struct btrfs_stripe_extent *stripe_extent,
-- 
2.54.0

