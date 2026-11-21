Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=109.224.244.108
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795268767;
	b=13ZO9kecKidfFvig1k6/fEyD+3ztETUbeivEwWHii/h7iUSRYiuP3c2loou6Byckaeu8
	 XhHVZnvMa6y1pb1jTQPBJa3k3iDJar/QJv2ARF0i7tmFMPZ5rbCv12rWOevCtb3tanpmZ
	 w/DW1Zic7YH8gPbuuHh078Xzr3i0hivREL65g4qN9lvxEw2FNmzbmzhT1DWIn4omLMjO8
	 yJ2MlXqHPpr9iK6v0PXiiRRn0ZQtFeL+iv2AN1LqLJOLrv3TtDzPbUwQuF1OyY9v+sDf7
	 KT8s6b3BuEr3Rl6WsfIBruXc46afdCXIb5EPbgO8OPPvBlfT/Kb+jQKZhtqCp39HQhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795268767;
	h=DMARC-Filter:DKIM-Signature:X-Pm-Submission-Id:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=qjbIw5eltl0P3wNAC45BtR5hsOrnj/jw+NbLglvhSAI=;
	b=uQ5VtbWdYY/oB/+K0W4Vfcz5Cli8VbSE166sNfU40H2zU1zQec48iCjOfvj4VF8FjQgF
	 J9fw0GOmFf2aYvl0KhqBxG0gZr8PQ5ZZPLa78HHJlIl7Xj1ygYuVpkTx2Wpigz1EGGP3A
	 EmJFl/pMFAiEDy67sdaSDi4n8/0MND0gta5wgBozeHCmR+I7LF7hgHB1AsX1x4GKnhtgc
	 FDEg1WOs+9EkuGj3wGzYndCHKIZlik96Ts4cl7hYTk/VS0bFQxbbhC04aj2Sd78nnxjLZ
	 cwxgjG7YtcDPtdVpGsZz3STDArLarsv2bwD8klJQNR6fIS9PsG8t/U//+fIcyjL4HNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=raidlab.org;
	spf=pass smtp.mailfrom=raidlab.org;
	dkim=pass header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b="2F8EHpL/";
	arc=none smtp.remote-ip=109.224.244.108
Received: from mail-244108.protonmail.ch (mail-244108.protonmail.ch [109.224.244.108])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC349606A33D;
	Sat, 21 Nov 2026 13:46:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DC349606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raidlab.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raidlab.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=2F8EHpL/
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=raidlab.org;
	s=protonmail; t=1795268760; x=1795527960;
	bh=qjbIw5eltl0P3wNAC45BtR5hsOrnj/jw+NbLglvhSAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:From:To:
	 Cc:Date:Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=2F8EHpL/mQ+32lJJJyuP1Djhtgk4cxr3fmmbdBIFrNIuKnEx9ysReUpe8fg3HiGwD
	 Z1QwaygGu4LrrjqXhrOV/KjSUlmBhI1ayRut86P5eEBG6OyICMbpc/C8aWWED+Tvjr
	 pufN+uVOFQTdU6VGxBKzTBk+PVemsW++onoFMXHBDYoXJAwQeaPw4aooMRygalEnXi
	 9qJ4O2HFk8a07yEX3kpQ32cwwP0fW7dEO4ZrqQainQUjunovVzHcGUxWdypVK1B34P
	 VKLK7K48ISNi8yWwTB3gtB7RIxkqSfbuIVNpZRNO0zXYIxmvj8tjC0zK3VrvJ0xEfb
	 eRht+F78ggG4g==
X-Pm-Submission-Id: 4jWtl95n9tz1DDns
From: Miroslav Cimerman <mc@raidlab.org>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/5] btrfs: zoned: take the RAID1 active state from the first present stripe
Date: Sat, 21 Nov 2026 13:45:45 +0000
Message-ID: <20261121134550.216217-2-mc@raidlab.org>
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

