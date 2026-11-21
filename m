Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=79.135.106.112
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795268768;
	b=CRMT717+J2xOfm8RXrFRAbsNSph+BRCRzUj+dhxPlDBYg1Du6QJWkzYVpVHqEcQml5Zf
	 A+/Ov6Cjhh9xZ7suVNdB0+qfV+bE3hag1GKVLwTsBpTJ73Ygjo2fhVFfQse5Tgrkd3lVN
	 0tW2QNKp26sZYEvs7aGVeN0X8Clg9T9s8S3l0Hr60PJS1GFJDLx3zEbxZNH2sbDMJhn0Q
	 uXFBLn8WH0oGvpraAXTyvdgDdnUrG4WM8OsfFu6xprRBfnoda0M3Zp5UWum3q5/fyr6FH
	 CulswJo562zPm08JNyDBIFnZGWnTAm52Vjuxj+J4UFv9GQtaAoIjUOc6x44RUEXPkDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795268768;
	h=DMARC-Filter:DKIM-Signature:X-Pm-Submission-Id:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=wwaIzSxGaoJ/ioKSJ8wNcO4s5yJJOi3EzyNX16TlETg=;
	b=m7XvPYvM9DtfYOiQvnoc9zlJCRNGVjzcucmKeM+OaZitcvlvYg842/yifIy3CwxRetZo
	 /COWUG0D2//bHZWTGiqxOvYOpY3M3Cgrv6ZQDNsWPpvB3VPWvBf37sBp12zFZezZIin8O
	 R6HAoIAqg+LYm3UIpTOd+sHYjwzxwbEnQ2mVeOa1h0Ljc5IX7P0A3K0SOlU7yjX41tdCt
	 OPhF/6N0WklrS5MHaT4Zq2N2qOH7AiHqPBEwQG4cuy8nt1tnHaGRqjEo/TpoHg43wfSxW
	 6QOsVvMGZP6OJMqoIh2ENvnwBFCQ7wo1JdoxD5fkPZ2sz+oev9QPz4JkMMpc+P2vY/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=raidlab.org;
	spf=pass smtp.mailfrom=raidlab.org;
	dkim=pass header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=QWCoisWO;
	arc=none smtp.remote-ip=79.135.106.112
Received: from mail-106112.protonmail.ch (mail-106112.protonmail.ch [79.135.106.112])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137BF606A332;
	Sat, 21 Nov 2026 13:46:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 137BF606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raidlab.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raidlab.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=QWCoisWO
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=raidlab.org;
	s=protonmail; t=1795268766; x=1795527966;
	bh=wwaIzSxGaoJ/ioKSJ8wNcO4s5yJJOi3EzyNX16TlETg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:From:To:
	 Cc:Date:Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=QWCoisWOtnuKAevulgaw6YuXdOb+6dKiBntqvZUzj75yUaRb2gQ9rlBMb9zOMG8vY
	 pwk+UscxKTCbCw3WImS6CKVfO8R8el8Bqaf3Vc/3XWZGh9Q67v/3A5tYpfKCY/i9kg
	 IdbsuCjPiJWN8tEBz3md6K7GtSRb3Vk1gz5Qzuu3wjwRU9VNowauIYVgUb9N/CMg0o
	 DonMT8VdXO0q9TeKTzq/uHlfZPFRuIt4lRTAnaCUzkis8HqhMCd3JQwYpmkGFDxR22
	 4TtxiyM0b7Wk8r5tOqCrWBYoEQA1BA41cuSp2AsKIaJlnluzkw0moxLRNKhrxGXQxg
	 TbY34HFc+RmCQ==
X-Pm-Submission-Id: 4jWtlJ2ZV4z1DDnx
From: Miroslav Cimerman <mc@raidlab.org>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/5] btrfs: zoned: use the highest RAID1 write pointer on degraded mounts
Date: Sat, 21 Nov 2026 13:45:48 +0000
Message-ID: <20261121134550.216217-5-mc@raidlab.org>
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
other copies. Writes to the stripes behind can fail, as they already
could when stripe 0 was ahead. Data without checksums can return what a
stripe behind holds there.

Once a block group with a stripe behind is full and finished, all its
zones report their capacity, and a later regular mount no longer sees
that a stripe was behind. Only the warning of the degraded mount tells
that a balance is needed.

