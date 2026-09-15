Received: from outbound.st.icloud.com (st-2006k-snip4-11.eps.apple.com [57.103.76.241])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B23378D9A
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Sep 2026 05:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.76.241
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789450748; cv=none; b=HNxOXaTo+0RNuRbQqsWweAYXc+Iv1v52+2PgekyEFNDUUGs2Gv4fjlcbmCzY5YDeox39TwAnRk4MQ7fmiTOyiiYsGyg6RChOKMb8EXkP35QHizNlpKZRpwVIJGREeMQjwtrntX25cc0xCwKFP9aXgeiSLueSJvhCOeYjwBfnjlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789450748; c=relaxed/simple;
	bh=Hs8Ywqm0XKnmxx/kGivdMNflllxmuiFlMBlkTpOK4lQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aCPXhoQLlNkBxg1tjQ7Z3bpyiH9sDKwF22TPlZyjX3ksKJy3wOMJws9v7J9PXH79BzNY7XZTuIjBjJxPq2pcFlCi3hq0oEO8vuf8ndHEBLpcX5JoPewX4FiaGMRzpvthWmPikCDqlIdRbdCKJ2zsJDQb9Fo9JHo9KMg/N2lcDFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dev.linjama.com; spf=pass smtp.mailfrom=dev.linjama.com; dkim=pass (2048-bit key) header.d=dev.linjama.com header.i=@dev.linjama.com header.b=aPVdAGV2; arc=none smtp.client-ip=57.103.76.241
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dev.linjama.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dev.linjama.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dev.linjama.com header.i=@dev.linjama.com header.b="aPVdAGV2"
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-6 (Postfix) with ESMTPS id CCA9018002FB;
	Tue, 15 Sep 2026 05:39:03 +0000 (UTC)
X-ICL-RepId: 01a0a393-6fb8-7463-8f3c-ea1a811fac5f
X-ICL-Out-Info: HUtFAUMHWwJACUgBTUQeDx5WFlZNRAJCTQ9KHVwHXRxBDFYCXQ5LVxQEHFIDXg5eMF0dRUNbAlwaWBVSQ1QEX1BfHA4JUh0cHFAWWQxaChwTVhUTH1RWBlBRHV8CCgRHBFsXRgNTRUEEFxFQAVgeVl5aF15NRx9ATWJJAVoZWxxAF0puTVMPDxRcDh0BXgVYEVQZHQ5YBhIdUBwOUQVbAEYJQQJYB14BSAhNHV4HXARHDVUBQFMKXBlcFHMJUh0cHFAWWQxaChwTVhUNTUMSQhUEG0YeQwRfL10XXgxeBQ==
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dev.linjama.com; s=sig1; t=1789450746; x=1792042746; bh=uIqC4CKLNx0Iri/NXM/v8s84tulXTsKDMkwb9j7cSXg=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=aPVdAGV2X+byhdLvs3EW7YN0wrFap643jPhzaC6IcUeKxkxC0qWk4jUNvOdo9tiTvXaMXkqBn4+mxBTzzIXwTNYXWiEzNbRz1hF0Yf6cm/XI0TjdWQNVQV8iteNAtC//cyEIzT4fQ/J6zvlNDVuiczFmFWn65YK2+nSqcHXQoAHvo/urNUkldyUgpZAzsH1Ea55y5gisKJYOPq2dMCkTKlAntUZujg3o7xd3fxfPu4azNxjdaRHt9Ganldq++OWWCxvJuytR0C+jMQzcMQjxrHZniZ3mpGbyZxVMd8dcspRGlaRb4ixi1npvjnN1+T7pwancrgopmSCb/6YUZuqU7g==
mail-alias-created-date: 1690913137769
Received: from dev.linjama.com (unknown [17.156.216.30])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-6 (Postfix) with ESMTPSA id 51E6E18002D9;
	Tue, 15 Sep 2026 05:39:02 +0000 (UTC)
From: Daniel Linjama <daniel@dev.linjama.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	Qu Wenruo <wqu@suse.com>,
	Daniel Linjama <daniel@dev.linjama.com>
Subject: [PATCH 2/2] btrfs: test ENOSPC handling on fsverity rollback
Date: Tue, 15 Sep 2026 08:38:15 +0300
Message-ID: <20260915053815.307674-2-daniel@dev.linjama.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260915053815.307674-1-daniel@dev.linjama.com>
References: <20260915053815.307674-1-daniel@dev.linjama.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Info-Out: v=2.4 cv=J7GnLQnS c=1 sm=1 tr=0 ts=6aa8d9f8
 cx=c_apl:c_pps:t_out a=oyWFxbOnq+dmhQrAPgaJYA==:117
 a=oyWFxbOnq+dmhQrAPgaJYA==:17 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=olXNNK5aAAAA:8 a=iLia4Pd5vxHsIscpiQMA:9 a=U4UmX7kblY_o6ZOM_jyP:22
