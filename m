Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792948957;
	b=kXHoF73bAUHoT/IWbJpsC2/XW/oXMw4dv1Dh6y4a2kxb7ONoyChQgJJMg5e4Aue5o27r
	 Vk66ezMpSf/355CABi6NT5UZcRSMeZuBu/0JrtlFN7WoE6XKWhYUlROz9KrUxSGXmBrA1
	 k3aIdsBkmi6+hhWe+Qa0PJV5pSAGtZhAahFecYeHiSB1mPAlpmGC9UzMPoW5pBD5+GuKy
	 VHCS7w/o7wzXaVNIwUmb1r4ZukgjfG3Nx1j45404wyKZTfpOri2KYa+svmxi4DcgI2aA3
	 32xhCcux/Uh+95ZOqYQAb4t+7U9oQRumV+I+MrTnk0c+ujMy+m6dRC2q8Ba37bjIGgQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792948957;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=eS9Y9d3Zb14keEWC7bLDKOdub+3GfIlcm4vYIcfTgIc=;
	b=HmPBbQRTfywqkKHQolw9GRT2j8XpS9Mzpnn8XCgbXCOBaisi4TGhUsYN9wAv0XBTIdpT
	 2Mz4Y2QqiMhNsqs3nuyUYnjj5maKxVkVZRL+4BKH6vNlnVy7NRFOZSaAg/fzwG46x5axR
	 Qn/nOt+a9cjEG2vv8ekomsRi5xiyTU1NUyWp+4jPwIr5Vuck1W7xX+rnldpdnL4YiF1LA
	 Lv8jJxMNbdO9azEu3Pv6k8cPMU89Lz2rAc5MAb+ouGnqGhTPIMtR/HbFMm0ajEHV8zHRC
	 hcT/G76vxgJmnGJLHRwvqtmfWaYBk9gQC2BKWU3PfwA2ar5q2IduoRQx3HW1Sp/UfnA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gzYoCSIR;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AE3D606A326;
	Sun, 25 Oct 2026 17:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gzYoCSIR
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792948956;
	b=d9cHS83JBQINF5NPk0uzi4TjvoVDJrJf5ovYeesdv4gwWKr43XhGkaa8oqNOllozZpZD
	 xrRNT2vxHwTtY5NM47kvGQRbF7WXR2kB1UWAQQFbvYsNIb5YuUFac02AFz0M1xVX4481C
	 sMBZae7/p3YUxI0ALyF/5FyYlXvEGr0rTeMTNOZHO9HVshKlZg1K1mxnw4GVvm9hX09gh
	 8ueS6tvJMFoDzCOIDJOeTK+ax3XX7n4LdOUja/X+7Ncnoy/OOFScY7XiQk0KmTFt6olWo
	 9Rj8WeM5dxw7Sp/QlLjr6xZJp9CQ2nXYuBxXmyOTdfeWICfWaZelAjhBk+MCR/5rvBA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792948956;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=eS9Y9d3Zb14keEWC7bLDKOdub+3GfIlcm4vYIcfTgIc=;
	b=wO+bCDUgxx3ynboNsfPcwHzY4xmoB0vzYSteEd6nxVOjMRkpKJpEOvgoqHXVQhxBbe53
	 mARj0Z6eWFuuVR/TTK3O7rBb9GQ5w1KyDDdsgPgdo6ssyVaIIGT2h+Kb6aesjJof3UOQi
	 iBAVL37Ikp1x/lyY2E6xBL6eochSkjPToujDx6ZNZ+EBFrKFWP4AVNHf8KGEa52WOFikX
	 fWmHhtMSBgzHeTZmlnLMzkFhCdBLqEFpobfYobJo3nU4gACNuANRjzIsCy9UMKWpgCz2G
	 Vcr07sGwv3J8JjjJzNtIEePQD66BgZpvSBuNGvfkvBcdbNkd5icwjCPRpysQN/pDI1A==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id D92751F031E0;
	Sun, 25 Oct 2026 17:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792948956;
	bh=eS9Y9d3Zb14keEWC7bLDKOdub+3GfIlcm4vYIcfTgIc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=gzYoCSIRZgN/oAWuu7NzVu8jzRstM1Ftn6g4v2DGjiEHQC1NRk/1HGhMt+P6vjsux
	 LkvH5q4bTSunKcHJDqcmTL1Ke4MIS2qbIKhk49AvmcryrciIJiEPsY9ImokcXAlPmn
	 8/vWAxrV47/MsTKwGehu3nR1/8+fb6iro5f4v0Ki8aN53aCRD697s0s+H5HWje2SQK
	 BImHIUSiG+kCo8x/ohm0QZHMdyVPP1GCG3nmpOpIIPbDl1udgmst+laU7QXZ/RPAjO
	 ZXM7u7qKkN2h2RPJURpVLshZj09YQudQq98Dfytx/yDorcGzd9GdXKhHGO4n7G8djV
	 biqpEMDzATHqw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 4F69B44A88;
	Sun, 25 Oct 2026 17:22:34 +0000 (UTC)
