Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D63B937BE85
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Apr 2026 08:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775724753; cv=none; b=tCaqQQHjCjOSrUUCns+ZOdQRmZCyygS270AS2dZN1De7BiiT3GlR0OcTRSyVuQt3AcgGrfmLEh6rK9TdgOQLd/XBVzGDW/13BrhXH7+Wt179/Q+skOEqC19DV+EyZRR978NafMEczKBmnWkWiqjzor9vilmDBrDjDNDV+2DNVW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775724753; c=relaxed/simple;
	bh=d0XThvbaxMQWNyMYUEwz7rdYXh/dpTLQn7xzip4UgUc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FlpicxSXE+l9EKDZwff5hr4z9dxEjNa/p4VIQ9x8U8g2Znwi6rKE4oahmfW2ovY9m1/Vb2WO5WiEKlaDVkqlqajMTennQA6XQOil46Unhvr1bPZJ0SdO7AjBWDSaOEqwqp0egBpy9Tk7y8m26PrVMx8H1MlODl6hDWDDl4lBloI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=s3hWyHkF; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=s3hWyHkF; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="s3hWyHkF";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="s3hWyHkF"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 12AE14EE4B
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Apr 2026 08:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775724746; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pjHyMBQ0dGTXjswLVozK1FQobZaD+XqgSnbRSwwag0Y=;
	b=s3hWyHkFM1I/HWTyVqW4wRzDrrw5b1BpNKC9ZJLZAttWLsP5Y7uY+Uhj8NpcF+Mgoh12dE
	pTNFyHP2sVUGxeNjOF3//2MXUQWV8aBCo9IrtpwPCGcid4nD/ZomLgyDR7ocl9kfeuPLVe
	e1Tvk4n5FHjY+Yj1vx8FjniRcVWqMdA=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=s3hWyHkF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775724746; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pjHyMBQ0dGTXjswLVozK1FQobZaD+XqgSnbRSwwag0Y=;
	b=s3hWyHkFM1I/HWTyVqW4wRzDrrw5b1BpNKC9ZJLZAttWLsP5Y7uY+Uhj8NpcF+Mgoh12dE
	pTNFyHP2sVUGxeNjOF3//2MXUQWV8aBCo9IrtpwPCGcid4nD/ZomLgyDR7ocl9kfeuPLVe
	e1Tvk4n5FHjY+Yj1vx8FjniRcVWqMdA=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0F9C54A0B3
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Apr 2026 08:52:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8F6yK8ho12lUJwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 09 Apr 2026 08:52:24 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v4 1/5] btrfs-progs: mkfs-tests: also test hole-deteciton without no-holes
Date: Thu,  9 Apr 2026 18:22:00 +0930
Message-ID: <2b987f5ffc1e07aa91402d553d38547edc3faee2.1775724568.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1775724568.git.wqu@suse.com>
References: <cover.1775724568.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim,suse.com:email];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 12AE14EE4B

Mark fixed a bug in the hole-detection code where the extent type is
uninitialized. Such bug can be detected by running the hole-detection
test case without no-holes feautres.

Update the test case to test with and without no-holes feature to
prevent such bug in the future.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 tests/mkfs-tests/041-hole-detection/test.sh | 48 ++++++++++++---------
 1 file changed, 27 insertions(+), 21 deletions(-)

diff --git a/tests/mkfs-tests/041-hole-detection/test.sh b/tests/mkfs-tests/041-hole-detection/test.sh
index 2b4e03c7a2e7..bd69447eded7 100755
--- a/tests/mkfs-tests/041-hole-detection/test.sh
+++ b/tests/mkfs-tests/041-hole-detection/test.sh
@@ -40,30 +40,36 @@ run_check dd if=/dev/urandom of="$tmp/middle_hole" bs=$blocksize count=1
 run_check dd if=/dev/urandom of="$tmp/middle_hole" bs=$blocksize count=1 seek=16
 middle_hole_before=$(run_check_stdout md5sum "$tmp/middle_hole" | awk '{print $1}')
 
-run_check_mkfs_test_dev -s $blocksize --rootdir "$tmp"
-run_check $SUDO_HELPER "$TOP/btrfs" check "$TEST_DEV"
-run_check_mount_test_dev
+workload()
+{
+	run_check_mkfs_test_dev -s $blocksize --rootdir "$tmp" $@
+	run_check $SUDO_HELPER "$TOP/btrfs" check "$TEST_DEV"
+	run_check_mount_test_dev
 
-# There are only 3 blocks written, thus 'du' should only report such 3 blocks used.
-blocks=$(run_check_stdout du -B $blocksize "$TEST_MNT" | awk '{print $1}')
+	# There are only 3 blocks written, thus 'du' should only report such 3 blocks used.
+	blocks=$(run_check_stdout du -B $blocksize "$TEST_MNT" | awk '{print $1}')
 
-if [ "$blocks" != "3" ]; then
-	_fail "Unexpected number of blocks written, has $blocks expect 3"
-fi
+	if [ "$blocks" != "3" ]; then
+		_fail "Unexpected number of blocks written, has $blocks expect 3"
+	fi
 
-full_hole_after=$(run_check_stdout md5sum "$TEST_MNT/full_hole" | awk '{print $1}')
-middle_data_after=$(run_check_stdout md5sum "$TEST_MNT/middle_data" | awk '{print $1}')
-middle_hole_after=$(run_check_stdout md5sum "$TEST_MNT/middle_hole" | awk '{print $1}')
+	full_hole_after=$(run_check_stdout md5sum "$TEST_MNT/full_hole" | awk '{print $1}')
+	middle_data_after=$(run_check_stdout md5sum "$TEST_MNT/middle_data" | awk '{print $1}')
+	middle_hole_after=$(run_check_stdout md5sum "$TEST_MNT/middle_hole" | awk '{print $1}')
 
-if [ "$full_hole_before" != "$full_hole_after" ]; then
-	_fail "full_hole content changed"
-fi
-if [ "$middle_data_before" != "$middle_data_after" ]; then
-	_fail "middle_data content changed"
-fi
-if [ "$middle_hole_before" != "$middle_hole_after" ]; then
-	_fail "middle_hole content changed"
-fi
+	if [ "$full_hole_before" != "$full_hole_after" ]; then
+		_fail "full_hole content changed"
+	fi
+	if [ "$middle_data_before" != "$middle_data_after" ]; then
+		_fail "middle_data content changed"
+	fi
+	if [ "$middle_hole_before" != "$middle_hole_after" ]; then
+		_fail "middle_hole content changed"
+	fi
+	run_check_umount_test_dev
+}
+
+workload -O no-holes
+workload -O ^no-holes
 
-run_check_umount_test_dev
 run_check rm -rf -- "$tmp"
-- 
2.53.0

