Received: from fout-b8-smtp.messagingengine.com (fout-b8-smtp.messagingengine.com [202.12.124.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1CFC572661
	for <linux-btrfs@vger.kernel.org>; Tue, 22 Sep 2026 16:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790096139; cv=none; b=MX88Lx5FSRNjme35NjxqtkFooRWgT8eMzyubdL1OTs1oozDONzkLOWeKlryyqfHY4M3F1YkjvhSKl3nU0HDaP1AzkjY7M9VjuFhnmyrzbGWY/IjZfhQ039FFQ64+Loa6wMJVhNJuWXZStjds8kqPlthUhHaZzzLm9CMP6/AD660=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790096139; c=relaxed/simple;
	bh=pEowBR3JiZnWI71FFMwofhJG+Q6GowGY/GiyxED5fJQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FB8eljVwJZTwc7DJMAJeLtfD1YuGQsPa9tl3Ik5oO0jK/Q2irk1b2HzjWtnh1XFXi81tn+uZg4sKIQjZ5/w1EWEothwDzw1BOmZxVb5aAglecUtE34Cr0xsbsftlT3Z8z4RRR6qGiRMAtRnQyyuq6O7j0XG9N2dRxTd6ii0XYLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=URPQMYqj; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=rFTCHuKy; arc=none smtp.client-ip=202.12.124.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="URPQMYqj";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="rFTCHuKy"
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfout.stl.internal (Postfix) with ESMTP id B1EFE1D000E6;
	Tue, 22 Sep 2026 12:55:36 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-07.internal (MEProxy); Tue, 22 Sep 2026 12:55:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1790096136; x=
	1790182536; bh=5CoTgALeiJWIk7YstgqEWzUC8kNkZ3GNgw0hW/tKiX0=; b=U
	RPQMYqjyeBX8BtCdfum6p01OQKv04DXW7WC0emYA/uKNPD0URm0r5uVNEvKiW7uC
	qdVybq86+cnycvalZts7YOS+SbsFWX6vXunBi9jJXt1FGok4tXg65SO3SD3r1Vpt
	tFoXSBZM8ifj0nrVK6gErp5WR+FbsCk1L3Zs5LrezxSXfRq4GlWfq72ler2cXzNk
	UBfLV7G6Lhg6Dc8DfKqOIfKyaSWknhq9UoJyTk06RdTFa/J3LLjwORiYyD0dtg2H
	t7G3WJpyWfymTia4h1OUdpT8G9UyfH7eGrqE3XzSSsqRjyU6qNpChECz8eigLv7O
	vkiSz6AefWCPtCDgMbr2A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; t=1790096136; x=1790182536; bh=5CoTgALeiJWIk7YstgqEWzUC8kNk
	Z3GNgw0hW/tKiX0=; b=rFTCHuKyd31mvckmokV7Zlq5Bd1ylrHc8bGyL9TbQYOZ
	wGoH/jAY2AuUt4KHnhHfagvkKkL95e3wvDjEdnPnVQ7DxsdI5p1RNLUGDPb/4FOx
	xx3yRAmvSMk4ozkBVW4PQxPWGdWAEKX3/Xd8HsS/Tb/r5hbmLxI5iSrMR0f3zjd2
	GI1wjDw/wLlViKm7DVDekkuligcw86G0Cjetp14OmXqP0rfNObgv2zDTGU7AZ9WZ
	EDRFKAgnqmCZjBnsJhC+nrxTznwYC0su5Cxfgy6PIqiqUOeOENtU1AvGPcoEUz9e
	c3enfu2AWkdjKcfvzCldzlOKV68O1Q6vWTwuQp1YEw==
X-ME-Sender: <xms:CLOyamkJDHviImrRhy7Omb1l5clIa9NPJqXwNzeAR4T3eh2P9AsHNA>
    <xme:CLOyaj3388dpmB5lVMgWzcmrocw9wikihuvyBOW-TqBa4Henkr29K5vQgDqrGaUqe
    O6Asl8_EXA1BB5wdtI_O0WQJj7yp3Tm-NxmyhlESnoZunAiTY4Jd8P0>
X-ME-Received: <xmr:CLOyaiQJhlmBgVMMcDQ0F2XVSi-APb4Ge_D_a-KmztNpzopqSH_OZE4>
X-ME-Proxy-Cause: dmFkZTFzVj0YWmnvojXoK2+EpfJGJ4LTWfQZsTwohPIv7eWyRhfgORymsHnHB9dDZWX2IQ
    /sIfcno29CCLth9xSzFS73wZjFmXhOntAZsLL3/2WHdinDBLPcnlj2rLCs9dU8NlEM5b8q
    8VO8TT8MmrZneCwQJPfBz88qe9wqcExmmXJzCZYrjp8vcaXdWlDJp7QYZ1HbpT0EiRs2Lo
    b85Rg6d/aq66O8Ofe2SRMvVSBWNwqtUz8T5rm2xURre+wTjAlS2g8bqIk7VAfOZKV48Rpv
    Nv38umI2nWP/0QIZAmZBUzOUz45gA8mfTJimGkqH4XxX8bsKtJb5SBSkuUxHw8AA1+HGcD
    BU/gvX4GAIn5QLoEtL9rRLTZvT5MNyXCbwBFjJRf1SUNaDEpTl6V3L1C6c5VaNJIYv1er7
    nEb7F8aEg8fD02t2TuFG2VNPwIYYXIf+7zW3BC4ZuFixp9AxYIt+6f9LksgpY9LOwGDS26
    HoJIMHoT6OiMbFAYRlOI6vrwq932IbR0cUsfHIMfdHgEzxzhLdsTmr0OLWHrSDWZh7Bol3
    kg7tytTZCHx9ZLB6mIy/a39frOgtnA0aJe4xVJar7jd6FRR0noGjweUmIEI6jfgdtyNw/7
    gmbcHrGpl1cXbNUPQjlovDfICvuh/Oj6pvwJcJ0e5mHnCxqMKREJDL7FEhjQ
X-ME-Proxy: <xmx:CLOyaluFUlcfmEY4J4Kj1MmVA3FMNxNJi6lU_-sIvS8JAf2tGX8NEw>
    <xmx:CLOyanYHnRUMkd-S3CZed7ESE2eHnYpXjo5vS7IvqsvEmeJfo314nA>
    <xmx:CLOyaqsc8BqowLOoY8wyy7NMZ0GPfsoehKa4vjBn_XlbQEu0kVWBvA>
    <xmx:CLOyapGJNsVKBGJJQYQlhjnO-e-MSqVDS6pHocDCAz4BjVnVROBpgg>
    <xmx:CLOyakmDFqIibZ2rYijH4gOp2-iI_b5k389BpCDKT1cpRA8HMY4nl1Pa>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 22 Sep 2026 12:55:36 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH 1/2] btrfs: allocate additional SYSTEM space earlier
Date: Tue, 22 Sep 2026 09:55:37 -0700
Message-ID: <c68f903b219f964552a86fe969011cf819ef470d.1790095812.git.boris@bur.io>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1790095812.git.boris@bur.io>
References: <cover.1790095812.git.boris@bur.io>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, reserve_chunk_space() allocates a new system chunk when the
space left is smaller than the reservation for a single chunk tree
update.

Therefore, a filesystem in single metadata mode on a very large block
device can accumulate tens of thousands (TB) of chunks while never
allocating more than the original 4MiB SYSTEM block group created by
mkfs. If it then fills up (with large fallocates for example) and then
that data is freed, en-masse, we end up trying to delete thousands of
block groups in a single transaction in btrfs_delete_unused_bgs().

This process touches most of the nodes and leaves of the chunk tree,
essentially trying to allocate roughly double the current usage of the
chunk tree for cow. When this runs into needing a fresh system chunk,
the fs is full of the empty bgs and we abort with ENOSPC in
btrfs_remove_chunk() like:

  BTRFS error (device loop0 state A): Transaction 30733 aborted (-ENOSPC)
  space_info SYSTEM (sub-group id 0) has 0 free, is not full
  space_info total=4194304, used=3276800, pinned=0, reserved=917504, may_use=0, readonly=0 zone_unusable=0
  BTRFS: error (device loop0 state A) in btrfs_remove_chunk:3643: errno=-28 No space left

This was seen on a 30TiB production filesystem with 10TiB of unused
block groups and reproduces on a 30TiB sparse loop device: mkfs with
-m single, fallocate 1GiB files until ENOSPC, delete two of every three
adjacent files, sync.

To fix this, we should allocate the (relatively tiny) system chunks a
little bit more eagerly. If we do it when it is half full, we ensure we
can delete all of the block groups in one go. To fill up half of a 4MiB
system bg requires thousands of block_groups so this should only affect
very large fileystems.

Assisted-by: LLM
Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/block-group.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 2eb09c9901c9..cf26dbeaabdb 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1574,6 +1574,19 @@ static bool btrfs_link_bg_list(struct btrfs_block_group *bg, struct list_head *l
 	return added;
 }
 
+/*
+ * Compute an upper bound on the bytes needed to modify every leaf in the chunk
+ * tree. Normally, we could just allocate a new system chunk then, but that can
+ * fail if there is no free space for a new dev extent. This can happen when
+ * we fill up a large filesystem then rapidly delete a large portion of it.
+ */
+static u64 system_space_needed(struct btrfs_space_info *sinfo)
+{
+	lockdep_assert_held(&sinfo->lock);
+
+	return btrfs_space_info_used(sinfo, true) + sinfo->bytes_used;
+}
+
 /*
  * Process the unused_bgs list and remove any that don't have any allocated
  * space inside of them.
@@ -1661,6 +1674,9 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
 		if (btrfs_is_block_group_used(block_group) ||
 		    (block_group->ro && !(block_group->flags & BTRFS_BLOCK_GROUP_REMAPPED)) ||
 		    list_is_singular(&block_group->list) ||
+		    ((block_group->flags & BTRFS_BLOCK_GROUP_SYSTEM) &&
+		     space_info->total_bytes - block_group->length <
+		     system_space_needed(space_info)) ||
 		    test_bit(BLOCK_GROUP_FLAG_FULLY_REMAPPED, &block_group->runtime_flags)) {
 			/*
 			 * We want to bail if we made new allocations or have
@@ -1674,6 +1690,10 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
 			 * next block group of this type would be created with a
 			 * "single" profile (even if we're in a raid fs) because
 			 * fs_info->avail_*_alloc_bits would be 0.
+			 *
+			 * Also bail out if this is a system block group that
+			 * system_space_needed() relies on to ensure head room for
+			 * mass deletion.
 			 */
 			trace_btrfs_skip_unused_block_group(block_group);
 			spin_unlock(&block_group->lock);
@@ -4509,6 +4529,7 @@ static void reserve_chunk_space(struct btrfs_trans_handle *trans,
 	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_space_info *info;
 	u64 left;
+	bool low;
 	int ret = 0;
 
 	/*
@@ -4520,6 +4541,7 @@ static void reserve_chunk_space(struct btrfs_trans_handle *trans,
 	info = btrfs_find_space_info(fs_info, BTRFS_BLOCK_GROUP_SYSTEM);
 	spin_lock(&info->lock);
 	left = info->total_bytes - btrfs_space_info_used(info, true);
+	low = left < bytes || info->total_bytes < system_space_needed(info);
 	spin_unlock(&info->lock);
 
 	if (left < bytes && btrfs_test_opt(fs_info, ENOSPC_DEBUG)) {
@@ -4528,7 +4550,7 @@ static void reserve_chunk_space(struct btrfs_trans_handle *trans,
 		btrfs_dump_space_info(info, 0, false);
 	}
 
-	if (left < bytes) {
+	if (low) {
 		u64 flags = btrfs_system_alloc_profile(fs_info);
 		struct btrfs_block_group *bg;
 		struct btrfs_space_info *space_info;
@@ -4572,7 +4594,7 @@ static void reserve_chunk_space(struct btrfs_trans_handle *trans,
 		}
 	}
 
-	if (!ret) {
+	if (!ret || left >= bytes) {
 		ret = btrfs_block_rsv_add(fs_info,
 					  &fs_info->chunk_block_rsv,
 					  bytes, BTRFS_RESERVE_NO_FLUSH);
-- 
2.55.0

