Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0EA94D9F62;
	Thu, 17 Sep 2026 11:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789645112; cv=none; b=k1TxFdSaFfestG0NR6AwTUNuoGkVb5b16C1qMluUQAZRVGuAgzSU4++QGQJMh1n5WWUb7fJyhlrCgqHLHdsFjuzjmiz5dwdlburweiyhK2zwhaAL7cDTzawcfTzlty3Fa7QYPbBiZXViHxMaVRCoU60Nu3GP/FkNmwhbUKRLNDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789645112; c=relaxed/simple;
	bh=eEnEZbFuUKxgtaBf04hGQJuO3Nqxt85CSgOisvYK5QQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=e1S6XTuubwuu85CcE0G+fSlxI7tl+gIlQ2nWyn+r6LwRAvR7lFB40Un48EaKKuprrPr8wTuZc2g1msIn1rgSYO9tHmqRJk5a6xoeWED7/9RzDBo1LOlEdehgQjJcH7wD3dXeH+d+JSqV3JnCurOay7FZej+pMu6JxRTVLMnGh6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MmPchfj4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MmPchfj4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54B2E1F000FF;
	Thu, 17 Sep 2026 11:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789645110;
	bh=JyrNM/sTCRe+62bvrZEUDr7khGGEM5vbgNBdBzFOAuI=;
	h=From:Date:Subject:To:Cc;
	b=MmPchfj45ngVAStdoqZuhov3HYJI+7YejQkN2Poa0JmJ5L3wd/UJzj1TC2T8LvJM6
	 ZBCmjAExqOzne1ZgjEdg8nKmNH/UrO00RMAmYpEU/Y533u7byt4x7Jxnk5y/vZq4g0
	 sTyt0SuxhZ+a4gbmS8Nc+sXOzREXiNQq+plPEf/VsVFGJMaYR+S1YU9ToLPKblnLsU
	 sOBWRKROc9CqB/fLPDgi73tmnB/5P5Eww5766c0qH2P3r+a95CIJbsAlOheyZLyZUo
	 an50acs4hvQRadiL/05u2suX1lp1d6KYLRBFRz8RJ2+Q76s25XkYE2TD4BfTHoIGWr
	 lpgigOfcnBjZg==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 17 Sep 2026 07:38:23 -0400
Subject: [PATCH fstests v2] btrfs: test graceful ENOMEM handling in
 synchronous dirops
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-btrfs-enomem-v2-1-0ccc4271ad64@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/22NQQrCMBBFr1JmbSQTMFFX3kO6aNNpG7RJmQlFK
 bm7oWuXj8d/fwchDiRwb3Zg2oKEFCuYUwN+7uJEKgyVwWhj9Q0vqs88iqKYFloUOa2du1qD6KB
 OVqYxfI7cE0bJJFmgrWIOkhN/j5sND/2/uKFC5TvtLGrqfTc8XsSR3ufEE7SllB/Ryr6IsgAAA
 A==
X-Change-ID: 20260915-btrfs-enomem-e70077862117
To: Zorro Lang <zlang@kernel.org>, Anand Jain <asj@kernel.org>, 
 Filipe Manana <fdmanana@suse.com>
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=7348; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=eEnEZbFuUKxgtaBf04hGQJuO3Nqxt85CSgOisvYK5QQ=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBqq9ExMry6pjxa+a3zU6OgGogUUavq6dp/0YqJi
 ezb9F/oAemJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaqvRMQAKCRAADmhBGVaC
 FaE6D/9zieKLAYm/x+WlcULf3ow9AdHT/w3FNcTZ2NLaRle2Qj3XtYZHV3kutOueNAU8xEbEi2G
 +G2cY8CYzYletN8LXi2steDTtcpUqkdN5W/X25yiQy0phaJSgPJpOcENqUt9EkbIL74Js2nx2rA
 TIqtg+ddRqo/DCTa6sf5oxkDr1dWcy0I/jXs7hbIE1sJdHgkaQV0rhiO577RTyrda7xEzbx9/+2
 +9p8iWxKiI2fqcW34rWAop823aPN81gYlmxObudv5D/4be/dfD/HwHJuHNKMwWVepYsUuOJSbKo
 5KMx69TciWmLLFij3Z68pNB9ISksU3yygJtlvg+yFJMzbzAPQDeP+EZPLB6odxO61qfGvFKAyS/
 770HPL1dq1YW8Y0R2y/5N5lmTd/AipkPHN9I1eOajXILPuTXO+bVtcYEEC8KgbEmGHGAr8+77Ps
 8zWFW1psqLovx5X/AEEk3RZjkBhiYhGaQDQ2ZzM2eVV8dIansQvbXUSWdK2FOz1t4f2+AwKGtjo
 bVRWI8h/0hjQgbfHuqRVc/fvp7wTqtnyCs9+Q7f8/+O2zSaq3FTQ/4YhTb9zjTPHZUbGllv1IRk
 0uCmhj1yoWq33dyHe03Oa4LrFF+h8qV1DhqfAGaPjUUErOAIlqhO+tUI8F6kNJNvMRHFth1ua/X
 DTsbHdvduhZDUTA==
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
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
Changes in v2:
- Add _fixed_by_kernel_commit line
- Clean up changelog
- Link to v1: https://lore.kernel.org/r/20260915-btrfs-enomem-v1-1-ca07610ebcad@kernel.org
---
 common/inject       | 50 +++++++++++++++++++++++++++++++
 tests/btrfs/354     | 86 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/354.out |  2 ++
 3 files changed, 138 insertions(+)

diff --git a/common/inject b/common/inject
index 6b590804d1ea..da78c1931135 100644
--- a/common/inject
+++ b/common/inject
@@ -111,3 +111,53 @@ _scratch_inject_error()
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
index 000000000000..e5365b21059a
--- /dev/null
+++ b/tests/btrfs/354
@@ -0,0 +1,86 @@
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
+_begin_fstest auto quick
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
+status=0
+exit
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

