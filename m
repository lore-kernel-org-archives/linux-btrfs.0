Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795542757;
	b=LWhBd0e/NDkL6x9d5x3XdoMQVAZbEoX0YlJNoX6wEiweQEZsoPj7q0f3EmQxwHvnjob/
	 dn9kIb41ysd+MGtBDff/TE0PUcNoWa/TuwKexbyB/NOWQUCHmEe2Ls8IDdI3G2DltWPOl
	 nL5JH53cKU/QDv5jGb1/raz7ahKUNzYMTyXLLHk0sW8iGwKs401lDV8DqjLq0W9zArIjm
	 42aeowNI3n/+A3TqbFapZ4DFMPnWbFBH5cU9oR79NJNpZoK4vnAnYt+t3cGXYLAdweeF8
	 SGLuJmtR1Ehl2tC0VyTPx2mpBfleXWpaTeX9G2Cyd94dO0oPgNtdOVSe9W8FbpsmJsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795542757;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Xy6EWSF99HGHeP8GhUp38WSqPd5ynd13YZgZPpIxi4g=;
	b=bmn/n35Ap8ZZl3P/xbKSUqn/JSfeUZVWPkP0kZLRsI184TiX7T0hHfyRfX3dUjSlMbOj
	 gJGA7ms52lNsVVbv9AxK7PtYoA6/9PLey0t+/MsBdeg0xemZ8gsxWN+tgRbAO57/Hv7ra
	 SqARm1rZ7Ii9llmqaiYuV1QxHMzkglY89gUueYThtt9/XUa5N/ToMs65Hf/qo4B54+AT7
	 b6Rtp39ugbFxOrsFhP0pN5HVh7cdhHXERwPdGpEZpvZqttHy8UjGXWca7D9/MzjJr5jsX
	 IFCKx4KXXyEjWZxDJVmk0HFwB5I4GFQj/5Tf/+Uj5950fnZuVK32NKPM+9pcMYFWk7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jTjKjEH2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA66A606A31E;
	Tue, 24 Nov 2026 17:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jTjKjEH2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5C3C1F000C0;
	Tue, 24 Nov 2026 17:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795542757;
	bh=Xy6EWSF99HGHeP8GhUp38WSqPd5ynd13YZgZPpIxi4g=;
	h=From:To:Cc:Subject:Date;
	b=jTjKjEH28W1e5egdkVoBTDp+TafEZCunyEyNQItUC5wBQQ/USbCCBFrNIPLbmPrNo
	 tSeF1lAWE5/vJxxMoUwlQxYtyWwKWjKZSKW0DsCQlm8bl9t5oeNpumaPz90c0ob4lB
	 OFSDWazK2vNxnwO5PJHzgvDOjnC4rsuRHiCZFkBt78uvFqCpGj6SCFB/pi3Embpk7/
	 zTr07w+arycISR/VkY/NgQm5aCcjs2kLFfZSifGehIyFXBBTHcmK7Wj8khPyZPkIKj
	 /nWnyIV6EsZuleOUu0hgMKBspzRQXuBOEupijsHzbakqBy5AD1Wida1sDkJkmYziJR
	 Xd93QKVNG2ZUA==
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] generic: test fsync of a file in a new direcory with a hardlink removed
Date: Tue, 24 Nov 2026 17:52:32 +0000
Message-ID: <0e9facfab3e5b9750b551524cf95d8a29d0a3726.1795541960.git.fdmanana@suse.com>
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

Test creating a file in a new directory, creating a hardlink inside a new
subdirectory, open a fd to the file, remove the first link, fsync the file
using the fd previously opened and power fail. After the fs is mounted
again we expect the file and the directories to exist, but only the second
link for the file exists.

This exercises a bug in btrfs that is fixed by the following patch:

  "btrfs: fix loss of fsynced file after link into new dir and unlink"

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/generic/900     | 65 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/900.out | 15 ++++++++++
 2 files changed, 80 insertions(+)
 create mode 100755 tests/generic/900
 create mode 100644 tests/generic/900.out

diff --git a/tests/generic/900 b/tests/generic/900
new file mode 100755
index 00000000..1bcf2e59
--- /dev/null
+++ b/tests/generic/900
@@ -0,0 +1,65 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
+#
+# FS QA Test 900
+#
+# Test creating a file in a new directory, creating a hardlink inside a new
+# subdirectory, open a fd to the file, remove the first link, fsync the file
+# using the fd previously opened and power fail. After the fs is mounted again
+# we expect the file and the directories to exist, but only the second link for
+# the file exists.
+#
+. ./common/preamble
+_begin_fstest auto quick log
+
+_cleanup()
+{
+	_cleanup_flakey
+	cd /
+	rm -r -f $tmp.*
+}
+
+. ./common/filter
+. ./common/dmflakey
+
+_require_scratch
+_require_hardlinks
+_require_test_program unlink-fsync
+_require_dm_target flakey
+
+_fixed_by_fs_commit btrfs xxxxxxxxxxxx \
+	"btrfs: fix loss of fsynced file after link into new dir and unlink"
+
+_scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
+_require_metadata_journaling $SCRATCH_DEV
+_init_flakey
+_scratch_mount
+
+# Create our test file with some data.
+mkdir $SCRATCH_MNT/testdir
+$XFS_IO_PROG -f -c "pwrite -S 0xab 0K 64K" $SCRATCH_MNT/testdir/foo | _filter_xfs_io
+
+# Create a subdirectory and a link in it for our file.
+mkdir $SCRATCH_MNT/testdir/subdir
+ln $SCRATCH_MNT/testdir/foo $SCRATCH_MNT/testdir/subdir/bar
+
+# Now open an fd to our file using its first link, unlink that path and fsync
+# the fd.
+$here/src/unlink-fsync $SCRATCH_MNT/testdir/foo
+
+# Simulate a power failure and replay the log/journal.
+# Our file should exist with a single link, as $SCRATCH_MNT/testdir/subdir/bar.
+_flakey_drop_and_remount
+
+echo "Filesystem content after power failure:"
+# Remove the 'lost+found' directory which only exists in some filesystems like
+# extN and remove empty lines to have a consistent output regardless of the
+# existence of the 'lost+found' directory.
+ls -1R $SCRATCH_MNT/ | grep -v 'lost+found' | grep -v -e '^$' | _filter_scratch
+
+echo -e "\nFile data after power failure:"
+_hexdump $SCRATCH_MNT/testdir/subdir/bar
+
+# success, all done
+_exit 0
diff --git a/tests/generic/900.out b/tests/generic/900.out
new file mode 100644
index 00000000..01988d0c
--- /dev/null
+++ b/tests/generic/900.out
@@ -0,0 +1,15 @@
+QA output created by 900
+wrote 65536/65536 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+Filesystem content after power failure:
+SCRATCH_MNT/:
+testdir
+SCRATCH_MNT/testdir:
+subdir
+SCRATCH_MNT/testdir/subdir:
+bar
+
+File data after power failure:
+000000 ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab  >................<
+*
+010000
-- 
2.53.0

