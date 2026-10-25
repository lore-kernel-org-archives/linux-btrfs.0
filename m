Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792917738;
	b=O2vJ/d1DbPA5jX7ba5fe8/YEBumXwPPruQUl5fA2zPU0jqP3EOGn/b171ltUTCBzF+CX
	 deI7g8kfsbBOdIvU9axXTLIK7afhNCevzRJcIqin7BxKCbBroRZKmpRr11XdUQv0p+itz
	 27k09pjvR/PUAL7HK3YioLVnelkATYY3F1gBGDGAfQDb/dHY/Os+YHewGXQH+V68OLjUo
	 L8d8jk2LJrHa0iwHiWWZPxOESW3HhKjzKCcLGVWdnEaZKevut9dHcmcmoQVXVKwdP8mWU
	 rQ4NuAPjiGV2HtZXQsXrukVTvLPVDL9Elao/+g7ioiZFv7+sfRTj734RIqau/hcgbGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792917738;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spam-Flag:
	 X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=21JbaW0plvSzHzPFHobmz4mcLEGjneQKi1RA7ockKLg=;
	b=EGsWRY6aJ0Di48N6YKda1/A1R/M7TO5eadnjhOdXMlnvTXGvBvoF06+ddfQ2OmJmsGzN
	 VO9LRrQpi0rNOyKcmcJeJH4gDs4J8b4UNRloxK3Zj9ha7zDVm4diW5ebgOucksJJOoufn
	 obUm1em9KbryMMgdZLdowiAHGW9ayjLC3vhcEsURCwzjBRjV9WokyiaKHDHSLVsse5Cxd
	 j1L9FT3bAT42Hv+5HxGUBY6ALkOxBcfzbyB29pkLw9VRiCL40sv6SNTWnTF3XGQdRFApB
	 zZIy5tsLdaT/WcV/LxhOUM6L715z9RC0nNHfuf1hBVgXsYuxOfW+XYJeAbhiTHzpAgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=M+sqRUeI;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=M+sqRUeI;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5FA606A31B
	for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 08:42:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4D5FA606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=M+sqRUeI;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=M+sqRUeI
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3032222252
	for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 08:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792917731; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=21JbaW0plvSzHzPFHobmz4mcLEGjneQKi1RA7ockKLg=;
	b=M+sqRUeI+iPTyAz9xgD3SntVVhVcjCKKTuCNv4sMNfxkBb+qxjobxwxEa8P8CqhODys68G
	ZQxLqcWVl4UusDSq0UjPmlSxHCs4/zjR0UQzer2//0iE5SBP/Z4db4jLJQvRNtZ0W2rDXZ
	rcf1CMPJY5m0GfupD0QplwKOJUHDDc0=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792917731; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=21JbaW0plvSzHzPFHobmz4mcLEGjneQKi1RA7ockKLg=;
	b=M+sqRUeI+iPTyAz9xgD3SntVVhVcjCKKTuCNv4sMNfxkBb+qxjobxwxEa8P8CqhODys68G
	ZQxLqcWVl4UusDSq0UjPmlSxHCs4/zjR0UQzer2//0iE5SBP/Z4db4jLJQvRNtZ0W2rDXZ
	rcf1CMPJY5m0GfupD0QplwKOJUHDDc0=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1A40513314
	for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 08:42:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mglvH9zA3Wq5HgAAD6G6ig:T4
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 08:42:09 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 03/12] btrfs-progs: image: cleanup pending ordered works after an error
Date: Sun, 25 Oct 2026 19:11:37 +1030
Message-ID: <1202db51c06ca03ae6b5cca57177a7adc36753bc.1792914402.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1792914402.git.wqu@suse.com>
References: <cover.1792914402.git.wqu@suse.com>
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
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80

The function flush_pending() can queue at most ITEMS_PER_CLUSTER
async_works before submitting them to write_buffers().

But if we hit an critical error, e.g. read_tree_block() hit a bad tree
block, and there is already pending async_works, we rely on the last
flush_pending() call inside create_metadump() to do the cleanup.

However that final flush_pending() will hit the same corrupted tree
block and fail halfway, without really dispatch the existing async
works.

Fix the problem by:

- Avoid calling the final flush_pending() if we had already hit an error

- Manually cleanup any pending async works inside metadump_destroy()

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 image/image-create.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/image/image-create.c b/image/image-create.c
index d172fcd3897a..1fd288d2b566 100644
--- a/image/image-create.c
+++ b/image/image-create.c
@@ -124,6 +124,14 @@ static void metadump_destroy(struct metadump_struct *md, int num_threads)
 	pthread_cond_destroy(&md->cond);
 	pthread_mutex_destroy(&md->mutex);
 
+	while (!list_empty(&md->ordered)) {
+		struct async_work *async = list_first_entry(&md->ordered,
+				struct async_work, ordered);
+
+		list_del_init(&async->ordered);
+		free(async->buffer);
+		free(async);
+	}
 	while ((n = rb_first(&md->name_tree))) {
 		struct name *name;
 
@@ -828,13 +836,14 @@ int create_metadump(const char *input, FILE *out, int num_threads,
 
 	ret = copy_space_cache(root, &metadump, &path);
 out:
-	ret = flush_pending(&metadump, 1);
-	if (ret) {
-		if (!err)
-			err = ret;
-		error("failed to flush pending data: %d", ret);
+	if (!ret) {
+		ret = flush_pending(&metadump, 1);
+		if (ret)
+			error("failed to flush pending data: %d", ret);
 	}
 
+	if (ret && !err)
+		err = ret;
 	metadump_destroy(&metadump, num_threads);
 
 	btrfs_release_path(&path);
-- 
2.56.0

