Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 340AF3B3BF2
	for <linux-btrfs@vger.kernel.org>; Fri, 22 May 2026 09:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779441860; cv=none; b=t8Q3OPmSs/OxoP+fS2Wgq2SKzaopj78HfMUmpUrGIUuYN180838kKyjyf84cQlluqCPqNXpu57atf5JJ6DJ4n0RMo6mDwsvN339bOyTgvmyDQUOj3yhHerd7CHeUnMeLpM9UCKDVFMM4F2LEao+tYkgqwd6u+6Ik4Y+qjSHi0BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779441860; c=relaxed/simple;
	bh=1l60m2EKLB1QstB3MdJ7M3aa16Po6TnBZ1KUHVBftrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZQC7zveKoXn5Nwsy+T0RdNqSLYmdZe2dH39xkNJHPC2VC1l10HQe792iu2Uqzu2jfvlvtwoc5XjpBdiCpMAnFUepGyYeYeRHdCWTc2f72O1q+B28V4fMyoRN4gZAigI45VISoRybZ17m2ui4YWWzQ8HG9f0YnoLXHJuDVkqZ2Gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=LcNl/JY/; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=LcNl/JY/; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="LcNl/JY/";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="LcNl/JY/"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7E3386B901;
	Fri, 22 May 2026 09:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779441857; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f9U/LvdoKHFht9C9fZIfjT3fQ+W4Ms6Jej2dzUqWVCU=;
	b=LcNl/JY/pD5DNFe2WIqi6XONqXu3Z3kRF+q+7JBJqZw865fb8xXGvjdkNe9Oo1pMhmwr8T
	B8kKBdPtteknkeuSPxhXfOpL/V3wvQ3v9ASy/IIJ0tARarnhFUjpClI68e3fTilsHsepUk
	2rnVjU51WP+LvC0hewZYssGPIf8IAYI=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="LcNl/JY/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779441857; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f9U/LvdoKHFht9C9fZIfjT3fQ+W4Ms6Jej2dzUqWVCU=;
	b=LcNl/JY/pD5DNFe2WIqi6XONqXu3Z3kRF+q+7JBJqZw865fb8xXGvjdkNe9Oo1pMhmwr8T
	B8kKBdPtteknkeuSPxhXfOpL/V3wvQ3v9ASy/IIJ0tARarnhFUjpClI68e3fTilsHsepUk
	2rnVjU51WP+LvC0hewZYssGPIf8IAYI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 48F86593A8;
	Fri, 22 May 2026 09:24:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UHqMA8AgEGoXQgAAD6G6ig
	(envelope-from <wqu@suse.com>); Fri, 22 May 2026 09:24:16 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: hch@lst.de,
	linux-raid@vger.kernel.org
Subject: [PATCH 3/3] btrfs: disguise single-data-RAID56 as RAID1/RAID1C3
Date: Fri, 22 May 2026 18:53:53 +0930
Message-ID: <ce02ebf8a9a6f5e2357b838df9d7ecce1f0cfd4b.1779412152.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1779412152.git.wqu@suse.com>
References: <cover.1779412152.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 7E3386B901
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	TO_DN_NONE(0.00)[];
	internal_greylist_whitelist(0.00)[2a07:de40:b281:104:10:150:64:97];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,suse.com:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

Recently kernel RAID56 lib is trying to remove the unexpected
single-data-RAID56 (2 disks RAID5 or 3 disk RAID5) support, meanwhile
btrfs still supports such setup, which means in the long run btrfs has
to handle such corner case by ourselves.

Thankfully single-data-RAID56 is really RAID1/RAID1C3, since data and
P/Q stripes all match each other, rotation also makes no difference.

This patch will disguise those single-data-RAID56 chunks as
RAID1/RAID1C3 chunks.

This is done at two timings:

- Chunk read
- Chunk allocation

This is done by introducing btrfs_chunk_map::on_disk_type member, which
stores the type read from the on-disk metadata.
Meanwhile btrfs_chunk_map::type is calculated using on_disk_type.

For most profiles @type matches @on_disk_type, but for
single-data-RAID56, the @type will be RAID1/RAID1C3.

This method has a minimal impact on the fs, all other operations like
scrub and read-repair, are all based on the chunk map type, so the
disguise method will require no extra modification to those call sites.

Although there are still some locations that are checking against
block_group->flags, e.g. scrub. Those call sites will still get extra
limits assuming the bg is RAID56. But it should not cause any extra
problem.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/block-group.c |  2 +-
 fs/btrfs/volumes.c     | 21 ++++++++++++++++++---
 fs/btrfs/volumes.h     |  8 ++++++++
 3 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 41f65a3165f8..5c9fc7ed4c3e 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2624,7 +2624,7 @@ static int fill_dummy_bgs(struct btrfs_fs_info *fs_info)
 
 		/* Fill dummy cache as FULL */
 		bg->length = map->chunk_len;
