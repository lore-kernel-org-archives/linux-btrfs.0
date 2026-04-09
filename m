Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF63A1E89C
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Apr 2026 04:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775709121; cv=none; b=LwMRbgNk4v4V5EHmsEqm1oDWnOBorfx+iEiAKNUUtPGlEonH7QuG7tMvaXCpWDIw1sub3vjAHCOLt4tyDF2mC5QHPOBr6iWZNE1ym22oFmqn0HMCQ8/p/85o6Rpngl+4ziMaQdNaGfCfH2HxBb+xg6zFgaUjQOVJh654badOWbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775709121; c=relaxed/simple;
	bh=d0XThvbaxMQWNyMYUEwz7rdYXh/dpTLQn7xzip4UgUc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=COPtJs9nQNMy+4J7ifsQfLR0dFosU1ZKN3tpqRh20NnfkRm0LyyYaIbR1PkTN1bSRxpqsNq00WfGlb8VNzMy3AXnEMDSMRCO9e4RpJ5lbJxBzpj4bJB+9L6ZyFsq3RjI/gv1BG3TMEck5X4ZXvZsjbPJw1LskgcmSoL/xYYRJIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=nn6846Hv; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=j+0WBbej; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="nn6846Hv";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="j+0WBbej"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E643A4ED4A
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Apr 2026 04:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775709118; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pjHyMBQ0dGTXjswLVozK1FQobZaD+XqgSnbRSwwag0Y=;
	b=nn6846HvoUV1IcFUzMTYzGpcGwpSL/kE42RCMGn6HAFqbG5T9wGDzMtYtKxCLioUKPpWhy
	eI8IVqPg1emLQI2HDrwdNmn5VsKC0Ni5738B8U0GdVLQNeYSbtRprzrftlpUuQP0Do5t8c
	nbjJrjS+8uz0o0Q/o0/45jSK73n+Azg=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=j+0WBbej
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775709116; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pjHyMBQ0dGTXjswLVozK1FQobZaD+XqgSnbRSwwag0Y=;
	b=j+0WBbej42cLJczSWYmJOT9RlxGb+DzkVbTgDj3iVyA/FhLYhydeTH8c2ZJSZbGvq95APM
	6enKNPtNoUpVsPAd8XIZ2poB3U68b9Ko78pPtedsXa7GFl1sIv0w01s1fc2MRpilEnX60q
	s4czRNzBDz+6ptFqQZjTXBBUiPgEO1M=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3DA934A0B3
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Apr 2026 04:31:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6EWlNrgr12lLIgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 09 Apr 2026 04:31:52 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 1/5] btrfs-progs: mkfs-tests: also test hole-deteciton without no-holes
Date: Thu,  9 Apr 2026 14:01:13 +0930
Message-ID: <2b987f5ffc1e07aa91402d553d38547edc3faee2.1775708393.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1775708393.git.wqu@suse.com>
References: <cover.1775708393.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_ONE(0.00)[1];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:mid,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Queue-Id: E643A4ED4A
X-Spam-Flag: NO
X-Spam-Score: -3.01
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

