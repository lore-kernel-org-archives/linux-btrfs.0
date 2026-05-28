Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 170EA343D8A
	for <linux-btrfs@vger.kernel.org>; Thu, 28 May 2026 06:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779951546; cv=none; b=Ff+VIKYKe3V5ipM8DR1Vsvdyq6ciBALbQRQnosPmFA5tCLXqUDwJk+DT0veDqES9CC914yz6a7YgDci6LqbhE1nMZCKTQHxoGqp9qmVpYzRp9yYBpzz7mwj1vHMvd/Fps7D6iwL4nXkIw+lFuaWERxGeNFPvjkzlsLX+R1FbY7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779951546; c=relaxed/simple;
	bh=Jm4qhX9SGGS1geR6QFSqdq4CN0moJFebFN6nBm+mrwY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=G23Cpz/o3qxczAQ/z0l4QVYCVwfT2mthc7aZ/2QvsIvgr4VeY0+nXNTEnCD5Q+3kTk+V8JHpH6VIm59aobUfoWCOu87ACcZC0xjMm8FXbFmQ5LjRwIgf9wzOpsOPncwmPmOAR8ko7+QyQzysvLL+bWERZysNPALF3f1LPGV5cuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=j5OSi/F7; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=j5OSi/F7; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="j5OSi/F7";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="j5OSi/F7"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 60D0B6AFA5;
	Thu, 28 May 2026 06:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779951543; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=G/ZSdxSAZ7ER7yPRGPlO+GmeH383Lhf2G4+6dO1nhGU=;
	b=j5OSi/F7eCy6M+U7IqFIMcvgFNaH6VrT8SCDMEXYYX2NPzjUsQVFGsh8/M9xPr4Je7I3g5
	1iZCyLFucfrY3vdaAg2D48VTHF7Wij892GPmxl60UIgKUI2zpJztXLbzSE3tS8boka61TD
	bB5Omt/DYHkhpUwhE1/84webRrW3yqk=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779951543; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=G/ZSdxSAZ7ER7yPRGPlO+GmeH383Lhf2G4+6dO1nhGU=;
	b=j5OSi/F7eCy6M+U7IqFIMcvgFNaH6VrT8SCDMEXYYX2NPzjUsQVFGsh8/M9xPr4Je7I3g5
	1iZCyLFucfrY3vdaAg2D48VTHF7Wij892GPmxl60UIgKUI2zpJztXLbzSE3tS8boka61TD
	bB5Omt/DYHkhpUwhE1/84webRrW3yqk=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 663BD5AC62;
	Thu, 28 May 2026 06:59:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id trObCrbnF2pqLwAAD6G6ig
	(envelope-from <wqu@suse.com>); Thu, 28 May 2026 06:59:02 +0000
From: Qu Wenruo <wqu@suse.com>
To: fstests@vger.kernel.org,
	linux-btrfs@vger.kernel.org
Subject: [PATCH] fstests: remove dio related target file to respect mount options that only affecst new inodes
Date: Thu, 28 May 2026 16:28:44 +0930
Message-ID: <20260528065844.71952-1-wqu@suse.com>
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
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:mid];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]

