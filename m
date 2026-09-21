Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80BDA45D91F
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Sep 2026 09:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789982241; cv=none; b=Ap09agh07x5SG33aR9eB71PawBAVnxzYHywXm7kAqw8RshDMVtQ2Bg5Oi4UK0Gg7/bOnSwin4ie5d0in9HJR4yqIyYxvvdeQ7n9Gdx3LDvljKfysAyC+HT3UmvCd8171l+l5FB8HuUMBumeRUkouA/ocEKOYxfbBAEX998Ur+nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789982241; c=relaxed/simple;
	bh=Jm+btqCPBJ7bcQ6v1ayTL2MQIQOpTOdXj3uztkkrb3Q=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hhohHMN7Vf5F9NJvHJT7No/JfofTWsgy+VGAPIheKhHXvc//C9zMjoalTtKpvaBQaYOSqoqppYlmTeFD1l+ZWnBBApuo+s5fabny3G7v3O5o1g2wy9LvvK3luJoHo2nyZ4juvfghi5tJdD9b/4OgIDS7mzbGZlLpfyY5poWRn/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=booebzI/; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=i9uTR6tU; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="booebzI/";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="i9uTR6tU"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 532D621AF2
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Sep 2026 09:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789982233; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IUCx/sh1JfKgNTmk1aj2fZtgfpo5udoGOZJLmVksPpQ=;
	b=booebzI//lT34h/xwi4IAn6uoE8l9LmduSnbALI2NodKns388UJfUCsvelcHS1s2CQeqbM
	XZzAiolGtfWsIjXGeBOfWBYSR6vTKXF1L5oqfUJDMscLBFUL+QGRX3vXJmTO8aE36DNDP8
	V2d+a+apoU0sgJAk+5JKzSk/R2iUshs=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=i9uTR6tU
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789982229; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IUCx/sh1JfKgNTmk1aj2fZtgfpo5udoGOZJLmVksPpQ=;
	b=i9uTR6tU0Rgcvly8eL96mJNg0iw+ztDRC/FJBWQw/raqkwWZnDc6Dn2VZyNctSyImPwbrc
	l1Ct+y1Coi6yYs9giTRYTM5jIrulU3dXOYFVFmNAzCu1NxoZ6NSfnYdiUEz17BjRWfyDJz
	dmERveouU22HbjlnbEJ8wPH3HUcBDnY=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0907813793
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Sep 2026 09:17:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8dCGIhH2sGqkbAAAD6G6ig:T2
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Sep 2026 09:17:07 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 1/3] btrfs: let rescan_should_stop() decide if the rescan flag is cleared
Date: Mon, 21 Sep 2026 18:46:44 +0930
Message-ID: <b0f743a5d512c45d5184086c1b7f26af65cc261e.1789981860.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1789981860.git.wqu@suse.com>
References: <cover.1789981860.git.wqu@suse.com>
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
X-Rspamd-Queue-Id: 532D621AF2
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim,suse.com:email,suse.com:mid];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Flag: NO
X-Spam-Score: -3.01

Currently if rescan_should_stop() returned true, aka the rescan should
be stopped, then we won't clear the BTRFS_QGROUP_STATUS_BIT_RESCAN
unless the BTRFS_QGROUP_RUNTIME_BIT_CANCEL_RESCAN is set.

However the reason why we should stop rescan is also affecting whether
we should clear the rescan flag:

- fs closing
  Should not clear RESCAN flag, as the next mount will resume the rescan

- fs remounting (from RW to RO)
  The next RW mount will resume qgroup rescan, so we should not clear
  the RESCAN flag.

- quota already disabled
  We should clear the RESCAN flag.

- CANCEL_RESCAN bit set
  We should clear the RESCAN flag, for now it's a special case and
  checked manually later.

So it's better to let rescan_should_stop() to determine whether the
RESCAN flag should also be cleared.

Since we're here, also slightly change the message, the CANCEL_RESCAN
bit is already cleared before outputting the message, so that
corresponding branch is dead.