X-Proofpoint-GUID: xEJSUdMremfw-gj_o0ChGKkpoL6T5yJx
X-Proofpoint-ORIG-GUID: xEJSUdMremfw-gj_o0ChGKkpoL6T5yJx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDA3OCBTYWx0ZWRfX/fhwghkAa9kx
 561WqflUIisygZ1KDq4xn9LmfVFINcYE3vRRYmxQkMabUw+vRcgfvysmQQGYddefmA634+WXEf2
 XpVbInviUz0qs2nGoIixxrB2A956GuObTXULbsd18bt+h+qmMSaNOj6k8X+2iDZJl61LqDbA8iV
 yd+W4Q6QAfBzeyrGjeYB6EaRP1YH4xOd9EZK/e8dBxbhtfVsGmSk3uXOtiJ9vegGes5TG8sTd9k
 BI8gzt5NxtKj4gfLotY80dVAxUynQXVE9bgA5+cFUbNgSOD5EtLm8k4hr/M87l9L0ZDOUaXGbty
 N9VObYTTScJnOsGBzNM4I1R3IaS1SqKE2sp7alX3aqFvDWo36lak1vOa8+Fy4g=
X-JNJ: AAAAAAABPmfoBAGXiadAe9r6WIASTmiEUhNrGFzegOO0B/KILy24j4/m5gew8HDy9EAZcSejpWQ7ey6cuEGDmPY8ojkU4tm5Zl5czLyJY22rmzhLkseT6quYOlsNuZRWGhl0M0L8DQ9pyYmxq8T9qBJF5AS2IFFkJ6jEWrYqPxgaBLXmD2Js6uA8s1swwXlCAom/GQUQrFB9P97PYTZRsshPftqegoieMvlvpaXlvuJtws7efkvXkx+M9GBM7wrWRkuV+v2NJSw09dZFh3rIlD6aydK/vGMp1reM8jaQxEu11ruNUmOpnfFkytkWyydfTNE45U+UHKMDKa4Zr6mv4pkLZjFWj1rqyC9QpyQHyGTA68m4DDvS4GUG/wCsnkBYpyf5NB0KEN0liRWKJbauK6uQS5S/aF43VAa7CTP1rfC6KXWpvdRWP0mTRwHTAlvBL0d5SpOGB/8wfYNXNQaQmmdDLSn6nE5XHHkj5jkCFH2c3Bxb7JbI+Ww7QsDw+Us8HMnQbiPDMX3jdQYm/7n4/+Ce+qA2AZgIrqUwRzcskBNXhvyUUpbv6XawQq2UrBNmeEwQ2VD/3p2kAj84/0Bs38FKhfiW4omKcRCUhwAnlZFGJURPfJDKa+sZ9hTaOmANmxdBke4tmhc7lFsqFA43w+zmnhSNXmHyiQUoxuKesVbo8HrzQkhQRVVRE3A2zUw3y3LraA==

Test that the filesystem stays writable when an fsverity enable and its
rollback run out of space on a small mixed block group filesystem, and
that it still mounts afterwards with no verity or orphan items left behind.

The -ENOSPC counterpart of btrfs/354.

This exercises a bug fixed by the kernel patch with subject:
"btrfs: handle lack of space when cleaning up verity items"

Assisted-by: LLM
Signed-off-by: Daniel Linjama <daniel@dev.linjama.com>
---
 tests/btrfs/355     | 119 ++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/355.out |   2 +
 2 files changed, 121 insertions(+)
 create mode 100755 tests/btrfs/355
 create mode 100644 tests/btrfs/355.out

diff --git a/tests/btrfs/355 b/tests/btrfs/355
new file mode 100755
index 0000000..5f13c5b
--- /dev/null
+++ b/tests/btrfs/355
@@ -0,0 +1,119 @@
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
+_require_xfs_io_command "falloc"
+_require_no_compress
+_require_scratch_size $((1024 * 1024))
+_disable_fsverity_signatures
+
+_fixed_by_kernel_commit xxxxxxxxxxxx \
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
+	$XFS_IO_PROG -f -c "pwrite -S 0 -b 1m 0 512m" $target >> $seqres.full 2>&1
+	sync
+}
+
+fill_fs()
+{
+	local i=0
+
+	while $XFS_IO_PROG -f -c "falloc 0 2m" $SCRATCH_MNT/filler.$i &>/dev/null; do
+		i=$((i + 1))
+		[ $i -gt 1000 ] && break
+	done
+	echo "fillers written: $i" >> $seqres.full
+	# Room for the enable to start, not to finish.
+	rm -f $SCRATCH_MNT/filler.$((i - 1))
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
+	rm -f $SCRATCH_MNT/filler.0 2>> $seqres.full || \
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
+	dd if=$target of=/dev/null bs=1M count=1 status=none 2>> $seqres.full || \
+		echo "cannot read the target file after the failed verity enable"
+	_scratch_unmount
+}
+
+check_leftover_items()
+{
+	local dump=$($BTRFS_UTIL_PROG inspect-internal dump-tree -t 5 $SCRATCH_DEV)
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

