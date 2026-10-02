Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43484611E5;
	Fri,  2 Oct 2026 12:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790942439; cv=none; b=AMbTnbSegyJQYXgudYTkNgCorcALsrM5UfLC32xu/mnsaxQpvV9J6IwW0xl5vKNz+DTmZeGcO23bCIJn8ug5IFSncmMdmn/IeXLTI7hCp/Ot5QE/0CGzRj4nNQtdmJZ6fPRI7dj1PRI56s7IPYA2JGRKBy1XCmrvsdOMHC3n/ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790942439; c=relaxed/simple;
	bh=u996lQyz5UZnZAec+cXTXl9Vfm1TXApv6wRmZvZYM/A=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=ORyfZdTCVyYuNAEuGuJCG4NrwYg5Muz44/IJulFg/2gSZTiNc7m2zYkqezrLIrjKIWoo1PX14Pss0IR6HV8CImhgo+DwZ/0aWlhgga1vCnfkfbB47T93yTMtU4fN66Hde4vG8uPlPMXfzjr1W1Ep5RCRXIp62t78xC1RhmiRiOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=hyTcTRHj; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=YCsCT+0Z; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="hyTcTRHj";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="YCsCT+0Z"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6DAB521F22;
	Fri,  2 Oct 2026 12:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1790942431; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=0rhHSsbNL6T96kcHqwKPYX2a7rnoikMN51Br4NbNdo8=;
	b=hyTcTRHjjw6AEQMkNDzkurC4X6TKCThfydLirFFyBtr/INHX9l8bPlxfxb9jLDgDQ2FZ44
	+r7rU0Jl6YFgwCV43dRpcEp5CCWd9B8rLy0vJGvhOmXOvEgmNKM2vWEY+lGdQDcHIPRnMN
	fDf+7t11vgUTpJ6GmEsKMx/eRVPEvP4=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=YCsCT+0Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1790942427; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=0rhHSsbNL6T96kcHqwKPYX2a7rnoikMN51Br4NbNdo8=;
	b=YCsCT+0ZWFl7yPRbzjErNtvI3cmaZQoZA+JyDC/U3NKLK0MNnBkoliNt3mzwcFMIumzu5u
	FlYZ5lKe5ueHVVKUOZMc0Jvpr21K/0EfuZZz4yZmyjV7k9f5+6FHO3U82lTNkYDsXYz2S3
	dmHeWpa7JRiu5qfO9EIcrMXJsunzzRg=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EC24013C6C;
	Fri,  2 Oct 2026 12:00:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id riWUEdmcv2qkIAAAD6G6ig
	(envelope-from <wqu@suse.com>); Fri, 02 Oct 2026 12:00:25 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH] fstests: btrfs: add a test case for deleting partially owned qgroup
Date: Fri,  2 Oct 2026 21:29:59 +0930
Message-ID: <20261002115959.7011-1-wqu@suse.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 6DAB521F22
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.19)[-0.928];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:mid,suse.com:email,suse.com:dkim];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Flag: NO
X-Spam-Score: -3.00
X-Spam-Level: 

There is a bug report that, when deleting a partially owned qgroup,
btrfs will delete the on-disk items but leave the in-memory rb-tree and
sysfs entries untouched.

Introduce a regression test for it, verifying the behavior by:

- Create a btrfs with a specific qgroup layout

              2/1
               |
              1/1
               |
   0/subv1  0/snap1

   All involved qgroups will have "1M + nodesize" as reference number,
   and "nodesize" as exclusive number.

   For the remaining example I'll use 16K as nodesize.

- Remove the qgroup relationship between 0/snap1 and 1/1
  This will mark qgroup inconsistent, but leave the old numbers.

              2/1 (rfer: 1M+16K, excl: 16K)
               |
              1/1 (rfer: 1M+16K, excl: 16K)

- Remove qgroup 1/1
  Which will automatically remove the relationship between 1/1 and 2/1.

  And since qgroup 1/1 is not fully owned (rfer > excl), this will mark
  qgroup inconsistent and return 1.

  For unpatched kernels, that positive return value is treated as an
  error, causing on-disk metadata items removed but still leave
  the rb-tree and sysfs entries untouched.

