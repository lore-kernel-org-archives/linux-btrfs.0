Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.70.43.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795268770;
	b=IJ/vNWDgGA1YAo8+HJKltTaMbRzssjyTBSu2AAENZPxb19rLENW1lobQtZifqVwjp0Cb
	 KKHSDppN70OHkgwmLIacgZVf+6ZRkV5MwsDo41x9d1+5wXaARel9CvnEuROJ/ZQ0oq4Wv
	 HFnKu/Xu89AbbNP4x8hWojFktI+Acl2TcgXLKu/jDes5gP9Wtii7D9V4t+/eR4Yh9ghCU
	 5CT1eh+Uqjil7E23qDY3bcVf8+5DridpUR1kvwzH8TBkRz90gcM2bpP2T/mbt0Cga2N3q
	 st0yvCseYGCLRlDCoRmYM3zsgG8cU121VO/XZ+rzc0sDOqTPB+H44Ie/JAKmEURZgeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795268770;
	h=DMARC-Filter:DKIM-Signature:X-Pm-Submission-Id:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=bgjr5+E58rRHzdOaQemxGfUdksvbJ9w6msH1vvyx8Sw=;
	b=JNwuwUxk2QoUKU7g/fRcxwUcxC7xnxwboA0BVlqiozoZZdSYHm14jsMUjtYUG5JV1Ice
	 AwnJ1ciaFknYv+a6ydl/b3ivwcrmJnAqAldnxr2LHbHn2L8BTybSCAeBlbZLZYch0i0n5
	 KE/zLCRaoien+FEBn63FtxWBpCCGNFLe2JQQlO5CtfZA76uZmlVSPmh5vwxSMN3GHkAnL
	 l1l5MZD4+GEt/qPKuV5Yg9LajXNFytJMqOUiqfIyYbRpvELxZAktXrDLIH6MzrqoBwPWe
	 WojYfIQoZPg7PBi9yeeh8ZQEBrQfmw2aCKNxzWwrTBg6K8/nf0OXO+5RRnIRasf4uKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=raidlab.org;
	spf=pass smtp.mailfrom=raidlab.org;
	dkim=pass header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=1w9X+FAG;
	arc=none smtp.remote-ip=185.70.43.171
Received: from mail-43171.protonmail.ch (mail-43171.protonmail.ch [185.70.43.171])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201A3606A338
	for <linux-btrfs@vger.kernel.org>; Sat, 21 Nov 2026 13:46:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 201A3606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raidlab.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raidlab.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=1w9X+FAG
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=raidlab.org;
	s=protonmail; t=1795268767; x=1795527967;
	bh=bgjr5+E58rRHzdOaQemxGfUdksvbJ9w6msH1vvyx8Sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:From:To:
	 Cc:Date:Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=1w9X+FAGAkh+ojyQneBKVH2Xoeez3NAREB8ksJ7w5i3clut/h46XXEP5cJzK5Sxy7
	 DPCLd4pEh2Bi3ATG6DbxfgbPgzlUhPX4oD6EuvdZkn0QuB6PtP1z+XLt09+gVdF0rx
	 fJ2wMCurhsnmQICnT+8s3j/CH9gAjj2dqwFhK43lzjpZxBRrWI8Ilh5+9xhQWPM4xq
	 hzA0O/UvhlP8Pun/ZCnvTzpCoMvbTuSdQFIDeb3p/cdMBVkzQURQwjxyKA7iUxtpzz
	 YwaYdSQ4kyo7auTBoaLa1kHT+IZM7Qn64ym2SE7OGHsn8089ta1p8kSF/xnQkxZs5S
	 QDA5/9BAJPpog==
X-Pm-Submission-Id: 4jWtlL0QVjz1DDnv
From: Miroslav Cimerman <mc@raidlab.org>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/5] btrfs: tests: zoned: add RAID1 cases with missing or stale stripes
Date: Sat, 21 Nov 2026 13:45:49 +0000
Message-ID: <20261121134550.216217-6-mc@raidlab.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261121134550.216217-1-mc@raidlab.org>
References: <20261121134550.216217-1-mc@raidlab.org>
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

