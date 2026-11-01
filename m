Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793573715;
	b=ykgLqvozhduRuIELMRRYfhfBQ4HHekKkhaqYiblFZgTGelPfJvrrR2Fi1GWiAzKnCbfY
	 whj0w8N9btkbf82cSwMBD53coS0mN2T/MZrzbY9YvqWqO12aC6JU7j1Ht0zPKkgAirWWU
	 R3SsyjqKffAa4wV/HU3jegUreL3m1+jXe3RXgRaK3GwPtBX6T1AMOIqV3ZeLOpvZlhTHz
	 jR/uWUHsJHmfOat9Kxd+frrgM/svqxkbz9JvQCkbAt1VzwMBkn2IPf6JSHJ+UOgyHGjBw
	 adEsPzKK5hUsBJ8eWbNKcQSR/P2wq89FAV+ggX50vxXb6GEcz2jBXS9GJS/ZldPogNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793573715;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Spamd-Result:X-Spam-Score:X-Spam-Level:
	 X-Spam-Flag;
	bh=PfzDxp1Jhrfzad7RfUklBjbd3xIB0bCdQMOreGclhY0=;
	b=aPtjx2bV5uKilNWCrslnftZk7/E3722DbP1MGl8jZdxKEUTID8t5C2+oefas+vnjMxa4
	 m19A5xPJ8fo4+nQrxTegcvF7rLFS9qwaLPFZBj/vlpG6N1zZQnx25xB4mbh2yuv05oMp0
	 GBURj50CR95ELvo0x7Vd2+1lD73E+GD0c7jdmW96acaHRFubwmCUPbz/KbeEjZdFV2yPE
	 pf1eOAg4h9lszOwIJBd6Z2vJKhnsGg/MCu+WEOjlwYuFh8dE9NfxqL8MuVQu7Cw6N7cWY
	 UDHvG0jDMIcSSINlxqJpXnRsSvYubLU1ahq2AviBHlcsj7El3O1F7RWp+kQJsoyOxEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=LTZcOgw3;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=LTZcOgw3;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8381C606A324
	for <linux-btrfs@vger.kernel.org>; Sun,  1 Nov 2026 22:55:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8381C606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=LTZcOgw3;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=LTZcOgw3
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 685851F84F
	for <linux-btrfs@vger.kernel.org>; Sun,  1 Nov 2026 22:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793573712; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=PfzDxp1Jhrfzad7RfUklBjbd3xIB0bCdQMOreGclhY0=;
	b=LTZcOgw3z5VGPJh8cz9snudM2BowU4iLu0VFk7oPDAkqZSIM8aK1h6/Br315gxBVDU6wN3
	JOpSi77fWTpg40dO95thvYomlfwkwEC7IpG4tA00o0NFztxy3iQV0DhIidB5MrhNReTavv
	T4NKkA9wWC500W3JhdDA1RtBcNYEViM=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793573712; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=PfzDxp1Jhrfzad7RfUklBjbd3xIB0bCdQMOreGclhY0=;
	b=LTZcOgw3z5VGPJh8cz9snudM2BowU4iLu0VFk7oPDAkqZSIM8aK1h6/Br315gxBVDU6wN3
	JOpSi77fWTpg40dO95thvYomlfwkwEC7IpG4tA00o0NFztxy3iQV0DhIidB5MrhNReTavv
	T4NKkA9wWC500W3JhdDA1RtBcNYEViM=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 459AC13314
	for <linux-btrfs@vger.kernel.org>; Sun,  1 Nov 2026 22:55:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ZAbCI07D52qmagAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 01 Nov 2026 22:55:10 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: tree-checker: unify the chunk and block group flags check
Date: Mon,  2 Nov 2026 09:24:44 +1030
Message-ID: <37eee6577ce1db53a14de45dba11e1d0b022edae.1793573667.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
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
	NEURAL_HAM_SHORT(-0.20)[-0.999];
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

The btrfs_chunk::type and btrfs_block_group_item::flags are using the
same value, thus their checks should match each other.

Unify the check into a common helper, is_chunk_type_valid(), which takes
the chunk type and super block incompat flags to do validation.

The reason we need a dedicated @incompat_flags is because the validation
can be called before fully setting up the fs_info, so we can not rely on
the btrfs_fs_incompat() helper.

Furthermore, due to the very different error message helpers utilized by
chunk and block group items, we will not be able to give a comprehensive
reason on why the chunk_type is incorrect.

Now there will only be a generic error message for invalid chunk_type.

Although end users can no longer easily de-code the error message, with
the help of LLM I believe they should still get what is going wrong
eventually.

