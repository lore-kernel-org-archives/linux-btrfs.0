Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1764936074F
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Aug 2026 06:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787813763; cv=none; b=mdGeMYRAMXJdFLToe0DCEQvUwSJGfv7q1xppBifavQI9gG8v6EuA19PpJ4dP8GNDAp1xDJAAIZvG4ZeIfkh7BYkshEZK8gh3eZLMbmSbOxj29dwOAKuaQQrj6ZUixgMH5oZNwDSZ9bNdOkVbP8E5UNtUPQaTiXI+DpnE7EI1pOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787813763; c=relaxed/simple;
	bh=5ayS+agNJM+yGn7V9bMvXsMnvLXfHvXltLx4pr3qKhc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BGLbaLoUFGx4tsGUffhHzImOIJ2m1HqPtapBNP/mPZnNcXtOm6fRTKHuQRYw+Jd3X8h0sNqNrqpIuhMiTUBySDghLDuwMZ1mhzkmEdRgvp7gKsZ4o1xaU/drM95HjPKy2A3cxJWDiyNCtE3tognOKr1ce3I7TwSCcrb99TUTSJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=HeGEMQwR; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=HjNoWHDG; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="HeGEMQwR";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="HjNoWHDG"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D4E331F823
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Aug 2026 06:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1787813756; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=81ZXx3c9pxW6NyfaQhaT679b9Z8EBWTcCpllxbaez4Q=;
	b=HeGEMQwRMfcJ5rntA59afBt5p8XkUUd5bXpiv6BuBn9wmuSic53tqWpKa0IZHUpXCthA9X
	AglDWOj252mazZwAreX0qA56Bw5hYQNQvvlmR6190gvoj+EcRlPsaRmc2b/QyHZ1F4ocFs
	QkRS9w1xhVc1WbiDKYADQq/OzTNES4Y=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=HjNoWHDG
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1787813751; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=81ZXx3c9pxW6NyfaQhaT679b9Z8EBWTcCpllxbaez4Q=;
	b=HjNoWHDGauPMeaSXAQO2D3vxdFvCgEDC6coko+ouahav4rgfykdlLnrLfRY1AMYbEyJ7g+
	HS+akOpTu3DtEHfGsJdZvPNJrJD7pVLoltuOzYbjJz2EEkRZoDocTk8eVVTxr0l+e1twgR
	lJdI+86DoI5ZF+M9CNbbUppycvfdpXU=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D248A1352D
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Aug 2026 06:55:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SN2rH3bfj2oiXgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Aug 2026 06:55:50 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: reject new qgroup rescan during subvolume dropping
Date: Thu, 27 Aug 2026 16:25:29 +0930
Message-ID: <bd41abdbd37716b1cbfd325c0c5c9f8414523e2c.1787812966.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1787812966.git.wqu@suse.com>
References: <cover.1787812966.git.wqu@suse.com>
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
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,suse.com:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Queue-Id: D4E331F823
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

