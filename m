Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ABDB31B80D
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Jun 2026 08:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781859315; cv=none; b=OKasTqHymqXs3qa+JK9NRvvPhDgixCiVHj7nJaKxZYTOUMICL9/zag4W1wNfiOjOaNQ4SmTxv1UlY4N5yl6Xx2gIX/IZGN4MBBQqu9k3WezXxf47nUgm0C3651F3qEKXfPc5XXCw2F0GBZ9LoDf0b1BMEdESqn8aJedjqZ78quE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781859315; c=relaxed/simple;
	bh=LH6nqrRo5auPvn8oolcMfR7tvR7HMPrWTDbLUX857f4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PxDKFBjT9rPnvwD3JeypGBCBRKFHsKwxreilhcPP1YcxcWgZL4qVGfCjO8lgrpeF49KyNlqmY7xSYKFrtMT+d5txwV2qBM1q3jA3OZehztQi6TYtjgKjHk8w5knEV/VpYnWFhHE0ANH8BZpz7J6auQh4eoO/xopww7voIpFLKpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=i8zkho6K; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=i8zkho6K; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="i8zkho6K";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="i8zkho6K"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6CFE56D173
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Jun 2026 08:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781859312; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=beRPAE0T2GPnnkDx0gibKm5DGM5qXVYKzZX2or2bUyI=;
	b=i8zkho6K74KMlAFE3Ruig0zf5RtNhLPne2oJjW+hLe5su6PVWC0kpBiFS876c8Gos1nKtw
	uIA3TaxkOKgONk29EPIJr6Ga98KmJxxqC80sDyt/qs0OzvV3LC9K/yHbGCgGRedVWeuqrU
	/9PjF79U0zzJwrG/vEfok6QD++7+0zs=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781859312; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=beRPAE0T2GPnnkDx0gibKm5DGM5qXVYKzZX2or2bUyI=;
	b=i8zkho6K74KMlAFE3Ruig0zf5RtNhLPne2oJjW+hLe5su6PVWC0kpBiFS876c8Gos1nKtw
	uIA3TaxkOKgONk29EPIJr6Ga98KmJxxqC80sDyt/qs0OzvV3LC9K/yHbGCgGRedVWeuqrU
	/9PjF79U0zzJwrG/vEfok6QD++7+0zs=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6D0B8779AB
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Jun 2026 08:55:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eOMVB+8DNWrBTwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Jun 2026 08:55:11 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: remove the out-of-date comments on the 2K block size
Date: Fri, 19 Jun 2026 18:24:46 +0930
Message-ID: <b6fc790b78bc5147aa67de3850ced872eebff5d1.1781859111.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1781859111.git.wqu@suse.com>
References: <cover.1781859111.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 

Since commit bac3c2910c0c ("btrfs: remove 2K block size support") there
is no 2K block size support inside btrfs anymore.

Remove the stale comments of btrfS_supported_blocksize().

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/fs.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/btrfs/fs.c b/fs/btrfs/fs.c
index 14d83565cdee..907c8837a639 100644
--- a/fs/btrfs/fs.c
+++ b/fs/btrfs/fs.c
@@ -135,12 +135,6 @@ void btrfs_csum_final(struct btrfs_csum_ctx *ctx, u8 *out)
  *
  * - PAGE_SIZE
  *   The straightforward block size to support.
- *
- * And extra support for the following block sizes based on the kernel config:
- *
- * - MIN_BLOCKSIZE
- *   This is either 4K (regular builds) or 2K (debug builds)
- *   This allows testing subpage routines on x86_64.
  */
 bool __attribute_const__ btrfs_supported_blocksize(u32 blocksize)
 {
-- 
2.54.0