The active state still comes from the first present stripe. If that is
an empty zone behind a written one, a metadata block group is not marked
active although it holds tree blocks. btrfs_zone_activate() then warns
at its next write: it expects a block group that is not active to be
empty. Tree blocks are written at the highest write pointer, which fails
on a stripe behind without opening its zone. So mark a metadata block
group with a mismatch active if any of its zones is. Data is written by
zone append to each stripe. So a data block group whose first present
zone is empty is still activated with all its zones at its first
allocation, if it has room and its devices have active zones left.

Compare the write pointers with the first present stripe, and leave
missing stripes out of the highest one. With stripe 0 missing, the
allocation offset came from the last stripe. In RAID1C3 and RAID1C4 that
stripe can be missing as well, and the block group then failed to load.

An offline or read-only zone, or one whose zone report fails with -EIO
or -EOPNOTSUPP, has no write pointer, as with a missing stripe. With
stripe 0's zone in that state, a regular mount failed on the comparison,
while with another stripe's zone in that state it loaded. Now both load.

Fixes: 568220fa9657 ("btrfs: zoned: support RAID0/1/10 on top of raid stripe tree")
CC: stable@vger.kernel.org # 6.7+
Signed-off-by: Miroslav Cimerman <mc@raidlab.org>
---
v2 (was 2/4): mark a metadata block group with a mismatch active if any
of its zones is. Sashiko found that with an empty first zone, it stayed
inactive and warned at its next write.

Found with FuzzyRAID, a fault-injection tester for RAID that is not
public at the moment. The analysis, the fix and the commit message
were prepared with the help of an LLM, which also tested it. I reviewed
everything.

Making such a block group unallocatable instead, as b1934cd60695 did,
was replaced by failing the mount in b0c26f479926. With the highest
write pointer, the degraded mount and balance that b0c26f479926
describes keep working, and in testing, a regular mount works again
after the balance.

A regular mount now loads a block group whose stripe 0 is on an offline
or read-only zone. Finishing the block group later fails on that zone,
which, for a metadata block group, turns the filesystem read-only. It
already did so with such a zone on another stripe.

Scrub on such a degraded mount finds what the stripes behind miss, but
does not repair it, as zoned repairs are skipped on degraded mounts.
Qu agreed to drop that skip in the thread of "btrfs: scrub: don't count
zoned repairs as corrected on a degraded mount", and I will send that
as its own patch:
https://lore.kernel.org/linux-btrfs/20261118175637.60283-1-mc@raidlab.org/
In testing, scrub then relocated the block groups where it found
errors, and a regular mount worked without a balance.

A degraded mount without the stripe with the smallest zone capacity uses
a larger one and can write past the smallest. This is not changed here.
With that stripe back, a degraded mount now fails to load such a block
group. Before, if that stripe was stripe 0, it took stripe 0's write
pointer, below the extents written while it was missing.

 fs/btrfs/zoned.c | 47 ++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 38 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 48f8391a80a9..8ce329da612d 100644
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
 
@@ -1575,13 +1577,24 @@ static int btrfs_load_block_group_raid1(struct btrfs_block_group *bg,
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
@@ -1593,10 +1606,26 @@ static int btrfs_load_block_group_raid1(struct btrfs_block_group *bg,
 		}
 	}
 
-	if (zone_info[0].alloc_offset != WP_MISSING_DEV)
-		bg->alloc_offset = zone_info[0].alloc_offset;
+	if (mismatch) {
+		btrfs_warn(fs_info,
+		"zoned: write pointer mismatch in %s block group %llu, using the highest",
+			   btrfs_bg_type_to_raid_name(map->type), bg->start);
+		/*
+		 * Metadata is written at the highest write pointer, which fails
+		 * on a stripe behind and opens no zone there.
+		 * btrfs_zone_activate() expects an inactive block group to be
+		 * empty, but this one holds metadata, so it is active if any of
+		 * its zones is.
+		 */
+		if (!(map->type & BTRFS_BLOCK_GROUP_DATA) &&
+		    !bitmap_empty(active, map->num_stripes))
+			set_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &bg->runtime_flags);
+	}
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

