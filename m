Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE5737E5D7
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Aug 2026 07:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786348317; cv=none; b=eSq5NJFhsKSLhM+1WZ5SGrGBLhJGq4OYjaIziSqyfqUTnyR/6luU9FIexW9pHjPNJCL/n6xKp4pAIX7XcvDGm/L5RfFLeNXav4JhdDv9GoSnVSi1dwnwWhisYpzrPUU3oX7tEkf95jBscKF89hXKM4thixhydJ9D3IiOyHQM0Vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786348317; c=relaxed/simple;
	bh=rMQwVCmJo51l6jAyxE2zpJhbyfDt8vECVu0VMwAtClE=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=M+xXRN0k8gMLrUwuVb6wj048sy0467ysAHfK0YV8NTtW2QB4J4hKL8dNQ+bVdTyRgnL3d4DIzSa53fBAuFJrHrIXHW5wIGDFOlSurtcc7VbUjs17+zOH6OfBFP5+DSmADNSQFlcQeVPsWjsDlnWO/ogkHdrA3UzhNg6rsVLp+Xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=oFjDrxta; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=lT8t8lmU; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="oFjDrxta";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="lT8t8lmU"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CA2214209
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Aug 2026 07:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1786348309; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Kjkk8RYd8Em8KOc0bQlYjKUXTxUYzBrOEeWYaTzgaYM=;
	b=oFjDrxtaJo5NsRikXnaFiSFXDYwuLjeTdhpaHC9c1PE8xetaYi5CL74q8zGL4XkZEpQTGg
	Qu9wJB+Xg0TA9V0EHsdvY4fVhd4Yay0n8wdwtn+lgCPV4oKaCWT9G27q4FXKDmFQA2TrTP
	TVjfBYdrojNV8m0JY/OFTmxZNili3nM=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=lT8t8lmU
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1786348305; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Kjkk8RYd8Em8KOc0bQlYjKUXTxUYzBrOEeWYaTzgaYM=;
	b=lT8t8lmUmNZMHEwzDETE1aeTt0kFeKIHuWwTuzOG5kvLVG8but/62z6HLv7V6eIDDL2rQQ
	KYbI2/ORzw246a/bETRUzsw4Gy3v8l0jfkavAYYYIq6UmzJCq/3Su+MSx7mOugsLc8jD7C
	T0jfrs0fuNY9EpdJ1jSaCzNn7TSjS1Y=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B2605779B2
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Aug 2026 07:51:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wg00FhCDeWrzUQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Aug 2026 07:51:44 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: properly cleanup replace_task when the replace failed to start
Date: Mon, 10 Aug 2026 17:21:25 +0930
Message-ID: <2bb108e8d3204506a80562fec03d0d365583631f.1786348282.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
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
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sashiko.dev:url,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:mid,suse.com:dkim]
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Queue-Id: CA2214209
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

In the function btrfs_dev_replace_start(), we have several error paths
that assigns replace_start without reverting it back to NULL.

There are two involved error paths:

- There is already a running dev-replace
  Then replace_task is over-written to the current task.
  This is the one with long running effect.

- The btrfs_start_transaction() call failed
  This is much harder to hit though.

This can result the replace_task check inside btrfs_map_block() to be
incorrectly triggered, not taking dev_replace->rwsem.

Normally that replace_task check is to protect regular IOs from racing
with dev-replace, which will modify the device list.

But since dev_replace->rwsem is incorrectly updated, a process
triggering the update will no longer be protected from dev-replace's
device list modification, thus later IO can get stale device info,
triggering things like use-after-free.

Fix the problem by:

- Moving the replace_task assignment after replace_state check

- Reset replace_task to NULL if btrfs_start_transaction() failed

This is reported by Sashiko, which found the existing bug during review
of another patch, and since the bug is an existing one, it's not shown in
the summary, but only in the detail page.

Link: https://sashiko.dev/#/patchset/tencent_853134544C3CE88A219EEB21346E2510D308%40qq.com
Fixes: 8cca35cb29f8 ("btrfs: don't take dev_replace rwsem on task already holding it")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/dev-replace.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 72cba7fed942..5fc1dec88fb2 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -633,7 +633,6 @@ static int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
 		goto leave;
 
 	down_write(&dev_replace->rwsem);
-	dev_replace->replace_task = current;
 	switch (dev_replace->replace_state) {
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_NEVER_STARTED:
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_FINISHED:
@@ -647,6 +646,7 @@ static int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
 		goto leave;
 	}
 
+	dev_replace->replace_task = current;
 	dev_replace->cont_reading_from_srcdev_mode = read_src;
 	dev_replace->srcdev = src_device;
 	dev_replace->tgtdev = tgt_device;
@@ -693,6 +693,7 @@ static int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
 			BTRFS_IOCTL_DEV_REPLACE_STATE_NEVER_STARTED;
 		dev_replace->srcdev = NULL;
 		dev_replace->tgtdev = NULL;
+		dev_replace->replace_task = NULL;
 		up_write(&dev_replace->rwsem);
 		goto leave;
 	}
-- 
2.54.0

