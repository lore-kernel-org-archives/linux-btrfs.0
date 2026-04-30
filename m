Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3309A2417D1
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Apr 2026 14:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777558743; cv=none; b=QpRNFnMIpMwWYgAQJ0fm+vqAn+zxFqgdEtfIDPFRXQYWqn/NqlhuWqQmrJZUUnH1mLNKv+D3qWDcREvoC0oxC7C1ZLBiiC8imy2QR5d90YNo1+hHJuPBm1X5jfzJJ8qdf9qvgr6qJWkqfyNaR02J2g0GNzfhQiqEGl1dch3GlFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777558743; c=relaxed/simple;
	bh=lH4eikemgkkKgYTQeZjy51xbIWTEx/gDkGOqgcWR4Bg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pwix3gLqjIwtIxG8COxrA1cINP02CsV3rv5UpJ5I91xITgS4bQtQMdlM5kL5tk4CeFAX3H9TgXNFwLS7n94/QVenP9oSUxK0QXxTdEbqRrhLL78zzz4wiVolkXY8ApiF1yEFqWXlyRDMQ8R8prjKltX8i1WOx25MfpmIoCP9WCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=pu5Yrl9F; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=pu5Yrl9F; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="pu5Yrl9F";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="pu5Yrl9F"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 850386A865;
	Thu, 30 Apr 2026 14:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777558740; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=g5DequyvuXbsFKl5fjzbfCmJ5P2wWHnLUobXdOWGNGw=;
	b=pu5Yrl9FeczkoGILikQbj0IS//wEd8Tt3YFnKo7iTwG7/UYGJRGIwxsSS9uX3lMhmCsDgS
	wv0ZQkxMY3GTbZKJT+L32I9HAa9cxOGgaCG2TReRSrBn/nlDqh0Yc5wX5hkcQhvAf/Nojn
	VXwOKgEBI2InjFSE/5FTJtA1aQgGs44=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777558740; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=g5DequyvuXbsFKl5fjzbfCmJ5P2wWHnLUobXdOWGNGw=;
	b=pu5Yrl9FeczkoGILikQbj0IS//wEd8Tt3YFnKo7iTwG7/UYGJRGIwxsSS9uX3lMhmCsDgS
	wv0ZQkxMY3GTbZKJT+L32I9HAa9cxOGgaCG2TReRSrBn/nlDqh0Yc5wX5hkcQhvAf/Nojn
	VXwOKgEBI2InjFSE/5FTJtA1aQgGs44=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7D455593B0;
	Thu, 30 Apr 2026 14:19:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6lKUHtRk82l4aQAAD6G6ig
	(envelope-from <dsterba@suse.com>); Thu, 30 Apr 2026 14:19:00 +0000
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: simplify how first hit is passed to __btrfs_abort_transaction()
Date: Thu, 30 Apr 2026 16:18:51 +0200
Message-ID: <20260430141851.14332-1-dsterba@suse.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid,suse.com:email];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

Optimize the btrfs_abort_transaction() for size as it (by our
convention) must be put right after the error condition is detected.
The exact file:line is reported so there's a portion that must be
inlined. As this is cold code it bloats functions. In previous patch
"btrfs: move transaction abort message to __btrfs_abort_transaction()"
the error message was moved to the common helper, saving like 20KiB of
btrfs.ko and several instructions per call site and some stack space.

There's little left to be optimized, we need to keep the atomic
test_and_set_bit() and to convey that as 'first hit' to
__btrfs_abort_transaction().

Right now it's a bool, which takes 8 bytes on stack for each call but
it's 1 bit of information. We can encode that to some of the other
parameters.

For that let's use the 'error' parameter, by convention it's negative
errno so we can reliably detect if it's the first hit or a later error.
Also the negation is usually implemented by a single instruction (NEG on
x86_64) so the resulting object code is kept short.

This reduces btrfs.ko by 8K and stack in several functions by 8 bytes.

Cumulative effect with the other commit is -30K of btrfs.ko. While the
encoding is an implementation detail, it's contained within the API.
Making the transaction abort calls very light is desired.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/transaction.c | 13 ++++++++++++-
 fs/btrfs/transaction.h | 15 +++++++++------
 2 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 01f66328966f..bbef3ae86ac4 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -2723,12 +2723,23 @@ int btrfs_clean_one_deleted_snapshot(struct btrfs_fs_info *fs_info)
  *
  * We'll complete the cleanup in btrfs_end_transaction and
  * btrfs_commit_transaction.
+ *
+ * Note: the parameter @error encodes whether the transactin abort was first hit
+ *       (setting the FS_ERROR state bit in btrfs_abort_transaction())
+ *       - positive number - first hit
+ *       - negative number - abort after it was already done
  */
 void __cold __btrfs_abort_transaction(struct btrfs_trans_handle *trans,
 				      const char *function,
-				      unsigned int line, int error, bool first_hit)
+				      unsigned int line, int error)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
+	bool first_hit = false;
+
+	if (error > 0) {
+		error = -error;
+		first_hit = true;
+	}
 
 	WRITE_ONCE(trans->aborted, error);
 	WRITE_ONCE(trans->transaction->aborted, error);
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index f1cb05460cec..e1d4e7330198 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -243,20 +243,23 @@ static inline bool btrfs_abort_should_print_stack(int error)
 }
 
 /*
- * Call btrfs_abort_transaction as early as possible when an error condition is
- * detected, that way the exact stack trace is reported for some errors.
+ * Call btrfs_abort_transaction() as early as possible when an error condition
+ * is detected, that way the exact stack trace is reported for some errors.
+ *
+ * Error number must be negative as it encodes wheather it's the first abort.
  */
 #define btrfs_abort_transaction(trans, error)		\
 do {								\
-	bool __first = false;					\
+	int __error = (error);					\
+								\
 	/* Report first abort since mount */			\
 	if (!test_and_set_bit(BTRFS_FS_STATE_TRANS_ABORTED,	\
 			&((trans)->fs_info->fs_state))) {	\
-		__first = true;					\
+		__error = -__error;				\
 		WARN_ON(btrfs_abort_should_print_stack(error));	\
 	}							\
 	__btrfs_abort_transaction((trans), __func__,		\
-				  __LINE__, (error), __first);	\
+				  __LINE__, __error);		\
 } while (0)
 
 int btrfs_end_transaction(struct btrfs_trans_handle *trans);
@@ -294,7 +297,7 @@ void btrfs_add_dropped_root(struct btrfs_trans_handle *trans,
 void btrfs_trans_release_chunk_metadata(struct btrfs_trans_handle *trans);
 void __cold __btrfs_abort_transaction(struct btrfs_trans_handle *trans,
 				      const char *function,
-				      unsigned int line, int error, bool first_hit);
+				      unsigned int line, int error);
 
 int __init btrfs_transaction_init(void);
 void __cold btrfs_transaction_exit(void);
-- 
2.51.0

