Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2A833D6D7
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Apr 2026 14:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777473189; cv=none; b=bHqGEuWLAjHHtJPZK+6v/H8IQ7N337EUYko+J5uc806Iumq1r66GC6pY5QHB7E5nDAnBfYV//EUb75xf+iHj4Nl9WAQm1MLpZ1u9u7sfT6JDcPcskdn2I1mQa8+FbBP0jKZITOP6f+XIXsVtpdxEmHEu9GbNZvEMj2zfidAwqEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777473189; c=relaxed/simple;
	bh=1RWHgeT080wFcKmN2HDyFzHttS8aUh6cTgNDX/NOAkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VOyOYSOX7E1XutzwRlmcKcCV29u2ubYIolnQ3/3NTje7jPTuEohLl5ZiMjlDVvIO7yseRFmmNYdDllfTZgGiCRisEjL4TL5D6qpWveZHdvk9QjTKwbiapW3pOD1tVH56GEdixXFvtiMIVNpk0qdO1INe7LmFvOYtNXNXqeNpy/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=VUWjbDYO; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=RHvM5WIY; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="VUWjbDYO";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="RHvM5WIY"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 019705BD17;
	Wed, 29 Apr 2026 14:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777473182; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sS/d3v5fq/V54suwMzhRR5OtiSI+IK1UYeUA3ZlCG9Y=;
	b=VUWjbDYOfO7K1nVzlgUUU93jEA2vCBAs5L5BaCbOk3gBT9ELyjSVyuJj4z5WgNnzg2DCy/
	e7sr+p6ngyRBgqeqb49JnHYqNeR4oEB4R3wRgGyyaPVC56QBAC0OCFBbon5c4qU4hRWBZQ
	9OUF8fdQov0vSjERInd5yKNdpeDpj3k=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777473178; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sS/d3v5fq/V54suwMzhRR5OtiSI+IK1UYeUA3ZlCG9Y=;
	b=RHvM5WIY5eFIe2C/zjtaDukZl5BvyUSt5D1S+2HFZsJLKtn4C+RVEzd34nnZWxZeChQQjU
	zbZ+dQZeIOD3a+8OPC4jeQc1R54DkVfhPHXgaXbRbgxZtd5rM8aLhLNxD5pOH1CaqLgQG1
	WyNEwm7lDshU4/TJB7pynBKToAeP0oA=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EE213593B0;
	Wed, 29 Apr 2026 14:32:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CjYdOpkW8mnJagAAD6G6ig
	(envelope-from <dsterba@suse.com>); Wed, 29 Apr 2026 14:32:57 +0000
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH v2] btrfs: move transaction abort message to __btrfs_abort_transaction()
Date: Wed, 29 Apr 2026 16:32:53 +0200
Message-ID: <20260429143253.2236286-1-dsterba@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428155148.2399-1-dsterba@suse.com>
References: <20260428155148.2399-1-dsterba@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.995];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid,suse.com:email];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80
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

This removes about 20KiB of btrfs.ko on a release config.

Signed-off-by: David Sterba <dsterba@suse.com>
---

v2:
- move message in __btrfs_abort_transaction() under 'first_hit', also to
  make the WRITE_ONCE() assignments immediate
- savings updated to 20K, it depends on the config and compiler, use an
  average of a few setups

 fs/btrfs/transaction.c |  8 ++++++--
 fs/btrfs/transaction.h | 11 +----------
 2 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 194f581b36f3..184fe976450e 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -2731,8 +2731,12 @@ void __cold __btrfs_abort_transaction(struct btrfs_trans_handle *trans,
 
 	WRITE_ONCE(trans->aborted, error);
 	WRITE_ONCE(trans->transaction->aborted, error);
-	if (first_hit && error == -ENOSPC)
-		btrfs_dump_space_info_for_trans_abort(fs_info);
+	if (first_hit) {
+		btrfs_err(trans->fs_info, "Transaction %llu aborted (error %d)",
+			  trans->transid, error);
+		if (error == -ENOSPC)
+			btrfs_dump_space_info_for_trans_abort(fs_info);
+	}
 	/* Wake up anybody who may be waiting on this transaction */
 	wake_up(&fs_info->transaction_wait);
 	wake_up(&fs_info->transaction_blocked_wait);
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 7d70fe486758..f1cb05460cec 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -253,16 +253,7 @@ do {								\
 	if (!test_and_set_bit(BTRFS_FS_STATE_TRANS_ABORTED,	\
 			&((trans)->fs_info->fs_state))) {	\
 		__first = true;					\
-		if (WARN(btrfs_abort_should_print_stack(error),	\
-			KERN_ERR				\
-			"BTRFS: Transaction aborted (error %d)\n",	\
-			(error))) {					\
-			/* Stack trace printed. */			\
-		} else {						\
-			btrfs_err((trans)->fs_info,			\
-				  "Transaction aborted (error %d)",	\
-				  (error));			\
-		}						\
+		WARN_ON(btrfs_abort_should_print_stack(error));	\
 	}							\
 	__btrfs_abort_transaction((trans), __func__,		\
 				  __LINE__, (error), __first);	\
-- 
2.53.0

