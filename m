Received: from altprdrgo002.altice.prod.cloud.openwave.ai (altprdrgo002.altice.prod.cloud.openwave.ai [66.179.105.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D8E485CCD
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Aug 2026 16:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.179.105.249
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786724917; cv=none; b=sUAx8ens8FnnlFlkOdgYBA2/VtI3xb1uCDwxh7q+2xBV+NNFLkz8zcLo4EBxZdjlXig/bmf2/Rd28JBFYVMg5sE6WvXvvENtY7QQsTxkK66aSi6zW3qdrldeZB652mBZ01R5UO9fokBIz+EsvU1KZcx0kxp5nUWwnzpMuZbrw8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786724917; c=relaxed/simple;
	bh=SE+9pgiLsOTc+rlJ7UI1ZzoD248G1KBJGMde4ljp38k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EjUbD43B2vxcvkgyotEa+N7ff+f488A3QvHjFwlpt4otpvB3KTwTW9yhGChxtBxZ4enKhK9BB4ldAIK6ccxOeDuilDkjJyFin5sGUo/SFgBe/aLQwe032ItJgh/Pa7Lh/OKRh2xdoUzKK6xLI2OxHrF7egmLSllqoN4mfGPSk+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=optonline.net; spf=pass smtp.mailfrom=optonline.net; dkim=pass (2048-bit key) header.d=optonline.net header.i=@optonline.net header.b=SiaZC3/u; arc=none smtp.client-ip=66.179.105.249
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=optonline.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=optonline.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=optonline.net header.i=@optonline.net header.b="SiaZC3/u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=optonline.net; s=dkim-002; t=1786724914; 
        bh=HVP2ubTBFSPmtHRh6mhFxBym0+E6DUnNCPMJL+bqle0=;
        h=From:To:Subject:Date:Message-ID:MIME-Version;
        b=SiaZC3/uBPWVmneHca6MwMNkMRRSfW8pTaO24erFPSBXosnSD3HT/ibvguWK/IKDBWrG6jhkvV2gRBQkAkayOdIUpg5rJenoxuN2KT7GIRynvydQQ+pQxPlUw8IIaUsxmbvQJE4uR0zTz2sr8htWQBj4ekWj8CKdDz+s+m56cPNj4S+OXF/16hOjcue2h/T0BakNlalLLsI7g7GtBELH+tUMMhKVSL6qj2QOgAFki7K5RY0Q9A05q9BEF/pNZh2DIsvFde0q9+7JKwgqwN+ZrQ8Gl8lOZwoQVz/Q9fqSFQngRrDeq7C4GctieCtPc015kJ/IbYQQ8S/LldV2XeJzkw==
X-RG-VS-CS: clean
X-RG-VS-SC: 0
X-RG-VS: Clean
X-RG-Env-Sender: jamesowens@optimum.net
X-RG-Rigid: 6A7F24300005ADDB
X-RazorGate-Vade: dmFkZTFgSN/F7wwvthI+KbDoiouOiALTr3TPaYTcxM/m4vXCGqjmTlIDuuc3TsFpCBG0Qy5fy5PyfhlfJnADUkvqpa8UGbZ4ImusVOTi8XFLeO7vPNUjNEy+PX9huyGcpkSBhzvbi7fZXTPNUQQYIG8ysDOeCycX7WMgAm1qfwNp/t84gHGibGh0ffFIdwPeKkOM5dY/Y9wjzSZ2IluiPYguPJwD7n+BVP++PyQH0eSZGzuKnxxNkk3AYtx4b7c6UTy9nMVvifqqXM/9r7R4rGV1z7w5xugCS56FuVdKVjMISIn8Ab4UiVLZj1NrM2+thEKEF9pqljMSahWBjSk2AOHRupGXCcjRaiPFcCScWCycQsZ650Cx1csWNYnvlKhBG6+0xK53lJnia/C40nTkZSxuWeondeHyp8ckaEV/M9Y5VCtKNKLFZBpAucizy4GxYi3DaSmyXhf5B2kn5LEm6osZeYlMX6ox5N2naQoPPK2UD1MUiB3qxf24qMeEQ1EJy0Pch3irSyCSKS1FMw24KIIATzzXGVWUv4gqdugB2sM3cBSR2bajyJRc+fTMvCNBcw4g9WFq3j/OvpTqlf0q0nzI/UfnpNdvmqDEUygyCm26HH6lulZNRz0GZoYk+lH8/rB/vA1fPPqHwcoXLvk1D7eiaB/W1XgX6TXCBwe7jvU6why01Q
X-RazorGate-Vade-Verdict: clean 0
X-RazorGate-Vade-Classification: clean
Received: from jco-monster-ng.jcowens.net (68.197.170.124) by altprdrgo002.altice.prod.cloud.openwave.ai (authenticated as jamesowens)
        id 6A7F24300005ADDB; Fri, 14 Aug 2026 12:24:57 -0400
From: "James C. Owens" <jamesowens@optonline.net>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com,
	wqu@suse.com
Subject: [PATCH] btrfs: scrub: report the failing sector's address, not the stripe base
Date: Fri, 14 Aug 2026 12:24:05 -0400
Message-ID: <20260814162405.1434693-1-jamesowens@optonline.net>
X-Mailer: git-send-email 2.55.0
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

Signed-off-by: James C. Owens <jamesowens@optonline.net>
---
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1045,6 +1045,10 @@
 
 skip:
 	for_each_set_bit(sector_nr, &extent_bitmap, stripe->nr_sectors) {
+		const u64 sector_logical = stripe->logical +
+			((u64)sector_nr << fs_info->sectorsize_bits);
+		const u64 sector_physical = physical +
+			((u64)sector_nr << fs_info->sectorsize_bits);
 		bool repaired = false;
 
 		if (scrub_bitmap_test_bit_is_metadata(stripe, sector_nr)) {
@@ -1073,12 +1077,12 @@
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
@@ -1087,30 +1091,30 @@
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
-- 
2.51.0
