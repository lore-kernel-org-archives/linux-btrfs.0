Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D54D1A6828
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Jul 2026 00:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783383516; cv=none; b=NpJ3gDGLIDq1t8hHy8hwMG2xrPAYFBaYe94HYOrq2It9ElM9aa+J12BhbsM2K+zJDcTESP7ylBCNnQIVlMYYwHoaey5XhZ1qfJr31+ue1fiSbP8fdFw+Zlwr6QI+VPyemTh2EuVHsEciE2VTbI0/kN4XOfGW5SBZpwcx+om806w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783383516; c=relaxed/simple;
	bh=6MH/e+eYSds5jtJXpSJNVmNn65VzVCe5Le6N1TprL+0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=o+xtAb3/2lXA4BXTKluVzgW/DipyuyYtVRfTi1m2xhdx/KCTG7UhXbsPg1YUrWRbzt/qwByRghkR5yBqbtZ4DdnEKvkFbN9ry2stlLjfzcDE+lK/7uOKsWiBPERYBeARl87Ahn8jtKF0teteDcw50LmzijnPq2g+pYzGbRLNKH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=nl/5+zt7; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=nl/5+zt7; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="nl/5+zt7";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="nl/5+zt7"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 95A4475B87;
	Tue,  7 Jul 2026 00:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783383511; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=xq4sQwrykzSOF1Rd3vwNRL13N7wDHm6ujH7X60xcLNo=;
	b=nl/5+zt7viGZ4/g2s3D2MMNz8zqsJk/TrK/2o75Kr+RNEYfhrukGuVGbYjATOqQUhxZzS5
	OIvwDnGD7kuKyFL49aG+ZyxQWpn9B2bsbWz2Hvh3k7VQeCB3xj2e3jkDVUW41tuW5FAS3O
	s+EBMIjRMicjmRJzSg2yAlYZmsAysMg=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="nl/5+zt7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783383511; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=xq4sQwrykzSOF1Rd3vwNRL13N7wDHm6ujH7X60xcLNo=;
	b=nl/5+zt7viGZ4/g2s3D2MMNz8zqsJk/TrK/2o75Kr+RNEYfhrukGuVGbYjATOqQUhxZzS5
	OIvwDnGD7kuKyFL49aG+ZyxQWpn9B2bsbWz2Hvh3k7VQeCB3xj2e3jkDVUW41tuW5FAS3O
	s+EBMIjRMicjmRJzSg2yAlYZmsAysMg=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4C084779AE;
	Tue,  7 Jul 2026 00:18:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id g4EbO9VFTGo6QwAAD6G6ig
	(envelope-from <wqu@suse.com>); Tue, 07 Jul 2026 00:18:29 +0000
From: Qu Wenruo <wqu@suse.com>
To: fstests@vger.kernel.org,
	linux-btrfs@vger.kernel.org
Subject: [PATCH] fstests: generic: add a basic cachestat test case
Date: Tue,  7 Jul 2026 09:48:07 +0930
Message-ID: <20260707001807.31931-1-wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 95A4475B87
X-Spam-Flag: NO
X-Spam-Score: -3.01
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
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:mid,suse.com:dkim,suse.com:email,suse.com:url];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:mid,suse.com:dkim,suse.com:email,suse.com:url];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

The test case is inspired by LTP, where there is a regression on 64K
page size systems with btrfs, that after a fsync, cachestat() still
report dirty pages.

The test case itself is pretty simple, fill the file with a buffered write that is
1/2/4/8/16 page sized, call cachestat() to make sure the cached/dirtied
number match the page number.

Then do a fsync(), and make sure the dirty page number reduced to 0
meanwhile cached is still the same.

Link: https://bugzilla.suse.com/show_bug.cgi?id=1270397
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 tests/generic/798     | 57 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/798.out |  2 ++
 2 files changed, 59 insertions(+)
 create mode 100755 tests/generic/798
 create mode 100644 tests/generic/798.out

diff --git a/tests/generic/798 b/tests/generic/798
new file mode 100755
index 00000000..4328475e
--- /dev/null
+++ b/tests/generic/798
@@ -0,0 +1,57 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
+#
+# FS QA Test 798
+#
+# Basic tests for cachestate()
+#
+. ./common/preamble
+_begin_fstest auto quick
+
+_require_xfs_io_command "cachestat"
+_require_scratch
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
+	cached=$(cat $tmp.output | cut -f1 -d, | awk '{print $2}')
+	dirtied=$(cat $tmp.output | cut -f2 -d, | awk '{print $2}')
+
+	if [ "$cached" -ne "$num_page" ]; then
+		_fail "cached not matching the page number"
+	fi
+
+	if [ "$cached" -ne "$dirtied" ]; then
+		_fail "dirited not matching the page number"
+	fi
+	$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/foobar >> $seqres.full
+
+	# Test dirty page number reporting after a fsync.
+	$XFS_IO_PROG -c "cachestat 0 $size" $SCRATCH_MNT/foobar > $tmp.output
+	cat $tmp.output >> $seqres.full
+	_scratch_unmount
+	cached=$(cat $tmp.output | cut -f1 -d, | awk '{print $2}')
+	dirtied=$(cat $tmp.output | cut -f2 -d, | awk '{print $2}')
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

