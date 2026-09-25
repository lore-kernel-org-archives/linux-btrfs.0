Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36B613AE1BC;
	Fri, 25 Sep 2026 16:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790355055; cv=none; b=OMvmBrzve+fUpl0vbfz7vO3MgfDkOCmMUGag0AjSpvixCDKD/pPkZnPJ/VrQJP9TAbFcrfehLnPa68RDHi5Tos7JbXYRG2odUDj76iip2aLZkGC4sno19oVgymKiKZtDVrqpX+vmRV14mB/g7p55jsM0AK/L8Nmu/SCCH3kMhlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790355055; c=relaxed/simple;
	bh=qGw/ns8BKlqeazX6UsFC0P0FZM2PdsV85GaHr/D2hOc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EFR/2wY/+RjNhNVr5QGeda4yUUbw/qHR7wCitzA2VQCIZGxU870cm6j/BYGrx+YawezBWTEe4n4I66oCjrFWIPyUx+TGj+KYmyZ9CagbQD/3JkVuIyH/X3w81RDSqOa9tn7OlWVswHmOe9PqRIBnjn5kfAtScpsLZy1mGkIxzsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UxuHXBCK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UxuHXBCK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 640CB1F00893;
	Fri, 25 Sep 2026 16:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790355051;
	bh=+ocbp023lvvpBmAsueB+RooN2GIs+B7oKo5b+YLp+jA=;
	h=From:To:Cc:Subject:Date;
	b=UxuHXBCK1PXO0xYCD1hqP/jwl8A9IPm2ujmCw9deDPB+aDERW8K6wN7kTMYLxdAc4
	 g1/MQdG7frAW26wh95YgV5Ewz4YV63Y7KAQowGGJ+7tTcAY32u42O5Bi1BeEh3oK/2
	 ZLPZynXHtyie0yqN5KoR3uyU1SC3p6nAcgITO4OeTDauolQSKzTUz7qHiekqqs6owb
	 jDdONpDhgzq5cbVppu8TNCKB2zCwXONlkO5m8H6j1IC30M0j7kh6Wl0R+eqLjMUEce
	 1hVdAjsUYMweTjRWDN+//QprOkOVoBsbz+4xHhgFFAr5PxNc4RZB9hq+G+YZg5Thb1
	 IeSrgV5phltIA==
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] generic: test replacing a xattr with a larger value
Date: Fri, 25 Sep 2026 17:50:46 +0100
Message-ID: <8916aea263bc59af6cfb1accacc2eaf78aaffe89.1790354960.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

Test that replacing a xattr's value with a larger value works. This is a
test that exercises a specific scenario on btrfs where two xattrs are
stored in the same item, and for that to happen their names must result
in the same crc32c hash.

This was recently fixed by the following patch:

  "btrfs: fix xattr replace when multiple xattrs are packed in the same item"

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/generic/806     | 43 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/806.out | 11 +++++++++++
 2 files changed, 54 insertions(+)
 create mode 100755 tests/generic/806
 create mode 100644 tests/generic/806.out

diff --git a/tests/generic/806 b/tests/generic/806
new file mode 100755
index 00000000..6d74f445
--- /dev/null
+++ b/tests/generic/806
@@ -0,0 +1,43 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
+#
+# FS QA Test 806
+#
+# Test replacing a xattr's value with a larger value.
+#
+. ./common/preamble
+_begin_fstest auto quick metadata attr
+
+. ./common/filter
+. ./common/attr
+
+_require_scratch
+_require_attrs
+
+fixed_by_fs_commit btrfs xxxxxxxxxxxx \
+   "btrfs: fix xattr replace when multiple xattrs are packed in the same item"
+
+_scratch_mkfs >>$seqres.full 2>&1 || _fail "mkfs failed"
+_scratch_mount
+
+touch $SCRATCH_MNT/testfile
+
+# Add two xattrs that, on btrfs, have the same hash (crc32c) for their name
+# and therefore are packed into the same btrfs_dir_item.
+$SETFATTR_PROG -n user.foobar -v 123 $SCRATCH_MNT/testfile
+$SETFATTR_PROG -n user.WvG1c1Td -v qwerty $SCRATCH_MNT/testfile
+
+# Verify the xattrs are present.
+echo "xattrs before:"
+_getfattr --absolute-names --dump $SCRATCH_MNT/testfile | _filter_scratch
+
+# Now replace the value of the foobar xattr with a significantly larger value.
+$SETFATTR_PROG -n user.foobar -v abcdefghijklmnopqrstuvwxyz $SCRATCH_MNT/testfile
+
+# Check the xattrs have the expected values.
+echo "xattrs after:"
+_getfattr --absolute-names --dump $SCRATCH_MNT/testfile | _filter_scratch
+
+# success, all done
+_exit 0
diff --git a/tests/generic/806.out b/tests/generic/806.out
new file mode 100644
index 00000000..620a953e
--- /dev/null
+++ b/tests/generic/806.out
@@ -0,0 +1,11 @@
+QA output created by 806
+xattrs before:
+# file: SCRATCH_MNT/testfile
+user.WvG1c1Td="qwerty"
+user.foobar="123"
+
+xattrs after:
+# file: SCRATCH_MNT/testfile
+user.WvG1c1Td="qwerty"
+user.foobar="abcdefghijklmnopqrstuvwxyz"
+
-- 
2.47.2

