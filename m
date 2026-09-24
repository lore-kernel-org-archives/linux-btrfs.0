Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A842E3EDE43
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Sep 2026 05:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790229535; cv=none; b=cZGOL31ofl0SsMCtjPdNIndDjWfY+hHbDqvjotVepPbuAGmzHgt6TgKKdvXQtNXuIDwIAt0gyW/Lu0QNIg18YwODc42/pWto4o+CGS+upiSxh9d7/I+3ZmYXdBJ5EHIyH9L/ZsmeLC/5Uyskkfm2Yo/4bjy4xyjO88SKo3FP95E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790229535; c=relaxed/simple;
	bh=J1PD9ew5wU8U1l01Oic24lNAIu7++jMKWB1KS9g28Ac=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SGDqkrjCrd+VLX9dagZRBNHrINJ1hDqB1XZwF3pbZ2NTHoDs57WDOGlE5baVLNFoD6cESfk8sS026djmFxc0YXF4i3o6bq2xWp/fSTbY/PMXlKddk2Ww1EOckgqVp4oyZmCHXkni0iVgYXEYOBUqmpa20TurFb2FbjAAhwTBI74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ilDUFOcb; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=kHMln4d1; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ilDUFOcb";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="kHMln4d1"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8F0021FF28
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Sep 2026 05:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1790229521; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EzyqvnXsjRpkUy+Tcmx8CeoiNLmqGaFvOzvh7xIWBuQ=;
	b=ilDUFOcb/o8R8KL7bVfP+KPWRQNgr+SlBLE5SngJaNpmM0oWsa5UFqV7Mo45GC53APEZUv
	19GxS2mu9xQaZakCJJU08+gKHojCUk7LyfHiUdtG0mUqkdAKdAzpy/+GuqYXoEqm+7fbUC
	zTPlfpIV0R+WRuReSbMd9BhhtuHfYTc=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1790229517; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EzyqvnXsjRpkUy+Tcmx8CeoiNLmqGaFvOzvh7xIWBuQ=;
	b=kHMln4d1vsHBAdQk2MntzBXdzL322r3iCRJSvkfcLr1Ryk/kgBAoNJPW7ngUh592KL+cP5
	kwoGXn4XypNenewjfwORi3GcxWsRiPe3dnnUfyo1pneMFfJVw4+fITYK10MD68RRBcfRqm
	AfQIIvPh6p6JIfPpQ2VricyziHSM4Bg=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5041613A62
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Sep 2026 05:58:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oEOcAwq8tGq3OAAAD6G6ig:T2
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Sep 2026 05:58:36 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 1/3] btrfs: move __TRANS_* and TRANS_* flags out of transaction.h
Date: Thu, 24 Sep 2026 15:28:14 +0930
Message-ID: <f8b46621fa212642c4d961f790bac84ec42adb49.1790229298.git.wqu@suse.com>
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
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO

Among all those flags, only __TRANS_DUMMY is used outside of
transaction.[ch], and there are only two places using it:

- find_parent_nodes()
  Introduce a helper, btrfs_trans_is_dummy(), for this call site.

- btrfs_init_dummy_trans()
  Move the function into transaction.[ch], and hide it behind
  CONFIG_BTRFS_FS_RUN_SANITY_TESTS.

With the above changes, we can hide __TRANS_* and TRANS_* flags inside
transaction.c. This allows us to modify those flags in the future
without causing any changes to existing callers.

After the flags relocation, now we can also hide __TRANS_DUMMY behind
CONFIG_BTRFS_FS_RUN_SANITY_TESTS.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/backref.c           |  2 +-
 fs/btrfs/tests/btrfs-tests.c |  9 ---------
 fs/btrfs/tests/btrfs-tests.h |  2 --
 fs/btrfs/transaction.c       | 36 ++++++++++++++++++++++++++++++++++++
 fs/btrfs/transaction.h       | 29 +++++++++++------------------
 5 files changed, 48 insertions(+), 30 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 1be632c742bd..939511629ecc 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1432,7 +1432,7 @@ static int find_parent_nodes(struct btrfs_backref_walk_ctx *ctx,
 		goto out;
 	}
 
