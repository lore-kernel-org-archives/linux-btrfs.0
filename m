Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB4E49DB8B;
	Tue, 22 Sep 2026 18:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790102810; cv=none; b=QvHqjn7bSZnvoV7QFEhe1GdqhPzXA/4LwQpTnM53Sdbowk+KaOXWttkL0/uKmekkfM16e2jb3CcfhxnjN2im5hOO/yK3qc7UqBg0OExbRrXbby/gosXYk0au+C4Zipf6znZnTFqv6cBDWGHVYVbgG3iNHq8GJyj7SL1Xr88OrgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790102810; c=relaxed/simple;
	bh=xVUD0ZyCN4GNdmTHQUT0S+wn1N1gac8eMzEqnfwMH7c=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=ckwJyqoA79FRnN/Q91g0AegiZoQhgidHv1I+iH4srn+pXDSxuQzW0UEs8ENztsL96W1Z1vwJxrRI3w97JgaJHObrHCLNHBl1Z4jPAOTkanxd3tZgJ9vPwuXbXHVdQz+OzOjmQx0QHxQZn38Q3Fe9iwj1I5qFp2iRnJ8+vz06F8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dut+LyLp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dut+LyLp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BC821F000FF;
	Tue, 22 Sep 2026 18:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790102798;
	bh=Ig8VuFNrCO8Wls7CC/e/hBr2ze3xti7Vw5G8bEeaGnI=;
	h=From:Date:Subject:To:Cc;
	b=dut+LyLpB0PkORA1l6MWijoICCxFj0TSWuMRDG4/JFfbj6I/st7nc4f+tAdeMvANO
	 HoOa+/kVurhNM87Yy25BPU6XWuX2az+2x5ijkPBv1r8m98cYHBUSfvecvehyKvfY3I
	 fE3pYoo+9SVemI4A+Sdl/ZvcMfe6XQK6U2CXVAS26HU88Xy9Jswnyp1vjcvaLZvQ33
	 cfUB0guA3pkjd8tGjBo79jXx4TcudSTyRGVNTLZpE7U/QXJt7fT+653pdKwG9R6GB2
	 f7Su3noiU6AkJdztAMlFjTT4l+qY9tns27e5yvER2aTNXJ3XgwwkhMtieZSQ7n+Mkw
	 SJbY5aRidhDhw==
From: Jeff Layton <jlayton@kernel.org>
Date: Tue, 22 Sep 2026 14:46:22 -0400
Subject: [PATCH fstests v3] btrfs: test graceful ENOMEM handling in
 synchronous dirops
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260922-btrfs-enomem-v3-1-1be91fc173fc@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/22NwQ7CIBAFf6XZsxjACurJ/zAeKN22RAuGJUTT9
 N8lnNR4nLzMvAUIo0OCU7NAxOzIBV9gt2nATsaPyFxfGCSXih/FnnUpDsTQhxlnhppzrQ9KCqG
 hKI+Ig3vW3AUGSkiJ4FqGyVEK8VVvsqjz/2IWTDBruFaCY2dNf75h9HjfhjjWUpaftv6xZbG5t
 baVWphetV/2uq5v/JbwNfAAAAA=
X-Change-ID: 20260915-btrfs-enomem-e70077862117
To: Zorro Lang <zlang@kernel.org>, Anand Jain <asj@kernel.org>, 
 Filipe Manana <fdmanana@suse.com>
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=7886; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=xVUD0ZyCN4GNdmTHQUT0S+wn1N1gac8eMzEqnfwMH7c=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBqss0InE6Sv7Dv2acOX/gexBdLzKEJ2pULiTwPY
 JVcAbSeJEGJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCarLNCAAKCRAADmhBGVaC
 FWjND/wL4evmgpUmEdV6WRLvnIf6u5Pmg1pXl7Qr9084DI2QB6ubZzPlCR5nAeA3ngXMGe4omTG
 O4vGA/9CEKMDqZbQjRiCK30CTcPXsxYFYx42WbWiiaylOHPSLGycpgUjUa7VOBTYGRZWsBMwh8K
 YaamE9o+xq3fXePpE/haynDScmG81icw650gXwai02NPCX9NLXQGsMTQRtVm7YPZezHx5tyI1J6
 zp/GBtH/wemwSkQz0DARbxVAVry3qm+shxFQZTq1EgNfVWkNrNymGWfNieMBAOSBMbgD2op1vos
 Dne+Nym/GkIkCSUBaySRcYCQtPstGgLpTSsRTXa7Mnkk+0DmWziY06DuZhgmbRg4PshImm+AsEG
 5L5Vr5nbpktVIwgdzE6/TQIeASP5eKN7SPDFQszPkCQzJeC0dmIuuz7WH++17srjF6OkDFyhwmo
 BWZOBcn3DQnQpGPUM+X83tTGzrmr2OLVTCuqTFf+eVvfJ3BfiTouFv4VqkO2DNS7a9M0dsiHTSK
 MOydD5qeMNIrTVK1vyJAmSfmAM/+oZrSw88hwnxHYEXZ9QC7qjCzu0/Hf9lG/ix9nsnNeTA8lGS
 XAJUzyFh6zOQIFizq7yyye48AerffPeCHo8a5Nc2aYsE/MaaPi9Ko4murRtZu+vxl3OM4IzbRM5
 f2xcFzf+3p2868g==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215

