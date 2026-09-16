Received: from outbound.st.icloud.com (st-2001g-snip4-11.eps.apple.com [57.103.76.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30013D7D67
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 06:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.76.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789539880; cv=none; b=YtxM8I3RzrRwujiqA2nwQpaQdn8XQexZQs1AHlSrVrAreII7OIRQOPPrb3jCce92yzZwXl4bSbulJPx3R+GRtF6pShtBzWRyfHmxCzZUrW+p9/vaDs52BMbBBFJVNA6nOPIgqMLBlilDc6K1aKqCwGi2UGYiNrbESOfXfBQU1cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789539880; c=relaxed/simple;
	bh=eDIE/neV7ymS8hragaG6Lgw939qkX3EV83bQMcBlU7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rXqYp3nDckUl1ZeI012RqFNKD3bFjuy1fGdgIevXJ1fMr6Y5ZLk4c/ScEvuYMU4UVsmpUEPULQwOzX3v0Aqhdr5UJScgBjN5GxSXcheyx6EkTq40TgJT+Bm1IZFhoejv3ksvXVtmrXqYOOMwNttAWtw+fa3WxDQ+8g7UgpSkExI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dev.linjama.com; spf=pass smtp.mailfrom=dev.linjama.com; dkim=pass (2048-bit key) header.d=dev.linjama.com header.i=@dev.linjama.com header.b=Q24K5Ja5; arc=none smtp.client-ip=57.103.76.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dev.linjama.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dev.linjama.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dev.linjama.com header.i=@dev.linjama.com header.b="Q24K5Ja5"
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-3 (Postfix) with ESMTPS id 73A4A180012E;
	Wed, 16 Sep 2026 06:24:36 +0000 (UTC)
X-ICL-RepId: 01a0a8e3-7e2f-77d8-9d9b-2936f51e6c1a
X-ICL-Out-Info: HUtFAUMHWwJACUgATUQeDx5WFlZNRAJCTQ9KHVwHXRxCD1YCXQNLVxQEHFIDXg5eMF0dRUNbAlwaWBVSQ1QEX1BfHA4JUh0cHFAWWQxaChwTVhUTH1RWBlBRHV8CCgRHBFsXRgNTRUEEFxFQAVgeVl5aF15NRx9ATWJJAVoZWxxAF0puTVMPDxRcDh0BXgVYEVQZHQ5YBhIdUBwOUQVbAEYJQQJbB10AQwxOHVsOWwNDDlUBQFMKXBlcFHMJUh0cHFAWWQxaChwTVhUNTUMSQhUEG0YeQwRfL10XXgxeBQ==
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dev.linjama.com; s=sig1; t=1789539877; x=1792131877; bh=EFQG/aHFhZpGo21RPwtmcmmeL8gCzdb2u0VJLbGKqYk=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=Q24K5Ja5Sb4GK4KxT9mWi/ygjfXLnpvdxf5NcAxgNMTkHQGh60EFioWkyXohNlGUCtEHj2W4KnluMsHsuWYi0IXcO2bfIG3drOhT+ZirmikPhsX7l1lODFXIYlXq2KB+Lajz1YQJrT1Sv2a39xzFxvyIIkhRnQk5aax1joCnsl5t14O4IJ7pCyehGjm17fAfCjVRSiqlPkSdLFkkhHih3KfXOOCL4/cIQ6AqOSEznhfSWhBLaQdkWGW35RgL+LDxt8+GujY8Hx1itBt5t6sFu9JA2yXMP0v6qul2jf2ZKQak2NAmS22sEVA2mubmclv47x4tb0R2/LRcHVQ3q5qCJA==
mail-alias-created-date: 1690913137769
Received: from dev.linjama.com (unknown [17.156.216.30])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-3 (Postfix) with ESMTPSA id 2C9EA1800124;
	Wed, 16 Sep 2026 06:24:35 +0000 (UTC)
From: Daniel Linjama <daniel@dev.linjama.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	Qu Wenruo <wqu@suse.com>,
	Daniel Linjama <daniel@dev.linjama.com>
Subject: [PATCH v2 2/2] btrfs: test ENOSPC handling on fsverity rollback
Date: Wed, 16 Sep 2026 09:23:56 +0300
Message-ID: <20260916062356.690137-2-daniel@dev.linjama.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916062356.690137-1-daniel@dev.linjama.com>
References: <20260916062356.690137-1-daniel@dev.linjama.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Info-Out: v=2.4 cv=Sfj6t/Ru c=1 sm=1 tr=0 ts=6aaa3624
 cx=c_apl:c_pps:t_out a=oyWFxbOnq+dmhQrAPgaJYA==:117
 a=oyWFxbOnq+dmhQrAPgaJYA==:17 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=olXNNK5aAAAA:8 a=iLia4Pd5vxHsIscpiQMA:9 a=U4UmX7kblY_o6ZOM_jyP:22
X-Proofpoint-ORIG-GUID: fGoKEVQWM6uoR-H5SsMVx0HiG3dIMAn5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDA4MCBTYWx0ZWRfX0cLWA0NJWN8o
 w7KxjZGoCXMQePLO64dhu4WQkJZcDGcqBMIGXPKp5Chr1BeaqfxU4/DeSBefnDNUQ7363jxulWZ
 CNSk8tbg1G8r7eSoKBKVTSUq4GtPXG/ZLPlZMw/s+GIg4ERQgoqNwIYy1Qqb0reEhKS3ab9ThKA
 YymtkhQKdYcKSBe+0rTB6Vm2CN8xeFIqnz/PWxVheFq+LSY2yT6t6tgtIzJ+JE/Bh7FzHe1Eglc
 1UoPIWLycB1cA7h2AIL8ECvo7iy5eNSaxTF1JH67b5baRjvnfgTHMPf+NCLA1J2xdo+U958Fxxa
 BnhovAovtuR4UdItRIm+gdjuTxV/w/au8vB/ZCOtJWzTlJGwih51/N1MpShEM4=
X-Proofpoint-GUID: fGoKEVQWM6uoR-H5SsMVx0HiG3dIMAn5
X-JNJ: AAAAAAABEjUMPupGEqha/8bbLZKTcLXR4FKSWo0/PautoV+ds3XkqQnsfrpUhMkpYcaPOgyH7mw8bWq9nkLFvPDMNPWdWWvdLsQsGf1Gn2fues6aSTBWxPjCFMfqgBk4srYeT6c5fB17w77vzQT+Hr5eIsm8Kw55dK/kj028dyN0AUnPQcTrdKQTHL252qDi3UZj/UlsZzZ9VYlrxo6XWqH4ZV6rgCdgPKGQilcQoUJzp6PpWwJOafbpk/TzXRsuRcmwU91hZsjGdqXpM+LOVarQRnrP+iRmhtzd2h15/dPIy+XMItMitYXKGCA4qz2GbXDIUPPkPbk1NriT6pWWthj6NEGBgBrCDANewEzgNPjsJFD12W2Wz250jJaY1lMUjYjuQszgY4EQVwS0MHdVknE4jjAeHGfrMp8qOMsp/4Ow5AMGY7UdtDEaIlfVUFwlCEoNlFBnpN/Jl5HW5+RAAjPqXj19OpSbbP75OtC8xbsAUxaHVvthVR3fu2h81Qkvv8+0gdf98Vq9urHipdSTbhsB79nnEcGxUOaETH5lPEx71LAIORnq0ETc7i1IMsQu733AUdOyJk7CsZ8I30HFLOKkwui7FyU9gb68XeGTuidK9zKTkr2FvTdfSRMgm2zViobTbsQiMTfXTqnPSs5GWfhEGVbN8YETwbcBJ8L5QFgLbISmzaJ4r4b6WW1+TTuyZTLuwR+KxlrlLA9hwQnFgVAk8rBT7cJMqDvZYo00

Test that the filesystem stays writable when an fsverity enable and its
rollback run out of space on a small mixed block group filesystem, and
that it still mounts afterwards with no verity or orphan items left behind.

The -ENOSPC counterpart of btrfs/354.

This exercises a bug fixed by the kernel patch with subject:
"btrfs: handle lack of space when cleaning up verity items"

Assisted-by: LLM
Signed-off-by: Daniel Linjama <daniel@dev.linjama.com>
---
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
index 0000000..8127d25
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