btrfs_load_block_group_raid1() compares the active state of each present
stripe's zone with stripe 0's. A missing device has no active zones. So
with stripe 0 missing, an active zone of a present stripe always
mismatches. A degraded mount then neither activates the block group nor
marks it active. The block group is not on the list of active block
groups, while its zones are active and count against their devices'
active zone limits.

If it is a data block group, writing data to it tries to activate it,
which fails when the active zones left are reserved for metadata. With
no other data block group with room left, the allocation then returns
-EAGAIN, and the write waits for a zone finish forever:

  task:dd              state:D
   btrfs_new_extent_direct
   btrfs_dio_iomap_next
   iomap_iter
   __iomap_dio_rw
   btrfs_direct_write
   btrfs_do_write_iter
   vfs_write

If it is a metadata block group, writing tree blocks to it activates it
with a warning:

  WARNING: fs/btrfs/zoned.c:2451 at btrfs_zone_activate+0x72a/0xa60, CPU#1: btrfs/157
   btrfs_check_meta_write_pointer
   write_meta_extent_buffer
   btree_writepages

Compare with the first present stripe instead.

Fixes: 568220fa9657 ("btrfs: zoned: support RAID0/1/10 on top of raid stripe tree")
CC: stable@vger.kernel.org # 6.7+
Signed-off-by: Miroslav Cimerman <mc@raidlab.org>
---
Found by an LLM while testing this series. The fix and the commit
message were prepared with the help of an LLM, which also tested it. I
reviewed everything.

A mismatch between present stripes is not changed, apart from metadata
block groups with a stripe behind, see 4/5. On a degraded mount,
depending on which stripe comes first, the block group is marked active
at load without the zone of the other stripe accounted, or activated at
its first write if it has room left, which can fail as above when no
active zone is left. Both happened before too.

btrfs_load_block_group_raid10() compares the active state with stripe
0's too, but activates the block group on a mismatch instead of
skipping it. With stripe 0 missing, that warns at mount for a metadata
block group, and can fail the mount for a data block group when no
active zone is left. RAID10 also adds a zone capacity of 0 for a
missing first stripe of a pair, which fails the degraded mount once a
block group holds more than the capacity that is left. Neither is
changed in this series. I will send fixes for both.

 fs/btrfs/zoned.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index e6ce6f05ad75..8eac6e2283a2 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1522,6 +1522,7 @@ static int btrfs_load_block_group_raid1(struct btrfs_block_group *bg,
 					u64 last_alloc)
 {
 	struct btrfs_fs_info *fs_info = bg->fs_info;
+	int first = -1;
 	int i;
 
 	if ((map->type & BTRFS_BLOCK_GROUP_DATA) && !fs_info->stripe_root) {
@@ -1555,6 +1556,9 @@ static int btrfs_load_block_group_raid1(struct btrfs_block_group *bg,
 		if (zone_info[i].alloc_offset == WP_CONVENTIONAL)
 			zone_info[i].alloc_offset = last_alloc;
 
+		if (first < 0)
+			first = i;
+
 		if (unlikely((zone_info[0].alloc_offset != zone_info[i].alloc_offset) &&
 			     !btrfs_test_opt(fs_info, DEGRADED))) {
 			btrfs_err(fs_info,
@@ -1562,13 +1566,13 @@ static int btrfs_load_block_group_raid1(struct btrfs_block_group *bg,
 				  btrfs_bg_type_to_raid_name(map->type));
 			return -EIO;
 		}
-		if (test_bit(0, active) != test_bit(i, active)) {
+		if (test_bit(first, active) != test_bit(i, active)) {
 			if (unlikely(!btrfs_test_opt(fs_info, DEGRADED) &&
 				     !btrfs_zone_activate(bg))) {
 				return -EIO;
 			}
 		} else {
-			if (test_bit(0, active))
+			if (test_bit(first, active))
 				set_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &bg->runtime_flags);
 		}
 	}
-- 
2.53.0