Recently, we added some patches to allow btrfs to handle -ENOMEM errors
in dir-morphing codepaths [1]. As part of that, we added fault injection
knobs to a few functions so we could test that error handling.

Add a test case that uses the fail_function facility to inject -ENOMEM
into btrfs_prealloc_delayed_dir_index() and confirms that a
dir-modifying operation returns ENOMEM to userspace without aborting the
filesystem:

- mkdir fails with ENOMEM (not EROFS),
- a subsequent create succeeds (fs is not read-only/aborted),
- a mount cycle runs orphan cleanup and the automatic fsck confirms
  consistency.

The injection is global, so any other btrfs dir-entry creation can
consume it first -- including the test's own $tmp redirection when /tmp
is itself on btrfs. Pre-create that file and retry until the mkdir takes
the error.

Add generic _require_function_error_injection / _inject_function_error /
_uninject_function_error helpers to common/inject for driving the kernel
fail_function interface.

[1]: https://lore.kernel.org/linux-btrfs/20260825-btrfs-enomem-v4-0-b9363fa8714a@kernel.org/

Assisted-by: LLM
Reviewed-by: Zorro Lang <zlang@kernel.org>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
Changes in v3:
- Call _require_debugfs in _require_function_error_injection
- Add the test to the "dir" group
- Uninject the error in _cleanup, so an interrupted test can't leak it
- Use _exit 0 instead of setting status directly
- Link to v2: https://lore.kernel.org/r/20260917-btrfs-enomem-v2-1-0ccc4271ad64@kernel.org

Changes in v2:
- Add _fixed_by_kernel_commit line
- Clean up changelog
- Link to v1: https://lore.kernel.org/r/20260915-btrfs-enomem-v1-1-ca07610ebcad@kernel.org
---
 common/inject       | 51 +++++++++++++++++++++++++++++
 tests/btrfs/354     | 92 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/354.out |  2 ++
 3 files changed, 145 insertions(+)

diff --git a/common/inject b/common/inject
index 6b590804d1ea..fc63d3a32c8a 100644
--- a/common/inject
+++ b/common/inject
@@ -111,3 +111,54 @@ _scratch_inject_error()
 		_fail "Cannot inject error ${type} value ${value}."
 	fi
 }
