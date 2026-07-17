Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61DA13DA7F8
	for <linux-btrfs@vger.kernel.org>; Fri, 17 Jul 2026 07:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784272059; cv=none; b=eT0qPHwDj4qNpPWMHYFGe6MTnBsq9foFS5VUYpiJDO+hIADYfsNhg2WU164nK5V+suaG0GD+yXOsGBzo70CLUsnUEG3YbI3kHj0JMeuRK4c3FTcjYZ02PoQDYWWWeJNeBKgeUp44mdhGNwxmdOvUvgQFi66gr5E3sM12s4CbQhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784272059; c=relaxed/simple;
	bh=Se6FgeiLE4IJBAdWrogPZ4SMnscez9Le0lcFNl/LIiQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=EB6AjsbGyZD+ZVL9LOZi42ABi8bd9sy/ZWROxGKttVU07MyYWnJo7i+3s49ryDc4d0LoRc2+YHMqi+ig1MOzzvSRrYa7ncNoFC+sy+1tZ/IS1IHEwTeYKt2miuispJoiOYkB0qrGwv6N5xiHFPhzaE0+h9uyqp0UAIHSRPPVvQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=b8Kw7Jgu; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=b8Kw7Jgu; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="b8Kw7Jgu";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="b8Kw7Jgu"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7ECD678D88;
	Fri, 17 Jul 2026 07:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1784272056; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=kQFcQBfrd1ei6Xfh9tdrBykU2TBH0pZct8isXwZ9F2o=;
	b=b8Kw7JguBm2lFv4cRntULYt1T9sLhPoXyyMze+KpK2UL1on4/NvueK9lOjQ4C3Pzo8UsM6
	ITMRBT7ZIAXa4VWj88+XQ24A6RufgXNIvcj9JXr/RoTyJFzxF/KdfwV3Iq9tYs4XA+h7kz
	rQEN9pH9PCW+V7a9uMP/DVd/iK72oUc=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1784272056; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=kQFcQBfrd1ei6Xfh9tdrBykU2TBH0pZct8isXwZ9F2o=;
	b=b8Kw7JguBm2lFv4cRntULYt1T9sLhPoXyyMze+KpK2UL1on4/NvueK9lOjQ4C3Pzo8UsM6
	ITMRBT7ZIAXa4VWj88+XQ24A6RufgXNIvcj9JXr/RoTyJFzxF/KdfwV3Iq9tYs4XA+h7kz
	rQEN9pH9PCW+V7a9uMP/DVd/iK72oUc=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 84161779AA;
	Fri, 17 Jul 2026 07:07:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id A7TsEbfUWWodbwAAD6G6ig
	(envelope-from <wqu@suse.com>); Fri, 17 Jul 2026 07:07:35 +0000
From: Qu Wenruo <wqu@suse.com>
To: fstests@vger.kernel.org,
	linux-btrfs@vger.kernel.org
Subject: [PATCH] fstests: vfstest: skip rejected tmpfile creation
Date: Fri, 17 Jul 2026 16:37:17 +0930
Message-ID: <20260717070717.113517-1-wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 
X-Spam-Score: -2.80

Since kernel commit 539dce114465 ("fs: refuse O_TMPFILE creation with an
unmapped fsuid or fsgid"), tmpfile creation can be rejected with
EOVERFLOW, so also skip that error number to avoid false alerts like the
following:

 FSTYP         -- ext4
 PLATFORM      -- Linux/x86_64 btrfs-vm 7.2.0-rc3-custom+ #411 SMP PREEMPT_DYNAMIC Fri Jul 17 16:24:34 ACST 2026
 MKFS_OPTIONS  -- -F /dev/mapper/test-scratch1
 MOUNT_OPTIONS -- -o acl,user_xattr /dev/mapper/test-scratch1 /mnt/scratch

 generic/633  1s ... - output mismatch (see /home/adam/xfstests/results//generic/633.out.bad)
    --- tests/generic/633.out	2022-05-11 11:25:30.816666664 +0930
    +++ /home/adam/xfstests/results//generic/633.out.bad	2026-07-17 16:25:45.033967541 +0930
    @@ -1,2 +1,4 @@
     QA output created by 633
     Silence is golden
    +utils.c: 948: openat_tmpfile_supported - Value too large for defined data type - failure: create
    +utils.c: 948: openat_tmpfile_supported - Value too large for defined data type - failure: create
    ...
    (Run 'diff -u /home/adam/xfstests/tests/generic/633.out /home/adam/xfstests/results//generic/633.out.bad'  to see the entire diff)
 Ran: generic/633
 Failures: generic/633
 Failed 1 of 1 tests

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 src/vfs/utils.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/src/vfs/utils.c b/src/vfs/utils.c
index 0b435afe..d2922cc3 100644
--- a/src/vfs/utils.c
+++ b/src/vfs/utils.c
@@ -941,7 +941,11 @@ bool openat_tmpfile_supported(int dirfd)
 
 	fd = openat(dirfd, ".", O_TMPFILE | O_RDWR, S_IXGRP | S_ISGID);
 	if (fd == -1) {
-		if (errno == ENOTSUP) {
+		/*
+		 * Kernel commit 539dce114465 ("fs: refuse O_TMPFILE creation
+		 * with an unmapped fsuid or fsgid") will reject such operation.
+		 */
+		if (errno == ENOTSUP || errno == EOVERFLOW) {
 			errno = 0; /* Don't report misleading errno. */
 			return false;
 		} else {
-- 
2.51.2

