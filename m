Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C7122BDC1C;
	Thu,  3 Sep 2026 06:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788416611; cv=none; b=it/dTfm+b7z3KCEeE7MzuvuQ8WkK9JAUkX2WH3ph5s0RlNoY8JnSuGOWUnKB9unqw96nJsab+3SfQEGG4nFR375+jlX2N4oHG7vQg7hfe6gjsUyhgmFi9F//EgYyWmUUAr0+QoAsybJ9IIr/lOqE8kkKG9CWpuf270NQbve+XlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788416611; c=relaxed/simple;
	bh=SaB9aXPUYYvGwQvhTxrdrk4O5rz23QLKf9SfjrmIcMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m8gHY+DzjCbu1xdo+tGBGAlMLer6hpyKGbpqSqJgD3S+5oVTS3cIFsP+6RgbvPye6dyRLx5apod1qLKryc6IDHldq+8BhmGivq1sABZu8isWdffPdjdlH3xY0jChQKJesKhkd6wZOV1ONmg/ke1wkKOFLjoQIvXqkoVCHuHKMpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Sykx5Cgx; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Sykx5Cgx"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7DE961FDB1;
	Thu,  3 Sep 2026 06:23:23 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1788416603; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WKsSDk9GkEa82koVjVF9sHtV2XmBuB9AUujVQP91OZU=;
	b=Sykx5CgxFRaMO/x/vCTep3m1K4Qu4g2XCpAUQsOw/azpEXx4U7UyGSgpzTEijDd1aTHLOv
	5K9DlB1AwWpxzvxC2sk9kyBCcA+aEHND65c6HCeNBWdA35pHT+nsT5FnjW5GvhnLWrhLRr
	PohAjbagV/7p9iY9BDVCsfvdxS6XGMw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2C01413736;
	Thu,  3 Sep 2026 06:23:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IDcwClsSmWoVKwAAD6G6ig
	(envelope-from <neelx@suse.com>); Thu, 03 Sep 2026 06:23:23 +0000
From: Daniel Vacek <neelx@suse.com>
To: David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>
Cc: Daniel Vacek <neelx@suse.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Qu Wenruo <wqu@suse.com>
Subject: [PATCH v2 1/3] btrfs: consume the given iter directly instead of copying in csum_one_bio()
Date: Thu,  3 Sep 2026 08:23:14 +0200
Message-ID: <20260903062317.3928665-2-neelx@suse.com>
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
X-Rspamd-Queue-Id: 7DE961FDB1
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]

This is just a small cleanup to avoid copying the iter twice in async case.
We already have a copy csum_one_bio() can consume directly. No need to copy
again the second time.
We can use this copy also in the sync case and get rid of the parameter.

Signed-off-by: Daniel Vacek <neelx@suse.com>
---

v2: Use the bbio::csum_saved_iter in both cases and simplify even further.
---
 fs/btrfs/file-item.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 581ca5653be9..4a7681557ec1 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -797,18 +797,17 @@ int btrfs_lookup_csums_bitmap(struct btrfs_root *root, struct btrfs_path *path,
 	return ret;
 }
 
-static void csum_one_bio(struct btrfs_bio *bbio, struct bvec_iter *src)
+static void csum_one_bio(struct btrfs_bio *bbio)
 {
 	struct btrfs_inode *inode = bbio->inode;
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	struct btrfs_ordered_sum *sums = bbio->sums;
-	struct bvec_iter iter;
+	struct bvec_iter *iter = &bbio->csum_saved_iter;
 	const u32 blocksize = fs_info->sectorsize;
 	int index = 0;
 
-	for (iter = *src; iter.bi_size; bio_advance_iter(&bbio->bio, &iter, blocksize)) {
-		btrfs_csum_one_bio_block(fs_info, &bbio->bio, &iter,
-					 sums->sums + index);
+	for (; iter->bi_size; bio_advance_iter(&bbio->bio, iter, blocksize)) {
+		btrfs_csum_one_bio_block(fs_info, &bbio->bio, iter, sums->sums + index);
 
 		index += fs_info->csum_size;
 	}
@@ -820,7 +819,7 @@ static void csum_one_bio_work(struct work_struct *work)
 
 	ASSERT(btrfs_op(&bbio->bio) == BTRFS_MAP_WRITE);
 	ASSERT(bbio->async_csum == true);
-	csum_one_bio(bbio, &bbio->csum_saved_iter);
+	csum_one_bio(bbio);
 	complete(&bbio->csum_done);
 }
 
@@ -850,13 +849,13 @@ int btrfs_csum_one_bio(struct btrfs_bio *bbio, bool async)
 	bbio->sums = sums;
 	btrfs_add_ordered_sum(ordered, sums);
 
+	bbio->csum_saved_iter = bio->bi_iter;
 	if (!async) {
-		csum_one_bio(bbio, &bbio->bio.bi_iter);
+		csum_one_bio(bbio);
 		return 0;
 	}
 	init_completion(&bbio->csum_done);
 	bbio->async_csum = true;
-	bbio->csum_saved_iter = bbio->bio.bi_iter;
 	INIT_WORK(&bbio->csum_work, csum_one_bio_work);
 	schedule_work(&bbio->csum_work);
 	return 0;
-- 
2.53.0

