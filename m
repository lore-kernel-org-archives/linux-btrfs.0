Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B7AE36B939;
	Thu,  1 Oct 2026 04:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790827841; cv=none; b=DYjna6JyyPbCJisp8LeVNqR1pzmRKqysnI4cKA5C2LmJFVfKO3r/1K4SeEgZ4iD8cd4tyG/M8N90J3T8VOn5hA3el1rQUCTzv4D70CQlTlGfnf9OnWPZoaGPBEJQjy82nvdq6Ge59wS/reZ4Jr9XKkR3ZzVeoXR0Ziq4D4uhJs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790827841; c=relaxed/simple;
	bh=CE6fsmLqbL8NI1+tObjO8k9yEgqnBEVsZSBexUx1vo4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=vA5XQ42nqb6bJXJFCeT4PXGn1lBSCAaxItbCGbM0MWBeVyLkTHh40pX7KSke59w4hb7pt1tSuzTe7FQtnp0IYk0Pvpq4rh9Mv9lsyKS48+hORfeTwFf4k2EsB1gEPGHx2gSTbgnGlKSj7/lRLKOsk0IUGIyJaZ7LTijFHN0QceU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=hPAPQDvn; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=gBpUVCET; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="hPAPQDvn";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="gBpUVCET"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D39691FCD5;
	Thu,  1 Oct 2026 04:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1790827832; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=dhl/ByZxXAZgZ9IkQAkta1UbfYwmqaFnbZBdhEE3XPI=;
	b=hPAPQDvnmJinNhwCKDUak9pHvDzTiZRCxRDFSxvqR8iwcuMFLHn+gOibQW5uLHrW+5Lvh2
	q4cZRY7hx8mPxBeOz2s6DQBFayYDovpbYcw/eaVn5UPJaj90p9R59Zfnu0SsQf2iq0K+Zs
	TO6ceyK4baDsWVWi3t1kssK60+5ZBMY=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1790827828; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=dhl/ByZxXAZgZ9IkQAkta1UbfYwmqaFnbZBdhEE3XPI=;
	b=gBpUVCETck+N8ZMFD3T9XpZ5ehRe7hEP2BAoVhI+bukNM7wphaGAMFjZRLHu2db+3e6zzh
	ty2FIWHr4qEql/XwjGBCSNnaJwN5bv/4dkz5oRh35U5uYoU7QMTLzH2wsY7WaNlcXqSr6B
	2MnvKWAis+aD1jHTEPVDvMjuTFKzAkI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 464561368E;
	Thu,  1 Oct 2026 04:10:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id VokcJTLdvWoPWQAAD6G6ig
	(envelope-from <wqu@suse.com>); Thu, 01 Oct 2026 04:10:26 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH] fstests: btrfs: add a new test case to verify degraded RMW writes
Date: Thu,  1 Oct 2026 13:40:08 +0930
Message-ID: <20261001041008.39697-1-wqu@suse.com>
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
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:mid];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80
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
    This is done through fdatasync.

For unpatched kernels, the fio will always fail pretty early, meanwhile
patched kernels can finish the full 15 seconds runs on both RAID5 and
RAID6 profiles.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 tests/btrfs/357     | 65 +++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/357.out |  2 ++
 2 files changed, 67 insertions(+)
 create mode 100755 tests/btrfs/357
 create mode 100644 tests/btrfs/357.out

diff --git a/tests/btrfs/357 b/tests/btrfs/357
new file mode 100755
index 00000000..f2c04285
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
+fdatasync=8
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

