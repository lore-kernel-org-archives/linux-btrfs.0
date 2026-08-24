Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85BFB37648F
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Aug 2026 04:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787546087; cv=none; b=sFErSjKz9oNCt6RZ6y3N9X78iZH+QmFfsLB6TH47ugr5v8uulU1iFSZCOvgNhdqzy7zY0lmmtS0oFz1CHCi1r1M2KeCAk75q7dR2tuzms1ypj2gDCAmT+R+TOgp90g/qpalcJlB4IjkW7LQFGty7G33O+41S1pRJ/aujBPHlunk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787546087; c=relaxed/simple;
	bh=Fk4OH4S+ZcUrOcuQmciT1KDywXrShmHE/BYsMsj7c+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AjAdRzuVvgzA6ldD1I7ANuQBkkl/SYJqVxixrndU9cqhYZU4SQIVxS79ta1D17HvahHyeLqtKSKSYMqEptKhNHq2yGZSar+blsph8hukHH+A5lyDDII02rZNsA+SlfXrq9/8cRB0nS7wl7mh/wQa30iU17mSA86RLpT2jRE09Bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=nXS+Na+V; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=UDRRgQXF; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="nXS+Na+V";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="UDRRgQXF"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6DAB93E51;
	Mon, 24 Aug 2026 04:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1787546079; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j5cCcBNPfuAZ1vtuon9NCITEciKzfZPDOoIBYUD0RK0=;
	b=nXS+Na+VcDvHaqtIYz7h5nRA969J3H4MNe0aCVXauE/vfLdjv8fhnC0Lv5rEb/iyGoxzOP
	8BALSHXoog+apNr+MHtyUtbvStIfUL0mTJpfU94Go4bEBC5c7dML8TJ0kgRbCNRXD0vSMr
	DlfgK72pCJb4FYp2sz5JfaAOvHRgtZg=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1787546075; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j5cCcBNPfuAZ1vtuon9NCITEciKzfZPDOoIBYUD0RK0=;
	b=UDRRgQXFtlhNiKddIthTywg6NjObOtyognfF4avf+JA3SPYB8X/VoEOa4DgZ2Ia7QauR4G
	zpu3TKJsoIG2b5vC36gTXNmqYRYkT1mur0d7UAGtgmSJgiHZ5YYBSy4ORkoaqYPHQjp7Sn
	QGivHnW836kb2z5K8h5maKh+RqLtToo=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 06227133CF;
	Mon, 24 Aug 2026 04:34:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wC/iKNnJi2p1SAAAD6G6ig
	(envelope-from <wqu@suse.com>); Mon, 24 Aug 2026 04:34:33 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v3 4/4] btrfs: dev-replace: properly cleanup replace_task
Date: Mon, 24 Aug 2026 14:04:08 +0930
Message-ID: <9643263705371fae65db79947303e839e6c7778a.1787545216.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1787545216.git.wqu@suse.com>
References: <cover.1787545216.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.992];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,sashiko.dev:url,suse.com:mid,suse.com:email];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

There are several involved error paths, that we can error out without
resetting replace_task back to NULL:

- A running dev-replace in btrfs_dev_replace_start()
  This is impossible to hit, as dev-replace is an exclusive operation,
  meaning new dev-replace request will fail immediately without reaching
  btrfs_dev_replace_by_ioctl().

- The btrfs_start_transaction() call failed in btrfs_dev_replace_start()
  Possible but not common

- The dev-replace is suspended in btrfs_dev_replace_finishing()
  This happens when remounting a btrfs read-only with a running replace,
  or during unmount.

  btrfs_dev_replace_suspend_for_unmount() is the only call site changing
  replace_state for a running replace, other than
  btrfs_dev_replace_finishing().

  btrfs_dev_replace_suspend_for_unmount() only changed replace_state to
  SUSPENDED, but the running replace is still running.
  It's the later btrfs_scrub_cancel() that really waits for the running
  replace to finish and handle the suspended case.

  But for this suspended case, we do not reset replace_task.

