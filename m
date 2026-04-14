Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F6D23BD1D;
	Tue, 14 Apr 2026 13:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.143.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776174340; cv=none; b=t/+UdaX7UbDI0uZ2/grONeR3a0C5e4gT18kPkKx+EvmIUA8ECP/ZpVMnhQ1vwte4AGvSsR8Y2vykGWpkfY9+UPSJzmf4JRLmLhVHCLdZypbrRFVTyOOgGy982+4F8M7U+inwllI531HuOHikzCds/osBUyTQvSTDmR7tubvqcDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776174340; c=relaxed/simple;
	bh=RHqHUgMH9ohRH6jyJuuXMgIieHslvkyIy2AOU6SPmbM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bzp2DlsrffwYzAbmnKNAJc2dDhxkJo6Wwjyasy4hv+0977EWtdmLispmZjZDl9IPD9Dbz4vwezH8iyc4TGYlpd8aEXjUn5uHqAZByWz+fUyPuOCrovwrPbwbcKpQoxCXHuMQjC9Wdzbc59CJS+TIi8Oc5evDkvNx9m7IbUeRNL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=KZ3SHgBl; arc=none smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="KZ3SHgBl"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1776174338; x=1807710338;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=RHqHUgMH9ohRH6jyJuuXMgIieHslvkyIy2AOU6SPmbM=;
  b=KZ3SHgBlKFRC5BNhEcU3ecVx0p1AFkxh/tSAkxxgBlKEoofI4TqS0P62
   VsQp+kznY0sdUZm83ZwXrAO8IIrdegb4IC3MQlSLUyW0+Uheg7uWyutTQ
   qASPb615XgymsEBWVynvhj3Fa9KSJtl+jaNHIoSM16xP1DKdaYTLOccA2
   Kox9Jrc09Bik0vV4FyS+3jv0VHnZgrbzqDdlfvjdUwd5udir5MZ34YOx6
   25vQyCDz9JFWLt9vc+4qkBhsIkqUldrRk7YQDIBF35daxe4JaQLgYU4FS
   G4Ja1RGM+U/YL1mJTClZbNWwz26/kphqAxwHOCnvrBnFNmQP/aT2qo8pG
   Q==;
X-CSE-ConnectionGUID: 03N1WvwJRgGyDwQ+CWiHHg==
X-CSE-MsgGUID: 1ZMaOfNTQFGdiMP/5JVdgQ==
X-IronPort-AV: E=Sophos;i="6.23,179,1770566400"; 
   d="scan'208";a="145632048"
Received: from unknown (HELO uls-op-cesaep03.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 14 Apr 2026 21:45:32 +0800
X-CSE-ConnectionGUID: EDkN4Oa2RCyxuS+ncKjFgw==
X-CSE-MsgGUID: jwpJl22bQA2ZGblk90RTXw==
IronPort-SDR: 69de44e4_ogs9Woov854trikUJd4x8zPrGgooRvwEdAMCOvJZ5kde6qR
 iq6mtQi4N7DQwmypJTL9DSaR6VV3nZ2L7DX1CSw==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep03.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Apr 2026 06:45:09 -0700
X-CSE-ConnectionGUID: UVu0u6RyTxeAp0m9uULt1Q==
X-CSE-MsgGUID: AeoVl0s6TMedCroqpk3s5w==
WDCIronportException: Internal
Received: from wdap-uxbjeij2ea.ad.shared (HELO neo.fritz.box) ([10.224.19.23])
  by uls-op-cesaip01.wdc.com with ESMTP; 14 Apr 2026 06:45:07 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Zorro Lang <zlang@redhat.com>
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	fstests@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2] fstests: test premature ENOSPC in zoned garbage collection
Date: Tue, 14 Apr 2026 15:44:58 +0200
Message-ID: <20260414134458.153318-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This test stresses garbage collection in zoned file systems by
constantly overwriting the same file. It is inspired by a reproducer for
a btrfs bugifx.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
Changes to v1:
- Rebased onto patches-in-queue
- Use "generic/999" to avoid any conflicts
- Change the number of loops to number of seq zones
- Remove bogus "2>&1"

Link to v1:
https://lore.kernel.org/all/20260210111103.265664-1-johannes.thumshirn@wdc.com/


 tests/generic/999     | 48 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/999.out |  2 ++
 2 files changed, 50 insertions(+)
 create mode 100755 tests/generic/999
 create mode 100644 tests/generic/999.out

diff --git a/tests/generic/999 b/tests/generic/999
new file mode 100755
index 000000000000..4ac6c0ff935c
--- /dev/null
+++ b/tests/generic/999
@@ -0,0 +1,48 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Western Digital Corporation.  All Rights Reserved.
+#
+# FS QA Test 999
+#
+# This test stresses garbage collection in zoned file systems by constantly
+# overwriting the same file. It is inspired by a reproducer for a btrfs bugifx.
+
+. ./common/preamble
+_begin_fstest auto quick zone
+
+. ./common/filter
+
+_require_scratch_size $((16 * 1024 * 1024))
+_require_zoned_device "$SCRATCH_DEV"
+
+# This test requires specific data space usage, skip if we have compression
+# enabled.
+_require_no_compress
+
+
+_fixed_by_fs_commit XXXXXXXXXXXX \
+	"btrfs: zoned: cap delayed refs metadata reservation to avoid overcommit"
+_fixed_by_fs_commit XXXXXXXXXXXX \
+	"btrfs: zoned: move partially zone_unusable block groups to reclaim list"
+_fixed_by_fs_commit XXXXXXXXXXXX \
+	"btrfs: zoned: add zone reclaim flush state for DATA space_info"
+
+
+_scratch_mkfs_sized $((16 * 1024 * 1024 * 1024)) &>>$seqres.full
+_scratch_mount
+
+blocks="$(df -TB 1G $SCRATCH_DEV |\
+	$AWK_PROG -v fstyp="$FSTYP" 'match($2, fstyp) {print $3}')"
+
+loops=$(echo "$blocks * 4 - 2" | bc)
+
+for (( i = 0; i < $loops; i++)); do
+	dd if=/dev/zero of=$SCRATCH_MNT/test bs=1M count=1024 status=none
+	if [ $? -ne 0 ]; then
+		_fail "Failed writing on iteration $i"
+	fi
+done
+
+echo "Silence is golden"
+# success, all done
+_exit 0
diff --git a/tests/generic/999.out b/tests/generic/999.out
new file mode 100644
index 000000000000..3b276ca804fc
--- /dev/null
+++ b/tests/generic/999.out
@@ -0,0 +1,2 @@
+QA output created by 999
+Silence is golden
-- 
2.53.0

