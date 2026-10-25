Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792948956;
	b=G3Honn0Yaad6Av9K6OBGBve642gK4Bp0VGG55HYaWwqOY4Iod5SMauqKq51tmEKUiTL5
	 JU+X9rv2grcxPwKvST6pxeQjZxo63KmQFcued86EqD31jrWUcbJ3OxEPdRkK8c4zJK8oD
	 HyL1xxxZzAI/wnsyWq4NWToe5WTrHwPAvi2PacCvzl86DAdCoqUehAneShja2jD9eTXkO
	 qfFsm5wOgwo8Cj57EDN6dBxq2WVNiL3TZhPOvC7w6hOvXC6hgHkby3kL3WbK0NkLHXwHG
	 nySj1VtbbUjhCX7ye4KvnYiw61v7L22cwDk4qkBWUMPUvsJ7uMydthhmU2JG+FDqy8g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792948956;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=h1nGHx4vMQ+43ZjYamu+W6gEkU9ENuft+DX8Y06qt+g=;
	b=ehbnDozzcyoPZvNg8ymEOj12eBY7yHbS0QJNl/xWdTZ8i7Hp/L9pHn01hddf9xeDUjFM
	 eKMds1j1WH0g6AMlBT3BbndvAWECg2ueERMVCerP/McOl3lkjtp73Mog3jeL/2UHVduNj
	 Vgl/7T4B4bagW4pq9H4OARHAHHGCQuJxcbYRogp+BvyqGiSXo/v47NkGxInWqlQiE2JbF
	 mteSHRUCSw1cSqcGLI46z2vgGb2mW7GUCY8i1gHX7sTMPJXA8wQzP/nk6nTEyK6IudpTI
	 0yIpXqi692aXLxTLOR6YvqSf0fJNgaUTfrO+wtWa1uCRIXzKJ6zRcwFSUN1inmGamug==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a0HYBK0I;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BFE6606A31D;
	Sun, 25 Oct 2026 17:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a0HYBK0I
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792948956;
	b=XBrs0WQkt9gFTAAvI1kiIlI59+V4lMv2vY79Tchs7XLMGmjAAiJw0RYGQ+eraNC6OQV7
	 pjdTRXlGL+60987WW3xPiBfa2fe9GIAPa55lv4zADofDR0M3iLv4nNp2orphZbkAT0Bwk
	 kE3ldRlahLS0jqb/0DBAaNuBSLm6dZlJ+mW6ux4XQQYRT4QThBNkA0xww2KjkJZkMLK20
	 dDZWosg/PPAvieauwnwv+w9jRbnc67hFA7A7gpFGMQL/MeHE2K0ECUN/nGMXDyk5c/MCQ
	 x9cDQs8T5YgB9W1ocljozA83zOWhCInAgEvBRCXqYRKqI8Ewt2lgiwom62PUbfXI4cg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792948956;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=h1nGHx4vMQ+43ZjYamu+W6gEkU9ENuft+DX8Y06qt+g=;
	b=2rN0VIvYnFYHRAK3x/bYO60tmTl7rc2J6ky3Xd+Cbqf+SOqKZGkFyLcif3HSdf6UTzuU
	 W2Mgf7u1a0mQ0y0xwRfsudp4hq9H0MS2ER/6NM2t3CTJVpukhu2kebOHC09NyfucG2ucL
	 UaURtKQL4S/hCpSuDaKbEWLhSPPLUW8YbRLryaYoxLuP/b9EV/LHLJXGF+yPyiEMR34pV
	 r02J1BeMVPwBX7WzeJVDDN57uEeRg6CL7uDnxiC4awEb2LLE7GUxN1O2K1hBl/X5VRViV
	 RL7DZ48xSg9LKvGPYz/XIHKrcbESrNCjJl4TdCA2MKArYgwE8lRqHPEMLaFNKXXm7hg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id D67D51F01829;
	Sun, 25 Oct 2026 17:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792948955;
	bh=h1nGHx4vMQ+43ZjYamu+W6gEkU9ENuft+DX8Y06qt+g=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=a0HYBK0Ipsr4da69QIHlVSLgMR5fC13Ra63TJ32vmvY6yH3xf7cTVpTDjZUr3gKqJ
	 QxnbqMFEhFNLD6WphAMjI+5vTvPP4atdpzsG2NckQxYIR/ehYf5bsRvpahnJ+pU0gQ
	 G0hKP+RhtY7lwbOWUu2aY0AOq/LxL31/Yq3kQuuePtKT03dcc+TSk11xua8H8OsD1j
	 +O6z8EoLYAFOdKgeG94BAvJBdzs0mkjU8z/g01nbY5DgaD9hxpJqpYNWsZpgI2JzuK
	 xQJFCYX99q1kVq/loFkxSxzWTMa8H0P4E0ImlTs6iR4ZJCgfEDoysCfIeucfjPFCHN
	 jlUcgNteZtOsg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 3E0A144A7D;
	Sun, 25 Oct 2026 17:22:34 +0000 (UTC)
