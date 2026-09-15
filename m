Received: from outbound.st.icloud.com (st-2001h-snip4-8.eps.apple.com [57.103.76.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C7E4378D9A
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Sep 2026 05:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.76.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789450745; cv=none; b=JLdcSp2aq1/F5SVQUF97tL++Hwoh4zNjn1Od915ViSgIYT34+jqgRZPVK9pVK8WndAo2FTdXEPMEmywdtbQAhENxXdsmcI35FQcEEeyQ/KsYkSpDj8akTAGzzYTcAjrz/MhgrJ57RTpULM5/yWBd3JiARwMcnNg4K+gExwtKnFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789450745; c=relaxed/simple;
	bh=T93e7Q9pSKCBffUQL7PNlbprcBG6IpqWeoYdu4IIFbg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HRLx9/yNWj57DZ621QbahsBdMyXKRFjzyuLUCXqBXW17yfuW6LMHI1ufl6klYTcpPsPNinw+Z5WU6cNAjE/BN6MpXSBUWT2jzyhBBK5fbR6UYpsls/xy0Gm2ssdB5OaenOYjeK7E2YFrqc+Xt2Qwl6IHSTc/KIWh7z2cnDl32MI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dev.linjama.com; spf=pass smtp.mailfrom=dev.linjama.com; dkim=pass (2048-bit key) header.d=dev.linjama.com header.i=@dev.linjama.com header.b=DPYxwnAB; arc=none smtp.client-ip=57.103.76.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dev.linjama.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dev.linjama.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dev.linjama.com header.i=@dev.linjama.com header.b="DPYxwnAB"
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-6 (Postfix) with ESMTPS id 3071F1800100;
	Tue, 15 Sep 2026 05:38:59 +0000 (UTC)
X-ICL-RepId: 01a0a393-6172-76ea-8f66-b49b1336842f
X-ICL-Out-Info: HUtFAUMHWwJACUgATUQeDx5WFlZNRAJCTQ9KHVwHXRxBDFYCXQ5LVxQEHFIDXg5eMF0dRUNbAlwaWBVSQ1QEX1BfHA4JUh0cHFAWWQxaChwTVhUTH1RWBlBRHV8CCgRHBFsXRgNTRUEEFxFQAVgeVl5aF15NRx9ATWJJAVoZWxxAF0puTVMPDxRcDh0BXgVYEVQZHQ5YBhIdUBwOUQVbAEYJQQJYB14BSAhNHV4HXARHDVUCQFMKXBlcFHMJUh0cHFAWWQxaChwTVhUNTUMSQhUEG0YeQwRfL10XXgxeBQ==
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dev.linjama.com; s=sig1; t=1789450742; x=1792042742; bh=Q/zaM3n8/0PJzKzEoqBAI19iLIJje8t3qnt+d4zeWDg=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=DPYxwnABDRkdBgrGstGQLtyUUa2vZT2NxUXRm3M7wcIKBtuQb5RU1CXhR7yLx2/UKDlN+yZ5Zth2NeSO0UMlFcAZ0rQAI7GQSvKTzRqlngBKX67aplnBtgVF7R2Mj90xoWbz7JsF0mDrGOyc+HT7KUm8DaE3SZP/xLf0dRthyEowUV2ZOBvls/o0tkMOiN6rsZvkZQCSQcpvQsGMPFrNKltt90kND0oCfnC3wiDEiF61jwZCKDs7w86bkJMeooXi+AhziuXOaEXsHmJHv9SSU/+WLaEKAqwwJNGCzfMyLfoyr92ZQ0uJ+QaiZb/aCjCLQ50q14cRlhpbgFk+lBZV/A==
mail-alias-created-date: 1690913137769
Received: from dev.linjama.com (unknown [17.156.216.30])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-6 (Postfix) with ESMTPSA id 9E4AC18002CE;
	Tue, 15 Sep 2026 05:38:58 +0000 (UTC)
From: Daniel Linjama <daniel@dev.linjama.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	Qu Wenruo <wqu@suse.com>,
	Daniel Linjama <daniel@dev.linjama.com>
Subject: [PATCH 1/2] btrfs: test qgroup limit handling on fsverity rollback
Date: Tue, 15 Sep 2026 08:38:14 +0300
Message-ID: <20260915053815.307674-1-daniel@dev.linjama.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDA3OCBTYWx0ZWRfX/cDcsMWVm+bE
 sbHpbRikW8Oa9xYfBD+3HEBcIFZKSNeYWdrPuw2O3+Gz87kvYFSmZ45aK7Hz/C2VFDvBQqbZkfY
 o7j55SiZYghWbfIe4y4FvOk/adgwi+81wELSFk25maAYzNcad0vd7slJt6j8T1dTJwGWg2YNHDm
 gS554o38yJ8G3r80jUxx+X9qb56q0wTEXDkkjd/C1ycYO5Fp7i+KSp1Y0h1Hds+bpT2JdVt+vO2
 /jkOgAozgCqMUrQIBwBF5gvqhSuuw8YhERBzXmCkZNwvLvWKucERl3RCHmEAjXCL6HZPvUMRWU/
 uVUJGQ6l1cG4pHzEe7HyWRIgjA51lEwos+FlYhql4NqZaqAIFGH0IZ+M3PbTTM=
X-Authority-Info-Out: v=2.4 cv=L+QQguT8 c=1 sm=1 tr=0 ts=6aa8d9f4
 cx=c_apl:c_pps:t_out a=oyWFxbOnq+dmhQrAPgaJYA==:117
 a=oyWFxbOnq+dmhQrAPgaJYA==:17 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=olXNNK5aAAAA:8 a=WwdHHYCB-LfYqlj0cEEA:9 a=U4UmX7kblY_o6ZOM_jyP:22
X-Proofpoint-ORIG-GUID: KWJ-b98lSqxYspevOEGINWgEE0NaLNFs
X-Proofpoint-GUID: KWJ-b98lSqxYspevOEGINWgEE0NaLNFs
X-JNJ: AAAAAAABYQZGG1HBfw0dy6I7qj3M0d8MKWrBfDjNj7T8AyMnMnFlanW3hOJbbqdKtJcWoMDu79zfe0NTAo099M65dZCZF2y0oAz3+rLJKfGk2Cw1LV8Blp+Q9yIRlvdslxyvwTjWt72qZGrkd9M2tiZDUgAuadBSkrzLz1TURotZOYe1ofbGbdxGqHTrO6Qkaz7tahyNRwG7w01FJv52RSqSWbdHMCZiXEl7X2VHzHQKa0QagI9Nq1yzcmbz7dFYgdGNl466B3AgpB5DJmIE/TE+C5l69/ZXOsVtW7MZYGvNSBIB7hTYLxzDiZQWhNp+fzurBIh2jny1Jb7Nm4yBymEyDoWwBNiMaYGXicdIznMqzDVV4/or91402xJjCBv0poM/FIL0pSPBfVOsfxo3ZpcmJdiFhU/PMSn5cmvZopYuHwcjBgAFQLE6EdzVqzd1q1Crg/5x/Ab9UdVWeGCN4qsz/hPoRdXlP/4IF/U+TqZQacETSu/Kiz+l+4rFcOgFgfLWXDzoXArYsjb1f7HpB/4Igo+/vpB9Ip1CWJg81qfVQ1Xfrj2WUY/wUDNixDR+igMH0vLr7YgNjQMyxZVyIEuNl+Y3ej+eU+Jc0qvMXxCrDVgvPfBmV/1YWj0XcvC9Yr5eKk39dFDCQBzEzTamrReiqVAXakTDI/VPyIX/Wxc63SYGSC87I1d0C5g7wcGt46v218kfPuSg2w9yzc5LAJ5xTdFC8JOGqqE8TNgiVsNDMD3a9RvBrBKbR2kFeLiuKad7eKesCKpwTmACph7+hucKK99ExMB0fJx5e4V6QL9Zd35QiBcjQOjMscjHUJBKobj1atvYOZIp+VMsqBNcxVWPmQACLKdL2ebaXvMyTOgQvU1G8rjRXREEPASjRyDlvDuBglO0xtyGqXopg8CcOc3HE1wgAjz/MiVx5iMJHN7RDEHNTKpNBRkfYNPySUbqqOhaPoO7DEaU0qwmYRyYho+Dgpp5EV7
 qkdy8ZRTWtrOsBBmmw1c605Rxa8siV9cLV2Sy0Fkaq5c44IeoGxtaWv5yxB7JipMRvi3zNOZDNJBs5M91v1OFKrBFaQ606V6TLHeYql5XQELKsp4YFNn8/oTHtbzcfec3paL9GmhuRZgUSMoD8sNhO2f2BWc/Miw+JsvDVm9OREQr2AjC8yhLdoPS6wKtmxMgi+nHPdWXR98SnwqwFzzd0Q==

Test that the subvolume and the filesystem stay writable when an fsverity
enable and its rollback hit the qgroup limit, and that the subvolume is
still reachable after a remount with no verity or orphan items left behind.

This exercises a bug fixed by the kernel patch with subject:
"btrfs: handle lack of space when cleaning up verity items"

Assisted-by: LLM
Signed-off-by: Daniel Linjama <daniel@dev.linjama.com>
---
 tests/btrfs/354     | 131 ++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/354.out |   2 +
 2 files changed, 133 insertions(+)
 create mode 100755 tests/btrfs/354
 create mode 100644 tests/btrfs/354.out

diff --git a/tests/btrfs/354 b/tests/btrfs/354
new file mode 100755
index 0000000..e3f6716
--- /dev/null
+++ b/tests/btrfs/354
@@ -0,0 +1,131 @@
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
+_require_btrfs_command quota
+_require_no_compress
+_require_scratch_size $((2 * 1024 * 1024))
+_disable_fsverity_signatures
+
+_fixed_by_kernel_commit xxxxxxxxxxxx \
+	"btrfs: handle lack of space when cleaning up verity items"
+
+subv=$SCRATCH_MNT/sub
+target=$subv/target
+
+prepare()
+{
+	_scratch_mkfs_verity &>> $seqres.full
+	_scratch_mount
+	$BTRFS_UTIL_PROG quota enable $SCRATCH_MNT >> $seqres.full 2>&1
+	_qgroup_rescan $SCRATCH_MNT >> $seqres.full 2>&1
+	_btrfs subvolume create $subv
+	subvolid=$(_btrfs_get_subvolid $SCRATCH_MNT sub)
+	$BTRFS_UTIL_PROG qgroup limit 200M 0/$subvolid $SCRATCH_MNT >> $seqres.full 2>&1
+}
+
+create_target()
+{
+	dd if=/dev/zero of=$target bs=1M count=128 status=none
+	sync
+}
+
+fill_qgroup()
+{
+	local i=0
+
+	while dd if=/dev/zero of=$subv/filler.$i bs=1M count=4 status=none 2>/dev/null; do
+		sync
+		i=$((i + 1))
+		[ $i -gt 200 ] && break
+	done
+	sync
+	echo "fillers written: $i" >> $seqres.full
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
+	dd if=$target of=/dev/null bs=1M count=1 status=none 2>> $seqres.full || \
+		echo "cannot read the target file after the failed verity enable"
+	_scratch_unmount
+}
+
+check_leftover_items()
+{
+	local dump=$($BTRFS_UTIL_PROG inspect-internal dump-tree -t $subvolid $SCRATCH_DEV)
+	local verity_items=$(echo "$dump" | grep -c 'VERITY_\(DESC\|MERKLE\)_ITEM')
+	local orphans=$(echo "$dump" | grep -c 'ORPHAN_ITEM')
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

