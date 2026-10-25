Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792917731;
	b=HJjPGo3ah7WrWkobBN8g0KYcKg3MsU0y74Bv/9vnqE43ay/5Z7fEvMTycMNPyPVEgOqV
	 4ZHdgTKl8vLS9pmbGHeqBpv7OaEYDPhHGuNovYsA9CxmILYjrmWSexlhZp63ZExV4vyB3
	 aaifAACCT+nW0pFFK64ANvsSw4q3LQZbanDllHIUIz1Ke0YAb16Zt2W8ltAAILXUNumw8
	 FasogtbBbA4P+BKNwS2g1tegG0RwOyL3UfaJTghi78X9Vr7IG4WX+YPB0NQsE7SGVxzDs
	 UKClTilzyiEDc4MYR8PKzD2gdPj7Vldt/C3EXziiw9fMtT38wnoQoADKzk6JpvGExfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792917731;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Rspamd-Queue-Id:
	 X-Spam-Level:X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:
	 X-Spamd-Result:X-Spam-Score;
	bh=FtB3YxppGaOaSRjAiJOAFCDrJym39oUXUE1SSVeiHd0=;
	b=atL5LXv14dbhXlVQ8yegxwbc1PNTowxgTVxii6bFQ/jA6NK/WLEzdaAIUevnLN65VC1X
	 LCeqiJ5I1hE1V9oEt6cWqBXovtERme681vZG45/nF7G/zDkMWOMJkhIc6xjgx+etiuHnA
	 Y42kD6CjnpJXucYEtU2jZpoBzJjXvnLICR9//Itoottnf/SvP5xv+x6fIqpyNAGT0ZvMd
	 PNASOI5sf/n1eVReQSK5nbB6zf+RBI7BExzRvbMdJPCkiWL4yeMO1vToQmQiMbDt7O+q5
	 EwRpuMi4Zdi/saXcW4AMKLTb9TC9wob1AuRjHrtNRPJZmVyYuM2BibjBad+OxO/8rmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=gwlRAcj6;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=YlaLh4Xv;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D424B606A322
	for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 08:42:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D424B606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=gwlRAcj6;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=YlaLh4Xv
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E27ED1F390
	for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 08:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792917729; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FtB3YxppGaOaSRjAiJOAFCDrJym39oUXUE1SSVeiHd0=;
	b=gwlRAcj6Jp7Wl/rQiPcqLHwJXiii4xmWwWkZS1dwEBqMpNnZgq6to3XUVEijzfKuyUgjAx
	QmzrhTt2GYjHiL6fIzW+rMKxHmrWOIdrbipTf8vSMgELLa6ynJPsKD+mD44CEQL4F5G5JQ
	WBbRQGUXgrfue4lttoJl0j95Kc2xLbI=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=YlaLh4Xv
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792917727; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FtB3YxppGaOaSRjAiJOAFCDrJym39oUXUE1SSVeiHd0=;
	b=YlaLh4Xv2B/QpUhoQl/Jz9mYOylpBbhrZuHphG7G0RhhjCbUEEb5dv89jT+n23MJRGUh75
	5QTq8tD3arOwZN8U3vVaeTOggea1mg1lruN/9WYKgUjO6Oo/NFCb5jJDxvU92ipB1tw6di
	M/AOH4Nzo04INNbDvwIfEJKeJvFim4Y=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CC891134EA
	for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 08:42:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mglvH9zA3Wq5HgAAD6G6ig:T2
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 08:42:06 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 01/12] btrfs-progs: image: destroy chunk tree after all pthreads finished
Date: Sun, 25 Oct 2026 19:11:35 +1030
Message-ID: <4b8e6bbe34e4f708e399e33f02810524deb77145.1792914402.git.wqu@suse.com>
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
X-Rspamd-Queue-Id: E27ED1F390
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-12.01 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FROM_HAS_DN(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim,suse.com:email]
X-Spam-Score: -12.01

In the function mdrestore_destroy(), the chunk tree is destroyed before
all the pthreads finished.

This can lead to use-after-free problems for the chunk tree.

Fix it by waiting for all pthreads before destroy the chunk tree.

Since we're here, also fix the mdrestore_destroy() call inside
mdrestore_init() where if an error happened, we wait for a thread that
failed to be created.

Assisted-by: LLM (exposing the bug)
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 image/image-restore.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/image/image-restore.c b/image/image-restore.c
index 125ac06f339b..9bc11ea5e7d9 100644
--- a/image/image-restore.c
+++ b/image/image-restore.c
@@ -50,15 +50,6 @@ static void mdrestore_destroy(struct mdrestore_struct *mdres, int num_threads)
 	struct rb_node *n;
 	int i;
 
-	while ((n = rb_first(&mdres->chunk_tree))) {
-		struct fs_chunk *entry;
-
-		entry = rb_entry(n, struct fs_chunk, l);
-		rb_erase(n, &mdres->chunk_tree);
-		rb_erase(&entry->p, &mdres->physical_tree);
-		free(entry);
-	}
-	free_extent_cache_tree(&mdres->sys_chunks);
 	pthread_mutex_lock(&mdres->mutex);
 	mdres->done = 1;
 	pthread_cond_broadcast(&mdres->cond);
@@ -69,6 +60,16 @@ static void mdrestore_destroy(struct mdrestore_struct *mdres, int num_threads)
 
 	pthread_cond_destroy(&mdres->cond);
 	pthread_mutex_destroy(&mdres->mutex);
+
+	while ((n = rb_first(&mdres->chunk_tree))) {
+		struct fs_chunk *entry;
+
+		entry = rb_entry(n, struct fs_chunk, l);
+		rb_erase(n, &mdres->chunk_tree);
+		rb_erase(&entry->p, &mdres->physical_tree);
+		free(entry);
+	}
+	free_extent_cache_tree(&mdres->sys_chunks);
 	free(mdres->original_super);
 }
 
@@ -646,7 +647,7 @@ static int mdrestore_init(struct mdrestore_struct *mdres,
 		}
 	}
 	if (ret)
-		mdrestore_destroy(mdres, i + 1);
+		mdrestore_destroy(mdres, i);
 	return ret;
 }
 
-- 
2.56.0

