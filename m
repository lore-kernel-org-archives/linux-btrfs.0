Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=109.224.244.106
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795124428;
	b=3+3MEqSGVAm1/O2LItulEFGZGiWLz65eXPFwOVYjN6MYRVRO0GoXH/ROl6lWMI2K47mN
	 wSulQ6MFQf9LpSUjFnS9f+zg4t1sCjmXClbBKU87Be6LsrPL+1VOgavE8iwMhuFsboFR9
	 m2yHDwrmpH9N5uekFvmI1NUg8BO+fYB7A5vf9PNQ7+DlaGLaNuhnxq+D9I6S/M5xaTk9N
	 NUruV4VlyBDaG2tgTUKCKLvkX3tvstAFVHENkmHmV7HZFTiYWSCzRAebmdB3ILUW07vnc
	 bRNJ9KmTETE/fiaHSMloWSmaTR2C7ky8Z0hkXTZya/c6C1f5PFBf9UYSpUvTzn/iXlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795124428;
	h=DMARC-Filter:DKIM-Signature:X-Pm-Submission-Id:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=vhEoqq6jM/5MnC4TqVMNhHOIsvcSptsryDNY3ThC9jU=;
	b=jub58VDLBezcZcnnPNsIBjJjH7wFwodn1x/4CaYaYNQLKuPxM67IjKnRyqpUtRfH6Iih
	 GqaGCFRNrs5aVcTAx14MKXB/CBN/KCqgb3JfIU6pgA58j8HvTxzhsbZWgqAvymB268XqG
	 RLKzjM70qqO87dAEAGzaY7IIoJf66W/lGC4cjWd17RTPWM+eCgqHhtMAnfrQD8fbfCfXF
	 Ax+MyHQr8WXTwFCExU0Nl9nYzvlQUISVPrQ/dR3diroR4zY2F86ydnz2leUTnqWqaGxgj
	 kXk+ckFhJgm+GM+vFR/lcsS5uAb8oMx8NSfrCD3PfOkeaTs4z3BKWIT346h03vF8f3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=raidlab.org;
	spf=pass smtp.mailfrom=raidlab.org;
	dkim=pass header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b="Zj/DpSNw";
	arc=none smtp.remote-ip=109.224.244.106
Received: from mail-244106.protonmail.ch (mail-244106.protonmail.ch [109.224.244.106])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C73F7606A335
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2026 21:40:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C73F7606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raidlab.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raidlab.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=Zj/DpSNw
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=raidlab.org;
	s=protonmail; t=1795124425; x=1795383625;
	bh=vhEoqq6jM/5MnC4TqVMNhHOIsvcSptsryDNY3ThC9jU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:From:To:
	 Cc:Date:Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=Zj/DpSNwHSZKKGZoTjfTY3mmm4m35yzYxzLYaYW3E7aGwt73nG8b+3zXNheL3x3T/
	 0MirnK1SBPq0jInlaVl8l7CAblHL9fZnJZXDhOjlZ+TJae7gx4J4xvfrjBxbnRX8y4
	 POfDxy2M6q6Bwvp7O4SeMzvBiMDMV7iUawH+fNdveRm9TVethwJZeO55ofT34y2L2B
	 mJ9L4yNFmSgQ8P2cz8brscgq8LF9FyytjqRzAXTo5SjrAyWh5PDfV7luOwKy0YHfcw
	 U81Pw8SOWcUdl0cn8PsQ7rrnCqAc+6OJd5T8AOnTo86Z4YkmjesXFr4sOhK2m8q7JA
	 sCFr5ExEBUUgw==
X-Pm-Submission-Id: 4jVsMX1MJvz1DDXR
From: Miroslav Cimerman <mc@raidlab.org>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] btrfs: zoned: use the highest RAID1 write pointer on degraded mounts
Date: Thu, 19 Nov 2026 21:38:33 +0000
Message-ID: <20261119213835.103131-3-mc@raidlab.org>
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

