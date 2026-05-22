Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290393BFAD1
	for <linux-btrfs@vger.kernel.org>; Fri, 22 May 2026 09:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779441861; cv=none; b=QoFONsTLPH8bmIlOIYBA8pQOqKsc24iOC22PkoCDmdjP1BgLuZvSGpmpPZT8DueZIiGXvqvfpdWTRMjOmhG3au2erCcuf8cLxc6kipjAo3vIMrfo0hUjw89c0ZiRGyRim2J/Da7qXknu5sgDX6L6NTX6xisVMWK4MhmpXVRBwR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779441861; c=relaxed/simple;
	bh=61caWS1JyRnDpv4/CMS6g4H+TZpxP+Odd77kH6vXZ/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fs0hzRuHu52iTSipqgXsBt8tMhECN+alX8Q5NULY1vNAbv19YWyyiA8bVXrRtbZpDtA4gZWJjxz6rb7ujVlr3NKAf+i4PR7ek7TlFCA0m6PozFQavErfzq7oo5SnYGAB7+qztOA+q14byHq4SPk/v5aw4YJV4E2Yk/PxFeYSBNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=SrUtKOr4; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=SrUtKOr4; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="SrUtKOr4";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="SrUtKOr4"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1BCD767A97;
	Fri, 22 May 2026 09:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779441854; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=81EwkzaTtWevC3VYypU83dFd/mgM/y9vse9a5T69jOI=;
	b=SrUtKOr4BzLBadj9PN25/pEc8E2JZl70EZKekgqbU3bpy+PXS79vsJrpPtNI3zQcHi5w2E
	8XSIoUuoHR9Hegu8HlgxF8iCt3AODZJLjgV9RDTR89MR0MtyEZzeHYWb7jdALytEphGMc5
	1kbFzp4BjHXwf56oVIuH/4KpBqNRka0=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=SrUtKOr4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779441854; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=81EwkzaTtWevC3VYypU83dFd/mgM/y9vse9a5T69jOI=;
	b=SrUtKOr4BzLBadj9PN25/pEc8E2JZl70EZKekgqbU3bpy+PXS79vsJrpPtNI3zQcHi5w2E
	8XSIoUuoHR9Hegu8HlgxF8iCt3AODZJLjgV9RDTR89MR0MtyEZzeHYWb7jdALytEphGMc5
	1kbFzp4BjHXwf56oVIuH/4KpBqNRka0=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DA049593A8;
	Fri, 22 May 2026 09:24:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AALmJrwgEGoXQgAAD6G6ig
	(envelope-from <wqu@suse.com>); Fri, 22 May 2026 09:24:12 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: hch@lst.de,
	linux-raid@vger.kernel.org
Subject: [PATCH 1/3] btrfs: remove btrfs_chunk_map::io_(align|width) members
Date: Fri, 22 May 2026 18:53:51 +0930
Message-ID: <c8b0e9c0006c14c47246a5a2291c531d8ce220ab.1779412152.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1779412152.git.wqu@suse.com>
References: <cover.1779412152.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 1BCD767A97
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
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	TO_DN_NONE(0.00)[];
	internal_greylist_whitelist(0.00)[2a07:de40:b281:104:10:150:64:97];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:mid,suse.com:dkim]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

Those two members are read from on-disk metadata, but never utilized.
And for new chunks we always set those members to BTRFS_STRIPE_LEN
anyway.

Thus there is no need to keep them inside btrfs_chunk_map.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/volumes.c | 4 ----
 fs/btrfs/volumes.h | 2 --
 2 files changed, 6 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 93a923e4ecaf..daa8f1ddf713 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6019,8 +6019,6 @@ static struct btrfs_block_group *create_chunk(struct btrfs_trans_handle *trans,
 	map->chunk_len = ctl->chunk_size;
 	map->stripe_size = ctl->stripe_size;
 	map->type = type;
-	map->io_align = BTRFS_STRIPE_LEN;
-	map->io_width = BTRFS_STRIPE_LEN;
 	map->sub_stripes = ctl->sub_stripes;
 	map->num_stripes = ctl->num_stripes;
 
@@ -7583,8 +7581,6 @@ static int read_one_chunk(struct btrfs_key *key, struct extent_buffer *leaf,
 	map->start = logical;
 	map->chunk_len = length;
 	map->num_stripes = num_stripes;
-	map->io_width = btrfs_chunk_io_width(leaf, chunk);
-	map->io_align = btrfs_chunk_io_align(leaf, chunk);
 	map->type = type;
 	/*
 	 * We can't use the sub_stripes value, as for profiles other than
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 96904d18f686..f24385b599dc 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -633,8 +633,6 @@ struct btrfs_chunk_map {
 	u64 chunk_len;
 	u64 stripe_size;
 	u64 type;
-	int io_align;
-	int io_width;
 	int num_stripes;
 	int sub_stripes;
 	struct btrfs_io_stripe stripes[];
-- 
2.54.0

