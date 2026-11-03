Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793664079;
	b=5LkZAcg24HhxWurf1i8hwCkZD1yybAEIX27fUgZZFvNKcydIFLQqvPZRMfX1jlIf1k5z
	 iDXo83qCOj90s+e5Mxznd34pq3XevDVXMUUMVoSaE+Hq77XNp3Lz6z14IW6SFLjDoT7bc
	 5Ry7qM0IREk6/Oto7zQOgmzJ9gILnHh414dUoGSjBcj6F8pbjUbkofF+odrKZPsDzC/eI
	 QBdh+di59vlH1RF2yUmyqsQZWHi3LSEl/JSUZTrmbk/y9RrcPBCvxzAmnbPA7U9Dw3UdF
	 wiYGbKV6Y4+/piU02XVv7pZQHIGXVA/zIAXLBEAH7HlI/PeMds/QPO6SJBAaQE5GNrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793664079;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Rspamd-Queue-Id:X-Spam-Level:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:
	 X-Spam-Score;
	bh=NhX03ZpYJ2LKUFia+vtdxVRkYlcSli+kvkEUkF8Sa+Y=;
	b=fbw1zN1r28txoC44kZI3uUqiyaDtv+UVOJ2MBkVnp7ZyLPejDOb4R63Cmi+SbMgwhN8u
	 nTMMivnjZaY1FH6sEkUndP0DkxTFnoLz0jgQP0TNA+fc43tnA6zjir89Had7UENLi8WVm
	 0HLIvkMhTbYqEorqffpQHRFBw9H/DKebkRIAOAgqeibgWGfYlaiC7vTt3prFEz0xvdPE7
	 n7q6eddE/Onfyc0MTY9V/HYUVE+IUCtKLjpjdfYuLlmSYo46y3yzBGJ/sgoo0KBTU++1Q
	 +Vr/ROvaeRuSLGOzSGRoENpnIdhk8Z2OFxcspXPrPGkoi03jDifNRx0rKO0rV8FEd7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=PEYTyNX3;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=PEYTyNX3;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D1B606A324
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Nov 2026 00:01:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 78D1B606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=PEYTyNX3;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=PEYTyNX3
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 856281F82A;
	Tue,  3 Nov 2026 00:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793664076; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=NhX03ZpYJ2LKUFia+vtdxVRkYlcSli+kvkEUkF8Sa+Y=;
	b=PEYTyNX3VSvGLDVFLQOYi5z4cvso8GkewQqSR1nYa45YjytdY+FKeDJkNKMfbqfyUyoBaP
	tnn3eRxnQ4DqPp4U8GqZBHixNdQZNewdmvr/ZoO29zhQkNkLQHmbpWcc21WEcz544BFJpG
	POD0Jfr3+aTWbnj+yC57o6NmyhqqGbM=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=PEYTyNX3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793664076; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=NhX03ZpYJ2LKUFia+vtdxVRkYlcSli+kvkEUkF8Sa+Y=;
	b=PEYTyNX3VSvGLDVFLQOYi5z4cvso8GkewQqSR1nYa45YjytdY+FKeDJkNKMfbqfyUyoBaP
	tnn3eRxnQ4DqPp4U8GqZBHixNdQZNewdmvr/ZoO29zhQkNkLQHmbpWcc21WEcz544BFJpG
	POD0Jfr3+aTWbnj+yC57o6NmyhqqGbM=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1B96313651;
	Tue,  3 Nov 2026 00:01:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8Ym8G0ok6WoHDAAAD6G6ig
	(envelope-from <wqu@suse.com>); Tue, 03 Nov 2026 00:01:14 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Siddharth Mishra <smish149@asu.edu>
Subject: [PATCH] btrfs: return error immediately for btrfs_validate_super()
Date: Tue,  3 Nov 2026 10:30:52 +1030
Message-ID: <7350d541824422978116bfb536d2c7bc68cbb826.1793664043.git.wqu@suse.com>
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
X-Rspamd-Queue-Id: 856281F82A
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-12.01 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[asu.edu:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim,suse.com:email];
	RCVD_COUNT_TWO(0.00)[2];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Score: -12.01

