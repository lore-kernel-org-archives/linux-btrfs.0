Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793374587;
	b=04nd7g4wxpPa842uy/IusXODsTB2blF4SkoCnslsdTXNhL4BT+aj4I8Du5Kk6rbSJ2xS
	 TsC3DYPO/6h9iDOtUIIr7glXtu7Z2F8Sn95weN4wRhQwg3Z9PhIRH4UTs8Qs0v6uMYzWU
	 jXmrDk73hGPnpamA+l9NWEonj2tncNbISICkOWaH+U8QqKGVlFldo89NP2YhN28b/lUyP
	 8slpAMk8Fz8Y0/8bPFU/x5Jjg29hhbG5xWt6I0rCBhbeWBjV8AoPch8ri/RgBfZWha+MJ
	 imsK2CWmADUn40bbPmtjGTB/G40AaDdGxIp1VPHnufrxuS2cfhaRbIAi3DyE6P9W96w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793374587;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Flag:X-Spam-Level:X-Spamd-Result:
	 X-Spam-Score;
	bh=sd5RL1XCNlo2sqTNOx3kwpxSRfkZd0uC81i/NNCK/dU=;
	b=mPyk8tk5OmtRVPf2pLLXvXa9V6iW6nuPjvJvaHic+lbSfcKIaiVts6HyEO9k9dWc0Ire
	 OSaG6sJfFtNiQYKtP4f8Z/LFyaKC8SseOjnB8rC0cQv3eerJnoiPe9ZAD6s2UlcMpiDdO
	 +WqYTjvLXb+Hi5QsaoqnUnsR9JYwvSJA4f1qWQohj1nRyP26KMpmLGk4ZcBb3qvrvwUiq
	 LjToWnkhRiJTRRjZBFTMSWmV+6Co+FHiLcFWCalfv9B91rtLBDGhgUW/lfSWUz18F8xg8
	 XY6soRsUsv03ZXqG59J96aw9vHbKKRGKm5xXWW5siyJ08ebrl/Ov/0m2oV70yx7ELtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b="GJnaf7C/";
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=uCiLmze4;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEAEE606A31F;
	Fri, 30 Oct 2026 15:36:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BEAEE606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=GJnaf7C/;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=uCiLmze4
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E577E20152;
	Fri, 30 Oct 2026 15:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793374585; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=sd5RL1XCNlo2sqTNOx3kwpxSRfkZd0uC81i/NNCK/dU=;
	b=GJnaf7C/59Bw/iGsZVvdlooRAc1wb7rQ4opA+jjUMVcio3fbDS9jp4mgBn/NDuGMSm+GT4
	wIK5qzCoN5qsUAD/d/PjNYyVWJehvRUUX31zCMxZB5/ZP2+p0J+4brHoSXOp2hX4BC2h/H
	sKXxpLAMieW1MX8J0nwvdMrnStd7Vs8=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793374584; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=sd5RL1XCNlo2sqTNOx3kwpxSRfkZd0uC81i/NNCK/dU=;
	b=uCiLmze42TJIkHNiuFigvNYMrMOGTXfy9ENvW/xkpP2JN2n8tj1Df1KwtvYuOGaIUYl42J
	BeR4LL2WWNLCN2kZJiGV6zkN9VePHq8+61SWcTes4n7GcEIiYwCWmDVCU6zNqQzyqeMvIH
	bFqGmBDBVF8q1KjsUfJfztIKC7gdApc=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AF64E13432;
	Fri, 30 Oct 2026 15:36:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PZ2HH3i55GrMXwAAD6G6ig
	(envelope-from <neelx@suse.com>); Fri, 30 Oct 2026 15:36:24 +0000
From: Daniel Vacek <neelx@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Daniel Vacek <neelx@suse.com>,
	"Naulls, Peter" <PeterNaulls@eaton.com>,
	linux-rt-devel@lists.linux.dev,
	stable@vger.kernel.org
Subject: [PATCH] btrfs: fix a livelock in wait_for_commit() on PREEMPT_RT
Date: Fri, 30 Oct 2026 16:36:17 +0100
Message-ID: <20261030153617.329733-1-neelx@suse.com>
X-Mailer: git-send-email 2.53.0
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
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-11.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80

Peter reported [1] that running multiple RR tasks doing sync()
on fully preemptible kernel may starve other/normal sync() tasks
due to fs_info::trans_lock turned into rt_mutex.

This is caused by RR tasks contending over the mutex with priority over
other tasks, which in turn lack progress and they are no longer able to
remove TRANS_STATE_COMPLETED transactions from the fs_info::trans_list.

