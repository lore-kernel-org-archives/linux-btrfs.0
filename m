Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 250143DB313;
	Tue, 15 Sep 2026 15:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789484726; cv=none; b=jvDztMR9MhgsKjX9KTtxXVTUqZEaM5H79s1cQT/CYzuoWO/4IDqfKojlnX2/18vOTJx5QBR8Sl+sBP6LTyxx3y9Q2Ea+526ar27uc/ofFWBWiL+HSk9pMHTkm7OgFA1jLfd6cm98Zj7iM11nmagM1bZqYl+4ORNCVuOavDUHkXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789484726; c=relaxed/simple;
	bh=q50IGXCjTtJf8Qjpusf3q1/umwpCSG9nqs2BSN739ZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UXH3zdKXhS7CtONMpWgXUgHg4Gqa54kO3DoZBgVc+CYL/KDF8twt94X7PTmhAB0oIrJ7rEcJEka5/bPb/jXvezbbZlZ3mIx5KEcTM5cyDtb1F+vWDSgs/rSoFqQB085KPCDiAxC9/59u2E8yaFKnWJUobTi0uCGBRBK34kaoSNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OG7rVD2r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OG7rVD2r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B4841F000FF;
	Tue, 15 Sep 2026 15:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789484723;
	bh=+PBw3LT9UVPPm+kmCNnQM2GVYOt6rl/gx4CAKbDqN1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OG7rVD2rWO8F2NTnFzzNMIqeF47qQCbQYef5nm/uNfXc2lXpCtLVe7zOR+SpKQW59
	 xyKixKM5FYeVb0SExqiNAkapfR4XkCwBDhdlO5QIsZEfdUoRSjaRuhFeeZkVF28ANX
	 RTQEeq2WaPmVETa+C4TyT1uURoiw8bkG1XtlEfO1t/ea50Jmpy/Bz5JyARWFCdDDtC
	 HQZbnSyjfzqPuURCNV2y7GZUm2TqpnYYchDKeGMrSMZ/pZRmSMLBanZr+lrFu0JyMC
	 3MtaUpUz3pGBHRu2femef2fuqbrnCdhIllAHwo+/kdi6dXJUTHd3Myg0ky+B1Tvhu9
	 9fZcb9FowcjBA==
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	Filipe Manana <fdmanana@suse.com>,
	David Disseldorp <ddiss@suse.de>
Subject: [PATCH v2] btrfs: test that we don't create pointless compressed inline extents
Date: Tue, 15 Sep 2026 16:05:16 +0100
Message-ID: <5acebd19e4e5b9b825497947ef32527cc2103147.1789484528.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <83e3a8678c5eafb1cfcf10741a53b6e586cd72d8.1789408399.git.fdmanana@suse.com>
References: <83e3a8678c5eafb1cfcf10741a53b6e586cd72d8.1789408399.git.fdmanana@suse.com>
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

Reviewed-by: David Disseldorp <ddiss@suse.de>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: Use a single call to btrfs inspect-internal and a single awk
    call (David Disseldorp).

 tests/btrfs/354     | 46 +++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/354.out |  2 ++
 2 files changed, 48 insertions(+)
 create mode 100755 tests/btrfs/354
 create mode 100644 tests/btrfs/354.out

diff --git a/tests/btrfs/354 b/tests/btrfs/354
new file mode 100755
index 00000000..1b25ab5d
--- /dev/null
+++ b/tests/btrfs/354
@@ -0,0 +1,46 @@
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
+	$BTRFS_UTIL_PROG inspect-internal dump-tree -t 5 $SCRATCH_DEV | \
+		tee -a $seqres.full | \
+		$AWK_PROG -v algo="$algo" '
+		  /inline extent/ {
+			for (i = 1; i < NF; i++) {
+			      if ($i ~ /^size$/)
+				 extent_size = $(i + 1)
+			      if ($i ~ /^ram_bytes$/)
+			         ram_size = $(i + 1)
+			}
+			if (extent_size > ram_size)
+			   printf "inline extent size (%d) greater than ram_size (%d) for algo %s\n", extent_size, ram_size, algo
+		  }'
+done
+
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

