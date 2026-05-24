Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 088A04C97
	for <linux-btrfs@vger.kernel.org>; Sun, 24 May 2026 05:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779599699; cv=none; b=p1Fh091Jq7SOPe/cX39D2NpUUUJaaGrN/Nl0olkJ0N09rhz7OyuIU4CDMBHhuBtN2AZZgNnRSuWPsXwlt4DyGlVSv1nLyEntSJ5IM3A3k2r89Ma47v532144xSmzm2CnRA1FU1Q7VGBZL0c+vcKmKEmOqJlDIlXwWrBAAaaDVkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779599699; c=relaxed/simple;
	bh=HKdawVnpYiGAasNgqzWNL3/7YzqOtGCVsgRYIjwaJtQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=lCNCLvSaa2+BJC9Vl918METs2N0Cq4HGnoQLcChV9x+KUGd9UaRKmFT1szZFyza0NLofAfdMLi7KhL4hXM8F1ExQ/yJIpDkPVeIFHHkROgBDr70hQ5XaPPObP9kriVMNhCSaf4fGxsM1+sq0kYsu5zoK6yJwM8CabpwVTjSVgwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Rbogui+L; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Rbogui+L; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Rbogui+L";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Rbogui+L"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2D70C67D79;
	Sun, 24 May 2026 05:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779599347; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Xj56NLT7jvoe0e1R4yNw1Zb3iPs38+DGpcBI9tLiBpY=;
	b=Rbogui+Lt7Lh9ooLuWLnuwLidIcugg8J0ofjaROg85HR2MWhNieyXHkLuNnJkL/OJgR5fe
	AslbXZkB/nyVzJEuybwwK9YazOstlkgDX8m0/0C9VFd2VJ1otGYwrqsG2UrhaIZ8VNVEKM
	c2UUuITpO/7eIAyjGsZYXvm7TJXtvTY=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779599347; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Xj56NLT7jvoe0e1R4yNw1Zb3iPs38+DGpcBI9tLiBpY=;
	b=Rbogui+Lt7Lh9ooLuWLnuwLidIcugg8J0ofjaROg85HR2MWhNieyXHkLuNnJkL/OJgR5fe
	AslbXZkB/nyVzJEuybwwK9YazOstlkgDX8m0/0C9VFd2VJ1otGYwrqsG2UrhaIZ8VNVEKM
	c2UUuITpO/7eIAyjGsZYXvm7TJXtvTY=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2D80E595B5;
	Sun, 24 May 2026 05:09:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Ym4EOPGHEmrVXQAAD6G6ig
	(envelope-from <wqu@suse.com>); Sun, 24 May 2026 05:09:05 +0000
From: Qu Wenruo <wqu@suse.com>
To: fstests@vger.kernel.org,
	linux-btrfs@vger.kernel.org
Subject: [PATCH] fstests: btrfs: add a new test case for single data RAID56
Date: Sun, 24 May 2026 14:38:48 +0930
Message-ID: <20260524050848.57740-1-wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	URIBL_BLOCKED(0.00)[suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 
X-Spam-Flag: NO

Although single-data-RAID56, aka 2 disks raid5 or 3 disks raid6, is
not recommended for btrfs, btrfs still supports it as there are cases
like degraded writes can still lead to such cases.

But we do not have any proper tests for such corner cases.

Furthermore, RAID56 lib is going to drop the support of
single-data-RAID56, and btrfs will have its own handling of such cases,
thus coverage on single-data-RAID56 is required.

This new test case will have the following workload to verify the
behavior:

- Create a fs with single-data-RAID56

- Populate the fs with fsx and fsstress
  Fsx and fsstress will utilize read and write paths of RAID56.

- Mount each device in degraded mode and run read-only scrub on them
  Such scrub will utilize the following path of RAID56:
  * Regular data read
  * Reconstruction read
  * P/Q stripe scrub

- Re-scan all devices and add a new disk to the array
- Balance all data and scrub again
  This should utilized non-single-data-RAID56 handling.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 tests/btrfs/348     | 68 +++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/348.out |  2 ++
 2 files changed, 70 insertions(+)
 create mode 100755 tests/btrfs/348
 create mode 100644 tests/btrfs/348.out

diff --git a/tests/btrfs/348 b/tests/btrfs/348
new file mode 100755
index 00000000..748e5a86
--- /dev/null
+++ b/tests/btrfs/348
@@ -0,0 +1,68 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
+#
+# FS QA Test 348
+#
+# Basic function test for single-data-RAID56.
+#
+. ./common/preamble
+_begin_fstest auto raid
+
+# 3 disks for single-data-raid6, but one extra to make sure btrfs can still properly
+# convert to regular 4 disks raid6.
+_require_scratch_dev_pool 4
+_require_btrfs_raid_type raid5
+_require_btrfs_raid_type raid6
+_require_btrfs_forget_or_module_loadable
+
+# Make sure we have support RAID1C34 first
+if [ ! -f "/sys/fs/btrfs/features/raid1c34" ]; then
+	_notrun "no RAID1C34 support"
+fi
+
+common_workload()
+{
+	_scratch_mount
+	_run_fsx_on_file $FSX_AVOID "$SCRATCH_MNT/foobar" -q -N 10000 >> $seqres.full
+	_run_fsstress -w -n 10000 -d "$SCRATCH_MNT"
+	_scratch_unmount
+
+	# Mount each device degraded and run a scrub to exercise:
+	# - Regular data read
+	# - Data reconstruction read
+	# - P/Q scrub
+	for dev in $SCRATCH_DEV_POOL; do
+		_btrfs_forget_or_module_reload
+
+		_mount -o ro,degraded "$dev" "$SCRATCH_MNT"
+		_btrfs scrub start -Br "$SCRATCH_MNT"
+		_scratch_unmount
+	done
+
+	# Add a new device, balance all data, and re-scrub to make sure
+	# regular RAID56 is still working.
+	_btrfs_rescan_devices
+	_spare_dev_get
+	_scratch_mount
+	_btrfs device add -f "$SPARE_DEV" "$SCRATCH_MNT"
+	_btrfs balance start -d "$SCRATCH_MNT"
+	_btrfs scrub start -B "$SCRATCH_MNT"
+	_scratch_unmount
+	_spare_dev_put
+}
+
+_scratch_dev_pool_get 2
+# There will be a warning about single-data-RAID56, thus need
+# to redirect stderr
+_scratch_pool_mkfs -m raid1 -d raid5 >> $seqres.full 2>&1
+common_workload
+_scratch_dev_pool_put
+
+_scratch_dev_pool_get 3
+_scratch_pool_mkfs -m raid1c3 -d raid6 >> $seqres.full 2>&1
+common_workload
+_scratch_dev_pool_put
+
+echo "Silence is golden"
+_exit 0
diff --git a/tests/btrfs/348.out b/tests/btrfs/348.out
new file mode 100644
index 00000000..ec5e4701
--- /dev/null
+++ b/tests/btrfs/348.out
@@ -0,0 +1,2 @@
+QA output created by 348
+Silence is golden
-- 
2.51.2

