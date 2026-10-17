Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE2473F1ABE;
	Sat, 17 Oct 2026 09:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792227849; cv=none; b=dtxgd3w2hjwDLzH3VCwwpvx2CeQeY/5QWLyWTyYvTrkO+dilFFp1TVtUywl9FSzabODbnd0EPsCqdBAm0Q6uLIHoDUXYlYC2x5BNZqUn6SmVpSSWmzhHYKOLcZZ8KRTSfnRGWfqlr4n6Dnmel1a7DUuBnAG+cCZXBKl+uRoE29Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792227849; c=relaxed/simple;
	bh=lz0GsTPA+3iW46pKNTTm6B2kS/4MbtaXuX+tqmhhrgk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PINiDtvm/0oSuSJ8MY5Cos6/N9BeRM9eMA//GdjeTXuOV3K61lE06G8PUKrgM0YBkf9htPm3I3tuBQJcoGNV4yKeX8oLm9G936WN0m0g629pGVy2GxPbHgxDNO9Xm9MGFM0Y4uE8gW+HKmfvKDtwkI8Bz3+MUlnLEvLzba4n6g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=GlHBun7k; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=GlHBun7k; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="GlHBun7k";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="GlHBun7k"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 059571F747;
	Sat, 17 Oct 2026 09:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792227843; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=QVobapDrWbXN4UzNk2eIR9AG35N5cQ8prywvZ6HdP6o=;
	b=GlHBun7kh4pUBU9Ntjh1JB4sPLI47G1y2slrZfCbnIkm+mUl7TD6xUO2QxuMx/BiEj7fKo
	9lH3Y2cERfOZia7vnPbfKyfeTBh4ZPvYGvSvvNAYUO/1SE0jpTf12eYi9ugKPOzTsXh9DK
	18wuLHak/cNoDxXm+xCpzVKd2yZzx00=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792227843; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=QVobapDrWbXN4UzNk2eIR9AG35N5cQ8prywvZ6HdP6o=;
	b=GlHBun7kh4pUBU9Ntjh1JB4sPLI47G1y2slrZfCbnIkm+mUl7TD6xUO2QxuMx/BiEj7fKo
	9lH3Y2cERfOZia7vnPbfKyfeTBh4ZPvYGvSvvNAYUO/1SE0jpTf12eYi9ugKPOzTsXh9DK
	18wuLHak/cNoDxXm+xCpzVKd2yZzx00=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DAFAE133A7;
	Sat, 17 Oct 2026 09:04:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id y36pGf8502oCSwAAD6G6ig
	(envelope-from <wqu@suse.com>); Sat, 17 Oct 2026 09:04:00 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org,
	fstests@vger.kernel.org
Cc: ebiggers@kernel.org
Subject: [PATCH v4] fstests: generic: add a test case to check fsverity reads
Date: Sat, 17 Oct 2026 19:33:41 +1030
Message-ID: <20261017090341.72079-1-wqu@suse.com>
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
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	ARC_NA(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email]

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

- Read that file and verify its content

- Verify there is no "FILE CORRUPTED!" warning

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Changelog
v4:
- Also output the checksum for the file for content verification

- Update the comment to show the requirement more clearly
  It requires the folio size larger than the fs block size.

  This means either a system with larger page size (e.g. 64K page sized
  arm64 with 4K block size), or large folio support (which requires
  transparent huge page).

- Minor comment updates
  * Concentrate the mention of large folio to the triggering part
  * Explain why fserror is not utilized for error detection

v3:
- Disable signature verification temporarily for the test
  Pointed out by Dhruva, as it's a user configurable behavior that if
  signature is required, reading the file without a signature will lead
  to an EPERM error.

v2:
- Do not use btrfs specific mount options to limit read bio size
  Use holes to limit the size of read bios instead, now the test case
  can be generic other than btrfs specific.

- Add the missing _require_check_dmesg call
---
 tests/generic/807     | 72 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/807.out |  2 ++
 2 files changed, 74 insertions(+)
 create mode 100755 tests/generic/807
 create mode 100644 tests/generic/807.out

diff --git a/tests/generic/807 b/tests/generic/807
new file mode 100755
index 00000000..db3c6fbb
--- /dev/null
+++ b/tests/generic/807
@@ -0,0 +1,72 @@
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
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	_restore_fsverity_signatures
+	rm -f $tmp.*
+}
+
+_require_xfs_io_command "fpunch"
+_require_check_dmesg
+_require_scratch_verity
+_disable_fsverity_signatures
+
+filesize=$(( 32 * 1024 * 1024 ))
+interval=$(( 128 * 1024 ))
+holesize=$(( 64 * 1024 ))
+
+_scratch_mkfs_verity >> $seqres.full
+_scratch_mount
+
+# Create a large enough file so that readahead is triggered.
+_pwrite_byte "0xcd" 0 "$filesize" "$SCRATCH_MNT/foobar" > /dev/null
+
+# Create a hole for every $interval bytes. This should limit the read to
+# $(( $interval - $holesize )), which should be much smaller than the maximum
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
+#
+# This warning is triggered when the folio size is larger than the fs block
+# size, either from block size < page size (e.g. 4K block size on 64K page
+# size systems), or from large folios (requires transparent huge page).
+#
+# But the read itself should still be fine, as the failed part will be retried.
+_md5_checksum "$SCRATCH_MNT/foobar"
+
+# Check for any kernel warnings from fs-verity on file corruption.
+#
+# Using fserror would be more reliable, but unfortunately btrfs doesn't fully
+# support it yet, and the fserror support for fsverity is not available in v7.2,
+# where large folios made this easy to trigger.
+if _check_dmesg_for "FILE CORRUPTED!"; then
+	echo "fs-verity detected corruption"
+fi
+
+_exit 0
diff --git a/tests/generic/807.out b/tests/generic/807.out
new file mode 100644
index 00000000..744d48c9
--- /dev/null
+++ b/tests/generic/807.out
@@ -0,0 +1,2 @@
+QA output created by 807
+9ff4ff01a9e149fcd1c36314ea42102c
-- 
2.56.0

