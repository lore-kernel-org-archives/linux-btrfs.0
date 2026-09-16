Received: from outbound.st.icloud.com (st-2001e-snip4-11.eps.apple.com [57.103.76.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B213E835E
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 06:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.76.93
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789539875; cv=none; b=Q+orxs5urVuovclxirv72kRu+nQ3rDTmT+Gs0CUBt98KOOseCNUjSJ6wUT/iyA/KF7ngDm60Fi+7VEn4uIXi3Thmd8p/QcleiutOwWusc23kdszLivxBc9xTQpVYUPs0onn3E+4bBEbDVBvv4Xe/13MqINkI+H6sDedFcgop+uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789539875; c=relaxed/simple;
	bh=50w7k9vTC+rZxLwN4sYnDWn5AwaIfa7Ew5O32cZnIrY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=m3tE6UKlUoDh1bprBoqwr5ZmsnpMIjdbCFJCnbtt83qoxoxfYyXxkU4C/6huHrn1XD4C/CHCn6fVFYF5CbxviwkXJXuHyz7I6tpJFbtbEEl26Ay5YBxCsE0zt9lN5RLUb+YxUjT+zVCXbnIGocBaZUJiHMbBQ0HhzA1o291H0PY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dev.linjama.com; spf=pass smtp.mailfrom=dev.linjama.com; dkim=pass (2048-bit key) header.d=dev.linjama.com header.i=@dev.linjama.com header.b=oC7AeV3u; arc=none smtp.client-ip=57.103.76.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dev.linjama.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dev.linjama.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dev.linjama.com header.i=@dev.linjama.com header.b="oC7AeV3u"
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-3 (Postfix) with ESMTPS id ABCEA18000B4;
	Wed, 16 Sep 2026 06:24:29 +0000 (UTC)
X-ICL-RepId: 01a0a8e3-6381-7845-adda-3ad6918bf0ed
X-ICL-Out-Info: HUtFAUMHWwJACUgATUQeDx5WFlZNRAJCTQ9KHVwHXRxCD1YCXQNLVxQEHFIDXg5eMF0dRUNbAlwaWBVSQ1QEX1BfHA4JUh0cHFAWWQxaChwTVhUTH1RWBlBRHV8CCgRHBFsXRgNTRUEEFxFQAVgeVl5aF15NRx9ATWJJAVoZWxxAF0puTVMPDxRcDh0BXgVYEVQZHQ5YBhIdUBwOUQVbAEYJQQJbB10AQwxOHVsOWwNDDlUCQFMKXBlcFHMJUh0cHFAWWQxaChwTVhUNTUMSQhUEG0YeQwRfL10XXgxeBQ==
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dev.linjama.com; s=sig1; t=1789539872; x=1792131872; bh=u9L5XLWeJ23eECGRSif6qCR3XyUZMq++D0uJ5TSttLw=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=oC7AeV3uRLObdHjMwMHmzF2/T2oWFWw0+Yeb0/ZxenVQHIDq559cgqHGG82StipbGInOu2pWBnDxNIteWY4oj6K0HqeSXeiWVdkOKuXBtHp4ZSLi5F4MOotf7HJFQR2P6olZgNt2igjEdnTOLAcKaT4hrmJtCgEfXOP+/2U92cRdS0pbLHJytBE8nosgzm0Is72BdxUwOP1jQT65qZXUMgDL8qFSNtsDSqrCK75lETDMrSiCy3Z6tcQdopqsQNHrqTbzZ24cDVvX5+tWv7dHkC9LTfDQUo8OuLS4jWENChIxGMTiKkm2DAulTEYQVtgwHehmgWUY955beJVAxeE9Sg==
mail-alias-created-date: 1690913137769
Received: from dev.linjama.com (unknown [17.156.216.30])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-3 (Postfix) with ESMTPSA id F34B2180011F;
	Wed, 16 Sep 2026 06:24:27 +0000 (UTC)
From: Daniel Linjama <daniel@dev.linjama.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	Qu Wenruo <wqu@suse.com>,
	Daniel Linjama <daniel@dev.linjama.com>
Subject: [PATCH v2 1/2] btrfs: test qgroup limit handling on fsverity rollback
Date: Wed, 16 Sep 2026 09:23:55 +0300
Message-ID: <20260916062356.690137-1-daniel@dev.linjama.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDA4MCBTYWx0ZWRfX2jjoiSef0RNP
 rwVTjWSwxNPN8DrdTa/6gA6W5HhhYmDaCRDTo4PBr7p7BUPfGyGjTunT+fxtHlZt3arrSMMkgPb
 jXoAFP7CNI2LGKTG6awlm2gRRQlSa4f9WXxEHOBG4IQFmmmJNDY9maa7Q/UAgLVlHjNBT6HtRjK
 WehwVfLOFXM0LM7LqG4cXbzSS7JThliI5YmLvXdmq7SufbO/MQ61/w9hQ5++2IWV7Xc6eFcvXMS
 ACOHwYm4I8rNMUmDd2LedHvM1rnLMxzv8M+5w9QhSFOWsxZdmGFmPCDldISk6F27h/ZyXtlJ6bx
 nFOwFgWt8Q+AqAjBqx+ZlekFTReiDWYaH+c30Mlw1f0KfqIfX4OW8+DZH+wXvs=
X-Proofpoint-ORIG-GUID: u1rromSS3aJnB-ULx-aBqxLIBTsdHl2k
X-Authority-Info-Out: v=2.4 cv=MOBtWcZl c=1 sm=1 tr=0 ts=6aaa361e
 cx=c_apl:c_pps:t_out a=oyWFxbOnq+dmhQrAPgaJYA==:117
 a=oyWFxbOnq+dmhQrAPgaJYA==:17 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=olXNNK5aAAAA:8 a=WwdHHYCB-LfYqlj0cEEA:9
 a=U4UmX7kblY_o6ZOM_jyP:22
X-Proofpoint-GUID: u1rromSS3aJnB-ULx-aBqxLIBTsdHl2k
X-JNJ: AAAAAAABNLlPGJJIo1cRtCOXtbGgIolhKWwCXXN2L6MFbiQPXK1QzsOHUBfzFoYMKEljLHRkUKgovakJ6Q/labrYSUca6HwXg/FPOjNhKIRSqv/5hw/x0+nYAdk1AUR3M8cDxmacl323rIkvnxL5Gf5dpOqlZmynBpppjbkuW1rwyk0XHI1cFUvDGIeHAXhMfxrhEC7YComHAZMkzzeMsHBAUHzyiYrBVT5+rDy8/jragaddSs/j26cW9//XUCt/4h6KJpPQHqu0ljYkb2A2QlVaCV5yX6Curhh7asybe41AWWk2m8f9AWsv89heulkGcVj09junP0wsQboH+QUmtR2sx0Z/N085NaCpCEpGgSxptdw1IjL/Xz/Ei9AMsflsXsYG2czxUk0acgAq96cMPb+JXK+0VYu4CGMxsux7agxE9rRsoe3df9yKENy/rlaxZHduN0PeboA/KDLWuQneQn/vgF5wCXDYRHXhDCE/OaulnprkvDQZkfJptDpZWxoIYml7YZNGW76Gz+kXc9cTgC6uvvleHEOa2WTO8jAUIB9A5l5kRTcbJm8XiXuBq5o2/4KSLtT6/jpMihsg6gbMG4imtApGwiqmVYWZw3qDJSU2HSlk/roUAlkRcMnILsndcimD76qeE3X4nTlTVKPSimRlONwchc/FzQyuM9Kt8s7/QL5lVWOJ187BnnyhYkKnDUOr10ssVQn5Bjyszz0m9lCIwqydIaz5zw0uHyRs+GFbXD4xBSVLrRhKh5WMAuC0v3BUWZGzaQw1aHHlbDzLU38Io6xgA/8Eu4g0jPNKrIKfwu6Ge6VOv31WJ15DVDCENb5GATPwPIo91/sYQQYstjBJbAsY2m6UHVHeP2MNI+ZPMwloWjgEATjt5vpYFJCoCCola8xobKWvHkaqAFAv63plQJJmrVqdKrrA530y/ohBWqzGw4+3LVZSp7TKgyKUh+hYgF3oqhm910Yqs+wUzaAU8yKRAya
 I8ikCxdk+81ZKpXLxJ8xTs6wc0spXht8NX95ySI/xQwEyho/H05BrHyXmsp8lt9HyxmMH4n9Nc+joPFrnk0ASpcPzNYII8Dw2CAhLbPoWBdXsry3ui6d2ap8WuHVIDCCH/JY5v9aQ2azde7mJiP3QtU9tqEYpX+XWcqxTSh2H/fFawxDrRYfXigmNUHx0wOnGJ2D/LmlpH92D09sZ9KGrVB+s87vsfv6ECu6LX0VtfD+ZV+Pc

Test that the subvolume and the filesystem stay writable when an fsverity
enable and its rollback hit the qgroup limit, and that the subvolume is
still reachable after a remount with no verity or orphan items left behind.

This exercises a bug fixed by the kernel patch with subject:
"btrfs: handle lack of space when cleaning up verity items"

Assisted-by: LLM
Signed-off-by: Daniel Linjama <daniel@dev.linjama.com>
---
Changes since v1:
- Use _require_qgroup_rescan(); the _qgroup_rescan helper already waits
  with -w.
- Fill the qgroup with a single xfs_io write instead of a loop of dd
  calls, xfs_io instead of dd elsewhere too.
- Both suggested by Qu Wenruo.
- Look for leftover items of the target inode only, like btrfs/058 does.

v1: https://lore.kernel.org/fstests/20260915053815.307674-1-daniel@dev.linjama.com/

 tests/btrfs/354     | 126 ++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/354.out |   2 +
 2 files changed, 128 insertions(+)
 create mode 100755 tests/btrfs/354
 create mode 100644 tests/btrfs/354.out

diff --git a/tests/btrfs/354 b/tests/btrfs/354
new file mode 100755
index 0000000..0ae6e7f
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

