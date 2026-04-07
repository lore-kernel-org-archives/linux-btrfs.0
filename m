Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD9F72D7BF
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Apr 2026 09:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775554470; cv=none; b=n+XRx+DB1xXoWJHnLvixCe5/BAQ2UFdjFTeZdUCn4FigcNXQA2x/3W4WxTPu5QscnqJLo4f4AoHRqU/iDC3qYccUN5RJZR6Yl9sMYrjjDgz8jKfCaUwF52UbExVBr5PoyZs7kgPl9BcY030MzV1CmU+I86w0yKnnqYYKBdQ3JwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775554470; c=relaxed/simple;
	bh=mDDfk5yC3M+BBI7wPHg4T/rC2KCgeOurpDbeWuKyW1U=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rXd7g8E/6UTl7hIxtDXbwqgXmWsBgovc8z7FyxFYdYB/KQ8Tgzq3aXCo4rzW/oV6D/Yu8JvMfNSvXHWaLJ8RgDV/pgMYdY562FVfAJbstDnRWJD69fISSQ00QwFebL9BE0rq71HZWrihAcCd7U1MLdxqIyU1t42DAGnbY9I1h9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=troZ+Fpz; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=troZ+Fpz; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="troZ+Fpz";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="troZ+Fpz"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1CA354E3AC
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Apr 2026 09:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775554463; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AJqcEpkfLveELNRHf1VIiFxF/xwFFnSDx+RDEJFhetA=;
	b=troZ+FpzOPGEAI6/a5QbrIcVhWeIQ/h2/PcpSjHcMuEDq98DvnRWemqnbyqg/5aCJUDthe
	nuNjllwEU+ImpzFwV3aaZr+k2vjtT5/PlJ1fYOyDCf2jRimPwRVV4osgRI1TgLYqNjBdCi
	4/XNc8bpX3KBwxDEKYNDvBRLgkfSSTY=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=troZ+Fpz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775554463; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AJqcEpkfLveELNRHf1VIiFxF/xwFFnSDx+RDEJFhetA=;
	b=troZ+FpzOPGEAI6/a5QbrIcVhWeIQ/h2/PcpSjHcMuEDq98DvnRWemqnbyqg/5aCJUDthe
	nuNjllwEU+ImpzFwV3aaZr+k2vjtT5/PlJ1fYOyDCf2jRimPwRVV4osgRI1TgLYqNjBdCi
	4/XNc8bpX3KBwxDEKYNDvBRLgkfSSTY=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1C0334A0B0
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Apr 2026 09:34:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OD7iLp3P1GkOYAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 07 Apr 2026 09:34:21 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/4] btrfs: remove the dev stats item for replace target device
Date: Tue,  7 Apr 2026 19:03:58 +0930
Message-ID: <9766224952431a39ccffb222c9cab5a91cde6e86.1775553952.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1775553952.git.wqu@suse.com>
References: <cover.1775553952.git.wqu@suse.com>
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
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_NONE(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:mid,suse.com:dkim,suse.com:email]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 1CA354E3AC

[MINOR PROBLEM]
When a running dev-replace hits some error for the target device (devid
0), there will be a DEV_STATS with error records created at the next
transaction commit.

Unfortunately that item will never to be deleted.

This means at the next dev-replace, if the replace is interrupted, then
at the next mount, the target device will suddenly inherit the old error
records from that DEV_STATS item, which can give some false alerts on
that device.

This shouldn't affect end users that much, as it requires all the
following conditions to be met, which is pretty rare:

- The initial dev-replace hits some error on the target device
  E.g. write errors, but those errors itself is already a big problem
  for a running replace.

  This is required to create the DEV_STATS item in the first place.

- The next replace is interrupted
  This is required to allow btrfs to read from the old records.

[CAUSE]
Btrfs just never deletes the DEV_STATS after a replace is finished.

[FIX]
Remove the DEV_STATS item for devid 0 after the replace is finished.

This is not going to completely fix the error, as we still have other
error paths, e.g. by somehow the fs flips RO and can not start a new
transaction for the DEV_STATS item removal.

But those corner cases will be addressed by later patches which provide
a more generic fix to DEV_STATS related problems.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/dev-replace.c |  9 ++++++++-
 fs/btrfs/volumes.c     | 32 ++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.h     |  1 +
 3 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 8f8fa14886de..5ea14d74824d 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -1013,8 +1013,15 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 
 	/* write back the superblocks */
 	trans = btrfs_start_transaction(root, 0);
-	if (!IS_ERR(trans))
+	if (!IS_ERR(trans)) {
+		/*
+		 * Ignore any error here, if we failed to remove the
+		 * DEV_STATS item for devid 0, it's not a big deal.
+		 * We have other ways to address it.
+		 */
+		btrfs_remove_dev_stat_item(trans, BTRFS_DEV_REPLACE_DEVID);
 		btrfs_commit_transaction(trans);
+	}
 
 	mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 16e923987958..f709e2de11f4 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2286,6 +2286,38 @@ void btrfs_scratch_superblocks(struct btrfs_fs_info *fs_info, struct btrfs_devic
 	update_dev_time(rcu_dereference_raw(device->name));
 }
 
+int btrfs_remove_dev_stat_item(struct btrfs_trans_handle *trans, u64 devid)
+{
+	BTRFS_PATH_AUTO_RELEASE(path);
+	struct btrfs_fs_info *fs_info = trans->fs_info;
+	struct btrfs_root *dev_root = fs_info->dev_root;
+	struct btrfs_key key;
+	int ret;
+
+	key.objectid = BTRFS_DEV_STATS_OBJECTID;
+	key.type = BTRFS_PERSISTENT_ITEM_KEY;
+	key.offset = devid;
+
+	ret = btrfs_search_slot(trans, dev_root, &key, &path, -1, 1);
+	if (ret < 0) {
+		btrfs_warn(fs_info,
+			   "error %d while searching for dev_stats item for devid %llu",
+			   ret, devid);
+		return ret;
+	}
+	/* The dev stats item is not created, nothing to bother. */
+	if (ret > 0)
+		return 0;
+	ret = btrfs_del_item(trans, dev_root, &path);
+	if (ret < 0) {
+		btrfs_warn(fs_info,
+			   "error %d while deleting dev_stats item for devid %llu",
+			   ret, devid);
+		return ret;
+	}
+	return 0;
+}
+
 int btrfs_rm_device(struct btrfs_fs_info *fs_info,
 		    struct btrfs_dev_lookup_args *args,
 		    struct file **bdev_file)
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 0082c166af91..128cc1c2e3d5 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -932,6 +932,7 @@ bool btrfs_first_pending_extent(struct btrfs_device *device, u64 start, u64 len,
 				u64 *pending_start, u64 *pending_end);
 bool btrfs_find_hole_in_pending_extents(struct btrfs_device *device,
 					u64 *start, u64 *len, u64 min_hole_size);
+int btrfs_remove_dev_stat_item(struct btrfs_trans_handle *trans, u64 devid);
 
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 struct btrfs_io_context *alloc_btrfs_io_context(struct btrfs_fs_info *fs_info,
-- 
2.53.0

