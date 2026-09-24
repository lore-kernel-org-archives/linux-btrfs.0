Received: from outbound.st.icloud.com (st-2002l-snip4-5.eps.apple.com [57.103.78.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1342D411FAC
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Sep 2026 04:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.78.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790225868; cv=none; b=mnSSSjIrTabhUVI+pxDQId1QTnttwa8EeSZlgXRr/2kyPVR37dW3p+ghR8pXY9kxKtASQgrBHItgxH/mXJpZuRzgYODC4B19ZEUpTDfZPN4EuO89yx0FpOXaLg37N8lsOWciSPZ127vInft3yQpVkARDpNm3a96jQVSSLMKYOUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790225868; c=relaxed/simple;
	bh=zuVGv5zCf2xo1SjbacxUjEVeQamaOikImaW29pk6fPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CAJBz2YX1EyaTanHuKK52cGhS15qJJE5NojSFgNicDfF6b64NX5to87V4qsgEe6HFt5p7bvq046Jx2BI6DBhHbyiHyUKdrsCnTo0VLnjus+Ljsp1y3itHU0A0BrNSICMyE11Ae6vzVPVkQpz3MPRYppIPlnGTX5mNzBuyCjkyYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dev.linjama.com; spf=pass smtp.mailfrom=dev.linjama.com; dkim=pass (2048-bit key) header.d=dev.linjama.com header.i=@dev.linjama.com header.b=Wsz+SEhk; arc=none smtp.client-ip=57.103.78.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dev.linjama.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dev.linjama.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dev.linjama.com header.i=@dev.linjama.com header.b="Wsz+SEhk"
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-0 (Postfix) with ESMTPS id 1D5A71800165;
	Thu, 24 Sep 2026 04:57:43 +0000 (UTC)
X-ICL-RepId: 01a0d1c6-d555-7b61-968d-860a5d655882
X-ICL-Out-Info: HUtFAUMHWwJACUgATUQeDx5WFlZNRAJCTQ9KHVwHXRxBDFYCXQ5LVxQEHFIDXg5eMF0dRUNbAlwaWBVSQ1QEX1BfHA4JUh0cHFAWWQxaChwTVhUTH1RWBlBRHV8CCgRHBFsXRgNTRUEEFxFQAVgeVl5aF15NRx9ATWJJAVoZWxxAF0puTVMPDxRcDh0BXgVYEVQZHQ5YBhIdUBwOUQVbAEYJQQFZB18HRwtPHVoEXQpJCFUCQFMKXBlcFHMJUh0cHFAWWQxaChwTVhUNTUMSQhUEG0YeQwRfL10XXgxeBQ==
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dev.linjama.com; s=sig1; t=1790225866; x=1792817866; bh=r/V1oYYsXsAyNvmbh4UVjR8BMQtaqenPfThSzDpPt+E=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=Wsz+SEhkjHEPr2bydt7eMoyGxr14UyRAdM2an+KCOU1HsLOfRp3NQg2Vr+ok+UTP8bBNWkUytY2gjcH7ZpA+VhxMvBxcvsvh90utHX4Al/9tVKS8Ev/0wXM/PZE4ZNXWhH5ET5dELnUtYfHIjKEyxiHD4uCLyUqN+OqlrPgvSOdvbZcRrQf9JRHPrrnP78a+rbC7hS+Wr3Ny+302l7okqF93WNX1odhHSgRKS2LASXK+GSi4gFksTXQs71LuoGuM9UuLv4qwHzgXxdAr24NDU44nQlP2M5BrxRME+KEotD+HFVe5RZtFVfur3PM22XRoA8W+xeDWzfvP7ueb8mVqfw==
mail-alias-created-date: 1690913137769
Received: from dev.linjama.com (unknown [17.156.216.30])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-0 (Postfix) with ESMTPSA id 9E1281800151;
	Thu, 24 Sep 2026 04:57:42 +0000 (UTC)
From: Daniel Linjama <daniel@dev.linjama.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	Qu Wenruo <wqu@suse.com>,
	Daniel Linjama <daniel@dev.linjama.com>
Subject: [PATCH v3 1/2] btrfs: test qgroup limit handling on fsverity rollback
Date: Thu, 24 Sep 2026 07:57:26 +0300
Message-ID: <20260924045727.736891-1-daniel@dev.linjama.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: 5w-yfuHmzk-_6ucB_Rkw8Uw0rjdDKtlI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI0MDAyMSBTYWx0ZWRfXwVi8wMji8Rsw
 YLud1EHqYNlzSbrP5ZuoBn5QQUG4hd+sdFyfE6T5GBor60WczVyyVnAgEgjLDw+Mtl5HqxW0ano
 bDxZF7RksWYD2uV+o6aMVZ3B0dCUomwrj7XsaR85tUN+rhXRvQnu9PPRb6VBULlOfCYoJM+VCTI
 O1CiLVwOvUSWtge6MrjmZP0KLCix0mWRqXAwLyUQZiBABUp3VpB7bNn+8mrl95pYKdr4HeY6p5U
 2vGvDmxVZ5O61U9uCTkyLWNGPNfSxDVfuGv1A8vRE1CnZM409ZYYUX06rB+5a6uKOsvV16sryaE
 L9VQFkIqBJ5wEKMgAPT/14olv94YD9Val7iSUYgF3kWoILIhQDW4sgJ7ODj1Xo=
X-Authority-Info-Out: v=2.4 cv=XKM9iAhE c=1 sm=1 tr=0 ts=6ab4adc8
 cx=c_apl:c_pps:t_out a=oyWFxbOnq+dmhQrAPgaJYA==:117
 a=oyWFxbOnq+dmhQrAPgaJYA==:17 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=olXNNK5aAAAA:8 a=WwdHHYCB-LfYqlj0cEEA:9
 a=U4UmX7kblY_o6ZOM_jyP:22
X-Proofpoint-ORIG-GUID: 5w-yfuHmzk-_6ucB_Rkw8Uw0rjdDKtlI
X-JNJ: AAAAAAABELym5/1abw5K5cEV55A07EdtdMLh4+wEN57SBjzOGgsOZ7Y/LBRIyFmvdCW/uy5x+6nnep3Rv/f+rnk3+RdJQ9IUQCEP6aKiCMEj5j51gY/Q2HZjjp/EkaVxA4DUe8lyk7ZQnJUWCsRhoJRequGqm9AnD2o5yv8Z4IPWXobypwwezMKOlWijEdnxR6k8KUxQUfiCKy5uBnD+HaEefNPh+uyfZb9xghPG2yjETe+3jDtbOlEWeNMgvTA/O0eiEPAwEA2HUOKPHylqFbwZBgHITlzHK72uhL4LNxdjeSsAu5xHvObzKHqlrX2/ijWDEZX95uY9EGoUzEwB92yZM4NMvHws9yLMc45DdnukbarhZpwToe9pweKxaUv/SZaNAs4ReTuNSZLoLdF4Ko1ulyy2pIzxhkrcIhiNR1IFsLL3uxB92w5hWQlPQuqtaxooCLuQ8+4sAZYKR/Afq90W+iAQAE/S4na0iYaBvn74K8J1WgSPYmjhByupeC72dL1/CoiW4RL4RJzrjN3DLkydoJ186wkNfqOocFfoAmZl65yBsAl0zp9+clzaFEnQg/FqvYwQf6Ic87sI7h1X5xGquMJemok0geipIBpg/qzm4uhoNXla2dUd31g9Yhuovnr5gqNpHN5dHT6kLv/xCieF3JVM7H0Py3i1n/DIrDSIJVza8Baivx6j08rwrSKAvwssfQf+0kFtAESdyLz4fRmyNrfjjE/ulC40ZwkBPpDZ4SLiHyIOqoNIdQd9wOAwIG8eVVqVbSGRiJQUJ7rx58pZHCgUrX8o0dNYxAhuwsquzYWSaJHBq/iKrci6V79bkEOAP3oNK2cx++r6hRqeOUA/NQhj5+6Fhos1QD5d6sQlsTTp18c3sq6MX0CwzoDf4LxlGNINgFQdgDPLTivN1GncMOalTqrNE97UazgeCjJUMvyN9Pucy2Z1pcID0SgpF7D4icCwAqM1//LoGexv1Kf+R8EiUW1
 mPh+YqHa0llpcreLji7bnNe3aiNFcU3EAe0ODyhDs8wqheZI/aLDBvvl0WWAoPOrrJTGa4HXPm/jN85eiM0tDDnbYtdjt6xcZkKfLrneLzFn8pxxlQsPfR5I3eG6PyZuWo6C7YC7rnqhHJc2WbYv7J0f3Gmt4IvUVRoHpsQvENx//m7CCnwkDGITj02SKwfu6iMATsF+91Sr97FP7XmKmgnVpLw==

Test that the subvolume and the filesystem stay writable when an fsverity
enable and its rollback hit the qgroup limit, and that the subvolume is
still reachable after a remount with no verity or orphan items left behind.

This exercises a bug fixed by kernel commit 76bf149cd029 ("btrfs: handle
lack of space when cleaning up verity items").

Assisted-by: LLM
Signed-off-by: Daniel Linjama <daniel@dev.linjama.com>
---
Changes since v2:
- The fix is in mainline as 76bf149cd029, fill it in.

Changes since v1:
- Use _require_qgroup_rescan(); the _qgroup_rescan helper already waits
  with -w.
- Fill the qgroup with a single xfs_io write instead of a loop of dd
  calls, xfs_io instead of dd elsewhere too.
- Both suggested by Qu Wenruo.
- Look for leftover items of the target inode only, like btrfs/058 does.

v2: https://lore.kernel.org/fstests/20260916062356.690137-1-daniel@dev.linjama.com/
v1: https://lore.kernel.org/fstests/20260915053815.307674-1-daniel@dev.linjama.com/

 tests/btrfs/354     | 126 ++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/354.out |   2 +
 2 files changed, 128 insertions(+)
 create mode 100755 tests/btrfs/354
 create mode 100644 tests/btrfs/354.out

diff --git a/tests/btrfs/354 b/tests/btrfs/354
new file mode 100755
index 0000000..170bd9b
--- /dev/null
+++ b/tests/btrfs/354
@@ -0,0 +1,126 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Daniel Linjama.  All Rights Reserved.
+#
+# FS QA Test 354
+#
+# Test that a failed fsverity enable in a subvolume whose qgroup is at its
+# limit leaves the filesystem usable.
+#
+. ./common/preamble
+_begin_fstest auto quick qgroup limit verity
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
+_require_qgroup_rescan
+_require_no_compress
+_require_scratch_size $((2 * 1024 * 1024))
+_disable_fsverity_signatures
+
+_fixed_by_kernel_commit 76bf149cd029 \
+	"btrfs: handle lack of space when cleaning up verity items"
+
+subv=$SCRATCH_MNT/sub
+target=$subv/target
+
+prepare()
+{
+	_scratch_mkfs_verity &>> $seqres.full
+	_scratch_mount
+	_btrfs quota enable $SCRATCH_MNT
+	_qgroup_rescan $SCRATCH_MNT >> $seqres.full 2>&1
+	_btrfs subvolume create $subv
+	subvolid=$(_btrfs_get_subvolid $SCRATCH_MNT sub)
+	_btrfs qgroup limit 200M 0/$subvolid $SCRATCH_MNT
+}
+
+create_target()
+{
+	$XFS_IO_PROG -f -c "pwrite -q -b 1m 0 128m" $target
+	ino=$(stat -c %i $target)
+	sync
+}
+
+fill_qgroup()
+{
+	# Writes until the qgroup limit is hit.
+	$XFS_IO_PROG -f -c "pwrite -q -b 64k 0 256m" $subv/filler &>/dev/null
+	sync
+	$BTRFS_UTIL_PROG qgroup show -re $SCRATCH_MNT >> $seqres.full 2>&1
+}
+
+enable_fsverity()
+{
+	if _fsv_enable $target >> $seqres.full 2>&1; then
+		_notrun "could not exhaust the qgroup limit, verity enable succeeded"
+	fi
+}
+
+check_rollback()
+{
+	touch $SCRATCH_MNT/canary 2>> $seqres.full || \
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
+	ls $subv >/dev/null 2>> $seqres.full || \
+		echo "cannot read the subvolume after the failed verity enable"
+	$XFS_IO_PROG -c "pread -q 0 1m" $target >> $seqres.full 2>&1 || \
+		echo "cannot read the target file after the failed verity enable"
+	_scratch_unmount
+}
+
+check_leftover_items()
+{
+	local dump=$($BTRFS_UTIL_PROG inspect-internal dump-tree -t $subvolid $SCRATCH_DEV)
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
+check_subvol_mount()
+{
+	_try_scratch_mount -o subvol=sub >> $seqres.full 2>&1 || \
+		_fail "cannot mount the quota limited subvolume on its own"
+}
+
+prepare
+create_target
+fill_qgroup
+enable_fsverity
+check_rollback
+check_remount
+check_leftover_items
+check_subvol_mount
+
+echo "Silence is golden"
+
+# success, all done
+status=0
+exit
diff --git a/tests/btrfs/354.out b/tests/btrfs/354.out
new file mode 100644
index 0000000..8bc7ecf
--- /dev/null
+++ b/tests/btrfs/354.out
@@ -0,0 +1,2 @@
+QA output created by 354
+Silence is golden
-- 
2.55.0

