Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2F8733F8A2;
	Tue, 31 Mar 2026 14:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774966516; cv=none; b=WklT2hSqlbzYJ/0rQk5oPncXCZoyt9d1C/0jB0vmv3oPTBxvuoGLhQh6GXmaqXG2MeGG8HNyIS20d+GxoR+/yHbJqff/nkpSLESNWxgCpmt39LPNW7Uz6NLpf5W6xyvir7hEJn1WblsXDuiufNUdYv4cTr+sRwg3ONJzGZENE7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774966516; c=relaxed/simple;
	bh=sQ0HnxJY4D4EolN35eHo3ARK9oYmcGlRrGEnhgi8k4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fj0IBsOg4I9e719kGplTdnmpTV1ybdquhqdShTyeBYisQwSvKaraWId1f98lioluPUFuwYdKDzUF+qxiTdPCR4r33MxYMpFjc/tHmuuD4vtM2O1zc99bhqXEndxL83DjPfM46s6mmIblU2TDVrydXUJo/mt8tl+mXlo/S4lwja4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hjCdLoie; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hjCdLoie"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F32BC19423;
	Tue, 31 Mar 2026 14:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774966516;
	bh=sQ0HnxJY4D4EolN35eHo3ARK9oYmcGlRrGEnhgi8k4Q=;
	h=From:To:Cc:Subject:Date:From;
	b=hjCdLoie/xEc2YZ+7/7rEP6oLufhFyzq3Zw7MMjIBndB9GDF/TuiOAyWomikVZJi/
	 a0RLb75r95oNvjWxSv/mOvV7yBRRHYMoRVQMIaTeh/5beQ5uD8DTsoYqWR0NIP1l2b
	 oRDzJ3iHIAiZ7m46Ol/EcW5s0OGezPdjHbbi8V0GYtNUbJyNY1eh+6FmWIZQjTBgQL
	 ZJQEw8A0Mz2/jTHaNRE1Ra5Fk8C+dI+Jh7njg0e5GZl9+Zz08+kLsMicCP7jQoo+Aa
	 SBCvlOhDtJJqmOZCnOaULbZXubwuSVuqOyo7SSK8s3VwZFd6dLt4OYsacHhrEziRda
	 R1iBi4p00KcIg==
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] fstests: add kernel commit IDs for patches already merged upstream
Date: Tue, 31 Mar 2026 15:15:10 +0100
Message-ID: <63eb507011e1ab2681a8aaa68ec1214896c05b55.1774966392.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

Several tests mention patches that are already in Linus' git tree, so add
their commit IDs. For generic/762, also use "fixed_by_fs_commit xfs"
instead of "_fixed_by_git_commit kernel" since it's a XFS specific commit
and it does not make sense for the test to report that commit in case it
fails when running against a filesystem other than XFS.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/btrfs/340   | 2 +-
 tests/btrfs/345   | 2 +-
 tests/btrfs/346   | 2 +-
 tests/btrfs/347   | 2 +-
 tests/generic/762 | 2 +-
 tests/generic/789 | 2 +-
 tests/generic/790 | 2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/tests/btrfs/340 b/tests/btrfs/340
index fc3b8d62..872f790c 100755
--- a/tests/btrfs/340
+++ b/tests/btrfs/340
@@ -10,7 +10,7 @@
 . ./common/preamble
 _begin_fstest auto quick qgroup
 
-_fixed_by_kernel_commit xxxxxxxxxxxx \
+_fixed_by_kernel_commit 68d4b3fa18d7 \
 	"btrfs: qgroup: update all parent qgroups when doing quick inherit"
 
 # For the automatic fsck at unmount.
diff --git a/tests/btrfs/345 b/tests/btrfs/345
index 75cc3067..58727049 100755
--- a/tests/btrfs/345
+++ b/tests/btrfs/345
@@ -17,7 +17,7 @@ _require_scratch
 _require_btrfs_support_sectorsize 4096
 _require_btrfs_command "property"
 
-_fixed_by_kernel_commit xxxxxxxxxxxx \
+_fixed_by_kernel_commit e1b18b959025 \
 	"btrfs: fix transaction abort when snapshotting received subvolumes"
 
 # Use a 4K node/leaf size to make the test faster.
diff --git a/tests/btrfs/346 b/tests/btrfs/346
index ef301ef7..28c1e536 100755
--- a/tests/btrfs/346
+++ b/tests/btrfs/346
@@ -14,7 +14,7 @@ _begin_fstest auto quick subvol
 _require_scratch
 _require_btrfs_support_sectorsize 4096
 
-_fixed_by_kernel_commit xxxxxxxxxxxx \
+_fixed_by_kernel_commit 2d1ababdedd4 \
 	"btrfs: fix transaction abort on file creation due to name hash collision"
 
 # Use a 4K node/leaf size to make the test faster and require less file names
diff --git a/tests/btrfs/347 b/tests/btrfs/347
index ebd53d97..9239e99a 100755
--- a/tests/btrfs/347
+++ b/tests/btrfs/347
@@ -16,7 +16,7 @@ _require_test_program t_btrfs_received_uuid_ioctl
 _require_scratch
 _require_btrfs_support_sectorsize 4096
 
-_fixed_by_kernel_commit xxxxxxxxxxxx \
+_fixed_by_kernel_commit 87f2c46003fc \
 	"btrfs: fix transaction abort on set received ioctl due to item overflow"
 
 # Use a 4K node/leaf size to make the test faster.
diff --git a/tests/generic/762 b/tests/generic/762
index e3a01de8..bbaf5051 100755
--- a/tests/generic/762
+++ b/tests/generic/762
@@ -10,7 +10,7 @@
 . ./common/preamble
 _begin_fstest auto quota prealloc
 
-_fixed_by_git_commit kernel XXXXXXXXXXXXXX \
+_fixed_by_fs_commit xfs 4b8d867ca6e2 \
 	"xfs: don't over-report free space or inodes in statvfs"
 
 . ./common/filter
diff --git a/tests/generic/789 b/tests/generic/789
index 1ed7a885..0e72966e 100755
--- a/tests/generic/789
+++ b/tests/generic/789
@@ -24,7 +24,7 @@ _cleanup()
 _require_scratch
 _require_dm_target flakey
 
-_fixed_by_fs_commit btrfs xxxxxxxxxxxx \
+_fixed_by_fs_commit btrfs 5254d4181add \
 	"btrfs: fix zero size inode with non-zero size after log replay"
 
 _scratch_mkfs >>$seqres.full 2>&1 || _fail "mkfs failed"
diff --git a/tests/generic/790 b/tests/generic/790
index 9aa577f5..28f7faa2 100755
--- a/tests/generic/790
+++ b/tests/generic/790
@@ -27,7 +27,7 @@ _cleanup()
 _require_scratch
 _require_dm_target flakey
 
-_fixed_by_fs_commit btrfs xxxxxxxxxxxx \
+_fixed_by_fs_commit btrfs 9573a365ff9f \
 	"btrfs: log new dentries when logging parent dir of a conflicting inode"
 
 _scratch_mkfs >>$seqres.full 2>&1 || _fail "mkfs failed"
-- 
2.47.2

