Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D4B2CCC5
	for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2026 06:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792392035; cv=none; b=p4etkY/KowpUMXgRKp5Cj2GPnMavQMH9zf3FpLOEWMpv67wlQqMZQKpBj/SB15MDpnWmv0QkZvpVKgyScB0v+z7axAZz359Dy6GnPcmbHUTxLWzaHGiWK9d1In9D9RebMHhw7g0BmqihIOA2B9ep3TJkjJxqS8ykjTpWm93EQ7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792392035; c=relaxed/simple;
	bh=kuqWb+c/6sfbSbpvdAHqY0H7OtBD2eI4rVF1uTeIbSk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M2qDd/gG6z9dgKEASSJ+d9BZTf43SMqnazJ8BlWiIYDtHAI2P2W2+cyiNrextyJRhLNR42TlDxVIYYdf5/viku/+4bksEfLTpPC0cHhhPZr4fYtSv7WDdvCRTbcWyiwZokdz7US0tX1IEGDCI1oraPZ7xBus0DJK2ZkTGK+sPko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=WC5iQHXN; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=WC5iQHXN; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="WC5iQHXN";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="WC5iQHXN"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 147BD1F821
	for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2026 06:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792392032; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kmC/edEMkCoYUfLSm2vCXpfF8gT3YvSU/sgNCvfkWxo=;
	b=WC5iQHXNPaPO6Tu5wRHMHBFjIZMUQPqs68nx4FNtBKHYE/gLn07lgZGjBS2WvqY8+hp0I0
	mFPqdjBkXttb6lncZWcNK3JrXGhaJ7vlle0WGuHsjrkji0hv199XS38T+FME+8+6M0Ksm5
	U9KV+vHMiigXbMH5Q0ejZ9NnkNwtHWk=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=WC5iQHXN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792392032; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kmC/edEMkCoYUfLSm2vCXpfF8gT3YvSU/sgNCvfkWxo=;
	b=WC5iQHXNPaPO6Tu5wRHMHBFjIZMUQPqs68nx4FNtBKHYE/gLn07lgZGjBS2WvqY8+hp0I0
	mFPqdjBkXttb6lncZWcNK3JrXGhaJ7vlle0WGuHsjrkji0hv199XS38T+FME+8+6M0Ksm5
	U9KV+vHMiigXbMH5Q0ejZ9NnkNwtHWk=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 48D6D1375D
	for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2026 06:40:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 09jKA1i71WpsbgAAD6G6ig:T4
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2026 06:40:29 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/9] btrfs: add btrfs_io_context::stripe_len and load it
Date: Mon, 19 Oct 2026 17:09:59 +1030
Message-ID: <2158f68d1a09a4d6c4b828a23c7e690a5a1c87b2.1792391732.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1792391732.git.wqu@suse.com>
References: <cover.1792391732.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spam-Score: -3.01
X-Spam-Flag: NO
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email,suse.com:dkim];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Level: 
X-Rspamd-Queue-Id: 147BD1F821
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org

The new member will be utilized by various path that no direct
btrfs_chunk_map is available, but a stripe length is still required.

The new member is located inside a hole between @refs and @fs_info, so
no size increase for btrfs_io_context.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/volumes.c | 1 +
 fs/btrfs/volumes.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a30b212ef0f1..ff7189ac1c49 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7411,6 +7411,7 @@ int btrfs_map_block(struct btrfs_fs_info *fs_info, enum btrfs_map_op op,
 		ret = -ENOMEM;
 		goto out;
 	}
+	bioc->stripe_len = map->stripe_len;
 	bioc->map_type = map->type;
 	bioc->use_rst = io_geom.use_rst;
 
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 9dcc14cd61e2..9356cec00a90 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -515,6 +515,7 @@ struct btrfs_discard_stripe {
  */
 struct btrfs_io_context {
 	refcount_t refs;
+	u32 stripe_len;
 	struct btrfs_fs_info *fs_info;
 	/* Taken from struct btrfs_chunk_map::type. */
 	u64 map_type;
-- 
2.56.0

