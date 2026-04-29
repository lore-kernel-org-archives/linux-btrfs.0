Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B5542C3259;
	Wed, 29 Apr 2026 20:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777495693; cv=none; b=OzLN9/+awTq9hHDL1ReIyZyG3SdRhVUnSc/IDBMr8CRcURvr7HFnfZytAXtePvEUMx4AI22XRgkvGGg0Hqa4EKnJIh9jYYx+sU76nZke/eZKGnf4hm9JpHDZbS1lG2ZUAY2glejy3HKogZLJDQdeBvU+IrAHkHHXdUN25TXQC9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777495693; c=relaxed/simple;
	bh=jD2tnPjT+mVdbbH+mbn2X2InqfNaaAu+t3E47eqgzoc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tZCDvAw+pt2/+4F0RAbyIuJlCt0QvHoDpmHyo8b+DDcbYzmv6O6Hjb/j2CxZ7cpTY8V2KKiHNh/IstyByuXEx9q7oz+ywc0pov0Qocp4ngQpnVxaMQNBNp7n4jwuIuX7EBMVYAFZRUuS94BpVkpuOuvXhEOfy4tTgzR91KRSFxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=G93aqohd; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="G93aqohd"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1777495690; x=1809031690;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=jD2tnPjT+mVdbbH+mbn2X2InqfNaaAu+t3E47eqgzoc=;
  b=G93aqohdpKCR7LJumIAK6UPAF6xDqPwwYmTGgyuw3z5R0DcDSXMJOf0y
   kciVN/odXUsiR9u6/1Rf8pvIoGXt1ru165zDtkZAJXJrSu567dyoyAG2F
   OQE+jC9E8xo8koud2DLvt6AWbqgRvFj9Pxi+w5V7gXBRTS1cYGSGEPNNS
   GRCupFIYpdjQKmV8/Ls1wu5yYvNUN+o6pgI7dZYIU346yQB+C4hUJdme9
   cJuqKwnV7E4ss6adRlNJrjsFHvbd9q+SPqELgi6/pSt+IjSDQxzRW0cYd
   cN97Z7/peLXJjjzeuqacjIyKVrBHcRWw7MxQ9y5kaTPR7Ht4X9hj7yuqJ
   g==;
X-CSE-ConnectionGUID: lFUyp3jKTiy7qjdhfJMLJg==
X-CSE-MsgGUID: uvjt3kgyRR+gTD3B0JfdZw==
X-IronPort-AV: E=Sophos;i="6.23,206,1770566400"; 
   d="scan'208";a="145552338"
Received: from unknown (HELO uls-op-esad2-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 30 Apr 2026 04:47:01 +0800
X-CSE-ConnectionGUID: VaoI5fW7Q2uCI5Ldq0DeRw==
X-CSE-MsgGUID: qIiS6DwOQyyxYVYCi0xXDQ==
IronPort-SDR: 69f26e27_K2Su1sHiTThFFlRbjvP01Z3TsKS1i91/X0pRM9oKJvqvjXj
 4VeO5JEaA38+xrgIVgOgdI8a9+uFclMMCj6Jmtg==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad2-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Apr 2026 13:46:31 -0700
X-CSE-ConnectionGUID: yRZbdT35Ru2lUnuN/QJuew==
X-CSE-MsgGUID: dtzVo67rTFCL2lB4ige/IA==
WDCIronportException: Internal
Received: from 5cg1443s5p.ad.shared (HELO neo.fritz.box) ([10.224.28.29])
  by uls-op-esai1-o.wdc.com with ESMTP; 29 Apr 2026 13:46:29 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Zorro Lang <zlang@redhat.com>
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	fstests@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Hans Holmberg <Hans.Holmberg@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v3] generic/793: limit number of overwrites
Date: Wed, 29 Apr 2026 22:46:24 +0200
Message-ID: <20260429204624.807220-1-johannes.thumshirn@wdc.com>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---

Changes to v2:
- Re-add $BLKZONE_PROG

 tests/generic/793 | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/tests/generic/793 b/tests/generic/793
index a59e84694309..0d3b0bfcac5e 100755
--- a/tests/generic/793
+++ b/tests/generic/793
@@ -11,6 +11,7 @@
 _begin_fstest auto quick zone
 
 . ./common/filter
+. ./common/zoned
 
 _require_scratch_size $((16 * 1024 * 1024))
 
@@ -34,12 +35,14 @@ _fixed_by_fs_commit btrfs 258e46a6385c \
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
+zsize=$(_zone_capacity 0 $zoned_dev)
+loops=$(( fssize/zsize))
 
 for (( i = 0; i < $loops; i++ )); do
 	dd if=/dev/zero of=$SCRATCH_MNT/test bs=1M count=1024 status=none
-- 
2.53.0

