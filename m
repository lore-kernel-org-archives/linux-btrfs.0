Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951B3331ED5;
	Sat, 10 Oct 2026 09:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791623088; cv=none; b=PSV2a4IMJqGPbt6IKO4ymzKqL9QUvpeZcwkCM9hXt0SaFi1XKfwPzNZMFTivF4uXzqd5ptcCyp+Dwb3B6so/f75/xlO+ECupsijE1fuIIrGBxeTTPvR0zjJztRjvgb25oXQn6OyJXzONuc/yrhd0MBiwLSi2XaDG1g0KwwYWKsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791623088; c=relaxed/simple;
	bh=jQTXPp1rH07ts20LkA181vM2lobDaOVeAB+9V1Sm27w=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=OoYoVCDbF1BCic002fpTcfsxbQ68ytHzQg7lQZKige2eJ8wvYwbqixKBpabcmLsXsPed+/PnD5hcgEf72m5bHOAJDowGheglWts9TifiHhA0Pfhv9jXk+8+5qtZ3tsliwtwdsjFCuYmhaXDYDTGLA1S41E3xrLG99gQ4aM9Gdws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=vTrW5rjs; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=nhr02LM6; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="vTrW5rjs";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="nhr02LM6"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 770831F388;
	Sat, 10 Oct 2026 09:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791623084; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=SaxexIkoeW4OeZZXsx6q4jzPvvYyfX3/ArS70U7xZ1A=;
	b=vTrW5rjsip3Z/LD0SIzV+lZwboRiJRCn+bHr1h1sGjrokesLBrNBV9DnlSe1qye4d5Hjr0
	sn2eVdDj9gVALVu1oKvLtn6DZKx5xlrAUJYE7hGU7tWmwu/ycyO4UJWkoCGANfRXpqhmDO
	AV7yKGWFIu7hr6io+C5aBBgorPPNWe4=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791623083; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=SaxexIkoeW4OeZZXsx6q4jzPvvYyfX3/ArS70U7xZ1A=;
	b=nhr02LM6+UEGY5jAbH3nJvnYRLkA7+37atn3nfBpn6LtmEW9m8NpelHz61BtQFPKvOKdjd
	jUVZjX4ygMSo1hlM+meogX7OvxXHzG/j2g+/bRRMsdGl15HRxKAjxH1q+zapbOh9iGShnU
	jMGzFC6Ue/YxlArCRvQA4Nu5PxW7mOU=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 935911326D;
	Sat, 10 Oct 2026 09:04:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QVt+L6j/yWrXDAAAD6G6ig
	(envelope-from <wqu@suse.com>); Sat, 10 Oct 2026 09:04:41 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH v2] fstests: generic: add a test case to check fsverity reads
Date: Sat, 10 Oct 2026 19:34:22 +1030
Message-ID: <20261010090422.59743-1-wqu@suse.com>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spam-Flag: NO

There is a bug report that with the recently enabled large folios
support, fsverity enabled files on btrfs can trigger reproducible
warnings about file corruption, but in the end no error is returned to
user space.

It turns out to be a bug in the btrfs fsverity integration, where blocks
not included in the read range are passed to be verified.

This is a long-standing bug where btrfs fsverity always assumed that one
folio contains exactly one fs block, ignoring the fact that btrfs had
block size < page size support before fsverity support was added.

Add a new regression test case for it. The workload is pretty simple:

- Create a 32M file

- Punch a 64K hole for every 128K
  This will limit the read bio size to 64K, which is smaller than
  a lot of large folios, and thus can trigger the btrfs bug.

- Enable fsverity digest and drop page cache

- Read that file

- Verify there is no "FILE CORRUPTED!" warning

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Changelog
v2:
- Do not use btrfs specific mount options to limit read bio size
  Use holes to limit the size of read bios instead, now the test case
  can be generic other than btrfs specific.

- Add the missing _require_check_dmesg call

v1:
https://lore.kernel.org/linux-btrfs/20261010032508.36935-1-wqu@suse.com/
---
 tests/generic/807     | 56 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/807.out |  2 ++
 2 files changed, 58 insertions(+)
 create mode 100755 tests/generic/807
 create mode 100644 tests/generic/807.out

diff --git a/tests/generic/807 b/tests/generic/807
new file mode 100755
index 00000000..24e22e8c
--- /dev/null
+++ b/tests/generic/807
@@ -0,0 +1,56 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
+#
+# FS QA Test 807
+#
+# Verify that reading a large file with holes won't trigger fsverity warnings
+#
+. ./common/preamble
+_begin_fstest auto quick verity
+
+_fixed_by_fs_commit btrfs xxxxxxxxxxxx \
+	"btrfs: fix the fsverity callback where unexpected range is verified"
+
+. ./common/verity
+
+_require_xfs_io_command "fpunch"
+_require_check_dmesg
+_require_scratch_verity
+
+filesize=$(( 32 * 1024 * 1024 ))
+interval=$(( 128 * 1024 ))
+holesize=$(( 64 * 1024 ))
+
+_scratch_mkfs_verity >> $seqres.full
+_scratch_mount
+
+# Create a large enough file so that readahead is triggered, and
+# large folios are allocated during readahead.
+_pwrite_byte "0xcd" 0 "$filesize" "$SCRATCH_MNT/foobar" > /dev/null
+
+# Create a hole for every $interval bytes. This should limit the read to
+# $(( $interval - $holesize)), which should be much smaller than the maximum
+# folio size (2M for x86_64).
+for (( i = 0; i < $(( $filesize / $interval )); i++ )); do
+	$XFS_IO_PROG -c "fpunch $(( $i * $interval )) $holesize" \
+		"$SCRATCH_MNT/foobar" > /dev/null
+done
+
+_fsv_enable "$SCRATCH_MNT/foobar"
+
+# Cycle mount to drop page cache
+_scratch_cycle_mount
+
+# Read the file, unpatched btrfs will verify blocks outside the read range and
+# trigger fs-verity warnings.
+# But the read itself should still be fine, as the failed part will be retried.
+cat "$SCRATCH_MNT/foobar" > /dev/null
+
+# Check for any kernel warnings from fs-verity on file corruption.
+if _check_dmesg_for "FILE CORRUPTED!"; then
+	echo "fs-verity detected corruption"
+fi
+echo "Silence is golden"
+
+_exit 0
diff --git a/tests/generic/807.out b/tests/generic/807.out
new file mode 100644
index 00000000..3752a5f7
--- /dev/null
+++ b/tests/generic/807.out
@@ -0,0 +1,2 @@
+QA output created by 807
+Silence is golden
-- 
2.56.0

