Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 087162E5B29;
	Thu, 15 Oct 2026 15:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792077703; cv=none; b=adDLLoah/AjM1zSfBUQw3nbw267SeVd8gCtTal4MH2FqdRdEk4TEqCFDeXtdc5Ib7e721cU/wnqsXAQ9ZtqwvmG2Ia7uM2G0rvZJ/l0bFcztFawJNcrDpprRMKZ9EzNOo5v2qyUIcw3An3npyJ8VaEEa289XVUYkiWRmqb1289g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792077703; c=relaxed/simple;
	bh=TPitwEY1rf6HN6oVwzQFDDHVWVi1gLGkI1DpxxCstpA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NiJnAE/ovsbvNWaXXv2OVAVxsj+1/zpAuz0PrTFhevqzwKE6NLIYUtnc2/iUHYdvHZiqUHMOjKNQKdF+3UNTfOF0csq7c8Mn6Z3N2+DgImG5mdgv4Z93c7QvIUn8a/hOOj/JTwBOI72hQlXj8ZIRqQoCM7WZTQHQxmO5PFkh8bA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UjOeyfjD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UjOeyfjD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB3931F000C4;
	Thu, 15 Oct 2026 15:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792077699;
	bh=8HAIOpnNfb7cq4KnpcsEJyJjPX8m9uiGmxjkY5X2BNA=;
	h=From:To:Cc:Subject:Date;
	b=UjOeyfjDgw0RWayFzzQuScrtnH05XlolQ6KJm3Un1QX6BqTcdShlqUo25sc2yBImX
	 LrIBO9uZeNkH2pMyge+LLtTdjYVl06nS1Rd7iM/sLYFiv+5RAdthyAIDIa26N2kibx
	 wIyHqkY+X48FQUmv0CMeCaIDC5kvx4f2YLhtofB7gZIWbO4dQO01+6WwUNIpgwhQ+C
	 EWDhNY4gpZ3IbEzURifC0J4ozgORhJhlzXTEDkZHnTJqnrLgBv2wxZswkoVQ0b4soK
	 YI2SkicQyWiNboQCHBMjsgtl6Zo3eifXO48CS2UJxuVgXKHm2e1GczXv0hHc+TtSgI
	 VIQpiz44Mxjig==
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] btrfs: test fiemap does not merge compressed extents
Date: Thu, 15 Oct 2026 16:21:34 +0100
Message-ID: <5b73c7dc792763acc71d3f4286bccc473114fca3.1792077449.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

Test that fiemap does not report logically adjacent compressed extents
as a single extent.

This is a reproducer for a bug that is fixed by the following kernel
patch:

  "btrfs: fix fiemap merging compressed extents"

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/btrfs/361     | 50 +++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/361.out |  8 ++++++++
 2 files changed, 58 insertions(+)
 create mode 100755 tests/btrfs/361
 create mode 100644 tests/btrfs/361.out

diff --git a/tests/btrfs/361 b/tests/btrfs/361
new file mode 100755
index 00000000..96eff971
--- /dev/null
+++ b/tests/btrfs/361
@@ -0,0 +1,50 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
+#
+# FS QA Test 361
+#
+# Test that fiemap does not report logically adjacent compressed extents as a
+# single extent.
+#
+. ./common/preamble
+_begin_fstest auto quick compress fiemap
+
+. ./common/filter
+. ./common/punch # for _filter_fiemap_flags
+
+_fixed_by_kernel_commit xxxxxxxxxxxx \
+	"btrfs: fix fiemap merging compressed extents"
+
+_require_btrfs_support_sectorsize 4096
+_require_xfs_io_command "falloc"
+_require_xfs_io_command "fiemap"
+_require_scratch
+
+_scratch_mkfs -s 4K >> $seqres.full 2>&1 || _fail "mkfs failed"
+_scratch_mount "-o compress"
+
+# Do a write that compresses to a single 4K extent and represents the maximum
+# compressed chunk size (128K).
+$XFS_IO_PROG -f -c "pwrite 0 128K" $SCRATCH_MNT/foo | _filter_xfs_io
+
+# Sync to flush delalloc and allocate the 4K extent.
+$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/foo
+
+# Now allocate a 124K extent in some other file, which will be adjacent (to the
+# right) of the 4K extent previously allocated.
+$XFS_IO_PROG -f -c "falloc 0 124K" $SCRATCH_MNT/filler
+
+# Do another write to the main file at its current EOF that is compressible and
+# fits in a 4K extent.
+$XFS_IO_PROG -c "pwrite 128K 128K" $SCRATCH_MNT/foo | _filter_xfs_io
+
+# Sync to flush delalloc and allocate the 4K extent.
+$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/foo
+
+# Run fiemap which should report 2 encoded extents, each with a logical size
+# of 128K.
+echo "Fiemap output:"
+$XFS_IO_PROG -c "fiemap -v" $SCRATCH_MNT/foo | _filter_fiemap_flags 1
+
+_exit 0
diff --git a/tests/btrfs/361.out b/tests/btrfs/361.out
new file mode 100644
index 00000000..b09afa3d
--- /dev/null
+++ b/tests/btrfs/361.out
@@ -0,0 +1,8 @@
+QA output created by 361
+wrote 131072/131072 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 131072/131072 bytes at offset 131072
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+Fiemap output:
+0: [0..255]: encoded
+1: [256..511]: encoded|last
-- 
2.53.0

