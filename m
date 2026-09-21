Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644722222A9
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Sep 2026 00:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789951502; cv=none; b=uQu83S/fdUAkIAKstmzmT9x4gGfFvOXG1vlgkOdp47kh5twMb1L2h9BlKKGOXVnY/M+DzXEdFrjlGkvHGjKsoNjtbqpZWqIDoTReF2D2mdmWoJhigrgbxP5jdTXXaLIdnXII4i8qQ2d18Z53Vkdx5WUDtnACtbeQTjJuDJZjuVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789951502; c=relaxed/simple;
	bh=r8+QAu2CmMUJCpa6Ztad7LsD4D32siq0GLhNt84tfSY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gYZgYaIjf/aMrz6dGc31b9fjlco34nD1FBmi+534SIaeUwmyUXIGqhXBQuOn1itPWGK+5oNDikHblcnSprEzuU6axDZekeIMX168+Yp2n+4uh2QHkg4Xi6tCdrdCjT/EUbrAghg8hUHZ4z0KDmsjeYr65cnL+oEUq7KdvpewDF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Ofz15oz6; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Ofz15oz6; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Ofz15oz6";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Ofz15oz6"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 51EB4219BF
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Sep 2026 00:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789951499; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fi8OFFoT2TcpxoJZuFGLSLV7HPrx/GU5VTnMGE1ctz0=;
	b=Ofz15oz6zh3AH0b8jhSYzy6TkCELwY/hN5+kn0UWTQ6D9dQpjTKjZNH0PVy7FLDZZqSJo1
	V4v2aMO7+O+OKw0ptWB+rhTzaoNmrf8IY8QcpYc/iKTYuHvrHhnewynaNXHFeYx2A2lQ58
	02rgk8MLvvVnKB4C09Nke7AIXKoA0rs=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=Ofz15oz6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789951499; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fi8OFFoT2TcpxoJZuFGLSLV7HPrx/GU5VTnMGE1ctz0=;
	b=Ofz15oz6zh3AH0b8jhSYzy6TkCELwY/hN5+kn0UWTQ6D9dQpjTKjZNH0PVy7FLDZZqSJo1
	V4v2aMO7+O+OKw0ptWB+rhTzaoNmrf8IY8QcpYc/iKTYuHvrHhnewynaNXHFeYx2A2lQ58
	02rgk8MLvvVnKB4C09Nke7AIXKoA0rs=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3C52213793
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Sep 2026 00:44:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id m/o+Ogd+sGqATwAAD6G6ig:T2
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Sep 2026 00:44:57 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 1/2] btrfs: lzo: fix space saving checks
Date: Mon, 21 Sep 2026 10:14:33 +0930
Message-ID: <c039d2e995b2433e7608494fcf5dd06680b0e00d.1789951424.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1789951424.git.wqu@suse.com>
References: <cover.1789951424.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 51EB4219BF
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_DN_NONE(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email,suse.com:mid];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Flag: NO
X-Spam-Score: -3.01

[BUG]
Since commit 3be8a788eed3 ("btrfs: lzo: introduce lzo_compress_bio()
helper"), the space saving check on lzo is broken:

- Space saving check is always done based on block size
  This prevents lzo_compress_bio() from doing any compression if the @len
  is smaller than sectorsize.

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
  returns true and copy_compressed_data_to_bio() always returns -E2BIG and
  failed to create an lzo compressed inlined extent.

This check is LZO specific, as other algorithms do not have any block
aligned check during compression.
Both remaining algorithms rely on regular input/output size check, and
the final common space saving check at compress_file_range().

And for the extra padding bytes, there is no space saving check at all.

[FIX]
- Do a simpler space saving check
  By just checking whether the compressed size meets or exceeds the input
  size. If so reject it with -E2BIG.

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