- Check if /sys/fs/btrfs/<fsid>/qgroups/1_1/ still exists
  If exists, the kernel is not yet patched.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 tests/btrfs/358     | 79 +++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/358.out |  2 ++
 2 files changed, 81 insertions(+)
 create mode 100755 tests/btrfs/358
 create mode 100644 tests/btrfs/358.out

diff --git a/tests/btrfs/358 b/tests/btrfs/358
new file mode 100755
index 00000000..642b0808
--- /dev/null
+++ b/tests/btrfs/358
@@ -0,0 +1,79 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
+#
+# FS QA Test 358
+#
+# Verify that when deleting a partially owned qgroup (excl != rfer),
+# the sysfs and in-memory rb-tree entries are also properly removed.
+#
+. ./common/preamble
+_begin_fstest auto quick qgroup
+
+_fixed_by_kernel_commit xxxxxxxxxxxx \
+	"btrfs: qgroup: do not treat \"ret > 0\" as error when deleting a qgroup"
+
+_require_btrfs_sysfs_fsid
+_require_btrfs_command qgroup remove --no-rescan
+_require_scratch
+_require_btrfs_qgroup_report
+
+# This implies making a btrfs and enables full qgroup mode.
+_require_scratch_qgroup
+_scratch_mount
+
+fsid=$(_btrfs_get_fsid "$SCRATCH_MNT")
+
+# We require /sys/fs/btrfs/<fsid>/qgroups/ directory
+if [ ! -d "/sys/fs/btrfs/$fsid/qgroups/0_5" ]; then
+	_scratch_unmount
+	_notrun "No sysfs qgroups directory"
+fi
+
+_btrfs subvolume create "$SCRATCH_MNT/subv1"
+_pwrite_byte 0x00 0 1M "$SCRATCH_MNT/subv1/data1" &> /dev/null
+_btrfs subvolume snapshot "$SCRATCH_MNT/subv1" "$SCRATCH_MNT/snap1"
+snap1id=$(_btrfs_get_subvolid $SCRATCH_MNT snap1)
+
+# Create the following qgroup layout and rescan.
+#                    2/1
+#                     |
+#                    1/1
+#                     |
+#  0/subv1           0/snap1
+#
+# Since snap1 is a snapshot of subv1, both will have 1M shared data
+# plus nodesize as exclusive metadata.
+# This means neither of them is fully exclusive (rfer > excl).
+_btrfs qgroup create 1/1 "$SCRATCH_MNT"
+_btrfs qgroup create 2/1 "$SCRATCH_MNT"
+_btrfs qgroup assign 1/1 2/1 "$SCRATCH_MNT"
+_btrfs qgroup assign 0/$snap1id 1/1 "$SCRATCH_MNT"
+
+# Do a rescan, as the above assign will mark the qgroup inconsistent.
+_btrfs quota rescan -w "$SCRATCH_MNT"
+
+# Now remove the qgroup relationship between 0/snap1 and 1/1
+# This will mark qgroup inconsistent but we do not want to trigger a rescan
+# automatically.
+# This will leave the old numbers (rfer > excl) for 1/1.
+_btrfs qgroup remove --no-rescan "0/$snap1id" 1/1 "$SCRATCH_MNT"
+
+# Now delete qgroup 1/1, which will automatically remove the relationship
+# between 1/1 and 2/1.
+# Since qgroup 1/1 still has stale values where rfer doesn't match excl,
+# the kernel marks the qgroups inconsistent and returns 1 to indicate a
+# rescan is needed.
+_btrfs qgroup destroy 1/1 "$SCRATCH_MNT"
+
+# For unpatched kernels, that positive return value is treated as an error,
+# causing btrfs to delete on-disk items for qgroup 1/1, but leaving the
+# in-memory rb-tree and sysfs entries untouched.
+# Check if the sysfs qgroup directory still has a directory for qgroup 1/1.
+if [ -d "/sys/fs/btrfs/$fsid/qgroups/1_1" ]; then
+	echo "Qgroup 1/1 still exists in sysfs qgroups directory"
+fi
+
+echo "Silence is golden"
+_scratch_unmount
+_exit 0
diff --git a/tests/btrfs/358.out b/tests/btrfs/358.out
new file mode 100644
index 00000000..8bcf2699
--- /dev/null
+++ b/tests/btrfs/358.out
@@ -0,0 +1,2 @@
+QA output created by 358
+Silence is golden
-- 
2.51.2

