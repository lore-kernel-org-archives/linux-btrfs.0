Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741AD33D6FA;
	Fri,  2 Oct 2026 09:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790932932; cv=none; b=usUeGJNmCg8WiC08+qWcsRxrBIFVXk/3IQuPGLssYsjT//WruPPOxRlv9bItLtl8AO6zocsBpDExqX7v9/bdJF8ODRIWwe9xJvefg9jKnX/cH80hvhMYg+5bVVWzlCi/ao3Z4b7JVAUBXNRKZfH6OdqlwAhv1UiNR9TWJdZ6Lyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790932932; c=relaxed/simple;
	bh=VEofMvKifzbXg0CvCcdGQYxQdysu3/01C+IFYiKSdYM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DeaKq6srGCevjEabkgpRFcx/DwYaaS4YJqx2srh/a6v3IFMh17zeufvHe163fsz0SndEwDDcySaFBNizeGuMr+2qP+9DM+TGi+Pg3D7kX/si0H9ykLIcYK3qTWYpeF4BOJAXUccLTTSJfpRN+hL+DuGAH3eO60Ifq8zuAO0lZLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=j+jOGKZh; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=N5OgrrCn; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="j+jOGKZh";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="N5OgrrCn"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1E11C21E4D;
	Fri,  2 Oct 2026 09:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1790932924; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=hND1KtmoSx56aH+pfsr01QOw5e00p1QCWLlNnAhE1jA=;
	b=j+jOGKZhgQsPZ7bKtElVL/Fa0ZPr07hic/yydOLIsfci0y8dOQM8/TfBoH8+Vr6RmqQWwc
	uoc9QgaNhfSnCNrno5+1YkTM+GZ92KiVwbsHHDY+pak1pWfrlgMfCmW2zb18KCO2NHjS5V
	1WJkeqC7J/1UW71vVyAzXTu+PYMEMVU=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=N5OgrrCn
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1790932920; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=hND1KtmoSx56aH+pfsr01QOw5e00p1QCWLlNnAhE1jA=;
	b=N5OgrrCnxN20mmqWqxOxMsgbWufjDLHmimVr7gh2VatLIq/mTegLb4PoexNl6oQYtqGcgN
	hFEYdPfFrgorPCfgis/hAgTZaY60ZpxaRHhNTQ+OMkSms3D1X/g8I9TaefByMVqpsEHFwY
	uSrIkhAknwcPfIpJ/Leok1dy3Qjp3j0=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5326B13C01;
	Fri,  2 Oct 2026 09:21:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MUKgKLV3v2q/dAAAD6G6ig
	(envelope-from <wqu@suse.com>); Fri, 02 Oct 2026 09:21:58 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org,
	fstests@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [PATCH v2] fstests: btrfs: add a new test case to verify degraded RMW writes
Date: Fri,  2 Oct 2026 18:51:35 +0930
Message-ID: <20261002092135.61719-1-wqu@suse.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 1E11C21E4D
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_THREE(0.00)[3];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email,suse.com:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

This is a regression test for a recent reported bug.

The test workload is pretty straightforward:

- Create a 4 disks RAID5 or RAID6 btrfs

- Destroy one disk and mount the btrfs degraded

- Use fio to do a workload meeting all the following conditions
  * Triggering a RMW write
    This is done by using buffered write with 8 4K writes.
    The total write will not fulfill a full stripe, thus it will
    always go through RMW.

  * Some blocks of the full stripe have csum and some do not
    This is done by pre-allocating the target file before testing, so
    every full stripe does not have any csum by default.

    Then after some writes, there will be checksum for those new writes,
    resulting blocks with mixed data checksum.

  * Detect RMW failure
    This is done through fsync.

For unpatched kernels, the fio will always fail pretty early, meanwhile
patched kernels can finish the full 15 seconds runs on both RAID5 and
RAID6 profiles.

Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Changelog:
v2:
- Use fsync= option for the fio workload
  The fdatasync= is no different than fsync= on btrfs.
---
 tests/btrfs/357     | 65 +++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/357.out |  2 ++
 2 files changed, 67 insertions(+)
 create mode 100755 tests/btrfs/357
 create mode 100644 tests/btrfs/357.out

diff --git a/tests/btrfs/357 b/tests/btrfs/357
new file mode 100755
index 00000000..b68d03b5
--- /dev/null
+++ b/tests/btrfs/357
@@ -0,0 +1,65 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
+#
+# FS QA Test 357
+#
+# Make sure on degraded RAID5/6, RMW writes won't return false errors
+# when some blocks do not have checksums.
+#
+. ./common/preamble
+
+_begin_fstest auto raid volume
+
+_fixed_by_kernel_commit xxxxxxxxxxxx \
+	"btrfs: raid56: do not verify the content if there is no data checksum"
+
+_require_command "$WIPEFS_PROG" wipefs
+_require_scratch_dev_pool 4
+_scratch_dev_pool_get 4
+
+fio_job_file=$tmp.fio
+cat > $fio_job_file << EOF
+[sync_randwrite]
+directory=$SCRATCH_MNT
+rw=randwrite
+filesize=512M
+bs=4K
+fsync=8
+time_based
+fallocate=posix
+runtime=15
+EOF
+
+_require_fio "$fio_job_file"
+
+# The target to remove for degraded mount.
+dev2="${SCRATCH_DEV_NAME[1]}"
+
+workload()
+{
+	local profile=$1
+	_scratch_pool_mkfs "-m raid1 -d $profile" >> $seqres.full 2>&1
+	$WIPEFS_PROG -fa "$dev2" >> $seqres.full 2>&1
+	_scratch_mount -o degraded
+
+	# The fio job will do fsync after 8 4K writes, which is not enough to
+	# fill a full stripe and always trigger RMW.
+	# And the target file is preallocated, after some writes a full stripe
+	# can have blocks with csum and some blocks without csum.
+	#
+	# Unpatched kernels will try to verify the checksum even if there is no
+	# csum and fail the RMW, causing fio to fail.
+	$FIO_PROG $fio_job_file >> $seqres.full 2>&1
+	if [ $? -ne 0 ]; then
+		echo "fio failed on degraded $profile"
+	fi
+	_scratch_unmount
+}
+
+workload raid5
+workload raid6
+
+_scratch_dev_pool_put
+echo "Silence is golden"
+_exit 0
diff --git a/tests/btrfs/357.out b/tests/btrfs/357.out
new file mode 100644
index 00000000..25875c6d
--- /dev/null
+++ b/tests/btrfs/357.out
@@ -0,0 +1,2 @@
+QA output created by 357
+Silence is golden
-- 
2.51.2

