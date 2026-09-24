Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C80379988
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Sep 2026 05:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790229536; cv=none; b=IYLb6rEpQJnmp08OXKPl51uInzEFr9HTduWjudjajkAqQmafsaA7pCe+4XlxOcvChfrBrUy1kM+l7ZwPmrGJPqWtIA02fBqKqbzIhCrsjwXzsN6YBs7qUgGPP40NIV+mc3fn3EcaKtB9l6UsHZB8xoU9OF+VMlmPa9iTzqvqwgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790229536; c=relaxed/simple;
	bh=LTanvlyaEPRMTOufXIxGdre9EWcKqG6IlzteyGezhA0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qfNXRSWIgSS4B5ilouUxHmSIddD2kYPo1q3CEE6udMyLrMsYEe+kD56Sz8aLTZm6fJUzXDzWRVAxARAKxEnLtMonVLIfL1TczcjSK8Pk0FsUHY21dTvGiyq3WW3h4aC2pb/W8IrUhaP8YoEFXTmtX8QYtyGUipyHUoBc6FRYfwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=sR1HF1C7; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=fR5Bprpj; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="sR1HF1C7";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="fR5Bprpj"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2FD571FEFC
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Sep 2026 05:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1790229523; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OjI0efpnCZileGztByp7g3fRMlEeSyvmP9S5xNboqEw=;
	b=sR1HF1C7C/HWQ8fEZ7CRdbTU6KNg4fAXGxJey9huZ+6SETEEjLjpn4aotrSm48WvSjPt4f
	mTqRlrotcxNLUGnpTx43ehub94QS6JD9GieX1SR6Fb8w7Cg/PfOeSMxzDDoylKZy42qSPE
	gNT4oJEfw1J04ghJSudPjFVIudGBnik=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=fR5Bprpj
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1790229519; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OjI0efpnCZileGztByp7g3fRMlEeSyvmP9S5xNboqEw=;
	b=fR5BprpjksXqjB18AmjCmWACVvEgj6vA2zdidNiclUff8wFpdDqL2+oC5pXkEYR2HkMuml
	d4KBkswMtHZ3EirBYZmg56orFu+sDpK+DXy+jH+TJnl+U7YhkxqYzQArkxxSUqeNESBhaX
	Q5QsLtpRMsYvIDa1sPC0VkvVPvrhSx8=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E605113A64
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Sep 2026 05:58:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oEOcAwq8tGq3OAAAD6G6ig:T3
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Sep 2026 05:58:37 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 2/3] btrfs: remove __TRANS_FREEZABLE
Date: Thu, 24 Sep 2026 15:28:15 +0930
Message-ID: <0eae09fa05791ff4079a10f778c02cc0da0653b0.1790229298.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1790229298.git.wqu@suse.com>
References: <cover.1790229298.git.wqu@suse.com>
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
X-Rspamd-Queue-Id: 2FD571FEFC
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
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
X-Spam-Flag: NO
X-Spam-Score: -3.01

Inside transaction.c most TRANS_* flags are just a single bit, but there
are 2 exceptions:

- TRANS_START
  Which is (__TRANS_START | __TRANS_FREEZABLE)

- TRANS_JOIN
  Which is (__TRANS_JOIN | __TRANS_FREEZABLE)

The extra __TRANS_FREEZABLE flag indicates that those operations need
to acquire sb intwrite lock to handle fs freezing.

However since there are only two operations requiring sb intwrite lock,
there is no need to introduce a dedicated flag for it, we can introduce
a new TRANS_SB_INTWRITER_MASK to cover the only two cases, then use that
new mask to determine whether the type requires sb intwrite lock.

This makes all TRANS_* flags a single bit.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/transaction.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 4181f3897a30..d73c8723ed70 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -39,7 +39,6 @@
 static struct kmem_cache *btrfs_trans_handle_cachep;
 
 enum {
-	ENUM_BIT(__TRANS_FREEZABLE),
 	ENUM_BIT(__TRANS_START),
 	ENUM_BIT(__TRANS_ATTACH),
 	ENUM_BIT(__TRANS_JOIN),
@@ -50,12 +49,15 @@ enum {
 	ENUM_BIT(__TRANS_JOIN_NOSTART),
 };
 
-#define TRANS_START		(__TRANS_START | __TRANS_FREEZABLE)
+#define TRANS_START		(__TRANS_START)
 #define TRANS_ATTACH		(__TRANS_ATTACH)
-#define TRANS_JOIN		(__TRANS_JOIN | __TRANS_FREEZABLE)
+#define TRANS_JOIN		(__TRANS_JOIN)
 #define TRANS_JOIN_NOLOCK	(__TRANS_JOIN_NOLOCK)
 #define TRANS_JOIN_NOSTART	(__TRANS_JOIN_NOSTART)
 
+/* Those types need to hold sb intwrite lock. */
+#define TRANS_SB_INTWRITER_MASK (__TRANS_START | __TRANS_JOIN)
+
 #define TRANS_EXTWRITERS	(__TRANS_START | __TRANS_ATTACH)
 
 /*
@@ -746,6 +748,8 @@ start_transaction(struct btrfs_root *root, unsigned int num_items,
 	}
 
 	/*
+	 * Only TRANS_START and TRANS_JOIN require sb intwrite lock.
+	 *
 	 * If we are JOIN_NOLOCK we're already committing a transaction and
 	 * waiting on this guy, so we don't need to do the sb_start_intwrite
 	 * because we're already holding a ref.  We need this because we could
@@ -755,7 +759,7 @@ start_transaction(struct btrfs_root *root, unsigned int num_items,
 	 * If we are ATTACH, it means we just want to catch the current
 	 * transaction and commit it, so we needn't do sb_start_intwrite(). 
 	 */
-	if (type & __TRANS_FREEZABLE)
+	if (type & TRANS_SB_INTWRITER_MASK)
 		sb_start_intwrite(fs_info->sb);
 
 	if (may_wait_transaction(fs_info, type))
@@ -857,7 +861,7 @@ start_transaction(struct btrfs_root *root, unsigned int num_items,
 	return h;
 
 join_fail:
-	if (type & __TRANS_FREEZABLE)
+	if (type & TRANS_SB_INTWRITER_MASK)
 		sb_end_intwrite(fs_info->sb);
 	kmem_cache_free(btrfs_trans_handle_cachep, h);
 alloc_fail:
@@ -1138,7 +1142,7 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 
 	btrfs_trans_release_chunk_metadata(trans);
 
-	if (trans->type & __TRANS_FREEZABLE)
+	if (trans->type & TRANS_SB_INTWRITER_MASK)
 		sb_end_intwrite(info->sb);
 
 	/*
@@ -2150,7 +2154,7 @@ static void cleanup_transaction(struct btrfs_trans_handle *trans, int err)
 		fs_info->running_transaction = NULL;
 	spin_unlock(&fs_info->trans_lock);
 
-	if (trans->type & __TRANS_FREEZABLE)
+	if (trans->type & TRANS_SB_INTWRITER_MASK)
 		sb_end_intwrite(fs_info->sb);
 	btrfs_put_transaction(cur_trans);
 	btrfs_put_transaction(cur_trans);
@@ -2682,7 +2686,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	btrfs_put_transaction(cur_trans);
 	btrfs_put_transaction(cur_trans);
 
-	if (trans->type & __TRANS_FREEZABLE)
+	if (trans->type & TRANS_SB_INTWRITER_MASK)
 		sb_end_intwrite(fs_info->sb);
 
 	btrfs_scrub_continue(fs_info);
-- 
2.55.0

