Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2EC3EDE43
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Sep 2026 05:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790229538; cv=none; b=dGwMahSke2ZUrPGH8i415ohyu2+dAdkwHmaPSfPSivydFIC6W7XyDVkElf4UHl5yxmJtyE0+BWKEqrEcooKLMP1zdbBgeXY3C6MJD/EY/OLP4QAPc7pTDkR8YymJF4LNeqeUhwUAjlVJVq+87+d/JGJ65ZQ8FUene4/nbxE6VBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790229538; c=relaxed/simple;
	bh=ipeRZpcPn9LpTjRcD5TfBXcHIJZYijgrO2idM292b5Q=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bs7qi/RQI7UrWyDr8v4yjSEwglYAP8hN0leHmgOVQe2wUzSAPJVL43T5paPW2EE/3hxwcrT1ct4evvTU1Sv4b11VkO1n8cHPpYoJ6sIQ4oxQknR4VYgvjAztIo//CINa0ZlNiXUUhWHNRC6ZekN7Xem6WyVmhOah/G7E/Xm2jsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=PM1Ntn0G; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=W/+HJy5T; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="PM1Ntn0G";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="W/+HJy5T"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C5DC61FF2A
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Sep 2026 05:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1790229524; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=31rNuj0xFMN1w7BixVucokO40cZ5KdAUF0uRRBIOTuI=;
	b=PM1Ntn0GhIiAjLXr6c6F5GnzA/YBVINg63Je8SXVHkoyP5LJ+MMhYvAGQLNhwWSxSERwMX
	oQ8anpa3o77t9kvpDMewqbmKbqVSj9T+UEKmkrSfVTVUvaDJ5W1whiBfOJUHq+t4CaDMua
	T9hnvMtwnXGysl/k+ikPFHxtejBEpz8=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="W/+HJy5T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1790229520; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=31rNuj0xFMN1w7BixVucokO40cZ5KdAUF0uRRBIOTuI=;
	b=W/+HJy5TdICy3qIlrUf9T3aBojUjdQjbcIXg4vFRT7ko4E9Y0p6HO8qt/jHgv0huW1G10c
	vJjhQkmXV+kV6PFHm30OL7yVt5CRMe6RR5AkJys0W6m9O0r7kpzL/q7Ofj2jIYvDNl1Z0Q
	0hWyzfJw3Z6O//7IavdQ/Duzp/PMSrk=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8864113A66
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Sep 2026 05:58:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oEOcAwq8tGq3OAAAD6G6ig:T4
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Sep 2026 05:58:39 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 3/3] btrfs: remove __TRANS_* flags
Date: Thu, 24 Sep 2026 15:28:16 +0930
Message-ID: <35418bcbdb67010774673ae2e4c434e0755a9849.1790229298.git.wqu@suse.com>
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
X-Spam-Score: -3.01
X-Rspamd-Queue-Id: C5DC61FF2A
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
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

After patch "btrfs: remove __TRANS_FREEZABLE", each TRANS_* flag is just
the corresponding single-bit __TRANS_* flag.

There is no need to split __TRANS_* and TRANS_* flags, just remove
__TRANS_* flags and use TRANS_* flags instead.

Since every TRANS_* flag is a single bit, do extra cleanups:

- Add an ASSERT() in start_transaction()
  To make sure there is only a single bit set in @type

- Rename TRANS_EXTWRITERS to TRANS_EXTWRITERS_MASK
  To follow the naming scheme that a multi-bit value has the _MASK
  suffix.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/transaction.c | 77 ++++++++++++++++++++----------------------
 1 file changed, 37 insertions(+), 40 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index d73c8723ed70..2532b7b27f9a 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -39,26 +39,20 @@
 static struct kmem_cache *btrfs_trans_handle_cachep;
 
 enum {
-	ENUM_BIT(__TRANS_START),
-	ENUM_BIT(__TRANS_ATTACH),
-	ENUM_BIT(__TRANS_JOIN),
-	ENUM_BIT(__TRANS_JOIN_NOLOCK),
+	ENUM_BIT(TRANS_START),
+	ENUM_BIT(TRANS_ATTACH),
+	ENUM_BIT(TRANS_JOIN),
+	ENUM_BIT(TRANS_JOIN_NOLOCK),
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
-	ENUM_BIT(__TRANS_DUMMY),
+	ENUM_BIT(TRANS_DUMMY),
 #endif
-	ENUM_BIT(__TRANS_JOIN_NOSTART),
+	ENUM_BIT(TRANS_JOIN_NOSTART),
 };
 
-#define TRANS_START		(__TRANS_START)
-#define TRANS_ATTACH		(__TRANS_ATTACH)
-#define TRANS_JOIN		(__TRANS_JOIN)
-#define TRANS_JOIN_NOLOCK	(__TRANS_JOIN_NOLOCK)
-#define TRANS_JOIN_NOSTART	(__TRANS_JOIN_NOSTART)
-
 /* Those types need to hold sb intwrite lock. */
-#define TRANS_SB_INTWRITER_MASK (__TRANS_START | __TRANS_JOIN)
+#define TRANS_SB_INTWRITER_MASK (TRANS_START | TRANS_JOIN)
 
