Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 120A62AE78
	for <linux-btrfs@vger.kernel.org>; Sun, 26 Apr 2026 07:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777189897; cv=none; b=tf2Bk0QftoiDbnoWs6uYQMkc1swzDvy+SoORft8bX8GYPOZttsqsGliY74Sr7qR+/QdG5OQVDsllLLJw4KZOPWK4LHfD6UWulnbBvogkoPY4lHYNXTA2WOPPBhsimT84MpTieHnZDxZjTNPj6UdNQ3dUh2FuXQqBYDaVqSxNftw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777189897; c=relaxed/simple;
	bh=zpIcEdPG5QRKPF7jTtuanMUUn/x7JOTgjdh+YZmv97A=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TCvEUH6i+rJtW4QxQo8+4PWydXhbQzXWidwp/uDOrbVfy7n0vanQ9a4cIwfVgjYgdkXjCqOEJt5Kw8p1shuDnUxbkjHoixqcqK0gMZmTV7wzvrfGyhhCwG3LgTCBhm10AyG7ENGhhotnQWFJkB8+zg4KxDphJCRy6D9VWLRHA1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Ma5TeCF7; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Ilx27Dvt; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Ma5TeCF7";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Ilx27Dvt"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E8A8B5BD25
	for <linux-btrfs@vger.kernel.org>; Sun, 26 Apr 2026 07:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777189890; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ggv/FZi9HthToOHXT6ZAQ9iB0CzxWS/RqbnlkTYcPwU=;
	b=Ma5TeCF7nD39gT5baKW17iEheihl4m2xYyub7LvV8frFqw//ZHfIGZeE4x8aiIeIamf1PV
	k0kL4AvLImGBQXjnqwstP2AL88FdjN9eX5c9YucG2FtU2G3byoJDBE+YSeJfnEd4/1ZoRH
	fS0aPBN3SI1QKDs5dUFvvIplkXsdHMI=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=Ilx27Dvt
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777189889; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ggv/FZi9HthToOHXT6ZAQ9iB0CzxWS/RqbnlkTYcPwU=;
	b=Ilx27DvtVvHrSt2QXG8dMmT4tLeRH/tFDfgS2aU7qy6y1g9m4WBepvLcixvFWo9cUTgXpl
	3r723wl3rRKtmsyFE94i1P8SeV3lt5SnAqNirPxCnICRaT/b732TfImG1wN4JEkRoRc6bz
	jOvFIaBzs2NYEzfL6tLwSwIqHBbPOjI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E2FDE593B0
	for <linux-btrfs@vger.kernel.org>; Sun, 26 Apr 2026 07:51:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mHcDJADE7Wm3IwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 26 Apr 2026 07:51:28 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: enable cross-folio readahead for bs < ps and large folio cases
