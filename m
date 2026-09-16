Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4B3A3EC6AE
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 06:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789541570; cv=none; b=c8mpW8O6RoT/FkiR4596HkNzKpuTgB6Y+uHTOk1YgGrrxWAEl8b8Xj0zjEA52J0bxzpxSOLqg6eXNaAGDUhpunoVo0pUUHku+Hw2l4e0+ub4X0Z2VA+PKTf9Toz/SfZt84opMTsQOPgTuDYKtq2D9KVr/WpRreuJjd52Kfl4oi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789541570; c=relaxed/simple;
	bh=KZdx3TTmhpQg4FWfLDKS/TQkqsTb+tobxloJy7TVdpk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pe9TcCifZJsew1C9Ws7rPdl8m55ksG1s64nW19ujyzTQj9qkR6/SxVLREyNwFHIfwno8LTCjU2rIlYiTMH9sn02t26WZajTo68MXpaJjVXE9zem7h0GwfO6rjuxUezU6gjkatDVwU4ktjPspmjKtPhxXapmpar9c7hFMMyUXoK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=amwCaZkC; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=RVRZ8Hzh; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="amwCaZkC";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="RVRZ8Hzh"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9538121C4D
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 06:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789541562; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T4HiVGijzTzTNlvqUc3Po87su7OBYepFYYU32gyasew=;
	b=amwCaZkCbhPN0vWJn/YUJmtcBDLG2e8HJQ8TyC6G6TFWyzUNIeK+XwqKwccBLx0AmU04gF
	ZCtNNw6rGu1F0YLpDp9N1dguXc8lWFcaageqjgThNyiLZuzjVN58t8DqxhkIRJGMBcYgne
	CV12VDsk0nvgFc52W0teW31M0ovncW4=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=RVRZ8Hzh
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789541558; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T4HiVGijzTzTNlvqUc3Po87su7OBYepFYYU32gyasew=;
	b=RVRZ8HzhXrzZrzts5UE/qrO5lzCaZX8JBSLkJAjr+7JllLFFlLqr5oLuOiKxEYfpUD7JPN
	ETZ/pmrdz/OZIbHwL3K9WPdmSK25n7bK3aphvSbAFKe+0wtUhkPj++A3JeFGrT97JILvJL
	fSC3cFvU3ANBDV5PV06pt/T1FqRudQw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5045E13888
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 06:52:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ts9hJK88qmr0ZAAAD6G6ig:T4
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 06:52:36 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] btrfs-progs: misc-tests: add a test case for btrfs-restore
Date: Wed, 16 Sep 2026 16:22:05 +0930
Message-ID: <278cc52554d86183072e4450da56c1771cb9db64.1789541428.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1789541428.git.wqu@suse.com>
References: <cover.1789541428.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 9538121C4D
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
	URIBL_BLOCKED(0.00)[suse.com:dkim,suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -3.01

The new test case will:

- Create an inlined compressed file extent
- Generate checksum for that file
- Use btrfs-restore to extract that file
- Compare the extracted file with the generated checksum

The checksum should match.

This is a regression test for a behavior change in kernel, which results
older btrfs-restore unable to handle newerly created inlined compressed
file extents.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 .../073-restore-inline-compressed/test.sh     | 28 +++++++++++++++++++
 1 file changed, 28 insertions(+)
 create mode 100755 tests/misc-tests/073-restore-inline-compressed/test.sh

diff --git a/tests/misc-tests/073-restore-inline-compressed/test.sh b/tests/misc-tests/073-restore-inline-compressed/test.sh
new file mode 100755
index 000000000000..e558cd372184
--- /dev/null
+++ b/tests/misc-tests/073-restore-inline-compressed/test.sh
@@ -0,0 +1,28 @@
+#!/bin/bash
+# Test "btrfs restore" on compressed inlined extents.
+
+source "$TEST_TOP/common" || exit
+source "$TEST_TOP/common.convert" || exit
+
+check_prereq mkfs.btrfs
+check_prereq btrfs
+check_global_prereq md5sum
+
+setup_root_helper
+prepare_test_dev
+
+tmp=$(_mktemp_dir "restore-destination")
+run_check_mkfs_test_dev
+run_check_mount_test_dev -o max_inline=4095
+run_check $SUDO_HELPER dd if=/dev/zero of="$TEST_MNT/foobar" bs=2k count=1 status=noxfer
+md5_before=$(run_check_stdout md5sum "$TEST_MNT/foobar" | cut -d ' ' -f 1)
+run_check_umount_test_dev
+
+run_check $SUDO_HELPER "$TOP/btrfs" restore "$TEST_DEV" "$tmp"
+md5_after=$(run_check_stdout md5sum "$tmp/foobar" | cut -d ' ' -f 1)
+
+rm -rf "$tmp"
+
+if [ "$md5_before" != "$md5_after" ]; then
+	_fail "md5 checksum mismatch"
+fi
-- 
2.55.0

