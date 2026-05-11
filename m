Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E4851624D5
	for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2026 00:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778461055; cv=none; b=laHBpqb6+zLpVD1GYSZA5x4joW6KvhsBcxH+qMutJkcjmMieLwc0qUUDuNA9sspIbxKUH9QW+Di4ypVKyizciG0FlnqtQV270Cruz4a+WZsKK9nrQ5Oc+o1I4QpeH04uEiEE/Y/vqykbMOVxiTwoHILa7kwLNbD8GpQruAR5r/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778461055; c=relaxed/simple;
	bh=Lwd1vQhwHLZn0zN+Nwd3BTisNC3xGxocFMAEvo+n9UY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OWIpz7TSaQRPgF88KjgW9Z5LDLaw+y+KEM+U/qBXAhx/MWDWhsZ6DNv6aU+P3SS8YdbHHYuacEqmOClK/ABlsZAejHVYyQ9/T8NQlOB88WOSs9YNq86QGnfwRSlQyvJ/b1O9MM2/6hmaXoTHazmEiWNI5Z6RQ92zdTIXQx3ptzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=hBqa1lQI; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Qdi0FurG; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="hBqa1lQI";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Qdi0FurG"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E7FF56AFD8
	for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2026 00:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778461042; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UsZSiUoLzknYl9ze0od/+6DjtVOMBzBae/3qtv00Bfk=;
	b=hBqa1lQIOAKiuAC9x++HO08qzba5VlOMbnKwr87g85wEYuPiTZPyjw9nVSWlAJ+EytnqJF
	HEgU9vLlC0KvfyhVeWZPeIO/VaQd3gZahMYHUv0CR1CCTq3w4ZgyGFTF/hWYid+5fB8/y5
	CMVUT3MgqvPfLbNn4UL+orQVCnfOZW4=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=Qdi0FurG
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778461041; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UsZSiUoLzknYl9ze0od/+6DjtVOMBzBae/3qtv00Bfk=;
	b=Qdi0FurGZiUf355BuEc+kWhZIHH/wHQ4KpZdb+612kUkAAGJZCtu3IEU/TMXnG8jqyPl3c
	rzCXfLizrO4ExC7b+7s49Ml2rTgewXwprkc+vWIuQhU9m9CQiGWiRgyjOOKGoUsBaBbiO2
	JpZhr64+qcU6Wqg7/hPNzBygZ2Mbd9A=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3418E593A3
	for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2026 00:57:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iKMDOnApAWp3OwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2026 00:57:20 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] btrfs: tree-checker: add more cross checks for free space tree
Date: Mon, 11 May 2026 10:26:51 +0930
Message-ID: <aaa282bda6884280756f0c244b8ab5c46bcaab02.1778460959.git.wqu@suse.com>
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
X-Rspamd-Queue-Id: E7FF56AFD8
X-Spam-Level: 

This introduces extra checks using the previous key.

If there is a previous key, we can do extra validations:

- The previous key is FREE_SPACE_INFO
  This means the current extent/bitmap should be inside the
  free space info key range.

  And matches the type of the free space info.

- The previous key is FREE_SPACE_EXTENT or FREE_SPACE_BITMAP
  In that case both the current and previous key should belong to the same
  block group.

  Thus the key type must match, and no overlap between the two keys.

These extra checks are inspired by the recently added type checks during
free space tree loading.

The new tree-checker checks will allow earlier detection, but the
loading time checks are still needed, as the tree-checker checks are
still inside the same leaf, not matching per-bg level checks.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/tree-checker.c | 67 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 60 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index ca9bb695f826..e965c4bfe0c2 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -2119,7 +2119,8 @@ static int check_free_space_info(struct extent_buffer *leaf, struct btrfs_key *k
 	return 0;
 }
 
-static int check_free_space_common_key(struct extent_buffer *leaf, struct btrfs_key *key, int slot)
+static int check_free_space_common_key(struct extent_buffer *leaf, struct btrfs_key *key, int slot,
+				       struct btrfs_key *prev_key)
 {
 	struct btrfs_fs_info *fs_info = leaf->fs_info;
 	const u32 blocksize = fs_info->sectorsize;
@@ -2148,14 +2149,65 @@ static int check_free_space_common_key(struct extent_buffer *leaf, struct btrfs_
 			    type_str, key->objectid, key->offset);
 		return -EUCLEAN;
 	}
