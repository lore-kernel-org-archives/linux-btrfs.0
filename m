Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C9823E25B
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Apr 2026 04:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775190833; cv=none; b=hi9WOnTtBxOD5sl9bRPGCzER5483PbVTcw83iC8ab2/puVikpxGkm749FVbAG8tNf9hPgBo7EVky2+zf83MAFh2FS26XQnriODtD1CEDi3dqex23IdtU/oY4yFiO2s1tIBMXldsgqCwokrOY5LJr0FIYxHJcqhEZEeV2BmUbJqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775190833; c=relaxed/simple;
	bh=X5eHUTtrTasC5G1KmZcPFZs4cSwQxwPXfmw5d5NQhaU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ewgmK1kfTkA5gvIFY43sTVZ3Xwlgf/UAlfFFKUNd2Ct4onxod0/7cq9lagzA2e60FiKkafyhXHAiTBl77w1OB+NZy92LYd2VzbQKawp6EQoN8csj3WfTw15VlbvtFQc+pprDQXJzXEQugT0PHoueSZ0TcpzAFu1AhpKMzBJvCbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=jRTaPTrr; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=jRTaPTrr; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="jRTaPTrr";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="jRTaPTrr"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2E0004D214
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Apr 2026 04:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775190806; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ySXuAI63ielpiWeevFFm8QHrY3n+SM8buchDmtX0+x4=;
	b=jRTaPTrr8tKuVJlvc5BcWtIcQY/GYfEkVfTpJeEAOqsf/5DvW9KDqEhFkROzhUS7XAyTpI
	HUzCbC0ZFg3oF7rgCwhb/aJUxPwN7lrUx8v9TTdGxhcbrs/ljDpiNs+PMI/+7HXn2jKU9d
	pEYgLojPcL4Qi0XcnCm0kqVX/V7iaGY=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=jRTaPTrr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775190806; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ySXuAI63ielpiWeevFFm8QHrY3n+SM8buchDmtX0+x4=;
	b=jRTaPTrr8tKuVJlvc5BcWtIcQY/GYfEkVfTpJeEAOqsf/5DvW9KDqEhFkROzhUS7XAyTpI
	HUzCbC0ZFg3oF7rgCwhb/aJUxPwN7lrUx8v9TTdGxhcbrs/ljDpiNs+PMI/+7HXn2jKU9d
	pEYgLojPcL4Qi0XcnCm0kqVX/V7iaGY=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6DDC54A0B0
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Apr 2026 04:33:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CDaNDBVDz2nTYQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 03 Apr 2026 04:33:25 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 6/6] btrfs-progs: mkfs-tests: add a new test case for fiemap based detection
Date: Fri,  3 Apr 2026 15:03:00 +1030
Message-ID: <aa6e7dbc740dd836a75418e0dababc3010dbd8b7.1775190565.git.wqu@suse.com>
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
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_ONE(0.00)[1];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:mid,suse.com:dkim,suse.com:email]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 2E0004D214

The new test case will create an inode on btrfs, with the following
layout:

- [0, 16K): hole
- [16K, 32K): regular
- [32K, 64K): hole
- [64K, 80K): prealloc
- [80K, 84K): regular

Using fiemap based detection, we should be able to create a btrfs with
exactly the same layout, verified by fssum with "-s" option.

And test both no-holes and ^no-holes features.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 tests/mkfs-tests/043-fiemap-detection/test.sh | 64 +++++++++++++++++++
 1 file changed, 64 insertions(+)
 create mode 100755 tests/mkfs-tests/043-fiemap-detection/test.sh

diff --git a/tests/mkfs-tests/043-fiemap-detection/test.sh b/tests/mkfs-tests/043-fiemap-detection/test.sh
new file mode 100755
index 000000000000..bf6b6f79cd9a
--- /dev/null
+++ b/tests/mkfs-tests/043-fiemap-detection/test.sh
@@ -0,0 +1,64 @@
+#!/bin/bash
+# Test basic hole detection features
+
+source "$TEST_TOP/common" || exit
+
+check_prereq mkfs.btrfs
+check_prereq btrfs
+check_prereq fssum
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
+fssum_prog="$INTERNAL_BIN/fssum"
+tmp=$(_mktemp_dir mkfs-fiemap)
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
+run_check $SUDO_HELPER $fssum_prog -n -d -s -f -w "$tmp/fssum" "$TEST_MNT"
+run_check $SUDO_HELPER umount "$TEST_MNT"
+
+workload()
+{
+	run_check $SUDO_HELPER mount "$rootdir_dev" "$TEST_MNT"
+	run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f --rootdir "$TEST_MNT" "$real_dev" $@
+	run_check $SUDO_HELPER umount "$TEST_MNT"
+
+	run_check $SUDO_HELPER "$TOP/btrfs" check "$real_dev"
+	run_check $SUDO_HELPER mount "$real_dev" "$TEST_MNT"
+	run_check $SUDO_HELPER $fssum_prog -r "$tmp/fssum" "$TEST_MNT"
+	run_check $SUDO_HELPER umount "$TEST_MNT"
+}
+
+workload -O no-holes
+workload -O ^no-holes
+run_check rm -rf -- "$tmp"
+cleanup_loopdevs
-- 
2.53.0

