Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33535378D7D
	for <linux-btrfs@vger.kernel.org>; Sun,  5 Jul 2026 11:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783252522; cv=none; b=NLs+I578zq+9DycMJWTiSNZraASAwoHi92T7tFoYwF6R/flQ46rbJVVR6miFGxl8OIL9hZrTQZ4qxRlocE5RcQHICRYing2W7uqw+q33ySdOrefH+/VOQuRqkLejagu8WFAH11LuO5KeEEUAmgDRLYVDh/+1v6vr69gsI1fd1L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783252522; c=relaxed/simple;
	bh=6ORF9l+1dayDThXN6kKckQ6gcol2TZ2IgpAwd+r5Xw0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WIw13YjGp4vuwZNZ3rM2AmiJwW9zSj7IUru31mflGzlVMS4X0o52a9oHhjU+wQZ/O7BqdnFbb2Z10U0xA5ETqjncFYaSSkp8EY+hAhMy2cAdzh+LfRx95AyTGwEhxw/6j9SHn7K+rkJLzMdu2UpO1pYX5cbt9dt2qOHS4kj2snI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=XKl+a60o; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=XKl+a60o; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="XKl+a60o";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="XKl+a60o"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B11FE75A49
	for <linux-btrfs@vger.kernel.org>; Sun,  5 Jul 2026 11:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783252514; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XO5+ybZZVqoVb3/AJKWj+Y7UAaUrYcKQxSPlK8ClpiU=;
	b=XKl+a60oGg0kNewcAOl17UJ54XAy5GgXQcFtS/eNqV72he/RF/f2tHuJlOgpQLRxifI6T8
	7csyXN4JLiturkdYlOfvLkcX00nOlidetpnbaDSV3As1yd0QZUrHBRWDvMObFmovKcZDTG
	9TM4nIHHWyHgPuBj8eJhQ1Pl6PhtxSs=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783252514; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XO5+ybZZVqoVb3/AJKWj+Y7UAaUrYcKQxSPlK8ClpiU=;
	b=XKl+a60oGg0kNewcAOl17UJ54XAy5GgXQcFtS/eNqV72he/RF/f2tHuJlOgpQLRxifI6T8
	7csyXN4JLiturkdYlOfvLkcX00nOlidetpnbaDSV3As1yd0QZUrHBRWDvMObFmovKcZDTG
	9TM4nIHHWyHgPuBj8eJhQ1Pl6PhtxSs=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B8E31779AA
	for <linux-btrfs@vger.kernel.org>; Sun,  5 Jul 2026 11:55:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QA5MGiFGSmqsTgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 05 Jul 2026 11:55:13 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v6 1/4] btrfs: remove SCRUB_MAX_SECTORS_PER_BLOCK
Date: Sun,  5 Jul 2026 21:24:46 +0930
Message-ID: <24d88759a0ad75c151decb7743fae65a6552f3e2.1783252371.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1783252371.git.wqu@suse.com>
References: <cover.1783252371.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 
X-Spam-Score: -2.80

The last user of this macro is removed in commit 001e3fc263ce ("btrfs:
scrub: remove scrub_block and scrub_sector structures").

Now that macro is only utilized in an ASSERT(), which no longer makes
much sense.

Just remove it completely.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/scrub.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index d2f7ac5b6e96..5ec04c91e12d 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -57,12 +57,6 @@ struct scrub_ctx;
 
 #define SCRUB_TOTAL_STRIPES		(SCRUB_GROUPS_PER_SCTX * SCRUB_STRIPES_PER_GROUP)
 
-/*
- * The following value times PAGE_SIZE needs to be large enough to match the
- * largest node/leaf/sector size that shall be supported.
- */
-#define SCRUB_MAX_SECTORS_PER_BLOCK	(BTRFS_MAX_METADATA_BLOCKSIZE / SZ_4K)
-
 /* Represent one sector and its needed info to verify the content. */
 struct scrub_sector_verification {
 	union {
@@ -3091,14 +3085,6 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 	/* At mount time we have ensured nodesize is in the range of [4K, 64K]. */
 	ASSERT(fs_info->nodesize <= BTRFS_STRIPE_LEN);
 
-	/*
-	 * SCRUB_MAX_SECTORS_PER_BLOCK is calculated using the largest possible
-	 * value (max nodesize / min sectorsize), thus nodesize should always
-	 * be fine.
-	 */
-	ASSERT(fs_info->nodesize <=
-	       SCRUB_MAX_SECTORS_PER_BLOCK << fs_info->sectorsize_bits);
-
 	/* Allocate outside of device_list_mutex */
 	sctx = scrub_setup_ctx(fs_info, is_dev_replace);
 	if (IS_ERR(sctx))
-- 
2.54.0

