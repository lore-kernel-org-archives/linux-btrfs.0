Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 870983A759E
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Apr 2026 15:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777391516; cv=none; b=aUAvpXbLPDcwZGLMANbJgoAzU4aJiEEqfLLxlP4XLvYk14hrze83MCTJ/RKGacxQFepKfFM63HVgQZhjoYt57FGwz9myomKRiqobTugJF9pRsDVN7c+yt3+/WAjbTNw5Mzt3MJlBPj7AquSqIzNHyP/rN+Oryf4wCI8sQOxVpaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777391516; c=relaxed/simple;
	bh=veISr0Is9LoPrkGIBUXj2t0hRmv+kNWwySZAPNefeY4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ljA5T+KhxR4D/AOtBHU9UmDKpj13UjXRYKBQV6wHGf52vGwom45CdBuWyeYVIDqTGp3i68BGqqMeBlG4okm+an9hHZoYwfkSnHkPcoCnQX4HPWYxYLKL9sCqHQYFIawEVm/CBfAfAhXgjEE2bk+fH6xrF1Uf11UxwtcL7iWTXSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=BxwmxcOp; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=BxwmxcOp; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="BxwmxcOp";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="BxwmxcOp"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D8F396A86B;
	Tue, 28 Apr 2026 15:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777391513; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=kiJ+SPfIVrt7fR7m7pt7F54bnlwN+Z0yI87V0jyy4YA=;
	b=BxwmxcOpvBkDDYM4IBoT4NbJeiilvSoMeia8qDIicgjScuN0otlMI6tapNu1eO+kTfejXq
	RKnRufvwcEA7HF8pMlBpFgN1Ef3lM6R959vTDDWkX/a870olparohZ3Lt4gMO+WD+NZfam
	xnuVh4mww6JalQviJsNMUmDsJUlfTzM=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=BxwmxcOp
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777391513; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=kiJ+SPfIVrt7fR7m7pt7F54bnlwN+Z0yI87V0jyy4YA=;
	b=BxwmxcOpvBkDDYM4IBoT4NbJeiilvSoMeia8qDIicgjScuN0otlMI6tapNu1eO+kTfejXq
	RKnRufvwcEA7HF8pMlBpFgN1Ef3lM6R959vTDDWkX/a870olparohZ3Lt4gMO+WD+NZfam
	xnuVh4mww6JalQviJsNMUmDsJUlfTzM=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D309C593B0;
	Tue, 28 Apr 2026 15:51:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id m6uAM5nX8GlCfwAAD6G6ig
	(envelope-from <dsterba@suse.com>); Tue, 28 Apr 2026 15:51:53 +0000
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: move transaction abort message to __btrfs_abort_transaction()
Date: Tue, 28 Apr 2026 17:51:48 +0200
Message-ID: <20260428155148.2399-1-dsterba@suse.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:dkim,suse.com:mid,suse.com:email]
X-Rspamd-Queue-Id: D8F396A86B
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

The btrfs_abort_transaction() is called at the location where we want to
report the abort. It must be a macro so we get the correct line and
stack trace. This inlines the necessary code and the rest is pushed to
__btrfs_abort_transaction().

There's a possibility to reduce the inlined code if we move the message
to the helper function as well, without loss of information. The
difference is only that the WARN will not print it inside the stack
report but after:

  --[ cut here ]--
  WARNING: fs/btrfs/transaction.c:2045 at btrfs_commit_transaction+0xa21/0xd30 [btrfs], CPU#11: bonnie++/3377975
  ...
  --[ end trace ] --
  BTRFS error (device dm-0 state A): Transaction aborted (error -28)

While previously there would be one more line like:

  --[ cut here ]--
  BTRFS: Transaction aborted (error -28)
  WARNING: fs/btrfs/transaction.c:2045 at btrfs_commit_transaction+0xa21/0xd30 [btrfs], CPU#11: bonnie++/3377975
  ...
  --[ end trace ] --

This removes about 22KiB of btrfs.ko on a release config.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/transaction.c |  3 +++
 fs/btrfs/transaction.h | 11 +----------
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 194f581b36f3..5125cb20ef85 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -2729,6 +2729,9 @@ void __cold __btrfs_abort_transaction(struct btrfs_trans_handle *trans,
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
 
+	btrfs_err(trans->fs_info, "Transaction %llu aborted (error %d)",
+		  trans->transid, error);
+
 	WRITE_ONCE(trans->aborted, error);
 	WRITE_ONCE(trans->transaction->aborted, error);
 	if (first_hit && error == -ENOSPC)
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 264dcd4b3788..f1cb05460cec 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -253,16 +253,7 @@ do {								\
 	if (!test_and_set_bit(BTRFS_FS_STATE_TRANS_ABORTED,	\
 			&((trans)->fs_info->fs_state))) {	\
 		__first = true;					\
-		if (WARN(btrfs_abort_should_print_stack(error),	\
-			KERN_ERR				\
-			"BTRFS: Transaction %llu aborted (error %d)\n",	\
-			(trans)->transid, (error))) {			\
-			/* Stack trace printed. */			\
-		} else {						\
-			btrfs_err((trans)->fs_info,			\
-			"Transaction %llu aborted (error %d)",	\
-				  (trans)->transid, (error));	\
-		}						\
+		WARN_ON(btrfs_abort_should_print_stack(error));	\
 	}							\
 	__btrfs_abort_transaction((trans), __func__,		\
 				  __LINE__, (error), __first);	\
-- 
2.51.0

