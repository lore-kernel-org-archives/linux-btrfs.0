Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794371206;
	b=v4l4i/t3I10kwIhNbqb0/ZYIJDM6CGLG1egflOYwBAhSfp3Yui08RWLFNZg8zBA8KwSr
	 qIFCu77ploU3j4l+WNETtarN1pGkCfThs0chYzacqHFAyao6+UWkvYQuPohEHh1vv98tJ
	 Tfta0jMn1OU7z9ybWAc4I0FcO9i2fqtOkfrdnJlkGty5vGp8AK+wttLDo6b4pwTVLyZ/K
	 h1ranTVwxH7yoMGnzjCy+t8l1SWWn1MbSoKpj+2ENO/abv+afvkSWHyA33Hxz1mgOIIsy
	 s9oTYPrTNgfWMFnAo950qbaZ7d/SEonhjOHE3Da8GhLbxmZRxhKX6CpLFkh4YOZrOGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794371206;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Spamd-Result:X-Spam-Score:X-Spam-Level:
	 X-Spam-Flag;
	bh=8myrueTot67B76Txmos5dyLVFcR8TMQ2fxp4UzrdEaQ=;
	b=hWahTO7qYhAYhS6kvZhcpZ7QnZLs9wKC1QActgh6imVbKkYCEv4GKCVLSjkNfOeYZILn
	 hQnp9guWTaAFzlxTvulIlASASc6fi0b6XHAGAcAFC5IxhycE/aLiz7gbqAhtfCJZoBRQS
	 K5spHc5yC6bhM7Wfsr7J413dITcDZ/Hc1ljz5B889jI9Dsk2YzhidLNHWTyuE1s+Ht/cO
	 igtC9cny+Jr8Db8Zse9l5UhAAZyvgDxmAABPJ7dTojzIWsRt6axfnB4FMjAdO+fie5VNp
	 WhKJcroeIbdyZKAGnCiICOWty08uJzPOI+oIdJ7+zAKA26Ut4x9BPLPoytSXySgDIyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=GjzusdZz;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=A5xqqHfs;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7135860A2622
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Nov 2026 04:26:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7135860A2622
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=GjzusdZz;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=A5xqqHfs
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4830A21E64
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Nov 2026 04:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794371203; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=8myrueTot67B76Txmos5dyLVFcR8TMQ2fxp4UzrdEaQ=;
	b=GjzusdZzekYN0bMh2hlN2ZrzhuWRmfRAZ0040MS+JG9p+3sRIaazqFTJ2Lx3RVq/6Ss0SR
	Em14r1UWA6j8uir/whrWDx6EHN51vfDtwzYJa4/xRAf9aK1TtE+cry33elKtHyXKcTq8O+
	wjugLgh7STOKgvSODGE1ONQZRFfBsC8=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794371202; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=8myrueTot67B76Txmos5dyLVFcR8TMQ2fxp4UzrdEaQ=;
	b=A5xqqHfsJJVTo6TGnviaFpyPFMnJKaQbhd6SgrNcj+6keV91Nc/jjOyHmGY7UwJcx4zP0a
	/l9J2D1gJud/7OvvODcS5MBHMdxZHj7ePdegmCMHaI8Xio2kpW4/1TCgHYqbHx5SvT2DcC
	p0PGsUT3eE6+pyHBWO7YunjdYdEJdm0=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F10CE134E5
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Nov 2026 04:26:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id t45uEYDu82rXIgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Nov 2026 04:26:40 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: zstd: use a dedicated hidden max level workspace
Date: Wed, 11 Nov 2026 14:56:22 +1030
Message-ID: <29f91f205377d9076610cacff756194285eb400f.1794371180.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-11.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,sashiko.dev:url,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80
X-Spam-Level: 
X-Spam-Flag: NO

zstd_get_workspace() relies on one max level workspace being hidden from
the reclaim lru list, so that after a failed allocation under memory
pressure there is always a max level workspace to wait for.

But which workspace is hidden is decided on every put, by checking whether
idle_ws[max] is empty, and that can go wrong. A max level workspace can
sit on the lru list, e.g. W2 that was put while W1 was already idle at the
max level. Then:

 Task A (level 1)                     Task B (level 15)
 zstd_get_workspace()
 \-zstd_find_workspace()
   |-pops W2 from idle_ws[max]
   \-req_level = 1, W2 stays on lru
                                      zstd_get_workspace()
                                      \-zstd_find_workspace()
                                        \-pops W1, idle_ws[max] is empty
 zstd_put_workspace(W2)
 |-clip_level(req_level) != level
 | ^^^ skips the lru update
 \-adds W2 back to idle_ws[max]
                                      zstd_put_workspace(W1)
                                      |-idle_ws[max] is not empty
                                      | ^^^ no longer hidden
                                      \-adds W1 to the lru list

Now both max level workspaces are on the lru list, and
zstd_reclaim_timer_fn() frees both of them. A later allocation failure in
zstd_get_workspace() then waits forever for a max level workspace that
doesn't exist, as only putting a max level workspace wakes the waiters.