Date: Sun, 26 Apr 2026 17:21:03 +0930
Message-ID: <4eaa4b5b1839aecd6a2bed8f995e8430fcea8ba0.1777189624.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1777189624.git.wqu@suse.com>
References: <cover.1777189624.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_ONE(0.00)[1];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_HAS_DN(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: E8A8B5BD25

[BACKGROUND]
When bs < ps support was initially introduced, the compressed data
readahead was disabled as at that time the target page size was 64K, which
means a compressed data extent can span at most 3 64K pages (the head
and tail parts are not aligned to 64K), meaning the benefit is pretty
minimal.

[UNEXPECTED WORKING SITUATION]
But with the already merged large folio support, we're already enabling
readahead with subpage routine unintentionally, e.g:

   0      4K      8K      12K      16K
   |   Folio 0    |    Folio 8K    |
   |<----- Compressed data ------->|

We have 2 8K sized folios, all backed by a single compressed data.

In that case add_ra_bio_pages() will continue to add folio 8K into the
read bio, as the condition to skip is only (bs < ps), not taking the
newer large folio support into consideration at all.

So for folio 8K, it is added to the read bio, but without subpage lock
bitmap populated.

Then at end_bbio_data_read(), folio 0 has proper locked bitmap set, but
folio 8K does not.
This inconsistency is handled by the extra safety net at
btrfs_subpage_end_and_test_lock() where if a folio has no @nr_locked, it
will just be unlocked without touching the locked bitmap.

[ENHANCEMENT]
Make add_ra_bio_pages() support bs < ps and large folio cases, by
removing the check and calling btrfs_folio_set_lock() unconditionally.

This won't make any difference on 4K page sized systems with large
folios, as the readahead is already working, although unexpectedly.

But this will enable true compressed data readahead for bs < ps cases
properly.

Please note that such readahead will only work if the compressed extent is
crossing folio boundaries, which is also the existing limit.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/compression.c | 31 ++++++-------------------------
 1 file changed, 6 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index c5783ac1b646..09729728624b 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -358,10 +358,7 @@ struct compressed_bio *btrfs_alloc_compressed_write(struct btrfs_inode *inode,
  * Add extra pages in the same compressed file extent so that we don't need to
  * re-read the same extent again and again.
  *
- * NOTE: this won't work well for subpage, as for subpage read, we lock the
- * full page then submit bio for each compressed/regular extents.
- *
- * This means, if we have several sectors in the same page points to the same
+ * If we have several sectors in the same page points to the same
  * on-disk compressed data, we will re-read the same extent many times and
  * this function can only help for the next page.
  */
@@ -391,16 +388,6 @@ static noinline int add_ra_bio_pages(struct inode *inode,
 	if (isize == 0)
 		return 0;
 
-	/*
-	 * For current subpage support, we only support 64K page size,
-	 * which means maximum compressed extent size (128K) is just 2x page
-	 * size.
-	 * This makes readahead less effective, so here disable readahead for
-	 * subpage for now, until full compressed write is supported.
-	 */
-	if (fs_info->sectorsize < PAGE_SIZE)
-		return 0;
-
 	/* For bs > ps cases, we don't support readahead for compressed folios for now. */
 	if (fs_info->block_min_order)
 		return 0;
@@ -442,8 +429,8 @@ static noinline int add_ra_bio_pages(struct inode *inode,
 				break;
 
 			/*
-			 * Jump to next page start as we already have page for
-			 * current offset.
+			 * Jump to the next folio as we already have a folio for
+			 * the current offset.
 			 */
 			cur += (folio_sz - offset);
 			continue;
@@ -455,7 +442,7 @@ static noinline int add_ra_bio_pages(struct inode *inode,
 			break;
 
 		if (filemap_add_folio(mapping, folio, pg_index, cache_gfp)) {
-			/* There is already a page, skip to page end */
+			/* There is already a folio, skip to folio end */
 			cur += folio_size(folio);
 			folio_put(folio);
 			continue;
@@ -480,7 +467,7 @@ static noinline int add_ra_bio_pages(struct inode *inode,
 		read_unlock(&em_tree->lock);
 
 		/*
-		 * At this point, we have a locked page in the page cache for
+		 * At this point, we have a locked folio in the page cache for
 		 * these bytes in the file.  But, we have to make sure they map
 		 * to this compressed extent on disk.
 		 */
@@ -514,13 +501,7 @@ static noinline int add_ra_bio_pages(struct inode *inode,
 			folio_put(folio);
 			break;
 		}
-		/*
-		 * If it's subpage, we also need to increase its
-		 * subpage::readers number, as at endio we will decrease
-		 * subpage::readers and to unlock the page.
-		 */
-		if (fs_info->sectorsize < PAGE_SIZE)
-			btrfs_folio_set_lock(fs_info, folio, cur, add_size);
+		btrfs_folio_set_lock(fs_info, folio, cur, add_size);
 		folio_put(folio);
 		cur += add_size;
 	}
-- 
2.53.0

