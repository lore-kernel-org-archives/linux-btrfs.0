Received: from outbound.st.icloud.com (st-2004i-snip4-11.eps.apple.com [57.103.78.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA5241D629
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Sep 2026 04:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.78.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790225871; cv=none; b=vDXQqLXnlBA2vrIHkyKDQwhuhAwsmLYOP+kAtcRVNgnesJ4sWHhElwMCQYTBGhi4nj8BIpcnAAvpVBB9vhqGAMFM/Xs7/0rfeEsi2cPL1I1gaatnzmAhLllqcdhl9fEYv+/uS+SxTqj6WBAgcruTGHG3JEIXLv9xSh/wE/MGQiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790225871; c=relaxed/simple;
	bh=YsS+6rLkxvWidDq+o3lYRu4x587ON9Fp6DfheirjntY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j/0HYoNFVDTRE1qayDyhJqsh2US2yF7HpWTVU1JLHk88I4MhDSucba6Ra5EUv45VtIOKjHa3EQ7WGKq6zanpjn/hMp5V7kDrw0mkYM/R6hWqiWUIkOLgipsU97UxEYz0fgm056+IZZhov0ys9rOBmc03baPiZoUEb1UHTklw16g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dev.linjama.com; spf=pass smtp.mailfrom=dev.linjama.com; dkim=pass (2048-bit key) header.d=dev.linjama.com header.i=@dev.linjama.com header.b=WUmFLNrI; arc=none smtp.client-ip=57.103.78.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dev.linjama.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dev.linjama.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dev.linjama.com header.i=@dev.linjama.com header.b="WUmFLNrI"
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-0 (Postfix) with ESMTPS id 6BA8C1800164;
	Thu, 24 Sep 2026 04:57:47 +0000 (UTC)
X-ICL-RepId: 01a0d1c6-e268-78c2-9b16-cc20aa2b1c7d
X-ICL-Out-Info: HUtFAUMHWwJACUgATUQeDx5WFlZNRAJCTQ9KHVwHXRxBDFYCXQ5LVxQEHFIDXg5eMF0dRUNbAlwaWBVSQ1QEX1BfHA4JUh0cHFAWWQxaChwTVhUTH1RWBlBRHV8CCgRHBFsXRgNTRUEEFxFQAVgeVl5aF15NRx9ATWJJAVoZWxxAF0puTVMPDxRcDh0BXgVYEVQZHQ5YBhIdUBwOUQVbAEYJQQFZB18HRwtPHVoEXQpJCFUBQFMKXBlcFHMJUh0cHFAWWQxaChwTVhUNTUMSQhUEG0YeQwRfL10XXgxeBQ==
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dev.linjama.com; s=sig1; t=1790225868; x=1792817868; bh=ZQoKULuvnLsE5HeuTQxDUrfvzEsSBo6oJG4cxtcjqJI=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=WUmFLNrIpMRHTJti58LlmvMOv/ZIwsAI9dd0ZL71V/fayLGBvL78R3PRz56bDL9EQvxqcvwMN0ZBlJlia3LVEUXzfduZ0lsZr65svgqOK7NS7Ze2ENYsTMiieoD7Hx+jZVt6fUJLM2PTa7Os7k1aTS2imJD1JJiM/4dfF/3VOQdXiu+VdjLJJEhXGMIfBkQ5pC+MdTk7Yq3YFK9Z9+RM+/2NIscHrkv+ALo4bJbvZta8FsC+dyfDjf6fE+FgCKgDGHfTsytIXy3aD75I42MAP0L1xXI4peCGBAja7aDafZ7KGK/0Uq0i+sqoQHGdMn/PNyuviyR4DH/N+e4kI/rE/A==
mail-alias-created-date: 1690913137769
Received: from dev.linjama.com (unknown [17.156.216.30])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-0 (Postfix) with ESMTPSA id 2647A1800151;
	Thu, 24 Sep 2026 04:57:46 +0000 (UTC)
From: Daniel Linjama <daniel@dev.linjama.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	Qu Wenruo <wqu@suse.com>,
	Daniel Linjama <daniel@dev.linjama.com>
Subject: [PATCH v3 2/2] btrfs: test ENOSPC handling on fsverity rollback
Date: Thu, 24 Sep 2026 07:57:27 +0300
Message-ID: <20260924045727.736891-2-daniel@dev.linjama.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260924045727.736891-1-daniel@dev.linjama.com>
References: <20260924045727.736891-1-daniel@dev.linjama.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI0MDAyMSBTYWx0ZWRfX+Ao/lOt2C4rC
 Y6pdrYykKv4EOQdBl3beYfYYx/UiqshLW9/K2G1zLOWia7eBEG3fGarzZGIjdQ2CwIkDA62fTec
 y4CF98hD3ly93YH9lZi4hqk0rx69laIilTo0QSSIkEgzHnCQGqy8GNe+PhRwLOUBWAqDUzVJ1Kn
 tfraz+f1qry+bW0rkeDJJ7+JOHtmcCdwHpsWQuXa0PC4F5TWM/cCuH+E3QiU4xFWt+cY11kLCZi
 i1M6XEiD9fmx/Uw/T2Rht/T/5/UQZGM/5aZKdt4OcWenQ1sCpbiSHDH4zjIT7f02A0goQNEiTU5
 eEbNMLOv2o2/9VgWFH+qyUJW04Q8wTwqu9lwqRf9FF0xhPqzJ9zC6FROHox0H0=
X-Proofpoint-ORIG-GUID: e2BB3RnXAEbzClG3xDvbV85dsXLZaC3a
X-Authority-Info-Out: v=2.4 cv=R4YO2NRX c=1 sm=1 tr=0 ts=6ab4adcb
 cx=c_apl:c_pps:t_out a=oyWFxbOnq+dmhQrAPgaJYA==:117
 a=oyWFxbOnq+dmhQrAPgaJYA==:17 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=olXNNK5aAAAA:8 a=iLia4Pd5vxHsIscpiQMA:9 a=U4UmX7kblY_o6ZOM_jyP:22
X-Proofpoint-GUID: e2BB3RnXAEbzClG3xDvbV85dsXLZaC3a
X-JNJ: AAAAAAABk6ku2wLJlu50qMbw3sndyKo93RqHk6dyEUe5tGX5C7a+LaT2Np4ISb0ROHt3/kgmDp0YXwY4jKIVjH6OJXdBsIsRslq5LqYULbNE+ZHzP6Vd0XY3zeHCtwqnbz/1RUitT92fF3/f+d7xJM+Jtbqh4ClwyAnfAL0fQ7dXpS94+i0kwtH4SeFE/Ch2y3sBc54cIyy/MYcybGKkxtXHuIwLwmFvHKlUlw8r7To1Bsn15wiQA5PrpQsDMdDidcm4EU3tKuKkGR14JFJvDAOqQ2Y74238G5BmPUGylznlTNRsv9lJgIUED3ov/XCeqY52MLwzr6IRogLB5jJNebKtXwMwTexorQU9BF15y7u7x/sWQITK6OPrk/cISyypejpdwGOXB0xY/8MTIxxfOZoUrjIpKDOBbv5i48HOg0qIyJqx9HMbiMmmyfj5i19I+MTwdzpZxLN72l3DLJzdMPrKVTD/LzLxm8sMgBDr6qlku0h5e6bfgpbr3IWgYJXb3CTG7L1e/GvsjOi/C7SZ14lJfrRZOCEYQzWbnNLuMvPYWMcvlNi3ugcx5ysRzbM4lXur0rAxnj+Zq5rOtkG9b3qzgBpEVk8hfsTdmDC8L+BH9froJBUfU2GDG3EBouPbtPtud+vrRVY51N35YfK4siggRUkEIZTy1LtlEHAzqG7PKtaX7TplOoGGX//WRiWcCc+BPHCQ4q/Hz4bRDKMf7hQi4mhZSn83SEOxWLEb

Test that the filesystem stays writable when an fsverity enable and its
rollback run out of space on a small mixed block group filesystem, and
that it still mounts afterwards with no verity or orphan items left behind.

The -ENOSPC counterpart of btrfs/354.

This exercises a bug fixed by kernel commit 76bf149cd029 ("btrfs: handle
lack of space when cleaning up verity items").

Assisted-by: LLM
Signed-off-by: Daniel Linjama <daniel@dev.linjama.com>
---
Changes since v2:
- The fix is in mainline as 76bf149cd029, fill it in.

Changes since v1:
- Fill the filesystem with a single xfs_io write, like btrfs/354 now
  does. The room for the enable to start is made by deleting a small
  file written beforehand, since a truncate fails on a full filesystem.
- Look for leftover items of the target inode only, like btrfs/058 does.

 tests/btrfs/355     | 117 ++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/355.out |   2 +
 2 files changed, 119 insertions(+)
 create mode 100755 tests/btrfs/355
 create mode 100644 tests/btrfs/355.out

diff --git a/tests/btrfs/355 b/tests/btrfs/355
new file mode 100755
index 0000000..f7918a4
--- /dev/null
+++ b/tests/btrfs/355
@@ -0,0 +1,117 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Daniel Linjama.  All Rights Reserved.
+#
+# FS QA Test 355
+#
+# Test that a failed fsverity enable on a full filesystem leaves the
+# filesystem usable. The -ENOSPC counterpart of btrfs/354.
+#
+. ./common/preamble
+_begin_fstest auto quick verity enospc
+
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	_restore_fsverity_signatures
+	rm -f $tmp.*
+}
+
+# Import common functions.
+. ./common/filter
+. ./common/verity
+
+# real QA test starts here
+
+_require_scratch_verity
+_require_btrfs_command inspect-internal dump-tree
+_require_no_compress
+_require_scratch_size $((1024 * 1024))
+_disable_fsverity_signatures
+
+_fixed_by_kernel_commit 76bf149cd029 \
+	"btrfs: handle lack of space when cleaning up verity items"
+
+target=$SCRATCH_MNT/target
+
+prepare()
+{
+	# Mixed block groups, so filling with data starves metadata too.
+	_scratch_mkfs --mixed -b 1G &>> $seqres.full || _fail "mkfs failed"
+	_scratch_mount
+}
+
+create_target()
+{
+	$XFS_IO_PROG -f -c "pwrite -q -b 1m 0 512m" $target
+	ino=$(stat -c %i $target)
+	sync
+}
+
+fill_fs()
+{
+	# Deleting this afterwards leaves room for the enable to start, not
+	# to finish.
+	$XFS_IO_PROG -f -c "pwrite -q 0 1m" $SCRATCH_MNT/margin
+	# Writes until the filesystem is full.
+	$XFS_IO_PROG -f -c "pwrite -q -b 64k 0 1g" $SCRATCH_MNT/filler &>/dev/null
+	sync
+	rm -f $SCRATCH_MNT/margin
+	sync
+	$BTRFS_UTIL_PROG filesystem usage $SCRATCH_MNT >> $seqres.full 2>&1
+}
+
+enable_fsverity()
+{
+	if _fsv_enable $target >> $seqres.full 2>&1; then
+		_notrun "could not fill the filesystem, verity enable succeeded"
+	fi
+}
+
+check_rollback()
+{
+	# Deleting a filler needs no new space, it fails only if the fs went read-only.
+	rm -f $SCRATCH_MNT/filler 2>> $seqres.full || \
+		echo "filesystem was forced read-only by the failed verity enable"
+	if $FSVERITY_PROG measure $target >> $seqres.full 2>&1; then
+		echo "verity is enabled on the target after a failed enable"
+	fi
+}
+
+check_remount()
+{
+	_scratch_unmount
+	_try_scratch_mount >> $seqres.full 2>&1 || \
+		_fail "cannot mount the filesystem after the failed verity enable"
+	$XFS_IO_PROG -c "pread -q 0 1m" $target >> $seqres.full 2>&1 || \
+		echo "cannot read the target file after the failed verity enable"
+	_scratch_unmount
+}
+
+check_leftover_items()
+{
+	local dump=$($BTRFS_UTIL_PROG inspect-internal dump-tree -t 5 $SCRATCH_DEV)
+	local verity_items=$(echo "$dump" | grep -c "($ino VERITY_\(DESC\|MERKLE\)_ITEM")
+	local orphans=$(echo "$dump" | grep -c "(ORPHAN ORPHAN_ITEM $ino)")
+
+	echo "$dump" >> $seqres.full
+	[ "$verity_items" -eq 0 ] || \
+		echo "$verity_items verity items left behind by the failed enable"
+	[ "$orphans" -eq 0 ] || \
+		echo "$orphans orphan items left behind by the failed enable"
+}
+
+prepare
+create_target
+fill_fs
+enable_fsverity
+check_rollback
+check_remount
+check_leftover_items
+
+echo "Silence is golden"
+
+# success, all done
+status=0
+exit
diff --git a/tests/btrfs/355.out b/tests/btrfs/355.out
new file mode 100644
index 0000000..4e4c5e9
--- /dev/null
+++ b/tests/btrfs/355.out
@@ -0,0 +1,2 @@
+QA output created by 355
+Silence is golden
-- 
2.55.0

