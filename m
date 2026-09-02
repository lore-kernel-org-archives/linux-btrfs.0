Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6CF149C4D5;
	Wed,  2 Sep 2026 16:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788367921; cv=none; b=KV/3+DQjLzqY9hy+uRRA2dKCNdvIcKYQ88o2tN4XpA2ggedmvru1YTbSpeLT6OTgmDiJm6XUp51MLIGD/xmNNXVZtXcrbRrijJTehuj3HxaWVQ4ot/Pmvtpan70ZXbFLdRbHjv0Xsih9+qsz+qtVxamBtJTvRW1SGg+UkHJR2oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788367921; c=relaxed/simple;
	bh=rWLz0Ve9sYrgJMCzALujwZvpjHCpCpKjkPp4jMUv92Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GVGJ9Ydvd8sPbi6ql2TmiRJwzHX+NAL/K4aXmlW8vcRzrlCWn+FfbwrzPfrc4sAG5kAmImxLUZHKTk5Us0tg+4UK+OB32cOi2wVQ36Cc1370HbUWtk3FXrgQyzlYQmSqQiHs4+EojiFQ8L3vSC+xMcPYrkhlWLod6mw4ewTs0Nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=kx57QZ0M; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="kx57QZ0M"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B241F1F7B8;
	Wed,  2 Sep 2026 16:51:53 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1788367913; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cZ9sqfNF8E6Npqu07LtG7obMDTQznZsBb4WX8Oy59iU=;
	b=kx57QZ0ME6u0pX6BDH4NmkpOz4b94JG4z9X3ruHaDnrKpkgvitQbRi8Rzl9lt6F4tD8RDm
	T4Y77bV4BhwSJViEEq3g7GvMVodU6IVoiy+jwFUoLFPcAJWKKgQ+DmKJIpTv33X3H1YG28
	ZSsCrW17Xa/YTTAE9qo23rWByuqqyAY=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 615BC13736;
	Wed,  2 Sep 2026 16:51:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4K8cFylUmGqNKAAAD6G6ig
	(envelope-from <neelx@suse.com>); Wed, 02 Sep 2026 16:51:53 +0000
From: Daniel Vacek <neelx@suse.com>
To: David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>
Cc: Daniel Vacek <neelx@suse.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Qu Wenruo <wqu@suse.com>
Subject: [PATCH 1/2] btrfs: consume the given iter directly instead of copying in csum_one_bio()
Date: Wed,  2 Sep 2026 18:51:35 +0200
Message-ID: <20260902165137.3781696-2-neelx@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260902165137.3781696-1-neelx@suse.com>
References: <20260902165137.3781696-1-neelx@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: B241F1F7B8
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.00

This is just a small cleanup to avoid copying the iter twice in async case.
We already have a copy csum_one_bio() can consume directly. No need to copy
again the second time.
In the sync case we can copy in the caller (as we did before dd57c78aec39
("btrfs: introduce btrfs_bio::async_csum")).

Signed-off-by: Daniel Vacek <neelx@suse.com>
---
 fs/btrfs/file-item.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 581ca5653be9..5a5cffb18922 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -797,18 +797,16 @@ int btrfs_lookup_csums_bitmap(struct btrfs_root *root, struct btrfs_path *path,
 	return ret;
 }
 
-static void csum_one_bio(struct btrfs_bio *bbio, struct bvec_iter *src)
+static void csum_one_bio(struct btrfs_bio *bbio, struct bvec_iter *iter)
 {
 	struct btrfs_inode *inode = bbio->inode;
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	struct btrfs_ordered_sum *sums = bbio->sums;
-	struct bvec_iter iter;
 	const u32 blocksize = fs_info->sectorsize;
 	int index = 0;
 
-	for (iter = *src; iter.bi_size; bio_advance_iter(&bbio->bio, &iter, blocksize)) {
-		btrfs_csum_one_bio_block(fs_info, &bbio->bio, &iter,
-					 sums->sums + index);
+	for (; iter->bi_size; bio_advance_iter(&bbio->bio, iter, blocksize)) {
+		btrfs_csum_one_bio_block(fs_info, &bbio->bio, iter, sums->sums + index);
 
 		index += fs_info->csum_size;
 	}
@@ -851,12 +849,14 @@ int btrfs_csum_one_bio(struct btrfs_bio *bbio, bool async)
 	btrfs_add_ordered_sum(ordered, sums);
 
 	if (!async) {
-		csum_one_bio(bbio, &bbio->bio.bi_iter);
+		struct bvec_iter iter = bio->bi_iter;
+
+		csum_one_bio(bbio, &iter);
 		return 0;
 	}
 	init_completion(&bbio->csum_done);
 	bbio->async_csum = true;
-	bbio->csum_saved_iter = bbio->bio.bi_iter;
+	bbio->csum_saved_iter = bio->bi_iter;
 	INIT_WORK(&bbio->csum_work, csum_one_bio_work);
 	schedule_work(&bbio->csum_work);
 	return 0;
-- 
2.53.0

