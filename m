Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792661997;
	b=MQ5VEkiwMFbe2h97P7FZ+HW6hg7bNi+SRGLeI4ah4fWxwV8l26Udgs3tOSzoXMeP2dJx
	 GRAm8PGw+2T95Lw+OWX/TaD9IHOcdbGWiRbWPUWpUzYSVvv9qcXpOQFiPmQCZSeSeUzPG
	 mYYiUYuRdY6Zp/oyhoLKYclUajkii3G/jXUWHTpKSmZTZgSzAbKLuhv/sWnL6yRoL40AG
	 apQ0wX1HsPFLVFAhdk5oPwcnHaJ/pYncmFWrGWx8mMRCluYL7+t6PuUedcqIr0z3l4/Gl
	 b8jFppEWJX+/FxxF9RhWFjK3WjBMLlrC8N+xwxI8czTQBshPSzd16mh8lJsoQnxhlaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792661997;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spamd-Result:
	 X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=I3i6Tg01NdE5OAVcqK6wTDxIFeZbzt1w+4oh3fKfg/E=;
	b=02YLYLaR6PlnBRfBLsFuDp+8hymz14jADoFF0OirsmedU7PlYUieMHMAuAteLuTdZaVZ
	 lWygtCirspEgbt/ODxtXdpD6gnltbof/sRx40vYZEg7hRfkXZu26b8TTCwU4hwkzdmGcF
	 +Ipd5vruzN6iLCYO7peHwk3uzqNJVBCYnJx1QEBRsdJTyPQpEzSrs3bmbnn6DkpAwt/gX
	 2r2dCmxEJy7b0twqB8byC5yOVJLnnnp2hCB2c6DnHv/IK8WdluVueF1fZGMPIuxP7akjc
	 58hNlWSsRBW08i/8KA7FENXiykm1SJlN2zG9KRN+cE2VtMBZeJVfqXbtQbwsRs7wk0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=pH+CPVvj;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=pH+CPVvj;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1DE3606A31D
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2026 09:39:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B1DE3606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=pH+CPVvj;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=pH+CPVvj
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1A5162213B
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2026 09:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792661995; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I3i6Tg01NdE5OAVcqK6wTDxIFeZbzt1w+4oh3fKfg/E=;
	b=pH+CPVvjTiaPM5uryJatsSMr9V8WGkQlhL3X3aTpVHRkT4+9Fpj6J89APBtVVvGaYVa7AE
	+WYH9VUwtbifyAv3rdMbBJzBINyK7ZBHJjzak+A2Snr2WdJ51IYhIzQ/maLjckWMG7dpGD
	kQ6PbAgAeaHFWGqV9fIP5rDQNyURZUk=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792661995; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I3i6Tg01NdE5OAVcqK6wTDxIFeZbzt1w+4oh3fKfg/E=;
	b=pH+CPVvjTiaPM5uryJatsSMr9V8WGkQlhL3X3aTpVHRkT4+9Fpj6J89APBtVVvGaYVa7AE
	+WYH9VUwtbifyAv3rdMbBJzBINyK7ZBHJjzak+A2Snr2WdJ51IYhIzQ/maLjckWMG7dpGD
	kQ6PbAgAeaHFWGqV9fIP5rDQNyURZUk=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 02911134E9
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2026 09:39:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sUAVLufZ2Wp7dQAAD6G6ig:T2
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2026 09:39:53 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] btrfs: introduce rbio_nr_data_sectors() helper
Date: Thu, 22 Oct 2026 20:09:27 +1030
Message-ID: <0b7f47fcd021a6cdcb882cd4a6e49b61e4a41c98.1792661955.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1792661955.git.wqu@suse.com>
References: <cover.1792661955.git.wqu@suse.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-11.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80
X-Spam-Level: 
X-Spam-Flag: NO

The pattern "rbio->nr_data * rbio->stripe_nsectors" is utilized more
than 5 times inside raid56.c, it's worthy to extract it into a new
helper.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/raid56.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 59aad807f98a..0c792d85f520 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -246,6 +246,12 @@ static void memcpy_from_bio_to_stripe(struct btrfs_raid_bio *rbio, unsigned int
 	}
 }
 
