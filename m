Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 259823C0621;
	Sat, 10 Oct 2026 03:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791602744; cv=none; b=m/sHjKctba8XZALKP0DWzF0E6B0EjUTpGAMkh9G1ZXYpg6nqCJ5HFhIYFH4qrAXerLHR6LKvIy0iXYnAqIzmrG20TRtNPqX7ORz+0gT4lsNgFgON2/odlB8HTVszLP+uKNZxkGQ+TH5YAPNJTCh/xO7Agi0FHreIf7U3yxAV7b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791602744; c=relaxed/simple;
	bh=nBexOR2WuYmTcu6491ggksEg67z8yp8mbPNMbwJzxSU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=VyG+S5rwyeHVSgXLAuqZRNbzxQqWmsmEkeUj+YbaSyHeSPOz58MJeDFR7sT8Lr8I4urYHXDc1xJHz1ViERva3sWCEcA/EiWH3emtBbbePCj9It0xRu2x3e3GQ1D9iUG/xKu0+L+jBtkijm5DuWeOs3uFH5lCniff2K5GYzkEQyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=g7BIAA4H; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=g7BIAA4H; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="g7BIAA4H";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="g7BIAA4H"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EAD8B1F7CB;
	Sat, 10 Oct 2026 03:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791602738; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=yGd5PSWnSswVwv55NdkcXTI7APoFgmjY0WMMohECnZ0=;
	b=g7BIAA4H22+tJdiSP5LVraxov2Bf4v2DduEE1jmAorR3WURbqEp9ZIhDzX8reXjY1EKIy8
	mleytVqwOwXZrVlCWzjStS+AckMvR0ecOY8VcCjpGRppbApT0CI+YHyxTaGvcx1JTSA1RV
	Qpl6LIuRCDcu2gAw2wIFPfW8APfCC4M=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=g7BIAA4H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791602738; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=yGd5PSWnSswVwv55NdkcXTI7APoFgmjY0WMMohECnZ0=;
	b=g7BIAA4H22+tJdiSP5LVraxov2Bf4v2DduEE1jmAorR3WURbqEp9ZIhDzX8reXjY1EKIy8
	mleytVqwOwXZrVlCWzjStS+AckMvR0ecOY8VcCjpGRppbApT0CI+YHyxTaGvcx1JTSA1RV
	Qpl6LIuRCDcu2gAw2wIFPfW8APfCC4M=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B3F5A1326D;
	Sat, 10 Oct 2026 03:25:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id T5VAFi6wyWptPQAAD6G6ig
	(envelope-from <wqu@suse.com>); Sat, 10 Oct 2026 03:25:34 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH] fstests: btrfs: add a test case to verify fsverity on compressed files
Date: Sat, 10 Oct 2026 13:55:08 +1030
Message-ID: <20261010032508.36935-1-wqu@suse.com>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: EAD8B1F7CB
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	ARC_NA(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Flag: NO
X-Spam-Score: -3.01

There is a bug report that with the recently enabled large folios
support, compressed files on btrfs can give random but reproducible
warnings about file corruption.

It turns out to be a bug in the verification range, where blocks not
included in the read range are passed to be verified.

Add a new regression test case for it, the workload is pretty simple:

- Create a 64M file with compressed file extents
- Enable fsverity digest on that file
- Drop page cache
- Read that file
- Verify there is no "FILE CORRUPTED!" warning

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 tests/btrfs/359     | 45 +++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/359.out |  6 ++++++
 2 files changed, 51 insertions(+)
 create mode 100755 tests/btrfs/359
 create mode 100644 tests/btrfs/359.out

diff --git a/tests/btrfs/359 b/tests/btrfs/359
new file mode 100755
index 00000000..2047d965
--- /dev/null
+++ b/tests/btrfs/359
@@ -0,0 +1,45 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
+#
+# FS QA Test 359
+#
+# Test if btrfs handles fsverity read correctly without corruption warning
+#
+. ./common/preamble
+_begin_fstest auto quick verity compress
+
+_fixed_by_kernel_commit xxxxxxxxxxxx \
+	"btrfs: fix the fsverity callback where unexpected range is verified"
+
+. ./common/filter
+. ./common/verity
+
+_require_scratch_verity
+
+_scratch_mkfs_verity >> $seqres.full
+
+# We need a read range that doesn't cover the full folio, the easiest way
+# to create such read is compression, which limits the extent size to 128K,
+# much smaller than the supported large folio size (256K or 2M for 4K page size).
+_scratch_mount -o compress
+
+# Create a large enough file that can contain multiple compressed file extents.
+_pwrite_byte "0xcd" 0 64m "$SCRATCH_MNT/foobar" | _filter_xfs_io
+
+# Enable verity on that file
+_fsv_enable "$SCRATCH_MNT/foobar"
+
+# Cycle mount to drop page cache
+_scratch_cycle_mount
+
+# Read the file, unpatched kernel will race and trigger fs-verity warnings.
+# But the read itself should still be fine, as the failed part will be retried.
+_hexdump "$SCRATCH_MNT/foobar"
+
+# Check for any kernel warnings from fs-verity on file corruption.
+if _check_dmesg_for "FILE CORRUPTED!"; then
+	echo "fs-verity detected corruption"
+fi
+
+_exit 0
diff --git a/tests/btrfs/359.out b/tests/btrfs/359.out
new file mode 100644
index 00000000..96bd78d7
--- /dev/null
+++ b/tests/btrfs/359.out
@@ -0,0 +1,6 @@
+QA output created by 359
+wrote 67108864/67108864 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+000000 cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd  >................<
+*
+4000000
-- 
2.56.0

