Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 563BD3932C0
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Jun 2026 08:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782807861; cv=none; b=qeFbLYULQSo5xcgS075aFoEeAXhuBMfCTgshXdgQLxpJhwSV+AVXx7Yl5GtInKz/S2S0T7lKnyMbdzxEH28ke0OcOc8PbzlVeLNTSYum8BV/He0Nl41Hok2Uw11mMGNGlZxe4fAaf16lMTDF/7hu/mir6N8ihMGqPkrX4sAJwak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782807861; c=relaxed/simple;
	bh=6ORF9l+1dayDThXN6kKckQ6gcol2TZ2IgpAwd+r5Xw0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dASAlkV6QepHae7fT1wWwjo3Oeo/SirQYrjw0ix1xNsV1oK+nnc4hpFgk1oFfku+Numke8Bd4w4QJ0i3QH6Wch4X0Bf9S/FC0gayzPRzVdTq5hzRr9Tt7bCk+uOrkGbB+PpFmuNcvOLLeWzYzQg3eZUZIsq+VqbgQWL3hft4cig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=TeHo6Gst; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=TeHo6Gst; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="TeHo6Gst";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="TeHo6Gst"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6631075886
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Jun 2026 08:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1782807853; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XO5+ybZZVqoVb3/AJKWj+Y7UAaUrYcKQxSPlK8ClpiU=;
	b=TeHo6GstTkvFHFXjQZlEY09VXLgKOnlmoXQlBCb6SoeCAacyAhwwcEiQ+XeV/eqEgRIJpB
	gC43VnDte3HUAAqa34A1TMHMLQEiLIjL/ibGmjQLcJ7G8hZi8BZn+vibcCCM2ydIUoOV+l
	sZgGIVznTE3TLRmtqRRIq+vH3NFRHds=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1782807853; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XO5+ybZZVqoVb3/AJKWj+Y7UAaUrYcKQxSPlK8ClpiU=;
	b=TeHo6GstTkvFHFXjQZlEY09VXLgKOnlmoXQlBCb6SoeCAacyAhwwcEiQ+XeV/eqEgRIJpB
	gC43VnDte3HUAAqa34A1TMHMLQEiLIjL/ibGmjQLcJ7G8hZi8BZn+vibcCCM2ydIUoOV+l
	sZgGIVznTE3TLRmtqRRIq+vH3NFRHds=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 69C4A779A8
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Jun 2026 08:24:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oFmgBix9Q2oBEAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Jun 2026 08:24:12 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v4 1/3] btrfs: remove SCRUB_MAX_SECTORS_PER_BLOCK
Date: Tue, 30 Jun 2026 17:53:49 +0930
Message-ID: <04c42fe35460477ebfa619dc8d37a7d83c6d5f96.1782795330.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782795330.git.wqu@suse.com>
References: <cover.1782795330.git.wqu@suse.com>
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
	TO_DN_NONE(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo]
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

