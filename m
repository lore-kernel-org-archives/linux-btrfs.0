Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838B94C1507;
	Mon, 12 Oct 2026 17:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791826280; cv=none; b=H/ExcWb1bafA9CdvawwbN3m2pW+rMoPbRyrGPCwSDdu4HFsiwS0B6KCgXVnQ+JYZt0DZYclXDI+Fm3l8jn3yWGXcf7wOCF8h5tR+3Z+yPrwZvxovNHF9zMQez5pQsWoksM24jaYBN4JADLBNx5GPnHBAWeD3C1VOFpYNbtxmxew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791826280; c=relaxed/simple;
	bh=iVlEu+F2387LYnpcpogqYSDJwJGhELAx6VTLwUWBOkM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dnWUWUcszkR3XjeFWrdNUnCI9ayjjZcTtgmGZhJgwwXJ/zmd3+sx1QPrjzOwNEKfKVgwcPwLuD024Zws6v1EBMe2EzAi8ODfUzk2wejHcRnvH4P4Ckr3lcVAgxbQXgRDwFUmLSfLkpurq6gRLMStoiIV5z1sS8/2FvFFziPu5K4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dn6cNkBm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dn6cNkBm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CC9D1F0089B;
	Mon, 12 Oct 2026 17:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791826279;
	bh=YEgRGEDdABx+qg8TC0wYMuy0D26K4FsB2eO7sEXGdN8=;
	h=From:To:Cc:Subject:Date;
	b=dn6cNkBmakSaWrrinObOfpoccnD+BCZvHMP9oBfg8HVPP19msNICFwDMRpbJPBNrW
	 PAawRpfcz10A2XnNj3cOBLNuG1kdRMwA8jwICx1SPGHwYlgM1/r1plIfXmjyy0Os4/
	 aIyEqKbbDTEL0v24OhXNlmwSoPJS1J5MBZwxoGIIHXPu2r6ySQWxt+b/qRnVPJaa8z
	 GYMw7Bf+92oDYaQsuDi9uxn633WkpZeZ3nqcHf1v03WvQ3v2mXos6aFhs5mzAb5IjX
	 5+z1a0H6SWiW3QFtfLsgsiUYpatVZGj7Bioq8LS0evTLKY+0JsyToTcj4Dif7hkIAD
	 zJAMGg/mtkK5w==
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] btrfs: test setting attribute on nodatasum file that has inherited compression
Date: Mon, 12 Oct 2026 18:31:13 +0100
Message-ID: <0c27162bb8d0b8366afc37411da2ed794d33fc22.1791826238.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

Test that setting an attribute unrelated to compression on a file that has
inherited compression from its parent directory does not fail when the fs
is mounted with the nodatasum option.

This exercises a regression introduced in kernel 7.2 and that is fixed by
a patch with the following subject:

  "btrfs: fix chattr failing on nodatasum files that have the compress flag"

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/btrfs/360     | 37 +++++++++++++++++++++++++++++++++++++
 tests/btrfs/360.out |  2 ++
 2 files changed, 39 insertions(+)
 create mode 100755 tests/btrfs/360
 create mode 100644 tests/btrfs/360.out

diff --git a/tests/btrfs/360 b/tests/btrfs/360
new file mode 100755
index 00000000..84c4ba38
--- /dev/null
+++ b/tests/btrfs/360
@@ -0,0 +1,37 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
+#
+# FS QA Test 360
+#
+# Test that setting an attribute unrelated to compression on a file that has
+# inherited compression from its parent directory does not fail when the fs is
+# mounted with the nodatasum option.
+#
+. ./common/preamble
+_begin_fstest auto quick compress
+
+_fixed_by_kernel_commit xxxxxxxxxxxx \
+	"btrfs: fix chattr failing on nodatasum files that have the compress flag"
+
+_require_scratch
+_require_btrfs_no_nodatacow
+_require_chattr c
+_require_chattr A
+
+_scratch_mkfs >>$seqres.full 2>&1 || _fail "mkfs failed"
+_scratch_mount "-o nodatasum"
+
+mkdir $SCRATCH_MNT/dir
+# Set the compression attribute on the directory so that any file created inside
+# it will inherit compression.
+$CHATTR_PROG +c $SCRATCH_MNT/dir
+
+# File foo inherits compression from its parent directory.
+touch $SCRATCH_MNT/dir/foo
+
+# Now set some other attribute on file foo and check that it succeeds.
+$CHATTR_PROG +A $SCRATCH_MNT/dir/foo
+
+echo "Silence is golden"
+_exit 0
diff --git a/tests/btrfs/360.out b/tests/btrfs/360.out
new file mode 100644
index 00000000..aead0f88
--- /dev/null
+++ b/tests/btrfs/360.out
@@ -0,0 +1,2 @@
+QA output created by 360
+Silence is golden
-- 
2.53.0

