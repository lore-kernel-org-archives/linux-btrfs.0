Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9C035CB91
	for <linux-btrfs@vger.kernel.org>; Sat, 19 Sep 2026 11:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789816770; cv=none; b=o3rRmM5K6Cw1j/sxZIqREY4uMEKC5vFFxv1oxHBRu/JbqI+qjgrE8Re7oDoCgy5JrD+DPTsRu8skpHmn1zqPVv+56wmsVRlJHdWwYBzdZwGObiCp/0kWpWOaXyyJ4maAUNHyjbmasEuGGWzuVsuOb3TMobXaljp8FrXL+fMMWrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789816770; c=relaxed/simple;
	bh=YbfGCdkicSRUz5Qu7kU9kU6lIY6MDuHtSonYm5M7veM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hbraE8E5lurTnHSmVhnXe+vvQD9bnXimhIrQDtJrvfoKnwq0yEbXLdAgmAUjDuWD7eIwtNnWy3B8BhqR3h5I5sKHn0QIwPwxdYCvAW5SRxKIaR5sDWXSyWSwnbKvCcb5zL7JBA8AZId2c87mnbWE8mIgzKux5dyMUnutj1l6Fjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=foKtX12H; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=HuWxOVe0; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="foKtX12H";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="HuWxOVe0"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E203321E2C
	for <linux-btrfs@vger.kernel.org>; Sat, 19 Sep 2026 11:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789816757; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jyYQ4cvn0oMwRIhEnfm4osSszXyCFHeOqzXA0kgPnGs=;
	b=foKtX12HubAPc03U77KKUU/1fWxV0a/8tkuk0v8aMMRtAcffd5j1EWbojP7i62emyT/dby
	VMWUQvHx9P5RD4dgai2mIHNDUBd6jVt2sZs/R6Vu3RApT1dIho9J2Aby1V/GBqBYPvDvm1
	JyHPuT6iMpdJXMKnha/CfrOt5Vf7+0Q=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789816752; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jyYQ4cvn0oMwRIhEnfm4osSszXyCFHeOqzXA0kgPnGs=;
	b=HuWxOVe0iMrqG7+9pSjDVEdvDrI6eB8NG/Vk5YGG2SWOIYhZilPaz+bjADXntV8w4i48Ba
	rT+LgTpSdfgYOnrhbsDJuaEYEzij/sU4T8eYiUB7m+y0K6ITCR4dFdHfPRbgrKxpcWYmhg
	6ldbTWEQoDN2Q0Kp9OJMvrRssa9TVoI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A086A13886
	for <linux-btrfs@vger.kernel.org>; Sat, 19 Sep 2026 11:19:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fM2AF61vrmrlBAAAD6G6ig:T2
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sat, 19 Sep 2026 11:19:11 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: fix the incorrect lzo space saving checks
Date: Sat, 19 Sep 2026 20:48:50 +0930
Message-ID: <3200353d8e1b92f6783df0824b63b9a7b1298298.1789816636.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1789816636.git.wqu@suse.com>
References: <cover.1789816636.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Score: -2.80
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:mid];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]

