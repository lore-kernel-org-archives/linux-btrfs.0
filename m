Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F5362BDC1C;
	Thu,  3 Sep 2026 06:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788416615; cv=none; b=lJUw0YMQ14P2FU3znmxPfh05X64MozRREr1RWscf6q4MymihkHrP+da03+vbQWTlHidT7LJfUcuSjPF6SsJqQ7B9SOhIMVygXVoSziSxfG4s6TUiKF/FCia2lxnO5o+Arbfy1+C1j4EFLPV/y4R+xGmxF4MPPP98QA3C0hTT5q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788416615; c=relaxed/simple;
	bh=0t4SnB+S0ybvtQvhutv6dDJUnDmQA8XgTKf82VCqI9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZXRaDt361YA6EGNK+9dyacrn08ninkNNcUXQIWNDYr5vKSwGOvisQBt9wUA6fuBXUof70567KWYyVMw1wU0AtXoDIlwqG1qKH2lJHRmstWJLRPCgE3dIpF1pOQvHy1z5Jh7oe0H6jorLl3gonjYZAOBPtNXGuthMLK7GC3tPl8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=DCVNfkHl; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Nj/fSERK; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="DCVNfkHl";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Nj/fSERK"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 217A821E07;
	Thu,  3 Sep 2026 06:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1788416608; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sfXDvErAVYiffVsYFRcL1awa1CCQQAqkDQEPuekIlFo=;
	b=DCVNfkHlO/Pi8fbzT8tx1EitbXLdXk/XHUpwM3rWD7gY4XZjUngMXTlPpp0Ns3kAyv6/4o
	I9BFUwuDgMiZf1oB1uuR5Rh9ShRiU72UI71Przb7KUUFSfF7Qh4X2nqDYd4eySc5M5v+0F
	/TJeRkLtbBV/uXWzIT+ekF7osHktbLE=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1788416604; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sfXDvErAVYiffVsYFRcL1awa1CCQQAqkDQEPuekIlFo=;
	b=Nj/fSERKZ8tSAhnthbC5hdtY98LtmCB0qkJPNpk93PI8gYzmcX8VD+qJlnzQFtLi4InzGj
	/xYQ+Zfj6xHEupfo/ucybxVjTlHcyb8bty7To/pUfgAyz8NJqfTVpMiR76LNexWOnMmwpc
	dC7EcGQPtK13OOGsjEq/vxK5o/upHzg=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C53EC13738;
	Thu,  3 Sep 2026 06:23:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eGybL1sSmWoVKwAAD6G6ig
	(envelope-from <neelx@suse.com>); Thu, 03 Sep 2026 06:23:23 +0000
From: Daniel Vacek <neelx@suse.com>
To: David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>
Cc: Daniel Vacek <neelx@suse.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Qu Wenruo <wqu@suse.com>
Subject: [PATCH v2 2/3] btrfs: use bio::remaining for async checksumming synchronization
Date: Thu,  3 Sep 2026 08:23:15 +0200
Message-ID: <20260903062317.3928665-3-neelx@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260903062317.3928665-1-neelx@suse.com>
References: <20260903062317.3928665-1-neelx@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -6.80
X-Spam-Level: 
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid,suse.com:email];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO

We can use bio::remaining counter to sync the offloaded checksuming.
As a result we can slim down the btrfs_bio structure by 24 bytes
and simplify the code a bit.

$ pahole | diff
-	/* size: 328, cachelines: 6, members: 15 */
+	/* size: 304, cachelines: 5, members: 14 */

Moreover this will allow us enabling async checksumming with encryption
where we need to checksum the bounce bio instead of our regular one
embedded in btrfs_bio. And so we need to extend it's lifetime. This is
the preffered way to do so.

Signed-off-by: Daniel Vacek <neelx@suse.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
---

No change since v1
---
 fs/btrfs/bio.c       | 4 ----
 fs/btrfs/bio.h       | 4 ----
 fs/btrfs/file-item.c | 6 ++----
 3 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
index 19b4855969f5..771b7d598aee 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -103,7 +103,6 @@ static struct btrfs_bio *btrfs_split_bio(struct btrfs_fs_info *fs_info,
 	bbio->can_use_append = orig_bbio->can_use_append;
 	bbio->is_scrub = orig_bbio->is_scrub;
 	bbio->is_remap = orig_bbio->is_remap;
-	bbio->async_csum = orig_bbio->async_csum;
 
 	atomic_inc(&orig_bbio->pending_ios);
 	return bbio;
@@ -114,9 +113,6 @@ void btrfs_bio_end_io(struct btrfs_bio *bbio, blk_status_t status)
 	/* Make sure we're already in task context. */
 	ASSERT(in_task());
 
-	if (bbio->async_csum)
-		wait_for_completion(&bbio->csum_done);
-
 	bbio->bio.bi_status = status;
 	if (bbio->bio.bi_pool == &btrfs_clone_bioset) {
 		struct btrfs_bio *orig_bbio = bbio->private;
diff --git a/fs/btrfs/bio.h b/fs/btrfs/bio.h
index b7bd377a0162..bbf362b8668b 100644
--- a/fs/btrfs/bio.h
+++ b/fs/btrfs/bio.h
@@ -58,7 +58,6 @@ struct btrfs_bio {
 			struct btrfs_ordered_extent *ordered;
 			struct btrfs_ordered_sum *sums;
 			struct work_struct csum_work;
-			struct completion csum_done;
 			struct bvec_iter csum_saved_iter;
 			u64 orig_physical;
 			u64 orig_logical;
@@ -93,9 +92,6 @@ struct btrfs_bio {
 	/* Whether the bio is coming from copy_remapped_data_io(). */
 	bool is_remap:1;
 
-	/* Whether the csum generation for data write is async. */
-	bool async_csum:1;
-
 	/* Whether the bio is written using zone append. */
 	bool can_use_append:1;
 
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 4a7681557ec1..0fed4e0d32d5 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -818,9 +818,8 @@ static void csum_one_bio_work(struct work_struct *work)
 	struct btrfs_bio *bbio = container_of(work, struct btrfs_bio, csum_work);
 
 	ASSERT(btrfs_op(&bbio->bio) == BTRFS_MAP_WRITE);
-	ASSERT(bbio->async_csum == true);
 	csum_one_bio(bbio);
-	complete(&bbio->csum_done);
+	bio_endio(&bbio->bio);
 }
 
 /*
@@ -854,8 +853,7 @@ int btrfs_csum_one_bio(struct btrfs_bio *bbio, bool async)
 		csum_one_bio(bbio);
 		return 0;
 	}
-	init_completion(&bbio->csum_done);
-	bbio->async_csum = true;
+	bio_inc_remaining(bio);
 	INIT_WORK(&bbio->csum_work, csum_one_bio_work);
 	schedule_work(&bbio->csum_work);
 	return 0;
-- 
2.53.0

