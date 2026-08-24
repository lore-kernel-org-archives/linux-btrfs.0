Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F137238150
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Aug 2026 04:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787546085; cv=none; b=OuAdl+UQFClMlQxcLe+uP5Ii2P14+g87OcaNsi6JIjqXPrWO2OReo4oqwT2C9opwj9Eid/iVYcWnrHb8i/YcLvALGm4HolCfmJ1DLYXWdW/L59L1rL9ALWQl3MrKrvrh3OK8keUR+cyoBToEX5zTXWb1zggAobOyDbK7MKdyQ2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787546085; c=relaxed/simple;
	bh=JYO8QW3iu17CIfUlmsXEqQHN5CipWdSqpo9uMnlA9kA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gdvh3bcFsMBk2qA559njpQB2xDYBMCS6+VNoveGWpQR/tZu5raziwbWL2AfD2XIDDfytML2ewuh9OqGyaKoxzV1dm6ZWYgDDi3AYjo/ebCHPFmkBI8uyu3M6Jpro905sbnAAGf7B4br1+WEHHZ4ixywejiASOR3jD4TXA6CWLQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=HbpIM+zq; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=K/JIzpnB; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="HbpIM+zq";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="K/JIzpnB"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5EA1B866F3
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Aug 2026 04:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1787546077; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VICgBt0LsA6HdlAhbOnE+puF9k6vgQWeomsGnK6SIyM=;
	b=HbpIM+zq298g5/438swvsyGt4LJvwMAxaxo9cLE5h+Ayk6FCGgyYlHhZYY68k3hMeBrIQt
	yV+UFpn25q7hDaGZ/J11dczbl0Vkv/vrua9ScO2Q+ckFQBM3/aEtlG7p9H63vtoF/ggOYM
	3PBcUNZGHzxtPqdMYsbGxmeTQIi2djs=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1787546073; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VICgBt0LsA6HdlAhbOnE+puF9k6vgQWeomsGnK6SIyM=;
	b=K/JIzpnBo4aljYQQZeN88rrF7x5/CmBVHPoYRzvQrzkKfpSl9/3A7vYC4HfWP7gdd2Mhnl
	fFdPGwMo4L+iJiOFOl7YMcBnVdvKRyLm+e1rls0n3aV0g+fuvyvtjheHCPY9o+vs7BTKlP
	ZH3GcnXc26i+dzSAyjQa9+b5mlT0sxM=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4FCE6133A6
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Aug 2026 04:34:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CBPhOtfJi2p1SAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Aug 2026 04:34:31 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 3/4] btrfs: dev-replace: fix the error handling in btrfs_dev_replace_finishing()
Date: Mon, 24 Aug 2026 14:04:07 +0930
Message-ID: <d1e76ae13f52a03bb4625d8b8034f443e27f8919.1787545216.git.wqu@suse.com>
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
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]

In btrfs_dev_replace_finishing(), we have the following error paths that
do not do any cleanup:

- btrfs_start_delalloc_roots() error
- btrfs_start_transaction() error

Both will error out directly, leaving the existing dev_replace
untouched, meaning the dev-replace will still be treated as running,
blocking future dev_replace.

Fix the problem by letting the above errors to go to a new out label,
which will do the common dev_replace cleanup, with an error message
showing that dev-replace has failed.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/dev-replace.c | 39 +++++++++++++++++++++------------------
 1 file changed, 21 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index be4031a6ce1d..df048cf69621 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -893,8 +893,9 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	 */
 	ret = btrfs_start_delalloc_roots(fs_info, LONG_MAX, false);
 	if (ret) {
-		mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
-		return ret;
+		mutex_lock(&fs_devices->device_list_mutex);
+		mutex_lock(&fs_info->chunk_mutex);
+		goto out;
 	}
 	btrfs_wait_ordered_roots(fs_info, U64_MAX, NULL);
 
@@ -906,8 +907,10 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	while (1) {
 		trans = btrfs_start_transaction(root, 0);
 		if (IS_ERR(trans)) {
-			mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
-			return PTR_ERR(trans);
+			ret = PTR_ERR(trans);
+			mutex_lock(&fs_devices->device_list_mutex);
+			mutex_lock(&fs_info->chunk_mutex);
+			goto out;
 		}
 		ret = btrfs_commit_transaction(trans);
 		WARN_ON(ret);
@@ -925,10 +928,8 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 		}
 	}
 
+out:
 	down_write(&dev_replace->rwsem);
-	dev_replace->replace_state =
-		scrub_ret ? BTRFS_IOCTL_DEV_REPLACE_STATE_CANCELED
-			  : BTRFS_IOCTL_DEV_REPLACE_STATE_FINISHED;
 	dev_replace->tgtdev = NULL;
 	dev_replace->srcdev = NULL;
 	dev_replace->time_stopped = ktime_get_real_seconds();
@@ -938,14 +939,17 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	 * Update allocation state in the new device and replace the old device
 	 * with the new one in the mapping tree.
 	 */
-	if (!scrub_ret) {
-		scrub_ret = btrfs_set_target_alloc_state(src_device, tgt_device);
-		if (scrub_ret)
-			goto error;
-		btrfs_dev_replace_update_device_in_mapping_tree(fs_info,
-								src_device,
-								tgt_device);
-	} else {
+	if (!scrub_ret && !ret) {
+		ret = btrfs_set_target_alloc_state(src_device, tgt_device);
+		if (!ret)
+			btrfs_dev_replace_update_device_in_mapping_tree(fs_info,
+									src_device,
+									tgt_device);
+	}
+	dev_replace->replace_state =
+		(scrub_ret || ret) ? BTRFS_IOCTL_DEV_REPLACE_STATE_CANCELED
+				   : BTRFS_IOCTL_DEV_REPLACE_STATE_FINISHED;
+	if (scrub_ret || ret) {
 		if (scrub_ret == -ECANCELED)
 			btrfs_info(fs_info,
 				"dev_replace from %s (devid %llu) to %s canceled",
@@ -956,8 +960,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 				 "dev_replace from %s (devid %llu) to %s failed %d",
 				 btrfs_dev_name(src_device),
 				 src_device->devid,
-				 btrfs_dev_name(tgt_device), scrub_ret);
-error:
+				 btrfs_dev_name(tgt_device), scrub_ret ? scrub_ret : ret);
 		up_write(&dev_replace->rwsem);
 		mutex_unlock(&fs_info->chunk_mutex);
 		mutex_unlock(&fs_devices->device_list_mutex);
@@ -967,7 +970,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 		btrfs_rm_dev_replace_unblocked(fs_info);
 		mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
 
-		return scrub_ret;
+		return scrub_ret ? scrub_ret : ret;
 	}
 
 	btrfs_info(fs_info,
-- 
2.55.0

