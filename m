Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001722248A8
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Mar 2026 00:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774399449; cv=none; b=UoP87ug7As5jb5Owxj0WiC6vLYy8sPBy611OC1D0mNJ+rtCWWR4NyeshXKUg0NKNBvlodPcm0ZweforE6teFBZEqiyujVEGvD1UlzSuYfKU1MQ4tIeYIpVtT/ZQ0JsLDwq2VsFYcYCLAOIaTsjCBGmU/6pYkBb5o2YLAo47sM6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774399449; c=relaxed/simple;
	bh=pJxBZfkEpVbsRmIxx3V5vwBM1L3AVHZCKc/i40H0bn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PnQ65PT9HYQHe9Y+m/7N5WyuuVisZHqbAIsN4WUqfXehhpsuJSvxNs25IP9KNAktaU+/y2VOpyq+lipjdPRE4oWPUgy2K/NrtbskwfNNft5hk3Nvf6Jchr15QrwTNomFRunYCYp28xDQ8lDnTSbAOjLcy59b35zZ1WeXl38Elak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jzUylgCM; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jzUylgCM"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-c7412b07f22so185365a12.0
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Mar 2026 17:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774399447; x=1775004247; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fUxVMW0Q6ViE/Zxq8+fERJmXmaxdxo0no4qCgJ6CNic=;
        b=jzUylgCMt2r/tBZvY9JHE8aVkhdiYXwiaTl+HpocxqxYP/09K21OuwSK0UTlSuRnHI
         rad3SI33jEq2SyJHyLfK/HUTDIQp6ekbETd7r19FzdKIh0RJrQD/zHy6i/Zs28SrnQ7U
         dbd67piv5jNI3eDshMf1Hl0URaWswGlLaPQg9/kT9ujU4WIiDWxBDgi04ZyQuBTcE8e8
         WX1Zfcu6leaIOZ4u6/W25RyPiY7VRSg7iKhqahOIJ3iExRGnx8abQ/8xPjfFz1YHUkmF
         yVKzQu4CHzHgdzPh0tHyfJJ4Zkpo+Mm4o1Ujsj83C+gk+ztgITshUcLmfw5uEI7qtlnw
         vrTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774399447; x=1775004247;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fUxVMW0Q6ViE/Zxq8+fERJmXmaxdxo0no4qCgJ6CNic=;
        b=a653+zGhYjqPCxNWc5asTkRpXXMLJdFsQV9Z1IIhrR8e+p/x9Hl0U7ZB9V6Q/oEzKb
         82cbN8uKzFCMlsfGZYv7F4Q5Gu4HyoaR5IFzsh/xhW/rPl3qRHsbSNRgVieXJetqp56N
         1IZd5xT02YXUuIeR3ZOYZ7R2D52vmP9kdr3rM1UXXfju4V5ld3CF26HMo1xlxmaZ0brG
         VWHmVWB+4tGtlAGZC/0fKPiobtbyRrcBTNEAW3YXxs/9cgoGyM5Ax/Pz+twwYuX3C++r
         lu9bZiFarde/Pwgh+rFg16AL0n3Gtlw3xQRqW3iPDCO2sUQsnDHA0UjZ8QE9KupZo5i1
         3Oaw==
X-Gm-Message-State: AOJu0Yw7oFROBvLudFSAw5q3SNHDM9F9O53vVwdyTIKHItWZG8k0++40
	acYTCTRsgykBL+BTVDv4VQOL9cw1iWZ+HVxgwwjjdzNqYtiLdibht1WR
X-Gm-Gg: ATEYQzy6Bp7iggH9sPkXUfJ9mEUGrbpKVj2L5Lqtp4OHHw3zXX/ivOTUN5O335zlN7D
	fDz/oQcdJU8n1s1e0Oap8URmWYvitud93t7GKdQ1V1noMRry1lJLgFDJPE+HtHLEwOIbvrw1vcB
	NrH7M8YWQJzOdlchtwRiLfc4zlC6psVNUxTUmfP2axLXMU5V+EsHFkC4JuHtPeUwoKKAmw+rUn8
	kRaAHd6bHoOKtgHtTvuUla+LrN3R3EJnDD8+gZXHJok+RTT1CKzOa9p0dYOzVlKzEGni76bIkde
	0JpFCF+eOtStx4o3tOd3pNHLpTYwycf0tvzIrsJwzzLP7p3Ig9oVh8ef/fHQcOUyQVy1otbpHkI
	BnZ3vZzZcQa0yCuM2+6CI6cm8MUDUm5Cklgbx8/41NnYy3kONUwWbvGi3jjluNQtb2W5D3YZBf+
	XoL8SmBW4w4p39+2E4KPlM6CzFYagaK4nwBwvv2MHzr206rchP0B8gcaYRxcSp3ZJbx2opKReer
	BbkWXQbIQ==
X-Received: by 2002:a17:903:37c5:b0:2ae:be67:722f with SMTP id d9443c01a7336-2b0b07f9bd5mr16343605ad.22.1774399447341;
        Tue, 24 Mar 2026 17:44:07 -0700 (PDT)
Received: from kernel-fuzz.. ([103.172.182.26])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b0836554acsm207457015ad.51.2026.03.24.17.44.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 17:44:06 -0700 (PDT)
From: ZhengYuan Huang <gality369@gmail.com>
To: dsterba@suse.com,
	clm@fb.com,
	idryomov@gmail.com
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	r33s3n6@gmail.com,
	zzzccc427@gmail.com,
	ZhengYuan Huang <gality369@gmail.com>
