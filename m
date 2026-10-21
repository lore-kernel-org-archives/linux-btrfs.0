Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792554015;
	b=rhjnFtR5HJmC3q6vETtWYs6g6yITO7H/EjtGCxw85vKcFrFo+O1DCkgVZ1tyxhq1OUFq
	 UrThfcrDONe/saiBAl/notde8D4Qlq2Jb1UoTtq8xA0YDY1i6YSjgWC4oSHOH/CcbbC7h
	 6TxVB+pt8q1VQ5N4CbuAGxbylVDPTMYTcPKnR+npXH41u/RHvcivtf8lNzAUSz4l7RX1l
	 JottfADdCKiPbwJhQkw2kwacXVtKfLsXwZkd0gJ+LgPq0t/9RytRAsMfcpMZbteLzi0/G
	 0LDpGRHblMTVJA5QMzM728S62OvdieN711fLiF4Z7+E1N1x1smNcPoWtlGIhH99UZVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792554015;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spam-Flag:
	 X-Spam-Score:X-Spam-Level:X-Spamd-Result;
	bh=TrToTIQJ14EcVIwmK/B/whRX2i69gap5vUYo4JOOAWI=;
	b=tM6xyIeJ23ziLrlcdv2QfyZlhpRH/cwzQ+vlmIsbzPvtLayQsNROdQV+73EGx4ZbikZX
	 6GuJQ+yiqbiPAzZS8jG+2hzhv+FmKPVrrw5iTWuitUAlNYU2CaIyxgLlz1pyR7zFTSX9h
	 ru988rGDB7ZBUJDFxR0cxoCQmpvgxqCs8MQrDZ4GzZw9Eb+wqMBDw2V3i2x/mFUy1neVz
	 aOUGknyCCewy2dmKqNNGA/2gvc/0gePA+jEaNlQiZ1xVR3s4qpkg3TIFUZHv9syexaUn8
	 McXY56izVVhE4CU/7cox0TiCWGbAU3nFMI8h3fQa/qRyxxRo59NyktV6Re6OqbzNOEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b="nR/GMah7";
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b="nR/GMah7";
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45FC606A324
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 03:40:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B45FC606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=nR/GMah7;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=nR/GMah7
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 16EEC1F7F1;
	Wed, 21 Oct 2026 03:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792554013; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TrToTIQJ14EcVIwmK/B/whRX2i69gap5vUYo4JOOAWI=;
	b=nR/GMah76q8L0MHw+3Z7qk035AFe5HthLTxXFrH3a8h1G8ODQE7SC8wJmRnI1BojXcchF7
	7TCKYvsPXIyZKQz662IQQcLR62YDITjDcAevdR9779liqOCNj0Nb46U7uLNUvtcsBWSQqJ
	gQ3Nx/qI9MG0Jk/dXwZwJoyT2kCMjto=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792554013; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TrToTIQJ14EcVIwmK/B/whRX2i69gap5vUYo4JOOAWI=;
	b=nR/GMah76q8L0MHw+3Z7qk035AFe5HthLTxXFrH3a8h1G8ODQE7SC8wJmRnI1BojXcchF7
	7TCKYvsPXIyZKQz662IQQcLR62YDITjDcAevdR9779liqOCNj0Nb46U7uLNUvtcsBWSQqJ
	gQ3Nx/qI9MG0Jk/dXwZwJoyT2kCMjto=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id ACC9D134A5;
	Wed, 21 Oct 2026 03:40:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4EIhJRU02GpeeQAAD6G6ig:T4
	(envelope-from <wqu@suse.com>); Wed, 21 Oct 2026 03:40:11 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2 3/9] btrfs: add btrfs_io_context::stripe_len and load it
Date: Wed, 21 Oct 2026 14:09:37 +1030
Message-ID: <e779d56649992346db217ff5a452d346b858dd81.1792553748.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1792553748.git.wqu@suse.com>
References: <cover.1792553748.git.wqu@suse.com>
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
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,wdc.com:email];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[wdc.com:email,imap1.dmz-prg2.suse.org:helo,suse.com:email];
	RCVD_TLS_ALL(0.00)[]

The new member will be utilized by various path that no direct
btrfs_chunk_map is available, but a stripe length is still required.

The new member is located inside a hole between @refs and @fs_info, so
no size increase for btrfs_io_context.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
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

