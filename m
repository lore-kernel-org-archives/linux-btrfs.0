Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 362DA3F8231
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Jul 2026 11:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783424122; cv=none; b=hNTtZz17xlDwl/hXaTIhqemPOyqVWS54B/dhSfE1j6gFCO8rMiciQ4bnBRxDXDlD3yR130y3tLAVBGT1HIqU17LDcrDe5jAd1VFknAEVeosYWUX1iBZ6gMJe1EK5uJp7aRix2V9Nim39iWImEgDFwMEYJzoog5Xqx00HRFhmsEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783424122; c=relaxed/simple;
	bh=5d2zFAe6ItSsAyEpmj0qESXQqZlubCCk7t5qBjtzPlk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=J+VrcIz4MvXrxfmHckUqoTY8ibMs+U976dFGuRraNRHpe3v7WQzU/UQA3qYu2tpLrL3XxVsEOpU1uiiRBibHAcRl5Unb0zGk4xPB8xOvRDehwohhEpdLKm1WyPvQPcNUIEuPzbmCygp0k6zZDRDOsw/Qu63k9YvWLBk1etbqueM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=APr0pM3M; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=APr0pM3M; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="APr0pM3M";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="APr0pM3M"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 78AC17409B;
	Tue,  7 Jul 2026 11:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783424118; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=zNprTdV7Wue5Q9FgZe4Ben/0b/M07q+frIOSYYirG1U=;
	b=APr0pM3MR2jKsNTj8fSkrYY3gYVhD/sYh41aLoIpBvl/K3cOLG25I3CzG4Ev3YugzfWsrl
	81ErveIEIofCIvKfmi934eElEvXxGQxn8LywTuOQHepadlirUfZlSoz/K/p/Ud7hwQAePP
	KxYe+PuHHQscDnplePiOaU7OaHLyIQo=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783424118; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=zNprTdV7Wue5Q9FgZe4Ben/0b/M07q+frIOSYYirG1U=;
	b=APr0pM3MR2jKsNTj8fSkrYY3gYVhD/sYh41aLoIpBvl/K3cOLG25I3CzG4Ev3YugzfWsrl
	81ErveIEIofCIvKfmi934eElEvXxGQxn8LywTuOQHepadlirUfZlSoz/K/p/Ud7hwQAePP
	KxYe+PuHHQscDnplePiOaU7OaHLyIQo=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DB658779AE;
	Tue,  7 Jul 2026 11:35:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zPHVInTkTGqNPAAAD6G6ig
	(envelope-from <wqu@suse.com>); Tue, 07 Jul 2026 11:35:16 +0000
From: Qu Wenruo <wqu@suse.com>
To: fstests@vger.kernel.org,
	linux-btrfs@vger.kernel.org
Cc: Anand Jain <asj@kernel.org>
Subject: [PATCH v2] fstests: generic: add a basic cachestat test case
Date: Tue,  7 Jul 2026 21:04:54 +0930
Message-ID: <20260707113454.120001-1-wqu@suse.com>
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
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:url,suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 

The test case is inspired by LTP, where there is a regression on 64K
page size systems with btrfs, that after a fsync, cachestat() still
report dirty pages.

The test case itself is pretty simple, fill the file with a buffered write that is
1/2/4/8/16 page sized, call cachestat() to make sure the cached/dirtied
number match the page number.

Then do a fsync(), and make sure the dirty page number reduced to 0
meanwhile cached is still the same.

Link: https://bugzilla.suse.com/show_bug.cgi?id=1270397
Reviewed-by: Anand Jain <asj@kernel.org>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Changelog:
v2:
- Reject "sync" and "dax" mount options
  Those mount options write back data synchronously, will screw up the
  buffered write dirtied page reporting.

- Use AWK_PROG everywhere.

- Remove the unnecessary redirection for fsync
---
 tests/generic/798     | 61 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/798.out |  2 ++
 2 files changed, 63 insertions(+)
 create mode 100755 tests/generic/798
 create mode 100644 tests/generic/798.out

diff --git a/tests/generic/798 b/tests/generic/798
new file mode 100755
index 00000000..8888f6a3
--- /dev/null
+++ b/tests/generic/798
@@ -0,0 +1,61 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
+#
+# FS QA Test 798
+#
+# Basic tests for cachestat()
+#
+. ./common/preamble
+_begin_fstest auto quick
+
+_require_xfs_io_command "cachestat"
+_require_scratch
+# Any mount option that writes data back synchronously should be rejected.
+# Or it will screw up the dirtied page reporting for buffered writes.
+_exclude_scratch_mount_option "dax"
+_exclude_scratch_mount_option "sync"
+
+pagesize=$(_get_page_size)
+
+for num_page in 1 2 4 8 16; do
+	size=$(($pagesize * $num_page))
+
+	echo "=== Test with $num_page pages ===" >> $seqres.full
+	_scratch_mkfs > /dev/null
+	_scratch_mount
+
+	# Basic cached number reporting
+	$XFS_IO_PROG -f -c "pwrite -b $pagesize 0 $size" \
+		$SCRATCH_MNT/foobar >> $seqres.full
+	$XFS_IO_PROG -c "cachestat 0 $size" $SCRATCH_MNT/foobar > $tmp.output
+	cat $tmp.output >> $seqres.full
+	cached=$(cat $tmp.output | cut -f1 -d, | $AWK_PROG '{print $2}')
+	dirtied=$(cat $tmp.output | cut -f2 -d, | $AWK_PROG '{print $2}')
+
+	if [ "$cached" -ne "$num_page" ]; then
+		_fail "cached not matching the page number"
+	fi
+
+	if [ "$cached" -ne "$dirtied" ]; then
+		_fail "dirtied not matching the page number"
+	fi
+	$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/foobar
+
+	# Test dirty page number reporting after a fsync.
+	$XFS_IO_PROG -c "cachestat 0 $size" $SCRATCH_MNT/foobar > $tmp.output
+	cat $tmp.output >> $seqres.full
+	_scratch_unmount
+	cached=$(cat $tmp.output | cut -f1 -d, | $AWK_PROG '{print $2}')
+	dirtied=$(cat $tmp.output | cut -f2 -d, | $AWK_PROG '{print $2}')
+
+	if [ "$cached" -ne "$num_page" ]; then
+		_fail "cached not matching the page number"
+	fi
+	if [ "$dirtied" -ne 0 ]; then
+		_fail "dirtied pages not zero"
+	fi
+done
+
+echo "Silence is golden"
+_exit 0
diff --git a/tests/generic/798.out b/tests/generic/798.out
new file mode 100644
index 00000000..216d6e93
--- /dev/null
+++ b/tests/generic/798.out
@@ -0,0 +1,2 @@
+QA output created by 798
+Silence is golden
-- 
2.51.2