Save whether we still have the RESCAN bit set when still holding the
qgroup_rescan_lock instead, and use that saved result to determine if
the rescan is properly paused or canceled.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/qgroup.c | 41 ++++++++++++++++++++++++++++++-----------
 1 file changed, 30 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 05e35eb126dc..eb71f5d7c1a5 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3862,16 +3862,31 @@ static int qgroup_rescan_leaf(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-static bool rescan_should_stop(struct btrfs_fs_info *fs_info)
+/*
+ * Return true if the rescan should be stopped.
+ * If returning true, update @clear_rescan_ret to indicate whether the rescan
+ * flag should be cleared.
+ *
+ * Return false if the rescan should continue.
+ */
+static bool rescan_should_stop(struct btrfs_fs_info *fs_info, bool *clear_rescan_ret)
 {
-	if (btrfs_fs_closing(fs_info))
+	if (btrfs_fs_closing(fs_info)) {
+		*clear_rescan_ret = false;
 		return true;
-	if (test_bit(BTRFS_FS_STATE_REMOUNTING, &fs_info->fs_state))
+	}
+	if (test_bit(BTRFS_FS_STATE_REMOUNTING, &fs_info->fs_state)) {
+		*clear_rescan_ret = false;
 		return true;
-	if (!btrfs_qgroup_enabled(fs_info))
+	}
+	if (!btrfs_qgroup_enabled(fs_info)) {
+		*clear_rescan_ret = true;
 		return true;
-	if (test_bit(BTRFS_QGROUP_RUNTIME_BIT_CANCEL_RESCAN, &fs_info->qgroup_flags))
+	}
+	if (test_bit(BTRFS_QGROUP_RUNTIME_BIT_CANCEL_RESCAN, &fs_info->qgroup_flags)) {
+		*clear_rescan_ret = true;
 		return true;
+	}
 	return false;
 }
 
@@ -3883,7 +3898,9 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 	struct btrfs_trans_handle *trans = NULL;
 	int ret = 0;
 	bool stopped = false;
+	bool clear_rescan = false;
 	bool did_leaf_rescans = false;
+	bool canceled;
 
 	if (btrfs_qgroup_mode(fs_info) == BTRFS_QGROUP_MODE_SIMPLE)
 		return;
@@ -3900,7 +3917,7 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 	path->search_commit_root = true;
 	path->skip_locking = true;
 
-	while (!ret && !(stopped = rescan_should_stop(fs_info))) {
+	while (!ret && !(stopped = rescan_should_stop(fs_info, &clear_rescan))) {
 		trans = btrfs_start_transaction(fs_info->fs_root, 0);
 		if (IS_ERR(trans)) {
 			ret = PTR_ERR(trans);
@@ -3947,8 +3964,8 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 	}
 
 	mutex_lock(&fs_info->qgroup_rescan_lock);
-	if (!stopped || test_bit(BTRFS_QGROUP_RUNTIME_BIT_CANCEL_RESCAN,
-				 &fs_info->qgroup_flags))
+	if (!stopped || clear_rescan ||
+	    test_bit(BTRFS_QGROUP_RUNTIME_BIT_CANCEL_RESCAN, &fs_info->qgroup_flags))
 		clear_bit(BTRFS_QGROUP_STATUS_BIT_RESCAN, &fs_info->qgroup_flags);
 	if (trans) {
 		int ret2 = update_qgroup_status_item(trans);
@@ -3960,6 +3977,7 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 	}
 	fs_info->qgroup_rescan_running = false;
 	clear_bit(BTRFS_QGROUP_RUNTIME_BIT_CANCEL_RESCAN, &fs_info->qgroup_flags);
+	canceled = !test_bit(BTRFS_QGROUP_STATUS_BIT_RESCAN, &fs_info->qgroup_flags);
 	complete_all(&fs_info->qgroup_rescan_completion);
 	mutex_unlock(&fs_info->qgroup_rescan_lock);
 
@@ -3969,9 +3987,10 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 	btrfs_end_transaction(trans);
 
 	if (stopped) {
-		btrfs_info(fs_info, "qgroup scan paused");
-	} else if (test_bit(BTRFS_QGROUP_RUNTIME_BIT_CANCEL_RESCAN, &fs_info->qgroup_flags)) {
-		btrfs_info(fs_info, "qgroup scan cancelled");
+		if (canceled)
+			btrfs_info(fs_info, "qgroup scan cancelled");
+		else
+			btrfs_info(fs_info, "qgroup scan paused");
 	} else if (ret >= 0) {
 		btrfs_info(fs_info, "qgroup scan completed%s",
 			ret > 0 ? " (inconsistency flag cleared)" : "");
-- 
2.55.0

