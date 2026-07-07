Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9DA13F7AA6
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Jul 2026 11:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783424454; cv=none; b=iz+30sD1/4C8AV1Xqi2dhEuxUriOySHBET1Kc/Xvh26/k1vPOSGDndfu3I/b7jN6Xqgf9M5tgHJH+Jg3pmb9RJOOC6v8ensrZ5D2oYcyorNZQMyVkmUx4KDnHVhudEkAD0OaTTsaLsrMeyqsB0JC3tlm7AY6dvnU6ofUwxrKlkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783424454; c=relaxed/simple;
	bh=y3y4Vq685yM3mbtFYtUYH0ti0py5gpYNf388SLEPQDQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=hWJ1SHu9GACDl2KbHf8DOWUYdYLHspJDb5DFTxewrSXELq58UC+wqqd6RKr7xKDtN5nwLkpeoasHKfY6ZM5bwP0IKgMJ1hkXFZV4kAzDjpTxF1NxzFszfR87jBjYRQTBEDY0mG7q8iyagFhgACxUq1paMX7xb6iFrNzQOIYQUfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=bCWqVnzx; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=bCWqVnzx; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="bCWqVnzx";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="bCWqVnzx"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 450D6740B8;
	Tue,  7 Jul 2026 11:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783424450; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=+PJ4+g1RZlGRQ9Xb0Yv8yZjrMjGnSqHrKzXZkXwuSME=;
	b=bCWqVnzx+O2EAZHiX2wVsDGO9LbftH2q7Ut9xrnJTlPkGFnTdM9KBXyJp2J1QX83JdWKnk
	KfNnlPoAPqxEz2v36nzboG55KfyOozpNxUEXFzJIfqpNKIHWH4mQDvYNgGih2PtQEQndOp
	UA1+qLTdRYmgH4VkkIxHhmaDl88THU4=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783424450; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=+PJ4+g1RZlGRQ9Xb0Yv8yZjrMjGnSqHrKzXZkXwuSME=;
	b=bCWqVnzx+O2EAZHiX2wVsDGO9LbftH2q7Ut9xrnJTlPkGFnTdM9KBXyJp2J1QX83JdWKnk
	KfNnlPoAPqxEz2v36nzboG55KfyOozpNxUEXFzJIfqpNKIHWH4mQDvYNgGih2PtQEQndOp
	UA1+qLTdRYmgH4VkkIxHhmaDl88THU4=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 00774779AE;
	Tue,  7 Jul 2026 11:40:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4vsIKcDlTGq6QgAAD6G6ig
	(envelope-from <wqu@suse.com>); Tue, 07 Jul 2026 11:40:48 +0000
From: Qu Wenruo <wqu@suse.com>
To: fstests@vger.kernel.org,
	linux-btrfs@vger.kernel.org
Subject: [PATCH v2] fstests: btrfs: new test case for leaking BTRFS_FS_STATE_REMOUNTING flag
Date: Tue,  7 Jul 2026 21:10:30 +0930
Message-ID: <20260707114030.120393-1-wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 

This is a regression test for the patch "btrfs: fix leaking
BTRFS_FS_STATE_REMOUNTING flag", where conflicting mount options can
cause btrfs leave BTRFS_FS_STATE_REMOUNTING set.

Such set BTRFS_FS_STATE_REMOUNTING will interrupt several features, and
the test case will use "btrfs qgroup rescan" to catch the
BTRFS_FS_STATE_REMOUNTING flag.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Changelog:
v2:
- Use _require_btrfs_fs_feature to replace open-coded check
  Although the file content check still requires a open-coded check.
  I do not think there will be another user to check supported rescue
  options any time soon.
---
 tests/btrfs/352     | 50 +++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/352.out |  2 ++
 2 files changed, 52 insertions(+)
 create mode 100755 tests/btrfs/352
 create mode 100644 tests/btrfs/352.out

diff --git a/tests/btrfs/352 b/tests/btrfs/352
new file mode 100755
index 00000000..1d40c09c
--- /dev/null
+++ b/tests/btrfs/352
@@ -0,0 +1,50 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
+#
+# FS QA Test 352
+#
+# A regression test to make sure failed remount won't leave
+# BTRFS_FS_STATE_REMOUNTING flag set, which can interrupt several features,
+# one of them is btrfs qgroup rescan.
+#
+. ./common/preamble
+_begin_fstest auto quick remount
+
+_fixed_by_kernel_commit XXXXXXXXXXXX \
+	"btrfs: fix leaking BTRFS_FS_STATE_REMOUNTING flag"
+
+_require_btrfs_fs_feature supported_rescue_options
+
+if ! grep -q "ignorebadroots" "/sys/fs/btrfs/features/supported_rescue_options"; then
+	_notrun "\"rescue=ignorebadroots\" mount option not supported"
+fi
+
+_require_btrfs_command quota rescan -w
+_require_scratch
+_scratch_mkfs >> $seqres.full
+_scratch_mount
+
+# Enable regular quota mode, and do a rescan.
+# Although the regression is affecting multiple features, qgroup rescan is the
+# easiest to verify.
+_btrfs quota enable $SCRATCH_MNT
+_btrfs quota rescan -w $SCRATCH_MNT
+
+# The following mount must fail, as the following rescue mount option requires
+# a full RO mount, thus it can not be set for the existing RW mount.
+_scratch_remount "rescue=ignorebadroots" >> $seqres.full 2>&1
+if [ $? -eq 0 ]; then
+	_fail "\"rescue=ignorebadroots\" is applied to RW mount unexpectedly"
+fi
+
+# For unpatched kernel, qgroup rescan will be interrupted immediately.
+_btrfs quota rescan -w $SCRATCH_MNT
+
+# We want capture the stderr output, so use $BTRFS_UTIL_PROG instead of _btrfs
+$BTRFS_UTIL_PROG qgroup show $SCRATCH_MNT >> $seqres.full
+
+echo "Silence is golden"
+
+# success, all done
+_exit 0
diff --git a/tests/btrfs/352.out b/tests/btrfs/352.out
new file mode 100644
index 00000000..11826ba5
--- /dev/null
+++ b/tests/btrfs/352.out
@@ -0,0 +1,2 @@
+QA output created by 352
+Silence is golden
-- 
2.51.2

