Received: from mail.synology.com (mail.synology.com [211.23.38.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 830C925783C;
	Fri, 17 Apr 2026 07:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.23.38.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776409722; cv=none; b=All4OHduMMhC/auOysGNCrwkwQ3CxHQQdXWP1NluNTCWBo10UCgqdDI+lHCe/TJh5OWrI6guIzfM2mT3nHe08QjLCWcfSlVCGcerJtLjl5pud3yZ5ljteZjG13WLrAqr53B7Fik96BQL0y4C778cR1W711zyiGUhpL6V3T8qZqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776409722; c=relaxed/simple;
	bh=FQuR66YezmaipOoh529nhMhomVO+0wsppAVeavJZA20=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=eLxkFFTvPCbCAU0G/KLu0eX8ZqWsbIjloOF+zp9Mv11c3GlQGh7VFMxhuYeBowWFMcT82/eC77Vi6R8wJLJapykpMli1lqR+rmHyDfBSmSBh57USoyWpDH+Ud1Pa71DXCfU9MqjbMBmhssPrMdc730gbYjzdD6STsjeJalM6MPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com; spf=pass smtp.mailfrom=synology.com; dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b=g31yER8H; arc=none smtp.client-ip=211.23.38.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=synology.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="g31yER8H"
Received: from 10511-DT-003.. (unknown [10.17.46.51])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.synology.com (Postfix) with ESMTPSA id 4fxmFL42NbzJ14RyG;
	Fri, 17 Apr 2026 15:08:38 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
	t=1776409718; bh=FQuR66YezmaipOoh529nhMhomVO+0wsppAVeavJZA20=;
	h=From:To:Cc:Subject:Date;
	b=g31yER8HI4OlM0HjmgDkOqZL0eku4l9p7ESmvBtxaQmzdLWuujKmLwJmAL2fFMMTR
	 ev0Mkzv6JpnGm0e2sPR9kccwrzvruOnhPxSKLmkvVGHncFCN91+5yNaL3jPsBtemi+
	 8o5S8R2kD1mf8oo925UXChs5q+2WDa+NXxpon28k=
From: tchou <tchou@synology.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	Ting-Chang Hou <tchou@synology.com>
Subject: [PATCH] btrfs: regression test for duplicated rmdir in incremental send with extrefs
Date: Fri, 17 Apr 2026 15:07:37 +0800
Message-Id: <20260417070737.1318926-1-tchou@synology.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Synology-Spam-Flag: no
X-Synology-Virus-Status: no
X-Synology-MCP-Status: no
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
Content-Type: text/plain

From: Ting-Chang Hou <tchou@synology.com>

Regression test for btrfs incremental send issue where duplicated rmdir
instructions were sent when using INODE_EXTREF. This happens when there
are many hardlinks to the same file across two directories, causing the
INODE_EXTREF items to interleave between directories.

This issue is fixed by the following linux kernel btrfs patch:

commit 1fabe43b4e1a ("btrfs: send: fix duplicated rmdir operations when using extrefs")

Signed-off-by: Ting-Chang Hou <tchou@synology.com>
---
 tests/btrfs/348     | 99 +++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/348.out |  1 +
 2 files changed, 100 insertions(+)
 create mode 100755 tests/btrfs/348
 create mode 100644 tests/btrfs/348.out

diff --git a/tests/btrfs/348 b/tests/btrfs/348
new file mode 100755
index 00000000..6e887e77
--- /dev/null
+++ b/tests/btrfs/348
@@ -0,0 +1,99 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2025 Synology Inc.  All Rights Reserved.
+#
+# FS QA Test No. btrfs/348
+#
+# Regression test for btrfs incremental send issue where duplicated rmdir
+# instructions were sent when using INODE_EXTREF. This happens when there
+# are many hardlinks to the same file across two directories, causing the
+# INODE_EXTREF items to interleave between directories. The original fix
+# in commit 29d6d30f5c8a ("Btrfs: send, don't send rmdir for same target
+# multiple times") only handled consecutive rmdir operations for the same
+# directory, but failed when rmdir operations were not consecutive due to
+# the interleaved INODE_EXTREF ordering.
+#
+# This issue is fixed by the following linux kernel btrfs patch:
+#
+#   commit 1fabe43b4e1a ("btrfs: send: fix duplicated rmdir operations when using extrefs")
+#
+. ./common/preamble
+_begin_fstest auto quick send
+
+tmp=`mktemp -d`
+
+# Override the default cleanup function.
+_cleanup()
+{
+	rm -fr $tmp
+}
+
+. ./common/filter
+
+_require_scratch
+_require_fssum
+
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+mkdir $SCRATCH_MNT/a $SCRATCH_MNT/b
+
+echo 123 > $SCRATCH_MNT/a/foo
+
+# Create enough hardlinks to trigger INODE_EXTREF usage.
+# When hardlinks exceed what a single INODE_REF item can hold,
+# INODE_EXTREF is used. The key of INODE_EXTREF includes a hash
+# of the name and parent inode, causing items from different
+# directories to interleave.
+for ((i = 1; i <= 1000; i++)); do
+	ln $SCRATCH_MNT/a/foo $SCRATCH_MNT/a/foo.$i
+	ln $SCRATCH_MNT/a/foo $SCRATCH_MNT/b/foo.$i
+done
+
+# Filesystem looks like:
+#
+# .                              (ino 256)
+# |-- a/                         (ino 257)
+# |   |-- foo                    (ino 259)
+# |   |-- foo.1 ... foo.1000     (ino 259, hardlinks)
+# |
+# |-- b/                         (ino 258)
+#     |-- foo.1 ... foo.1000     (ino 259, hardlinks)
+
+_btrfs subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/snap1
+
+rm -r $SCRATCH_MNT/a $SCRATCH_MNT/b
+
+# Filesystem now looks like:
+#
+# .                              (ino 256)
+# |-- snap1/                     (read-only snapshot)
+
+_btrfs subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/snap2
+
+run_check $FSSUM_PROG -A -f -w $tmp/1.fssum $SCRATCH_MNT/snap1
+run_check $FSSUM_PROG -A -f -w $tmp/2.fssum -x $SCRATCH_MNT/snap2/snap1 \
+	$SCRATCH_MNT/snap2
+
+_btrfs send -f $tmp/1.snap $SCRATCH_MNT/snap1
+_btrfs send -p $SCRATCH_MNT/snap1 -f $tmp/2.snap $SCRATCH_MNT/snap2
+
+_scratch_unmount
+_check_btrfs_filesystem $SCRATCH_DEV
+
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+_btrfs receive -f $tmp/1.snap $SCRATCH_MNT
+run_check $FSSUM_PROG -r $tmp/1.fssum $SCRATCH_MNT/snap1
+
+# This used to fail with:
+# ERROR: rmdir o<ino>-<gen>-0 failed: No such file or directory
+_btrfs receive -f $tmp/2.snap $SCRATCH_MNT
+run_check $FSSUM_PROG -r $tmp/2.fssum $SCRATCH_MNT/snap2
+
+_scratch_unmount
+_check_btrfs_filesystem $SCRATCH_DEV
+
+status=0
+exit
diff --git a/tests/btrfs/348.out b/tests/btrfs/348.out
new file mode 100644
index 00000000..f5e0b75a
--- /dev/null
+++ b/tests/btrfs/348.out
@@ -0,0 +1 @@
+QA output created by 348
--
2.34.1


Disclaimer: The contents of this e-mail message and any attachments are confidential and are intended solely for addressee. The information may also be legally privileged. This transmission is sent in trust, for the sole purpose of delivery to the intended recipient. If you have received this transmission in error, any use, reproduction or dissemination of this transmission is strictly prohibited. If you are not the intended recipient, please immediately notify the sender by reply e-mail or phone and delete this message and its attachments, if any.