The offenders start looping in wait_for_commit() expecting the completed
transactions to get off the trans_list but since they're bouncing the
trans_lock the tasks with other/normal priority which are about to delist
such transactions never get a chance to do so due to lower priority.

A simple reproducer can be found in the mentioned email thread [1].

The situation can be resolved by boosting the priority of the starved
tasks or dropping priority of the offenders. Thought this fix prevents
the situation from happening in the first place. We simply delist the
transactions before changing them to completed state. That breaks the
loop condition.

[1] https://lore.kernel.org/linux-btrfs/SJ0PR17MB4288C46458DCE2C015839D0FBB9E2@SJ0PR17MB4288.namprd17.prod.outlook.com/

Reported-by: Naulls, Peter <PeterNaulls@eaton.com>
Fixes: 5fd76bf31ccfe ("btrfs: fix relocation crash due to premature return from btrfs_commit_transaction()")
CC: stable@vger.kernel.org # 5.15+
Tested-by: Naulls, Peter <PeterNaulls@eaton.com>
Signed-off-by: Daniel Vacek <neelx@suse.com>
---
 fs/btrfs/disk-io.c     | 18 +++++++-----------
 fs/btrfs/transaction.c | 15 +++++----------
 2 files changed, 12 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index c628c5081d92..6afcd6ca2a8a 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4312,10 +4312,6 @@ static void warn_about_uncommitted_trans(struct btrfs_fs_info *fs_info)
 			   trans->transid, dirty_bytes);
 		btrfs_cleanup_one_transaction(trans);
 
-		if (trans == fs_info->running_transaction)
-			fs_info->running_transaction = NULL;
-		list_del_init(&trans->list);
-
 		btrfs_put_transaction(trans);
 	}
 	ASSERT(!found);
@@ -4937,7 +4933,13 @@ void btrfs_cleanup_one_transaction(struct btrfs_transaction *cur_trans)
 				     EXTENT_DIRTY);
 	btrfs_destroy_pinned_extent(fs_info, &cur_trans->pinned_extents);
 
-	cur_trans->state =TRANS_STATE_COMPLETED;
+	spin_lock(&fs_info->trans_lock);
+	if (cur_trans == fs_info->running_transaction)
+		fs_info->running_transaction = NULL;
+	list_del_init(&cur_trans->list);
+	spin_unlock(&fs_info->trans_lock);
+
+	cur_trans->state = TRANS_STATE_COMPLETED;
 	wake_up(&cur_trans->commit_wait);
 }
 
@@ -4973,12 +4975,6 @@ static int btrfs_cleanup_transaction(struct btrfs_fs_info *fs_info)
 		}
 		btrfs_cleanup_one_transaction(t);
 
-		spin_lock(&fs_info->trans_lock);
-		if (t == fs_info->running_transaction)
-			fs_info->running_transaction = NULL;
-		list_del_init(&t->list);
-		spin_unlock(&fs_info->trans_lock);
-
 		btrfs_put_transaction(t);
 		spin_lock(&fs_info->trans_lock);
 	}
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index d265fac023e5..cd7dff5ba59b 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -2124,12 +2124,7 @@ static void cleanup_transaction(struct btrfs_trans_handle *trans, int err)
 
 	spin_unlock(&fs_info->trans_lock);
 
-	btrfs_cleanup_one_transaction(trans->transaction);
-
-	spin_lock(&fs_info->trans_lock);
-	if (cur_trans == fs_info->running_transaction)
-		fs_info->running_transaction = NULL;
-	spin_unlock(&fs_info->trans_lock);
+	btrfs_cleanup_one_transaction(cur_trans);
 
 	if (trans->type & TRANS_SB_INTWRITER_MASK)
 		sb_end_intwrite(fs_info->sb);
@@ -2641,6 +2636,10 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 		btrfs_clear_space_info_full(fs_info);
 
 	btrfs_set_last_trans_committed(fs_info, cur_trans->transid);
+
+	spin_lock(&fs_info->trans_lock);
+	list_del_init(&cur_trans->list);
+	spin_unlock(&fs_info->trans_lock);
 	/*
 	 * We needn't acquire the lock here because there is no other task
 	 * which can change it.
@@ -2650,10 +2649,6 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	wake_up(&cur_trans->commit_wait);
 	btrfs_trans_state_lockdep_release(fs_info, BTRFS_LOCKDEP_TRANS_COMPLETED);
 
-	spin_lock(&fs_info->trans_lock);
-	list_del_init(&cur_trans->list);
-	spin_unlock(&fs_info->trans_lock);
-
 	btrfs_put_transaction(cur_trans);
 	btrfs_put_transaction(cur_trans);
 
-- 
2.53.0

