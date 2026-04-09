Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B60F383C7F
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Apr 2026 08:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775724760; cv=none; b=Oui3oDQZbbSk5Lxf8+lb6z61Qe5YEPR806stGuTcrOynNafs5xkMx+w17OHEK+rrAK7X3N2mxzPfp15uzettARXH5edbp3Q1u+c0aSY5mnfv6cvMxfrfpXrSx05BDWEX4jTPTFHDGxLhrHL/tGDNcsgE94QFxWP0wptXFZbja6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775724760; c=relaxed/simple;
	bh=HBWkVbtU3Sv9Kmic3vxUIIg+sWEhcH3BfW4Xuag6Etg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fnV1Qc+ES/ssoE8rQ4LSYoMUOuBZr21LNeDL2L9SNk6UQU9+V50z4s1thVBQ9WeOIb9xG2YLlDAzvvcmiLA85UJymZZNL1xmXmk2/xuoIUnoXfXzHatmkPaPd8EZmH0x2EDk9rhot11QE0zW/YfmAtZ4d1D12rRbYtO3Btd4FoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=DIfZ4LLr; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=DIfZ4LLr; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="DIfZ4LLr";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="DIfZ4LLr"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B45E04EE58
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Apr 2026 08:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775724747; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VxFyLuPipd3PyfTUhKNAVTUQrs++KMYc1LdGofuqjZs=;
	b=DIfZ4LLrjWzGwsd8AjY1KUUzkT8/F3vMw6WVDspwabA0D7SH1XqQpUXsSpLb4ITwPEer/y
	HmUHTrEIoESKlR3kny6IXcq0RarTK+ncO5mVFCg47QsSZaSr5DRWg1xzT26afQOZUVjZSL
	EhrmRLPbWY3FSdiKSH12h7ZmagXfotY=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=DIfZ4LLr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775724747; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VxFyLuPipd3PyfTUhKNAVTUQrs++KMYc1LdGofuqjZs=;
	b=DIfZ4LLrjWzGwsd8AjY1KUUzkT8/F3vMw6WVDspwabA0D7SH1XqQpUXsSpLb4ITwPEer/y
	HmUHTrEIoESKlR3kny6IXcq0RarTK+ncO5mVFCg47QsSZaSr5DRWg1xzT26afQOZUVjZSL
	EhrmRLPbWY3FSdiKSH12h7ZmagXfotY=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B130F4A0B3
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Apr 2026 08:52:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iBNwF8po12lUJwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 09 Apr 2026 08:52:26 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v4 2/5] btrfs-progs: mkfs-tests: add a test case to verify the content of rootdir
Date: Thu,  9 Apr 2026 18:22:01 +0930
Message-ID: <65131d2cfac2a7714eb3b45b0fb0c0c952d3dd10.1775724568.git.wqu@suse.com>
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
X-Rspamd-Queue-Id: B45E04EE58

When running mkfs.btrfs with --rootdir option, we should make sure the
resulted fs has the same content of the source fs.

Add a test case to verify that with the following contents as a rootdir:

- A regular file with random data
  The file size is 32M.

- A sparse file with random data
  The sparse file is 512M, but there is only a 1MiB random data at file
  offset 128M.

- A directory generated by fsstress

Then we take fssum of the rootdir, create the btrfs, mount the btrfs and
verify the contents against fssum.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 Makefile                                      |  2 +-
 tests/mkfs-tests/042-rootdir-contents/test.sh | 57 +++++++++++++++++++
 2 files changed, 58 insertions(+), 1 deletion(-)
 create mode 100755 tests/mkfs-tests/042-rootdir-contents/test.sh

diff --git a/Makefile b/Makefile
index cc998bf55f4a..f77494e8a71d 100644
--- a/Makefile
+++ b/Makefile
@@ -553,7 +553,7 @@ test-misc: btrfs btrfs-image btrfs-corrupt-block mkfs.btrfs btrfstune fssum fsst
 	@echo "  TEST     misc-tests.sh"
 	$(Q)bash tests/misc-tests.sh
 
-test-mkfs: btrfs mkfs.btrfs
+test-mkfs: btrfs mkfs.btrfs fssum fsstress
 	@echo "  TEST     mkfs-tests.sh"
 	$(Q)bash tests/mkfs-tests.sh
 
diff --git a/tests/mkfs-tests/042-rootdir-contents/test.sh b/tests/mkfs-tests/042-rootdir-contents/test.sh
new file mode 100755
index 000000000000..005ea28190b1
--- /dev/null
+++ b/tests/mkfs-tests/042-rootdir-contents/test.sh
@@ -0,0 +1,57 @@
+#!/bin/bash
+# Make sure the created btrfs with rootdir has its content matches its source
+
+source "$TEST_TOP/common" || exit
+
+check_prereq mkfs.btrfs
+check_prereq btrfs
+check_prereq fssum
+check_prereq fsstress
+
+if ! [ -f "/sys/fs/btrfs/features/supported_sectorsizes" ]; then
+	_not_run "kernel support for different block sizes missing"
+fi
+
+setup_root_helper
+prepare_test_dev
+
+fssum_prog="$INTERNAL_BIN/fssum"
+fsstress_prog="$INTERNAL_BIN/fsstress"
+tmp=$(_mktemp_dir mkfs-rootdir)
+
+mkdir "$tmp/rootdir"
+# Get the fs block size, normally it's page size (using tmpfs for /tmp),
+# but it can still be other values if /tmp is on a regular fs.
+blocksize=$(stat -f -c %S "$tmp")
+
+blocksize_supported=false
+for bs in $(cat /sys/fs/btrfs/features/supported_sectorsizes); do
+	if [ "$blocksize" == "$bs" ]; then
+		blocksize_supported=true
+	fi
+done
+
+if [ "$blocksize_supported" != "true" ]; then
+	_not_run "kernel support for mounting blocksize $blocksize is missing"
+fi
+
+run_check $SUDO_HELPER dd if=/dev/urandom of="$tmp/rootdir/large" bs=1M count=32
+run_check $SUDO_HELPER truncate -s 512M "$tmp/rootdir/sparse"
+run_check $SUDO_HELPER dd if=/dev/urandom of="$tmp/rootdir/sparse" bs=1M count=1 conv=notrunc seek=128
+run_check $SUDO_HELPER $fsstress_prog -w -n 256 -d "$tmp/rootdir/"
+run_check $SUDO_HELPER $fssum_prog -n -d -f -w "$tmp/fssum" "$tmp/rootdir"
+
+workload()
+{
+	run_check_mkfs_test_dev -s $blocksize --rootdir "$tmp/rootdir" $@
+	run_check $SUDO_HELPER "$TOP/btrfs" check "$TEST_DEV"
+	run_check_mount_test_dev
+
+	run_check $SUDO_HELPER $fssum_prog -r "$tmp/fssum" "$TEST_MNT/"
+	run_check_umount_test_dev
+}
+
+workload -O no-holes
+workload -O ^no-holes
+
+run_check rm -rf -- "$tmp"
-- 
2.53.0

