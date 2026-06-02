Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2F73557F3
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Jun 2026 10:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780396768; cv=none; b=gQCDu7RXW5+/3q4a6ZpH2qeVAT0yqqiSLwEpk7G8PhbDOJqt+qR9Jts/kyWi9liP4MtG8m10RruUYalnGtEKutBveF9dQL9EWY+IyUGXvZeGQ36QHymipdArwDx0p2pmqwGJZC67MKOd1TyTi42J7MiEKUVZhKjqtB6BBc5oV6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780396768; c=relaxed/simple;
	bh=5/t1s4WQtESSU+/PPjkOFmorKpNar/59+lFpju1HSiE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=vFVV4Fl8u1iO7NYs8WV0StuZaMfLvvltV0yySLWljkY0QXCEkBJ/1md+7wSVPe3STfD1fsdB4V5uLjWorQrPhvQxwjElTusLCYUgJJ0LFQjQq5sJ23RNhx84qfAqszSVibVPmXwbHtaktQQNnkRjxAU0OlBa/xR3hnSzRe9z5LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=iWPC9GZm; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=VAJbP4Dy; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="iWPC9GZm";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="VAJbP4Dy"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C33436A9CC;
	Tue,  2 Jun 2026 10:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780396764; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=MAzD1JRfnAoeRlp40ywpUHAf/ORU7ic+vjXziwIVFSA=;
	b=iWPC9GZmfgsgDIL4NiYaPivFnasWvjQjXiuN1yjXsS8tQ0ZX8h3wR/QAd8PLb9M/J2vQKm
	eX0jYRq5VkdnPL4s8iO8WXRBBN62Q4GEU26w2F4crgCeYcMuUyRA8I2vleL8lcF5/Kj2Nw
	NvPTz+ogaqJ4YfRrlrHy98Ho46XusRQ=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780396762; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=MAzD1JRfnAoeRlp40ywpUHAf/ORU7ic+vjXziwIVFSA=;
	b=VAJbP4Dy+utsoNe9WnfrTcqt4g6AvYcUemKQI0IViLgTmJd73AXb+x34PmJKDh8M52ABR0
	dVI7TRjCw3BeAnn42h5WdXfS8V440wwti6sUBvhNHMjoMvFouWmMuQtMpS8qkV6c4TGe4Y
	h9iaiJisurHO8LnB10CT68MP+e7gofs=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4E2D2779A7;
	Tue,  2 Jun 2026 10:39:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id nsCbBNmyHmoOEwAAD6G6ig
	(envelope-from <wqu@suse.com>); Tue, 02 Jun 2026 10:39:21 +0000
From: Qu Wenruo <wqu@suse.com>
To: fstests@vger.kernel.org,
	linux-btrfs@vger.kernel.org
Cc: Su Yue <glass.su@suse.com>,
	Filipe Manana <fdmanana@suse.com>
Subject: [PATCH v2] fstests: btrfs: add a new test case for fstrim crash
Date: Tue,  2 Jun 2026 20:09:03 +0930
Message-ID: <20260602103903.93754-1-wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 
X-Spam-Score: -2.80

There is a bug report that btrfs/242 can crash very randomly.

It turns out the crash is caused by a re-appearing missing device, which
screwed up several checks in fstrim.

This new test case is a more reliable version, dedicated for such crash,
which will:

- Create a raid1 btrfs
- Mount with a single device in degraded mode
- Let the missing device to re-appear
- Run fstrim

Which is reliably crashing in my environment without the submitted fix.
And with the submitted fix, the test no longer crashes.

Reported-by: Su Yue <glass.su@suse.com>
Link: https://lore.kernel.org/linux-btrfs/wlwir19t.fsf@damenly.org/
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Changelog:
v2:
- Fix two grammar errors
- Add the missing _scratch_dev_pool_put at the end
- Add Filipe's reviewed-by tag
---
 tests/btrfs/350     | 39 +++++++++++++++++++++++++++++++++++++++
 tests/btrfs/350.out |  2 ++
 2 files changed, 41 insertions(+)
 create mode 100755 tests/btrfs/350
 create mode 100644 tests/btrfs/350.out

diff --git a/tests/btrfs/350 b/tests/btrfs/350
new file mode 100755
index 00000000..7cc04b63
--- /dev/null
+++ b/tests/btrfs/350
@@ -0,0 +1,39 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
+#
+# FS QA Test 350
+#
+# Make sure fstrim will not crash when a missing device re-appeared.
+#
+. ./common/preamble
+_begin_fstest auto quick volume trim raid
+
+_fixed_by_kernel_commit XXXXXXXXXXXX \
+	"btrfs: do not trim a device which is not writeable"
+
+_require_btrfs_forget_or_module_loadable
+_require_scratch_dev_pool 2
+_scratch_dev_pool_get 2
+dev1=$(echo $SCRATCH_DEV_POOL | $AWK_PROG '{ print $1 }')
+dev2=$(echo $SCRATCH_DEV_POOL | $AWK_PROG '{ print $2 }')
+
+_scratch_pool_mkfs "-m raid1 -d raid1"
+_require_batched_discard $SCRATCH_MNT
+
+# Mount the filesystem in degraded mode
+_btrfs_forget_or_module_reload
+_mount -o degraded $dev1 $SCRATCH_MNT
+
+# Now let devid 2 reappear
+_btrfs device scan $dev2
+
+# Run fstrim, it should skip the re-appeared device, as it still
+# lacks WRITEBALE flag and a proper bdev pointer.
+#
+# For unpatched kernel, it will crash with a NULL pointer dereference.
+$FSTRIM_PROG $SCRATCH_MNT
+
+_scratch_dev_pool_put
+echo "Silence is golden"
+_exit 0
diff --git a/tests/btrfs/350.out b/tests/btrfs/350.out
new file mode 100644
index 00000000..e9aad823
--- /dev/null
+++ b/tests/btrfs/350.out
@@ -0,0 +1,2 @@
+QA output created by 350
+Silence is golden
-- 
2.51.2

