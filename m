Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A4779DA;
	Fri, 24 Apr 2026 06:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777011770; cv=none; b=cfvFZqsyo8iIuSSM8iGZ1pWH3GPVwXegM1LMKNcv1SWAfTLZpJm3w+ZU8jydL1YcBpG0rz4WYVqTC3afaUpBDNs8Nd44oNutnPZj+A+PpOjTmEZBKTPZ2YB+qKN5Puh1mpvr5R9MxkYFeADSdIbVd+VDOQeNhkmjyDAb3G6wr7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777011770; c=relaxed/simple;
	bh=caFcc/xF32N3EvBI0ZqJBBJPr6pC8TUVZc5F0XkIc7A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VOdaMMjDz49VmiDZq4Iwdx18DH2h/guUvRL2SCuQ6bMwh/exNPsoN5e/LlyLVBbN/OoWOJJeTy8nxYJPw3e4rfqc/FADTkHZNC8Gl9F90cVK4L/MobB1WlJPTKG94R8qVbyAHGGbicDwjvjKynBu+1rT1zkYHw0IhD32zE+r85o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=EZJPfYmO; arc=none smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="EZJPfYmO"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1777011768; x=1808547768;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=caFcc/xF32N3EvBI0ZqJBBJPr6pC8TUVZc5F0XkIc7A=;
  b=EZJPfYmODkuerDTId9ktJpVnBQurbNI3AB4xWf4ItGNGpyDfa3VG3oUP
   tcJk4mafEzxWDyny7y+lvuGRUXRoqPq6tv9Sgc59L3hXt9enUILjBk/9s
   mIgsVQEVB8YdLR4s8c7aje2Mt7MDkXKZgdUXuQ8uxZVkNukSBXy8uuoNW
   jGR2nsPt3YnU+x+OqeUAlTdGd8VVPYQt+kZ2eehNNgtYp+12kfI5mZnnF
   FBG8j3HZRDaEgxX8YxHNclnPaMi2J57MQS9ZCTcFkP+Srva7vB96+ttFH
   b2WEbpEROcdAqbTK/s402Qrl5foExou6h1U+xT+kUKxerLGVHzrTm6STJ
   A==;
X-CSE-ConnectionGUID: zFejs/slQ0OCzTc6218K7A==
X-CSE-MsgGUID: 9RWX5adoQ2aQoTGqiHHYmw==
X-IronPort-AV: E=Sophos;i="6.23,196,1770566400"; 
   d="scan'208";a="141401011"
Received: from unknown (HELO uls-op-esad1-o.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 24 Apr 2026 14:22:47 +0800
X-CSE-ConnectionGUID: eDBeQ0gdSDGfbeqmM6B/cQ==
X-CSE-MsgGUID: WxVFJmXORBeJSIwRcE1sAQ==
IronPort-SDR: 69eb0c25_PFxmhNomyIeRinqvdmHxVkl/ApERNSrUWMYyvhtuxA5EGXt
 idTFFeQyusEjb4BC9B/ool4ggaAAMOxqW3dBHbQ==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad1-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 Apr 2026 23:22:29 -0700
X-CSE-ConnectionGUID: okn4ZxKfTsmJbPMnF0k4yQ==
X-CSE-MsgGUID: FKqZP3QXQWOdE9l9z15XZA==
WDCIronportException: Internal
Received: from wdap-u5y2tr2jdw.ad.shared (HELO neo.fritz.box) ([10.224.19.11])
  by uls-op-esai1-o.wdc.com with ESMTP; 23 Apr 2026 23:22:27 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Zorro Lang <zlang@redhat.com>
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	fstests@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH] generic/793: limit number of overwrites
Date: Fri, 24 Apr 2026 08:22:22 +0200
Message-ID: <20260424062222.87298-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Testcase generic/793 overwrites a 1GB file "number of sequential zones"
times in order to trigger a bug in zoned BTRFS' garbage collection. But on
scratch devices with a huge number of sequential zones (like SMR drives)
this can cause very long runtimes.

As the testcase also limits the filesystem size to 16GB, constraint the
number of overwrite loops to the number of sequential zones in the
filesystem. This still guarantees that the file will be overwritten often
enough to trigger the bug while not exploding the overall test runtime.

Reported-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 tests/generic/793 | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/tests/generic/793 b/tests/generic/793
index a59e84694309..6d48b991bedf 100755
--- a/tests/generic/793
+++ b/tests/generic/793
@@ -21,7 +21,6 @@ else
 fi
 
 _require_zoned_device "$zoned_dev"
-_require_command "$BLKZONE_PROG" blkzone
 
 # This test requires specific data space usage, skip if we have compression
 # enabled.
@@ -34,12 +33,15 @@ _fixed_by_fs_commit btrfs 258e46a6385c \
 _fixed_by_fs_commit btrfs e2a7fd22378f \
 	"btrfs: zoned: add zone reclaim flush state for DATA space_info"
 
-_scratch_mkfs_sized $((16 * 1024 * 1024 * 1024)) &>>$seqres.full
+fssize=$((16 * 1024 * 1024 * 1024))
+_scratch_mkfs_sized ${fssize} &>>$seqres.full
 _scratch_mount
 
-# Overwrite the data "number of seq zones" times, this is arbitrarily chosen
+# Overwrite the data "number of zones in fs" times, this is arbitrarily chosen
 # but triggers the original bug reliably
-loops=$($BLKZONE_PROG report $zoned_dev | grep -c "SEQ_WRITE_REQUIRED")
+qp="$(_sysfs_queue_path ${zoned_dev})"
+zsize=$(( $(cat ${qp}/chunk_sectors) << 9))
+loops=$(( fssize/zsize))
 
 for (( i = 0; i < $loops; i++ )); do
 	dd if=/dev/zero of=$SCRATCH_MNT/test bs=1M count=1024 status=none
-- 
2.53.0

