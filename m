Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.70.43.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795124434;
	b=oQHv0ysDRbIMb/a4w1WR3arsdrdiHBYZfuwjP/9s0RL73cePnAHM5uLxcaxvxuHAOnqv
	 iNnEH2huAEazlLfhLyXp6eltiajW2iWO6m9Jbhl3IpCDtjiWaO3wby2PqwtoPKx5HX8Eo
	 Y4LuyA4McRvvJNi0rKFRfTB8N7F6l8gOOlSL2VNp31qyyh7XNtewuYseVoel2+TdSEAxd
	 4oVDuEO0Lv1Ql2QM9B/r3DlkfCiqJHk9G9Zc4EOkVWcrpyVBBN/HOTvo1ELXSNochp33A
	 tekXnLQG/6esT01B3Z3uym3knwAy312k2gWOhLy7diKERd1wy0zGqalh0uLTQirqtzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795124434;
	h=DMARC-Filter:DKIM-Signature:X-Pm-Submission-Id:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=vF7ekkbhzw0sIXjPLBq5g9RE6+l5S7Zg7YNXTWY9lqo=;
	b=AhVzZEpyTS4TKI2pli76kHD//gLxQZUPalCUTH74TU91xnZpHEJu30uhAZo5I/4B2fIB
	 wlhS2YG2nv7Hp0XQ6L/qW3YXc/ljpQQ8G7jlcs43DGtehe8DZTBi6QrD3CiWR33k8CVde
	 PyIZBQwUI+NUuUdCww5w4DSMJFcaVyVOvYh76bddZooe3EKwxOg12Zv+ew6krrtWgA2YB
	 qiJLEEzYPNJlRMyQRJsAXPoUjpdORPXQmjpbPT1izqAkzSvMf4AVkqQbgwIPuKc3Rx73+
	 /fwa4AoG17HmwvOmsLW3Ag/pNCb+vBA92pmP45TMxasqh+k3PDdru3Pvf9yNCDPZlaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=raidlab.org;
	spf=pass smtp.mailfrom=raidlab.org;
	dkim=pass header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=MX+kM9Vw;
	arc=none smtp.remote-ip=185.70.43.171
Received: from mail-43171.protonmail.ch (mail-43171.protonmail.ch [185.70.43.171])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9617606A324;
	Thu, 19 Nov 2026 21:40:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C9617606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raidlab.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raidlab.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=MX+kM9Vw
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=raidlab.org;
	s=protonmail; t=1795124431; x=1795383631;
	bh=vF7ekkbhzw0sIXjPLBq5g9RE6+l5S7Zg7YNXTWY9lqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:From:To:
	 Cc:Date:Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=MX+kM9VwLZtagNbz5n2EsO8bZAEdDLpRnasVP35dovqKDaaj6FAWBD3OvFJ83aRRp
	 qj2z0vdpT7gs6g2+0H0vDRJv197tOEvsTdSejMhOX7WZ2GS+7NXWf9QcjFzVeJMoGB
	 XDyr7GguTtxS+CP7QrqVWFN/OKmjNz9tqaKmaE96g+GMkGrP51SIu7/X25P6K64f9M
	 fn6PoP289tV/3xIyq6AK0ohZGSTYBLJY7wK2iesGwOQm2ULJ5PYDEMYGc7XmMiiaM0
	 Hyj1D8l5xowQg2gvmlFV+xiGfFaxcN5qeQlIc9sX1xz2NwcGtihdMgsxwX32nik5yO
	 251J2Iv8nhfJw==
X-Pm-Submission-Id: 4jVsMZ4s92z1DDqy
From: Miroslav Cimerman <mc@raidlab.org>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] btrfs: tests: zoned: add degraded RAID1 cases
Date: Thu, 19 Nov 2026 21:38:35 +0000
Message-ID: <20261119213835.103131-5-mc@raidlab.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261119213835.103131-1-mc@raidlab.org>
References: <20261119213835.103131-1-mc@raidlab.org>
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

Add cases for the previous patches. On a degraded mount: RAID1 with the
first device missing, which has to be marked active, RAID1C3 with the
first and the last and with the first two devices missing, and RAID1
and RAID1C3 with different write pointers, which take the highest one.
On a regular mount: RAID1 with the first zone offline, which now loads.

Give missing devices a zone capacity of 0, as btrfs_load_zone_info()
does, and check the zone capacity and the active state where a case
asks for it. All six cases fail without the previous patches.

Signed-off-by: Miroslav Cimerman <mc@raidlab.org>
---
Prepared with the help of an LLM, which also ran the tests. I reviewed
everything.

 fs/btrfs/tests/zoned-tests.c | 82 +++++++++++++++++++++++++++++++++++-
 1 file changed, 81 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/tests/zoned-tests.c b/fs/btrfs/tests/zoned-tests.c
index bb9969210444..9cc5b32bb2ee 100644
--- a/fs/btrfs/tests/zoned-tests.c
+++ b/fs/btrfs/tests/zoned-tests.c
@@ -27,6 +27,8 @@ struct load_zone_info_test_vector {
 
 	int expected_result;
 	u64 expected_alloc_offset;
+	u64 expected_zone_capacity;
+	bool expected_active;
 
 	const char *description;
 };
@@ -77,7 +79,9 @@ static int test_load_zone_info(struct btrfs_fs_info *fs_info,
 	for (int i = 0; i < test->num_stripes; i++) {
 		zone_info[i].physical = 0;
 		zone_info[i].alloc_offset = test->alloc_offsets[i];
-		zone_info[i].capacity = ZONE_SIZE;
+		/* A missing device has a capacity of 0. */
+		if (zone_info[i].alloc_offset != WP_MISSING_DEV)
+			zone_info[i].capacity = ZONE_SIZE;
 		if (zone_info[i].alloc_offset && zone_info[i].alloc_offset < ZONE_SIZE)
 			__set_bit(i, active);
 	}
@@ -101,6 +105,19 @@ static int test_load_zone_info(struct btrfs_fs_info *fs_info,
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
 
@@ -244,6 +261,69 @@ static const struct load_zone_info_test_vector load_zone_info_tests[] = {
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
+	/* An offline zone has no write pointer on a regular mount either. */
+	{
+		.description = "RAID1: first zone offline",
+		.raid_type = BTRFS_BLOCK_GROUP_RAID1,
+		.num_stripes = 2,
+		.alloc_offsets = {
+			WP_MISSING_DEV, SZ_1M,
+		},
+		.expected_alloc_offset = SZ_1M,
+	},
 	/* Error case: having different write pointers. */
 	{
 		.description = "RAID1: fail: different write pointers",
-- 
2.53.0

