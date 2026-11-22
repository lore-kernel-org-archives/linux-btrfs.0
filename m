Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=79.135.106.111
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795319328;
	b=WvbfBEoA/4zWnr2YcUxHQgL0p+TEnvg3wNWgB5CLUAATWzKJFZ4/gQSMowgFVMQP1ltd
	 XC7lFwnNAPOMYtcWEAJHS8SIDTHBp6trTJ32ql7CcLtwZA0z/9wnxUX7HWGAlntSjMTyu
	 wRrAENqGOaW+bX3Q/ZqMQ0h793f7H/7DRkbxA/UeE5fnwi3nuigSOhszmWVMzB/sHm0dI
	 flRRgy8hfwGUnajwK9+Mu07qiTs7BKc4Q5C1hkPK5Me8Iwr+m7b7i8qGdOfNZcFKYYz/Y
	 zkhj9p9d7BkDyKLKtxOXfjhzna+ZmlQ6gFsoLIAw6UgXnGBTQMN/3cNTs1lty0xqbng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795319328;
	h=DMARC-Filter:DKIM-Signature:X-Pm-Submission-Id:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=lGbP5kKIXDKBpBUKGK+uyvTbQIOm4zeQDAxLPA8UNNc=;
	b=vtZ0vCY/ub7qMoqR/x9RCbhZAI790n8YUQ2WfZjSO9wQnG2pJXuYFbaKsCBoWNXc5+fV
	 rgL1mbTPBbHsAZuDSglUn4fuFMv1hLv8IC1hNGzNjmZYuC+CZvPRu9+E+OFTBI/2pP/mM
	 a1xLLO+tX1FPPpDrWfEGYkcb9jZbyP1AIbxYQeMyCJfWFU9bZwvZqXN8aL1ogeLG6k06k
	 NljDSzXBpYJfzozNqhS8jxafDqYQIVsqpqI6sxacwkwbccVSHCm6YjEoixtwgkGxJMaiA
	 /6PkhRyLOAyHlSQwgSxSeT2MfU8A/9Fm22+x8OhDXv86KJCpIWoM+ZXWxalHQLEojOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=raidlab.org;
	spf=pass smtp.mailfrom=raidlab.org;
	dkim=pass header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=BwAEtmhm;
	arc=none smtp.remote-ip=79.135.106.111