[BUG]
Test case generic/362 and generic/365 will fail with nodatasum, but
that's only when TEST_DEV is newly formated.

 FSTYP         -- btrfs
 PLATFORM      -- Linux/x86_64 btrfs-vm 7.1.0-rc4-custom+ #381 SMP PREEMPT_DYNAMIC Tue May 26 10:47:14 ACST 2026
 MKFS_OPTIONS  -- -O bgt -K /dev/mapper/test-scratch1
 MOUNT_OPTIONS -- -o nodatasum /dev/mapper/test-scratch1 /mnt/scratch

  generic/362  0s ... - output mismatch (see /home/adam/xfstests/results//generic/362.out.bad)
    --- tests/generic/362.out	2024-08-24 15:31:37.200000000 +0930
    +++ /home/adam/xfstests/results//generic/362.out.bad	2026-05-28 16:18:33.866141979 +0930
    @@ -1,2 +1,3 @@
     QA output created by 362
    +First write failed: Input/output error
     Silence is golden
    ...
    (Run 'diff -u /home/adam/xfstests/tests/generic/362.out /home/adam/xfstests/results//generic/362.out.bad'  to see the entire diff)

  generic/364  11s ... - output mismatch (see /home/adam/xfstests/results//generic/364.out.bad)
    --- tests/generic/364.out	2024-09-30 09:09:51.216666681 +0930
    +++ /home/adam/xfstests/results//generic/364.out.bad	2026-05-28 16:18:34.318532257 +0930
    @@ -1,2 +1,3 @@
     QA output created by 364
    +Fsync failed: Input/output error
     Silence is golden
    ...
    (Run 'diff -u /home/adam/xfstests/tests/generic/364.out /home/adam/xfstests/results//generic/364.out.bad'  to see the entire diff)

But if one has formated TEST_DEV, run test with default mount option,
then change the mount option to "nodatasum", the test will not fail
anymore:

 FSTYP         -- btrfs
 PLATFORM      -- Linux/x86_64 btrfs-vm 7.1.0-rc4-custom+ #381 SMP PREEMPT_DYNAMIC Tue May 26 10:47:14 ACST 2026
 MKFS_OPTIONS  -- -O bgt -K /dev/mapper/test-scratch1
 MOUNT_OPTIONS -- /dev/mapper/test-scratch1 /mnt/scratch

 generic/362  0s ...  1s
 generic/364  11s ...  10s
 Ran: generic/362 generic/364
 Passed all 2 tests

 FSTYP         -- btrfs
 PLATFORM      -- Linux/x86_64 btrfs-vm 7.1.0-rc4-custom+ #381 SMP PREEMPT_DYNAMIC Tue May 26 10:47:14 ACST 2026
 MKFS_OPTIONS  -- -O bgt -K /dev/mapper/test-scratch1
 MOUNT_OPTIONS -- -o nodatasum /dev/mapper/test-scratch1 /mnt/scratch

 generic/362  1s ...  0s
 generic/364  10s ...  11s
 Ran: generic/362 generic/364
 Passed all 2 tests

[CAUSE]
Btrfs' nodatasum mount option only affect new files, but the test cases
are using TEST_DEV, and never delete the target files
"$TEST_DIR/dio-append-buf-fault" for generic/362 and
"$TEST_DIR/dio-write-fsync-same-fd" for generic/364.

So if the files are created with default mount option, then all later
"nodatasum" mount option will not affect those files, thus hide the test
failure.

[FIX]
For all test cases utilizing "$here/src/dio*", add a _cleanup()
function, to remove target files, so that for mount options that only
affect new inodes, the mount options will be respected, and expose
failures.

Now generic/36[24] will properly fail for "nodatasum" mount option on
btrfs.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 tests/generic/362 | 6 ++++++
 tests/generic/364 | 7 +++++++
 tests/generic/418 | 7 +++++++
 tests/generic/708 | 6 ++++++
 4 files changed, 26 insertions(+)

diff --git a/tests/generic/362 b/tests/generic/362
index 0cfaa726..5e8fd534 100755
--- a/tests/generic/362
+++ b/tests/generic/362
@@ -10,6 +10,12 @@
 . ./common/preamble
 _begin_fstest auto quick
 
+_cleanup()
+{
+	cd /
+	rm -f "$TEST_DIR/dio-append-buf-fault"
+}
+
 # NFS forbade open with O_APPEND|O_DIRECT
 _exclude_fs nfs
 
diff --git a/tests/generic/364 b/tests/generic/364
index f7fb002f..6587cf02 100755
--- a/tests/generic/364
+++ b/tests/generic/364
@@ -11,6 +11,13 @@
 . ./common/preamble
 _begin_fstest auto quick
 
+_cleanup()
+{
+	cd /
+	rm -f "$TEST_DIR/dio-write-fsync-same-fd"
+}
+
+
 _require_test
 _require_odirect
 _require_test_program dio-write-fsync-same-fd
diff --git a/tests/generic/418 b/tests/generic/418
index 36789198..024c4682 100755
--- a/tests/generic/418
+++ b/tests/generic/418
@@ -26,6 +26,13 @@ _require_block_device $TEST_DEV
 _require_test_program "dio-invalidate-cache"
 _require_test_program "feature"
 
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+	rm -f "$testfile"
+}
+
 diotest=$here/src/dio-invalidate-cache
 testfile=$TEST_DIR/$seq-diotest
 sectorsize=`$here/src/min_dio_alignment $TEST_DIR $TEST_DEV`
diff --git a/tests/generic/708 b/tests/generic/708
index 827dac13..cdaad811 100755
--- a/tests/generic/708
+++ b/tests/generic/708
@@ -14,6 +14,12 @@
 . ./common/preamble
 _begin_fstest quick auto mmap
 
+_cleanup()
+{
+	cd /
+	rm -f "$src" "$dst"
+}
+
 _fixed_by_fs_commit btrfs b73a6fd1b1ef \
 		"btrfs: split partial dio bios before submit"
 
-- 
2.51.2