Subject: [PATCH v3 4/4] btrfs: fix check_chunk_block_group_mappings() to iterate all chunk maps
Date: Wed, 25 Mar 2026 08:43:39 +0800
Message-ID: <20260325004339.2323838-5-gality369@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260325004339.2323838-1-gality369@gmail.com>
References: <20260325004339.2323838-1-gality369@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[BUG]
A corrupted image with a chunk present in the chunk tree but whose
corresponding block group item is missing from the extent tree can be
mounted successfully, even though check_chunk_block_group_mappings()
is supposed to catch exactly this corruption at mount time.  Once
mounted, running btrfs balance with a usage filter (-dusage=N or
-dusage=min..max) triggers a null-ptr-deref:

  KASAN: null-ptr-deref in range [0x0000000000000070-0x0000000000000077]
    RIP: 0010:chunk_usage_filter fs/btrfs/volumes.c:3874 [inline]
    RIP: 0010:should_balance_chunk fs/btrfs/volumes.c:4018 [inline]
    RIP: 0010:__btrfs_balance fs/btrfs/volumes.c:4172 [inline]
    RIP: 0010:btrfs_balance+0x2024/0x42b0 fs/btrfs/volumes.c:4604

[CAUSE]
The crash occurs because __btrfs_balance() iterates the on-disk chunk
tree, finds the orphaned chunk, calls chunk_usage_filter() (or
chunk_usage_range_filter()), which queries the in-memory block group
cache via btrfs_lookup_block_group().  Since no block group was ever
inserted for this chunk, the lookup returns NULL, and the subsequent
dereference of cache->used crashes.

check_chunk_block_group_mappings() uses btrfs_find_chunk_map() to
iterate the in-memory chunk map (fs_info->mapping_tree):

  map = btrfs_find_chunk_map(fs_info, start, 1);

With @start = 0 and @length = 1, btrfs_find_chunk_map() looks for a
chunk map that *contains* the logical address 0. If no chunk contains
logical address 0, btrfs_find_chunk_map(fs_info, 0, 1) returns NULL
immediately and the loop breaks after the very first iteration,
having checked zero chunks. The entire verification function is therefore
a no-op, and the corrupted image passes the mount-time check undetected.

[FIX]
Replace the btrfs_find_chunk_map() based loop with a direct in-order
walk of fs_info->mapping_tree using rb_first_cached() + rb_next().
This guarantees that every chunk map in the tree is visited regardless
of the logical addresses involved.

No lock is taken around the traversal. This function is called during
mount from btrfs_read_block_groups(), which is invoked from open_ctree()
before any background threads (cleaner, transaction kthread, etc.) are
started. There are therefore no concurrent writers that could modify
mapping_tree at this point. An analogous lockless direct traversal of
mapping_tree already exists in fill_dummy_bgs() in the same file.

Since we walk the RB-tree directly via rb_entry() without going through
btrfs_find_chunk_map(), no reference is taken on each map entry, so the
btrfs_free_chunk_map() calls are also removed.

Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
 fs/btrfs/block-group.c | 24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 5322ef2ae015..d1e075a8905a 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2319,29 +2319,26 @@ static struct btrfs_block_group *btrfs_create_block_group_cache(
  */
 static int check_chunk_block_group_mappings(struct btrfs_fs_info *fs_info)
 {
-	u64 start = 0;
+	struct rb_node *node;
 	int ret = 0;
 
-	while (1) {
+	/*
+	 * This is called during mount from btrfs_read_block_groups(), before
+	 * any background threads are started, so no concurrent writers can
+	 * modify the mapping_tree. No lock is needed here.
+	 */
+	for (node = rb_first_cached(&fs_info->mapping_tree); node;
+	     node = rb_next(node)) {
 		struct btrfs_chunk_map *map;
 		struct btrfs_block_group *bg;
 
-		/*
-		 * btrfs_find_chunk_map() will return the first chunk map
-		 * intersecting the range, so setting @length to 1 is enough to
-		 * get the first chunk.
-		 */
-		map = btrfs_find_chunk_map(fs_info, start, 1);
-		if (!map)
-			break;
-
+		map = rb_entry(node, struct btrfs_chunk_map, rb_node);
 		bg = btrfs_lookup_block_group(fs_info, map->start);
 		if (unlikely(!bg)) {
 			btrfs_err(fs_info,
 	"chunk start=%llu len=%llu doesn't have corresponding block group",
 				     map->start, map->chunk_len);
 			ret = -EUCLEAN;
-			btrfs_free_chunk_map(map);
 			break;
 		}
 		if (unlikely(bg->start != map->start || bg->length != map->chunk_len ||
@@ -2354,12 +2351,9 @@ static int check_chunk_block_group_mappings(struct btrfs_fs_info *fs_info)
 				bg->start, bg->length,
 				bg->flags & BTRFS_BLOCK_GROUP_TYPE_MASK);
 			ret = -EUCLEAN;
-			btrfs_free_chunk_map(map);
 			btrfs_put_block_group(bg);
 			break;
 		}
-		start = map->start + map->chunk_len;
-		btrfs_free_chunk_map(map);
 		btrfs_put_block_group(bg);
 	}
 	return ret;
-- 
2.43.0