Add cases for the previous patches. On a degraded mount:

- RAID1 with the first device missing, and RAID1 metadata with an empty
  first zone: both are marked active
- RAID1C3 with the first and the last, and with the first two devices
  missing
- RAID1 and RAID1C3 with different write pointers: the highest one is
  taken
- RAID1 with full zones of different capacities
- RAID1 with a full zone that has extents past the smaller capacity: not
  capped, so the caller then refuses the block group

On a regular mount:

- RAID1 with the first zone offline, with a failed zone report for it,
  and with full zones of different capacities: now load
- RAID1C3 with a smaller third zone: sets the capacity
- two cases that still fail: a write pointer past the capacity in a zone
  that is not full, and full zones with extents past the capacity

Let a case set the zone capacity of each stripe. A stripe without a
write pointer has a capacity of 0 unless the case sets one:
btrfs_load_zone_info() gives 0 for a missing device or a failed zone
report, while an offline zone keeps its capacity. Derive the active
state from the write pointer and the capacity, and check the zone
capacity and the active state where a case asks for it. All new cases
fail without the previous patches, except the two that fail either way.
Those make sure that only full zones without extents past the capacity
are capped.

Signed-off-by: Miroslav Cimerman <mc@raidlab.org>
---
v2 (was 4/4): add the cases with an empty first zone, with different
zone capacities and with a failed zone report, and a capacity per
stripe. The case with an offline zone gives that zone a capacity now.

The subject was "btrfs: tests: zoned: add degraded RAID1 cases", but
6 of the 14 new cases are on a regular mount.

Prepared with the help of an LLM, which also ran the tests. I reviewed
everything.

 fs/btrfs/tests/zoned-tests.c | 203 ++++++++++++++++++++++++++++++++++-
 1 file changed, 201 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/tests/zoned-tests.c b/fs/btrfs/tests/zoned-tests.c
index bb9969210444..4848aa6fde11 100644
--- a/fs/btrfs/tests/zoned-tests.c
+++ b/fs/btrfs/tests/zoned-tests.c
@@ -21,12 +21,15 @@ struct load_zone_info_test_vector {
 	u64 raid_type;
 	u64 num_stripes;
 	u64 alloc_offsets[8];
+	u64 capacities[8];
 	u64 last_alloc;
 	u64 bg_length;
 	bool degraded;
 
 	int expected_result;
 	u64 expected_alloc_offset;
+	u64 expected_zone_capacity;
+	bool expected_active;
 
 	const char *description;
 };
@@ -77,8 +80,16 @@ static int test_load_zone_info(struct btrfs_fs_info *fs_info,
 	for (int i = 0; i < test->num_stripes; i++) {
 		zone_info[i].physical = 0;
 		zone_info[i].alloc_offset = test->alloc_offsets[i];
-		zone_info[i].capacity = ZONE_SIZE;
-		if (zone_info[i].alloc_offset && zone_info[i].alloc_offset < ZONE_SIZE)
+		/*
+		 * Without a write pointer, the capacity is 0 for a missing device
+		 * or a failed zone report, while an offline zone keeps its own.
+		 */
+		if (zone_info[i].alloc_offset == WP_MISSING_DEV)
+			zone_info[i].capacity = test->capacities[i];
+		else
+			zone_info[i].capacity = test->capacities[i] ?: ZONE_SIZE;
+		if (zone_info[i].alloc_offset &&
+		    zone_info[i].alloc_offset < zone_info[i].capacity)
 			__set_bit(i, active);
 	}
 	if (test->degraded)
@@ -101,6 +112,19 @@ static int test_load_zone_info(struct btrfs_fs_info *fs_info,
 		return -EINVAL;
 	}
 
+	if (!ret && test->expected_zone_capacity &&
+	    bg->zone_capacity != test->expected_zone_capacity) {
+		test_err("unexpected zone_capacity: zone_capacity %llu expected %llu",
+			 bg->zone_capacity, test->expected_zone_capacity);
+		return -EINVAL;
+	}
+
+	if (!ret && test->expected_active &&
+	    !test_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &bg->runtime_flags)) {
+		test_err("block group not marked active");
+		return -EINVAL;
+	}
+
 	return 0;
 }
 
