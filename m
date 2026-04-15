Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE63154774;
	Wed, 15 Apr 2026 10:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776249652; cv=none; b=lS8AhOG9uAwIG7k2l9w/xVLWoXYEg3E7wJwHodKLMOpthubvUtb2S2fmBcpQFvcn2PxxctGQG6dqD7Adbe7wsVqAB5LfFpf55L85Z3sNg/uiPdkiG7gb7nFtmYVyhoGPrbuCrEdm4amB9hRkhuhUc9UGTnEl9oiZGxTdsUwjPXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776249652; c=relaxed/simple;
	bh=/TsgDaD2XIdhfaTtA1k7VuV6HQLJcaZkw/tDvNKFeug=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nJRrUzFBxuOOdlalz4M8iIt6I5PRjN5LY+eVKP+uA1ntXUQLKvXrrqG6Y1mLXTAqafGHex89/juPChQr1YsZiJREALmO4k0z5BdtZIL7AgaqWoyJ4xSWHQG8lt1+0Q7yAzEas7SqLIEdxOjoVSjBegGqid+Wl7nlKQpmBrfZKYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=hOAu8F60; arc=none smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="hOAu8F60"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1776249651; x=1807785651;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/TsgDaD2XIdhfaTtA1k7VuV6HQLJcaZkw/tDvNKFeug=;
  b=hOAu8F60VZMZWc1vCrSDJCRgTdbaN0bQpR+Ux8sRB83glp2V7jmi/E2a
   oN6ZFmd5pJPxeVcZOzMlXMMUzJJvfYXVA+7qxeaMNtP/+8wGFmRSzXTo3
   nicqnDmshJ/yFCZHK6TuVjz0/lT6OSvT1qFCtOom68nabRI42dZ1uLMkx
   1wmDS0yzR22wbLtTicfiG8qjmtkmYRsmoX+e1ySLnxhdWbhWDyi9Q1X+3
   SPH/qf6rBPhl7WrFplw2kGostC+rzI2ihkVdP6bJ+t1gI/ikhZj/RdXyo
   RBcolt6zIaZMLnVBcoT0IFMDe6bUBV4x9SK/F4QQn7MUkZbPZNQHqd7+U
   Q==;
X-CSE-ConnectionGUID: lY6/AzMATByabJ9YYqc2HA==
X-CSE-MsgGUID: jpM4++mtSYWdtRw1xWkVJQ==
X-IronPort-AV: E=Sophos;i="6.23,179,1770566400"; 
   d="scan'208";a="145016777"
Received: from unknown (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 15 Apr 2026 18:40:50 +0800
X-CSE-ConnectionGUID: BX/ATrfbSw2PxgwthCEiNg==
X-CSE-MsgGUID: lmxSxToCQmSOd+AC6qCikA==
IronPort-SDR: 69df6b14_0K9oFLV0M5CKRIREX4IKykfU2sVCX6C3cQ0QU2OKVZq5nlo
 6nDAMZwg7e5lbMnqag8JJkSOrQTUlHyWbEqbWjA==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 15 Apr 2026 03:40:20 -0700
X-CSE-ConnectionGUID: T0pRcT34R4KVpGZrKP/sGA==
X-CSE-MsgGUID: JTdq8xeXQh2PjINcxb2DpA==
WDCIronportException: Internal
Received: from f3gqj1c25d.ad.shared (HELO neo.wdc.com) ([10.224.19.9])
  by uls-op-cesaip01.wdc.com with ESMTP; 15 Apr 2026 03:40:19 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Zorro Lang <zlang@redhat.com>
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	fstests@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v4] fstests: test premature ENOSPC in zoned garbage collection
Date: Wed, 15 Apr 2026 12:40:15 +0200
Message-ID: <20260415104015.209741-1-johannes.thumshirn@wdc.com>
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
Changes to v3:
- Distinguish between SCRATCH_DEV and SCRATCH_RTDEV so both BTRFS and
  XFS work
- Fix typo

Link to v3:
https://lore.kernel.org/r/20260414143341.167875-1-johannes.thumshirn@wdc.com

 tests/generic/999     | 53 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/999.out |  2 ++
 2 files changed, 55 insertions(+)
 create mode 100755 tests/generic/999
 create mode 100644 tests/generic/999.out

diff --git a/tests/generic/999 b/tests/generic/999
new file mode 100755
index 000000000000..d3b38b676d37
--- /dev/null
+++ b/tests/generic/999
@@ -0,0 +1,53 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Western Digital Corporation.  All Rights Reserved.
+#
+# FS QA Test 999
+#
+# This test stresses garbage collection in zoned file systems by constantly
+# overwriting the same file. It is inspired by a reproducer for a btrfs bugfix.
+
+. ./common/preamble
+_begin_fstest auto quick zone
+
+. ./common/filter
+
+
+if [ -b "$SCRATCH_RTDEV" ]; then
+	zoned_dev=$SCRATCH_RTDEV
+else
+	zoned_dev=$SCRATCH_DEV
+fi
+
+_require_scratch_size $((16 * 1024 * 1024))
+_require_zoned_device "$zoned_dev"
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
+loops=$($BLKZONE_PROG report $zoned_dev | grep -c "SEQ_WRITE_REQUIRED")
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