The function btrfs_validate_super() doesn't follow the common
tree-checker behavior, that will immediately return the first error when
something corrupted/unsupported is hit.

This can trigger some ASSERT() when a crafted image is passed in, e.g:

  BTRFS error (device loop0): invalid sectorsize 4097
  assertion failed: is_power_of_2(blocksize) &&
  blocksize >= BTRFS_MIN_BLOCKSIZE && blocksize <= BTRFS_MAX_BLOCKSIZE,
  in fs/btrfs/fs.c:137
  kernel BUG at fs/btrfs/fs.c:137!
  Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
  RIP: 0010:btrfs_supported_blocksize.cold (fs/btrfs/fs.c:137)
  Call Trace:
   btrfs_validate_super (fs/btrfs/disk-io.c:2525)
   open_ctree (fs/btrfs/disk-io.c:3507)
   btrfs_get_tree.cold (fs/btrfs/super.c:2133)
   vfs_get_tree (fs/super.c:1943)
   fc_mount (fs/namespace.c:1282)
   path_mount (fs/namespace.c:4337)
   __x64_sys_mount (fs/namespace.c:4542)

Fix it by making btrfs_validate_super() to immediately return the error
instead of continuing to the remaining checks.

This will bring a minor behavior change, that btrfs will no longer
report all problems of the super block, but I'd say the original
behavior of reporting all errors is not really useful anyway.

This also follows the scheme of tree-checker, and is safer than the
existing code.