+	if (slot == 0)
+		return 0;
+
+	/*
+	 * Make sure the current key is inside the block group, and matching
+	 * the expected info type.
+	 */
+	if (prev_key->type == BTRFS_FREE_SPACE_INFO_KEY) {
+		struct btrfs_free_space_info *fsi;
+		u32 info_flags;
+
+		if (unlikely(key->objectid < prev_key->objectid ||
+			     key->objectid + key->offset > prev_key->objectid + prev_key->offset)) {
+			generic_err(leaf, slot,
+"free space %s is not inside the space info, prev key " BTRFS_KEY_FMT " current key " BTRFS_KEY_FMT,
+				    type_str, BTRFS_KEY_FMT_VALUE(prev_key),
+				    BTRFS_KEY_FMT_VALUE(key));
+			return -EUCLEAN;
+		}
+		fsi = btrfs_item_ptr(leaf, slot - 1, struct btrfs_free_space_info);
+		info_flags = btrfs_free_space_flags(leaf, fsi);
+		if (unlikely((info_flags == BTRFS_FREE_SPACE_USING_BITMAPS &&
+			      key->type == BTRFS_FREE_SPACE_EXTENT_KEY) ||
+			     (info_flags != BTRFS_FREE_SPACE_USING_BITMAPS &&
+			      key->type == BTRFS_FREE_SPACE_BITMAP_KEY))) {
+			generic_err(leaf, slot,
+"free space %s key type is not matching the type of space info, key type %u space info flags %u",
+				    type_str, key->type, info_flags);
+			return -EUCLEAN;
+		}
+		return 0;
+	}
+	/*
+	 * Previous key should be either FREE_SPACE_EXTENT or FREE_SPACE_BITMAP.
+	 * Inside the same block group the key type should match each other, and
+	 * no overlaps.
+	 */
+	if (unlikely(key->type != prev_key->type)) {
+		generic_err(leaf, slot,
+"free space %s key type is not matching the type of previous key, key type %u prev key type %u",
+			    type_str, key->type, prev_key->type);
+		return -EUCLEAN;
+	}
+	if (unlikely(prev_key->objectid + prev_key->offset > key->objectid)) {
+		generic_err(leaf, slot,
+"free space %s key overlaps previous key, prev key " BTRFS_KEY_FMT " current key " BTRFS_KEY_FMT,
+			    type_str, BTRFS_KEY_FMT_VALUE(prev_key),
+			    BTRFS_KEY_FMT_VALUE(key));
+		return -EUCLEAN;
+	}
 	return 0;
 }
 
-static int check_free_space_extent(struct extent_buffer *leaf, struct btrfs_key *key, int slot)
+static int check_free_space_extent(struct extent_buffer *leaf, struct btrfs_key *key, int slot,
+				   struct btrfs_key *prev_key)
 {
 	int ret;
 
-	ret = check_free_space_common_key(leaf, key, slot);
+	ret = check_free_space_common_key(leaf, key, slot, prev_key);
 	if (unlikely(ret < 0))
 		return ret;
 
@@ -2169,13 +2221,14 @@ static int check_free_space_extent(struct extent_buffer *leaf, struct btrfs_key
 }
 
 static int check_free_space_bitmap(struct extent_buffer *leaf,
-				   struct btrfs_key *key, int slot)
+				   struct btrfs_key *key, int slot,
+				   struct btrfs_key *prev_key)
 {
 	struct btrfs_fs_info *fs_info = leaf->fs_info;
 	u32 expected_item_size;
 	int ret;
 
-	ret = check_free_space_common_key(leaf, key, slot);
+	ret = check_free_space_common_key(leaf, key, slot, prev_key);
 	if (unlikely(ret < 0))
 		return ret;
 
@@ -2263,10 +2316,10 @@ static enum btrfs_tree_block_status check_leaf_item(struct extent_buffer *leaf,
 		ret = check_free_space_info(leaf, key, slot);
 		break;
 	case BTRFS_FREE_SPACE_EXTENT_KEY:
-		ret = check_free_space_extent(leaf, key, slot);
+		ret = check_free_space_extent(leaf, key, slot, prev_key);
 		break;
 	case BTRFS_FREE_SPACE_BITMAP_KEY:
-		ret = check_free_space_bitmap(leaf, key, slot);
+		ret = check_free_space_bitmap(leaf, key, slot, prev_key);
 		break;
 	case BTRFS_IDENTITY_REMAP_KEY:
 	case BTRFS_REMAP_KEY:
-- 
2.54.0

