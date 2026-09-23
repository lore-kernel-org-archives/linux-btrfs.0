Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E062408017
	for <linux-btrfs@vger.kernel.org>; Wed, 23 Sep 2026 05:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790142310; cv=none; b=BpYfiAux/HClyPC24at2hFS1fW9IYbnnSyuHVl3LF+uqaFKrt1bk1YqM3XFMd3lJDukFBrMrE9D5Z8r9+gKigHIomswf4YJ5s1pxL19DkubojztT+4/Y7JWBJ4QpVD/+3YiMmryXapXBQeRzjzY8S5anT/bRkomIxSM34Z+fyzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790142310; c=relaxed/simple;
	bh=YwS4rRd22gw8bjRr+8ewD2LW8m2+gF49ah1Ll6+oYyo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I1wpNULLPGZK8UAQHf5J+d+2WnA5uqpzlWddQd3Ngxgh8S1wptamt08kC6TnoycBqxT7Pzh5g9oXgETsyhocXr85z8mb8Ey32Tjen7rrNIH51ipeJy+uGFB2Nuv0nNLUBiiiPOgRVupvobRmxHXFMw88VzTo43mlAOiX0Y4hZ7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=lheCiKMc; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=DkGn9BEk; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="lheCiKMc";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="DkGn9BEk"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EFE9421D64
	for <linux-btrfs@vger.kernel.org>; Wed, 23 Sep 2026 05:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1790142303; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vG7z+TDiyFoBNY7/PaHdVAV6nq6+91WSwA2DexSTb0o=;
	b=lheCiKMcOpmBmf1nQAbKgaHRS2fZKkQnyxO01kFFJ8+tUyfCTiGdpTKaSqaDPeoTaxpFYO
	ENG6wAsghNHPWkeY6Q9IdDgiuVQn/7hghVYfK4VV5jhyhc9nM33Tcwv/GC8eTEpt5BbWux
	vnU1ugHewIoro7wGvX195R/fhtsMNH4=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1790142298; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vG7z+TDiyFoBNY7/PaHdVAV6nq6+91WSwA2DexSTb0o=;
	b=DkGn9BEkGsfGTnT7BNwoGTsDqbQsEFEwIm+c+NsCjX+3SppsW796+EWJcl07jOrYfdJr9M
	OD2Ra21KoQijZA1Zz9IxR/tixfpki0laDJUOIOsza+d1qaOanm/AoHXle5psQG6OjuZK3c
	ZTpe/K+y3albGHN0aZPHpJTixkt/JDY=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AFCFC139EA
	for <linux-btrfs@vger.kernel.org>; Wed, 23 Sep 2026 05:44:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 40aCMlVns2o/dgAAD6G6ig:T3
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Wed, 23 Sep 2026 05:44:57 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] btrfs: use kvzalloc() for btrfs_raid_bio::csum_buf
Date: Wed, 23 Sep 2026 15:14:26 +0930
Message-ID: <4d1fec79a4cc0301c27733be433d2bc195123a04.1790142027.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1790142027.git.wqu@suse.com>
References: <cover.1790142027.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spam-Level: 
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO

That member is to store the checksum for the full stripe, and for the
following setup we can have a buffer size larger than 4K:

 sectorsize 4K, csum type SHA256 (32 bytes per sector) and 10 data
 stripes.

 The csum_buf size would be:

 stripe_nsectors * nr_data * csum_size
      16         *   10    *  32  = 5120

This means kzalloc() will require 2 physical contiguous pages, which may
not always be available if the available memory is highly fragmented.

However such allocation failure should be very rare, as small order
(order <= 3) allocation is not that easy to fail.

To reach costly order (>= 4) it requires 128 data stripes, which is beyond
sanity.

Change the allocation to use kvzalloc() instead, so that if we need
multiple pages as buffer, we still have a fallback that allocates single
pages and maps them into a virtually contiguous buffer.

For most cases where the buffer is smaller than a page, the kvzalloc()
should fallback to kzalloc(), with minimal overhead.

Assisted-by: LLM (finding callsites doing multi-page kmalloc)
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/raid56.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 8ec24dbb180f..6e7ab0bb025a 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -946,7 +946,7 @@ static void rbio_orig_end_io(struct btrfs_raid_bio *rbio, blk_status_t status)
 	struct bio *cur = bio_list_get(&rbio->bio_list);
 	struct bio *extra;
 
-	kfree(rbio->csum_buf);
+	kvfree(rbio->csum_buf);
 	bitmap_free(rbio->csum_bitmap);
 	rbio->csum_buf = NULL;
 	rbio->csum_bitmap = NULL;
@@ -2304,8 +2304,8 @@ static void fill_data_csums(struct btrfs_raid_bio *rbio)
 	    rbio->bioc->map_type & BTRFS_BLOCK_GROUP_METADATA)
 		return;
 
-	rbio->csum_buf = kzalloc(rbio->nr_data * rbio->stripe_nsectors *
-				 fs_info->csum_size, GFP_NOFS);
+	rbio->csum_buf = kvzalloc(rbio->nr_data * rbio->stripe_nsectors *
+				  fs_info->csum_size, GFP_NOFS);
 	rbio->csum_bitmap = bitmap_zalloc(rbio->nr_data * rbio->stripe_nsectors,
 					  GFP_NOFS);
 	if (!rbio->csum_buf || !rbio->csum_bitmap) {
@@ -2340,7 +2340,7 @@ static void fill_data_csums(struct btrfs_raid_bio *rbio)
 "sub-stripe write for full stripe %llu is not safe, failed to get csum: %d",
 			rbio->bioc->full_stripe_logical, ret);
 no_csum:
-	kfree(rbio->csum_buf);
+	kvfree(rbio->csum_buf);
 	bitmap_free(rbio->csum_bitmap);
 	rbio->csum_buf = NULL;
 	rbio->csum_bitmap = NULL;
-- 
2.55.0

