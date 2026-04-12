Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A7419D89E
	for <linux-btrfs@vger.kernel.org>; Sun, 12 Apr 2026 05:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775970560; cv=none; b=tdHqd1nFT8hzTApA/eEvf5Aueqga1ib7zpt5wgOE/C4oMJrCCvgUarjHB95sV2erCr218WIyfkSVW+tNV5OGmn+Y9XgIMEpATa+lQ0NSgxAp3mrR+6gO9miJHQd/Oi+CaSAYWcxywe9Io02FzfQ/HAloAmoQ//1yBHUJIyvncTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775970560; c=relaxed/simple;
	bh=GSv5MJnMikMBmUfAMKvgfK/UVA/FdAGjwqDFRIQcyJU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZHdZ9fGphb5zsYSDQn8FAyHGQQARDaW1WRCcqOg0SrAN1VZH+Jndar2OU/KPAXcmkzLnHWohCtdiaRi7AKMErqJwIRqXKIHnUn9sHvoRx0BzZBVLradqegW8QmJ8vtFXqXVMT5uGOwZylQQJN3RdIZrSh3SnqHce+2vZWP0/86w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=P1w//PqH; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=P1w//PqH; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="P1w//PqH";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="P1w//PqH"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5E3D65BCCE
	for <linux-btrfs@vger.kernel.org>; Sun, 12 Apr 2026 05:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775970550; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wUV8RlXbCULJRnUCsDo9aKWHwMjlsRe5BowMnZk8pbE=;
	b=P1w//PqH8n3XPNdnHKM4vo8yiIJhK7k6yvqPejrx67MBBIjeM4bRZwbCDyfnfXfCZQUCXa
	5c2fW1ocrQ2ryDv0y4xv32VM49NzvlYN7cgv53UXdggBJzGIJn+nroypikccFR8lnlszbm
	VU8RhYhhwsZIdNIB6q6C/c7OBfY+Pps=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="P1w//PqH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775970550; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wUV8RlXbCULJRnUCsDo9aKWHwMjlsRe5BowMnZk8pbE=;
	b=P1w//PqH8n3XPNdnHKM4vo8yiIJhK7k6yvqPejrx67MBBIjeM4bRZwbCDyfnfXfCZQUCXa
	5c2fW1ocrQ2ryDv0y4xv32VM49NzvlYN7cgv53UXdggBJzGIJn+nroypikccFR8lnlszbm
	VU8RhYhhwsZIdNIB6q6C/c7OBfY+Pps=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 56F284A756
	for <linux-btrfs@vger.kernel.org>; Sun, 12 Apr 2026 05:09:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MNIpAfUo22k7AwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 12 Apr 2026 05:09:09 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] btrfs-progs: fsck-tests: add a new test case for squota lowmem false alerts
Date: Sun, 12 Apr 2026 14:38:45 +0930
Message-ID: <1afd1ff20e8997b7f3856a6ec0f0ea96f9ff7abc.1775970499.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1775970499.git.wqu@suse.com>
References: <cover.1775970499.git.wqu@suse.com>
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
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 5E3D65BCCE

The new test script will fill a btrfs with squota enabled:

- A file with regular data extents
- A file with preallocated extents
- Several files with inline extents to bump up the tree level
- Snapshot of a subvolume containing above files

Then run btrfs check to verify no error is found.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 tests/fsck-tests/073-squota/test.sh | 31 +++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)
 create mode 100755 tests/fsck-tests/073-squota/test.sh

diff --git a/tests/fsck-tests/073-squota/test.sh b/tests/fsck-tests/073-squota/test.sh
new file mode 100755
index 000000000000..54a38d9b2d18
--- /dev/null
+++ b/tests/fsck-tests/073-squota/test.sh
@@ -0,0 +1,31 @@
+#!/bin/bash
+#
+# Make sure "btrfs check" can handle EXTENT_OWNER_REF key type for squota
+#
+
+source "$TEST_TOP/common" || exit
+
+check_prereq btrfs
+check_prereq mkfs.btrfs
+check_global_prereq fallocate
+
+if [ ! -f /sys/fs/btrfs/features/simple_quota ] ; then
+	_not_run "no kernel simple quota support"
+fi
+
+setup_root_helper
+prepare_test_dev
+
+run_check_mkfs_test_dev -O squota
+run_check_mount_test_dev
+run_check $SUDO_HELPER "$TOP/btrfs" subvolume create "$TEST_MNT/subv1"
+run_check $SUDO_HELPER dd if=/dev/zero bs=1M count=1 of="$TEST_MNT/subv1/regular"
+run_check $SUDO_HELPER fallocate -l 8m "$TEST_MNT/subv1/preallocated"
+for ((i = 0; i < 64; i++)); do
+	run_check $SUDO_HELPER dd if=/dev/urandom bs=1K count=1 of="$TEST_MNT/subv1/inline_$i"
+done
+
+run_check $SUDO_HELPER "$TOP/btrfs" subvolume snapshot "$TEST_MNT/subv1" "$TEST_MNT/snap1"
+run_check_umount_test_dev
+
+run_check $SUDO_HELPER "$TOP/btrfs" check "$TEST_DEV"
-- 
2.53.0

