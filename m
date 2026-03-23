Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18364AD4B
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2026 05:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774245125; cv=none; b=DipWPGsAJ7QPmnqq1I0FcFeNPTzfrwhmw80GHqTEkpp6j2tFJeKjSaoG3yLIp6OFzZAfQ08/SodImzsFrkDhjCnh5IgcW2kyuFNsaNsKgIDO4ZMTP+1AYHUyOu21rwvs8CTzYtsamgJRU9EsYGCRKCafaTpmGGPnQ+/K040cWcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774245125; c=relaxed/simple;
	bh=LMTavCZ/brHeiBKUz6p76LAGFXy/wgWdMttpGrkVctE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DQK0uDTeEvXDJMMlCy6Lr0yX5TGPryCGHFv1KQLbiqG0g8oEbHmwhTKXYTnJP2zmtDT3B73l2CXQwsCxiuKIZ7babjmyBz6oZ6klkPInx8uD0J8+GUfe/L7FENzir4556vk0/1CUlxLuLg0fW9IYnAb4cX9/kxKfT+19Bm7mcqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=NBiWn2bV; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=NBiWn2bV; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="NBiWn2bV";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="NBiWn2bV"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9F25E5BDB6
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2026 05:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1774245118; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b9TLNkDAf/hvqWfVIDbRK056CAYNsY+HDHZVZ2HtnV0=;
	b=NBiWn2bV55uSAKD13lsQy17io85iKSehy6zlMBtvYjKFvXeI/GQsRYiYKSs1MFYIawRIWq
	Bo+V+Ftaeha3f7Ehut4gnQxOufIcxeCXxy9iASNFUNhSr0HCPsGQMl9YQZMKWD2LxjEkLD
	QKABA+B+iJuKdWGm5usE/NypOZp1d8c=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=NBiWn2bV
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1774245118; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b9TLNkDAf/hvqWfVIDbRK056CAYNsY+HDHZVZ2HtnV0=;
	b=NBiWn2bV55uSAKD13lsQy17io85iKSehy6zlMBtvYjKFvXeI/GQsRYiYKSs1MFYIawRIWq
	Bo+V+Ftaeha3f7Ehut4gnQxOufIcxeCXxy9iASNFUNhSr0HCPsGQMl9YQZMKWD2LxjEkLD
	QKABA+B+iJuKdWGm5usE/NypOZp1d8c=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D9D8F43706
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2026 05:51:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wCKIJv3UwGlCAQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2026 05:51:57 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs-progs: mkfs-tests: add a test case for mkfs hole detection
Date: Mon, 23 Mar 2026 16:21:37 +1030
Message-ID: <d20f343cc00895c40a8f498ea01cf36bb9a91fb8.1774244873.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774244873.git.wqu@suse.com>
References: <cover.1774244873.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	DWL_DNSWL_LOW(-1.00)[suse.com:dkim];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	URIBL_BLOCKED(0.00)[suse.com:mid,suse.com:dkim,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_ONE(0.00)[1];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.01
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 9F25E5BDB6

The simple test case includes the following 3 patterns inside the
rootdir for hole detection:

- Full hole
  The whole file is a single hole.

- Middle data
  The head and tail parts are holes, and there is a single block of data
  in the middle.

- Middle hole
  There is a single block for the head and tail of the file.

Those files are inside a temporary directory, which is normally inside
'/tmp' thus is using page size as block size, but it can still be on
another fs.
Thus we have to properly grab the block size of the temporary directory
and check if we can mount the created fs first.

And verify the following aspects of those files after mounting the
created fs:

- The total amount of blocks written to the fs
  This is done by a plain 'du' call.
  We should get 3 data blocks written to the target fs thanks to the
  hole detection.

- The content of the files
  They should not change compared to the data in rootdir.

- Basic btrfs check
  The resulted fs should always pass btrfs check.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 tests/mkfs-tests/041-hole-detection/test.sh | 70 +++++++++++++++++++++
 1 file changed, 70 insertions(+)
 create mode 100755 tests/mkfs-tests/041-hole-detection/test.sh

diff --git a/tests/mkfs-tests/041-hole-detection/test.sh b/tests/mkfs-tests/041-hole-detection/test.sh
new file mode 100755
index 000000000000..8c21762ae6fe
--- /dev/null
+++ b/tests/mkfs-tests/041-hole-detection/test.sh
@@ -0,0 +1,70 @@
+#!/bin/bash
+# Test basic hole detection features
+
+source "$TEST_TOP/common" || exit
+
+check_prereq mkfs.btrfs
+check_prereq btrfs
+check_global_prereq du
+
+if ! [ -f "/sys/fs/btrfs/features/supported_sectorsizes" ]; then
+	_not_run "kernel support for different block sizes missing"
+fi
+
+setup_root_helper
+prepare_test_dev
+
+tmp=$(_mktemp_dir mkfs-rootdir)
+
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
+run_check truncate -s 1M "$tmp/full_hole"
+full_hole_before=$(run_check_stdout md5sum "$tmp/full_hole" | awk '{print $1}')
+run_check dd if=/dev/urandom of="$tmp/middle_data" bs=$blocksize seek=16 count=1
+run_check truncate -s $(($blocksize * 32)) "$tmp/middle_data"
+middle_data_before=$(run_check_stdout md5sum "$tmp/middle_data" | awk '{print $1}')
+run_check dd if=/dev/urandom of="$tmp/middle_hole" bs=$blocksize count=1
+run_check dd if=/dev/urandom of="$tmp/middle_hole" bs=$blocksize count=1 seek=16
+middle_hole_before=$(run_check_stdout md5sum "$tmp/middle_hole" | awk '{print $1}')
+
+run_check_mkfs_test_dev -s $blocksize --rootdir "$tmp"
+run_check $SUDO_HELPER "$TOP/btrfs" check "$TEST_DEV"
+run_check_mount_test_dev
+
+# There are only 3 blocks written, thus 'du' should only report such 3 blocks
+# used.
+blocks=$(run_check_stdout du -B $blocksize "$TEST_MNT" | awk '{print $1}')
+
+if [ "$blocks" != "3" ]; then
+	_fail "Unexpected number of blocks written, has $blocks expect 3"
+fi
+
+full_hole_after=$(run_check_stdout md5sum "$TEST_MNT/full_hole" | awk '{print $1}')
+middle_data_after=$(run_check_stdout md5sum "$TEST_MNT/middle_data" | awk '{print $1}')
+middle_hole_after=$(run_check_stdout md5sum "$TEST_MNT/middle_hole" | awk '{print $1}')
+
+if [ "$full_hole_before" != "$full_hole_after" ]; then
+	_fail "full_hole content changed"
+fi
+if [ "$middle_data_before" != "$middle_data_after" ]; then
+	_fail "middle_data content changed"
+fi
+if [ "$middle_hole_before" != "$middle_hole_after" ]; then
+	_fail "middle_hole content changed"
+fi
+
+run_check_umount_test_dev
+run_check rm -rf -- "$tmp"
-- 
2.53.0