+
+# Requires the kernel fail_function facility (CONFIG_FUNCTION_ERROR_INJECTION
+# and CONFIG_FAIL_FUNCTION) and, if a function name is given, that the function
+# is annotated with ALLOW_ERROR_INJECTION().
+_require_function_error_injection()
+{
+	local func="$1"
+
+	_require_debugfs
+	test -d "$DEBUGFS_MNT/fail_function" || \
+		_notrun "$DEBUGFS_MNT/fail_function not found; CONFIG_FAIL_FUNCTION not enabled"
+
+	if [ -n "$func" ]; then
+		grep -qw "$func" "$DEBUGFS_MNT/error_injection/list" 2>/dev/null || \
+			_notrun "$func is not registered for error injection"
+	fi
+}
+
+# Inject a fixed return value into a kernel function via fail_function.
+#   $1 - function name (must be ALLOW_ERROR_INJECTION annotated)
+#   $2 - return value to inject (e.g. -12 for -ENOMEM)
+#   $3 - number of times to fail (default 1)
+_inject_function_error()
+{
+	local func="$1"
+	local retval="$2"
+	local times="${3:-1}"
+
+	# Writing the function name to "inject" creates its per-function dir.
+	echo "$func" > "$DEBUGFS_MNT/fail_function/inject"
+	# The retval file is an unsigned hex attribute (DEFINE_DEBUGFS_ATTRIBUTE
+	# "%llx"), so a negative errno like -12 must be written as its unsigned
+	# 64-bit (two's-complement) hex form; a bare "-12" is rejected with EINVAL.
+	printf '%#x\n' "$retval" > "$DEBUGFS_MNT/fail_function/$func/retval"
+	echo 100 > "$DEBUGFS_MNT/fail_function/probability"
+	echo 0 > "$DEBUGFS_MNT/fail_function/interval"
+	echo 0 > "$DEBUGFS_MNT/fail_function/space"
+	echo 0 > "$DEBUGFS_MNT/fail_function/verbose"
+	echo "$times" > "$DEBUGFS_MNT/fail_function/times"
+}
+
+# Stop injecting errors into a kernel function set up by
+# _inject_function_error().
+_uninject_function_error()
+{
+	local func="$1"
+
+	echo 0 > "$DEBUGFS_MNT/fail_function/times" 2>/dev/null
+	echo 0 > "$DEBUGFS_MNT/fail_function/probability" 2>/dev/null
+	echo "!$func" > "$DEBUGFS_MNT/fail_function/inject" 2>/dev/null
+}
diff --git a/tests/btrfs/354 b/tests/btrfs/354
new file mode 100755
index 000000000000..a4d8fec41091
--- /dev/null
+++ b/tests/btrfs/354
@@ -0,0 +1,92 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Jeff Layton.  All Rights Reserved.
+#
+# FS QA Test No. 354
+#
+# Verify that an -ENOMEM in the synchronous directory entry insertion path is
+# returned to userspace without aborting the filesystem.
+#
+# btrfs pre-allocates the delayed dir index before modifying the btree, so a
+# failure in btrfs_prealloc_delayed_dir_index() must surface as -ENOMEM from
+# mkdir()/create()/etc. rather than a transaction abort. Use the fail_function
+# facility to force that allocation to fail and confirm the fs survives.
+#
+. ./common/preamble
+_begin_fstest auto quick dir
+
+_cleanup()
+{
+	[ -n "$func" ] && _uninject_function_error $func
+	cd /
+	rm -r -f $tmp.*
+}
+
+. ./common/inject
+. ./common/filter
+
+_fixed_by_kernel_commit xxxxxxxxxxxx \
+	"btrfs: handle ENOMEM from btrfs_insert_dir_item() without aborting"
+
+_require_scratch
+# For the automatic fsck at unmount, which confirms the orphaned inode left by
+# the failed operation is cleaned up and the fs is consistent.
+_require_check_dmesg
+_require_function_error_injection btrfs_prealloc_delayed_dir_index
+
+func=btrfs_prealloc_delayed_dir_index
+
+_scratch_mkfs >> $seqres.full 2>&1
+_scratch_mount
+
+# Pre-create the stderr file. fail_function has no usable task filter, so the
+# injection is global, and $tmp may well live on a btrfs filesystem itself. If
+# the shell had to create this file it would insert a dir entry and swallow the
+# injected failure before mkdir() ever ran.
+touch $tmp.err
+
+# For the same reason any other btrfs dir-entry creation on the system can
+# consume the one-shot failure, so retry until our mkdir is the operation that
+# takes it.
+err=""
+for i in $(seq 1 20); do
+	rm -rf "$SCRATCH_MNT/dir"
+
+	# Force a single -ENOMEM (-12) into the prealloc path.
+	_inject_function_error $func -12 1
+	mkdir "$SCRATCH_MNT/dir" 2>$tmp.err
+	res=$?
+	_uninject_function_error $func
+
+	# mkdir succeeded, so something else consumed the injected failure.
+	# Note we must not leave the directory behind, or the next attempt
+	# would fail with EEXIST rather than the injected error.
+	if [ $res -eq 0 ]; then
+		continue
+	fi
+
+	err=$(cat $tmp.err)
+	break
+done
+
+if [ -z "$err" ]; then
+	_notrun "injected error did not reach mkdir"
+fi
+
+# The error returned to userspace must be ENOMEM, not EROFS (which would mean
+# the transaction was aborted and the fs went read-only).
+echo "$err" | grep -qi "cannot allocate memory" || \
+	{ echo "unexpected error from mkdir:"; echo "$err" | _filter_scratch; }
+
+# The filesystem must still be usable: a create with injection disabled must
+# succeed. On an aborted (read-only) fs this would fail with EROFS.
+mkdir "$SCRATCH_MNT/dir2" || _fail "filesystem unusable after injected ENOMEM"
+
+# Cycle the mount to run orphan cleanup for the inode left behind by the failed
+# mkdir, then keep using the fs to be sure it is healthy.
+_scratch_cycle_mount
+touch "$SCRATCH_MNT/dir2/file"
+
+echo "silence is golden"
+
+_exit 0
diff --git a/tests/btrfs/354.out b/tests/btrfs/354.out
new file mode 100644
index 000000000000..afe30ed36fea
--- /dev/null
+++ b/tests/btrfs/354.out
@@ -0,0 +1,2 @@
+QA output created by 354
+silence is golden

---
base-commit: a370dcbed43563f0462801e889e0eceb93c7cfad
change-id: 20260915-btrfs-enomem-e70077862117

Best regards,
-- 
Jeff Layton <jlayton@kernel.org>

