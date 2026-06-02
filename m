Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C2214A8B
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Jun 2026 04:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780374850; cv=none; b=PoXN/FIwL93QOBwrySaxwaAo3QhYvyzdUE/yBNcgFRUzF1a/kfy85yxfWOuSQukumlGVSkOrOHcc1F2UpFVINovDI1Fp39n/qfZVPz1wn2RI1oPhqTaiDoVdHAusXJk+R76Yp1yDHjwhJIT6G825OrV/DOdQdeHHQrbbHXs3Dgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780374850; c=relaxed/simple;
	bh=xt3fv6F3jqNeYP7AJN0QSop/3/g0OVHJIL+iYSj0KPc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Kwi1Gpdp7hGPBuC7UpIUExQJUGVQoAiLMO5Fuysp9SDFco9JPqTlCjz4t5XRQ5S6b5rsgbcTzPIwe/0/jlVNXV/PHUKNNgwL/y7qloqPp7LjmtOMDywXrQ09uvO7Ua939J6jwd8ojoc/GgiGsXtngi0JSjUx366Wzg5XIRcrFXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=eJoQpHlt; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=krkik5Q2; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="eJoQpHlt";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="krkik5Q2"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F3813688E2;
	Tue,  2 Jun 2026 04:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780374847; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=D2HQlBFPiTgazor2+3UWCmdIgfUVV8XHwHd+1yD7CrA=;
	b=eJoQpHltxpt1iRR4BPr7xMxe3vEEID73rTC3t2oEXJA6HHV19G8f/c2zcA5aQAzdmXhMtk
	COPsSWcXCGZ3NDONQhPxjDVaceAYQhrtvK9xJVKpYU//O2OoXjQOrbka3q0ct2HXWB0g5k
	JMiZu3imIyBCgaWtUC4Uj8lvl2Q42Oo=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=krkik5Q2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780374846; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=D2HQlBFPiTgazor2+3UWCmdIgfUVV8XHwHd+1yD7CrA=;
	b=krkik5Q20ZCv0mxvEZXlSiTkIR/rJ5pSchXzglGnRwslBlDaeXEbq7nSnAb4kCipjrd4KA
	NuMxxKHglnVaRFE2VPK2npszv8QimfxjXkGHYHMa8MnNIBnNe07YPIsyQ28UmPuHtZFh8K
	xb3h2lEbc8atPZc8K6+9dFGukjymF9A=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AF33A779A7;
	Tue,  2 Jun 2026 04:34:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id FzYQHD1dHmptLgAAD6G6ig
	(envelope-from <wqu@suse.com>); Tue, 02 Jun 2026 04:34:05 +0000
From: Qu Wenruo <wqu@suse.com>
To: fstests@vger.kernel.org,
	linux-btrfs@vger.kernel.org
Cc: Su Yue <glass.su@suse.com>
Subject: [PATCH] fstests: btrfs: add a new test case for fstrim crash
Date: Tue,  2 Jun 2026 14:03:47 +0930
Message-ID: <20260602043347.50381-1-wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: F3813688E2
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCPT_COUNT_THREE(0.00)[3];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

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
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 tests/btrfs/350     | 38 ++++++++++++++++++++++++++++++++++++++
 tests/btrfs/350.out |  2 ++
 2 files changed, 40 insertions(+)
 create mode 100755 tests/btrfs/350
 create mode 100644 tests/btrfs/350.out

diff --git a/tests/btrfs/350 b/tests/btrfs/350
new file mode 100755
index 00000000..1206d66f
--- /dev/null
+++ b/tests/btrfs/350
@@ -0,0 +1,38 @@
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
+# lacks WRITEBALE flag nor a proper bdev pointer.
+#
+# For unpatched kernel, it will crash with a NULL pointer dereference.
+$FSTRIM_PROG $SCRATCH_MNT
+
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