+/* Return how many data blocks there is inside the rbio. */
+static unsigned int rbio_nr_data_sectors(const struct btrfs_raid_bio *rbio)
+{
+	return rbio->nr_data * rbio->stripe_nsectors;
+}
+
 /*
  * caching an rbio means to copy anything from the
  * bio_sectors array into the stripe_pages array.  We
@@ -272,7 +278,7 @@ static void cache_rbio_pages(struct btrfs_raid_bio *rbio)
 			 * a data sector it should still be uptodate as it is
 			 * read from disk.
 			 */
-			if (i < rbio->nr_data * rbio->stripe_nsectors)
+			if (i < rbio_nr_data_sectors(rbio))
 				ASSERT(test_bit(i, rbio->stripe_uptodate_bitmap));
 			continue;
 		}
@@ -402,7 +408,7 @@ static bool is_data_stripe_page(struct btrfs_raid_bio *rbio, int page_nr)
 	 * Thus if the first sector of the page belongs to data stripes, then
 	 * the full page belongs to data stripes.
 	 */
-	return (sector_nr < rbio->nr_data * rbio->stripe_nsectors);
+	return (sector_nr < rbio_nr_data_sectors(rbio));
 }
 
 /*
@@ -1559,7 +1565,7 @@ static void set_rbio_range_error(struct btrfs_raid_bio *rbio, struct bio *bio)
 		     rbio->bioc->full_stripe_logical;
 	int total_nr_sector = offset >> fs_info->sectorsize_bits;
 
-	ASSERT(total_nr_sector < rbio->nr_data * rbio->stripe_nsectors);
+	ASSERT(total_nr_sector < rbio_nr_data_sectors(rbio));
 
 	bitmap_set(rbio->error_bitmap, total_nr_sector,
 		   bio->bi_iter.bi_size >> fs_info->sectorsize_bits);
@@ -1669,7 +1675,7 @@ static void verify_bio_data_sectors(struct btrfs_raid_bio *rbio,
 		return;
 
 	/* P/Q stripes, they have no data csum to verify against. */
-	if (total_sector_nr >= rbio->nr_data * rbio->stripe_nsectors)
+	if (total_sector_nr >= rbio_nr_data_sectors(rbio))
 		return;
 
 	for (struct bvec_iter iter = init_bvec_iter_for_bio(bio);
@@ -2303,9 +2309,9 @@ static void fill_data_csums(struct btrfs_raid_bio *rbio)
 {
 	struct btrfs_fs_info *fs_info = rbio->bioc->fs_info;
 	struct btrfs_root *csum_root;
+	const unsigned int nr_data_sectors = rbio_nr_data_sectors(rbio);
 	const u64 start = rbio->bioc->full_stripe_logical;
-	const u32 len = (rbio->nr_data * rbio->stripe_nsectors) <<
-			fs_info->sectorsize_bits;
+	const u32 len = nr_data_sectors << fs_info->sectorsize_bits;
 	int ret;
 
 	/* The rbio should not have its csum buffer initialized. */
@@ -2326,10 +2332,8 @@ static void fill_data_csums(struct btrfs_raid_bio *rbio)
 	    rbio->bioc->map_type & BTRFS_BLOCK_GROUP_METADATA)
 		return;
 
-	rbio->csum_buf = kzalloc(rbio->nr_data * rbio->stripe_nsectors *
-				 fs_info->csum_size, GFP_NOFS);
-	rbio->csum_bitmap = bitmap_zalloc(rbio->nr_data * rbio->stripe_nsectors,
-					  GFP_NOFS);
+	rbio->csum_buf = kzalloc(nr_data_sectors * fs_info->csum_size, GFP_NOFS);
+	rbio->csum_bitmap = bitmap_zalloc(nr_data_sectors, GFP_NOFS);
 	if (!rbio->csum_buf || !rbio->csum_bitmap) {
 		ret = -ENOMEM;
 		goto error;
@@ -2445,9 +2449,10 @@ static void submit_write_bios(struct btrfs_raid_bio *rbio,
  */
 static bool need_read_stripe_sectors(struct btrfs_raid_bio *rbio)
 {
+	const unsigned int nr_data_sectors = rbio_nr_data_sectors(rbio);
 	int i;
 
-	for (i = 0; i < rbio->nr_data * rbio->stripe_nsectors; i++) {
+	for (i = 0; i < nr_data_sectors; i++) {
 		phys_addr_t paddr = rbio->stripe_paddrs[i * rbio->sector_nsteps];
 
 		/*
-- 
2.56.0

