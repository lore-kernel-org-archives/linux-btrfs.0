Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792613851;
	b=pHZjltbT5X1WDiwPRf4qhwDNd997H057gsXLW9Oxu1dMPlhnvrE6xEDMVoopbb2bFlci
	 ApM72OwozkJrQ2J6X3hvrOkxeDaiJ8LspOr3czIpqoLkuLF1hKY2TqknPR1V/YUctF4LJ
	 0XRycjmalouMDydLAmVETNf4RxsTuxq6mLYYa8JW9t7MgFqJoMR3Dgv8dPkMrGNKT/b6P
	 6x7/3+TXuvrkpfzzDiQQdv8Ds1QSfwyV+d3/FfRcFDEQY0FHBz1OB/OgSaTqrwb1qiRP7
	 Ik5QIrAw9QuAEHQMDhcLYKAmdyitwUEO1JJnxoZOHS7Wrrk/JuqW/NFqJa+ir/xsOQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792613851;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zpb1dKklnwN9LyFwkZ3G4CZM/i75l1SEsykH37jekwY=;
	b=sLuaAb+kZjRydS9m44DQQX2VEguPWdePYgdRWg2rKWFn0TgYZQDiKL7GYgHvPxok8PTZ
	 EgGyKPZwVjLQU/FGPIjuF9jJAi/V0ooPmtpCNkqCu4tmW4vt0q7sjfO1Kbh+bv4KsSWS0
	 nps6Ac0r9vpS/RlbbmFo4rK+/rQcgyZES1SNw+2wuWruU8+V9VG03gvVbYg5i8DQco2/F
	 lrKjT/SyV7BNxINm1TBDM1/1wdVGpCFPB9qN+ZEmgfJSUFjUj3sqyAl0LzUXdsTHxJFE4
	 ko8Gm7+AKHKYPnuU4TDNy7CxPY732K4jCjhHMQXKesSVqG7L9hX8m5cgVdcEUc+G8ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YfHFDVO8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 919E6606A319;
	Wed, 21 Oct 2026 20:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YfHFDVO8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 447B71F000C1;
	Wed, 21 Oct 2026 20:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792613851;
	bh=zpb1dKklnwN9LyFwkZ3G4CZM/i75l1SEsykH37jekwY=;
	h=From:To:Cc:Subject:Date;
	b=YfHFDVO8PT+QZYGtbK1U/Yjod4KR+7sCd9NwQ8Y/pWKUgMSTBnd18E7QvLne0gYiB
	 RAF/E3c0p0NeFqVqdzSgKuX8D4Q0uNiWJYGlBHMrqvwH8wOSdTttkz4t7BV0CgAJij
	 EaHDfpaOJFnQgn+duB+ZWl8Qi3ykJXZZch18xD2FqeQOkItbp7ziXEtSpiT8YSvs2u
	 VlImbvbaCeTY4gvdZLZ7WXLOpnE2IPWiV2FMVyTmWQxTglOQ8+/OOWQNlBvZeavP8P
	 toQhGEnClHyBfwvL6hpLjnrGe/xQHi6YSX1RyhQQmKp7d7TQA8wayyT42a+Yu2Bi+z
	 hzHXmDYma4sCw==
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] btrfs: test an incremental send scenario with hole punching
Date: Wed, 21 Oct 2026 21:17:25 +0100
Message-ID: <233845be4bd0fd12b4c62b5ca5243ec1ef4d44f8.1792613768.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

Test an incremental send scenario where we punched a hole into a tail
section of a file extent item that is the last item in a leaf and the
next leaf in the subvolume tree was not changed (remains shared between
the parent and send snapshots).

This currently fails and is fixed by the following kernel patch:

  btrfs: send: fix missing hole punching during incremental send

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/btrfs/362     | 84 +++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/362.out |  7 ++++
 2 files changed, 91 insertions(+)
 create mode 100755 tests/btrfs/362
 create mode 100644 tests/btrfs/362.out