Fix this by recording the hidden workspace in a dedicated member,
zwsm->hidden_ws. It is preallocated at init time, never changes, and is
never added to the lru list. Every other workspace, including other max
level ones, goes through the regular lru path and can be reclaimed.

This means failing to preallocate that workspace now fails the zstd
workspace manager initialization, instead of just a warning, so the
hidden workspace is always there.

Fixes: 3f93aef535c8 ("btrfs: add zstd compression level support")
Link: https://sashiko.dev/#/map/240622
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/zstd.c | 46 +++++++++++++++++++++++++++-------------------
 1 file changed, 27 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/zstd.c b/fs/btrfs/zstd.c
index e4937f6fde29..7c70a7d3b47e 100644
--- a/fs/btrfs/zstd.c
+++ b/fs/btrfs/zstd.c
@@ -80,6 +80,11 @@ struct zstd_workspace_manager {
 	spinlock_t lock;
 	struct list_head lru_list;
 	struct list_head idle_ws[ZSTD_BTRFS_MAX_LEVEL];
+	/*
+	 * The max level workspace preallocated at init time, which is never put
+	 * into the lru list, thus never reclaimed, to guarantee forward progress.
+	 */
+	struct workspace *hidden_ws;
 	unsigned long active_map;
 	wait_queue_head_t wait;
 	struct timer_list timer;
@@ -191,15 +196,20 @@ int zstd_alloc_workspace_manager(struct btrfs_fs_info *fs_info)
 	INIT_LIST_HEAD(&zwsm->lru_list);
 	for (int i = 0; i < ZSTD_BTRFS_MAX_LEVEL; i++)
 		INIT_LIST_HEAD(&zwsm->idle_ws[i]);
-	fs_info->compr_wsm[BTRFS_COMPRESS_ZSTD] = zwsm;
 
+	/*
+	 * Preallocate the hidden max level workspace, it is never reclaimed and
+	 * guarantees forward progress in the worst case.
+	 */
 	ws = zstd_alloc_workspace(fs_info, ZSTD_BTRFS_MAX_LEVEL);
 	if (IS_ERR(ws)) {
-		btrfs_warn(fs_info, "cannot preallocate zstd compression workspace");
-	} else {
-		set_bit(ZSTD_BTRFS_MAX_LEVEL - 1, &zwsm->active_map);
-		list_add(ws, &zwsm->idle_ws[ZSTD_BTRFS_MAX_LEVEL - 1]);
+		kfree(zwsm);
+		return PTR_ERR(ws);
 	}
+	set_bit(ZSTD_BTRFS_MAX_LEVEL - 1, &zwsm->active_map);
+	list_add(ws, &zwsm->idle_ws[ZSTD_BTRFS_MAX_LEVEL - 1]);
+	zwsm->hidden_ws = list_to_workspace(ws);
+	fs_info->compr_wsm[BTRFS_COMPRESS_ZSTD] = zwsm;
 	return 0;
 }
 
@@ -255,7 +265,7 @@ static struct list_head *zstd_find_workspace(struct btrfs_fs_info *fs_info, int
 			/* keep its place if it's a lower level using this */
 			workspace->req_level = level;
 			if (clip_level(level) == workspace->level)
-				list_del(&workspace->lru_list);
+				list_del_init(&workspace->lru_list);
 			if (list_empty(&zwsm->idle_ws[i]))
 				clear_bit(i, &zwsm->active_map);
 			spin_unlock_bh(&zwsm->lock);
@@ -340,19 +350,17 @@ void zstd_put_workspace(struct btrfs_fs_info *fs_info, struct list_head *ws)
 	ASSERT(zwsm);
 	spin_lock_bh(&zwsm->lock);
 
-	/* A node is only taken off the lru if we are the corresponding level */
-	if (clip_level(workspace->req_level) == workspace->level) {
-		/* Hide a max level workspace from reclaim */
-		if (workspace->level == ZSTD_BTRFS_MAX_LEVEL - 1 &&
-		    list_empty(&zwsm->idle_ws[ZSTD_BTRFS_MAX_LEVEL - 1])) {
-			INIT_LIST_HEAD(&workspace->lru_list);
-		} else {
-			workspace->last_used = jiffies;
-			list_add(&workspace->lru_list, &zwsm->lru_list);
-			if (!timer_pending(&zwsm->timer))
-				mod_timer(&zwsm->timer,
-					  jiffies + ZSTD_BTRFS_RECLAIM_JIFFIES);
-		}
+	/*
+	 * A node is only taken off the lru if we are the corresponding level.
+	 * The hidden workspace is never on the lru.
+	 */
+	if (workspace != zwsm->hidden_ws &&
+	    clip_level(workspace->req_level) == workspace->level) {
+		workspace->last_used = jiffies;
+		list_add(&workspace->lru_list, &zwsm->lru_list);
+		if (!timer_pending(&zwsm->timer))
+			mod_timer(&zwsm->timer,
+				  jiffies + ZSTD_BTRFS_RECLAIM_JIFFIES);
 	}
 
 	set_bit(workspace->level, &zwsm->active_map);
-- 
2.56.0