-		bg->flags = map->type;
+		bg->flags = map->on_disk_type;
 		bg->cached = BTRFS_CACHE_FINISHED;
 		bg->used = map->chunk_len;
 		bg->space_info = btrfs_find_space_info(fs_info, bg->flags);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index daa8f1ddf713..a754ab7a538f 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6000,6 +6000,19 @@ struct btrfs_chunk_map *btrfs_alloc_chunk_map(int num_stripes, gfp_t gfp)
 	return map;
 }
 
+static void set_real_chunk_type(struct btrfs_chunk_map *map)
+{
+	map->type = map->on_disk_type;
+	if (likely((map->on_disk_type & BTRFS_BLOCK_GROUP_RAID56_MASK) == 0 ||
+		   nr_data_stripes(map) > 1))
+		return;
+	if (map->on_disk_type & BTRFS_BLOCK_GROUP_RAID5)
+		map->type |= BTRFS_BLOCK_GROUP_RAID1;
+	else
+		map->type |= BTRFS_BLOCK_GROUP_RAID1C3;
+	map->type &= ~BTRFS_BLOCK_GROUP_RAID56_MASK;
+}
+
 static struct btrfs_block_group *create_chunk(struct btrfs_trans_handle *trans,
 			struct alloc_chunk_ctl *ctl,
 			struct btrfs_device_info *devices_info)
@@ -6018,9 +6031,10 @@ static struct btrfs_block_group *create_chunk(struct btrfs_trans_handle *trans,
 	map->start = start;
 	map->chunk_len = ctl->chunk_size;
 	map->stripe_size = ctl->stripe_size;
-	map->type = type;
+	map->on_disk_type = type;
 	map->sub_stripes = ctl->sub_stripes;
 	map->num_stripes = ctl->num_stripes;
+	set_real_chunk_type(map);
 
 	for (int i = 0; i < ctl->ndevs; i++) {
 		for (int j = 0; j < ctl->dev_stripes; j++) {
@@ -6199,7 +6213,7 @@ int btrfs_chunk_alloc_add_chunk_item(struct btrfs_trans_handle *trans,
 	btrfs_set_stack_chunk_length(chunk, bg->length);
 	btrfs_set_stack_chunk_owner(chunk, BTRFS_EXTENT_TREE_OBJECTID);
 	btrfs_set_stack_chunk_stripe_len(chunk, BTRFS_STRIPE_LEN);
-	btrfs_set_stack_chunk_type(chunk, map->type);
+	btrfs_set_stack_chunk_type(chunk, map->on_disk_type);
 	btrfs_set_stack_chunk_num_stripes(chunk, map->num_stripes);
 	btrfs_set_stack_chunk_io_align(chunk, BTRFS_STRIPE_LEN);
 	btrfs_set_stack_chunk_io_width(chunk, BTRFS_STRIPE_LEN);
@@ -7581,7 +7595,7 @@ static int read_one_chunk(struct btrfs_key *key, struct extent_buffer *leaf,
 	map->start = logical;
 	map->chunk_len = length;
 	map->num_stripes = num_stripes;
-	map->type = type;
+	map->on_disk_type = type;
 	/*
 	 * We can't use the sub_stripes value, as for profiles other than
 	 * RAID10, they may have 0 as sub_stripes for filesystems created by
@@ -7592,6 +7606,7 @@ static int read_one_chunk(struct btrfs_key *key, struct extent_buffer *leaf,
 	 */
 	map->sub_stripes = btrfs_raid_array[index].sub_stripes;
 	map->verified_stripes = 0;
+	set_real_chunk_type(map);
 
 	if (num_stripes > 0)
 		map->stripe_size = btrfs_calc_stripe_length(map);
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index f24385b599dc..f75f516afe0d 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -632,7 +632,15 @@ struct btrfs_chunk_map {
 	u64 start;
 	u64 chunk_len;
 	u64 stripe_size;
+	/*
+	 * The real type that is utilized during logical address mapping.
+	 *
+	 * For most profiles it matches @on_disk_type, but for single-data-RAID56,
+	 * the real type will be set to RAID1/RAID1C3, to avoid unsupported
+	 * operations from raid56 lib.
+	 */
 	u64 type;
+	u64 on_disk_type;
 	int num_stripes;
 	int sub_stripes;
 	struct btrfs_io_stripe stripes[];
-- 
2.54.0

