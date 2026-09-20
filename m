Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDDFE486B85
	for <linux-btrfs@vger.kernel.org>; Sun, 20 Sep 2026 22:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789944683; cv=none; b=X4GRFOgF8UNSdGw8OGBwYwEMELQrJybV2qNnZPXFS/CuZpIxkzlFpHTX+LRc4O+QOtxn+kWwAMzL5mI2a5cdzy0/SkipQJw8+sM6tpvjbbXqoNxHGqqjaU8jHdvkSy02kHgbaHHiUZntm69r+AjmC6ipXonIQrXYYg4MR/ja5pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789944683; c=relaxed/simple;
	bh=2QkhCNCHb2QZJVubyd1CRm4TgntDt/afNIvFKByChLA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=knlTgfOXdnRvEY+eCEqABcBBlj1DIol9v4fF2GMBkEHAXo7Jo+GkKFkrPOLdTTDrwBHQ9UHQq5hJccveLPboV7EkArlyJOL/y4ZHiuaZMLmgD/0ceTVs2rlwdCbS4RkHOH/sKNK+5yZbgsxWul5Tv+HzSefx3TVa4SF+y5zBj0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=GmaLwT2S; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=iPzgQ/Ar; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="GmaLwT2S";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="iPzgQ/Ar"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8ABC121BFC
	for <linux-btrfs@vger.kernel.org>; Sun, 20 Sep 2026 22:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789944669; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7gJADVzM9UlIxx590PZ9Pzgts2JMVR2Xck33nzOhYpM=;
	b=GmaLwT2SMh209TNucpo6fACxkoCD2sVmL8O+CwN6dJCOob5oviTzDMyLsf/2SI5lfopr4S
	jNXBIaYqlTXnaOUzC0SXTPJjB6AZaUfGKpYslAcb6Wz3vSwUdQniJH7o+90f1siKrQHEQl
	qN/yJc2qLYZzOlS7NxtCyiOrw/RFxG8=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="iPzgQ/Ar"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789944665; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7gJADVzM9UlIxx590PZ9Pzgts2JMVR2Xck33nzOhYpM=;
	b=iPzgQ/Ar6U/fiaK9Z830kv2A7C6NlFe61VlnDcJTukljS2ZhyRWtxNF9tpe76OViL1LiQ/
	+X6iMZ+K64Q+F5Fu013htE4IjSTkmAUi9w1IRChgnLnumdzz2W/r1opEkE0H1iUOje7bNa
	uKy5rMowHbfVd10THJJud+tKHHyy5to=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 51163139C3
	for <linux-btrfs@vger.kernel.org>; Sun, 20 Sep 2026 22:51:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id imMtBFZjsGphXAAAD6G6ig:T2
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 20 Sep 2026 22:51:04 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 1/2] btrfs: lzo: fix space saving checks
Date: Mon, 21 Sep 2026 08:20:43 +0930
Message-ID: <b3dc8e992c34424ce992a42c8fc48ba7ef27abbd.1789944508.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1789944508.git.wqu@suse.com>
References: <cover.1789944508.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -3.01
X-Rspamd-Queue-Id: 8ABC121BFC
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
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
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

[BUG]
Since commit 3be8a788eed3 ("btrfs: lzo: introduce lzo_compress_bio()
helper"), the space saving check on lzo is broken:

- Space saving check is always done based on block size
  This prevents lzo_compress_bio() to do any compression if the @len is
  smaller than sectorsize.

  This prevents proper inlined extent creation.

- Space saving check is not including the padding zeros
  If the remaining space in the output folio is not enough, we add
  padding zeros (up to 3 bytes), which contributes to the total
  compressed size.

  But that is not checked.

[CAUSE]

The function copy_compressed_data_to_bio() is doing the space saving
check wrong:

		/* With the range copied, we're larger than the original range. */
		if (((*total_out + copy_len) >> sectorsize_bits) >=
		    max_out >> sectorsize_bits)

- If the input length is smaller than sectorsize (inlined case)
  Then @max_out >> sectorsize_bits returns 0, the above check always
  returns true and copy_compressed_data_to_bio() always return -E2BIG and
  failed to create an lzo compressed inlined extent.

This check is LZO specific, as other algorithms do not have any block
aligned check during compression.
The remaining two algorithms are all relying on regular input/output
size check, and the final common space saving check at
compress_file_extent().

And for the extra padding bytes, there is no space saving check at all.

[FIX]
- Do a simpler space saving check
  By just check if the compressed size meets or exceeds the input size.
  If so reject it with -E2BIG.

  With this fixed, lzo_compress_bio() can properly handle a range that is
  smaller than a sector, which is required to get better compression ratio
  for inlined extents.

- Do space saving check before padding
  This will ensure that the compressed size never meets or exceeds the
  input size.

Fixes: 3be8a788eed3 ("btrfs: lzo: introduce lzo_compress_bio() helper")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/lzo.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index 2f0996692da0..4e7837dec332 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -224,8 +224,7 @@ static int copy_compressed_data_to_bio(struct btrfs_fs_info *fs_info,
 		u32 foffset = *total_out & (fsize - 1);
 
 		/* With the range copied, we're larger than the original range. */
-		if (((*total_out + copy_len) >> sectorsize_bits) >=
-		    max_out >> sectorsize_bits)
+		if (*total_out + copy_len >= max_out)
 			return -E2BIG;
 
 		if (!*out_folio) {
@@ -253,6 +252,8 @@ static int copy_compressed_data_to_bio(struct btrfs_fs_info *fs_info,
 	ASSERT(*out_folio);
 
 	/* The remaining size is not enough, pad it with zeros */
+	if (*total_out + sector_bytes_left >= max_out)
+		return -E2BIG;
 	folio_zero_range(*out_folio, offset_in_folio(*out_folio, *total_out), sector_bytes_left);
 	return write_and_queue_folio(out_bio, out_folio, total_out, sector_bytes_left);
 }
-- 
2.55.0

