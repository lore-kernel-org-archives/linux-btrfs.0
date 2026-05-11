Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1848175A6B
	for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2026 00:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778461049; cv=none; b=iIrsg/wQzWJYKA5cPQ9F6qkPm2FYVkMxDIITv3dUuj/r7Kj9oXBOAXJkCQdM141y9CHQEpr1HeE9AwAMofmAsK7CQr9WXZ77lmLltBvCkZxCLuPvAGg2X3CbWaML0Kws7rN9MnMdW4qvWXs6hz4ipveZKOCTelR6kFR063wIVkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778461049; c=relaxed/simple;
	bh=+4MRCb3xTWOmBQUluUzNHN5mbcPp4x0bumglZUwb594=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UOa1ZrPgBc3Jvona/ECK0VGD6K+zomCqxKbA7DMVSd+371PIJ/mEOyzuP+6hzW4RSR7HLwewp5+BlK2wQQjjwLWguQ/9/68SaVXFd6R3W7ikWBppbmx6wRiPFBfxFQH4J7AAyflhlyPx/y34KMGU3uJzd4UMISgieLg98wKXKXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=nLVjEm/j; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=nLVjEm/j; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="nLVjEm/j";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="nLVjEm/j"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 827076AFC6
	for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2026 00:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778461039; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P8TfRXmS6wz0Hr9bIc1qdeaaHDRLyhvnXmzrLKOiH80=;
	b=nLVjEm/jwmP0gJSpLnEayPF8bTGE4p+K3Jy3dB2BkdeF5soXyyE8o+/XEGmk45l63mHAFN
	ooIBc85+AcZ/hofLjH+dzy5DT/8YZ+XFhkbyIkjZL0WVsUaNBUVdo6vxTmfrFnCT+P/7o2
	93jnu6Kd2bDvzeR12Oyetjg7zZu3UkU=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="nLVjEm/j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778461039; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P8TfRXmS6wz0Hr9bIc1qdeaaHDRLyhvnXmzrLKOiH80=;
	b=nLVjEm/jwmP0gJSpLnEayPF8bTGE4p+K3Jy3dB2BkdeF5soXyyE8o+/XEGmk45l63mHAFN
	ooIBc85+AcZ/hofLjH+dzy5DT/8YZ+XFhkbyIkjZL0WVsUaNBUVdo6vxTmfrFnCT+P/7o2
	93jnu6Kd2bDvzeR12Oyetjg7zZu3UkU=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C1AA3593A3
	for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2026 00:57:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yDoJIW4pAWp3OwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2026 00:57:18 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] btrfs: tree-checker: extract the shared key check for free space entries
Date: Mon, 11 May 2026 10:26:49 +0930
Message-ID: <dc3df935dd5dc6d21f9ed6de8e1416625aebdc7f.1778460959.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1778460959.git.wqu@suse.com>
References: <cover.1778460959.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Rspamd-Action: no action
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
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 827076AFC6
X-Spam-Level: 

Currently both check_free_space_extent() and check_free_space_bitmap()
share a very common validation on the keys.

Extract them into a helper, check_free_space_common_key(), and
change the output string ("extent" or "bitmap") depending on the key type.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/tree-checker.c | 46 ++++++++++++++++++++---------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index ec24ffb6641d..4d6dde876c6d 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -2112,27 +2112,39 @@ static int check_free_space_info(struct extent_buffer *leaf, struct btrfs_key *k
 	return 0;
 }
 
-static int check_free_space_extent(struct extent_buffer *leaf, struct btrfs_key *key, int slot)
+static int check_free_space_common_key(struct extent_buffer *leaf, struct btrfs_key *key, int slot)
 {
 	struct btrfs_fs_info *fs_info = leaf->fs_info;
 	const u32 blocksize = fs_info->sectorsize;
+	const char *type_str = (key->type == BTRFS_FREE_SPACE_EXTENT_KEY) ? "extent" : "bitmap";
 
 	if (unlikely(!IS_ALIGNED(key->objectid, blocksize))) {
 		generic_err(leaf, slot,
-		"free space extent key objectid is not aligned to %u, has " BTRFS_KEY_FMT,
-			    blocksize, BTRFS_KEY_FMT_VALUE(key));
+		"free space %s key objectid is not aligned to %u, has " BTRFS_KEY_FMT,
+			    type_str, blocksize, BTRFS_KEY_FMT_VALUE(key));
 		return -EUCLEAN;
 	}
 	if (unlikely(!IS_ALIGNED(key->offset, blocksize))) {
 		generic_err(leaf, slot,
-		"free space extent key offset is not aligned to %u, has " BTRFS_KEY_FMT,
-			    blocksize, BTRFS_KEY_FMT_VALUE(key));
+		"free space %s key offset is not aligned to %u, has " BTRFS_KEY_FMT,
+			    type_str, blocksize, BTRFS_KEY_FMT_VALUE(key));
 		return -EUCLEAN;
 	}
 	if (unlikely(key->offset == 0)) {
-		generic_err(leaf, slot, "free space extent length is 0");
+		generic_err(leaf, slot, "free space %s length is 0", type_str);
 		return -EUCLEAN;
 	}
+	return 0;
+}
+
+static int check_free_space_extent(struct extent_buffer *leaf, struct btrfs_key *key, int slot)
+{
+	int ret;
+
+	ret = check_free_space_common_key(leaf, key, slot);
+	if (unlikely(ret < 0))
+		return ret;
+
 	if (unlikely(btrfs_item_size(leaf, slot) != 0)) {
 		generic_err(leaf, slot,
 			    "invalid item size for free space info, has %u expect 0",
@@ -2146,25 +2158,13 @@ static int check_free_space_bitmap(struct extent_buffer *leaf,
 				   struct btrfs_key *key, int slot)
 {
 	struct btrfs_fs_info *fs_info = leaf->fs_info;
-	const u32 blocksize = fs_info->sectorsize;
 	u32 expected_item_size;
+	int ret;
+
+	ret = check_free_space_common_key(leaf, key, slot);
+	if (unlikely(ret < 0))
+		return ret;
 
-	if (unlikely(!IS_ALIGNED(key->objectid, blocksize))) {
-		generic_err(leaf, slot,
-		"free space bitmap key objectid is not aligned to %u, has " BTRFS_KEY_FMT,
-			    blocksize, BTRFS_KEY_FMT_VALUE(key));
-		return -EUCLEAN;
-	}
-	if (unlikely(!IS_ALIGNED(key->offset, blocksize))) {
-		generic_err(leaf, slot,
-		"free space bitmap key offset is not aligned to %u, has " BTRFS_KEY_FMT,
-			    blocksize, BTRFS_KEY_FMT_VALUE(key));
-		return -EUCLEAN;
-	}
-	if (unlikely(key->offset == 0)) {
-		generic_err(leaf, slot, "free space bitmap length is 0");
-		return -EUCLEAN;
-	}
 	/*
 	 * The item must hold exactly the right number of bitmap bytes for the
 	 * range described by key->offset.  A mismatch means the item was
-- 
2.54.0

