Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792948956;
	b=rPwdvA8lcZKcSJbXbRFrcnMSGf8fpjXK8jXKUY1R+rI2y9RdRZ1DEvrkeATsOI06A5jb
	 f8uckilN3k3WBRBo1pT2SPje0PCPykHhCj+gZjZlwQqtFpdN+XmoeNSxfUtJli67Zi8CV
	 nksKWJUqzpBDw5ZQO+YWASkheQcBzbrSSBAyC9DAQNLc96pVZ32PSkt2DjMNJLFA/rTVo
	 dMGTqMedzNAx3+Ce5haM9jri2/tb0hkRWUQb9adom5nJDnCE2qnqCzUets3loa2pw5ajn
	 w6W7AloIBQ9xJPndmwDnZW/tLKUVMw4VaC75xa6JANxKjsucnOmJQ7Mksbmzg0mUwcA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792948956;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=9s3/DcJlrpkCAoApVeyckZg4DZMh9L5p5qco2ZrUrbI=;
	b=bD3iALctp5CudkkfSHrT8kvrQ6nvinLrPJWC6zhaRarERfaRr1BLymeBykpCTtxakrqO
	 uFALZFJc7Uwx8lFe/44s1rMut7bDBSxYaPrwb+TIJPh0wBcVLsLCnzd+xOICLG1VFNhg6
	 SB2bvb3mKhTlz+57z+IY8Uh1JlxY4sy1jFf8fOovTijJUPtrGpkCqcgGyYRe4T22+iDrw
	 f5tjsuN/XO4k/dMJbCRryuwXl4MQzuWhS7iQhSGnHc1rXQR/WiXNV2TRq9sEsFe1p50Ot
	 6qnxrMZk1qve2ordLj5EXUmNyiCVP01WfylEva4EJGG879ZUqAHCXK/MlWYLdtjIHrg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZzcMPDcH;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53008606A320;
	Sun, 25 Oct 2026 17:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZzcMPDcH
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792948956;
	b=zODgorz23rYgjSHtu3sSCuZKtA/sq6DEnT7pccTC6IJbE1MpgvZYFed/ZlRov/b733Ah
	 Wud6RSqhKVyOykINyS01JW8v+uq1RggzkQ+3pzLFFAOFqAsMK+Mzxojq8qrWtX97N2Vtg
	 6bT+4M4AOfDPNpAgAOQ8+SlkBeojiWgN4FtGU4hYHRsG82kwCLvC6OUt6TZbCs/jB3F6O
	 vcFDCPEyzqI+t+wu/hg/JxMXtWnmCOcEJivORxMocjPURm+E2M8mcek7O1WrdfW2UChoP
	 RIEeEmdg8yVYxpjU/94eUZs/KVnAWlbhKGrYPIn7lxR1DAbRjEeni5Uo3POvtLG5IoQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792948956;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=9s3/DcJlrpkCAoApVeyckZg4DZMh9L5p5qco2ZrUrbI=;
	b=UDk9He9E2DX/Vz1wP3okD3ppHph1XdPEZw9cVp4fT5jujHtXKLmyoASxTdoZQjQ6mh1v
	 FlT5RNscBFQYhYIbjDiUxs/KDnjaCfG64ySzDtDApaAwN7VXnMs0iZgiC8PBjKpajX/X8
	 nIKLjPKSr125FLtYUiMeu/jCDoWLTPRFFYisXxmGjoiegilw4M5BF/+vVlbFi9ij1bLdD
	 t6Iv2T8PFSZw5UqMaCzQrNu34ObZhAwF+vA9TEEHC7qSM3LGWFhRvU0TOorsh+3QJyl3u
	 gRoqwam68nN4HlDC3pUzYW8Dkmf7CkI4jPEzgnRRDo4K+MvYcLSyS0d4mW/8BqGFNIw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id D17EB1F01825;
	Sun, 25 Oct 2026 17:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792948956;
	bh=9s3/DcJlrpkCAoApVeyckZg4DZMh9L5p5qco2ZrUrbI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=ZzcMPDcH/eLBb5N65uQUs4RJPUuHMBStaBLJ3gIqVMRB5CW1m5+4sSrOf/FcG4nhT
	 BoJFpW90YD/PFKwdJvLlKK2eCZ0716C3Cdd+g1zP0jOU7gyHa+mdrkqNvaj2JgxueN
	 BxK0xv25LPN4P0u6n+wlDcXctOeVmLss1aq47gto3pGFteD2gum+/Lz8vX3ZD6wu+Q
	 Wd9BRw3uuSE4uhFw2JE0zMawLXfbdUxHGR1WJ54S+HLQd2pZ32CaMFWIjX9ePjyzh1
	 uf2lCRZs0bOgylLqbhIpEB0QcauI8qKm1QwHllVLM4r33MFC5++rFWOlzD4wdiXvdn
	 1N0ezkpurwerQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 4672744A84;
	Sun, 25 Oct 2026 17:22:34 +0000 (UTC)