From: Dhruva Gole via B4 Relay <devnull+goledhruva.gmail.com@kernel.org>
Date: Sun, 25 Oct 2026 17:21:52 +0000
Subject: [PATCH v2 3/3] btrfs: cover NOCOMPRESS inline eligibility and
 short tails
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261025-b4-btrfs-nocomp-v2-v2-3-628c1986f9b9@gmail.com>
References: <20261025-b4-btrfs-nocomp-v2-v2-0-628c1986f9b9@gmail.com>
In-Reply-To: <20261025-b4-btrfs-nocomp-v2-v2-0-628c1986f9b9@gmail.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Anand Jain <asj@kernel.org>, 
 Filipe Manana <fdmanana@suse.com>, Zorro Lang <zlang@kernel.org>, 
 Qu Wenruo <wqu@suse.com>, Dhruva Gole <goledhruva@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792948953; l=5180;
 i=goledhruva@gmail.com; s=remote-20261025; h=from:subject:message-id;
 bh=nSeOy4HCHBGmnWIBWdeEUmRx3/Kf0uqzyuynzDLXb2s=;
 b=hdLjnwCyiP7mZH3rd0qyBYpJRAVlsuGvMxA3admyu/205BegJe6BiIsNncxZGX/LijREG3lfU
 snXSbmIk/7PDvwR8r7g7t8LFvLGNfEBaAFET5ijcwwuzqtl4PmrbC7U
X-Developer-Key: i=goledhruva@gmail.com; a=ed25519;
 pk=OBz78Vw5K+/+HyXjxg9mNOV2Bq087eJgHL749H+Xe/k=
X-Endpoint-Received: by B4 Relay for goledhruva@gmail.com/remote-20261025
 with auth_id=1318
X-Original-From: Dhruva Gole <goledhruva@gmail.com>
Reply-To: goledhruva@gmail.com
Content-Transfer-Encoding: 7bit

From: Dhruva Gole <goledhruva@gmail.com>

Test that defrag --nocomp keeps a compressed inline extent while it is still
allowed by max_inline, and that it uncompresses the extent once remounted
with max_inline=0. Also exercise files with sizes of 1 byte, a sector minus
one byte, a sector plus one byte and a maximum compressed extent plus one
byte. Check the layouts with fiemap and the file contents with md5sum after
a remount.

Signed-off-by: Dhruva Gole <goledhruva@gmail.com>
---
 tests/btrfs/357     | 81 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/357.out | 39 ++++++++++++++++++++++++++
 2 files changed, 120 insertions(+)

