Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792917741;
	b=XhTYIqSUXhyiZLegGn6axlh3jkN5Ce/JLuVi/JReKSP7van8HE9aL2kb6ct9qOBvbYsf
	 4+oKaDFvne5iOWMCGibfJzbIPEVt2TFPB9ivDhBYxONDhETxN54DJS/ktwq/mJE37fPWA
	 B6BwfuRwFcaQOSgM3bzyo/25Q/86Klva+IJcaEcC994f0XEmcsnwrnhWohmy9OJn4ipAJ
	 LhdcDwBYT9qZ5PSIEtQLDX+P3JfFnNh/UqNw139H1v/cvHQStvSVUE34rMZrMOWCdS53m
	 A+GlpC2tYBKRiKbL1fbl29y7m6adW8d4DXI+x/n2uBLSb2IL8JXUVx3shH9eKFjXtjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792917741;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spam-Flag:
	 X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=WF3+qSBQMagbcb1YiguBR5QvrfWpX5ggpSh65S+vVro=;
	b=xtER7N83tlRp++ktiIeanbHFWGYT3b62eT/fmtvSMTRUCwny7UAWUvItWcVrWvYQWYEs
	 n6pv6aclpaegD/OlwS4JK/tnBjs5V0orSUbwOe+didZHlPSAhsKhd4awmhPnchNxV7Ill
	 u+3asjxyfVuc/mFv0cKy/qW37xBTrt7j6ohsnMsHvNZ/EJCVoPZ/pJKMolGQdztOZdXA5
	 +C2cEZ+p6zmYtLLDYYrz3VQPLhlwap6nGhL555u6A6KONqmZfqM0TKleYS7EtiiMUCoSK
	 rawRQHJXQ82T6ST8f5wFBIwtxnQ3CIKzWQwb1njR/MpKYtHKuP/dZIm0lrcqvAMi4sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=o0P7o2w2;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=o0P7o2w2;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD31606A31D
	for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 08:42:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BDD31606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=o0P7o2w2;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=o0P7o2w2
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 58DB81F38A
	for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 08:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792917739; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WF3+qSBQMagbcb1YiguBR5QvrfWpX5ggpSh65S+vVro=;
	b=o0P7o2w2o9Uo+c64VyFOKOyh7sPP1oM996+3LyfAgbfEtIZKeBN0BwSFAoTuzT8w4cXwI0
	Vwy4+ZDMZbfhhj+lognxlkMVxrPzQruqb/rK7GeKMU3kaTZ924A07/famsMklbbyOzf/8Z
	kKhsYA2ll5DREXGB+lhTsjCdyFvf7n8=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792917739; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WF3+qSBQMagbcb1YiguBR5QvrfWpX5ggpSh65S+vVro=;
	b=o0P7o2w2o9Uo+c64VyFOKOyh7sPP1oM996+3LyfAgbfEtIZKeBN0BwSFAoTuzT8w4cXwI0
	Vwy4+ZDMZbfhhj+lognxlkMVxrPzQruqb/rK7GeKMU3kaTZ924A07/famsMklbbyOzf/8Z
	kKhsYA2ll5DREXGB+lhTsjCdyFvf7n8=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 42C2513314
	for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 08:42:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mglvH9zA3Wq5HgAAD6G6ig:T9
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 08:42:17 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 08/12] btrfs-progs: image: fix memory leak on async_work for restore
Date: Sun, 25 Oct 2026 19:11:42 +1030
Message-ID: <2a998fd5915cf07ab96e28b5421264add8210c87.1792914402.git.wqu@suse.com>
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

There are two paths to leak the async_work memory, fix them by:

- restore_one_work() failure inside restore_worker()
  Manually release memory before jumping to out label.

- all restore_worker() failed to process any async_work
  Those async_work will stay inside mdres->list until the end of the
  program.

  Fix them by manually drain the mdres->list.

Assisted-by: LLM (exposing the bug)
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 image/image-restore.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/image/image-restore.c b/image/image-restore.c
index 2e4c19746cfb..4929beeb697e 100644
--- a/image/image-restore.c
+++ b/image/image-restore.c
@@ -61,6 +61,14 @@ static void mdrestore_destroy(struct mdrestore_struct *mdres, int num_threads)
 	pthread_cond_destroy(&mdres->cond);
 	pthread_mutex_destroy(&mdres->mutex);
 
+	while (!list_empty(&mdres->list)) {
+		struct async_work *async = list_first_entry(&mdres->list,
+						struct async_work, list);
+
+		list_del_init(&async->list);
+		free(async->buffer);
+		free(async);
+	}
 	while ((n = rb_first(&mdres->chunk_tree))) {
 		struct fs_chunk *entry;
 
@@ -590,6 +598,8 @@ static void *restore_worker(void *data)
 		if (ret < 0) {
 			mdres->error = ret;
 			pthread_mutex_unlock(&mdres->mutex);
+			free(async->buffer);
+			free(async);
 			goto out;
 		}
 		mdres->num_items--;
-- 
2.56.0

