Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=109.224.244.106
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795389805;
	b=ph2OCMKcTBTvR9+qm96RsVFH4yb/t2vZ8U+2yXtds3k6YMyBg8tA9hCH1HWyHmh+z9L0
	 Vjg7kV4GOfIwOz3hnapO07KcovzlG4NiNrXdDk6KJau5MrRyF6g6+DoT9wLvCkGC70pJ/
	 LL29kzWgxfnmibJe97HnXYMfUepSwztLvIBGQk/4qfYFs+xdq/2SC6taB8xX5NM21BCMa
	 mN8I1t87RKy3Z3AsFLgFA040Q3Xw6cAHE+6jBXouXTvrKX2RfdOKkbjUX/iZ5QL9ZVyGK
	 9RJrH1mwS8jWy/pJqfblXEpug62SW+1tdkhF2KZsUlibqsn45imOWAQTtCn0ANwkf/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795389805;
	h=DMARC-Filter:DKIM-Signature:X-Pm-Submission-Id:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=GG7o6LAe8/kW95NHZTMMKcprAevymP5Xc2VzczthiW8=;
	b=Qupr7+UXGh/L75I13ppE5pShStvm7rUP3+EFETe7R1Gt30bjngKTJSaik4GWuCu5wsdX
	 MURpP+EvMaTFUMn+ERLu05btCQlb5uoSJLLpIbAncmwINhROxy6TIacrdz+VqoaXh5pEu
	 QJZ05aW4mkxL3V5/gI4JjJgcVzc6cPSHUlu6bY7cItfZoTDbMhvY5krGmpU21dvpudcv7
	 8K3QfXb0Af8ksHPapv0TtnujlvB9iGSkB+Ff6zoB4QPH4yFQSoL5vwgpvY/V1dqjeMopS
	 I9/A4vUbzqCiPd/di7wxvIeH2LUpW4xAQlfesNvFtOUYRtwT+8TdFoKjRoEU9YTrmEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=raidlab.org;
	spf=pass smtp.mailfrom=raidlab.org;
	dkim=pass header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=mOckvqGg;
	arc=none smtp.remote-ip=109.224.244.106
Received: from mail-244106.protonmail.ch (mail-244106.protonmail.ch [109.224.244.106])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3A1606A684;
	Sun, 22 Nov 2026 23:23:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8F3A1606A684
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raidlab.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raidlab.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=mOckvqGg
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=raidlab.org;
	s=protonmail; t=1795389802; x=1795649002;
	bh=GG7o6LAe8/kW95NHZTMMKcprAevymP5Xc2VzczthiW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:From:To:
	 Cc:Date:Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=mOckvqGgp08woEaExE2TSp9agDyaTIy9tBwwICo11FK9PD3vVIiotnHfsI5wfJN6O
	 lkvUpRX+W+/qha3Vb0dYbw5D0DqWssstzdRjM2ihaBkx+fEPUTi8l1xfKldg5HifM1
	 XxBqRzLYVS0oQf097jQN+nWBFwi4V3HBvlk+fvTQBCBi02y8WEAaQctX7gWQrdDW9e
	 vDVLqG8lL0Va6Hf1+7OkfbGt3HPeDyZhy3nvQftCcZ9YoieJUjJ4z3N7IGTcBkgl02
	 OX9WwaMjz9SAAYyleiYw8CzYGWigttANt+eed801Vm96TFL+0lddFhjnGy2Hvu3pr3
	 rlbY805tZOfgQ==
X-Pm-Submission-Id: 4jXlVw67tQz2SchB
From: Miroslav Cimerman <mc@raidlab.org>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] btrfs: zoned: tolerate a failed zone finish on a full block group
Date: Sun, 22 Nov 2026 23:23:09 +0000
Message-ID: <20261122232310.4099580-3-mc@raidlab.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261122232310.4099580-1-mc@raidlab.org>
References: <20261122232310.4099580-1-mc@raidlab.org>
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

