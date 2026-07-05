Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9BF3769E4
	for <linux-btrfs@vger.kernel.org>; Sun,  5 Jul 2026 11:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783252521; cv=none; b=Z8pWAJwedgX/yic70C/kw2w7VWKP5aNUP52wzmd5HJkKq5hIwQ73Fjia4AtUeXgKTx8YEk4GgI7aa6MUCAyVVSDuUuFN6dVxcr/ERmf8PbSQ3e3wpHoh/FQmBtNwwSIxCC6lQ5bpKDC85ClFG68p28qq4dJaUu2a+t1uoXY9B6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783252521; c=relaxed/simple;
	bh=uYTUZbUB+5a5TlRIKBTNwUQ65DgGV5KdSg5zgLlXFks=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IOjzynwHgbN40M8WKZVHPUFq6zvHBcEGXUfVDWWYsf+UYI3vbLUF5JA3jyJVXb/Uyw6BOQgmhBLs2VymnjMqAD9OIST8MEiyu+GfOz5of0b9BQZqBPFj+DnBkjDL/lVpHSm78byzPbVNMAopd/HuGZcaPhkxOHWbjvCzn/bYi0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=pNXolJgJ; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ifEtr1bH; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="pNXolJgJ";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ifEtr1bH"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D88BE752BD
	for <linux-btrfs@vger.kernel.org>; Sun,  5 Jul 2026 11:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783252518; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TkA+pwJOvkG9cM84i8z7I8EZxbsMqThJhZUhsIbZcbc=;
	b=pNXolJgJAG5ZcLXteiwe64P2hUeWv5eCtQTN6+hzV4w7/49LMQqUcbMMvVV12MQZmE4AYs
	fSzvGIOv1YvgLAUIYEdHGo6K5BcZTjEQ8VJqlU/4I6XBWKmImhthhNHqGsQ+fBXjC1eeTM
	Jk4WstEsnfYGbYKNMXAZYR7Pbrv8qB8=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=ifEtr1bH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783252517; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TkA+pwJOvkG9cM84i8z7I8EZxbsMqThJhZUhsIbZcbc=;
	b=ifEtr1bHLas8qrbdwXrZ20ccY6STsDUT3mrdX0WV63cdCA03c/LUPhCrCD7x+X7pMLSSnG
	+zA7QUTqnJYkJS9rFkqJ7quHlURPgJ2Up12p4PUPr0RLGAPlWLtuJL1VpVJKW5lwp5Uaun
	PZHfAzaVARTNnqb8amlWy6BxOj22vjc=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E02AF779AA
	for <linux-btrfs@vger.kernel.org>; Sun,  5 Jul 2026 11:55:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oDvxIyRGSmqsTgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 05 Jul 2026 11:55:16 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v6 3/4] btrfs: scrub: implement calc_sector_number() in a faster way
Date: Sun,  5 Jul 2026 21:24:48 +0930
Message-ID: <b761a5ecf46388d29c3d4c1eee434bd1c9108dab.1783252371.git.wqu@suse.com>
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
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:dkim,suse.com:mid];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: D88BE752BD
X-Spam-Score: -3.01

Currently calc_sector_number() is implemented by comparing the first
bvec of the bbio against all blocks inside a scrub_stripe.

This implementation is a little inefficient, and depends on how the
scrub buffer is implemented.

One of the reason implementing such complex function is that, we do not
save the original bvec_iter inside a write btrfs_bio.
Although a read bbio has btrfs_bio::saved_iter to get the original
logical bytenr, it's not implemented for write bios.

On the other hand, since commit 81cea6cd7041 ("btrfs: remove
btrfs_bio::fs_info by extracting it from btrfs_bio::inode"), we always
set the btrfs_bio::file_offset as the logical bytenr for scrub, and that
member will not be modified during IO.

So this means we have a stable way to determine the logical bytenr for a
scrub bio, now calc_sector_number() is just as simple as:

	return (bbio->file_offset - stripe->logical) >> sectorsize_bits;

Since we're here, also add an ASSERT() to make sure the bbio is inside
the stripe, and change the return type to unsigned int to be extra safe.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/scrub.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index d95002edc20e..2224bca96a46 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -864,16 +864,19 @@ static void scrub_verify_one_stripe(struct scrub_stripe *stripe, unsigned long b
 	}
 }
 
-static int calc_sector_number(struct scrub_stripe *stripe, struct bio_vec *first_bvec)
+static unsigned int calc_sector_number(const struct btrfs_bio *bbio)
 {
-	int i;
+	const struct scrub_stripe *stripe = bbio->private;
+	const struct btrfs_fs_info *fs_info = stripe->bg->fs_info;
 
-	for (i = 0; i < stripe->nr_sectors; i++) {
-		if (scrub_stripe_get_kaddr(stripe, i) == bvec_virt(first_bvec))
-			break;
-	}
-	ASSERT(i < stripe->nr_sectors);
-	return i;
+	/* Scrub bbios all have their @file_offset set to the logical bytenr. */
+	ASSERT(bbio->file_offset >= stripe->logical &&
+	       bbio->file_offset < stripe->logical + (stripe->nr_sectors <<
+						      fs_info->sectorsize_bits),
+	       "scrub bio logical=%llu stripe logical=%llu stripe len=%u",
+	       bbio->file_offset, stripe->logical,
+	       stripe->nr_sectors << fs_info->sectorsize_bits);
+	return (bbio->file_offset - stripe->logical) >> fs_info->sectorsize_bits;
 }
 
 /*
@@ -885,12 +888,10 @@ static void scrub_read_endio_common(struct btrfs_bio *bbio)
 {
 	struct scrub_stripe *stripe = bbio->private;
 	struct btrfs_fs_info *fs_info = stripe->bg->fs_info;
-	int sector_nr = calc_sector_number(stripe, bio_first_bvec_all(&bbio->bio));
+	unsigned int sector_nr = calc_sector_number(bbio);
 	const u32 bio_size = bio_get_size(&bbio->bio);
 	const u32 sectors = bio_size >> fs_info->sectorsize_bits;
 
-	ASSERT(sector_nr < stripe->nr_sectors);
-
 	if (bbio->bio.bi_status) {
 		scrub_bitmap_set_io_error(stripe, sector_nr, sectors);
 		scrub_bitmap_set_error(stripe, sector_nr, sectors);
@@ -1264,7 +1265,7 @@ static void scrub_write_endio(struct btrfs_bio *bbio)
 {
 	struct scrub_stripe *stripe = bbio->private;
 	struct btrfs_fs_info *fs_info = stripe->bg->fs_info;
-	int sector_nr = calc_sector_number(stripe, bio_first_bvec_all(&bbio->bio));
+	unsigned int sector_nr = calc_sector_number(bbio);
 	const u32 bio_size = bio_get_size(&bbio->bio);
 
 	if (bbio->bio.bi_status) {
-- 
2.54.0