diff --git a/tests/btrfs/362 b/tests/btrfs/362
new file mode 100755
index 00000000..aca56540
--- /dev/null
+++ b/tests/btrfs/362
@@ -0,0 +1,84 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
+#
+# FS QA Test 362
+#
+# Test an incremental send scenario where we punched a hole into a tail section
+# of a file extent item that is the last item in a leaf and the next leaf in the
+# subvolume tree was not changed (remains shared between the parent and send
+# snapshots).
+#
+. ./common/preamble
+_begin_fstest auto quick send
+
+_cleanup()
+{
+	cd /
+	rm -fr $tmp.*
+	rm -fr $send_files_dir
+}
+
+. ./common/filter
+
+_require_test
+_require_scratch
+_require_btrfs_support_sectorsize 4096
+_require_xfs_io_command "fpunch"
+
+_fixed_by_kernel_commit xxxxxxxxxx \
+	"btrfs: send: fix missing hole punching during incremental send"
+
+send_files_dir=$TEST_DIR/btrfs-test-$seq
+
+rm -fr $send_files_dir
+mkdir $send_files_dir
+
+first_stream="$send_files_dir/1.send"
+second_stream="$send_files_dir/2.send"
+
+# We need a very specific leaf layout where we punch a hole in the last file
+# extent item of a leaf and the next leaf was not modified in the send snapshot,
+# so we set a fixed size of 16K.
+_scratch_mkfs -n 16K >> $seqres.full 2>&1 || _fail "first mkfs failed"
+_scratch_mount
+
+touch $SCRATCH_MNT/foo
+# 205 extents of 64K each with a 64K hole between them.
+for ((i = 0; i < 410; i += 2)); do
+	offset=$((i * 64 * 1024))
+	$XFS_IO_PROG -c "pwrite -b 64K -S 0xab $offset 64K" \
+		$SCRATCH_MNT/foo > /dev/null
+done
+
+_btrfs subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/snap1
+
+# Punch a hole in the last 16K of the last file extent item of the first leaf,
+# which starts at file offset 12845056, so 12845056 + 64K - 16K = 12894208.
+# This does not cause any change in the second leaf of the fs tree, so it will
+# be shared between the snapshots.
+$XFS_IO_PROG -c "fpunch 12894208 16K" $SCRATCH_MNT/foo
+
+_btrfs subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/snap2
+
+echo "File digest in the original fs: $(_md5_checksum $SCRATCH_MNT/snap2/foo)"
+
+_btrfs send -f $first_stream $SCRATCH_MNT/snap1
+_btrfs send -f $second_stream -p $SCRATCH_MNT/snap1 $SCRATCH_MNT/snap2
+
+# Create a new fs and apply both send streams.
+_scratch_unmount
+_scratch_mkfs >> $seqres.full 2>&1 || _fail "second mkfs failed"
+_scratch_mount
+
+_btrfs receive -f $first_stream $SCRATCH_MNT
+_btrfs receive -f $second_stream $SCRATCH_MNT
+
+echo "File digest in the new fs:      $(_md5_checksum $SCRATCH_MNT/snap2/foo)"
+
+# Check the region we punched a hole is full of zeroes.
+echo "Hole data:"
+od -A d -t x1 -j 12894208 -N $((16 * 1024)) $SCRATCH_MNT/snap2/foo
+
+# success, all done
+_exit 0
diff --git a/tests/btrfs/362.out b/tests/btrfs/362.out
new file mode 100644
index 00000000..789abb53
--- /dev/null
+++ b/tests/btrfs/362.out
@@ -0,0 +1,7 @@
+QA output created by 362
+File digest in the original fs: a5a06694d9f7fc3245afb2f391636e44
+File digest in the new fs:      a5a06694d9f7fc3245afb2f391636e44
+Hole data:
+12894208 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+12910592
-- 
2.53.0

