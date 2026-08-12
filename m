Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF8F42A792
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Aug 2026 23:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786576514; cv=none; b=CYE8/0fA+CjVXJ/RyzguVNBSJ+RcUsoM0zUg1mmQEDnCfB4b38M4HK/dZ0JXHjV0UorIjxr3/ItGH3uBGnw98oNUQf15BJqtMVDauEsOWRqH2I/0r6CmjkhtOxguSsZIfOkYUuAD8HFDJIuWna1K326MXFOlBcSRj9CUT2RDGxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786576514; c=relaxed/simple;
	bh=LGyTrqYK9cPnn+w/uU/Iz6xGdbwzXUyMfD2Vd745NeI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=NuD9l/AYp1MBSznlSLcKujKTKOFA1hk+OhLKQIL4UlenrMzEkR2gQu5tssIjHglrjyLNcWaemPqxvEG5YKWyfNUoBJfEqUaoyUS2wo/pqXhnddVXFwaWz6EQAHlY/euzlRVl/bC5J/oCjeV0NJ5QZq8hujVeCDO1g2OMl7KDSnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=iktshLb2; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=cdfMGdV9; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="iktshLb2";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="cdfMGdV9"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5583782593
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Aug 2026 23:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1786576506; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=r7QuhPRw062tgzoFFi5dAhV9mlow1BxAiX2EnPhDGds=;
	b=iktshLb2MLrV6pHxD2Xx6f3XlngZcMvt+oj7PaoZuTF+gowKVGv2VV1jtmRUJ4TSYJK3kI
	vc1xIsHuZPt+gUsoGqGeD51pDeMhSn7UamYdXzz007lgFE55EyJxf0dk1fxvdGWhyL2XGg
	PHkdW4AC4RojEiWmZnf8jZBTsHnq99I=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=cdfMGdV9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1786576502; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=r7QuhPRw062tgzoFFi5dAhV9mlow1BxAiX2EnPhDGds=;
	b=cdfMGdV9maz6fcLv8Zca55kt+yuUp8UzqyW1796UnXJXrPDLMRN5mwGMQUirsipzNrjQ+G
	Lc4p7K4SSQfACqeZky2kMBjP8gNaYgBfvN899uSjesrkdWLI0uVwdWU2eoEfYYX1k+0cda
	Q/2HjaiSvs6VrmyFfgmL1NwFsYIPacM=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 71B6777AEB
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Aug 2026 23:15:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id J3+NCnX+fGoyAwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Aug 2026 23:15:01 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: properly cleanup replace_task when the replace failed to start
Date: Thu, 13 Aug 2026 08:44:39 +0930
Message-ID: <8e4f535ac093c7085ab0641114e2f082788585f5.1786576348.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 5583782593
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
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_ONE(0.00)[1];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
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
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,sashiko.dev:url]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

In the function btrfs_dev_replace_start(), we have several error paths
that assigns replace_task without reverting it back to NULL.

There are two involved error paths:

- There is already a running dev-replace
  Then replace_task is over-written to the current task.
  This is the one with long running effect.

- The btrfs_start_transaction() call failed
  This is much harder to hit though.

This can result the replace_task check inside btrfs_map_block() to be
incorrectly triggered, not taking dev_replace->rwsem, and may get an
incorrect/stale view on replace related structures.

Thankfully this bug is very hard to hit.

As dev-replace is an exclusive operation, thus if there is already
a running replace, a new one will be rejected early without reaching
btrfs_dev_replace_start().

The only remaining case is a suspended replace, which is much harder to
hit, e.g. requiring async dev-replace conflicting with another exclusive
operation, then a new replace is started.

Fix the problem by:

- Moving the replace_task assignment after replace_state check in
  btrfs_dev_replace_start()

- Reset replace_task to NULL if btrfs_start_transaction() failed
  in btrfs_dev_replace_start()

- Reset replace_task to NULL for all paths of
  btrfs_dev_replace_finishing()

This is reported by Sashiko, which found the existing bug during review
of another patch, and since the bug is an existing one, it's not shown in
the summary, but only in the detail page.

Link: https://sashiko.dev/#/patchset/tencent_853134544C3CE88A219EEB21346E2510D308%40qq.com
Fixes: 8cca35cb29f8 ("btrfs: don't take dev_replace rwsem on task already holding it")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Changelog:
v2:
- Fix incorrect member names in the commit message

- Update the commit message to show that the bug is very hard to hit
  Mostly rejected by the exclusive operation, which rejects new replace
  early.

- Update btrfs_dev_replace_finishing() to reset replace_task
---
 fs/btrfs/dev-replace.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 72cba7fed942..c5e67524b417 100644
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
@@ -874,18 +875,20 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	/* don't allow cancel or unmount to disturb the finishing procedure */
 	mutex_lock(&dev_replace->lock_finishing_cancel_unmount);
 
-	down_read(&dev_replace->rwsem);
+	down_write(&dev_replace->rwsem);
+	dev_replace->replace_task = NULL;
+
 	/* was the operation canceled, or is it finished? */
 	if (dev_replace->replace_state !=
 	    BTRFS_IOCTL_DEV_REPLACE_STATE_STARTED) {
-		up_read(&dev_replace->rwsem);
+		up_write(&dev_replace->rwsem);
 		mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
 		return 0;
 	}
 
 	tgt_device = dev_replace->tgtdev;
 	src_device = dev_replace->srcdev;
-	up_read(&dev_replace->rwsem);
+	up_write(&dev_replace->rwsem);
 
 	/*
 	 * flush all outstanding I/O and inode extent mappings before the
@@ -986,8 +989,6 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 
 	list_add(&tgt_device->dev_alloc_list, &fs_devices->alloc_list);
 	fs_devices->rw_devices++;
-
-	dev_replace->replace_task = NULL;
 	up_write(&dev_replace->rwsem);
 	btrfs_rm_dev_replace_blocked(fs_info);
 
-- 
2.54.0

