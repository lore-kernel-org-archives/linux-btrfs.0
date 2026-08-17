Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 987A226296
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Aug 2026 05:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786943669; cv=none; b=d8tTTfQhB8jhrF3kqIV7JXtSRVLS4iUpoQBtOPlu3fxcYZhXkrCACZHeOE5tb+xBp3OKpo4y39svoSDVmaGk19vWmpIuTpiwihaOTJsKDFXYLJWRrUIZA/VwPVG+34+LcJgYSv4rJULJigduCnqE91aiMpd2E2zKrtRbtRjLtkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786943669; c=relaxed/simple;
	bh=uiwFQeYfjmZ4+wdRPZ0T4Jbw7M7zFoJph7EiXgzYjpA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k0m2REmeUO9EEF8zuc/y+zZlf47bjA1AkzGAZHViaTuANldPBXgi6a6G1oG1gXZevs4WWqmjn7pFs/mYjcKT61zCg6zPuHvR9NsZctteiR95Kh2g83y5SK++ZEJbwA54KzzxNwSym/WGKLaGdETdxAs9FNN/NDWDY9X4vOEwDMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=smF29gWZ; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=CAlgRu/+; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="smF29gWZ";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="CAlgRu/+"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C368783E31
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Aug 2026 05:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1786943661; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Fmcr+8X+KRfXJX9Q5W796JpkNWoYIMY6tu3afTbRsv0=;
	b=smF29gWZnr80qAuD/TkD5Xas8WWtsxulIVyFYSN3+luJqnmk6XIFjwhxo2sj1hZMfH54po
	DAfO6oACBIS+9qwjnenxdh6Lm3v9UoRrShNFEpz4sWKIYFYSntrFHYmKyIHNp9xEPT1KsC
	EPMcvp2YYN0W9SM3pYgNYVWg8fF2awk=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="CAlgRu/+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1786943657; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Fmcr+8X+KRfXJX9Q5W796JpkNWoYIMY6tu3afTbRsv0=;
	b=CAlgRu/+KFTSYNBsu8kZ5LloUq/CNQqcPq4Ij97GY/nZ4T4YO56zVU2hYEkO0Re4mINZOW
	yQqEsoEqmijuoC2TrVRBZoPyy5rTFMHOZlMLBuxfisebS7XzngRw/jTiwUWB7rTuNbGmKW
	QzEQjdEurWZ6pcUm35PU+zdKBFKBLl4=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A7A20792C4
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Aug 2026 05:14:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kJmpE6iYgmoDSgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Aug 2026 05:14:16 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: return proper negative error code for update_raid_extent_item()
Date: Mon, 17 Aug 2026 14:43:54 +0930
Message-ID: <e35279f4776fd6a69d1b75740155511ac7802292.1786943382.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1786943382.git.wqu@suse.com>
References: <cover.1786943382.git.wqu@suse.com>
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
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sashiko.dev:url,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:mid,suse.com:dkim];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Queue-Id: C368783E31
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

The function btrfs_abort_transaction() only accepts negative error code,
and have the macro VERIFY_NEGATIVE_ERROR() to verify that error code.

But inside update_raid_extent_item(), if there is such key found, we
return 1, breaking the negative error code scheme.

Furthermore if we hit some real error during the tree search, e.g. -EIO,
then the error code is always over-written to -EINVAL.

Fix both problems by following other call sites by overwriting @ret to
-ENOENT if the btrfs_search_slot() failed to locate the key.

This is very unlikely to hit, as we only enter update_raid_extent_item()
if there is a conflicting key already in the raid stripe tree.

This is again reported by Sashiko when reviewing another patch.

Link: https://sashiko.dev/#/patchset/20260817021512.3010812-1-shuangpeng.kernel%40gmail.com
Fixes: 8c4cba2adbb0 ("btrfs: update stripe extents for existing logical addresses")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/raid-stripe-tree.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/raid-stripe-tree.c b/fs/btrfs/raid-stripe-tree.c
index 6291775dbe0e..d9e660447205 100644
--- a/fs/btrfs/raid-stripe-tree.c
+++ b/fs/btrfs/raid-stripe-tree.c
@@ -310,8 +310,10 @@ static int update_raid_extent_item(struct btrfs_trans_handle *trans,
 
 	ret = btrfs_search_slot(trans, trans->fs_info->stripe_root, key, path,
 				0, 1);
-	if (ret)
-		return (ret == 1 ? ret : -EINVAL);
+	if (ret > 0)
+		ret = -ENOENT;
+	if (ret < 0)
+		return ret;
 
 	leaf = path->nodes[0];
 	slot = path->slots[0];
-- 
2.54.0