From: Dhruva Gole via B4 Relay <devnull+goledhruva.gmail.com@kernel.org>
Date: Sun, 25 Oct 2026 17:21:51 +0000
Subject: [PATCH v2 2/3] btrfs: check NOCOMPRESS preserves holes and
 preallocation
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
Message-Id: <20261025-b4-btrfs-nocomp-v2-v2-2-628c1986f9b9@gmail.com>
References: <20261025-b4-btrfs-nocomp-v2-v2-0-628c1986f9b9@gmail.com>
In-Reply-To: <20261025-b4-btrfs-nocomp-v2-v2-0-628c1986f9b9@gmail.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Anand Jain <asj@kernel.org>, 
 Filipe Manana <fdmanana@suse.com>, Zorro Lang <zlang@kernel.org>, 
 Qu Wenruo <wqu@suse.com>, Dhruva Gole <goledhruva@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792948953; l=4278;
 i=goledhruva@gmail.com; s=remote-20261025; h=from:subject:message-id;
 bh=6fh0L2Df1MA5vL1mDztYUnELsLKDU3e6oyTbelQ73h4=;
 b=ShAubn445l75XjgcJ1k8Rh3ZDdnPu2vfo0f8VzKryzadZIr5ejww+4b15ugONMU/FyfZ1oNDt
 FgeTBgq9qu4CTWQ634FgO7o58KWBDYtRv5wlztXcZ4fMZqcbKZrvB7D
X-Developer-Key: i=goledhruva@gmail.com; a=ed25519;
 pk=OBz78Vw5K+/+HyXjxg9mNOV2Bq087eJgHL749H+Xe/k=
X-Endpoint-Received: by B4 Relay for goledhruva@gmail.com/remote-20261025
 with auth_id=1318
X-Original-From: Dhruva Gole <goledhruva@gmail.com>
Reply-To: goledhruva@gmail.com
Content-Transfer-Encoding: 7bit

From: Dhruva Gole <goledhruva@gmail.com>

Create a file with compressed extents separated by holes, a preallocated
extent inside EOF and a preallocated extent beyond EOF. Test that defrag
--nocomp uncompresses the data extents while the holes and preallocated
extents are left untouched, checking the layout with fiemap and the file
contents with md5sum after a remount.

Signed-off-by: Dhruva Gole <goledhruva@gmail.com>
---
 tests/btrfs/356     | 64 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/356.out | 28 +++++++++++++++++++++++
 2 files changed, 92 insertions(+)