The write pointers of a RAID1 block group's stripes can differ after a
crash, or when a device missed committed writes and came back. A
regular mount fails then, and commit b0c26f479926 ("btrfs: zoned:
return EIO on RAID1 block group write pointer mismatch") relies on
manual intervention: a degraded mount and a full balance. On a degraded
mount, btrfs_load_block_group_raid1() ignores the mismatch and takes
the allocation offset from stripe 0. If stripe 0 is behind, new extents
are allocated over committed ones:

  stripe 0 (behind)  | a | a |   |   |
  stripe 1           | a | a | b | b |
                             ^
                             allocation offset from stripe 0,
                             new extents go over b

  BTRFS error (device nb2): failed to run delayed ref for logical 155189248 num_bytes 1048576 type 178 action 1 ref_mod 1: -17
  BTRFS error (device nb2 state A): Transaction 18 aborted (-EEXIST)

or, with CONFIG_BTRFS_ASSERT, an assertion in the free space tree fails:

  assertion failed: start >= found_start && end <= found_end, in fs/btrfs/free-space-tree.c:742

A stripe that is not behind has all committed extents below its write
pointer, the highest one. If no present stripe is up to date, the
highest write pointer can still be below committed extents, as before.
On a degraded mount, take the allocation offset from it, and warn about
the block group. Until a balance copies the block group to new zones,
reads of what the stripes behind miss fail their checksums and go to the
other copies, and writes to them can fail, as they already could when
stripe 0 was ahead. Data without checksums can return what a stripe
behind holds there.

Compare the write pointers with the first present stripe, and leave
missing stripes out of the highest one. With stripe 0 missing, the
allocation offset came from the last stripe, which can be missing as
well in RAID1C3 and RAID1C4, and the block group then failed to load.

An offline or read-only zone, or one whose zone report fails with -EIO
or -EOPNOTSUPP, counts as a missing stripe. With stripe 0's zone in that
state, a regular mount failed on the comparison, while with another
stripe's zone in that state it loaded. Now both load.

Fixes: 568220fa9657 ("btrfs: zoned: support RAID0/1/10 on top of raid stripe tree")
CC: stable@vger.kernel.org # 6.7+
Signed-off-by: Miroslav Cimerman <mc@raidlab.org>
---
Found with FuzzyRAID, a fault-injection tester for RAID that is not
public at the moment. The analysis, the fix and the commit message
were prepared with the help of an LLM, which also tested it. I reviewed
everything.

Making such a block group unallocatable instead, as b1934cd60695 did,
was replaced by failing the mount in b0c26f479926. With the highest
write pointer, the degraded mount and balance that b0c26f479926
describes keep working, and in testing, a regular mount works again
after the balance.

Scrub on such a degraded mount finds what the stripes behind miss, but
does not repair it, as zoned repairs are skipped on degraded mounts.
Repairing there would let scrub fix the block groups where it finds
errors, instead of a balance. That is discussed in the thread of
"btrfs: scrub: don't count zoned repairs as corrected on a degraded
mount":
https://lore.kernel.org/linux-btrfs/20261118175637.60283-1-mc@raidlab.org/

 fs/btrfs/zoned.c | 36 +++++++++++++++++++++++++++---------
 1 file changed, 27 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 8eac6e2283a2..8bd44dd260a4 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1522,6 +1522,8 @@ static int btrfs_load_block_group_raid1(struct btrfs_block_group *bg,
 					u64 last_alloc)
 {
 	struct btrfs_fs_info *fs_info = bg->fs_info;
+	u64 highest = 0;
+	bool mismatch = false;
 	int first = -1;
 	int i;
 
@@ -1559,13 +1561,24 @@ static int btrfs_load_block_group_raid1(struct btrfs_block_group *bg,
 		if (first < 0)
 			first = i;
 
-		if (unlikely((zone_info[0].alloc_offset != zone_info[i].alloc_offset) &&
-			     !btrfs_test_opt(fs_info, DEGRADED))) {
-			btrfs_err(fs_info,
-			"zoned: write pointer offset mismatch of zones in %s profile",
-				  btrfs_bg_type_to_raid_name(map->type));
-			return -EIO;
+		if (zone_info[first].alloc_offset != zone_info[i].alloc_offset) {
+			/*
+			 * A stripe is behind the others after a crash, or when
+			 * its device missed committed writes and came back.
+			 * This fails a regular mount. A degraded one allocates
+			 * from the highest write pointer: committed extents are
+			 * below it, unless all present stripes are behind.
+			 */
+			if (unlikely(!btrfs_test_opt(fs_info, DEGRADED))) {
+				btrfs_err(fs_info,
+				"zoned: write pointer offset mismatch of zones in %s profile",
+					  btrfs_bg_type_to_raid_name(map->type));
+				return -EIO;
+			}
+			mismatch = true;
 		}
+		highest = max(highest, zone_info[i].alloc_offset);
+
 		if (test_bit(first, active) != test_bit(i, active)) {
 			if (unlikely(!btrfs_test_opt(fs_info, DEGRADED) &&
 				     !btrfs_zone_activate(bg))) {
@@ -1577,10 +1590,15 @@ static int btrfs_load_block_group_raid1(struct btrfs_block_group *bg,
 		}
 	}
 
-	if (zone_info[0].alloc_offset != WP_MISSING_DEV)
-		bg->alloc_offset = zone_info[0].alloc_offset;
+	if (mismatch)
+		btrfs_warn(fs_info,
+		"zoned: write pointer mismatch in %s block group %llu, using the highest",
+			   btrfs_bg_type_to_raid_name(map->type), bg->start);
+
+	if (first >= 0)
+		bg->alloc_offset = highest;
 	else
-		bg->alloc_offset = zone_info[i - 1].alloc_offset;
+		bg->alloc_offset = WP_MISSING_DEV;
 
 	return 0;
 }
-- 
2.53.0

