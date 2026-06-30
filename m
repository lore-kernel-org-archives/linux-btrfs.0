Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E94E3890EE
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Jun 2026 08:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782807867; cv=none; b=BKYfvWM7xnXX7S4mfLiLIaojd/ulDXerhaVwgPR4FK8F93kXXGruMXFsHn4phqjT7Ii0cvB1f+0xkj3f8Eiy4YnL9n0WVj8B3I7sVZpj19WAgHN0pfQ+ebLwIV6L5/rUrVM4raf2Q3jd6Dl0HILqoyycX9gq0lQnzzz+FYQ98Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782807867; c=relaxed/simple;
	bh=WFKm8wrqtwaRf2Z8d2yF9jEuSMayTKy2L6ndOgRGroQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p/uGbbpvHLyG5g5jS0mUuF7OWrFJCOJlM/sHyDLdCSu06/V10RWe+ZTM/u69y23FduVeije7ZXfsrxI0Oddne+f065+aUmSYPshRODrXSyoLcLMqxoJZkGCVUtFpGqX0S320Duu0gLTO+pf4RiCXS/fR+ThYfQVm6UOwH3jrNPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=kNA++PAo; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=kNA++PAo; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="kNA++PAo";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="kNA++PAo"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0589D758DB
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Jun 2026 08:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1782807855; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FWoXpAZcMGmhIzXGE/F1wX9fzecT8ADH1iOxyoZs4gM=;
	b=kNA++PAoIUwIezNJqLWQuzmB3nysDqfzcXpP0OJKMrdYXSnneVhArAMTOV0RMicX5SRR79
	fx43XSxFUcgzTYYc0WvFSJiOUV+q9KuTuZ0E8MRMMeZKb9Gq7p/OdIExpyBqbBcJXPg42r
	lSCbG2SfD/cB6gekCcD8dOzM4Bs1GEg=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=kNA++PAo
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1782807855; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FWoXpAZcMGmhIzXGE/F1wX9fzecT8ADH1iOxyoZs4gM=;
	b=kNA++PAoIUwIezNJqLWQuzmB3nysDqfzcXpP0OJKMrdYXSnneVhArAMTOV0RMicX5SRR79
	fx43XSxFUcgzTYYc0WvFSJiOUV+q9KuTuZ0E8MRMMeZKb9Gq7p/OdIExpyBqbBcJXPg42r
	lSCbG2SfD/cB6gekCcD8dOzM4Bs1GEg=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0A780779A8
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Jun 2026 08:24:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8IoEKy19Q2oBEAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Jun 2026 08:24:13 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v4 2/3] btrfs: extract the common scrub read endio into a helper
Date: Tue, 30 Jun 2026 17:53:50 +0930
Message-ID: <2360504fe5317dee163277cf1fa1b2327c18cdd1.1782795330.git.wqu@suse.com>
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
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 0589D758DB
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCPT_COUNT_ONE(0.00)[1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DWL_DNSWL_BLOCKED(0.00)[suse.com:dkim];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

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