diff --git a/tests/btrfs/356 b/tests/btrfs/356
new file mode 100755
index 00000000..b1d89f43
--- /dev/null
+++ b/tests/btrfs/356
@@ -0,0 +1,64 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Meta Platforms, Inc. and affiliates. All Rights Reserved.
+#
+# FS QA Test 356
+#
+# Test that defrag --nocomp uncompresses data extents but leaves holes and
+# preallocated extents, including one beyond EOF, untouched.
+#
+. ./common/preamble
+_begin_fstest auto quick defrag compress prealloc fiemap
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
+_require_xfs_io_command "falloc" "-k"
+
+_wants_kernel_commit 009b2056cb25 \
+	"btrfs: defrag: add flag to force no-compression"
+
+_scratch_mkfs -s 4k >> $seqres.full 2>&1 || _fail "mkfs failed"
+_scratch_mount -o compress=zlib
+
+# Compressed extents at 0, 512K and 1M, holes in between, a preallocated
+# extent at 256K and a preallocated extent beyond EOF at 1280K. Fsync before
+# fallocating, otherwise the data would be written as NOCOW, uncompressed.
+$XFS_IO_PROG -f -c "pwrite -S 0xab 0 128K" \
+	     -c "pwrite -S 0xcd 512K 128K" \
+	     -c "pwrite -S 0xef 1M 128K" \
+	     -c "fsync" \
+	     -c "falloc 256K 128K" \
+	     -c "falloc -k 1280K 128K" \
+	     $SCRATCH_MNT/compressed_sparse_file | _filter_xfs_io
+
+echo "fiemap before defrag:"
+$XFS_IO_PROG -c "fiemap -v" $SCRATCH_MNT/compressed_sparse_file | _filter_fiemap_flags 1
+
+# Check the physical start of each preallocated extent as in btrfs/257.
+prealloc=$(_get_file_extent_sector "$SCRATCH_MNT/compressed_sparse_file" 262144)
+prealloc_eof=$(_get_file_extent_sector "$SCRATCH_MNT/compressed_sparse_file" 1310720)
+
+$BTRFS_UTIL_PROG filesystem defragment --nocomp $SCRATCH_MNT/compressed_sparse_file
+
+# Check that the extent layout and data persist across a remount.
+_scratch_cycle_mount compress=zlib
+
+if [ "$prealloc" != "$(_get_file_extent_sector "$SCRATCH_MNT/compressed_sparse_file" 262144)" ]; then
+	echo "preallocation inside EOF moved"
+fi
+if [ "$prealloc_eof" != "$(_get_file_extent_sector "$SCRATCH_MNT/compressed_sparse_file" 1310720)" ]; then
+	echo "preallocation beyond EOF moved"
+fi
+
+echo "fiemap after defrag:"
+$XFS_IO_PROG -c "fiemap -v" $SCRATCH_MNT/compressed_sparse_file | _filter_fiemap_flags 1
+md5sum $SCRATCH_MNT/compressed_sparse_file | _filter_scratch
+
+_exit 0
diff --git a/tests/btrfs/356.out b/tests/btrfs/356.out
new file mode 100644
index 00000000..777fdf1e
--- /dev/null
+++ b/tests/btrfs/356.out
@@ -0,0 +1,28 @@
+QA output created by 356
+wrote 131072/131072 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 131072/131072 bytes at offset 524288
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 131072/131072 bytes at offset 1048576
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+fiemap before defrag:
+0: [0..255]: encoded
+1: [256..511]: hole
+2: [512..767]: unwritten
+3: [768..1023]: hole
+4: [1024..1279]: encoded
+5: [1280..2047]: hole
+6: [2048..2303]: encoded
+7: [2304..2559]: hole
+8: [2560..2815]: unwritten
+fiemap after defrag:
+0: [0..255]: none
+1: [256..511]: hole
+2: [512..767]: unwritten
+3: [768..1023]: hole
+4: [1024..1279]: none
+5: [1280..2047]: hole
+6: [2048..2303]: none
+7: [2304..2559]: hole
+8: [2560..2815]: unwritten
+dc61af0129fdc173b1bc986ca00096bc  SCRATCH_MNT/compressed_sparse_file

-- 
2.43.0


