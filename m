Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11BEE46AED1;
	Sun, 11 Oct 2026 23:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791760069; cv=none; b=e3yWtPmw4AqicnNyvBFhhvFGPJmJeHetTNWucgfM7DipUeK2QDQViHDpS/0l2Ye8uE8D3N16uwbYbdhxDTjqCBbkoFG1gYY0WEFoVuadT4mbu+6bGanwu9VJy5rm9ObHFu5heTx9+kO9mgCRjlxw6+dVV/g5TBKCaxgu7K1tjjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791760069; c=relaxed/simple;
	bh=wTUcoaooCGpWK9DcCeN7rOdQklu4Ed77T5mGoahW2QU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=WT8TiT8jks8QjirU4al1pr0+xel8L9DhcTi8CPTAjgNy4I/9Cr8Suifd1LxikSZ0PPRMrdOwxeMB1RIAB9FqWeecIgqywSEP5O8jYUoXsOlWHJRTG+s0OtBgT7HepI29ACvqAGsp8+j29QrXvrpLqhkLQlaTJ8xyWvlkTIijvQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=EAonVRPy; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=EAonVRPy; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="EAonVRPy";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="EAonVRPy"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D7F5C21E2F;
	Sun, 11 Oct 2026 23:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791760064; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=ih3u3637LYMFs46cx2BtyrLir/Gb82cGgbDN0GAiC2E=;
	b=EAonVRPy39BvZ65TH7WXlj7gXzxe3R508SzqCT02EmZHTAYGYYwd1M9lKdLvdA8jTPwCna
	a8eMuZprje60HfAKEBkK/T2/RZorSb6uHmL/1xx7wp/IMLE4n+C45hTyt/g3bSFyvglb/c
	wVBfTeA6qBBwTgETJbGM2xBVrFBX9jI=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791760064; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=ih3u3637LYMFs46cx2BtyrLir/Gb82cGgbDN0GAiC2E=;
	b=EAonVRPy39BvZ65TH7WXlj7gXzxe3R508SzqCT02EmZHTAYGYYwd1M9lKdLvdA8jTPwCna
	a8eMuZprje60HfAKEBkK/T2/RZorSb6uHmL/1xx7wp/IMLE4n+C45hTyt/g3bSFyvglb/c
	wVBfTeA6qBBwTgETJbGM2xBVrFBX9jI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5E83D13408;
	Sun, 11 Oct 2026 23:07:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6XaHKr4WzGo4ZwAAD6G6ig
	(envelope-from <wqu@suse.com>); Sun, 11 Oct 2026 23:07:43 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH] fstests: btrfs: test if btrfs control file rejects unknown ioctls
Date: Mon, 12 Oct 2026 09:37:16 +1030
Message-ID: <20261011230716.16860-1-wqu@suse.com>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[]

This is a regression test for a recent bug fix, where unsupported ioctls
are not properly rejected for btrfs control file (normally at
"/dev/btrfs-control").

The test case itself is super simple, which doesn't even require test or
scratch device, it just run the "btrfs_ioctl" program using
"get_subvol_info" ioctl on "/dev/btrfs-control", which should fail as
that ioctl only makes sense on a mounted btrfs, not the btrfs control
file.

The error will be outputted to the golden output so that we can catch
any unexpected success.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 tests/btrfs/359     | 26 ++++++++++++++++++++++++++
 tests/btrfs/359.out |  2 ++
 2 files changed, 28 insertions(+)
 create mode 100755 tests/btrfs/359
 create mode 100644 tests/btrfs/359.out

diff --git a/tests/btrfs/359 b/tests/btrfs/359
new file mode 100755
index 00000000..46457f57
--- /dev/null
+++ b/tests/btrfs/359
@@ -0,0 +1,26 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
+#
+# FS QA Test 359
+#
+# Make sure the btrfs control file (/dev/btrfs-control) properly rejects
+# an unsupported ioctl.
+#
+. ./common/preamble
+_begin_fstest auto quick ioctl
+
+_fixed_by_kernel_commit xxxxxxxxxxxx \
+	"btrfs: return -ENOTTY for unknown ioctls on the control device"
+
+_require_test_program btrfs_ioctl
+
+path="/dev/btrfs-control"
+if [ ! -c "$path" ]; then
+	_notrun "No btrfs control file at \"$path\""
+fi
+
+# This should fail with -ENOTTY error.
+$here/src/btrfs_ioctl get_subvol_info "$path" >> $seqres.full
+
+_exit 0
diff --git a/tests/btrfs/359.out b/tests/btrfs/359.out
new file mode 100644
index 00000000..89090e22
--- /dev/null
+++ b/tests/btrfs/359.out
@@ -0,0 +1,2 @@
+QA output created by 359
+ioctl failed: Inappropriate ioctl for device
-- 
2.56.0

