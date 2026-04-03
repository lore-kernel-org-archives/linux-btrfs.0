Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63A6823E25B
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Apr 2026 04:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775190808; cv=none; b=P7fQUt4gYsmLup1HGIu1STTv7lJrsgatvNhKLTGhCR2NrVH8ua19lM7vus7Q+k22r6bvtOF7s5K+gURbB6mRZ81cYFcR30VTNBQ4MLvVnw/BbWvoBwEToHf2w4l8UsAJ9AxVB4RlYcNtJaPRjGSZrkG13y1stCKa2Bah477C5FI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775190808; c=relaxed/simple;
	bh=d0XThvbaxMQWNyMYUEwz7rdYXh/dpTLQn7xzip4UgUc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bVI+IoYo2Uq7wj7B1S4jh9Z1kjJmZSS04YxQbXAsdukehXX/OPd3a3mQ+xwcNZ0e+98lO/6HIn+K2fIzfV1qQjZr+PvY/r//nU1gsipKkf7QdoqA6FPxKrnaKW4stvU4vGtgpG7O/2nUYPk0CFa71KnJGaLWOQX2nKkaGVLzRJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=IlL8Vmhq; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=IlL8Vmhq; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="IlL8Vmhq";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="IlL8Vmhq"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2D54D4D1C5
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Apr 2026 04:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775190800; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pjHyMBQ0dGTXjswLVozK1FQobZaD+XqgSnbRSwwag0Y=;
	b=IlL8VmhqTldP/079KCqpO17czzHUa0hX9IelMQvtcZrt0+kxux25aMIZa+rmtH1XSnNbEj
	b3w1NhRBp4ug5vv5tmAg3+9yTUI/OulbScqlr+oF0ClxW75D2nkRoMVoTxetKAzkUOBhYz
	D6XR0KoZxc5IVT1c44mpLQxb2rnm6Z4=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775190800; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pjHyMBQ0dGTXjswLVozK1FQobZaD+XqgSnbRSwwag0Y=;
	b=IlL8VmhqTldP/079KCqpO17czzHUa0hX9IelMQvtcZrt0+kxux25aMIZa+rmtH1XSnNbEj
	b3w1NhRBp4ug5vv5tmAg3+9yTUI/OulbScqlr+oF0ClxW75D2nkRoMVoTxetKAzkUOBhYz
	D6XR0KoZxc5IVT1c44mpLQxb2rnm6Z4=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6CB1F4A0B0
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Apr 2026 04:33:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aAw+DA9Dz2nTYQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 03 Apr 2026 04:33:19 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 1/6] btrfs-progs: mkfs-tests: also test hole-deteciton without no-holes
Date: Fri,  3 Apr 2026 15:02:55 +1030
Message-ID: <2b987f5ffc1e07aa91402d553d38547edc3faee2.1775190565.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1775190565.git.wqu@suse.com>
References: <cover.1775190565.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid,suse.com:email];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

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

