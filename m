Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97CD4344056
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Mar 2026 22:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773094809; cv=none; b=o8u/ATxOQeXefIV0kIhhrXyd/VjBQh3yeLlE5xDAFGnvEt+83XShiGMPaPH7TL/7f6eibRCcVVPiL3xTvmBjUPCKW+ltmsYCy+gMeG5GX0+wAqpA9eViETTKRvgGEXTXECqLBYsIAiEQvomZ79Y6poffnDqZ4xpqmSvwW0xu3zY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773094809; c=relaxed/simple;
	bh=vbYozwHoTdHGsSPgot+s28I3aV2QCnfl/vd5JxHkTEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YGMDQbMSH/dsvo0uYsBGwD7Ka/CyRp5pt+eYQuMwDf8650nMWijQsPnV20/NXE2oWJj9MrHueosPLqOEBOUOQ9XUfnhT9hMSee70MhNoMKALvY+uNTbQoX99R9eAmQVirWbY7fao0R2U2BaLzClSrbMccnFioM6RFUG8bkLxMuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=VI9+RnG/; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=VI9+RnG/; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="VI9+RnG/";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="VI9+RnG/"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 441494D299;
	Mon,  9 Mar 2026 22:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1773094795; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ai+wQwt02SRLZ/xrHXPdEwPowmVWSzApXBiOsKSsjBs=;
	b=VI9+RnG/deOJbPeFkLDlAPqCaR3D4TQFExGcksRr3ozj+h5qGsNNRL/92oNXcHYsj2HDa0
	mlc+l/CBS+zhLfTJQyCGD1DGtrq0vly+ECd9SIHD151y7A82+McyPFBVSAKmTAZFkGxEDB
	MZaN2Kr01f3iWRQBrDGQ2/nP+cA0wIU=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1773094795; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ai+wQwt02SRLZ/xrHXPdEwPowmVWSzApXBiOsKSsjBs=;
	b=VI9+RnG/deOJbPeFkLDlAPqCaR3D4TQFExGcksRr3ozj+h5qGsNNRL/92oNXcHYsj2HDa0
	mlc+l/CBS+zhLfTJQyCGD1DGtrq0vly+ECd9SIHD151y7A82+McyPFBVSAKmTAZFkGxEDB
	MZaN2Kr01f3iWRQBrDGQ2/nP+cA0wIU=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 36FDE3F11A;
	Mon,  9 Mar 2026 22:19:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iCSwOYlHr2n6LQAAD6G6ig
	(envelope-from <wqu@suse.com>); Mon, 09 Mar 2026 22:19:53 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: gality369@gmail.com
Subject: [PATCH 1/2] btrfs: tree-checker: introduce checks for FREE_SPACE_INFO
Date: Tue, 10 Mar 2026 08:49:25 +1030
Message-ID: <dcc4425060fb18e7dc5b45e4ea05cd8afec13f6c.1773094579.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773094579.git.wqu@suse.com>
References: <cover.1773094579.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com];
	ARC_NA(0.00)[];
	TO_DN_NONE(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email,imap1.dmz-prg2.suse.org:helo];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

Introduce checks for FREE_SPACE_INFO item, which include:

- Key alignment check
  The objectid is the logical bytenr of the chunk/bg, and offset is the
  length of the chunk/bg, thus they should all be aligned to the fs
  block size.

- Item size check
  The FREE_SPACE_INFO should a fix size.

- Flags check
  The flags member should has no other flags than
  BTRFS_FREE_SPACE_USING_BITMAPS.

  For future expansion, introduce a new macro
  BTRFS_FREE_SPACE_FLAGS_MASK for such checks.

  And since we're here, the BTRFS_FREE_SPACE_USING_BITMAPS should not
  use unsigned long long, as the flags is only 32 bits wide.
  So fix that to use unsigned long.

