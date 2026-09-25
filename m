Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A000F4A1DEF
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Sep 2026 17:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790356545; cv=none; b=IXIwsw4d1IPfGj8jCnzrZV0fPQiNiucDcxxFUFG8jncCNBVBxnoy2Z1p8zGV/aKWNzCUfy+K/AIbxk9sSKtLEXLpBz4ZwqaslQNI8EwWPOFUCZ/uomYJ/U0fX5KfP8pHdHo79WC42RK+OFTuKEyDoBEjjPivBwtUmIvjkpOkxYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790356545; c=relaxed/simple;
	bh=WFjxR3hl+dWVXkAaDsxVzLPnEzrsHaz2EqlLH5TSAx8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n0j2hs4Hf6nNiX+THVrRpn5Sz170O1EaOeRl4YKu/lbwjpxX+9n3vTIJg7leJvfYKF40jJMRlyz5+iQlmrg+qdwsv/86IdZi9oAWCLbCum5cuG5p7iSnr52MZg86cmqQuPN/I3nGgzE2eaBYP1m9fqrPew4vY9CeVNcxA9LDRZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BLXw9LwS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BLXw9LwS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 693581F000FF
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Sep 2026 17:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790356537;
	bh=m2fR7RmLMT11qnBJhK/zlBKTwQpIyJTeMjt1NWOMOss=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=BLXw9LwSpF94VklLC7c+l+TVmHfsYYbOuhifE6M1NDcU2jEh1kqROu8y8MzpuPEGy
	 0OKkhnB+OwQ3ZNW/ajJVmXhPETEIZb7gWh/efFy5SLqUceb3SOHQrhuGyAKpwkXj2r
	 KBc0To6eBoCXswcDOZyH3TyABxSyOKJuhZLoOjONCvgN1//UFHLof2MmipXhfkKv36
	 o/zRB62131CWIDKyyiRuM+BHr19akHxric7dBC2lLturaRvCRbTVO9aMHzTQMSJVwO
	 BrZe6GI0hDz3y8qdK4ghAQ6ivuAGjxbyfF9OUaKdtsOedSjV4uBE4uj7T0Ttecl1z/
	 oxeV9UqkIqbSw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] generic: test replacing a xattr with a larger value
Date: Fri, 25 Sep 2026 18:15:35 +0100
Message-ID: <7d2caec7b8ecd95ad63fcbbc7e1cc1c84ee50d7f.1790356355.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <8916aea263bc59af6cfb1accacc2eaf78aaffe89.1790354960.git.fdmanana@suse.com>
References: <8916aea263bc59af6cfb1accacc2eaf78aaffe89.1790354960.git.fdmanana@suse.com>
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

V2: Fix missing _ on _fixed_by_fs_commit call.

 tests/generic/806     | 43 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/806.out | 11 +++++++++++
 2 files changed, 54 insertions(+)
 create mode 100755 tests/generic/806
 create mode 100644 tests/generic/806.out

diff --git a/tests/generic/806 b/tests/generic/806
new file mode 100755
index 00000000..1fcf0145
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
+_fixed_by_fs_commit btrfs xxxxxxxxxxxx \
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

