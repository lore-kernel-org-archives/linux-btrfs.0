Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E748B1990A7
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2026 04:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787631187; cv=none; b=mWEJ4zSmPbnX2YwRL5lES01rqv1oc835PqdFVb5PGf6OJrqlaBeapY4O92QvrmWuKMfpvs4tYyeRkh0bSoygCTFrOSwKdsCAOrVqNLMwqXWaHREvSWBhGSQDXLhesc7X5O1J42/M4pEkXbGUKmGsHIsthu/e0E6JfwISFS2NBug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787631187; c=relaxed/simple;
	bh=SaFF0wLpJ/AbTrkpRol/MojdfaCOfxS39wQt9Wufwgw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QrjZezRmXhT8XIu110/6HXto9MZ5+fFhRfFVYaaI1/FiBMulJxK0BAf5Jjotw9XIhEyjyXj45AnEvC7ypUjs0wLD14iVTgV4Dqi6fFotSsE+So6xZnlr5dUrgFuMfvn2vmCAwUCrBQ+Pth7FtluTJiZ70ACyLdGg8e7w7+zVdUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=HEgVne8I; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=OXhrM0o2; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="HEgVne8I";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="OXhrM0o2"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D48F4866BE
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2026 04:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1787631179; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PonngwihvGfFpksUxrrebxN9JnzC4pUgHDBIO/h5Woc=;
	b=HEgVne8IAdseWMG8mLhH9OF/Y5cXBx8ig+C0GrKHsmSkxsHKQ7TOISSBpRJHwEMGF5hD/u
	89Km/VQCjNTAXI84gfJzipBmNKNq0PkdS3NmCwN4YyJn9d+kwKcporLYGLHtj8eI/1fF2O
	VfRxZIUxMSrRDC+boURFOeLGhntaOG4=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=OXhrM0o2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1787631174; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PonngwihvGfFpksUxrrebxN9JnzC4pUgHDBIO/h5Woc=;
	b=OXhrM0o29tY6d0s6fsWGxs4OhbAE0Jam/BBTqDVXJpZL9Y24Bj733wpBglkyU7Hiuu5GBB
	l1h3081tb6PN1QT3GMQFIRqgRUYonfg3aNxS9xxvu8Alhq6eGhNeT+h/JTBFQzP3QNpQPz
	u8C8hfStm2EbkFuOQ+tSUgHRD00qkMg=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C98AE1339B
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2026 04:12:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2I5YHUUWjWodGQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2026 04:12:53 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: qgroup: use atomic operations for btrfs_fs_info::qgroup_flags
Date: Tue, 25 Aug 2026 13:42:31 +0930
Message-ID: <2b1409bbc46c33b82902bad50488cca1c6fd273a.1787631065.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1787631065.git.wqu@suse.com>
References: <cover.1787631065.git.wqu@suse.com>
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
X-Rspamd-Queue-Id: D48F4866BE
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email,suse.com:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

Currently we define btrfs_fs_info::qgroup_flags as u64, to match the
on-disk qgroup status item's flag.

But for now we have only 4 bits utilized for that flag, and since it's
u64 we have no way to properly use the existing atomic bit operations
(requires an unsigned long pointer).

This results in a lot of non-atomic operations inside qgroup code. Some
maybe fine as other locks are involved, but still it's not a good
practice.

Remove those non-atomic operations by:

- Re-define btrfs_fs_info::qgroup_flags as unsigned long
- Define BTRFS_QGROUP_STATUS_BIT_* and BTRFS_QGROUP_RUNTIME_BIT_*
  Instead of the old value define the bit number.

- Use set_bit()/clear_bit()/test_bit() to replace open-coded bit
  operations

- Add one extra check at qgroup status item read time
  To make sure the on-disk flag is still inside ULONG_MAX.
  Otherwise reject the status item and disable qgroup.

- Get rid of unnecessary spinlock when checking a single bit

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/fs.h                   |   2 +-
 fs/btrfs/ioctl.c                |   2 +-
 fs/btrfs/qgroup.c               | 108 +++++++++++++++++---------------
 fs/btrfs/qgroup.h               |   4 +-
 fs/btrfs/sysfs.c                |   9 +--
 include/uapi/linux/btrfs_tree.h |  26 +++++---
 6 files changed, 84 insertions(+), 67 deletions(-)

diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index 10e15a319b93..3eba8438593c 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -811,7 +811,7 @@ struct btrfs_fs_info {
 	struct btrfs_discard_ctl discard_ctl;
 
 	/* Is qgroup tracking in a consistent state? */
-	u64 qgroup_flags;
+	unsigned long qgroup_flags;
 
 	/* Holds configuration and tracking. Protected by qgroup_lock. */
 	struct rb_root qgroup_tree;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 21c4e755f9c5..6ffd4b9f384d 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3881,7 +3881,7 @@ static long btrfs_ioctl_quota_rescan_status(struct btrfs_fs_info *fs_info,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_RESCAN) {
+	if (test_bit(BTRFS_QGROUP_STATUS_BIT_RESCAN, &fs_info->qgroup_flags)) {
 		qsa.flags = 1;
 		qsa.progress = fs_info->qgroup_rescan_progress.objectid;
 	}
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index f3685cbb8f2e..2f2f4e0a3b2e 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -34,7 +34,7 @@ enum btrfs_qgroup_mode btrfs_qgroup_mode(const struct btrfs_fs_info *fs_info)
 {
 	if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags))
 		return BTRFS_QGROUP_MODE_DISABLED;
-	if (fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_SIMPLE_MODE)
+	if (test_bit(BTRFS_QGROUP_STATUS_BIT_SIMPLE_MODE, &fs_info->qgroup_flags))
 		return BTRFS_QGROUP_MODE_SIMPLE;
 	return BTRFS_QGROUP_MODE_FULL;
 }
@@ -384,14 +384,14 @@ static bool squota_check_parent_usage(struct btrfs_fs_info *fs_info, struct btrf
 __printf(2, 3)
 static void qgroup_mark_inconsistent(struct btrfs_fs_info *fs_info, const char *fmt, ...)
 {
-	const u64 old_flags = fs_info->qgroup_flags;
+	const unsigned long old_flags = fs_info->qgroup_flags;
 
 	if (btrfs_qgroup_mode(fs_info) == BTRFS_QGROUP_MODE_SIMPLE)
 		return;
-	fs_info->qgroup_flags |= (BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT |
-				  BTRFS_QGROUP_RUNTIME_FLAG_CANCEL_RESCAN |
-				  BTRFS_QGROUP_RUNTIME_FLAG_NO_ACCOUNTING);
-	if (!(old_flags & BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT)) {
+	set_bit(BTRFS_QGROUP_STATUS_BIT_INCONSISTENT, &fs_info->qgroup_flags);
+	set_bit(BTRFS_QGROUP_RUNTIME_BIT_CANCEL_RESCAN, &fs_info->qgroup_flags);
+	set_bit(BTRFS_QGROUP_RUNTIME_BIT_NO_ACCOUNTING, &fs_info->qgroup_flags);
+	if (!(test_bit(BTRFS_QGROUP_STATUS_BIT_INCONSISTENT, &old_flags))) {
 		struct va_format vaf;
 		va_list args;
 
@@ -472,8 +472,14 @@ int btrfs_read_qgroup_config(struct btrfs_fs_info *fs_info)
 				 "old qgroup version, quota disabled");
 				goto out;
 			}
-			fs_info->qgroup_flags = btrfs_qgroup_status_flags(l, ptr);
-			if (fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_SIMPLE_MODE)
+			if (btrfs_qgroup_status_flags(l, ptr) > ULONG_MAX) {
+				btrfs_err(fs_info,
+					  "invalid qgroup status flags, quota disabled");
+				goto out;
+			}
+			fs_info->qgroup_flags = (unsigned long)btrfs_qgroup_status_flags(l, ptr);
+			if (test_bit(BTRFS_QGROUP_STATUS_BIT_SIMPLE_MODE,
+				     &fs_info->qgroup_flags))
 				qgroup_read_enable_gen(fs_info, l, slot, ptr);
 			else if (btrfs_qgroup_status_generation(l, ptr) != fs_info->generation)
 				qgroup_mark_inconsistent(fs_info, "qgroup generation mismatch");
@@ -609,12 +615,12 @@ int btrfs_read_qgroup_config(struct btrfs_fs_info *fs_info)
 out:
 	btrfs_free_path(path);
 	if (ret >= 0) {
-		if (fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_ON)
+		if (test_bit(BTRFS_QGROUP_STATUS_BIT_ON, &fs_info->qgroup_flags))
 			set_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags);
-		if (fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_RESCAN)
+		if (test_bit(BTRFS_QGROUP_STATUS_BIT_RESCAN, &fs_info->qgroup_flags))
 			ret = qgroup_rescan_init(fs_info, rescan_progress, 0);
 	} else {
-		fs_info->qgroup_flags &= ~BTRFS_QGROUP_STATUS_FLAG_RESCAN;
+		clear_bit(BTRFS_QGROUP_STATUS_BIT_RESCAN, &fs_info->qgroup_flags);
 		btrfs_sysfs_del_qgroups(fs_info);
 	}
 
@@ -1099,9 +1105,9 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info,
 				 struct btrfs_qgroup_status_item);
 	btrfs_set_qgroup_status_generation(leaf, ptr, trans->transid);
 	btrfs_set_qgroup_status_version(leaf, ptr, BTRFS_QGROUP_STATUS_VERSION);