@@ -244,7 +268,182 @@ static const struct load_zone_info_test_vector load_zone_info_tests[] = {
 		.degraded = true,
 		.expected_alloc_offset = SZ_1M,
 	},
+	{
+		.description = "RAID1: missing first device on DEGRADED",
+		.raid_type = BTRFS_BLOCK_GROUP_RAID1,
+		.num_stripes = 2,
+		.alloc_offsets = {
+			WP_MISSING_DEV, SZ_1M,
+		},
+		.degraded = true,
+		.expected_alloc_offset = SZ_1M,
+		.expected_active = true,
+	},
+	{
+		.description = "RAID1C3: missing first and last device on DEGRADED",
+		.raid_type = BTRFS_BLOCK_GROUP_RAID1C3,
+		.num_stripes = 3,
+		.alloc_offsets = {
+			WP_MISSING_DEV, SZ_1M, WP_MISSING_DEV,
+		},
+		.degraded = true,
+		.expected_alloc_offset = SZ_1M,
+	},
+	{
+		.description = "RAID1C3: missing first and second device on DEGRADED",
+		.raid_type = BTRFS_BLOCK_GROUP_RAID1C3,
+		.num_stripes = 3,
+		.alloc_offsets = {
+			WP_MISSING_DEV, WP_MISSING_DEV, SZ_1M,
+		},
+		.degraded = true,
+		.expected_alloc_offset = SZ_1M,
+		.expected_zone_capacity = ZONE_SIZE,
+	},
+	/* A stripe behind the others: the highest write pointer on DEGRADED. */
+	{
+		.description = "RAID1: metadata, empty first zone on DEGRADED",
+		.raid_type = BTRFS_BLOCK_GROUP_RAID1,
+		.num_stripes = 2,
+		.alloc_offsets = {
+			0, SZ_1M,
+		},
+		.degraded = true,
+		.expected_alloc_offset = SZ_1M,
+		.expected_active = true,
+	},
+	{
+		.description = "RAID1: different write pointers on DEGRADED",
+		.raid_type = BTRFS_BLOCK_GROUP_RAID1,
+		.num_stripes = 2,
+		.alloc_offsets = {
+			SZ_1M, SZ_2M,
+		},
+		.degraded = true,
+		.expected_alloc_offset = SZ_2M,
+	},
+	{
+		.description = "RAID1C3: first missing, different write pointers on DEGRADED",
+		.raid_type = BTRFS_BLOCK_GROUP_RAID1C3,
+		.num_stripes = 3,
+		.alloc_offsets = {
+			WP_MISSING_DEV, SZ_2M, SZ_1M,
+		},
+		.degraded = true,
+		.expected_alloc_offset = SZ_2M,
+	},
+	/*
+	 * An offline zone or a failed zone report has no write pointer on a
+	 * regular mount either. An offline zone still has its capacity.
+	 */
+	{
+		.description = "RAID1: first zone offline",
+		.raid_type = BTRFS_BLOCK_GROUP_RAID1,
+		.num_stripes = 2,
+		.alloc_offsets = {
+			WP_MISSING_DEV, SZ_1M,
+		},
+		.capacities = {
+			ZONE_SIZE - SZ_1M,
+		},
+		.expected_alloc_offset = SZ_1M,
+		.expected_zone_capacity = ZONE_SIZE - SZ_1M,
+	},
+	{
+		.description = "RAID1: failed zone report of the first zone",
+		.raid_type = BTRFS_BLOCK_GROUP_RAID1,
+		.num_stripes = 2,
+		.alloc_offsets = {
+			WP_MISSING_DEV, SZ_1M,
+		},
+		.expected_alloc_offset = SZ_1M,
+		.expected_zone_capacity = ZONE_SIZE,
+	},
+	/* The block group's capacity is the smallest of its stripes'. */
+	{
+		.description = "RAID1C3: smaller third zone capacity",
+		.raid_type = BTRFS_BLOCK_GROUP_RAID1C3,
+		.num_stripes = 3,
+		.alloc_offsets = {
+			SZ_1M, SZ_1M, SZ_1M,
+		},
+		.capacities = {
+			ZONE_SIZE, ZONE_SIZE, ZONE_SIZE - SZ_1M,
+		},
+		.expected_alloc_offset = SZ_1M,
+		.expected_zone_capacity = ZONE_SIZE - SZ_1M,
+	},
+	/* Full zones report their own capacity, which can differ by device. */
+	{
+		.description = "RAID1: full zones with different capacities",
+		.raid_type = BTRFS_BLOCK_GROUP_RAID1,
+		.num_stripes = 2,
+		.alloc_offsets = {
+			ZONE_SIZE - SZ_1M, ZONE_SIZE,
+		},
+		.capacities = {
+			ZONE_SIZE - SZ_1M, ZONE_SIZE,
+		},
+		.last_alloc = ZONE_SIZE - SZ_1M,
+		.expected_alloc_offset = ZONE_SIZE - SZ_1M,
+		.expected_zone_capacity = ZONE_SIZE - SZ_1M,
+	},
+	{
+		.description = "RAID1: full zones with different capacities on DEGRADED",
+		.raid_type = BTRFS_BLOCK_GROUP_RAID1,
+		.num_stripes = 2,
+		.alloc_offsets = {
+			ZONE_SIZE, ZONE_SIZE - SZ_1M,
+		},
+		.capacities = {
+			ZONE_SIZE, ZONE_SIZE - SZ_1M,
+		},
+		.last_alloc = ZONE_SIZE - SZ_1M,
+		.degraded = true,
+		.expected_alloc_offset = ZONE_SIZE - SZ_1M,
+		.expected_zone_capacity = ZONE_SIZE - SZ_1M,
+	},
+	{
+		.description = "RAID1: full zone with extents past the capacity on DEGRADED",
+		.raid_type = BTRFS_BLOCK_GROUP_RAID1,
+		.num_stripes = 2,
+		.alloc_offsets = {
+			SZ_1M, ZONE_SIZE,
+		},
+		.capacities = {
+			ZONE_SIZE - SZ_1M, ZONE_SIZE,
+		},
+		.last_alloc = ZONE_SIZE,
+		.degraded = true,
+		.expected_alloc_offset = ZONE_SIZE,
+		.expected_zone_capacity = ZONE_SIZE - SZ_1M,
+	},
 	/* Error case: having different write pointers. */
+	{
+		.description = "RAID1: fail: write pointer past the capacity",
+		.raid_type = BTRFS_BLOCK_GROUP_RAID1,
+		.num_stripes = 2,
+		.alloc_offsets = {
+			ZONE_SIZE - SZ_1M, ZONE_SIZE - SZ_512K,
+		},
+		.capacities = {
+			ZONE_SIZE - SZ_1M, ZONE_SIZE,
+		},
+		.expected_result = -EIO,
+	},
+	{
+		.description = "RAID1: fail: full zones with extents past the capacity",
+		.raid_type = BTRFS_BLOCK_GROUP_RAID1,
+		.num_stripes = 2,
+		.alloc_offsets = {
+			ZONE_SIZE - SZ_1M, ZONE_SIZE,
+		},
+		.capacities = {
+			ZONE_SIZE - SZ_1M, ZONE_SIZE,
+		},
+		.last_alloc = ZONE_SIZE,
+		.expected_result = -EIO,
+	},
 	{
 		.description = "RAID1: fail: different write pointers",
 		.raid_type = BTRFS_BLOCK_GROUP_RAID1,
-- 
2.53.0