diff --git a/tests/btrfs/357 b/tests/btrfs/357
new file mode 100755
index 00000000..f9c790bb
--- /dev/null
+++ b/tests/btrfs/357
@@ -0,0 +1,81 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Meta Platforms, Inc. and affiliates. All Rights Reserved.
+#
+# FS QA Test 357
+#
+# Test that defrag --nocomp keeps a compressed inline extent while it can stay
+# inline, uncompresses it once max_inline no longer allows it, and handles
+# files with short EOF tails.
+#
+. ./common/preamble
+_begin_fstest auto quick defrag compress fiemap
+
+. ./common/filter
+. ./common/punch # for _coalesce_extents
+
+# Keep all flags, including DATA_INLINE (0x200) and ENCODED (0x8), while
+# filtering out physical addresses. A compressed inline extent has flags 0x309
+# (DATA_INLINE | NOT_ALIGNED | ENCODED | LAST).
+_filter_fiemap_keep_flags()
+{
+	$AWK_PROG '
+		$3 == "hole" {
+			print $1, $2, $3;
+			next;
+		}
+		$5 ~ /^0x[[:xdigit:]]+$/ {
+			print $1, $2, $5;
+		}' | _coalesce_extents
+}
+
+_require_btrfs_defrag_nocompress
+_require_btrfs_support_sectorsize 4096
+_require_btrfs_no_nodatacow
+_require_btrfs_no_nodatasum
+_require_btrfs_no_autodefrag
+_require_btrfs_inline_extents_creation
+_require_xfs_io_command "fiemap"
+
+_wants_kernel_commit 009b2056cb25 \
+	"btrfs: defrag: add flag to force no-compression"
+
+_scratch_mkfs -s 4k >> $seqres.full 2>&1 || _fail "mkfs failed"
+_scratch_mount -o compress=zlib,max_inline=4096
+
+# Create a compressed inline extent and check both ENCODED and DATA_INLINE.
+$XFS_IO_PROG -f -c "pwrite -S 0xab 0 2K" $SCRATCH_MNT/compressed-inline | \
+	_filter_xfs_io
+echo "fiemap before defrag:"
+$XFS_IO_PROG -c "fiemap -v" $SCRATCH_MNT/compressed-inline | \
+	_filter_fiemap_keep_flags
+
+$BTRFS_UTIL_PROG filesystem defragment --nocomp $SCRATCH_MNT/compressed-inline
+_scratch_cycle_mount compress=zlib,max_inline=4096
+echo "fiemap after defrag with max_inline=4096:"
+$XFS_IO_PROG -c "fiemap -v" $SCRATCH_MNT/compressed-inline | \
+	_filter_fiemap_keep_flags
+
+_scratch_cycle_mount compress=zlib,max_inline=0
+$BTRFS_UTIL_PROG filesystem defragment --nocomp $SCRATCH_MNT/compressed-inline
+
+for len in 1 4095 4097 131073; do
+	$XFS_IO_PROG -f -c "pwrite -S 0xcd 0 $len" $SCRATCH_MNT/tail-$len | \
+		_filter_xfs_io
+	echo "tail-$len fiemap before defrag:"
+	$XFS_IO_PROG -c "fiemap -v" $SCRATCH_MNT/tail-$len | \
+		_filter_fiemap_keep_flags
+	$BTRFS_UTIL_PROG filesystem defragment --nocomp $SCRATCH_MNT/tail-$len
+done
+
+# Check the new layout and data are persisted.
+_scratch_cycle_mount compress=zlib,max_inline=0
+
+for f in compressed-inline tail-1 tail-4095 tail-4097 tail-131073; do
+	echo "$f fiemap after defrag:"
+	$XFS_IO_PROG -c "fiemap -v" $SCRATCH_MNT/$f | _filter_fiemap_keep_flags
+done
+md5sum $SCRATCH_MNT/{compressed-inline,tail-1,tail-4095,tail-4097,tail-131073} | \
+	_filter_scratch
+
+_exit 0
diff --git a/tests/btrfs/357.out b/tests/btrfs/357.out
new file mode 100644
index 00000000..2351f68b
--- /dev/null
+++ b/tests/btrfs/357.out
@@ -0,0 +1,39 @@
+QA output created by 357
+wrote 2048/2048 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+fiemap before defrag:
+0: [0..7]: 0x309
+fiemap after defrag with max_inline=4096:
+0: [0..7]: 0x309
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+tail-1 fiemap before defrag:
+0: [0..7]: 0x1
+wrote 4095/4095 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+tail-4095 fiemap before defrag:
+0: [0..7]: 0x1
+wrote 4097/4097 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+tail-4097 fiemap before defrag:
+0: [0..15]: 0x9
+wrote 131073/131073 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+tail-131073 fiemap before defrag:
+0: [0..255]: 0x8
+1: [256..263]: 0x1
+compressed-inline fiemap after defrag:
+0: [0..7]: 0x1
+tail-1 fiemap after defrag:
+0: [0..7]: 0x1
+tail-4095 fiemap after defrag:
+0: [0..7]: 0x1
+tail-4097 fiemap after defrag:
+0: [0..15]: 0x1
+tail-131073 fiemap after defrag:
+0: [0..263]: 0x1
+a97d075b76a2d5d777ebadd4e3f3be94  SCRATCH_MNT/compressed-inline
+e6cf2aa82fa371b686171ecd6a734e5d  SCRATCH_MNT/tail-1
+eb7177e6602dec278d9eb99dfcb32764  SCRATCH_MNT/tail-4095
+915c2ed4a6fdedfd3ef3bb4198d9b4f8  SCRATCH_MNT/tail-4097
+1e71d33e1f1368bb15cbe39b7b9f2447  SCRATCH_MNT/tail-131073

-- 
2.43.0