Meanwhile we get less duplicated code and less error messages to bother,
I'd still call it a win.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/tree-checker.c | 155 +++++++++++++---------------------------
 1 file changed, 51 insertions(+), 104 deletions(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 9408182a8621..92c254b32f04 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -746,15 +746,58 @@ static void block_group_err(const struct extent_buffer *eb, int slot,
 	va_end(args);
 }
 
+/*
+ * The common btrfs_chunk::type and btrfs_block_group_item::flags validation.
+ *
+ * Unfortunately due to the error message helper differences, we will not output
+ * the detailed reasons for the invalid type.
+ *
+ * Furthermore, at the chunk validation time, the fs is not fully initialized,
+ * we have to pass a incompat_flags for extra validation.
+ */
+static bool is_chunk_type_valid(u64 type, u64 incompat_flags)
+{
+	const bool remapped = (type & BTRFS_BLOCK_GROUP_REMAPPED);
+	const bool support_remap = incompat_flags & BTRFS_FEATURE_INCOMPAT_REMAP_TREE;
+	const bool support_mixed = incompat_flags & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS;
+	const bool is_mixed = (type & BTRFS_BLOCK_GROUP_TYPE_MASK) ==
+			      (BTRFS_BLOCK_GROUP_DATA | BTRFS_BLOCK_GROUP_METADATA);
+
+	if (unlikely(type & ~BTRFS_BLOCK_GROUP_VALID))
+		return false;
+	if (unlikely(!support_remap && (remapped ||
+					(type & BTRFS_BLOCK_GROUP_METADATA_REMAP))))
+		return false;
+
+	/* Invalid REMAPPED flag for remap tree or system chunks. */
+	if (unlikely(remapped && (type & (BTRFS_BLOCK_GROUP_METADATA_REMAP |
+					  BTRFS_BLOCK_GROUP_SYSTEM))))
+		return false;
+
+	if (unlikely(!support_mixed && is_mixed))
+		return false;
+
+	/* One and only one TYPE bit must be set, or mixed. */
+	if (unlikely(!has_single_bit_set(type & BTRFS_BLOCK_GROUP_TYPE_MASK) &&
+		     !is_mixed))
+		return false;
+
+	/* One and only one PROFILE bit must be set, or SINGLE (no bit set). */
+	if (unlikely(!has_single_bit_set(type & BTRFS_BLOCK_GROUP_PROFILE_MASK) &&
+		     (type & BTRFS_BLOCK_GROUP_PROFILE_MASK) != 0))
+		return false;
+	return true;
+}
+
 static int check_block_group_item(struct extent_buffer *leaf,
 				  struct btrfs_key *key, int slot)
 {
 	struct btrfs_fs_info *fs_info = leaf->fs_info;
 	struct btrfs_block_group_item bgi;
 	u32 item_size = btrfs_item_size(leaf, slot);
+	const u64 incompat = btrfs_super_incompat_flags(fs_info->super_copy);
 	u64 chunk_objectid;
 	u64 flags;
-	u64 type;
 	size_t exp_size;
 
 	/*
@@ -813,49 +856,10 @@ static int check_block_group_item(struct extent_buffer *leaf,
 	}
 
 	flags = btrfs_stack_block_group_flags(&bgi);
-	if (unlikely(hweight64(flags & BTRFS_BLOCK_GROUP_PROFILE_MASK) > 1)) {
+	if (unlikely(!is_chunk_type_valid(flags, incompat))) {
 		block_group_err(leaf, slot,
-"invalid profile flags, have 0x%llx (%lu bits set) expect no more than 1 bit set",
-			flags & BTRFS_BLOCK_GROUP_PROFILE_MASK,
-			hweight64(flags & BTRFS_BLOCK_GROUP_PROFILE_MASK));
-		return -EUCLEAN;
-	}
-
-	if (unlikely(flags & BTRFS_BLOCK_GROUP_METADATA_REMAP &&
-		     !btrfs_fs_incompat(fs_info, REMAP_TREE))) {
-		block_group_err(leaf, slot,
-"invalid flags, have 0x%llx (METADATA_REMAP flag set) but no remap-tree incompat flag",
-				flags);
-		return -EUCLEAN;
-	}
-
-	type = flags & BTRFS_BLOCK_GROUP_TYPE_MASK;
-	if (unlikely(type != BTRFS_BLOCK_GROUP_DATA &&
-		     type != BTRFS_BLOCK_GROUP_METADATA &&
-		     type != BTRFS_BLOCK_GROUP_SYSTEM &&
-		     type != BTRFS_BLOCK_GROUP_METADATA_REMAP &&
-		     type != (BTRFS_BLOCK_GROUP_METADATA |
-			      BTRFS_BLOCK_GROUP_DATA))) {
-		block_group_err(leaf, slot,
-"invalid type, have 0x%llx (%lu bits set) expect either 0x%llx, 0x%llx, 0x%llx, 0x%llx or 0x%llx",
-			type, hweight64(type),
-			BTRFS_BLOCK_GROUP_DATA, BTRFS_BLOCK_GROUP_METADATA,
-			BTRFS_BLOCK_GROUP_SYSTEM, BTRFS_BLOCK_GROUP_METADATA_REMAP,
-			BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_DATA);
-		return -EUCLEAN;
-	}
-
-	if (unlikely(!btrfs_fs_incompat(fs_info, REMAP_TREE) &&
-		     type == BTRFS_BLOCK_GROUP_METADATA_REMAP)) {
-		block_group_err(leaf, slot,
-		"invalid type, METADATA_REMAP set but REMAP_TREE incompat flag not set");
-		return -EUCLEAN;
-	}
-
-	if (unlikely(!btrfs_fs_incompat(fs_info, REMAP_TREE) &&
-		     flags & BTRFS_BLOCK_GROUP_REMAPPED)) {
-		block_group_err(leaf, slot,
-		"invalid flags, REMAPPED set but REMAP_TREE incompat flag not set");
+		"invalid block group flags 0x%llx with super incompat features 0x%llx",
+				flags, incompat);
 		return -EUCLEAN;
 	}
 
@@ -976,9 +980,8 @@ int btrfs_check_chunk_valid(const struct btrfs_fs_info *fs_info,
 	u16 num_stripes;
 	u16 sub_stripes;
 	u64 type;
-	u64 features;
+	const u64 features = btrfs_super_incompat_flags(fs_info->super_copy);
 	u32 chunk_sector_size;
-	bool mixed = false;
 	bool remapped;
 	int raid_index;
 	int nparity;
@@ -1004,10 +1007,10 @@ int btrfs_check_chunk_valid(const struct btrfs_fs_info *fs_info,
 	nparity = btrfs_raid_array[raid_index].nparity;
 	remapped = (type & BTRFS_BLOCK_GROUP_REMAPPED);
 
-	if (unlikely(remapped && (type & (BTRFS_BLOCK_GROUP_METADATA_REMAP |
-					  BTRFS_BLOCK_GROUP_SYSTEM)))) {
+	if (unlikely(!is_chunk_type_valid(type, features))) {
 		chunk_err(fs_info, leaf, chunk, logical,
-			  "system or metadata remap chunks can not be remapped");
+			  "invalid chunk type 0x%llx with incompat features 0x%llx",
+			  type, features);
 		return -EUCLEAN;
 	}
 	if (unlikely(!remapped && !num_stripes)) {
@@ -1083,62 +1086,6 @@ int btrfs_check_chunk_valid(const struct btrfs_fs_info *fs_info,
 			  length, SZ_256G);
 		return -EUCLEAN;
 	}
-	if (unlikely(type & ~BTRFS_BLOCK_GROUP_VALID)) {
-		chunk_err(fs_info, leaf, chunk, logical,
-			  "unrecognized chunk type: 0x%llx",
-			  type & ~BTRFS_BLOCK_GROUP_VALID);
-		return -EUCLEAN;
-	}
-
-	if (unlikely(!has_single_bit_set(type & BTRFS_BLOCK_GROUP_PROFILE_MASK) &&
-		     (type & BTRFS_BLOCK_GROUP_PROFILE_MASK) != 0)) {
-		chunk_err(fs_info, leaf, chunk, logical,
-		"invalid chunk profile flag: 0x%llx, expect 0 or 1 bit set",
-			  type & BTRFS_BLOCK_GROUP_PROFILE_MASK);
-		return -EUCLEAN;
-	}
-	if (unlikely((type & BTRFS_BLOCK_GROUP_TYPE_MASK) == 0)) {
-		chunk_err(fs_info, leaf, chunk, logical,
-	"missing chunk type flag, have 0x%llx one bit must be set in 0x%llx",
-			  type, BTRFS_BLOCK_GROUP_TYPE_MASK);
-		return -EUCLEAN;
-	}
-
-	if (unlikely((type & BTRFS_BLOCK_GROUP_SYSTEM) &&
-		     (type & (BTRFS_BLOCK_GROUP_METADATA |
-			      BTRFS_BLOCK_GROUP_DATA)))) {
-		chunk_err(fs_info, leaf, chunk, logical,
-			  "system chunk with data or metadata type: 0x%llx",
-			  type);
-		return -EUCLEAN;
-	}
-
-	features = btrfs_super_incompat_flags(fs_info->super_copy);
-	if (features & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS)
-		mixed = true;
-
-	if (!mixed) {
-		if (unlikely((type & BTRFS_BLOCK_GROUP_METADATA) &&
-			     (type & BTRFS_BLOCK_GROUP_DATA))) {
-			chunk_err(fs_info, leaf, chunk, logical,
-			"mixed chunk type in non-mixed mode: 0x%llx", type);
-			return -EUCLEAN;
-		}
-	}
-
-	if (unlikely((type & BTRFS_BLOCK_GROUP_METADATA_REMAP) &&
-		     !(features & BTRFS_FEATURE_INCOMPAT_REMAP_TREE))) {
-		chunk_err(fs_info, leaf, chunk, logical,
-		"METADATA_REMAP chunk type without REMAP_TREE incompat bit");
-		return -EUCLEAN;
-	}
-
-	if (unlikely(remapped &&
-		     !(features & BTRFS_FEATURE_INCOMPAT_REMAP_TREE))) {
-		chunk_err(fs_info, leaf, chunk, logical,
-		"REMAPPED chunk flag without REMAP_TREE incompat bit");
-		return -EUCLEAN;
-	}
 
 	if (unlikely(!remapped &&
 		     !valid_stripe_count(type & BTRFS_BLOCK_GROUP_PROFILE_MASK,
-- 
2.56.0

