Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EAE73016E0
	for <linux-btrfs@vger.kernel.org>; Mon, 18 May 2026 10:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779099700; cv=none; b=c4cOY1L9qqRSeVygSojAjQlcHURj2tgFTj7p5c3/AV1QzQuybYcvqSCXxNjHHqK53ckxfsgCe/ksqNJn4d6Lp9KJUN4R3sHeRh5Amog79tRslubPSLmjzxxp/BD56qFoS/EYkQrUTuY8qqqK/rz5vDDx30IXuSKB6GbkQCNaDGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779099700; c=relaxed/simple;
	bh=64UzFHNWdjX5yv9lrPSdNqvLC5a1fQbLIxNpOIdPUhs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cN51PSbPgR2ZgjqDXSJ1BxVV6r03BbEzW2kSxQLZAwjHohlIwVwMo2unEja4JLQIvMKHkSs56e6wUEi5rtW8zfV0BhBkilNYzZWTBF6Wp6DOVI55YEzkq2XuYXdQwsGKeqy4Vvp+vraMvigSTHioyBdNU2ywwWQMpDU1w10QEmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Sba8Tv0O; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Sba8Tv0O; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Sba8Tv0O";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Sba8Tv0O"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 60D9666F3E
	for <linux-btrfs@vger.kernel.org>; Mon, 18 May 2026 10:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779099682; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qr/jlm/sIX7bHunybyHOSOFnJN22opUSrNp3mVsJkfM=;
	b=Sba8Tv0OO+lZCRc0z4USh5GEzZFtNkY+nsXW/SMjjb3e3soWp5NakHqGSfZ6wQ/keQO+SB
	7EDaVt9HVZ6srFML5hvqezf4hKqq4nd/eCkM2uNU8LvTnj1o6EWQm/Oq0ctrb3OmDnqu11
	APA9oNGhNWTpczjfg1tFjLLJcW+7jeM=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=Sba8Tv0O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779099682; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qr/jlm/sIX7bHunybyHOSOFnJN22opUSrNp3mVsJkfM=;
	b=Sba8Tv0OO+lZCRc0z4USh5GEzZFtNkY+nsXW/SMjjb3e3soWp5NakHqGSfZ6wQ/keQO+SB
	7EDaVt9HVZ6srFML5hvqezf4hKqq4nd/eCkM2uNU8LvTnj1o6EWQm/Oq0ctrb3OmDnqu11
	APA9oNGhNWTpczjfg1tFjLLJcW+7jeM=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9C14F593A8
	for <linux-btrfs@vger.kernel.org>; Mon, 18 May 2026 10:21:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ELmrFyHoCmorFwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 18 May 2026 10:21:21 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] btrfs-progs: mkfs-tests: add a new one for '--reflink' option
Date: Mon, 18 May 2026 19:50:59 +0930
Message-ID: <3b489cc531a933a09771af2b9f653fca997241a3.1779099356.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1779099356.git.wqu@suse.com>
References: <cover.1779099356.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Rspamd-Action: no action
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
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_ONE(0.00)[1];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:dkim,suse.com:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 60D9666F3E
X-Spam-Level: 

The new reflink option will allow mkfs.btrfs to reflink the aligned
blocks from the source fs to the fs image.

This will allow us to skip the time consuming IO.

The test case create a special layout to exercise the corner cases, the
layout looks like:

 $TEST_MNT
 |- rootdir/
 |  |- aligned	               <--- 16M file, the regular routine.
 |  |- multi_block_unaligned   <--- 65K file, checking the handling of
 |  |                               of the last partial block.
 |  |- partial_block           <--- 2K file, would be inlined.
 |  |- hole                    <--- A hole.
 |- image                      <--- The fs image.

Then create the image using the same rootdir/, but with and without
--reflink option.

Verify both image by checking the contents (through md5sum), and throw
"btrfs check --check-data-csum" on them.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 tests/mkfs-tests/043-rootdir-reflink/test.sh | 57 ++++++++++++++++++++
 1 file changed, 57 insertions(+)
 create mode 100755 tests/mkfs-tests/043-rootdir-reflink/test.sh

diff --git a/tests/mkfs-tests/043-rootdir-reflink/test.sh b/tests/mkfs-tests/043-rootdir-reflink/test.sh
new file mode 100755
index 000000000000..ff012ce2db29
--- /dev/null
+++ b/tests/mkfs-tests/043-rootdir-reflink/test.sh
@@ -0,0 +1,57 @@
+#!/bin/bash
+# Make sure the --reflink option works.
+
+source "$TEST_TOP/common" || exit
+
+check_prereq mkfs.btrfs
+check_prereq btrfs
+
+setup_root_helper
+prepare_test_dev
+
+verify_fs_image()
+{
+	# Verify the content of the new fs image
+	run_check $SUDO_HELPER mount "$TEST_MNT/image" "$TEST_MNT/rootdir"
+	run_check $SUDO_HELPER md5sum -c "$TEST_MNT/md5sum"
+	run_check $SUDO_HELPER umount "$TEST_MNT/rootdir"
+	run_check $SUDO_HELPER "$TOP/btrfs" check --check-data-csum "$TEST_MNT/image"
+	# Wait for the loopdev of "$TEST_MNT/image" to be completely removed, so that we can
+	# unmount "$TEST_MNT"
+	run_mayfail $SUDO_HELPER udevadm settle
+}
+
+run_check_mkfs_test_dev
+run_check_mount_test_dev -o max_inline=0
+
+# Populate the rootdir
+run_check $SUDO_HELPER mkdir -p "$TEST_MNT/rootdir"
+
+# A regular 16M file, exercising the aligned block handling.
+run_check $SUDO_HELPER dd if=/dev/urandom of="$TEST_MNT/rootdir/aligned" \
+	bs=1M count=16 status=noxfer > /dev/null 2>&1
+
+# A regular 65K file, mixing aligned block handling and the tailing partial block
+# handling.
+run_check $SUDO_HELPER dd if=/dev/urandom of="$TEST_MNT/rootdir/multi_block_unaligned" \
+	bs=1K count=65 status=noxfer > /dev/null 2>&1
+
+# A regular 2K file, should be inlined inside the fs image.
+run_check $SUDO_HELPER dd if=/dev/urandom of="$TEST_MNT/rootdir/partial_block" \
+	bs=1K count=2 status=noxfer > /dev/null 2>&1
+
+# A hole
+run_check $SUDO_HELPER truncate -s 37k "$TEST_MNT/rootdir/hole"
+
+run_check sync
+
+# Generate the md5sum for all above files.
+run_check_stdout $SUDO_HELPER find "$TEST_MNT/rootdir" -type f -exec md5sum {} \+ > "$TEST_MNT/md5sum"
+
+run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f "$TEST_MNT/image" --reflink --rootdir "$TEST_MNT/rootdir"
+verify_fs_image
+
+run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f "$TEST_MNT/image" --rootdir "$TEST_MNT/rootdir"
+verify_fs_image
+
+run_check $SUDO_HELPER umount "$TEST_MNT"
-- 
2.54.0

