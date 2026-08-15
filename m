Received: from altprdrgo006.altice.prod.cloud.openwave.ai (altprdrgo006.altice.prod.cloud.openwave.ai [66.179.105.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD7335E944
	for <linux-btrfs@vger.kernel.org>; Sat, 15 Aug 2026 15:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.179.105.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786808544; cv=none; b=NeNFaig7eZ8QPUJaZMuqWD0bLJqSdnyPt5n6BX0ZI6Z4lIdjykI4mgKhBCy7J4fqlJtYOZmLPYxzaEK7yJ5o/o9GW3ff0fCFEkmE5hrmpYj37hUPMhl3xGa0pkb9WEV/P3TxbLD3Rb/GZy/iHo0WlcM9GNI2PI6EKhkp5aUjiQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786808544; c=relaxed/simple;
	bh=p81VFQ0rHss+EvDPZD3i6eEVx78o7z4wk5eBhds38nc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nlfpi8gnI/iALpBWzJAdlEFemDHnwwCW67+9KZydOHdPaBlawlv9dxTBZP2MGbnbjMbibmHyOjTbIBnA+no2WgCPZR0vvFky6fBZUoKNQ8TrEPPkKqkTBFJHiPtUFNqTjRJDM9lfpJ0AA22vAzIaLGv9MLgj0BU0yU1GiaGBouw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=optonline.net; spf=pass smtp.mailfrom=optonline.net; dkim=pass (2048-bit key) header.d=optonline.net header.i=@optonline.net header.b=UKUr2HgS; arc=none smtp.client-ip=66.179.105.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=optonline.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=optonline.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=optonline.net header.i=@optonline.net header.b="UKUr2HgS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=optonline.net; s=dkim-002; t=1786808541; 
        bh=K4l8eAVySIIwdMZRpuvfrLlu/8yeTTmTBNsU6YiXJhs=;
        h=From:To:Subject:Date:Message-ID:In-Reply-To:References:MIME-Version;
        b=UKUr2HgSVTEh0war+AXBzh0IG+Bxs0YjaKi019c2tjTrZAvfRD71eqnts2UlzbPbBsHWUGvGcUIo9xjjc1LnkfhAYNeuz2+geUCEbJuhw4sJI838gsrxJMbasbWY7z8PAb6Iq27bUUqtCrBLXn2VWXRdrNU5CM7x4vUMBrAX8XOVjdfnkKuCUEIrSNelzEOUMRZzCaONkYZKWxJHZLvC5SUHbgOTVHx1aIPkYW93i/qzWk8TWshyDfXFposrXQ98X6Ne19ExRVDofIER8h8brvtjefzF5+E3R/9chRGHgiAYrvk98500jOsExAYh/ZFmilIidgiP8WCG6VrKtwdXRQ==
X-RG-VS-CS: clean
X-RG-VS-SC: 0
X-RG-VS: Clean
X-RG-Env-Sender: jamesowens@optimum.net
X-RG-Rigid: 6A80590D00075526
X-RazorGate-Vade: dmFkZTFB7AkcyiM9kX01BJsx1zoccQJ4EtkVFKWLUhlyezM2hA4KjleTx+q4MlILD1iK7N0xspnDS+HObNot3aDYvGLF37qdkk86j8EbzgzVuaF7zwNgWZqbDaHi/zCVSqsU4qXqvDvhtcssU10HfUlDd1o8DvIsdDap+4ueJHLEp8f7aYgtXWAyMUiW94s0BX8p+g1HBXJl1RxNIMTYb5tKaavqY2FJwaKe9gZGtfAB+SCfWqA4lpv9JBYoPiK3JgdEn/89MuZN9tz3sZIesbZyaCTv6e5ZrXaOSP3NHSVcGfCABtFk3kY/uiUSszLVyf0puDjSMzY/Sgt+fC2364Ehn0Y6M6iyK6bUVjUI4Uu4M4T7Fa53CDOeb4lOnkUP+wFtLMM7Xypu68v80/I3O3Ax+BExNZF/CydRmWg6tNRd80L3ZuxgkYvLPOgnp/G8zUAtQ9SjoK1LAEsi410KE5BWOWXdOhjMSIXYgzhDjLyvpTlCkQkCXkI4lcq49ONDB7QzcZAKo+sjYPIGEeokiDFLLcs6Vi6shOhA1Qj6+vH8U3HnQ6O7aNX5fgy+16nhdhOI/tQmw96YhRhI2/ZrnVl6u+o1K8AhNAZNjjmBml1srkmYfzw0076ls/23u041cypocBbqY59h6vfMxMA49v/Ge0WPGoUlQS+qbTem/XKCbRBPNw
X-RazorGate-Vade-Verdict: clean 0
X-RazorGate-Vade-Classification: clean
Received: from jco-monster-ng.jcowens.net (68.197.170.124) by altprdrgo006.altice.prod.cloud.openwave.ai (authenticated as jamesowens)
        id 6A80590D00075526; Sat, 15 Aug 2026 11:36:02 -0400
From: "James C. Owens" <jamesowens@optonline.net>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com
Subject: [PATCH v2] btrfs: scrub: report the failing sector's address, not the stripe base
Date: Sat, 15 Aug 2026 11:34:16 -0400
Message-ID: <20260815153416.138869-1-jamesowens@optonline.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260814162405.1434693-1-jamesowens@optonline.net>
References: <20260814162405.1434693-1-jamesowens@optonline.net>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

scrub_stripe_report_errors() iterates over the sectors of a stripe, but
every message it emits passes stripe->logical, the address of the first
sector of the 64KiB stripe, rather than the address of the sector being
reported. The physical address is likewise computed once, before the
loop, from stripe->logical.

This matters because scrub_print_common_warning() uses that logical
address for the backref walk which produces the "root %llu inode %llu
offset %llu ... (path: ...)" part of the message. As the address is
always the stripe base, the reported root/inode/offset/path can identify
a different file from the one whose sector actually failed.

A 64KiB stripe routinely spans several extents belonging to unrelated
files. On the machine where this was found, the stripe at logical
0x17D9380000 holds four sectors of /usr/share/plasma/emoji/bg.dict, then
a file inside a docker volume, then sectors referenced only by
snapshots. Every error anywhere in that stripe is attributed to bg.dict.

The effect is visible statistically: across ten months and four kernel
series that machine logged 81 distinct flagged logical addresses, and
every one of them is exactly 64KiB aligned. Since BTRFS_STRIPE_LEN is
64KiB and stripe->logical is stripe aligned by construction, real
failures distributed across sectors could not produce that.

Report the address of the sector actually being examined. Adding the
sector offset to the physical address is valid because BTRFS_STRIPE_LEN
is the unit contiguous on a single device for every profile, so a stripe
never crosses a device boundary.

Fixes: 0096580713ff ("btrfs: scrub: introduce error reporting functionality for scrub_stripe")
Signed-off-by: James C. Owens <jamesowens@optonline.net>
Reviewed-by: Qu Wenruo <wqu@suse.com>
---
v2:
 - Regenerate the patch with git format-patch. v1 was produced with plain
   diff(1) and so lacked the diffstat, the "diff --git" header, the index
   line and the function context in the hunk headers. Thanks Qu for catching
   it; no code change.
 - Add the Fixes: tag Qu supplied.
 - Carry Qu's Reviewed-by.

 fs/btrfs/scrub.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index d2f7ac5b6e96..09b6003d3019 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1041,6 +1041,10 @@ static void scrub_stripe_report_errors(struct scrub_ctx *sctx,
 
 skip:
 	for_each_set_bit(sector_nr, &extent_bitmap, stripe->nr_sectors) {
+		const u64 sector_logical = stripe->logical +
+			((u64)sector_nr << fs_info->sectorsize_bits);
+		const u64 sector_physical = physical +
+			((u64)sector_nr << fs_info->sectorsize_bits);
 		bool repaired = false;
 
 		if (scrub_bitmap_test_bit_is_metadata(stripe, sector_nr)) {
@@ -1069,12 +1073,12 @@ static void scrub_stripe_report_errors(struct scrub_ctx *sctx,
 			if (dev) {
 				btrfs_err_rl(fs_info,
 		"scrub: fixed up error at logical %llu on dev %s physical %llu",
-					    stripe->logical, btrfs_dev_name(dev),
-					    physical);
+					    sector_logical, btrfs_dev_name(dev),
+					    sector_physical);
 			} else {
 				btrfs_err_rl(fs_info,
 			   "scrub: fixed up error at logical %llu on mirror %u",
-					    stripe->logical, stripe->mirror_num);
+					    sector_logical, stripe->mirror_num);
 			}
 			continue;
 		}
@@ -1083,30 +1087,30 @@ static void scrub_stripe_report_errors(struct scrub_ctx *sctx,
 		if (dev) {
 			btrfs_err_rl(fs_info,
 "scrub: unable to fixup (regular) error at logical %llu on dev %s physical %llu",
-					    stripe->logical, btrfs_dev_name(dev),
-					    physical);
+					    sector_logical, btrfs_dev_name(dev),
+					    sector_physical);
 		} else {
 			btrfs_err_rl(fs_info,
 	  "scrub: unable to fixup (regular) error at logical %llu on mirror %u",
-					    stripe->logical, stripe->mirror_num);
+					    sector_logical, stripe->mirror_num);
 		}
 
 		if (scrub_bitmap_test_bit_io_error(stripe, sector_nr))
 			if (__ratelimit(&rs) && dev)
 				scrub_print_common_warning("i/o error", dev, false,
-						     stripe->logical, physical);
+						     sector_logical, sector_physical);
 		if (scrub_bitmap_test_bit_csum_error(stripe, sector_nr))
 			if (__ratelimit(&rs) && dev)
 				scrub_print_common_warning("checksum error", dev, false,
-						     stripe->logical, physical);
+						     sector_logical, sector_physical);
 		if (scrub_bitmap_test_bit_meta_error(stripe, sector_nr))
 			if (__ratelimit(&rs) && dev)
 				scrub_print_common_warning("header error", dev, false,
-						     stripe->logical, physical);
+						     sector_logical, sector_physical);
 		if (scrub_bitmap_test_bit_meta_gen_error(stripe, sector_nr))
 			if (__ratelimit(&rs) && dev)
 				scrub_print_common_warning("generation error", dev, false,
-						     stripe->logical, physical);
+						     sector_logical, sector_physical);
 	}
 
 	/* Update the device stats. */

base-commit: 15ef2f78c49d20d53ec7c0f1c9b40b02e089f2d6
-- 
2.55.0

