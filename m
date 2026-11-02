Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793649443;
	b=rKkI296P7Ujwyum4LBwTiGe424VKyQTcW70/p5AdpLHFk6eL45ojF1ZwG2BT/2/tPzCx
	 DNuoF5UMtJ9K8tzMCmBosoty53Xj7wtXpzRYG7YI8A/aUmKIERy5vKfXkNIo7BPs9PLjz
	 8ymxf52SpnE8QwbIqgzjUZ/HBHoV4799UavoKeqH2p4BiNr3idtGu64xwqryYgcbtRs7L
	 ZFpSIG8IpJoXlE7Cf3AwYTNITVORE3fnghPH03HpnHreyrjMBKeeEpQetVWQfJHYT7AbP
	 2ABk5Bsf80socfw3qEPSJN4tnbwIaON+htDZ7H7W2It3MsPk2+6M8/WDp46S6Lb9jSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793649443;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H/z6DfHeHtqagf+5jquslkH6AilKDQULJHG/HrxAMoo=;
	b=wyRSZV06WTB1JaKn8D+XBNYPwubSFucu00dRfTYWtfFCZ5i7AsBt7c6OjNKHttGaqjvi
	 fuGkLtMkaZRDCPwJston1bLVjV5MUFcGXlmQem1fOS/o5t+EmeVdYfOFixdGWkAgmfqT8
	 Qd0g4biW7dDVFqJGjNF2negmoxcpssL0Shze+Arkz3nIDHnCASLcROoLAQBSe+vrWl5Vw
	 dQJ4BzxRPlqUEDLcw0BwWI6+g+Nu2i406M3m01ehJf6KiD6UdCn4fzMERZMbBuIqLlLXs
	 8/gxxNa89gat4DES6CM702CH4AuqGDMegazDE90dn2i0lHc36b/mIKnJnBLmUiJo7OQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mbrmYdsk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 486C1606A32C;
	Mon,  2 Nov 2026 19:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mbrmYdsk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 128E01F00A16;
	Mon,  2 Nov 2026 19:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793649442;
	bh=H/z6DfHeHtqagf+5jquslkH6AilKDQULJHG/HrxAMoo=;
	h=From:To:Cc:Subject:Date;
	b=mbrmYdskeonddu/kjJra6/USdJnFnIY9QrhZgwMxkeG/eLIA3oXZuxzYz2BrtMw4P
	 Ikj7QsTixs8cqt/AVJIuEy4EshyG/Lwo8RF2f64DtNKI2L1jRKRkjktK8WkJH+YbeY
	 XSKnA5qhaZz8wkyAR/G5C3ERgLVRUy9EJxSY7GiEvZl55FgtuClCdVFdMWZwYrgoeN
	 teHDQdFgTwNSOu6IqiHaCrrbvTz/3hOn3Gsn9K2M9IRz+a/P4ouzpMNW+PpeVSE7nC
	 E+5MN9tDj2Ki2PWgkLVTvjSDWwEYX6xNVy2rwKceUgK5fpi99GE04PY3dz1S+UWDTR
	 V9xO5DxMdSIaw==
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] btrfs: test compression attribute on filesystems mounted with nodatacow
Date: Mon,  2 Nov 2026 19:57:17 +0000
Message-ID: <19d06a11c66590ec2a053781c79bf00e39361a70.1793648537.git.fdmanana@suse.com>
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

Test that if we mount a filesystem with "-o nodatacow", set the
compression attribute on a directory and then create a file under it, the
file should inherit compression and setting an additional attribute (like
+A, write append mode) should work.

This exercises a bug fixed by the following kernel patch:

  btrfs: dont propagate nodatacow mount option on files with inherited compression

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/btrfs/364     | 45 +++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/364.out |  5 +++++
 2 files changed, 50 insertions(+)
 create mode 100755 tests/btrfs/364
 create mode 100644 tests/btrfs/364.out

diff --git a/tests/btrfs/364 b/tests/btrfs/364
new file mode 100755
index 00000000..d59e1cab
--- /dev/null
+++ b/tests/btrfs/364
@@ -0,0 +1,45 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
+#
+# FS QA Test 364
+#
+# Test that if we mount a filesystem with "-o nodatacow", set the compression
+# attribute on a directory and then create a file under it, the file should
+# inherit compression and setting an additional attribute (like +A, write append
+# mode) should work.
+#
+. ./common/preamble
+_begin_fstest auto quick compress fiemap
+
+. ./common/filter
+. ./common/punch # for _filter_fiemap_flags
+
+_require_xfs_io_command "fiemap"
+_require_chattr c
+_require_chattr A
+_require_scratch
+
+_fixed_by_kernel_commit xxxxxxxxxxxx \
+	"btrfs: dont propagate nodatacow mount option on files with inherited compression"
+
+_scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
+_scratch_mount "-o nodatacow"
+
+# Create a directory with the compression attribute, so that all files created
+# under it inherit the compression attribute.
+mkdir $SCRATCH_MNT/dir
+$CHATTR_PROG +c $SCRATCH_MNT/dir
+
+# Now create a file with some data inside the directory.
+$XFS_IO_PROG -f -c "pwrite 0 128K" $SCRATCH_MNT/dir/foo | _filter_xfs_io
+
+# Now try to make the file append only, it should work.
+$CHATTR_PROG +A $SCRATCH_MNT/dir/foo
+
+# A fiemap should report an encoded extent, which means it's compressed.
+echo "Fiemap output:"
+$XFS_IO_PROG -c "fiemap -v" $SCRATCH_MNT/dir/foo | _filter_fiemap_flags 1
+
+# success, all done
+_exit 0
diff --git a/tests/btrfs/364.out b/tests/btrfs/364.out
new file mode 100644
index 00000000..205d5ca2
--- /dev/null
+++ b/tests/btrfs/364.out
@@ -0,0 +1,5 @@
+QA output created by 364
+wrote 131072/131072 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+Fiemap output:
+0: [0..255]: encoded|last
-- 
2.53.0

