Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D42592E7F3A;
	Sat,  3 Oct 2026 07:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791011892; cv=none; b=RV19hKAHbIqjnBAjLesxKHo4ZqEzf95DY3n3epcMzQURYpWAwtJSDooW+7BkbSKhFFof3EA1tV09I+zKXQ2ziJPMMV7G0FABN+bdCW/yOxEwENiIkbI/YbRUo/kZa0t/Qb26548tdcOpW8JJARJVvxFNeby+Fjl43Dc9K1PFNUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791011892; c=relaxed/simple;
	bh=AiwVH+iy0cQpUFN9UX6xCm4n1A3gtLJYEpLpyGyU8Ys=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pvM7FJY984ifAARJsaZhgBcgAE8MHWAtxSeowIRT6V42LHJnQrJv+kLKh27Vm4/eisW4TlKzmof+tBMbWy/sAR1L6beiy+YSHTdDLJcI2GIynqjG2bVS/tqI6u+72NJDiLrf8mqe3OaCIz+2qUDJkbJ82nevKED0n+5jTgo5zqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=lMB5N8iW; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=KVS/46N/; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="lMB5N8iW";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="KVS/46N/"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9E4E521BE2;
	Sat,  3 Oct 2026 07:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791011884; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=o7ZUaldMy/K15ptisu20fb6jH29+NyFiaQPfiLjMbeA=;
	b=lMB5N8iWZO4ANuwzD8HQMUsHC+PPFXbLez8hdScUc7Qf1zsTen7l9K17i6Dsby01P/ZgAS
	ot8zC8+JaQdG3+KhYcW3JmgnFqcPj92x0TPa4EjYy9DHUaGZuHpmvE1dWdzutM1zo2fljO
	ArdAMnIDT9lr43+wj4Tg0KZy/uVXAXg=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791011880; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=o7ZUaldMy/K15ptisu20fb6jH29+NyFiaQPfiLjMbeA=;
	b=KVS/46N/g7lXHre87DANhnPEO70iHcPlM1UAxxK/EpcI3q6zqUSioU5ZQVMNQy6ZNcbBoM
	Dpxc2ML5GZDFwRY9JiNZk21r91pMYn2Oo27tevMVhSUHB/iFxxG8WwUW+mlhC9M/XHvcLr
	0XyXMV+kkkFUGGsCtL+6JOBorAvwyJQ=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A7DD013712;
	Sat,  3 Oct 2026 07:17:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id vuRIOyWswGr3MAAAD6G6ig
	(envelope-from <wqu@suse.com>); Sat, 03 Oct 2026 07:17:58 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org,
	fstests@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [PATCH v2] fstests: btrfs: add a test case for deleting partially owned qgroup
Date: Sat,  3 Oct 2026 16:47:24 +0930
Message-ID: <20261003071724.50671-1-wqu@suse.com>
X-Mailer: git-send-email 2.55.0
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
	NEURAL_HAM_LONG(-1.00)[-0.998];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCPT_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spam-Flag: NO

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

Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Changelog:
v2:
- Do not redirect stderr when writing the 1M data
- Remove unnecessary _scratch_unmount for _notrun branch
  As "check" script will do it for us.
---
 tests/btrfs/358     | 78 +++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/358.out |  2 ++
 2 files changed, 80 insertions(+)
 create mode 100755 tests/btrfs/358
 create mode 100644 tests/btrfs/358.out

diff --git a/tests/btrfs/358 b/tests/btrfs/358
new file mode 100755
index 00000000..3e9f2783
--- /dev/null
+++ b/tests/btrfs/358
@@ -0,0 +1,78 @@
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
+# This implies making a btrfs and enabling full qgroup mode.
+_require_scratch_qgroup
+_scratch_mount
+
+fsid=$(_btrfs_get_fsid "$SCRATCH_MNT")
+
+# We require /sys/fs/btrfs/<fsid>/qgroups/ directory
+if [ ! -d "/sys/fs/btrfs/$fsid/qgroups/0_5" ]; then
+	_notrun "No sysfs qgroups directory"
+fi
+
+_btrfs subvolume create "$SCRATCH_MNT/subv1"
+_pwrite_byte 0x00 0 1M "$SCRATCH_MNT/subv1/data1" >> $seqres.full
+_btrfs subvolume snapshot "$SCRATCH_MNT/subv1" "$SCRATCH_MNT/snap1"
+snap1id=$(_btrfs_get_subvolid "$SCRATCH_MNT" snap1)
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
+# Now remove the qgroup relationship between 0/snap1 and 1/1.
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