From: Dhruva Gole via B4 Relay <devnull+goledhruva.gmail.com@kernel.org>
Date: Sun, 25 Oct 2026 17:21:50 +0000
Subject: [PATCH v2 1/3] btrfs: exercise NOCOMPRESS range and EOF handling
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
Message-Id: <20261025-b4-btrfs-nocomp-v2-v2-1-628c1986f9b9@gmail.com>
References: <20261025-b4-btrfs-nocomp-v2-v2-0-628c1986f9b9@gmail.com>
In-Reply-To: <20261025-b4-btrfs-nocomp-v2-v2-0-628c1986f9b9@gmail.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Anand Jain <asj@kernel.org>, 
 Filipe Manana <fdmanana@suse.com>, Zorro Lang <zlang@kernel.org>, 
 Qu Wenruo <wqu@suse.com>, Dhruva Gole <goledhruva@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792948953; l=6350;
 i=goledhruva@gmail.com; s=remote-20261025; h=from:subject:message-id;
 bh=rRd6hUvaJQlEGRR2dEfgYnu+HGutmczMTsoASyOLXxY=;
 b=SkharaxXvjVQZxtxYZQCPXM0qx1I8o3U9QmitPNI3GoUELseXrPfKAiHr4T6SAqVfPmUX6+ms
 aL/MbOIzyS0BAQ2UFyXSp4MffcfV4rBbclpuS+IiaKPv0Af3p5b8LaH
X-Developer-Key: i=goledhruva@gmail.com; a=ed25519;
 pk=OBz78Vw5K+/+HyXjxg9mNOV2Bq087eJgHL749H+Xe/k=
X-Endpoint-Received: by B4 Relay for goledhruva@gmail.com/remote-20261025
 with auth_id=1318
X-Original-From: Dhruva Gole <goledhruva@gmail.com>
Reply-To: goledhruva@gmail.com
Content-Transfer-Encoding: 7bit

From: Dhruva Gole <goledhruva@gmail.com>

Test that defrag --nocomp only uncompresses the requested range of a file
with compressed extents, and that the range handling works for a partial
final sector, a zero length (up to EOF) and a length extending past EOF.
Check the resulting layout with fiemap and the file contents with md5sum
after a remount, against the golden output.

Also, add _require_btrfs_defrag_nocompress() to common/btrfs, which skips
the test if either btrfs-progs or the kernel lacks support for
defrag --nocomp.

Signed-off-by: Dhruva Gole <goledhruva@gmail.com>
---
 common/btrfs        | 14 ++++++++++
 tests/btrfs/355     | 76 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/355.out | 45 +++++++++++++++++++++++++++++++
 3 files changed, 135 insertions(+)

diff --git a/common/btrfs b/common/btrfs
index 0bfb02dd..609f3f0a 100644
--- a/common/btrfs
+++ b/common/btrfs
@@ -1080,3 +1080,17 @@ _require_btrfs_iouring_encoded_read()
 		_notrun "btrfs io_uring encoded read failed with -EOPNOTSUPP"
 	fi
 }
