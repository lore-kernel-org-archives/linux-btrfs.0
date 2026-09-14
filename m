Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51729492E22;
	Mon, 14 Sep 2026 17:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789408470; cv=none; b=jRzBzA3NBs22nT8Z56tQcocFdjAWn8XFvy4k8uTeDhEKfwK4VFQs/Eo2T0RkYEbGnGmjlnse7ysXECL4ytPV+8ADOkD8YKUMYsiHxU7zWqng5h8JJQIf3ydd5v7gvG4MSQKUyiqtfiY8eA4qCOVIRkEeZyBWo+ahhPvAbCu4a2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789408470; c=relaxed/simple;
	bh=Nm2jJoFGlCKQ8KKlGlsLkQcvnsGCuR8va8ZeDxuGYDg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=re0rbsGIcRTob6TcXLE71d75NzTIfsgJPUzWQAiZQLnv04wS+6ZSTgJhnpIIXi0k32apJgUI1qKOPWlrprHAnWDjfGt+YcP89OccTB5eM4h2peoMxd3+BK5tqYH1ZCWxU5Pp2mAl8Rt9RaEjrr7My0VhOE+oXl7OnEXKWEsvIHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bPzbJson; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bPzbJson"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6542F1F000FF;
	Mon, 14 Sep 2026 17:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789408469;
	bh=Eaqodn33pVokqSBMDiUGVZFjtTTNBwDfP3Qi0gtwQGs=;
	h=From:To:Cc:Subject:Date;
	b=bPzbJsonG4piL3Y4Tit5bKJfEt8N9gevKYN5BezAdcm7BHIVDGufhSrZJvHPCQyt8
	 jt8uz+K+QoSQDOAvSgJP8iCyHbQrZJQKTKhVb6ECDc1XXjua5LpOgfRh1Arjwgfb9Y
	 LGZUs3Qus80XXxWDQwSE0CPQShZZZJJnyrtABGALSQq71dC7dKdiooA4tuIy2lTPzt
	 +tj/oeMI7L3ZkERSYOKBpKSozW7onA0wy8aZbhddMrN1lSQ1YiskwtEBUxPwyaBORC
	 nqXUnlIAFUyaN+00i84xkNd59slHmPXZIN4+miSMWJTHfXV3iVGKTWU9n6Wrh95td0
	 e9rRrxfofjXTw==
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] btrfs: test that we don't create pointless compressed inline extents
Date: Mon, 14 Sep 2026 18:54:23 +0100
Message-ID: <83e3a8678c5eafb1cfcf10741a53b6e586cd72d8.1789408399.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

Verify that we don't create compressed inline extents when the compressed
data size is not smaller than the uncompressed data size.

This exercises a regression introduced in kernel 7.1 and that is fixed by
the following patch:

  "btrfs: fix creation of compressed inline extents that don't save space"

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/btrfs/354     | 44 ++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/354.out |  2 ++
 2 files changed, 46 insertions(+)
 create mode 100755 tests/btrfs/354
 create mode 100644 tests/btrfs/354.out

diff --git a/tests/btrfs/354 b/tests/btrfs/354
new file mode 100755
index 00000000..801dc587
--- /dev/null
+++ b/tests/btrfs/354
@@ -0,0 +1,44 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
+#
+# FS QA Test 354
+#
+# Verify that we don't create compressed inline extents when the compressed
+# data size is not smaller than the uncompressed data size.
+#
+. ./common/preamble
+_begin_fstest auto quick compress
+
+. ./common/filter
+
+_fixed_by_kernel_commit xxxxxxxxxxxx \
+	"btrfs: fix creation of compressed inline extents that don't save space"
+
+_require_scratch
+_require_btrfs_command inspect-internal dump-tree
+
+algo_list=($(_btrfs_compression_algos))
+for algo in ${algo_list[@]}; do
+	_scratch_mkfs >>$seqres.full 2>&1 || _fail "mkfs failed"
+	_scratch_mount "-o compress=$algo"
+
+	echo 'a file with test content' > $SCRATCH_MNT/foobar
+	_scratch_unmount
+	_check_scratch_fs
+
+	extent_size=$($BTRFS_UTIL_PROG inspect-internal dump-tree -t 5 $SCRATCH_DEV | \
+	      grep 'inline extent' | \
+	      $AWK_PROG '{ for (i = 1; i < NF; i++) if ($i ~ /^size$/) print $(i + 1) }')
+	ram_size=$($BTRFS_UTIL_PROG inspect-internal dump-tree -t 5 $SCRATCH_DEV | \
+		   grep 'inline extent' | \
+		   $AWK_PROG '{ for (i = 1; i < NF; i++) if ($i ~ /^ram_bytes$/) print $(i + 1) }')
+
+	if [ "$extent_size" -gt "$ram_size" ]; then
+		echo "inline extent size ($extent_size) greater than ram_size ($ram_size) for algo $algo"
+	fi
+done
+
+# success, all done
+echo "Silence is golden"
+_exit 0
diff --git a/tests/btrfs/354.out b/tests/btrfs/354.out
new file mode 100644
index 00000000..8bc7ecf6
--- /dev/null
+++ b/tests/btrfs/354.out
@@ -0,0 +1,2 @@
+QA output created by 354
+Silence is golden
-- 
2.47.2

