Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0BAA37D10E
	for <linux-btrfs@vger.kernel.org>; Sun,  5 Jul 2026 11:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783252120; cv=none; b=swr8bqGrGkWV4TEzr3yvUqaBdOVCwym9otX5DmozguuwIzWWMilNT/hLTMr/pMqj5Jpt2wJ7s1NBPJO5PXe2QgOW1Gv/lN8BO1RXWWSUgAKwg3IbXe5Lqq+IjpdY2goC7nvsKHtbzFn6Z8w+eXW0BEA3g5RntYaHmhk/nlaPEL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783252120; c=relaxed/simple;
	bh=WFKm8wrqtwaRf2Z8d2yF9jEuSMayTKy2L6ndOgRGroQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FN0jakzDWOdBySseSxxZwCjnRdylQ1s1Q7XokBjzNZnFsomxFYVBCv0UeYVa4YCzdT/+aq2LoGk0RyreK7p7rdEAZat81OcWcG+9f1tKRs9eQM6vdvA10Vui6KLNgFmdOoKmLrzLfghgblD65fyDhx2L7GDWd75e4N+7PHKwEBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Q53UHcjD; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Q53UHcjD; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Q53UHcjD";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Q53UHcjD"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 79738759A1
	for <linux-btrfs@vger.kernel.org>; Sun,  5 Jul 2026 11:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783252108; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FWoXpAZcMGmhIzXGE/F1wX9fzecT8ADH1iOxyoZs4gM=;
	b=Q53UHcjDUw5B4V1I2arZECe0Z7zNBxs1IVOP3yjujZnQuTQzVAZGktNy3FULawtM7WlXKm
	f3wxnG1j0IjbB/eeTF5Nj0HRdykpQo9jXOytWt8VjLYlSB61SkKo+R2fUEelNR3ChvJqUB
	dh6d5pKetq3WH+xOF8UtGLJO7Yn9+vA=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783252108; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FWoXpAZcMGmhIzXGE/F1wX9fzecT8ADH1iOxyoZs4gM=;
	b=Q53UHcjDUw5B4V1I2arZECe0Z7zNBxs1IVOP3yjujZnQuTQzVAZGktNy3FULawtM7WlXKm
	f3wxnG1j0IjbB/eeTF5Nj0HRdykpQo9jXOytWt8VjLYlSB61SkKo+R2fUEelNR3ChvJqUB
	dh6d5pKetq3WH+xOF8UtGLJO7Yn9+vA=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 826A6779AA
	for <linux-btrfs@vger.kernel.org>; Sun,  5 Jul 2026 11:48:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CEccDYtESmpFSAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 05 Jul 2026 11:48:27 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v5 2/4] btrfs: extract the common scrub read endio into a helper
Date: Sun,  5 Jul 2026 21:17:55 +0930
Message-ID: <8e8f62c681bc0208796eec03ae161f3d62925eb0.1783251701.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1783251701.git.wqu@suse.com>
References: <cover.1783251701.git.wqu@suse.com>
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

For both scrub_repair_read_endio() and scrub_read_endio(), they share
the same bitmap update and bio put.

Extract the common code into a helper to reduce duplication.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/scrub.c | 52 ++++++++++++++++++++++++------------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 5ec04c91e12d..d95002edc20e 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -876,6 +876,30 @@ static int calc_sector_number(struct scrub_stripe *stripe, struct bio_vec *first
 	return i;
 }
 
+/*
+ * The common handling of read endio.
+ *
+ * The bbio will be released, so no more access to @bbio after this function.
+ */
+static void scrub_read_endio_common(struct btrfs_bio *bbio)
+{
+	struct scrub_stripe *stripe = bbio->private;
+	struct btrfs_fs_info *fs_info = stripe->bg->fs_info;
+	int sector_nr = calc_sector_number(stripe, bio_first_bvec_all(&bbio->bio));
+	const u32 bio_size = bio_get_size(&bbio->bio);
+	const u32 sectors = bio_size >> fs_info->sectorsize_bits;
+
+	ASSERT(sector_nr < stripe->nr_sectors);
+
+	if (bbio->bio.bi_status) {
+		scrub_bitmap_set_io_error(stripe, sector_nr, sectors);
+		scrub_bitmap_set_error(stripe, sector_nr, sectors);
+	} else {
+		scrub_bitmap_clear_io_error(stripe, sector_nr, sectors);
+	}
+	bio_put(&bbio->bio);
+}
+
 /*
  * Repair read is different to the regular read:
  *
@@ -885,22 +909,9 @@ static int calc_sector_number(struct scrub_stripe *stripe, struct bio_vec *first
 static void scrub_repair_read_endio(struct btrfs_bio *bbio)
 {
 	struct scrub_stripe *stripe = bbio->private;
-	struct btrfs_fs_info *fs_info = stripe->bg->fs_info;
-	int sector_nr = calc_sector_number(stripe, bio_first_bvec_all(&bbio->bio));
-	const u32 bio_size = bio_get_size(&bbio->bio);
 
-	ASSERT(sector_nr < stripe->nr_sectors);
+	scrub_read_endio_common(bbio);
 
-	if (bbio->bio.bi_status) {
-		scrub_bitmap_set_io_error(stripe, sector_nr,
-					  bio_size >> fs_info->sectorsize_bits);
-		scrub_bitmap_set_error(stripe, sector_nr,
-				       bio_size >> fs_info->sectorsize_bits);
-	} else {
-		scrub_bitmap_clear_io_error(stripe, sector_nr,
-					  bio_size >> fs_info->sectorsize_bits);
-	}
-	bio_put(&bbio->bio);
 	if (atomic_dec_and_test(&stripe->pending_io))
 		wake_up(&stripe->io_wait);
 }
@@ -1239,20 +1250,9 @@ static void scrub_stripe_read_repair_worker(struct work_struct *work)
 static void scrub_read_endio(struct btrfs_bio *bbio)
 {
 	struct scrub_stripe *stripe = bbio->private;
-	int sector_nr = calc_sector_number(stripe, bio_first_bvec_all(&bbio->bio));
-	int num_sectors;
-	const u32 bio_size = bio_get_size(&bbio->bio);
 
-	ASSERT(sector_nr < stripe->nr_sectors);
-	num_sectors = bio_size >> stripe->bg->fs_info->sectorsize_bits;
+	scrub_read_endio_common(bbio);
 
-	if (bbio->bio.bi_status) {
-		scrub_bitmap_set_io_error(stripe, sector_nr, num_sectors);
-		scrub_bitmap_set_error(stripe, sector_nr, num_sectors);
-	} else {
-		scrub_bitmap_clear_io_error(stripe, sector_nr, num_sectors);
-	}
-	bio_put(&bbio->bio);
 	if (atomic_dec_and_test(&stripe->pending_io)) {
 		wake_up(&stripe->io_wait);
 		INIT_WORK(&stripe->work, scrub_stripe_read_repair_worker);
-- 
2.54.0

