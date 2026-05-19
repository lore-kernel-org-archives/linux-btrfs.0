Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACAEC3FC5D0;
	Tue, 19 May 2026 17:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779210857; cv=none; b=eYheOuDeH2A1mal4ppNij/xjIgGwGZm4EDjfwJXdFLEidBTUkIDAl0IFxcudRUS71kYhfVFZRVQc1lP2E9mnrvXnXXJFgJvE/HbOEWNHLx/Bw5/XElFe/fzZfzISyh9NauYP7bY9mVCCOT/1RoPT7pSLOXR5k8DhPM4mQYOmkpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779210857; c=relaxed/simple;
	bh=hOR4z3DwoL/gqo9bYmQsjf2l0ZYzJ5P+Z0WBpS1Y1so=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NBNVqivZwp2W6MaFxNjEuSHjwXHAJzIQs4gsi/VYjko1jroCzL8h3JcDO9KhgHpcwnN5kCG9PSWsw4BRYR9JGKdXNDenNvKUWqyQ1VjcxjJLtSzFhTp20e7foUxmOLUE5P/Ci64aGmGO9kRIfP//rF5b1HXIsryQLboabnjZb2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ClxKzHza; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ClxKzHza"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F360C2BCB8;
	Tue, 19 May 2026 17:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779210857;
	bh=hOR4z3DwoL/gqo9bYmQsjf2l0ZYzJ5P+Z0WBpS1Y1so=;
	h=From:To:Cc:Subject:Date:From;
	b=ClxKzHzaC/+OFGytcSSIiysQXDkRlRIVDiKTV9qClyxwwhpkwswL45puvzD1DyjHK
	 wND9dqHBd8U8QL+/STnkmih+X/UpmUeRlTE+qjBH9b6GxB3yckuvnXpRH2+DzihwsD
	 oFKXGsruryB6k6PSNffpxwPPuPqU7zqJF24yJg5AchvgNsXYC3/5AikumeK7RmHcPM
	 06n1kwDlO6r1t2begmF1Fa2JDsVAeKXX3Wi3JLdOKLt/cEVc38SXlrQvn6VWgFkCEQ
	 HEJEo2saHK7SkgX1rMPKKcwvmkKMxH6XsqzUHgqvdoIUItUNNg5LUKoM3XOLPdZZIq
	 xyUbCzEBsflUQ==
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] generic: add a test case for fallocate i_size extension
Date: Tue, 19 May 2026 18:14:10 +0100
Message-ID: <a92aea73a82100f1dfde58e6f64191bed1d7f41d.1779210827.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

Test an i_size expanding fallocate into a range beyond current i_size that
already has a preallocated extent, with an unmount and mount after each
fallocate to verify that no metadata (i_size) and extents were lost.

This used to fail on btrfs when not using the no-holes feature (which is
a default since btrfs-progs 5.15) before this recent kernel fix:

  c562ba61fc5e ("btrfs: fix incorrect i_size after remount caused by KEEP_SIZE prealloc gap")

So in order to reproduce the failure when using an unpatched kernel and
a btrfs-progs >= 5.15, one must run the test with:

  MKFS_OPTIONS="-O ^no-holes"

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/generic/795     | 52 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/795.out |  5 +++++
 2 files changed, 57 insertions(+)
 create mode 100755 tests/generic/795
 create mode 100644 tests/generic/795.out

diff --git a/tests/generic/795 b/tests/generic/795
new file mode 100755
index 00000000..299c8134
--- /dev/null
+++ b/tests/generic/795
@@ -0,0 +1,52 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
+#
+# FS QA Test 795
+#
+# Test an i_size expanding fallocate into a range beyond current i_size that
+# already has a preallocated extent, with an unmount and mount after each
+# fallocate to verify that no metadata (i_size) and extents were lost.
+#
+. ./common/preamble
+_begin_fstest auto quick prealloc fiemap
+
+. ./common/punch # for _filter_fiemap
+
+_require_scratch
+_require_xfs_io_command "falloc" "-k"
+_require_xfs_io_command "fiemap"
+
+_fixed_by_fs_commit btrfs c562ba61fc5e \
+	"btrfs: fix incorrect i_size after remount caused by KEEP_SIZE prealloc gap"
+
+_scratch_mkfs >>$seqres.full 2>&1
+_scratch_mount
+
+# The fiemap results in the golden output requires file allocations to align to
+# 1M boundaries.
+_require_congruent_file_oplen $SCRATCH_MNT 1048576
+
+# Create our file with a size of 0 and a prealloc extent in the range [4M, 8M].
+$XFS_IO_PROG -f -c "falloc -k 4M 4M" $SCRATCH_MNT/foo
+
+# Unmount and mount again to remove any in memory state of the inode. We will
+# verify later that neither metadata nor extents were lost during unmount.
+_scratch_cycle_mount
+
+# Do an i_size expanding fallocate that overlaps the previous prealloc range
+# and extents past it. This increases the file size to 9M and allocates an
+# extent in the range [8M, 9M].
+$XFS_IO_PROG -c "falloc 7M 2M" $SCRATCH_MNT/foo
+
+# Unmount and mount again to remove any in memory state of the inode. We will
+# verify later that neither metadata nor extents were lost during unmount.
+_scratch_cycle_mount
+
+# File size should be 9M and we should have unwritten extents in range [4M, 9M].
+echo "File size after cycle mounts: $(stat -c %s $SCRATCH_MNT/foo)"
+echo "Fiemap output:"
+$XFS_IO_PROG -c "fiemap -v" $SCRATCH_MNT/foo | _filter_fiemap
+
+# Success, all done.
+_exit 0
diff --git a/tests/generic/795.out b/tests/generic/795.out
new file mode 100644
index 00000000..b2f78ac0
--- /dev/null
+++ b/tests/generic/795.out
@@ -0,0 +1,5 @@
+QA output created by 795
+File size after cycle mounts: 9437184
+Fiemap output:
+0: [0..8191]: hole
+1: [8192..18431]: unwritten
-- 
2.47.2