Link: https://lore.kernel.org/linux-btrfs/20261102233041.310900-1-smish149@asu.edu/
Reported-by: Siddharth Mishra <smish149@asu.edu>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/disk-io.c | 64 ++++++++++++++++++++++------------------------
 1 file changed, 31 insertions(+), 33 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8e8fb942d2b2..35a43e7cb937 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2477,39 +2477,38 @@ int btrfs_validate_super(const struct btrfs_fs_info *fs_info,
 {
 	const u32 nodesize = btrfs_super_nodesize(sb);
 	const u32 sectorsize = btrfs_super_sectorsize(sb);
-	int ret = 0;
 	const bool ignore_flags = btrfs_test_opt(fs_info, IGNORESUPERFLAGS);
+	int ret;
 
 	if (unlikely(btrfs_super_magic(sb) != BTRFS_MAGIC)) {
 		btrfs_err(fs_info, "no valid FS found");
-		ret = -EINVAL;
+		return -EINVAL;
 	}
 	if (unlikely(btrfs_super_flags(sb) & ~BTRFS_SUPER_FLAG_SUPP)) {
 		if (!ignore_flags) {
 			btrfs_err(fs_info,
 			"unrecognized or unsupported super flag 0x%llx",
 				  btrfs_super_flags(sb) & ~BTRFS_SUPER_FLAG_SUPP);
-			ret = -EINVAL;
-		} else {
-			btrfs_info(fs_info,
-			"unrecognized or unsupported super flags: 0x%llx, ignored",
-				   btrfs_super_flags(sb) & ~BTRFS_SUPER_FLAG_SUPP);
+			return -EINVAL;
 		}
+		btrfs_info(fs_info,
+		"unrecognized or unsupported super flags: 0x%llx, ignored",
+			   btrfs_super_flags(sb) & ~BTRFS_SUPER_FLAG_SUPP);
 	}
 	if (unlikely(btrfs_super_root_level(sb) >= BTRFS_MAX_LEVEL)) {
 		btrfs_err(fs_info, "tree_root level too big: %d >= %d",
 				btrfs_super_root_level(sb), BTRFS_MAX_LEVEL);
-		ret = -EINVAL;
+		return -EINVAL;
 	}
 	if (unlikely(btrfs_super_chunk_root_level(sb) >= BTRFS_MAX_LEVEL)) {
 		btrfs_err(fs_info, "chunk_root level too big: %d >= %d",
 				btrfs_super_chunk_root_level(sb), BTRFS_MAX_LEVEL);
-		ret = -EINVAL;
+		return -EINVAL;
 	}
 	if (unlikely(btrfs_super_log_root_level(sb) >= BTRFS_MAX_LEVEL)) {
 		btrfs_err(fs_info, "log_root level too big: %d >= %d",
 				btrfs_super_log_root_level(sb), BTRFS_MAX_LEVEL);
-		ret = -EINVAL;
+		return -EINVAL;
 	}
 
 	/*
@@ -2519,42 +2518,42 @@ int btrfs_validate_super(const struct btrfs_fs_info *fs_info,
 	if (unlikely(!is_power_of_2(sectorsize) || sectorsize < BTRFS_MIN_BLOCKSIZE ||
 		     sectorsize > BTRFS_MAX_METADATA_BLOCKSIZE)) {
 		btrfs_err(fs_info, "invalid sectorsize %u", sectorsize);
-		ret = -EINVAL;
+		return -EINVAL;
 	}
 
 	if (unlikely(!btrfs_supported_blocksize(sectorsize))) {
 		btrfs_err(fs_info,
 			"sectorsize %u not yet supported for page size %lu",
 			sectorsize, PAGE_SIZE);
-		ret = -EINVAL;
+		return -EINVAL;
 	}
 
 	if (unlikely(!is_power_of_2(nodesize) || nodesize < sectorsize ||
 		     nodesize > BTRFS_MAX_METADATA_BLOCKSIZE)) {
 		btrfs_err(fs_info, "invalid nodesize %u", nodesize);
-		ret = -EINVAL;
+		return -EINVAL;
 	}
 	if (unlikely(nodesize != le32_to_cpu(sb->__unused_leafsize))) {
 		btrfs_err(fs_info, "invalid leafsize %u, should be %u",
 			  le32_to_cpu(sb->__unused_leafsize), nodesize);
-		ret = -EINVAL;
+		return -EINVAL;
 	}
 
 	/* Root alignment check */
 	if (unlikely(!IS_ALIGNED(btrfs_super_root(sb), sectorsize))) {
 		btrfs_err(fs_info, "tree_root block unaligned: %llu",
 			  btrfs_super_root(sb));
-		ret = -EINVAL;
+		return -EINVAL;
 	}
 	if (unlikely(!IS_ALIGNED(btrfs_super_chunk_root(sb), sectorsize))) {
 		btrfs_err(fs_info, "chunk_root block unaligned: %llu",
 			   btrfs_super_chunk_root(sb));
-		ret = -EINVAL;
+		return -EINVAL;
 	}
 	if (unlikely(!IS_ALIGNED(btrfs_super_log_root(sb), sectorsize))) {
 		btrfs_err(fs_info, "log_root block unaligned: %llu",
 			  btrfs_super_log_root(sb));
-		ret = -EINVAL;
+		return -EINVAL;
 	}
 
 	if (unlikely(!fs_info->fs_devices->temp_fsid &&
@@ -2562,7 +2561,7 @@ int btrfs_validate_super(const struct btrfs_fs_info *fs_info,
 		btrfs_err(fs_info,
 		"superblock fsid doesn't match fsid of fs_devices: %pU != %pU",
 			  sb->fsid, fs_info->fs_devices->fsid);
-		ret = -EINVAL;
+		return -EINVAL;
 	}
 
 	if (unlikely(memcmp(fs_info->fs_devices->metadata_uuid, btrfs_sb_fsid_ptr(sb),
@@ -2570,7 +2569,7 @@ int btrfs_validate_super(const struct btrfs_fs_info *fs_info,
 		btrfs_err(fs_info,
 "superblock metadata_uuid doesn't match metadata uuid of fs_devices: %pU != %pU",
 			  btrfs_sb_fsid_ptr(sb), fs_info->fs_devices->metadata_uuid);
-		ret = -EINVAL;
+		return -EINVAL;
 	}
 
 	if (unlikely(memcmp(fs_info->fs_devices->metadata_uuid, sb->dev_item.fsid,
@@ -2578,7 +2577,7 @@ int btrfs_validate_super(const struct btrfs_fs_info *fs_info,
 		btrfs_err(fs_info,
 			"dev_item UUID does not match metadata fsid: %pU != %pU",
 			fs_info->fs_devices->metadata_uuid, sb->dev_item.fsid);
-		ret = -EINVAL;
+		return -EINVAL;
 	}
 
 	/*
@@ -2590,7 +2589,7 @@ int btrfs_validate_super(const struct btrfs_fs_info *fs_info,
 		      !btrfs_fs_incompat(fs_info, NO_HOLES)))) {
 		btrfs_err(fs_info,
 		"block-group-tree feature requires free-space-tree and no-holes");
-		ret = -EINVAL;
+		return -EINVAL;
 	}
 
 	if (btrfs_fs_incompat(fs_info, REMAP_TREE)) {
@@ -2603,22 +2602,22 @@ int btrfs_validate_super(const struct btrfs_fs_info *fs_info,
 			     !btrfs_fs_compat_ro(fs_info, BLOCK_GROUP_TREE))) {
 			btrfs_err(fs_info,
 "remap-tree feature requires free-space-tree, no-holes, and block-group-tree");
-			ret = -EINVAL;
+			return -EINVAL;
 		}
 
 		if (unlikely(btrfs_fs_incompat(fs_info, MIXED_GROUPS))) {
 			btrfs_err(fs_info, "remap-tree not supported with mixed-bg");
-			ret = -EINVAL;
+			return -EINVAL;
 		}
 
 		if (unlikely(btrfs_fs_incompat(fs_info, ZONED))) {
 			btrfs_err(fs_info, "remap-tree not supported with zoned devices");
-			ret = -EINVAL;
+			return -EINVAL;
 		}
 
 		if (unlikely(sectorsize > PAGE_SIZE)) {
 			btrfs_err(fs_info, "remap-tree not supported when block size > page size");
-			ret = -EINVAL;
+			return -EINVAL;
 		}
 	}
 
@@ -2629,32 +2628,31 @@ int btrfs_validate_super(const struct btrfs_fs_info *fs_info,
 	if (unlikely(btrfs_super_bytes_used(sb) < 6 * btrfs_super_nodesize(sb))) {
 		btrfs_err(fs_info, "bytes_used is too small %llu",
 			  btrfs_super_bytes_used(sb));
-		ret = -EINVAL;
+		return -EINVAL;
 	}
 	if (unlikely(!is_power_of_2(btrfs_super_stripesize(sb)))) {
 		btrfs_err(fs_info, "invalid stripesize %u",
 			  btrfs_super_stripesize(sb));
-		ret = -EINVAL;
+		return -EINVAL;
 	}
 	if (unlikely(btrfs_super_num_devices(sb) > (1UL << 31)))
 		btrfs_warn(fs_info, "suspicious number of devices: %llu",
 			   btrfs_super_num_devices(sb));
 	if (unlikely(btrfs_super_num_devices(sb) == 0)) {
 		btrfs_err(fs_info, "number of devices is 0");
-		ret = -EINVAL;
+		return -EINVAL;
 	}
 
 	if (unlikely(mirror_num >= 0 &&
 		     btrfs_super_bytenr(sb) != btrfs_sb_offset(mirror_num))) {
 		btrfs_err(fs_info, "super offset mismatch %llu != %llu",
 			  btrfs_super_bytenr(sb), btrfs_sb_offset(mirror_num));
-		ret = -EINVAL;
+		return -EINVAL;
 	}
 
-	if (unlikely(ret))
-		return ret;
-
 	ret = validate_sys_chunk_array(fs_info, sb);
+	if (unlikely(ret < 0))
+		return ret;
 
 	/*
 	 * The generation is a global counter, we'll trust it more than the others
@@ -2672,7 +2670,7 @@ int btrfs_validate_super(const struct btrfs_fs_info *fs_info,
 			btrfs_super_generation(sb),
 			btrfs_super_cache_generation(sb));
 
-	return ret;
+	return 0;
 }
 
 /*
-- 
2.56.0