-	if (ctx->trans && likely(ctx->trans->type != __TRANS_DUMMY) &&
+	if (ctx->trans && likely(!btrfs_trans_is_dummy(ctx->trans)) &&
 	    ctx->time_seq != BTRFS_SEQ_LAST) {
 		/*
 		 * We have a specific time_seq we care about and trans which
diff --git a/fs/btrfs/tests/btrfs-tests.c b/fs/btrfs/tests/btrfs-tests.c
index 6287d940323d..cebc9a17b94d 100644
--- a/fs/btrfs/tests/btrfs-tests.c
+++ b/fs/btrfs/tests/btrfs-tests.c
@@ -247,15 +247,6 @@ void btrfs_init_dummy_transaction(struct btrfs_transaction *trans, struct btrfs_
 	spin_lock_init(&trans->delayed_refs.lock);
 }
 
-void btrfs_init_dummy_trans(struct btrfs_trans_handle *trans,
-			    struct btrfs_fs_info *fs_info)
-{
-	memset(trans, 0, sizeof(*trans));
-	trans->transid = 1;
-	trans->type = __TRANS_DUMMY;
-	trans->fs_info = fs_info;
-}
-
 int btrfs_run_sanity_tests(void)
 {
 	int ret, i;
diff --git a/fs/btrfs/tests/btrfs-tests.h b/fs/btrfs/tests/btrfs-tests.h
index cea58fe84a6d..a16855138105 100644
--- a/fs/btrfs/tests/btrfs-tests.h
+++ b/fs/btrfs/tests/btrfs-tests.h
@@ -59,8 +59,6 @@ btrfs_alloc_dummy_block_group(struct btrfs_fs_info *fs_info, unsigned long lengt
 void btrfs_free_dummy_block_group(struct btrfs_block_group *cache);
 DEFINE_FREE(btrfs_free_dummy_block_group, struct btrfs_block_group *,
 	    btrfs_free_dummy_block_group(_T));
-void btrfs_init_dummy_trans(struct btrfs_trans_handle *trans,
-			    struct btrfs_fs_info *fs_info);
 void btrfs_init_dummy_transaction(struct btrfs_transaction *trans, struct btrfs_fs_info *fs_info);
 struct btrfs_device *btrfs_alloc_dummy_device(struct btrfs_fs_info *fs_info);
 
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index ca114235bbe1..4181f3897a30 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -38,6 +38,26 @@
 
 static struct kmem_cache *btrfs_trans_handle_cachep;
 
+enum {
+	ENUM_BIT(__TRANS_FREEZABLE),
+	ENUM_BIT(__TRANS_START),
+	ENUM_BIT(__TRANS_ATTACH),
+	ENUM_BIT(__TRANS_JOIN),
+	ENUM_BIT(__TRANS_JOIN_NOLOCK),
+#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
+	ENUM_BIT(__TRANS_DUMMY),
+#endif
+	ENUM_BIT(__TRANS_JOIN_NOSTART),
+};
+
+#define TRANS_START		(__TRANS_START | __TRANS_FREEZABLE)
+#define TRANS_ATTACH		(__TRANS_ATTACH)
+#define TRANS_JOIN		(__TRANS_JOIN | __TRANS_FREEZABLE)
+#define TRANS_JOIN_NOLOCK	(__TRANS_JOIN_NOLOCK)
+#define TRANS_JOIN_NOSTART	(__TRANS_JOIN_NOSTART)
+
+#define TRANS_EXTWRITERS	(__TRANS_START | __TRANS_ATTACH)
+
 /*
  * Transaction states and transitions
  *
@@ -139,6 +159,22 @@ static const unsigned int btrfs_blocked_trans_types[TRANS_STATE_MAX] = {
 					   __TRANS_JOIN_NOSTART),
 };
 
+#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
+bool btrfs_trans_is_dummy(const struct btrfs_trans_handle *trans)
+{
+	return trans->type == __TRANS_DUMMY;
+}
+
+void btrfs_init_dummy_trans(struct btrfs_trans_handle *trans,
+			    struct btrfs_fs_info *fs_info)
+{
+	memset(trans, 0, sizeof(*trans));
+	trans->transid = 1;
+	trans->type = __TRANS_DUMMY;
+	trans->fs_info = fs_info;
+}
+#endif
+
 void btrfs_put_transaction(struct btrfs_transaction *transaction)
 {
 	if (refcount_dec_and_test(&transaction->use_count)) {
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 89153cd22596..9eb92b1ad54d 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -119,24 +119,6 @@ struct btrfs_transaction {
 	wait_queue_head_t pending_wait;
 };
 
-enum {
-	ENUM_BIT(__TRANS_FREEZABLE),
-	ENUM_BIT(__TRANS_START),
-	ENUM_BIT(__TRANS_ATTACH),
-	ENUM_BIT(__TRANS_JOIN),
-	ENUM_BIT(__TRANS_JOIN_NOLOCK),
-	ENUM_BIT(__TRANS_DUMMY),
-	ENUM_BIT(__TRANS_JOIN_NOSTART),
-};
-
-#define TRANS_START		(__TRANS_START | __TRANS_FREEZABLE)
-#define TRANS_ATTACH		(__TRANS_ATTACH)
-#define TRANS_JOIN		(__TRANS_JOIN | __TRANS_FREEZABLE)
-#define TRANS_JOIN_NOLOCK	(__TRANS_JOIN_NOLOCK)
-#define TRANS_JOIN_NOSTART	(__TRANS_JOIN_NOSTART)
-
-#define TRANS_EXTWRITERS	(__TRANS_START | __TRANS_ATTACH)
-
 /*
  * Number of extent buffers a transaction handle tracks for writeback
  * inhibition. The CLOCK reference bits pack into a u32 so this must not exceed
@@ -305,6 +287,17 @@ do {								\
 				  __LINE__, __error);		\
 } while (0)
 
+#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
+bool btrfs_trans_is_dummy(const struct btrfs_trans_handle *trans);
+void btrfs_init_dummy_trans(struct btrfs_trans_handle *trans,
+			    struct btrfs_fs_info *fs_info);
+#else
+static inline bool btrfs_trans_is_dummy(const struct btrfs_trans_handle *trans)
+{
+	return false;
+}
+#endif
+
 int btrfs_end_transaction(struct btrfs_trans_handle *trans);
 struct btrfs_trans_handle *btrfs_start_transaction(struct btrfs_root *root,
 						   unsigned int num_items);
-- 
2.55.0

