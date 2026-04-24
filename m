Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D00D1862;
	Fri, 24 Apr 2026 11:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777031333; cv=none; b=nMpsEEbDkiAsDJG0WUQPV/lRavE0YGK4is4ZPQU31SQtDUsctiAIFAW6NzcFByTqhd53TJGkjSoPnvgtt1HYwIAc2OASJYbbit/AjNQffmpr6BOO8J/TTOK5LLuW3WA7j3Y8XLrJjzQl/L3NZBJU5O5Nfo4z01y14uNV0Uwhrro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777031333; c=relaxed/simple;
	bh=1y8Y1cBqvB7USRIY0dFrQP5ZTRAxdXQAcZUnbcXO6ko=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=S1aa08LuQzho4tqddlVF5eK1tYgExyS/FbH4/d4l+baPhOZUAKIKiTAFw9cSjMnAv8ldLXFTcmPjHRhr55lTJSwRxUymkum+4sF0mEhhFhfcG0qxPgaLNFaHxech+SuM2T3dvq68hDuu1X9gn4eHzm3fcdvq9CUFIdNtGhFhB34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Dgz7Wwxs; arc=none smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Dgz7Wwxs"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1777031331; x=1808567331;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1y8Y1cBqvB7USRIY0dFrQP5ZTRAxdXQAcZUnbcXO6ko=;
  b=Dgz7Wwxs6l3WVN/debAnPqahzuPKS/ZHRTPJz5wY6Gb7hEO1aBONavpB
   W+c/WKIuiGDxPN5Hz7ET8h51pB2vTwlN2TRRSmGAKSjHPLT3a7jNEy+FO
   cKvu9EhrpHV7aTaBNpNSw/Gh2NWuK3pKfgGabPhoQIXpKHkWnkEm2MIXT
   Ga6UvLI9CHPlpQKBjmv1Hykq53dK0fXz1DjPEGeDewOoHdzp4k8/XueR4
   m/svuuALea/FfDbv8c14fw5pijSl8Y6g9ljk3mCdqDB7Lf3A+s/63Vp1c
   CzJwBGod19+Ro8DtC0g88Gl91TUYOmpHES+sSpDYeqzOoedYo5RiiQ4wG
   g==;
X-CSE-ConnectionGUID: gQjaEl2LQVi9nsaI2YBXXA==
X-CSE-MsgGUID: x7WOY8ZXSc64tK5cSOxQLQ==
X-IronPort-AV: E=Sophos;i="6.23,196,1770566400"; 
   d="scan'208";a="144679701"
Received: from unknown (HELO uls-op-esad2-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 24 Apr 2026 19:48:50 +0800
X-CSE-ConnectionGUID: 14ZOpjXVTlSmuKwBjY9pww==
X-CSE-MsgGUID: aYA23wDKQI2qnzaeTF+bdQ==
IronPort-SDR: 69eb5889_sLNaAOkV/yi4SLHfCqjeSQA4fXmxorownCNqAav/cMrurep
 1n9e5V+/M+Udql2nOIPOvQVjMChxWyHmdaeVruQ==
Received: from uls-op-esai2-o.wdc.com ([10.248.3.38])
  by uls-op-esad2-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 24 Apr 2026 04:48:25 -0700
X-CSE-ConnectionGUID: 7EQfrEUsTSqAC4JPMur4vg==
X-CSE-MsgGUID: gTww68G+SOOBT0Xi79SWmA==
WDCIronportException: Internal
Received: from wdap-u5y2tr2jdw.ad.shared (HELO neo.fritz.box) ([10.224.19.11])
  by uls-op-esai2-o.wdc.com with ESMTP; 24 Apr 2026 04:48:23 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Zorro Lang <zlang@redhat.com>
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	fstests@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Hans Holmberg <Hans.Holmberg@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2] generic/793: limit number of overwrites
Date: Fri, 24 Apr 2026 13:48:19 +0200
Message-ID: <20260424114819.177805-1-johannes.thumshirn@wdc.com>
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
index a59e84694309..fcfbc4983d7c 100755
--- a/tests/generic/793
+++ b/tests/generic/793
@@ -11,6 +11,7 @@
 _begin_fstest auto quick zone
 
 . ./common/filter
+. ./common/zoned
 
 _require_scratch_size $((16 * 1024 * 1024))
 
@@ -21,7 +22,6 @@ else
 fi
 
 _require_zoned_device "$zoned_dev"
-_require_command "$BLKZONE_PROG" blkzone
 
 # This test requires specific data space usage, skip if we have compression
 # enabled.
@@ -34,12 +34,14 @@ _fixed_by_fs_commit btrfs 258e46a6385c \
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

