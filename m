Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C6733DD523
	for <linux-btrfs@vger.kernel.org>; Wed,  8 Jul 2026 07:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783495343; cv=none; b=hGJ0aex2kDaVxwKCFER/LxNpTx4WsyP5B7rJZT1BOJMIjDXtgOeX5oZK6pM6iV5ek9f0FObc1wtIo336noNHkWs+DOs5kImjcIUM/FIoYsAVztWH1P8+ZXHEPxdxi1+WSJxScv/rkNp66gX265Af8vTcYThUC0JTU/QgF1zcMPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783495343; c=relaxed/simple;
	bh=2SlGxshP7Qtb20k59LECes1vjLBoY7ItrgHgYE8W3wU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=u2uxJmJ+78k6RoSgdOpuycEy5zwBApwI1wsR4cQhIle8kSABclh8b+qsHa5de1Mhb9eT+O7FzEoBU5QkrUzqPLXtMF810nDiF2r57lLyTnS0SmcD/YV44/HHls1m2DPQndf2ejM1ZXu0WQgN+kTuXEBShj5OTN+N/WasoduIQPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=o2AVcZiv; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=L9Z8vBqT; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="o2AVcZiv";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="L9Z8vBqT"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9606C758A2
	for <linux-btrfs@vger.kernel.org>; Wed,  8 Jul 2026 07:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783495333; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=RecAbK8aAPFJoFBg2966ZCi+N3QaYY42trEVkw1S/Ks=;
	b=o2AVcZivqUJaNrNBtex9/EJ8OuzG5rAeTgmkVvG/YHPhYARoxUhpLpDARdYE90jVp2hAUz
	u1jgTrV+etu31kkWBFmYT5v+j9XrecjMwvCYNxJf4yHC4zTDdbJAytCUjB/70Azf/IH17T
	pVK0/DCXGBQ0FUmfSlSy+Ji9xNMwZrE=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=L9Z8vBqT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783495332; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=RecAbK8aAPFJoFBg2966ZCi+N3QaYY42trEVkw1S/Ks=;
	b=L9Z8vBqTI7cC//I5ZJQ8t5PeIm495ozeZAobTpdFGAPjeyeaObxuhkQ/+Hc6NlkYCUQTzE
	BtAJrLbaqAyIFgN37xLos+faJKDFf5+fa7c9cvMjQ0IdkfxWCgi+I9tI7t5o+Xb4yPQS5i
	aviTUuIN723cBujl40+3NAyj4t5UsnY=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4FF00779AE
	for <linux-btrfs@vger.kernel.org>; Wed,  8 Jul 2026 07:22:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BU7xNaL6TWpyLQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Wed, 08 Jul 2026 07:22:10 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs-progs: misc-tests: replace deprecated standalone "usebackuproot" option
Date: Wed,  8 Jul 2026 16:51:47 +0930
Message-ID: <c1d73aebbb11c6f64d6e2dde4ee02020a96df9fc.1783495287.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 9606C758A2
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
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

That option is already marked deprecated a long time ago, and is going to
be completely removed in v7.3.

Update the test case to auto-detect if the running kernel has support
for "rescue=usebackuproot", and if not skip the test case.

Furthermore, since v7.3 all "rescue=" mount options, including
"rescue=usebackuproot" will require full RO mount, also add "ro" mount
option to the test run.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Changelog:
v2:
- Add "ro" mount option for v7.3
---
 .../misc-tests/038-backup-root-corruption/test.sh  | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/tests/misc-tests/038-backup-root-corruption/test.sh b/tests/misc-tests/038-backup-root-corruption/test.sh
index d4396a7fe21e..02f5962da450 100755
--- a/tests/misc-tests/038-backup-root-corruption/test.sh
+++ b/tests/misc-tests/038-backup-root-corruption/test.sh
@@ -10,6 +10,18 @@ check_prereq btrfs-corrupt-block
 setup_root_helper
 prepare_test_dev

+supported_opts="/sys/fs/btrfs/features/supported_rescue_options"
+# Make sure the current kernel has "rescue=usebackuproot" support.
+# Since v7.3 the standalone "usebackuproot" mount option is completely
+# removed.
+if [ ! -f "$supported_opts" ]; then
+	_not_run "No sysfs file for supported_rescue_options"
+fi
+
+if ! grep -q usebackuproot "$supported_opts"; then
+	_not_run "No \"rescue=usebackuproot\" support"
+fi
+
 # Create a file and unmount to commit some backup roots
 run_check_mkfs_test_dev
 run_check_mount_test_dev
@@ -55,7 +67,7 @@ run_mustfail "Unexpected successful mount" \
 	$SUDO_HELPER mount "$TEST_DEV" "$TEST_MNT"

 # Cycle mount with the backup to force rewrite of slot 3
-run_check_mount_test_dev -o usebackuproot
+run_check_mount_test_dev -o rescue=usebackuproot,ro
 run_check_umount_test_dev

 main_root_ptr=$(dump_super | awk '/^root\t/{print $2}')
--
2.54.0