-	fs_info->qgroup_flags = BTRFS_QGROUP_STATUS_FLAG_ON;
+	fs_info->qgroup_flags = (1UL << BTRFS_QGROUP_STATUS_BIT_ON);
 	if (simple) {
-		fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_SIMPLE_MODE;
+		set_bit(BTRFS_QGROUP_STATUS_BIT_SIMPLE_MODE, &fs_info->qgroup_flags);
 		btrfs_set_fs_incompat(fs_info, SIMPLE_QUOTA);
 		/*
 		 * Set the enable generation to the next transaction, as we cannot
@@ -1111,7 +1117,7 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info,
 		 */
 		btrfs_set_qgroup_status_enable_gen(leaf, ptr, trans->transid + 1);
 	} else {
-		fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
+		set_bit(BTRFS_QGROUP_STATUS_BIT_INCONSISTENT, &fs_info->qgroup_flags);
 	}
 	btrfs_set_qgroup_status_flags(leaf, ptr, fs_info->qgroup_flags &
 				      BTRFS_QGROUP_STATUS_FLAGS_MASK);
@@ -1401,8 +1407,8 @@ int btrfs_quota_disable(struct btrfs_fs_info *fs_info)
 	spin_lock(&fs_info->qgroup_lock);
 	quota_root = fs_info->quota_root;
 	fs_info->quota_root = NULL;
-	fs_info->qgroup_flags &= ~BTRFS_QGROUP_STATUS_FLAG_ON;
-	fs_info->qgroup_flags &= ~BTRFS_QGROUP_STATUS_FLAG_SIMPLE_MODE;
+	clear_bit(BTRFS_QGROUP_STATUS_BIT_ON, &fs_info->qgroup_flags);
+	clear_bit(BTRFS_QGROUP_STATUS_BIT_SIMPLE_MODE, &fs_info->qgroup_flags);
 	fs_info->qgroup_drop_subtree_thres = BTRFS_QGROUP_DROP_SUBTREE_THRES_DEFAULT;
 	spin_unlock(&fs_info->qgroup_lock);
 
@@ -1552,7 +1558,7 @@ static int quick_update_accounting(struct btrfs_fs_info *fs_info,
 	}
 out:
 	if (ret)
-		fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
+		set_bit(BTRFS_QGROUP_STATUS_BIT_INCONSISTENT, &fs_info->qgroup_flags);
 	return ret;
 }
 
