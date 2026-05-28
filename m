Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 833453B7772;
	Thu, 28 May 2026 10:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779964036; cv=none; b=Udu6gBeKS+EkRv4M+coHOiDWLElZXWVxACFudZOiT/bo/9aCWBlL9VGZSG5fjSkSp+F2wEYr8j5pEgD5VHTmJopMM3+VlPto9t6koDu+ae/2u8km3lV3aPiTCEHxbZXcjQLTHoS122tZX13CcpyHSnAIVv1kIxdGuhoCpvmPgDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779964036; c=relaxed/simple;
	bh=pzINRwkdx6ghnIbbL73oPbKjXEJdMe9H3WidayQTpAM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MhYV63myfy3szZSZrAzgSlNCCg5X+JTq8P3GLbtNhxWAfVjETBCr98YKntUAGPV6iSjkhMx8OTZldBa0g1YNHqceRDPMgbvwwimVSWyCRRuPOiADacX0Mzet0bbUDUUzZdUoWO0gztHmRHAgg7G7Q6UGlU9J/L2IrBCo5Kk+FWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BVagzOZ9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BVagzOZ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A3B21F000E9;
	Thu, 28 May 2026 10:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779964033;
	bh=GtCiLsY1XYenbQIfjgod0edgFXom11kgQWbwRUDtOzM=;
	h=From:To:Cc:Subject:Date;
	b=BVagzOZ9EomM4Vb/QzRss+UqpA4tQcvGq+cIh8zJ7vgg84K2fX2phZ4twCErnxLTl
	 69zG9dKHzNfTKEckAr95mao2HxUrd6eddZTnQx5u1d+HwG5klThHZ1oxWhzE5LA4m4
	 e6uW8m95ad/7BsmlXq0dgtaMlBK5sX4d4RwUvrFqSurC/rYjYJtM8SYL9wrFzEZI6z
	 EYaKjnj6czefjbHO8WuHmVowlQtZRQJYg93mgWjl/xGtV9AqooxcR22gRy39uFtthJ
	 949dUcXgm5ZyZPDL64IfRRkVqwxeKAJtlSQ4y1SfUsegx6tjZ0ChLcnnysRhKPHePQ
	 4HrwUdh6CAfag==
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] generic: add a test case for writes with prealloc extents beyond i_size
Date: Thu, 28 May 2026 11:27:07 +0100
Message-ID: <4b84813ed94332ccf8bb46848ed91f699d75794a.1779964012.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

Test writing into a file range containing prealloc extents beyond the current
i_size, with an unmount and mount after fallocate and the write, to verify
that the file data, size and extent layout were not lost.

This used to fail on btrfs when not using the no-holes feature (which is
a default since btrfs-progs 5.15) before this recent kernel fix:

   080ecbd05432 ("btrfs: mark file extent range dirty after converting prealloc extents")

So in order to reproduce the failure when using an unpatched kernel and
a btrfs-progs >= 5.15, one must run the test with:

   MKFS_OPTIONS="-O ^no-holes"

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/generic/796     | 54 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/796.out | 10 ++++++++
 2 files changed, 64 insertions(+)
 create mode 100755 tests/generic/796
 create mode 100644 tests/generic/796.out

diff --git a/tests/generic/796 b/tests/generic/796
new file mode 100755
index 00000000..c42a4722
--- /dev/null
+++ b/tests/generic/796
@@ -0,0 +1,54 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
+#
+# FS QA Test 796
+#
+# Test writing into a file range containing prealloc extents beyond the current
+# i_size, with an unmount and mount after fallocate and the write, to verify
+# that the file data, size and extent layout were not lost.
+#
+. ./common/preamble
+_begin_fstest auto quick prealloc preallocrw fiemap
+
+. ./common/filter
+. ./common/punch # for _filter_fiemap
+
+_require_scratch
+_require_xfs_io_command "falloc" "-k"
+_require_xfs_io_command "fiemap"
+
+_fixed_by_fs_commit btrfs 080ecbd05432 \
+	"btrfs: mark file extent range dirty after converting prealloc extents"
+
+_scratch_mkfs >>$seqres.full 2>&1
+_scratch_mount
+
+# The fiemap results in the golden output requires file allocations to align to
+# 1M boundaries.
+_require_congruent_file_oplen $SCRATCH_MNT 1048576
+
+# Create our file with a size of 0 and a prealloc extent in the range [0, 2M].
+$XFS_IO_PROG -f -c "falloc -k 0 2M" $SCRATCH_MNT/foo
+
+# Unmount and mount again to remove any in memory state of the inode. We will
+# verify later that neither metadata nor extents were lost during unmount.
+_scratch_cycle_mount
+
+# Write into the [0, 1M] range, which increases the inode's i_size.
+$XFS_IO_PROG -c "pwrite -S 0xab -b 1M 0 1M" $SCRATCH_MNT/foo | _filter_xfs_io
+
+# Unmount and mount again to remove any in memory state of the inode. We will
+# verify later that neither metadata nor extents were lost during unmount.
+_scratch_cycle_mount
+
+# Check file data (and size).
+echo "File data:"
+_hexdump $SCRATCH_MNT/foo
+
+# Check we have unwritten extents in range [1M, 2M].
+echo "Fiemap output:"
+$XFS_IO_PROG -c "fiemap -v" $SCRATCH_MNT/foo | _filter_fiemap
+
+# Success, all done.
+_exit 0
diff --git a/tests/generic/796.out b/tests/generic/796.out
new file mode 100644
index 00000000..c6c6e6a8
--- /dev/null
+++ b/tests/generic/796.out
@@ -0,0 +1,10 @@
+QA output created by 796
+wrote 1048576/1048576 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+File data:
+000000 ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab  >................<
+*
+100000
+Fiemap output:
+0: [0..2047]: data
+1: [2048..4095]: unwritten
-- 
2.47.2

