Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A9EE45A2BC
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Sep 2026 09:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789982243; cv=none; b=uZ07mpqOqDy1mldDY8oFw8LRbh3wQHNOUuLYT9Vvx8FgmqORof04JQz/XIvr1KnmkIeTZlW6Ct7hiOAs41URoqTpr4toGgWB52gj1qGp/nOWvxlN9jk94Lf1C7N/i8AhpymRX3Ol9ljL0WzWyQFxe/2VNN3TbVG1ScPvbG11kro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789982243; c=relaxed/simple;
	bh=oqmOp/uAGw0pXj7936Kr1oZZrQZaHlwx+Bge0t1OQ7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lEvy0QQcoY1rOZFFN429kD9Swljy9Eu4I6biXtSKdbQBS+gx+9gsdFT7jCpZejL2ZG5ZnpI6k3VR4zL7EkJB3UDTGGaNTNlml0Iwa93i2Yyf2QTBH3Fc4Tlt9dCoOT3HEj9WMRJEU+8tHfRZ/39WwvIFbQdWrp83dXaE+UPQ8Vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=AdfA8ruz; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=A7wK7PE5; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="AdfA8ruz";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="A7wK7PE5"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0D24D1F793;
	Mon, 21 Sep 2026 09:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789982235; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6dFLkERqEqx+i+mtAEpFjKa0SGNJvFOK53Rdd9y7XK4=;
	b=AdfA8ruzrwpHIG2gmle7bGxVE4JUhknwqugtF6orIYaFW7/U5tBMAKv7snJ30YVdZ+62yb
	ALwrWACShZI5fyluGipCr+Rz2xoiFY8rEw0F5/zfEN7miknRn+bEAinrXAR9G8QNvtxocP
	ZviC8IlPTedOHRhZt3kHsiG9Y8ak9kw=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=A7wK7PE5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789982231; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6dFLkERqEqx+i+mtAEpFjKa0SGNJvFOK53Rdd9y7XK4=;
	b=A7wK7PE5NXpQXntVjaA2jgcjvUTCoLRruAhXZTxPuGTEHT3ulnyhKJrXJPMp5a12W1uiJQ
	y7O8sjPr2VwoPztKk4dEDPX8K9hl/5uO7jrbHz5XB30fhMxgRLOWK35PHw6YkIObPwBSvj
	U+SyqQwN9tOiIxS9Pc/r5cFDVYLWLiA=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 99024139D7;
	Mon, 21 Sep 2026 09:17:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8dCGIhH2sGqkbAAAD6G6ig:T3
	(envelope-from <wqu@suse.com>); Mon, 21 Sep 2026 09:17:09 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Richard Weinberger <richard@nod.at>
Subject: [PATCH] btrfs: make qgroup rescan work to handle fs freezing
Date: Mon, 21 Sep 2026 18:46:45 +0930
Message-ID: <cfc34be50699e2e0e5c84e4d57345c7e0506caf8.1789974081.git.wqu@suse.com>
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
X-Rspamd-Queue-Id: 0D24D1F793
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Flag: NO
X-Spam-Score: -3.01
Message-ID: <20260921091645.AmylE4qMBQ2sbpV8irI1PVEk1RSRhmqcjIzjdcZEyvg@z>

[BUG]
There is a bug report that a running qgroup rescan can fail a pm
suspension:

 [ T278489] Freezing remaining freezable tasks
 [ T278489] Freezing remaining freezable tasks failed after 20.003 seconds (0 tasks refusing to freeze, wq_busy=1):
 [ T278489] Showing freezable workqueues that are still busy:
 [...]
 [ T278489]   pwq 56: cpus=0-13 flags=0x4 nice=0 active=1 refcnt=16
 [ T278489]     in-flight: 205929:btrfs_work_helper [btrfs] for 111s

[CAUSE]
Btrfs qgroup rescan is running in a workqueue, and when the fs is
frozen, btrfs_start_transaction() will sleep on sb_start_intwrite().

But a sleeping workload still counts as active for the workqueue until
the workload exits.

So the qgroup rescan item will sleep on the frozen fs, and fail the pm
suspension.

[FIX]
I strongly doubt whether we should even use a workqueue for the qgroup
rescan workload, a kthread would be a more suitable choice and can handle
fs and process freezing way better.
But that will be a long term solution.

For now fix the problems by:

- make rescan_should_stop() to return true if the fs is frozen
  This should handle most cases.

- Use btrfs_try_start_transaction() to avoid sleeping on
  sb_start_intwrite()

  This is less common but still possible, and if we sleep on
  sb_start_intwrite(), the workqueue will never have a chance to
  deactivate.

The above fixes should interrupt the rescan, so that pm suspension won't
fail.
And since the INCONSISTENT flag is not cleared, the end user/tool should
re-start a rescan if they need uptodate qgroup numbers.

And since we're here, also remove the "if (!trans) return;" check, and
end the transaction if there is one, so that the error message is always
shown.

