Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95D521CC59
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2026 07:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774854609; cv=none; b=YpWKFH4L9TlN0wyOBslOA1GwJFDSJ9fA4JM/b6tTOtbeYetYiCuYqwZ6a+o1RTF5eCsCuMoKam2/bCR4vFLRfdpWmkZodK2KROuzkK3nU4MMQqV6svb/uxZH2xGiA5BD9GvEP3k/36M7puFTUqIsJ60RaSd83QpS/SOyRQnaisI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774854609; c=relaxed/simple;
	bh=o1dDYDZVInjuTiNCd++FEl0JijPFz4adsRQP2615eXM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MVU2HSNyMmU4LRMTpdLz8Xwf8BDuX9Vtdgb4KoGHdLdYVeXbfw0o+QNn1ecBVnQMprEIjkuKvM5t+mYyPQ9+RZfRBB2LK5j7ApaOFhB+pTMobIF41eYVmbd2XggaPnbtyZthcWzvqkYabQ3ShRD+mYjC+9z4UkzZFNtkir1zVSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=R2Fbir8n; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=R2Fbir8n; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="R2Fbir8n";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="R2Fbir8n"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0893F5BE7A
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2026 07:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1774854606; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K62tuD5UYAtB0K/ooFv9ntVnnOfcvWzwAUGvP/SZ2FQ=;
	b=R2Fbir8njFaAA9c3DHZMRWmkPp9T4y5NmQP8RiRkwn/nV4AMhqGdQ0IAhsBpWrTvIhSj5y
	zDy8O2EzUOhnbJPZFZzkTgSjmuVgfCzSeandjZHRY06vBoAPces21UomdyziP7EZqSp06B
	7A454ZTMCblOD6we4PpxaYFYsErlLhE=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=R2Fbir8n
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1774854606; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K62tuD5UYAtB0K/ooFv9ntVnnOfcvWzwAUGvP/SZ2FQ=;
	b=R2Fbir8njFaAA9c3DHZMRWmkPp9T4y5NmQP8RiRkwn/nV4AMhqGdQ0IAhsBpWrTvIhSj5y
	zDy8O2EzUOhnbJPZFZzkTgSjmuVgfCzSeandjZHRY06vBoAPces21UomdyziP7EZqSp06B
	7A454ZTMCblOD6we4PpxaYFYsErlLhE=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4AA024A0A2
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2026 07:10:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4DgQBM0hymk8DgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2026 07:10:05 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/4] btrfs-progs: mkfs-tests: add a new test case for fiemap based detection
Date: Mon, 30 Mar 2026 17:39:38 +1030
Message-ID: <8cac9dd81630ef112158aeaa697e78c1716cb91f.1774854459.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774854459.git.wqu@suse.com>
References: <cover.1774854459.git.wqu@suse.com>
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
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_ONE(0.00)[1];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_HAS_DN(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:mid,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Queue-Id: 0893F5BE7A
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

The new test case will create an inode on btrfs, with the following
layout:

- [0, 16K): hole
- [16K, 32K): regular
- [32K, 64K): hole
- [64K, 80K): prealloc
- [80K, 84K): regular

Using fiemap based detection, we should be able to create a btrfs with
exactly the same layout.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 tests/mkfs-tests/042-fiemap-detection/test.sh | 76 +++++++++++++++++++
 1 file changed, 76 insertions(+)
 create mode 100755 tests/mkfs-tests/042-fiemap-detection/test.sh

diff --git a/tests/mkfs-tests/042-fiemap-detection/test.sh b/tests/mkfs-tests/042-fiemap-detection/test.sh
new file mode 100755
index 000000000000..e652791565ce
--- /dev/null
+++ b/tests/mkfs-tests/042-fiemap-detection/test.sh
@@ -0,0 +1,76 @@
+#!/bin/bash
+# Test basic hole detection features
+
+source "$TEST_TOP/common" || exit
+
+check_prereq mkfs.btrfs
+check_prereq btrfs
+check_global_prereq xfs_io
+
+if ! [ -f "/sys/fs/btrfs/features/supported_sectorsizes" ]; then
+	_not_run "kernel support for different block sizes missing"
+fi
+
+setup_root_helper
+
+# tmpdir is normally inside /tmp, which can be tmpfs on a lot of distro.
+# Unfortunately tmpfs doesn't support fiemap ioctl.
+# So we need another btrfs as rootdir.
+setup_loopdevs 2
+prepare_loopdevs
+
+real_dev=${loopdevs[1]}
+rootdir_dev=${loopdevs[2]}
+
+blocksize_supported=false
+for bs in $(cat /sys/fs/btrfs/features/supported_sectorsizes); do
+	if [ "$bs" == "4096" ]; then
+		blocksize_supported=true
+	fi
+done
+
+if [ "$blocksize_supported" != "true" ]; then
+	_not_run "kernel support for mounting blocksize 4096 is missing"
+fi
+
+run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f -s 4k -O no-holes "$rootdir_dev"
+run_check $SUDO_HELPER mount "$rootdir_dev" "$TEST_MNT"
+
+# Create an inode with holes, preallocated and regular file extents.
+run_check $SUDO_HELPER xfs_io -f \
+	-c "pwrite 16k 16k" -c "falloc 64k 16k" -c "pwrite 80k 4k" -c sync \
+	"$TEST_MNT/foobar"
+
+run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f --rootdir "$TEST_MNT" "$real_dev"
+run_check $SUDO_HELPER umount "$TEST_MNT"
+
+run_check $SUDO_HELPER "$TOP/btrfs" check "$real_dev"
+
+# Check the dump-tree of each extent at filepos 16K, 64K and 80K.
+run_check $SUDO_HELPER "$TOP/btrfs" inspect-internal dump-tree -t 5 "$real_dev"
+
+if ! "$TOP/btrfs" ins dump-tree -t 5 "$real_dev" |\
+	grep -A1 "EXTENT_DATA 16384" | grep -q "type 1 (regular)"; then
+	_fail "data extent at 16K is not regular"
+fi
+
+if ! "$TOP/btrfs" ins dump-tree -t 5 "$real_dev" |\
+	grep -A1 "EXTENT_DATA 65536" | grep -q "type 2 (prealloc)"; then
+	_fail "data extent at 64K is not preallocated"
+fi
+
+if ! "$TOP/btrfs" ins dump-tree -t 5 "$real_dev" |\
+	grep -A1 "EXTENT_DATA 81920" | grep -q "type 1 (regular)"; then
+	_fail "data extent at 80K is not regular"
+fi
+
+# Since we have no-holes features, the extents at 0K, 32K should not exist
+if "$TOP/btrfs" ins dump-tree -t 5 "$real_dev" | grep -q "EXTENT_DATA 0"; then
+	_fail "data extent at 0 is not a hole"
+fi
+
+if "$TOP/btrfs" ins dump-tree -t 5 "$real_dev" | grep -q "EXTENT_DATA 32768"; then
+	_fail "data extent at 0 is not a hole"
+fi
+
+cleanup_loopdevs
-- 
2.53.0