@@ -1873,7 +1879,7 @@ int btrfs_remove_qgroup(struct btrfs_trans_handle *trans, u64 qgroupid)
 	 * very frequently.
 	 */
 	if (btrfs_qgroup_mode(fs_info) == BTRFS_QGROUP_MODE_FULL &&
-	    !(fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT)) {
+	    !test_bit(BTRFS_QGROUP_STATUS_BIT_INCONSISTENT, &fs_info->qgroup_flags)) {
 		if (unlikely(qgroup->rfer || qgroup->excl ||
 			     qgroup->rfer_cmpr || qgroup->excl_cmpr)) {
 			DEBUG_WARN();
@@ -2118,7 +2124,8 @@ int btrfs_qgroup_trace_extent_post(struct btrfs_trans_handle *trans,
 	 */
 	ASSERT(trans != NULL);
 
-	if (fs_info->qgroup_flags & BTRFS_QGROUP_RUNTIME_FLAG_NO_ACCOUNTING)
+	if (test_bit(BTRFS_QGROUP_RUNTIME_BIT_NO_ACCOUNTING,
+		     &fs_info->qgroup_flags))
 		return 0;
 
 	ret = btrfs_find_all_roots(&ctx, true);
@@ -2959,7 +2966,7 @@ int btrfs_qgroup_account_extent(struct btrfs_trans_handle *trans, u64 bytenr,
 	 * we can't just exit here.
 	 */
 	if (!btrfs_qgroup_full_accounting(fs_info) ||
-	    fs_info->qgroup_flags & BTRFS_QGROUP_RUNTIME_FLAG_NO_ACCOUNTING)
+	    test_bit(BTRFS_QGROUP_RUNTIME_BIT_NO_ACCOUNTING, &fs_info->qgroup_flags))
 		goto out_free;
 
 	if (new_roots) {
@@ -2981,7 +2988,7 @@ int btrfs_qgroup_account_extent(struct btrfs_trans_handle *trans, u64 bytenr,
 					num_bytes, nr_old_roots, nr_new_roots);
 
 	mutex_lock(&fs_info->qgroup_rescan_lock);
-	if (fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_RESCAN) {
+	if (test_bit(BTRFS_QGROUP_STATUS_BIT_RESCAN, &fs_info->qgroup_flags)) {
 		if (fs_info->qgroup_rescan_progress.objectid <= bytenr) {
 			mutex_unlock(&fs_info->qgroup_rescan_lock);
 			ret = 0;
@@ -3042,8 +3049,8 @@ int btrfs_qgroup_account_extents(struct btrfs_trans_handle *trans)
 		num_dirty_extents++;
 		trace_btrfs_qgroup_account_extents(fs_info, record, bytenr);
 
-		if (!ret && !(fs_info->qgroup_flags &
-			      BTRFS_QGROUP_RUNTIME_FLAG_NO_ACCOUNTING)) {
+		if (!ret && !test_bit(BTRFS_QGROUP_RUNTIME_BIT_NO_ACCOUNTING,
+				      &fs_info->qgroup_flags)) {
 			struct btrfs_backref_walk_ctx ctx = { 0 };
 
 			ctx.bytenr = bytenr;
@@ -3150,9 +3157,9 @@ int btrfs_run_qgroups(struct btrfs_trans_handle *trans)
 		spin_lock(&fs_info->qgroup_lock);
 	}
 	if (btrfs_qgroup_enabled(fs_info))
-		fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_ON;
+		set_bit(BTRFS_QGROUP_STATUS_BIT_ON, &fs_info->qgroup_flags);
 	else
-		fs_info->qgroup_flags &= ~BTRFS_QGROUP_STATUS_FLAG_ON;
+		clear_bit(BTRFS_QGROUP_STATUS_BIT_ON, &fs_info->qgroup_flags);
 	spin_unlock(&fs_info->qgroup_lock);
 
 	ret = update_qgroup_status_item(trans);
@@ -3842,7 +3849,7 @@ static bool rescan_should_stop(struct btrfs_fs_info *fs_info)
 		return true;
 	if (!btrfs_qgroup_enabled(fs_info))
 		return true;
-	if (fs_info->qgroup_flags & BTRFS_QGROUP_RUNTIME_FLAG_CANCEL_RESCAN)
+	if (test_bit(BTRFS_QGROUP_RUNTIME_BIT_CANCEL_RESCAN, &fs_info->qgroup_flags))
 		return true;
 	return false;
 }
@@ -3892,12 +3899,10 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 	btrfs_free_path(path);
 
 	mutex_lock(&fs_info->qgroup_rescan_lock);
-	if (ret > 0 &&
-	    fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT) {
-		fs_info->qgroup_flags &= ~BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
-	} else if (ret < 0 || stopped) {
-		fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
-	}
+	if (ret > 0)
+		clear_bit(BTRFS_QGROUP_STATUS_BIT_INCONSISTENT, &fs_info->qgroup_flags);
+	else if (ret < 0 || stopped)
+		set_bit(BTRFS_QGROUP_STATUS_BIT_INCONSISTENT, &fs_info->qgroup_flags);
 	mutex_unlock(&fs_info->qgroup_rescan_lock);
 
 	/*
@@ -3921,9 +3926,9 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 	}
 
 	mutex_lock(&fs_info->qgroup_rescan_lock);
-	if (!stopped ||
-	    fs_info->qgroup_flags & BTRFS_QGROUP_RUNTIME_FLAG_CANCEL_RESCAN)
-		fs_info->qgroup_flags &= ~BTRFS_QGROUP_STATUS_FLAG_RESCAN;
+	if (!stopped || test_bit(BTRFS_QGROUP_RUNTIME_BIT_CANCEL_RESCAN,
+				 &fs_info->qgroup_flags))
+		clear_bit(BTRFS_QGROUP_STATUS_BIT_RESCAN, &fs_info->qgroup_flags);
 	if (trans) {
 		int ret2 = update_qgroup_status_item(trans);
 
@@ -3933,7 +3938,7 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 		}
 	}
 	fs_info->qgroup_rescan_running = false;
-	fs_info->qgroup_flags &= ~BTRFS_QGROUP_RUNTIME_FLAG_CANCEL_RESCAN;
+	clear_bit(BTRFS_QGROUP_RUNTIME_BIT_CANCEL_RESCAN, &fs_info->qgroup_flags);
 	complete_all(&fs_info->qgroup_rescan_completion);
 	mutex_unlock(&fs_info->qgroup_rescan_lock);
 
@@ -3944,7 +3949,8 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 
 	if (stopped) {
 		btrfs_info(fs_info, "qgroup scan paused");
-	} else if (fs_info->qgroup_flags & BTRFS_QGROUP_RUNTIME_FLAG_CANCEL_RESCAN) {
+	} else if (test_bit(BTRFS_QGROUP_RUNTIME_BIT_CANCEL_RESCAN,
+			    &fs_info->qgroup_flags)) {
 		btrfs_info(fs_info, "qgroup scan cancelled");
 	} else if (ret >= 0) {
 		btrfs_info(fs_info, "qgroup scan completed%s",
@@ -3971,13 +3977,13 @@ qgroup_rescan_init(struct btrfs_fs_info *fs_info, u64 progress_objectid,
 
 	if (!init_flags) {
 		/* we're resuming qgroup rescan at mount time */
-		if (!(fs_info->qgroup_flags &
-		      BTRFS_QGROUP_STATUS_FLAG_RESCAN)) {
+		if (!(test_bit(BTRFS_QGROUP_STATUS_BIT_RESCAN,
+			       &fs_info->qgroup_flags))) {
 			btrfs_debug(fs_info,
 			"qgroup rescan init failed, qgroup rescan is not queued");
 			ret = -EINVAL;
-		} else if (!(fs_info->qgroup_flags &
-			     BTRFS_QGROUP_STATUS_FLAG_ON)) {
+		} else if (!(test_bit(BTRFS_QGROUP_STATUS_BIT_ON,
+				      &fs_info->qgroup_flags))) {
 			btrfs_debug(fs_info,
 			"qgroup rescan init failed, qgroup is not enabled");
 			ret = -ENOTCONN;
@@ -3990,10 +3996,11 @@ qgroup_rescan_init(struct btrfs_fs_info *fs_info, u64 progress_objectid,
 	mutex_lock(&fs_info->qgroup_rescan_lock);
 
 	if (init_flags) {
-		if (fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_RESCAN) {
+		if (test_bit(BTRFS_QGROUP_STATUS_BIT_RESCAN,
+			     &fs_info->qgroup_flags)) {
 			ret = -EINPROGRESS;
-		} else if (!(fs_info->qgroup_flags &
-			     BTRFS_QGROUP_STATUS_FLAG_ON)) {
+		} else if (!test_bit(BTRFS_QGROUP_STATUS_BIT_ON,
+				     &fs_info->qgroup_flags)) {
 			btrfs_debug(fs_info,
 			"qgroup rescan init failed, qgroup is not enabled");
 			ret = -ENOTCONN;
@@ -4006,13 +4013,15 @@ qgroup_rescan_init(struct btrfs_fs_info *fs_info, u64 progress_objectid,
 			mutex_unlock(&fs_info->qgroup_rescan_lock);
 			return ret;
 		}
-		fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_RESCAN;
+		set_bit(BTRFS_QGROUP_STATUS_BIT_RESCAN, &fs_info->qgroup_flags);
 	}
 
 	memset(&fs_info->qgroup_rescan_progress, 0,
 		sizeof(fs_info->qgroup_rescan_progress));
-	fs_info->qgroup_flags &= ~(BTRFS_QGROUP_RUNTIME_FLAG_CANCEL_RESCAN |
-				   BTRFS_QGROUP_RUNTIME_FLAG_NO_ACCOUNTING);
+	clear_bit(BTRFS_QGROUP_RUNTIME_BIT_CANCEL_RESCAN,
+		  &fs_info->qgroup_flags);
+	clear_bit(BTRFS_QGROUP_RUNTIME_BIT_NO_ACCOUNTING,
+		  &fs_info->qgroup_flags);
 	fs_info->qgroup_rescan_progress.objectid = progress_objectid;
 	init_completion(&fs_info->qgroup_rescan_completion);
 	mutex_unlock(&fs_info->qgroup_rescan_lock);
@@ -4063,7 +4072,8 @@ btrfs_qgroup_rescan(struct btrfs_fs_info *fs_info)
 
 	ret = btrfs_commit_current_transaction(fs_info->fs_root);
 	if (ret) {
-		fs_info->qgroup_flags &= ~BTRFS_QGROUP_STATUS_FLAG_RESCAN;
+		clear_bit(BTRFS_QGROUP_STATUS_BIT_RESCAN,
+			  &fs_info->qgroup_flags);
 		return ret;
 	}
 
@@ -4116,7 +4126,7 @@ int btrfs_qgroup_wait_for_completion(struct btrfs_fs_info *fs_info,
 void
 btrfs_qgroup_rescan_resume(struct btrfs_fs_info *fs_info)
 {
-	if (fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_RESCAN) {
+	if (test_bit(BTRFS_QGROUP_STATUS_BIT_RESCAN, &fs_info->qgroup_flags)) {
 		mutex_lock(&fs_info->qgroup_rescan_lock);
 		fs_info->qgroup_rescan_running = true;
 		btrfs_queue_work(fs_info->qgroup_rescan_workers,
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index 80dd2dacd56d..b3aaad5e617d 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -121,8 +121,8 @@ struct btrfs_qgroup_swapped_blocks;
  * To minimize the chance of collision with new persisted status flags, these
  * count backwards from the MSB.
  */
-#define BTRFS_QGROUP_RUNTIME_FLAG_CANCEL_RESCAN		(1ULL << 63)
-#define BTRFS_QGROUP_RUNTIME_FLAG_NO_ACCOUNTING		(1ULL << 62)
+#define BTRFS_QGROUP_RUNTIME_BIT_CANCEL_RESCAN		(BITS_PER_LONG - 1)
+#define BTRFS_QGROUP_RUNTIME_BIT_NO_ACCOUNTING		(BITS_PER_LONG - 2)
 
 #define BTRFS_QGROUP_DROP_SUBTREE_THRES_DEFAULT		(3)
 
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 39cb01ee441a..bec53da5678a 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -2359,9 +2359,7 @@ static ssize_t qgroup_enabled_show(struct kobject *qgroups_kobj,
 	struct btrfs_fs_info *fs_info = to_fs_info(qgroups_kobj->parent);
 	bool enabled;
 
-	spin_lock(&fs_info->qgroup_lock);
-	enabled = fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_ON;
-	spin_unlock(&fs_info->qgroup_lock);
+	enabled = test_bit(BTRFS_QGROUP_STATUS_BIT_ON, &fs_info->qgroup_flags);
 
 	return sysfs_emit(buf, "%d\n", enabled);
 }
@@ -2401,9 +2399,8 @@ static ssize_t qgroup_inconsistent_show(struct kobject *qgroups_kobj,
 	struct btrfs_fs_info *fs_info = to_fs_info(qgroups_kobj->parent);
 	bool inconsistent;
 
-	spin_lock(&fs_info->qgroup_lock);
-	inconsistent = (fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT);
-	spin_unlock(&fs_info->qgroup_lock);
+	inconsistent = test_bit(BTRFS_QGROUP_STATUS_BIT_INCONSISTENT,
+				&fs_info->qgroup_flags);
 
 	return sysfs_emit(buf, "%d\n", inconsistent);
 }
diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
index cc3b9f7dccaf..fa4984c80c9d 100644
--- a/include/uapi/linux/btrfs_tree.h
+++ b/include/uapi/linux/btrfs_tree.h
@@ -1255,13 +1255,19 @@ static inline __u16 btrfs_qgroup_level(__u64 qgroupid)
 }
 
 /*
- * is subvolume quota turned on?
+ * The following BTRFS_QGROUP_STATUS_BIT_* are for
+ * btrfs_qgroup_status_item::flags.
+ *
+ * Is subvolume quota turned on?
  */
-#define BTRFS_QGROUP_STATUS_FLAG_ON		(1ULL << 0)
-/*
- * RESCAN is set during the initialization phase
- */
-#define BTRFS_QGROUP_STATUS_FLAG_RESCAN		(1ULL << 1)
+#define BTRFS_QGROUP_STATUS_BIT_ON		(0)
+#define BTRFS_QGROUP_STATUS_FLAG_ON		\
+	(1ULL << BTRFS_QGROUP_STATUS_BIT_ON)
+
+/* RESCAN is set during the initialization phase */
+#define BTRFS_QGROUP_STATUS_BIT_RESCAN		(1)
+#define BTRFS_QGROUP_STATUS_FLAG_RESCAN		\
+	(1ULL << BTRFS_QGROUP_STATUS_BIT_RESCAN)
 /*
  * Some qgroup entries are known to be out of date,
  * either because the configuration has changed in a way that
@@ -1269,14 +1275,18 @@ static inline __u16 btrfs_qgroup_level(__u64 qgroupid)
  * with a non-qgroup-aware version.
  * Turning qouta off and on again makes it inconsistent, too.
  */
-#define BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT	(1ULL << 2)
+#define BTRFS_QGROUP_STATUS_BIT_INCONSISTENT	(2)
+#define BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT	\
+	(1ULL << BTRFS_QGROUP_STATUS_BIT_INCONSISTENT)
 
 /*
  * Whether or not this filesystem is using simple quotas.  Not exactly the
  * incompat bit, because we support using simple quotas, disabling it, then
  * going back to full qgroup quotas.
  */
-#define BTRFS_QGROUP_STATUS_FLAG_SIMPLE_MODE	(1ULL << 3)
+#define BTRFS_QGROUP_STATUS_BIT_SIMPLE_MODE	(3)
+#define BTRFS_QGROUP_STATUS_FLAG_SIMPLE_MODE	\
+	(1ULL << BTRFS_QGROUP_STATUS_BIT_SIMPLE_MODE)
 
 #define BTRFS_QGROUP_STATUS_FLAGS_MASK	(BTRFS_QGROUP_STATUS_FLAG_ON |		\
 					 BTRFS_QGROUP_STATUS_FLAG_RESCAN |	\
-- 
2.55.0

