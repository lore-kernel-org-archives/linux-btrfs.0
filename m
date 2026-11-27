Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795799491;
	b=m2AkydL+nULasr/0Nu+AOwO5+j7rAgm6LBs+y5Nh92br16Ip/f3coE4bQ6YzV6i6G2aZ
	 wMJeN1F8boEDXlK65Yf5KWe7GVMaA77MVASMVnk8JLFN8qzE837DdHsq3/YSspJGwpaJC
	 F43HS6ZX7yENgkyEViZDapYTv9jNL1HCm4q0428ubuJ6VeiHpeSxvqJg1V7gK9T13jYp5
	 HgHGoPNXLEshZ8Z7Lfn3iiNv2E/cpKvgJ64BBZf8OtMfr7Xr8ApnWw7ranIP1KCuhrf0q
	 n5ij5fRtJzKPJ+1jHq2wzL4F/R0Pz15C8Cf/6/fXZ8mSMV5rPjPzceBp2VypR2K61jw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795799491;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fo0H51MpKU562jnEmZz1xGJXHhOI3dVjof+GbffXnys=;
	b=gdNF8uaeZznqJl1Cpi/vHEgHe3WSviECaZSalp+FrVO8fgosJLNp56s+tjFgL7bznDW3
	 G20QplYfAR5Qz5UUpw8rDDg8icLa57qcZ4PVL5FzbK2xIWUG6cf0S1J2jn2TVNNYk0p2t
	 XaTwqmN4RB+D0UmdooGrSMeYquWQYUsY78dUltkI35BJsTb/CxKzCBS3SyIy+LA6woYv4
	 H06UAWNv7H07Q9V6KnqGXEwEdM/mxhI2wsI0WX7NhXXQaf6l71oFR5ZwNR/5u5djpmOs1
	 GwQ+L/Ipke5QR49qssXYw5qsJ9TaBhMfv+TKMPRb3sAQmfWBiY7jGJvO4Pvzoptgt1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RMUJUSN0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F6A606A31C;
	Fri, 27 Nov 2026 17:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RMUJUSN0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFD3C1F00893;
	Fri, 27 Nov 2026 17:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795799490;
	bh=fo0H51MpKU562jnEmZz1xGJXHhOI3dVjof+GbffXnys=;
	h=From:To:Cc:Subject:Date;
	b=RMUJUSN0YW605IPSIni1v6ZNhwjjeswu7r1Dg+QVZYdQUtb8SUrODeOxpvYhA05y9
	 bC4XR2A7geVfl10EQXN3xqMvGShrxPqGiV8WST+mIJuWYq+OKMNQZabIPR4MBZFNcE
	 bLUpNl3kQ0fA8Dc8danQ5QzpxDG8+pb2e+x9+EtepKHrZVNcN6Jq2K88nI8vPV3Smi
	 aQRLVrxC4D2Ux36ikDkkcOmwhy4tL8RqRCcPH3DL69WpEqAgQOGg3Q181I809IJ4gl
	 dxuycShMPcVNfyGecXfoSUYmoAfmErP3h2FwPhH0SLe1lgxyphzv78CgFxla7FCT+e
	 SOj36zGq9gWlA==
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] btrfs: test rename exchange with subvolume stubs
Date: Fri, 27 Nov 2026 17:11:21 +0000
Message-ID: <35ae48a4921b42b89843f00b24608eba25f4647b.1795799439.git.fdmanana@suse.com>
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

Test rename exchange using subvolume stubs found in snapshots.
These operations should fail and the filesystem should continue in RW
mode (no transaction aborts happened).

This exercises a bug in btrfs that is fixed by the patch:

  btrfs: reject rename exchange operations with subvolume stubs

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/btrfs/365     | 49 +++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/365.out |  5 +++++
 2 files changed, 54 insertions(+)
 create mode 100755 tests/btrfs/365
 create mode 100644 tests/btrfs/365.out

diff --git a/tests/btrfs/365 b/tests/btrfs/365
new file mode 100755
index 00000000..5d493451
--- /dev/null
+++ b/tests/btrfs/365
@@ -0,0 +1,49 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
+#
+# FS QA Test 365
+#
+# Test rename exchange using subvolume stubs found in snapshots.
+# These operations should fail and the filesystem should continue in RW mode (no
+# transaction aborts happened).
+#
+. ./common/preamble
+_begin_fstest auto quick rename subvol snapshot
+
+. ./common/renameat2
+
+_require_renameat2 exchange
+_require_scratch
+
+_fixed_by_kernel_commit xxxxxxxxxxxx \
+	"btrfs: reject rename exchange operations with subvolume stubs"
+
+_scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
+_scratch_mount
+
+_btrfs subvolume create $SCRATCH_MNT/subvol
+_btrfs subvolume create $SCRATCH_MNT/subvol/inner_subvol
+
+mkdir $SCRATCH_MNT/subvol/dir
+touch $SCRATCH_MNT/subvol/file
+
+_btrfs subvolume snapshot $SCRATCH_MNT/subvol $SCRATCH_MNT/snap
+
+# Source is a directory, destination is subvolume stub, should fail with -EPERM.
+$here/src/renameat2 -x $SCRATCH_MNT/snap/dir $SCRATCH_MNT/snap/inner_subvol
+
+# Source is a file, destination is subvolume stub, should fail with -EPERM.
+$here/src/renameat2 -x $SCRATCH_MNT/snap/file $SCRATCH_MNT/snap/inner_subvol
+
+# Source is a subvolume stub, destination is directory, should fail with -EPERM.
+$here/src/renameat2 -x $SCRATCH_MNT/snap/inner_subvol $SCRATCH_MNT/snap/dir
+
+# Source is a subvolume stub, destination is file, should fail with -EPERM.
+$here/src/renameat2 -x $SCRATCH_MNT/snap/inner_subvol $SCRATCH_MNT/snap/file
+
+# Test that the filesystem did not turn into RO mode due to a transaction abort.
+touch $SCRATCH_MNT/foo
+
+# success, all done
+_exit 0
diff --git a/tests/btrfs/365.out b/tests/btrfs/365.out
new file mode 100644
index 00000000..390f4458
--- /dev/null
+++ b/tests/btrfs/365.out
@@ -0,0 +1,5 @@
+QA output created by 365
+Operation not permitted
+Operation not permitted
+Operation not permitted
+Operation not permitted
-- 
2.53.0