[BUG]
Since commit 3be8a788eed3 ("btrfs: lzo: introduce lzo_compress_bio()
helper"), the space saving check on lzo is broken in two ways:

- No compression can be done if the length is smaller than @sectorsize

- If no space is saved, lzo can still create a compressed bio

[CAUSE]
The function copy_compressed_data_to_bio() is doing the space saving
checks wrong:

		/* With the range copied, we're larger than the original range. */
		if (((*total_out + copy_len) >> sectorsize_bits) >=
		    max_out >> sectorsize_bits)

- If the input length is smaller than sectorsize (inlined case)
  Then @max_out >> sectorsize_bits returns 0, the above checks always
  return true and copy_compressed_data_to_bio() always return -E2BIG and
  failed to create an lzo compressed inlined extent.

- If the input length is multiple sectors (regular cases)
  E.g. max_out is 8K, sectorsize is 4K.
  Then we got (*total_out + copy_len) reaching 4K + 1, at this stage we
  should not continue compressing already.

  As the on-disk extent will already be round_up(4K + 1, 4K), reaching
  the original length (8K), thus saving no space.

[FIX]
Pass the full @cb structure into copy_compressed_data_to_bio(), so that
we know exactly the compression range, and know if this is for an
inlined extent.

And split the space saving checks into two parts:

- For inlined cases
  Only return -E2BIG if the compressed size reaches or exceeds the
  original size.

  This is the new check.

- For regular cases
  Only return -E2BIG if the rounded up compressed size reaches or
  exceeds the rounded up original size.

  The original check is only doing rounding down, which can be too late
  already.

  E.g. The current compressed size reaches 4K + 1bytes, and the max_out
  is 8K, at this stage we saves no space and should reject the
  compression.

Finally also skip the padding for inlined extent, as there should only
be one lzo payload, thus no padding is needed.

Fixes: 3be8a788eed3 ("btrfs: lzo: introduce lzo_compress_bio() helper")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/lzo.c | 32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index 2f0996692da0..d0f3498bf6dd 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -154,7 +154,7 @@ static int write_and_queue_folio(struct bio *out_bio, struct folio **out_folio,
 /*
  * Copy compressed data to bio.
  *
- * @out_bio:		The bio that will contain all the compressed data.
+ * @cb:			The compressed bio that will contain all the compressed data.
  * @compressed_data:	The compressed data of this segment.
  * @compressed_size:	The size of the compressed data.
  * @out_folio:		The current output folio, will be updated if a new
@@ -174,16 +174,18 @@ static int write_and_queue_folio(struct bio *out_bio, struct folio **out_folio,
  * Will allocate new pages when needed.
  */
 static int copy_compressed_data_to_bio(struct btrfs_fs_info *fs_info,
-				       struct bio *out_bio,
+				       struct compressed_bio *cb,
 				       const char *compressed_data,
 				       size_t compressed_size,
 				       struct folio **out_folio,
 				       u32 *total_out, u32 max_out)
 {
+	struct bio *out_bio = &cb->bbio.bio;
 	const u32 sectorsize = fs_info->sectorsize;
 	const u32 sectorsize_bits = fs_info->sectorsize_bits;
 	const u32 fsize = btrfs_min_folio_size(fs_info);
 	const u32 old_size = out_bio->bi_iter.bi_size;
+	const bool is_inline = (cb->start == 0 && cb->len <= sectorsize);
 	u32 copy_start;
 	u32 sector_bytes_left;
 	char *kaddr;
@@ -223,9 +225,23 @@ static int copy_compressed_data_to_bio(struct btrfs_fs_info *fs_info,
 				     copy_start + compressed_size - *total_out);
 		u32 foffset = *total_out & (fsize - 1);
 
-		/* With the range copied, we're larger than the original range. */
-		if (((*total_out + copy_len) >> sectorsize_bits) >=
-		    max_out >> sectorsize_bits)
+		/*
+		 * To check if the compressed result really saves space,
+		 * the conditions are different for inline and regular cases.
+		 *
+		 * For regular cases, the rounded up size should not
+		 * reach the rounded up original size. Or we save no space.
+		 *
+		 * For inline cases, the compressed data should not reach the
+		 * original size, no need to consider the extent size since it
+		 * will be inlined.
+		 * If following the regular case condition, no inlined extent
+		 * can be created.
+		 */
+		if (*total_out + copy_len >= max_out && is_inline)
+			return -E2BIG;
+		if (round_up(*total_out + copy_len, sectorsize) >=
+		    round_up(max_out, sectorsize) && !is_inline)
 			return -E2BIG;
 
 		if (!*out_folio) {
@@ -245,9 +261,11 @@ static int copy_compressed_data_to_bio(struct btrfs_fs_info *fs_info,
 	/*
 	 * Check if we can fit the next segment header into the remaining space
 	 * of the sector.
+	 *
+	 * For inlined case no padding needed as there is no next payload.
 	 */
 	sector_bytes_left = round_up(*total_out, sectorsize) - *total_out;
-	if (sector_bytes_left >= LZO_LEN || sector_bytes_left == 0)
+	if (sector_bytes_left >= LZO_LEN || sector_bytes_left == 0 || is_inline)
 		return 0;
 
 	ASSERT(*out_folio);
@@ -316,7 +334,7 @@ int lzo_compress_bio(struct list_head *ws, struct compressed_bio *cb)
 			goto out;
 		}
 
-		ret = copy_compressed_data_to_bio(fs_info, bio, workspace->cbuf, out_len,
+		ret = copy_compressed_data_to_bio(fs_info, cb, workspace->cbuf, out_len,
 						  &folio_out, &total_out, len);
 		if (ret < 0)
 			goto out;
-- 
2.55.0