Reported-by: Richard Weinberger <richard@nod.at>
Link: https://lore.kernel.org/linux-btrfs/mu8fq8a8.b9a9a1ae-dd6b-45a4-a415-5db853d61536@nod.at/
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/qgroup.c      | 14 ++++++++------
 fs/btrfs/transaction.c | 22 +++++++++++++++++++---
 fs/btrfs/transaction.h |  4 ++++
 3 files changed, 31 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 05e35eb126dc..0390a17561e2 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3866,6 +3866,8 @@ static bool rescan_should_stop(struct btrfs_fs_info *fs_info)
 {
 	if (btrfs_fs_closing(fs_info))
 		return true;
+	if (fs_info->sb->s_writers.frozen > SB_UNFROZEN)
+		return true;
 	if (test_bit(BTRFS_FS_STATE_REMOUNTING, &fs_info->fs_state))
 		return true;
 	if (!btrfs_qgroup_enabled(fs_info))
@@ -3901,9 +3903,11 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 	path->skip_locking = true;
 
 	while (!ret && !(stopped = rescan_should_stop(fs_info))) {
-		trans = btrfs_start_transaction(fs_info->fs_root, 0);
+		trans = btrfs_try_start_transaction(fs_info->fs_root, 0);
 		if (IS_ERR(trans)) {
 			ret = PTR_ERR(trans);
+			if (ret == -EINTR)
+				stopped = true;
 			break;
 		}
 
@@ -3934,7 +3938,7 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 	 * btrfs_quota_disable().
 	 */
 	if (did_leaf_rescans) {
-		trans = btrfs_start_transaction(fs_info->quota_root, 1);
+		trans = btrfs_try_start_transaction(fs_info->quota_root, 1);
 		if (IS_ERR(trans)) {
 			ret = PTR_ERR(trans);
 			trans = NULL;
@@ -3963,10 +3967,8 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 	complete_all(&fs_info->qgroup_rescan_completion);
 	mutex_unlock(&fs_info->qgroup_rescan_lock);
 
-	if (!trans)
-		return;
-
-	btrfs_end_transaction(trans);
+	if (trans)
+		btrfs_end_transaction(trans);
 
 	if (stopped) {
 		btrfs_info(fs_info, "qgroup scan paused");
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index ca114235bbe1..76787417331e 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -559,7 +559,7 @@ static bool may_wait_transaction(struct btrfs_fs_info *fs_info, int type)
 	if (test_bit(BTRFS_FS_LOG_RECOVERING, &fs_info->flags))
 		return false;
 
-	if (type == TRANS_START)
+	if ((type & TRANS_START) == TRANS_START)
 		return true;
 
 	return false;
@@ -719,8 +719,17 @@ start_transaction(struct btrfs_root *root, unsigned int num_items,
 	 * If we are ATTACH, it means we just want to catch the current
 	 * transaction and commit it, so we needn't do sb_start_intwrite(). 
 	 */
-	if (type & __TRANS_FREEZABLE)
-		sb_start_intwrite(fs_info->sb);
+	if (type & __TRANS_FREEZABLE) {
+		if (type & __TRANS_TRYLOCK) {
+			if (!sb_start_intwrite_trylock(fs_info->sb)) {
+				ret = -EINTR;
+				kmem_cache_free(btrfs_trans_handle_cachep, h);
+				goto alloc_fail;
+			}
+		} else {
+			sb_start_intwrite(fs_info->sb);
+		}
+	}
 
 	if (may_wait_transaction(fs_info, type))
 		wait_current_trans(fs_info, type);
@@ -841,6 +850,13 @@ struct btrfs_trans_handle *btrfs_start_transaction(struct btrfs_root *root,
 				 BTRFS_RESERVE_FLUSH_ALL, true);
 }
 
+struct btrfs_trans_handle *btrfs_try_start_transaction(struct btrfs_root *root,
+						       unsigned int num_items)
+{
+	return start_transaction(root, num_items, TRANS_TRY_START,
+				 BTRFS_RESERVE_FLUSH_ALL, true);
+}
+
 struct btrfs_trans_handle *btrfs_start_transaction_fallback_global_rsv(
 					struct btrfs_root *root,
 					unsigned int num_items)
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 89153cd22596..a9da059d3806 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -127,9 +127,11 @@ enum {
 	ENUM_BIT(__TRANS_JOIN_NOLOCK),
 	ENUM_BIT(__TRANS_DUMMY),
 	ENUM_BIT(__TRANS_JOIN_NOSTART),
+	ENUM_BIT(__TRANS_TRYLOCK),
 };
 
 #define TRANS_START		(__TRANS_START | __TRANS_FREEZABLE)
+#define TRANS_TRY_START		(__TRANS_START | __TRANS_FREEZABLE | __TRANS_TRYLOCK)
 #define TRANS_ATTACH		(__TRANS_ATTACH)
 #define TRANS_JOIN		(__TRANS_JOIN | __TRANS_FREEZABLE)
 #define TRANS_JOIN_NOLOCK	(__TRANS_JOIN_NOLOCK)
@@ -308,6 +310,8 @@ do {								\
 int btrfs_end_transaction(struct btrfs_trans_handle *trans);
 struct btrfs_trans_handle *btrfs_start_transaction(struct btrfs_root *root,
 						   unsigned int num_items);
+struct btrfs_trans_handle *btrfs_try_start_transaction(struct btrfs_root *root,
+						       unsigned int num_items);
 struct btrfs_trans_handle *btrfs_start_transaction_fallback_global_rsv(
 					struct btrfs_root *root,
 					unsigned int num_items);
-- 
2.55.0