- A new error hit inside btrfs_dev_replace_finishing()
  We can hit errors inside btrfs_dev_replace_finishing() itself, like
  failed to run delalloc roots or start a new transaction.

  In that case, replace_task is only cleared when the replace finished
  without any error.

This can result in the replace_task check inside btrfs_map_block() to be
incorrectly triggered, not taking dev_replace->rwsem, thus not properly
protected against the running dev-replace state changes.

Fix this minor error handling problem by:

- Moving the replace_task assignment after replace_state check in
  btrfs_dev_replace_start()

- Reset replace_task to NULL if btrfs_start_transaction() failed
  in btrfs_dev_replace_start()

- Reset replace_task to NULL for btrfs_dev_replace_finishing() for
  suspended run

- Reset replace_task to NULL for btrfs_dev_replace_finishing() for
  cancelled/finished run

This is reported by Sashiko, which found the existing bug during review
of another patch, and since the bug is an existing one, it's not shown in
the summary, but only in the detail page.

Link: https://sashiko.dev/#/patchset/tencent_853134544C3CE88A219EEB21346E2510D308%40qq.com
Fixes: 8cca35cb29f8 ("btrfs: don't take dev_replace rwsem on task already holding it")
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/dev-replace.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index df048cf69621..daee306de43a 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -633,7 +633,6 @@ static int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
 		goto leave;
 
 	down_write(&dev_replace->rwsem);
-	dev_replace->replace_task = current;
 	switch (dev_replace->replace_state) {
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_NEVER_STARTED:
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_FINISHED:
@@ -650,6 +649,7 @@ static int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
 	dev_replace->cont_reading_from_srcdev_mode = read_src;
 	dev_replace->srcdev = src_device;
 	dev_replace->tgtdev = tgt_device;
+	dev_replace->replace_task = current;
 
 	btrfs_info(fs_info,
 		      "dev_replace from %s (devid %llu) to %s started",
@@ -693,6 +693,7 @@ static int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
 			BTRFS_IOCTL_DEV_REPLACE_STATE_NEVER_STARTED;
 		dev_replace->srcdev = NULL;
 		dev_replace->tgtdev = NULL;
+		dev_replace->replace_task = NULL;
 		up_write(&dev_replace->rwsem);
 		goto leave;
 	}
@@ -875,9 +876,19 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	mutex_lock(&dev_replace->lock_finishing_cancel_unmount);
 
 	down_read(&dev_replace->rwsem);
-	/* was the operation canceled, or is it finished? */
 	if (dev_replace->replace_state !=
 	    BTRFS_IOCTL_DEV_REPLACE_STATE_STARTED) {
+		/*
+		 * Only suspended replace can reach here. Regular cancelling
+		 * will not touch replace_state.
+		 *
+		 * Suspended replace won't reset tgt/src dev as it may be resumed
+		 * later.
+		 * And we do not need write rwsem lock to change replace_task.
+		 * The only reader in btrfs_map_block() doesn't acquire rwsem
+		 * to access replace_task either.
+		 */
+		dev_replace->replace_task = NULL;
 		up_read(&dev_replace->rwsem);
 		mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
 		return 0;
@@ -932,6 +943,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	down_write(&dev_replace->rwsem);
 	dev_replace->tgtdev = NULL;
 	dev_replace->srcdev = NULL;
+	dev_replace->replace_task = NULL;
 	dev_replace->time_stopped = ktime_get_real_seconds();
 	dev_replace->item_needs_writeback = 1;
 
@@ -994,8 +1006,6 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 
 	list_add(&tgt_device->dev_alloc_list, &fs_devices->alloc_list);
 	fs_devices->rw_devices++;
-
-	dev_replace->replace_task = NULL;
 	up_write(&dev_replace->rwsem);
 	btrfs_rm_dev_replace_blocked(fs_info);
 
-- 
2.55.0

