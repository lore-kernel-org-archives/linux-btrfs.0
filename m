Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFAD2386C15
	for <linux-btrfs@vger.kernel.org>; Wed,  8 Jul 2026 06:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783492340; cv=none; b=k3VooWF3JWrBB6/8sJ6bnGSlFcuFG1YxnXnJ9ZROUtruT7B67iozR82vPps2t9pS+gLlX7jhH5iyJTaAItYt0wCYxi81spbeCL08CzHHARC5t+GwbjPOVIiFK/xXUeRA+SZVo9DJ78O98V4qjCfskTWY8wxxfBcH0P0RHu12jwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783492340; c=relaxed/simple;
	bh=iNvJfHBel98gFnPcc0d+EJLAcf3mX+DtbSGVgQdTyaI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=t5vJ6rkbmpocRfrLWgV1hNU/p/uCpxTi9Y9kftQzO7/uncQyLmAIsw50uwkflmOCojRGUGWiAU9SEMKUYRl5t3R632mtmbfyNXb42VGv4yvTJqHge7ppTyZsjTNfWqd/273bhDlhKt/hou0t2j1o12UilbxLg4sswX1xe78C0yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=TDGr/WOM; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=TDGr/WOM; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="TDGr/WOM";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="TDGr/WOM"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9060875ED6
	for <linux-btrfs@vger.kernel.org>; Wed,  8 Jul 2026 06:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783492336; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=yY8Otm//IfT4tZaH81nFPCZTn6cIEXscaZty3NWogmw=;
	b=TDGr/WOMyw5Klg9rD5UWLTecJ0yhPFcswg60rEtsLYmFla7NN79wX/erCHCmEqzDHl1Z+m
	VrLuPiR6/m21xMU2G98e3aTCHEWoKSsKsnQpiLFlds43cBCbhf7Ak0z+vUTX4oNAxkIGeb
	oTHao0gCCSklYnrkyCUM/3bZsxsIrMo=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783492336; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=yY8Otm//IfT4tZaH81nFPCZTn6cIEXscaZty3NWogmw=;
	b=TDGr/WOMyw5Klg9rD5UWLTecJ0yhPFcswg60rEtsLYmFla7NN79wX/erCHCmEqzDHl1Z+m
	VrLuPiR6/m21xMU2G98e3aTCHEWoKSsKsnQpiLFlds43cBCbhf7Ak0z+vUTX4oNAxkIGeb
	oTHao0gCCSklYnrkyCUM/3bZsxsIrMo=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 98E1B779AE
	for <linux-btrfs@vger.kernel.org>; Wed,  8 Jul 2026 06:32:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qq2REu/uTWqsfAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Wed, 08 Jul 2026 06:32:15 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: misc-tests: replace deprecated standalone "usebackuproot" option
Date: Wed,  8 Jul 2026 16:01:53 +0930
Message-ID: <1ad89cc23c00a2a6f1229a97bffb2ebac41426db.1783492304.git.wqu@suse.com>
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
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 

That option is already marked deprecated a long time ago, and is going to
be completely removed in v7.3.

Update the test case to auto-detect if the running kernel has support
for "rescue=usebackuproot", and if not skip the test case.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 .../misc-tests/038-backup-root-corruption/test.sh  | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/tests/misc-tests/038-backup-root-corruption/test.sh b/tests/misc-tests/038-backup-root-corruption/test.sh
index d4396a7fe21e..fccff72aabf1 100755
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
+run_check_mount_test_dev -o rescue=usebackuproot
 run_check_umount_test_dev
 
 main_root_ptr=$(dump_super | awk '/^root\t/{print $2}')
-- 
2.54.0

