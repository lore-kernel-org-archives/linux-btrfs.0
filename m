Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86C7626CE1E;
	Tue, 14 Apr 2026 14:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776177257; cv=none; b=khrnoQLBQhRiLIkTBT3hYbbMrg4uRjVJ+R4Adj8R1FxhBLYQbiVJEzjlbit/xqsUmtWVU49R+X4puAClv+44mliXb2h6YmcBaDRUBJflwusc2tLMtp7OF8ge36qkU4BpXE37UfsKGlMY+xTPZ9XWyhtAOKZ87OU0pmRl8n8bAUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776177257; c=relaxed/simple;
	bh=2qjK66LJeGOdOMUrjly8VjRY5mOqnEskXJ7wwrZcI80=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ArdKpCmfhzuS+ZQXPmx+1PqPTp3IYeuRkKhxA2DSIyBh1xOPj05IquVZjrdgGo11W4N/phzf39LEw+BWK+P+4IKvIRxOIYW22OFrXQQwCR+17Ys5RsFBH7ahR1COg1cfzSEP7JKIuVKlbBaCtRVzFkkOkn2+2StM+qMnJLl585M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=lNSDmaxg; arc=none smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="lNSDmaxg"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1776177255; x=1807713255;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=2qjK66LJeGOdOMUrjly8VjRY5mOqnEskXJ7wwrZcI80=;
  b=lNSDmaxgbh8KOkbQtdAvb/E80yrTdiWM7Ay4e88WqJwrBilQxORJooWv
   3V11/WvhTfWYl6x+MkkMSYqkSTTDhivkUMZlri2QbiNRLjK/0KnScc0lx
   D7qzMgWpO0TOFG6MfN4UgoUcEDJN5gzVQuGHfvbLFW1k+ERaNmF14PquC
   NpnjyyGGLYhRnrr8+mafZg9vOQwVMG6uQecXkeYNsxcjsxGlIid+lTY/j
   K8N38ad75gl0nJDHQoRpwMu4Zz8FY0D5iuk55n6pD/mmkNnweFNatwewg
   gf75Mcnxsncm1UW9EJA/BN2QJhv7+YVHpaoQ2gQYMn0u2X9Ay3YZb3xdE
   g==;
X-CSE-ConnectionGUID: iJAtNElURqS0gVYQF23dtA==
X-CSE-MsgGUID: qnEHXDoJQhGL1DTt6XO7Dg==
X-IronPort-AV: E=Sophos;i="6.23,179,1770566400"; 
   d="scan'208";a="144023936"
Received: from unknown (HELO uls-op-cesaep03.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 14 Apr 2026 22:34:09 +0800
X-CSE-ConnectionGUID: /XxJDdVwSxKa1J8uSYbqEQ==
X-CSE-MsgGUID: SUG+oIarRBmwXF2dJ/9smg==
IronPort-SDR: 69de504c_7L11oYQDNxNj5bbRGXB/3McY4C0vx8zshKJueTfodHocl8n
 UehznfDXwLWJN6jXO2l2sUvPRs+sEX5HIIWSQRQ==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep03.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Apr 2026 07:33:48 -0700
X-CSE-ConnectionGUID: gtj1slHmTha8BHAOwra2aw==
X-CSE-MsgGUID: z9alXVxuRRWU9F2b4NpSRQ==
WDCIronportException: Internal
Received: from wdap-r8nvkhmetp.ad.shared (HELO neo.fritz.box) ([10.224.19.25])
  by uls-op-cesaip01.wdc.com with ESMTP; 14 Apr 2026 07:33:46 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Zorro Lang <zlang@redhat.com>
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	fstests@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v3] fstests: test premature ENOSPC in zoned garbage collection
Date: Tue, 14 Apr 2026 16:33:41 +0200
Message-ID: <20260414143341.167875-1-johannes.thumshirn@wdc.com>
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
- This time really did it...

Link to v1:
https://lore.kernel.org/all/20260210111103.265664-1-johannes.thumshirn@wdc.com/
 tests/generic/999     | 46 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/999.out |  2 ++
 2 files changed, 48 insertions(+)
 create mode 100755 tests/generic/999
 create mode 100644 tests/generic/999.out

diff --git a/tests/generic/999 b/tests/generic/999
new file mode 100755
index 000000000000..ef2b63abefd7
--- /dev/null
+++ b/tests/generic/999
@@ -0,0 +1,46 @@
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
+_require_command "$BLKZONE_PROG" blkzone
+
+# This test requires specific data space usage, skip if we have compression
+# enabled.
+_require_no_compress
+
+_fixed_by_fs_commit btrfs 7bcb04de982f \
+	"btrfs: zoned: cap delayed refs metadata reservation to avoid overcommit"
+_fixed_by_fs_commit btrfs 258e46a6385c \
+	"btrfs: zoned: move partially zone_unusable block groups to reclaim list"
+_fixed_by_fs_commit btrfs e2a7fd22378f \
+	"btrfs: zoned: add zone reclaim flush state for DATA space_info"
+
+_scratch_mkfs_sized $((16 * 1024 * 1024 * 1024)) &>>$seqres.full
+_scratch_mount
+
+# Overwrite the data "number of seq zones" times, this is arbitrarily chosen
+# but triggers the original bug reliably
+loops=$($BLKZONE_PROG report $SCRATCH_DEV | grep -c "SEQ_WRITE_REQUIRED")
+
+for (( i = 0; i < $loops; i++ )); do
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

