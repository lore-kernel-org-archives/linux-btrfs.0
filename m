Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.70.43.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795268768;
	b=tr7OwDqlJaZ2atF8Q0LDQb9Mv870Ol562rBfoXrDlvfELPkjy+507sLcHjl3HVqHjSBj
	 fKpmDt2DpSZEoQR3rast+Hl+36PlcMPMWRJNl5GWTZTR5ZZ9EKQ330+HoOHaxRU0nmcsQ
	 MhLcKu3SHSSO3XvhNRlzvq5Ls0r9L6V5xE1k/c2kzK47+dbJEsJiVdz3ieip1PsHVjbbt
	 nrt/5GWIL1YpF/G/kN1EubaHaP1X8JMp64K13A7zeT0Rx+hMWHw2RieaMVKwG8oxS87N1
	 DXKcRc2+EY7lokxZauVnYZsyLcioI2gkikNlAXngxiCJELsSXIIQ6r3sCogDC3H8G9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795268768;
	h=DMARC-Filter:DKIM-Signature:X-Pm-Submission-Id:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Z9qMKaNC4wBNyFn+O6M1msXAVq4q0zIFSQoQ1hCYMtI=;
	b=iYahxCJ9vuQzC3T2UguYE9rZ1cSJKvofrm1jUHGp8rkXK+cGiZxdzsUPpsa6TqojB4Z9
	 UOS9m0AIUEZKS9DO/J/WFaEq/6HvbKXXSENwfzvFfd79uqtcaYKm0qbk4gw1DOzBk5rMl
	 rLO7zkfRLw1NGXvMFfy5wTHMh7Wi9Ei09NZTl1cYxWnFIPdPweOO38GQjgNtCUvbhOGlK
	 Ak5+0+B+5KHWJpT95OS6nvr2V4MG64IofKiWP9KBnVmXuGMAC6KwunMvF1BLMZp1cE4Td
	 IIFHKe9gWaLucMgMeDlm7cK+itOV6YxPp6SalYtJTT3uGmnTakv7wuFQ1d/g1xUJZ8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=raidlab.org;
	spf=pass smtp.mailfrom=raidlab.org;
	dkim=pass header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=ea7whOkp;
	arc=none smtp.remote-ip=185.70.43.171
Received: from mail-43171.protonmail.ch (mail-43171.protonmail.ch [185.70.43.171])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33EFB606A682
	for <linux-btrfs@vger.kernel.org>; Sat, 21 Nov 2026 13:46:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 33EFB606A682
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raidlab.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raidlab.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=ea7whOkp
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=raidlab.org;
	s=protonmail; t=1795268764; x=1795527964;
	bh=Z9qMKaNC4wBNyFn+O6M1msXAVq4q0zIFSQoQ1hCYMtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:From:To:
	 Cc:Date:Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=ea7whOkpfBV6V4/uaVHrndsav0V5RPOSsv8xgwy7LCNTJb4VH5cg7DcMW/mvf+h9W
	 SlWP7rvXcr8+tjRt11uloG33a9cyb3ul2TL46DrDVeK3tE1+XAYS+h0+grgWAFC6J4
	 A3ODt/wNsEvTrGdtYausycwuQIdAp3cuICYGqUNtAO1kAosH4eB8sFDl8guAvSfKZU
	 foYRDwEpccFIR54p6HFPKl3R3OklXJNxgBpb2g6WyhJf+B/w0youHuZeTL2kg+5iDc
	 mmGmpMVda/k0qJmjtxwV2O6R202ldHTEkd0OzV6csCyJwjusVKJkSOVSV+EPwcWam0
	 nD/Wbb4bTHV5w==
X-Pm-Submission-Id: 4jWtlF6LjDz1DDnw
From: Miroslav Cimerman <mc@raidlab.org>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/5] btrfs: zoned: cap full RAID1 zones at the block group's capacity
Date: Sat, 21 Nov 2026 13:45:47 +0000
Message-ID: <20261121134550.216217-4-mc@raidlab.org>
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

The zone capacity of a RAID1 block group is the smallest of its
stripes'. Finishing the block group finishes its zones on devices with
an active zone limit, and a full zone reports its own capacity as its
write pointer. With zone capacities that differ between the devices, the
write pointers of a full block group then differ, and the next mount
fails:

  BTRFS error (device nb2): zoned: write pointer offset mismatch of zones in raid1 profile
  BTRFS error (device nb2): zoned: failed to load zone info of bg 150994944

A degraded mount with all devices present takes stripe 0's write
pointer, and fails too unless stripe 0 has the smallest capacity:

  BTRFS error (device nb2): zoned: invalid write pointer 14680064 (larger than zone capacity 12582912) in block group 150994944

