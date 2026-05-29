Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 650A52E738D
	for <linux-btrfs@vger.kernel.org>; Fri, 29 May 2026 09:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780047387; cv=none; b=StAHGhzXBfOz91kWFRVCqJuHaGkOvIbtXC7ENIX1w4WZjJFu7X0QmUntdXf/Vr/VmXAsHloBnHQrj0UK0xunKHnEIfqX2RjRDMyVmI0zmDjP3EhHDxB7Uix/+HPxDeDr9GTsR9lTVoeWb9qd4ohVdjFBEpGzpYjYUt+0QpjlsaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780047387; c=relaxed/simple;
	bh=nbyTDijRfeNYWfRwC5x/RJ6dh9ljP/Izsn76VbKaYXQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VyBSrsMiIVMLTxg+qFVP9/IsuTgLw9r+wIoSDw92r97Gctk/wjOkhrFH45kuJhC1PSuzZgN5jPJKAsWxr5J1xR46UgzzxhV+P1ZVtgZ0hzkeuuKfaFsLyhgivjWH5B6gamcVD4k78OWBHU85cNpW04cakGcheckD3P0WIY7rpvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=uxBPhSri; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=uxBPhSri; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="uxBPhSri";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="uxBPhSri"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8A5C0672D3
	for <linux-btrfs@vger.kernel.org>; Fri, 29 May 2026 09:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780047384; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M/FR+upX8dl0L3WEfxxBYPS4faRmKar5WxMcWLw87Kw=;
	b=uxBPhSrizNYb9RTM8jkqhfQakon3m+9T8nCIW7Z79JJ8RmvNvavVxxtk7YS3NxFpXm2YOp
	YONugzzCry90za2ps1JSHgdkMqWwPryBzWTmhquiQU5DVxkVaf87FLyYE1JtFV8RWhZSw1
	LdpC8D3Q88EnbqJvKUGAYeFGzZXr7Cs=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780047384; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M/FR+upX8dl0L3WEfxxBYPS4faRmKar5WxMcWLw87Kw=;
	b=uxBPhSrizNYb9RTM8jkqhfQakon3m+9T8nCIW7Z79JJ8RmvNvavVxxtk7YS3NxFpXm2YOp
	YONugzzCry90za2ps1JSHgdkMqWwPryBzWTmhquiQU5DVxkVaf87FLyYE1JtFV8RWhZSw1
	LdpC8D3Q88EnbqJvKUGAYeFGzZXr7Cs=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C5F47779A8
	for <linux-btrfs@vger.kernel.org>; Fri, 29 May 2026 09:36:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SPsXIhdeGWqfWgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 29 May 2026 09:36:23 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs-progs: misc-tests: add a regression test case for dump tree
Date: Fri, 29 May 2026 19:06:18 +0930
Message-ID: <16951b47162f8240f973bddce798b7fb34542530.1780047275.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1780047275.git.wqu@suse.com>
References: <cover.1780047275.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:mid];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]

The new test case will:

- Create an empty btrfs
- Grab the chunk tree root bytenr
- Pass that bytenr into "btrfs ins dump-tree -b <bytenr>"
  That must success.

This is for the regression introduced by commit 408e45feb325
("btrfs-progs: dump-tree: add extra chunk type checks").

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 .../072-dump-tree-chunk-bytenr/test.sh        | 25 +++++++++++++++++++
 1 file changed, 25 insertions(+)
 create mode 100755 tests/misc-tests/072-dump-tree-chunk-bytenr/test.sh

diff --git a/tests/misc-tests/072-dump-tree-chunk-bytenr/test.sh b/tests/misc-tests/072-dump-tree-chunk-bytenr/test.sh
new file mode 100755
index 000000000000..ef4fc4659e4f
--- /dev/null
+++ b/tests/misc-tests/072-dump-tree-chunk-bytenr/test.sh
@@ -0,0 +1,25 @@
+#!/bin/bash
+# Test "btrfs ins dump-tree -b <bytenr>" when the bytenr belongs to a chunk
+# tree block.
+#
+# This is a regression test for commit 408e45feb325 ("btrfs-progs:
+# dump-tree: add extra chunk type checks"), which is too strict and
+# rejects chunk tree blocks.
+
+source "$TEST_TOP/common" || exit
+source "$TEST_TOP/common.convert" || exit
+
+check_prereq mkfs.btrfs
+check_prereq btrfs
+
+setup_root_helper
+prepare_test_dev
+
+run_check_mkfs_test_dev
+chunk_root=$(run_check_stdout "$TOP/btrfs" inspect-internal dump-tree -t chunk "$TEST_DEV" |\
+	     grep "owner CHUNK_TREE" | cut -f 2 -d\ )
+if [ -z "$chunk_root" ]; then
+	_fail "unable to get the chunk root bytenr"
+fi
+
+run_check "$TOP/btrfs" inspect-internal dump-tree -b "$chunk_root" "$TEST_DEV"
-- 
2.54.0

