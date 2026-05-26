Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C691B239E80
	for <linux-btrfs@vger.kernel.org>; Tue, 26 May 2026 07:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779778878; cv=none; b=QL53gNzASYRl/cJ3vGe2xdibsXtWSHHr9dfpvijhjjuM/Qeh6SaoL49v2jn9H8ihepsebIumfXg60iiHaRVlWhjFahaU2w1dUXJZ+Rw+nQQ1vI7JVVdapoFmeWJzHetoprvA23meN4XusROA4MB1mNgNbSKl7JJcUJQCjdVbdYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779778878; c=relaxed/simple;
	bh=mlU9zCnB+vurOrC3LwF1nJR7dm+3w2IygSJgIvc5kbk=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=fuaQSMon3EE15P/b4NBUaNlOltB2di4juC4XLVDyNI3dbyj1+fJW3XKsZ0S9kxuV5IetWrMo8pOvToekp3VdZAy7apu4fUDzcwE+GS6KIsGwNgl2RH8bBTnTsnf94NA0bzv6gMnJb8dY0otITA15xkxNbuV3zTB+PqT6gPBLkuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=QpvfTQsF; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=p51WonL1; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="QpvfTQsF";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="p51WonL1"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EACC375BD0;
	Tue, 26 May 2026 07:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779778874; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=RnwfPIU2M74DaRg9xqvwN+2/NQhjOg6LNvYc1bZXxzM=;
	b=QpvfTQsFciUE+/47tAwKSuA28cGJ8X8ON81hTjXQKh2o7Buff/Y5YoRg7YvbGFpBzWM7uY
	0J0E7lfxjKFqM8dvDT1Xy1l0I7l/cqY/VlUID7T5p5pPe1LofGQ0vQVUxMX5EECyGoOO8D
	kSIJQf3q94YCrIdnMphpJcucVpzgwCc=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=p51WonL1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779778873; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=RnwfPIU2M74DaRg9xqvwN+2/NQhjOg6LNvYc1bZXxzM=;
	b=p51WonL1+UZoR6zIw0fmOeMR1Z79UrxRSru5qsn85DU9V1n5/sTkFXeTK5idF72arMqVx+
	V7RZLBCl0sKX2Bjw0Yqua0Ww8SkY+K5VRYlpnio91nAxfEIsHpNKjs0lX23zN/RnN9gVKV
	L1S08fsYeby7brBDYkE40A8a5C1h1MM=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E788F5A097;
	Tue, 26 May 2026 07:01:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pfGdKThFFWqYawAAD6G6ig
	(envelope-from <wqu@suse.com>); Tue, 26 May 2026 07:01:12 +0000
From: Qu Wenruo <wqu@suse.com>
To: fstests@vger.kernel.org,
	linux-btrfs@vger.kernel.org
Subject: [PATCH] fstests: generic/362: remove the old file to reflect new mount options
Date: Tue, 26 May 2026 16:30:55 +0930
Message-ID: <20260526070055.60193-1-wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -3.01
X-Rspamd-Queue-Id: EACC375BD0
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
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
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO

[HIDDEN BUG]
There is a btrfs bug that will only trigger on newly formated TEST_DEV,
with mount option "nodatasum":

 FSTYP         -- btrfs
 PLATFORM      -- Linux/x86_64 btrfs-vm 7.1.0-rc4-custom+ #381 SMP PREEMPT_DYNAMIC Tue May 26 10:47:14 ACST 2026
 MKFS_OPTIONS  -- -O bgt -K /dev/mapper/test-scratch1
 MOUNT_OPTIONS -- -o nodatasum /dev/mapper/test-scratch1 /mnt/scratch

 generic/362  0s ... - output mismatch (see /home/adam/xfstests/results//generic/362.out.bad)
     --- tests/generic/362.out	2024-08-24 15:31:37.200000000 +0930
     +++ /home/adam/xfstests/results//generic/362.out.bad	2026-05-26 16:24:40.201201849 +0930
     @@ -1,2 +1,3 @@
      QA output created by 362
     +First write failed: Input/output error
      Silence is golden
     ...
     (Run 'diff -u /home/adam/xfstests/tests/generic/362.out /home/adam/xfstests/results//generic/362.out.bad'  to see the entire diff)

But if one has formated TEST_DEV, run test with default mount option,
then change the mount option to "nodatasum", the test will not fail
anymore:

 FSTYP         -- btrfs
 PLATFORM      -- Linux/x86_64 btrfs-vm 7.1.0-rc4-custom+ #381 SMP PREEMPT_DYNAMIC Tue May 26 10:47:14 ACST 2026
 MKFS_OPTIONS  -- -O bgt -K /dev/mapper/test-scratch1
 MOUNT_OPTIONS -- /dev/mapper/test-scratch1 /mnt/scratch

 generic/362  0s ...  0s
 Ran: generic/362
 Passed all 1 tests

 FSTYP         -- btrfs
 PLATFORM      -- Linux/x86_64 btrfs-vm 7.1.0-rc4-custom+ #381 SMP PREEMPT_DYNAMIC Tue May 26 10:47:14 ACST 2026
 MKFS_OPTIONS  -- -O bgt -K /dev/mapper/test-scratch1
 MOUNT_OPTIONS -- -o nodatasum /dev/mapper/test-scratch1 /mnt/scratch

 generic/362  0s ...  0s
 Ran: generic/362
 Passed all 1 tests

[CAUSE]
Btrfs' nodatasum mount option only affect new files, but the test case
itself is using TEST_DEV, and never delete the file
"$TEST_DIR/dio-append-buf-fault"

So if the file is created with default mount option, then all later
"nodatasum" mount option will not affect that file, thus hide the test
failure.

[FIX]
Always delete the target file "$TEST_DIR/dio-append-buf-fault" before
running dio-append-buf-fault command.

So that the new target file is always newly created and will follow
btrfs' new mount option and expose the failure for nodatasum.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
I'm already looking into the test failure, because it's mostly hidden by
the btrfs' falling back to buffered IO behavior.

With the incoming IOMAP_DIO_BOUNCE usage inside btrfs, it will expose
the failure unconditionally.
---
 tests/generic/362 | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tests/generic/362 b/tests/generic/362
index 0cfaa726..86191e57 100755
--- a/tests/generic/362
+++ b/tests/generic/362
@@ -20,6 +20,10 @@ _require_test_program dio-append-buf-fault
 _fixed_by_fs_commit btrfs 939b656bc8ab \
 	"btrfs: fix corruption after buffer fault in during direct IO append write"
 
+# Remove the existing file, so a new inode can be created, and will be
+# affected by changed mount options.
+rm -rf $TEST_DIR/dio-append-buf-fault
+
 # On error the test program writes messages to stderr, causing a golden output
 # mismatch and making the test fail.
 $here/src/dio-append-buf-fault $TEST_DIR/dio-append-buf-fault
-- 
2.51.2