Take a full zone with a larger capacity as written up to the block
group's capacity, unless an extent of the block group ends past it. Then
the block group was written with a larger capacity, e.g. by a degraded
mount without the stripe with the smallest capacity, or in RAID1C3 and
RAID1C4 before the previous patch. Such a block group still fails a
regular mount. Get the end of the last extent from the extent tree when
the capacities differ, as for conventional zones.

Fixes: 568220fa9657 ("btrfs: zoned: support RAID0/1/10 on top of raid stripe tree")
CC: stable@vger.kernel.org # 6.7+
Signed-off-by: Miroslav Cimerman <mc@raidlab.org>
---
v2: new. An LLM review of v1 found that v1 failed a degraded mount here,
where it loaded before. A later review found that capping zones with
extents past the capacity let a regular mount accept a stale stripe. The
fix and the commit message were prepared with the help of an LLM, which
also tested it. I reviewed everything.

btrfs sets an active zone limit for devices that report none, so the
zones are finished on almost every device. DUP, RAID0 and RAID10 are not
changed here. RAID0 and RAID10 add up the capacities of their stripes.
In testing with different zone capacities, writes past the smallest one
failed, and so did the next mount. RAID10 also compares the two stripes
of a pair as RAID1 did. I will send fixes for RAID0 and RAID10 with the
RAID10 fixes mentioned in 1/5.

Blocks of the log tree are never in the extent tree. File data is never
only in the log tree here: zoned RAID1 data needs the raid-stripe-tree,
and an fsync of new RAID1 data commits the transaction. A tree-log block
group written past the capacity only by log tree blocks would still be
capped, and log replay would then move the allocation offset past the
capacity. I was not able to get that tested: in my tests on null_blk,
every fsync on a zoned filesystem committed the transaction, also for
changes without new data.

Not changed here, and found only by reading the code: with different
capacities, a crash between the last write to a block group and its zone
finish leaves the smaller zone FULL and the larger one open, at the same
write pointer. A regular mount then activates the block group while
loading it, which warns for metadata and fails the mount for data when
no active zone is left.

 fs/btrfs/zoned.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index ce7c535adff6..48f8391a80a9 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1536,6 +1536,20 @@ static int btrfs_load_block_group_raid1(struct btrfs_block_group *bg,
 	for (i = 0; i < map->num_stripes; i++)
 		bg->zone_capacity = min_not_zero(bg->zone_capacity, zone_info[i].capacity);
 
+	/*
+	 * A full zone reports its own capacity as its write pointer. With more
+	 * capacity than the block group, take it as written up to the block
+	 * group's capacity, unless an extent ends past that capacity: then the
+	 * block group was written with a larger one, and the zone keeps its
+	 * write pointer.
+	 */
+	for (i = 0; i < map->num_stripes; i++) {
+		if (zone_info[i].alloc_offset == zone_info[i].capacity &&
+		    zone_info[i].alloc_offset > bg->zone_capacity &&
+		    last_alloc <= bg->zone_capacity)
+			zone_info[i].alloc_offset = bg->zone_capacity;
+	}
+
 	/*
 	 * When the last extent is removed, last_alloc can be smaller than the other write
 	 * pointer. In that case, last_alloc should be moved to the corresponding write
@@ -1920,6 +1934,22 @@ int btrfs_load_block_group_by_raid_type(struct btrfs_block_group *bg,
 	return ret;
 }
 
+/* Whether the zones of the present stripes have different capacities. */
+static bool zone_capacities_differ(const struct btrfs_chunk_map *map,
+				   const struct zone_info *zone_info)
+{
+	u64 capacity = 0;
+
+	for (int i = 0; i < map->num_stripes; i++) {
+		if (!zone_info[i].capacity)
+			continue;
+		if (capacity && zone_info[i].capacity != capacity)
+			return true;
+		capacity = zone_info[i].capacity;
+	}
+	return false;
+}
+
 int btrfs_load_block_group_zone_info(struct btrfs_block_group *cache, bool new)
 {
 	struct btrfs_fs_info *fs_info = cache->fs_info;
@@ -1989,6 +2019,19 @@ int btrfs_load_block_group_zone_info(struct btrfs_block_group *cache, bool new)
 			set_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &cache->runtime_flags);
 			goto out;
 		}
+	} else if ((map->type & BTRFS_BLOCK_GROUP_RAID1_MASK) &&
+		   zone_capacities_differ(map, zone_info)) {
+		/*
+		 * The RAID1 loader caps a full zone only if no extent
+		 * ends past the block group's capacity.
+		 */
+		ret = calculate_alloc_pointer(cache, &last_alloc, new);
+		if (ret) {
+			btrfs_err(fs_info,
+			"zoned: failed to determine allocation offset of bg %llu",
+				  cache->start);
+			goto out;
+		}
 	}
 
 	ret = btrfs_load_block_group_by_raid_type(cache, map, zone_info, active, last_alloc);
-- 
2.53.0

