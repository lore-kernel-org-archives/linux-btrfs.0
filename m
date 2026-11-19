Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=79.135.106.113
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795124427;
	b=2pxFt602S+quoOQvb5WaQ0zM5OkijalrNPzPNFTA/IJjLd39tUFm6vZkz+ESwyJFGIM0
	 LzUKl4BM0t5Ziq7dnhir2+O4wRhAtTNKcEgHFflWBXamAaum60ru2wJx9d+ab6gHfDUdy
	 qVoLvNS5Y5Sl+z1t0O6I3UnuF4WYEEE0mI8MF3eEGIEw3TD6fain4AhI9MqR0yhWGzXCl
	 bESrPo5Xn5g6VLShdo0o9lGtE7C2JYe9QpJyER6OfvwyPDQ0sfPiDv3fBdw8HjIEOS/vC
	 YO0Hj80G4wmhFXk1R9m2450/E9RGqMblSoRLrBROZVBvcV7l/NGMOhh+G6rUl8B4EGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795124427;
	h=DMARC-Filter:DKIM-Signature:X-Pm-Submission-Id:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=nslFzgOpgAUKSjlgHfW9KAAolSPNb0dICXbeo/+kYUI=;
	b=uNXz07x/Ct6nNRmljLURGZ4kLslu7U+bxVhIhhGIodimTMvxGHSmC2UyzU4Jnjefl3wo
	 bci7RHT1oEUM4Y1Ib6oVGLdImS9Dv6spsWMz+8+w4qah7f1y21JqUoTWz2lIWEyJZw/e3
	 D5VNy8qB6E8QQH2o7f/8h6oQChQBgnUKkAa+UsOX6kR+gIT3RFDGsFEl1K53dcVZMShjM
	 sDsYiSWVCNt3EaB+f498dUdtGfgfTREFuwulGG0siuLXkrtSLULYO7HnAJoBMsBDqur07
	 4Frugn8CRpfHy407g2xPUIqKDScAtjUeAi72qiW1cu3NUbaBFrTGoaK784lu6aDBH8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=raidlab.org;
	spf=pass smtp.mailfrom=raidlab.org;
	dkim=pass header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=urGNTDGG;
	arc=none smtp.remote-ip=79.135.106.113
Received: from mail-106113.protonmail.ch (mail-106113.protonmail.ch [79.135.106.113])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 325A360A260C
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2026 21:40:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 325A360A260C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raidlab.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raidlab.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=urGNTDGG
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=raidlab.org;
	s=protonmail; t=1795124424; x=1795383624;
	bh=nslFzgOpgAUKSjlgHfW9KAAolSPNb0dICXbeo/+kYUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:From:To:
	 Cc:Date:Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=urGNTDGGpNCWzLAIYx77iwe1cw2Hs7nNFN+4EkgeTqX99NqHYZHdAxnauuKJUTMis
	 Qf0lcHuVTmmXD5UQeqnTJ95Uk5xuTGNAIMXhgUUnykDfoKGrgUI68rx3r4TZ5ZcF7I
	 MVdFA0mt2+NKNmlRnwU3U/iDOw5gUHcZ2EC0VbyjkI9Yxums1UQY0wMmmAsZY4LbCN
	 fRw5BZIJZ0HujYZLxUNZXAd5XTtctL9fecsuVZv0Ukgxeo/C7NGz7KvZY0qwHoxXm2
	 3xf/5kTDMmUPVCq73PiaYNwx7t83/yvXD0RtDOsc4D5H6bHtNiLXMNSnTFvgStWIuN
	 ZTrY6q9kespIw==
X-Pm-Submission-Id: 4jVsMV0fLsz1DDqy
From: Miroslav Cimerman <mc@raidlab.org>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] btrfs: zoned: take the RAID1 active state from the first present stripe
Date: Thu, 19 Nov 2026 21:38:32 +0000
Message-ID: <20261119213835.103131-2-mc@raidlab.org>
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

btrfs_load_block_group_raid1() compares the active state of each
present stripe's zone with stripe 0's. A missing device has no active
zones, so with stripe 0 missing, an active zone of a present stripe
always mismatches, and a degraded mount neither activates the block
group nor marks it active. It is then not on the list of active block
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
Found by an LLM while testing the next patch. The fix and the commit
message were prepared with the help of an LLM, which also tested it. I
reviewed everything.

A mismatch between present stripes, like a stripe behind the others on
a degraded mount, is not changed. Depending on which stripe comes
first, the block group is marked active at load without the zone of the
other stripe accounted, or activated at its first write if it has room
left, which can fail as above when no active zone is left. Both happened
before too. I can look at the active zone accounting for these zones
separately.

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