- Extent count check
  That member shows how many free space bitmap/extent items there are
  inside the chunk/bg.

  And we know the chunk size (from key->offset), thus there should be at
  most (key->offset >> sectorsize_bits) blocks inside the chunk.
  Use that value as the upper limit and if that counter is larger than
  that, there is a high chance it's a bitflip in high bits.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/tree-checker.c         | 45 +++++++++++++++++++++++++++++++++
 include/uapi/linux/btrfs_tree.h |  3 ++-
 2 files changed, 47 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index ac4c4573ee39..980e4d52061f 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1928,6 +1928,48 @@ static int check_dev_extent_item(const struct extent_buffer *leaf,
 	return 0;
 }
 
+static int check_free_space_info(struct extent_buffer *leaf, struct btrfs_key *key,
+				 int slot)
+{
+	struct btrfs_fs_info *fs_info = leaf->fs_info;
+	struct btrfs_free_space_info *fsi;
+	const u32 blocksize = fs_info->sectorsize;
+	u32 flags;
+
+	if (unlikely(!IS_ALIGNED(key->objectid, blocksize) ||
+		     !IS_ALIGNED(key->offset, blocksize))) {
+		generic_err(leaf, slot,
+		"free space info key range is not aligned to %u, has (%llu %u %llu)",
+			    blocksize, key->objectid, key->type, key->offset);
+		return -EUCLEAN;
+	}
+	if (unlikely(btrfs_item_size(leaf, slot) !=
+		     sizeof(struct btrfs_free_space_info))) {
+		generic_err(leaf, slot,
+		"invalid item size for free space info, has %u expect %zu",
+			    btrfs_item_size(leaf, slot),
+			    sizeof(struct btrfs_free_space_info));
+		return -EUCLEAN;
+	}
+	fsi = btrfs_item_ptr(leaf, slot, struct btrfs_free_space_info);
+	flags = btrfs_free_space_flags(leaf, fsi);
+	if (unlikely(flags & ~BTRFS_FREE_SPACE_FLAGS_MASK)) {
+		generic_err(leaf, slot,
+		"unknown flags for free space info, has 0x%x valid mask 0x%lx",
+			    flags, BTRFS_FREE_SPACE_FLAGS_MASK);
+		return -EUCLEAN;
+	}
+	if (unlikely(btrfs_free_space_extent_count(leaf, fsi) >
+		     key->offset >> fs_info->sectorsize_bits)) {
+		generic_err(leaf, slot,
+		"suspicious extent count, has %u max valid %llu",
+			    btrfs_free_space_extent_count(leaf, fsi),
+			    key->offset >> fs_info->sectorsize_bits);
+		return -EUCLEAN;
+	}
+	return 0;
+}
+
 /*
  * Common point to switch the item-specific validation.
  */
@@ -1991,6 +2033,9 @@ static enum btrfs_tree_block_status check_leaf_item(struct extent_buffer *leaf,
 	case BTRFS_RAID_STRIPE_KEY:
 		ret = check_raid_stripe_extent(leaf, key, slot);
 		break;
+	case BTRFS_FREE_SPACE_INFO_KEY:
+		ret = check_free_space_info(leaf, key, slot);
+		break;
 	}
 
 	if (unlikely(ret))
diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
index f7843e6bb978..cf0c95140299 100644
--- a/include/uapi/linux/btrfs_tree.h
+++ b/include/uapi/linux/btrfs_tree.h
@@ -1245,7 +1245,8 @@ struct btrfs_free_space_info {
 	__le32 flags;
 } __attribute__ ((__packed__));
 
-#define BTRFS_FREE_SPACE_USING_BITMAPS (1ULL << 0)
+#define BTRFS_FREE_SPACE_USING_BITMAPS (1UL << 0)
+#define BTRFS_FREE_SPACE_FLAGS_MASK	(BTRFS_FREE_SPACE_USING_BITMAPS)
 
 #define BTRFS_QGROUP_LEVEL_SHIFT		48
 static inline __u16 btrfs_qgroup_level(__u64 qgroupid)
-- 
2.53.0