Commit 011b46c30476 ("btrfs: skip subtree scan if it's too high to avoid
low stall in btrfs_commit_transaction()") introduced a threshold to skip
huge subtree scan during subvolume dropping.

But that's not covering all cases, e.g. rescan can still be started
immediately after that huge subtree skipping.
This will cause rescan to do the same accounting for that subtree
anyway, still causing a long stall during transaction commit.

Introduce a new runtime qgroup flag,
BTRFS_QGROUP_RUNTIME_BIT_REJECT_RESCAN, so that during cleanup of a
subvolume, no new qgroup rescan can be initiated.

The rejection uses the same -EINPROGRESS, as if there is already a
running qgroup rescan.

And since we have the extra bit, we can no longer allow plain assignment
in btrfs_quota_enable(), as the plain assignment will override the
REJECT_RESCAN bit.
To co-operate this new flag:

- Make btrfs_quota_enable() to only set BTRFS_QGROUP_STATUS_BIT_ON
  So it won't override the existing
  BTRFS_QGROUP_RUNTIME_BIT_REJECT_RESCAN bit.

- Make btrfs_quota_disable() to clear every non-rescan bit
  This includes:
  * BTRFS_QGROUP_STATUS_BIT_ON
  * BTRFS_QGROUP_STATUS_BIT_INCONSISTENT
  * BTRFS_QGROUP_RUNTIME_BIT_NO_ACCOUNTING

  For rescan related bits, they are either cleared by the rescan thread,
  or by the caller who rejects rescan.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/disk-io.c |  4 ++++
 fs/btrfs/qgroup.c  | 10 +++++++++-
 fs/btrfs/qgroup.h  | 13 +++++++++++++
 3 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index e6bbb0b1b38c..dd00e8ced883 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1496,7 +1496,11 @@ static int cleaner_kthread(void *arg)
 
 		btrfs_run_delayed_iputs(fs_info);
 
+		set_bit(BTRFS_QGROUP_RUNTIME_BIT_REJECT_RESCAN,
+			&fs_info->qgroup_flags);
 		again = btrfs_clean_one_deleted_snapshot(fs_info);
+		clear_bit(BTRFS_QGROUP_RUNTIME_BIT_REJECT_RESCAN,
+			  &fs_info->qgroup_flags);
 		mutex_unlock(&fs_info->cleaner_mutex);
 
 		/*
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 2f2f4e0a3b2e..cc08e7b2f68f 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1105,7 +1105,7 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info,
 				 struct btrfs_qgroup_status_item);
 	btrfs_set_qgroup_status_generation(leaf, ptr, trans->transid);
 	btrfs_set_qgroup_status_version(leaf, ptr, BTRFS_QGROUP_STATUS_VERSION);
-	fs_info->qgroup_flags = (1UL << BTRFS_QGROUP_STATUS_BIT_ON);
+	set_bit(BTRFS_QGROUP_STATUS_BIT_ON, &fs_info->qgroup_flags);
 	if (simple) {
 		set_bit(BTRFS_QGROUP_STATUS_BIT_SIMPLE_MODE, &fs_info->qgroup_flags);
 		btrfs_set_fs_incompat(fs_info, SIMPLE_QUOTA);
@@ -1407,8 +1407,14 @@ int btrfs_quota_disable(struct btrfs_fs_info *fs_info)
 	spin_lock(&fs_info->qgroup_lock);
 	quota_root = fs_info->quota_root;
 	fs_info->quota_root = NULL;
+	/*
+	 * Clear all on-disk and runtime bits, except RESCAN related ones, that
+	 * are either handled by rescan thread, or the caller who rejects rescan.
+	 */
 	clear_bit(BTRFS_QGROUP_STATUS_BIT_ON, &fs_info->qgroup_flags);
 	clear_bit(BTRFS_QGROUP_STATUS_BIT_SIMPLE_MODE, &fs_info->qgroup_flags);
+	clear_bit(BTRFS_QGROUP_STATUS_BIT_INCONSISTENT, &fs_info->qgroup_flags);
+	clear_bit(BTRFS_QGROUP_RUNTIME_BIT_NO_ACCOUNTING, &fs_info->qgroup_flags);
 	fs_info->qgroup_drop_subtree_thres = BTRFS_QGROUP_DROP_SUBTREE_THRES_DEFAULT;
 	spin_unlock(&fs_info->qgroup_lock);
 
@@ -3997,6 +4003,8 @@ qgroup_rescan_init(struct btrfs_fs_info *fs_info, u64 progress_objectid,
 
 	if (init_flags) {
 		if (test_bit(BTRFS_QGROUP_STATUS_BIT_RESCAN,
+			     &fs_info->qgroup_flags) ||
+		    test_bit(BTRFS_QGROUP_RUNTIME_BIT_REJECT_RESCAN,
 			     &fs_info->qgroup_flags)) {
 			ret = -EINPROGRESS;
 		} else if (!test_bit(BTRFS_QGROUP_STATUS_BIT_ON,
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index b3aaad5e617d..7cc1a079a0b4 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -124,6 +124,19 @@ struct btrfs_qgroup_swapped_blocks;
 #define BTRFS_QGROUP_RUNTIME_BIT_CANCEL_RESCAN		(BITS_PER_LONG - 1)
 #define BTRFS_QGROUP_RUNTIME_BIT_NO_ACCOUNTING		(BITS_PER_LONG - 2)
 
+/*
+ * No new rescan allowed when set.
+ *
+ * During huge subtree dropping, qgroup will be marked inconsistent,
+ * and skip all future accounting to avoid long stall.
+ * But an immediate rescan will re-enable qgroup and still stall
+ * the system.
+ *
+ * This bit is to avoid such rescan during the duration of a subvolume
+ * dropping.
+ */
+#define BTRFS_QGROUP_RUNTIME_BIT_REJECT_RESCAN		(BITS_PER_LONG - 3)
+
 #define BTRFS_QGROUP_DROP_SUBTREE_THRES_DEFAULT		(3)
 
 /*
-- 
2.55.0