do_zone_finish() sends ZONE_FINISH to the zone of each stripe of a block
group. It stops at the first error and returns it, even if the profile
tolerates the failed device. Since commit 3d16abf6c88a ("btrfs: zoned:
directly call do_zone_finish() from btrfs_zone_finish_endio_workfn()"),
btrfs_zone_finish_endio_workfn() handles that error with
btrfs_handle_fs_error(). So one failed device of a RAID1 metadata block
group turns the filesystem read-only.

When the block group is allocated up to the zone capacity and
everything is written, the zones are already full on the devices. A
failed ZONE_FINISH does not change them. In this case, finish the zones
of all stripes. Like a write, fail only if more devices failed than the
profile tolerates. Count a missing device toward the limit. The failed
device keeps the zone counted as active until the zone is reset or the
filesystem is remounted. For metadata, the active zone reservation
comes back only at the next mount.

A partly written block group keeps the current behavior. It stops at
the first error and returns it. Finishing the zones after a failed one
would leave more zones at different write pointers.
btrfs_load_block_group_raid1() refuses such a block group at the next
mount.

Fixes: 3d16abf6c88a ("btrfs: zoned: directly call do_zone_finish() from btrfs_zone_finish_endio_workfn()")
CC: stable@vger.kernel.org # 6.18+: a18a6b93a284: btrfs: zoned: finish active block group cleanup if call_zone_finish() fails
Signed-off-by: Miroslav Cimerman <mc@raidlab.org>
---
 fs/btrfs/zoned.c | 48 ++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 42 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 45bd05d8edb4..d18dc4f4dc33 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2540,9 +2540,6 @@ static int call_zone_finish(struct btrfs_block_group *block_group,
 	bool cleared;
 	int ret;
 
-	if (!device->bdev)
-		return 0;
-
 	if (zinfo->max_active_zones == 0)
 		return 0;
 
@@ -2573,6 +2570,9 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
 	const bool is_metadata = (block_group->flags &
 			(BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM));
 	struct btrfs_dev_replace *dev_replace = &fs_info->dev_replace;
+	enum btrfs_raid_types index;
+	bool zones_full;
+	int failed = 0;
 	int ret = 0;
 	int i;
 
@@ -2639,6 +2639,13 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
 	}
 
 	clear_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &block_group->runtime_flags);
+	/*
+	 * If the block group is allocated up to the zone capacity,
+	 * everything is written and the zones should be full already. A
+	 * truncated or failed write at the end is not detected here. That
+	 * would need a zone report from every device.
+	 */
+	zones_full = (block_group->alloc_offset == block_group->zone_capacity);
 	block_group->alloc_offset = block_group->zone_capacity;
 	if (block_group->flags & (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM))
 		block_group->meta_write_pointer = block_group->start +
@@ -2651,12 +2658,41 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
 	down_read(&dev_replace->rwsem);
 	map = block_group->physical_map;
 	for (i = 0; i < map->num_stripes; i++) {
-		ret = call_zone_finish(block_group, &map->stripes[i]);
-		if (ret)
-			break;
+		struct btrfs_io_stripe *stripe = &map->stripes[i];
+		int err;
+
+		if (!stripe->dev->bdev) {
+			failed++;
+			continue;
+		}
+
+		err = call_zone_finish(block_group, stripe);
+		if (err) {
+			btrfs_warn(fs_info,
+		"zoned: failed to finish zone at physical %llu on devid %llu: %d",
+				   stripe->physical, stripe->dev->devid, err);
+			failed++;
+			ret = err;
+			/*
+			 * Do not finish more zones of a partly written block
+			 * group. They would end at a different write pointer
+			 * than the failed one.
+			 */
+			if (!zones_full)
+				break;
+		}
 	}
 	up_read(&dev_replace->rwsem);
 
+	/*
+	 * Zones that are already full do not change with a failed finish.
+	 * Like a write, fail only if more devices failed than the profile
+	 * tolerates. A missing device counts toward the limit.
+	 */
+	index = btrfs_bg_flags_to_raid_index(map->type);
+	if (zones_full && failed <= btrfs_raid_array[index].tolerated_failures)
+		ret = 0;
+
 	if (!ret && !fully_written)
 		btrfs_dec_block_group_ro(block_group);
 
-- 
2.53.0