-#define TRANS_EXTWRITERS	(__TRANS_START | __TRANS_ATTACH)
+#define TRANS_EXTWRITERS_MASK	(TRANS_START | TRANS_ATTACH)
 
 /*
  * Transaction states and transitions
@@ -139,32 +133,32 @@ enum {
 static const unsigned int btrfs_blocked_trans_types[TRANS_STATE_MAX] = {
 	[TRANS_STATE_RUNNING]		= 0U,
 	[TRANS_STATE_COMMIT_PREP]	= 0U,
-	[TRANS_STATE_COMMIT_START]	= (__TRANS_START | __TRANS_ATTACH),
-	[TRANS_STATE_COMMIT_DOING]	= (__TRANS_START |
-					   __TRANS_ATTACH |
-					   __TRANS_JOIN |
-					   __TRANS_JOIN_NOSTART),
-	[TRANS_STATE_UNBLOCKED]		= (__TRANS_START |
-					   __TRANS_ATTACH |
-					   __TRANS_JOIN |
-					   __TRANS_JOIN_NOLOCK |
-					   __TRANS_JOIN_NOSTART),
-	[TRANS_STATE_SUPER_COMMITTED]	= (__TRANS_START |
-					   __TRANS_ATTACH |
-					   __TRANS_JOIN |
-					   __TRANS_JOIN_NOLOCK |
-					   __TRANS_JOIN_NOSTART),
-	[TRANS_STATE_COMPLETED]		= (__TRANS_START |
-					   __TRANS_ATTACH |
-					   __TRANS_JOIN |
-					   __TRANS_JOIN_NOLOCK |
-					   __TRANS_JOIN_NOSTART),
+	[TRANS_STATE_COMMIT_START]	= (TRANS_START | TRANS_ATTACH),
+	[TRANS_STATE_COMMIT_DOING]	= (TRANS_START |
+					   TRANS_ATTACH |
+					   TRANS_JOIN |
+					   TRANS_JOIN_NOSTART),
+	[TRANS_STATE_UNBLOCKED]		= (TRANS_START |
+					   TRANS_ATTACH |
+					   TRANS_JOIN |
+					   TRANS_JOIN_NOLOCK |
+					   TRANS_JOIN_NOSTART),
+	[TRANS_STATE_SUPER_COMMITTED]	= (TRANS_START |
+					   TRANS_ATTACH |
+					   TRANS_JOIN |
+					   TRANS_JOIN_NOLOCK |
+					   TRANS_JOIN_NOSTART),
+	[TRANS_STATE_COMPLETED]		= (TRANS_START |
+					   TRANS_ATTACH |
+					   TRANS_JOIN |
+					   TRANS_JOIN_NOLOCK |
+					   TRANS_JOIN_NOSTART),
 };
 
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 bool btrfs_trans_is_dummy(const struct btrfs_trans_handle *trans)
 {
-	return trans->type == __TRANS_DUMMY;
+	return trans->type == TRANS_DUMMY;
 }
 
 void btrfs_init_dummy_trans(struct btrfs_trans_handle *trans,
@@ -172,7 +166,7 @@ void btrfs_init_dummy_trans(struct btrfs_trans_handle *trans,
 {
 	memset(trans, 0, sizeof(*trans));
 	trans->transid = 1;
-	trans->type = __TRANS_DUMMY;
+	trans->type = TRANS_DUMMY;
 	trans->fs_info = fs_info;
 }
 #endif
@@ -261,21 +255,21 @@ static noinline void switch_commit_roots(struct btrfs_trans_handle *trans)
 static inline void extwriter_counter_inc(struct btrfs_transaction *trans,
 					 unsigned int type)
 {
-	if (type & TRANS_EXTWRITERS)
+	if (type & TRANS_EXTWRITERS_MASK)
 		atomic_inc(&trans->num_extwriters);
 }
 
 static inline void extwriter_counter_dec(struct btrfs_transaction *trans,
 					 unsigned int type)
 {
-	if (type & TRANS_EXTWRITERS)
+	if (type & TRANS_EXTWRITERS_MASK)
 		atomic_dec(&trans->num_extwriters);
 }
 
 static inline void extwriter_counter_init(struct btrfs_transaction *trans,
 					  unsigned int type)
 {
-	atomic_set(&trans->num_extwriters, ((type & TRANS_EXTWRITERS) ? 1 : 0));
+	atomic_set(&trans->num_extwriters, ((type & TRANS_EXTWRITERS_MASK) ? 1 : 0));
 }
 
 static inline int extwriter_counter_read(struct btrfs_transaction *trans)
@@ -662,11 +656,14 @@ start_transaction(struct btrfs_root *root, unsigned int num_items,
 	bool do_chunk_alloc = false;
 	int ret;
 
+	/* The type must be a single TRANS_* bit set. */
+	ASSERT(is_power_of_2(type));
+
 	if (unlikely(BTRFS_FS_ERROR(fs_info)))
 		return ERR_PTR(-EROFS);
 
 	if (current->journal_info) {
-		WARN_ON(type & TRANS_EXTWRITERS);
+		WARN_ON(type & TRANS_EXTWRITERS_MASK);
 		h = current->journal_info;
 		refcount_inc(&h->use_count);
 		WARN_ON(refcount_read(&h->use_count) > 2);
-- 
2.55.0