Received: from mail-106111.protonmail.ch (mail-106111.protonmail.ch [79.135.106.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9100D606A337
	for <linux-btrfs@vger.kernel.org>; Sun, 22 Nov 2026 03:48:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9100D606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raidlab.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raidlab.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=BwAEtmhm
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=raidlab.org;
	s=protonmail; t=1795319325; x=1795578525;
	bh=lGbP5kKIXDKBpBUKGK+uyvTbQIOm4zeQDAxLPA8UNNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:From:To:
	 Cc:Date:Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=BwAEtmhmgOLNOD3uVgnK5sjS/HIYFcj6b1Ca1T1D8CwZ2YkSjVBhxxvCxvLpiGKx+
	 S3SMOlRBRHcnyIM4gTj7ulCgCmAF1sPIKTtcTLxvVyF+I1b5ApAFMyFZm2MU1gVcpx
	 82oCGH+QY5ISz5HFwFY8a78uTDaHW7CIiLmrIBFTTuFt4XOyabDbPCbH6GFlu86Z35
	 5HpAVpiZdHLjADyVUFl7RevEdJ9dmNhoKAUVKCAedC3JRKjIXALffk1JbUdc3lO8+h
	 rHtYFznAqpSB5qzDtlCKTD9/USMYDkwoYXEfynjTPXoL/rsIu3JacRYT0Ho8FHRpvy
	 CopqHp7mmru8w==
X-Pm-Submission-Id: 4jXFRb1wPNz1DDqy
From: Miroslav Cimerman <mc@raidlab.org>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] btrfs: zoned: finish raid stripe tree zones once all data is written
Date: Sun, 22 Nov 2026 03:48:25 +0000
Message-ID: <20261122034826.2333981-3-mc@raidlab.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261122034826.2333981-1-mc@raidlab.org>
References: <20261122034826.2333981-1-mc@raidlab.org>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

btrfs_zone_finish_endio() finishes the zones of a data block group when
the ordered extent that ends at its capacity completes. It assumes that
all other data of the block group is written by then. Without the raid
stripe tree that holds: btrfs_finish_ordered_zoned() moves an extent to
the address where zone append wrote it, so the extent at the end of the
block group is the last one the device wrote.

With the raid stripe tree, an extent keeps its allocated address, and
the stripe tree records where each copy was written. The extent at the
end can then complete while zone append writes of other extents are
still queued. They reach a finished zone and fail:

  C allocated at 14M, D at 15M, the capacity is 16M
  D completes, btrfs_zone_finish_endio() finishes the zones
  C's zone append writes reach the full zones and fail

Count the completed bytes of such a block group in zone_written. Finish
its zones only when no more data can be allocated from it and all
allocated data is written. A block group loaded at mount counts as
written, and btrfs_reset_unused_block_groups() resets the counter with
alloc_offset. Bytes of a failed ordered extent, or of an extent freed
before its ordered extent was created, are not counted. Such a block
group is not finished here. Before, this happened only when the failed
extent was the last one. btrfs_zone_finish_one_bg() finishes it later
when an active zone is needed.

Fixes: 568220fa9657 ("btrfs: zoned: support RAID0/1/10 on top of raid stripe tree")
CC: stable@vger.kernel.org # 6.7+
Signed-off-by: Miroslav Cimerman <mc@raidlab.org>
---
The reset of zone_written in btrfs_reset_unused_block_groups() was not
reached in my tests. Without it, a reused block group would be finished
too early. The function already resets meta_write_pointer there for the
same reason.

 fs/btrfs/block-group.h |  6 ++++++
 fs/btrfs/zoned.c       | 33 +++++++++++++++++++++++++++++----
 2 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/block-group.h b/fs/btrfs/block-group.h
index d567ed822e55..1f88ecbc0b59 100644
--- a/fs/btrfs/block-group.h
+++ b/fs/btrfs/block-group.h
@@ -266,6 +266,12 @@ struct btrfs_block_group {
 	u64 alloc_offset;
 	u64 zone_unusable;
 	u64 zone_capacity;
+	/*
+	 * Bytes of allocated data whose write has completed. Only used for
+	 * data block groups with the raid stripe tree on a zoned filesystem.
+	 * Protected by the spinlock 'lock'.
+	 */
+	u64 zone_written;
 	u64 meta_write_pointer;
 	struct btrfs_chunk_map *physical_map;
 	struct list_head active_bg_list;
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index e6ce6f05ad75..02baf1ecc55e 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -18,6 +18,7 @@
 #include "bio.h"
 #include "transaction.h"
 #include "sysfs.h"
+#include "raid-stripe-tree.h"
 
 /* Maximum number of zones to report per blkdev_report_zones() call */
 #define BTRFS_REPORT_NR_ZONES   4096
@@ -2015,6 +2016,8 @@ int btrfs_load_block_group_zone_info(struct btrfs_block_group *cache, bool new)
 
 	if (!ret) {
 		cache->meta_write_pointer = cache->alloc_offset + cache->start;
+		/* Everything allocated at load time is written. */
+		cache->zone_written = cache->alloc_offset;
 		if (test_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &cache->runtime_flags)) {
 			spin_lock(&fs_info->zone_active_bgs_lock);
 			if (list_empty(&cache->active_bg_list)) {
@@ -2594,7 +2597,9 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
 	 * new allocation) and the IO for the last usable block is completed, we
 	 * don't need to wait for the other IOs. This holds because we ensure
 	 * the sequential IO submissions using the ZONE_APPEND command for data
-	 * and block_group->meta_write_pointer for metadata.
+	 * and block_group->meta_write_pointer for metadata. With the raid
+	 * stripe tree, btrfs_zone_finish_endio() calls this only once all
+	 * allocated data is written.
 	 */
 	if (!fully_written) {
 		if (test_bit(BLOCK_GROUP_FLAG_ZONED_DATA_RELOC, &block_group->runtime_flags)) {
@@ -2798,10 +2803,29 @@ int btrfs_zone_finish_endio(struct btrfs_fs_info *fs_info, u64 logical, u64 leng
 	else
 		min_alloc_bytes = fs_info->nodesize;
 
-	/* Bail out if we can allocate more data from this block group. */
-	if (logical + length + min_alloc_bytes <=
-	    block_group->start + block_group->zone_capacity)
+	if (btrfs_need_stripe_tree_update(fs_info, block_group->flags)) {
+		bool written;
+
+		/*
+		 * With the raid stripe tree, an extent keeps the address it was
+		 * allocated at, and zone append places its stripes wherever the
+		 * device writes them. The extent at the end of the block group
+		 * can complete before other extents of it are written, so only
+		 * finish the zones once all allocated data is written.
+		 */
+		spin_lock(&block_group->lock);
+		block_group->zone_written += length;
+		written = (block_group->alloc_offset + min_alloc_bytes >
+			   block_group->zone_capacity &&
+			   block_group->zone_written >= block_group->alloc_offset);
+		spin_unlock(&block_group->lock);
+		if (!written)
+			goto out;
+	} else if (logical + length + min_alloc_bytes <=
+		   block_group->start + block_group->zone_capacity) {
+		/* Bail out if we can allocate more data from this block group. */
 		goto out;
+	}
 
 	ret = do_zone_finish(block_group, true);
 
@@ -3282,6 +3306,7 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
 		reclaimed = bg->alloc_offset;
 		bg->zone_unusable = bg->length - bg->zone_capacity;
 		bg->alloc_offset = 0;
+		bg->zone_written = 0;
 		/*
 		 * The zone was just reset to empty, so alloc_offset went back to
 		 * the start of the zone. For metadata/system block groups the
-- 
2.53.0

