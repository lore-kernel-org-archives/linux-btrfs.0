Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69854508FF
	for <linux-btrfs@vger.kernel.org>; Thu,  7 May 2026 18:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778176806; cv=none; b=s6UL+vzHZYEL+aTEEobDpXpIyceU8MRuLWm+j4C2f0c7dSXwEDczrtNeBvngr/nN0HVIv1D/Xjse9mw+eqT4sE1ownyprGGd3prJrXkwUvv1V/ibgUECeHaPMrIeCIKmAl3yb2QEwySjrD0TD/Q+MIzCsSTa+oqsSLwaGxS0nzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778176806; c=relaxed/simple;
	bh=U626NxbuXWag+0EVv316NY4xGuVy7D6yOyg5igfV7rI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ehca0AI2Cp9QPVa8CJwwlSV+igf7z9YMBGyktGe/iVLXBBnMbaNnXfWAyJue1tkOKr9ZKBpo6QTXSTIwUY46FohwGr2If8bzfr5eM3xO5aELvq3SKcY1+ayGJTC2DmZB1bLrA7XDDbkXKLbqIRunI6CM5zCPltXDp2vIDN5JBvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Gh0cT89F; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=huWjtf1+; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Gh0cT89F";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="huWjtf1+"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E802E66E8E;
	Thu,  7 May 2026 18:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778176803; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oJ6gDPUwIO0hwHqNrr4t2+wyM3PdqsA3NCXgzuHXlxE=;
	b=Gh0cT89F0zVDJLJAu9buU0itINoQh/d01SD5nRgNHA9u9+5x9nlLuSg/yC+94n34+jcNF1
	7bh+pciROktC+5T8CNq0JvqIVyP/cYgC+AuD9jcpHIsWxIHHkZ4+vryxmHi+OCuxpuGOXt
	nk2zcCvalrcJ7mV2K1LIzBrrjhH6fa4=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=huWjtf1+
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778176802; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oJ6gDPUwIO0hwHqNrr4t2+wyM3PdqsA3NCXgzuHXlxE=;
	b=huWjtf1+6Yn+bSf0RNOeqOyrqenfSZe1FTbCK1lBoth5pofoD7L6U+ROlaDYvN+FALael1
	Ztg8UJljxR3duFbCXdSHZSz1JWOO/pJnpoZgHCTAYSqj8mE9uM5HdDcYz/XsTCRhe9NkrI
	hdUQXKNCD3/FA+BPOl6RImWWgMjeRrs=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E1D6A593A7;
	Thu,  7 May 2026 18:00:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id psYgNyLT/GklCQAAD6G6ig
	(envelope-from <dsterba@suse.com>); Thu, 07 May 2026 18:00:02 +0000
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH v2 2/2] btrfs: simplify how first hit is passed to __btrfs_abort_transaction()
Date: Thu,  7 May 2026 19:59:32 +0200
Message-ID: <06764bc69306e40baf712eeaa3589dba733769aa.1778176579.git.dsterba@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1778176579.git.dsterba@suse.com>
References: <cover.1778176579.git.dsterba@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Action: no action
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
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim,suse.com:email,suse.com:mid];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Queue-Id: E802E66E8E
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Score: -3.01

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
 fs/btrfs/transaction.h | 17 ++++++++++-------
 2 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 0fd596e2c65b..bc99d1200d28 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -2722,12 +2722,23 @@ int btrfs_clean_one_deleted_snapshot(struct btrfs_fs_info *fs_info)
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
index 72ab32c8ddca..5e4b1106fd90 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -266,21 +266,24 @@ do {										\
 } while(0)
 
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
 	VERIFY_NEGATIVE_ERROR(error);				\
 	/* Report first abort since mount */			\
 	if (!test_and_set_bit(BTRFS_FS_STATE_TRANS_ABORTED,	\
 			&((trans)->fs_info->fs_state))) {	\
-		__first = true;					\
-		WARN_ON(btrfs_abort_should_print_stack(error));	\
+		WARN_ON(btrfs_abort_should_print_stack(__error)); \
+		__error = -__error;				\
 	}							\
 	__btrfs_abort_transaction((trans), __func__,		\
-				  __LINE__, (error), __first);	\
+				  __LINE__, __error);		\
 } while (0)
 
 int btrfs_end_transaction(struct btrfs_trans_handle *trans);
@@ -318,7 +321,7 @@ void btrfs_add_dropped_root(struct btrfs_trans_handle *trans,
 void btrfs_trans_release_chunk_metadata(struct btrfs_trans_handle *trans);
 void __cold __btrfs_abort_transaction(struct btrfs_trans_handle *trans,
 				      const char *function,
-				      unsigned int line, int error, bool first_hit);
+				      unsigned int line, int error);
 
 int __init btrfs_transaction_init(void);
 void __cold btrfs_transaction_exit(void);
-- 
2.53.0