+
+# Check that both btrfs-progs and the kernel support defrag --nocomp.
+_require_btrfs_defrag_nocompress()
+{
+	_require_scratch
+	_require_btrfs_command filesystem defragment --nocomp
+
+	_scratch_mkfs > /dev/null 2>&1
+	_scratch_mount
+	touch $SCRATCH_MNT/foo
+	$BTRFS_UTIL_PROG filesystem defragment --nocomp $SCRATCH_MNT/foo \
+		> /dev/null 2>&1 || _notrun "kernel does not support defrag --nocomp"
+	_scratch_unmount
+}
diff --git a/tests/btrfs/355 b/tests/btrfs/355
new file mode 100755
index 00000000..13934de3
--- /dev/null
+++ b/tests/btrfs/355
@@ -0,0 +1,76 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Meta Platforms, Inc. and affiliates. All Rights Reserved.
+#
+# FS QA Test 355
+#
+# Test that defrag --nocomp only uncompresses the requested range, including
+# a partial final sector, a zero length and a length extending past EOF.
+#
+. ./common/preamble
+_begin_fstest auto quick defrag compress fiemap
+
+. ./common/filter
+. ./common/punch # for _filter_fiemap_flags
+
+_require_btrfs_defrag_nocompress
+_require_btrfs_support_sectorsize 4096
+_require_btrfs_no_nodatacow
+_require_btrfs_no_nodatasum
+_require_btrfs_no_autodefrag
+_require_xfs_io_command "fiemap"
+
+_wants_kernel_commit 009b2056cb25 \
+	"btrfs: defrag: add flag to force no-compression"
+
+_scratch_mkfs -s 4k >> $seqres.full 2>&1 || _fail "mkfs failed"
+_scratch_mount -o compress=zlib
+
+# 4M is chosen as a convenient size, uncompress [1M, 1.5M) later
+$XFS_IO_PROG -f -c "pwrite -S 0xab 0 4M" $SCRATCH_MNT/range | _filter_xfs_io
+
+# A file with a compressed extent covering a partial final sector at
+# [128K, 132K + 1). Uncompress one byte of it, then the rest up to EOF.
+$XFS_IO_PROG -f -c "pwrite -S 0xcd 0 $((132 * 1024 + 1))" $SCRATCH_MNT/partial_sector | \
+	_filter_xfs_io
+
+# Zero length means up to EOF, a length past EOF is clamped to EOF.
+# The name zero_length refers to the later -l 0 argument.
+$XFS_IO_PROG -f -c "pwrite -S 0xef 0 256K" $SCRATCH_MNT/zero_length | _filter_xfs_io
+# An independent file here lets -l 16M be tested without the earlier -l 0 conversion
+# affecting it
+$XFS_IO_PROG -f -c "pwrite -S 0xef 0 256K" $SCRATCH_MNT/past_eof | _filter_xfs_io
+
+# As in btrfs/280, defrag first to avoid writeback timing leaving compressed
+# extents smaller than 128K and changing the last extent's logical start.
+for f in range partial_sector zero_length past_eof; do
+	$BTRFS_UTIL_PROG filesystem defragment -czlib -f $SCRATCH_MNT/$f \
+		>> $seqres.full 2>&1
+done
+
+echo "fiemap before defrag:"
+for f in range partial_sector zero_length past_eof; do
+	echo "$f:"
+	$XFS_IO_PROG -c "fiemap -v" $SCRATCH_MNT/$f | _filter_fiemap_flags 1
+done
+
+$BTRFS_UTIL_PROG filesystem defragment --nocomp -s 1M -l 512K $SCRATCH_MNT/range
+$BTRFS_UTIL_PROG filesystem defragment --nocomp -s 128K -l 1 $SCRATCH_MNT/partial_sector
+echo "partial_sector after uncompressing one byte:"
+$XFS_IO_PROG -c "fiemap -v" $SCRATCH_MNT/partial_sector | _filter_fiemap_flags 1
+$BTRFS_UTIL_PROG filesystem defragment --nocomp -s $((128 * 1024 + 1)) -l 4K \
+	$SCRATCH_MNT/partial_sector
+$BTRFS_UTIL_PROG filesystem defragment --nocomp -s 128K -l 0 $SCRATCH_MNT/zero_length
+$BTRFS_UTIL_PROG filesystem defragment --nocomp -s 128K -l 16M $SCRATCH_MNT/past_eof
+
+# Check the new layout and data are persisted.
+_scratch_cycle_mount compress=zlib
+
+echo "fiemap after defrag:"
+for f in range partial_sector zero_length past_eof; do
+	echo "$f:"
+	$XFS_IO_PROG -c "fiemap -v" $SCRATCH_MNT/$f | _filter_fiemap_flags 1
+done
+md5sum $SCRATCH_MNT/{range,partial_sector,zero_length,past_eof} | _filter_scratch
+
+_exit 0
diff --git a/tests/btrfs/355.out b/tests/btrfs/355.out
new file mode 100644
index 00000000..340105d7
--- /dev/null
+++ b/tests/btrfs/355.out
@@ -0,0 +1,45 @@
+QA output created by 355
+wrote 4194304/4194304 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 135169/135169 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 262144/262144 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 262144/262144 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+fiemap before defrag:
+range:
+0: [0..7935]: encoded
+1: [7936..8191]: encoded|last
+partial_sector:
+0: [0..255]: encoded
+1: [256..271]: encoded|last
+zero_length:
+0: [0..255]: encoded
+1: [256..511]: encoded|last
+past_eof:
+0: [0..255]: encoded
+1: [256..511]: encoded|last
+partial_sector after uncompressing one byte:
+0: [0..255]: encoded
+1: [256..263]: none
+2: [264..271]: encoded|last
+fiemap after defrag:
+range:
+0: [0..2047]: encoded
+1: [2048..3071]: none
+2: [3072..7935]: encoded
+3: [7936..8191]: encoded|last
+partial_sector:
+0: [0..255]: encoded
+1: [256..271]: last
+zero_length:
+0: [0..255]: encoded
+1: [256..511]: last
+past_eof:
+0: [0..255]: encoded
+1: [256..511]: last
+e9295e0e0a926a8922168f1fc481ef90  SCRATCH_MNT/range
+6190a9bc8f51d424927964094f0ce4d1  SCRATCH_MNT/partial_sector
+832cb356cb2524376d8faa4f76cfcfcd  SCRATCH_MNT/zero_length
+832cb356cb2524376d8faa4f76cfcfcd  SCRATCH_MNT/past_eof

-- 
2.43.0


