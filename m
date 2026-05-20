Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE04636CDEF
	for <linux-btrfs@vger.kernel.org>; Wed, 20 May 2026 10:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779274663; cv=none; b=UW92vYwKer8tcb4cBKk30e3Ww94dDIrBmCWAw3Yy419tHMBc11yx6iKxqiwtKAdmT4LOqIbLtYeCzweRpOLEqwDRU49V1CqBxehVz2d7UFAlQmZNP6gXprrZuqnp4ebxPe9iv1rT09Eonsomxh1cMo6bD9v64Zk7bKneYjQe8TU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779274663; c=relaxed/simple;
	bh=CcNW7EXjY/vsA46WEZq71KdNBNWSGkIwuUqyGohe6pc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PD9cUFZMH5LRx0xDAAL5dAKMK7jKEfj8NWpILj1wxayhudt2l6/NRnfcU3Lbuh6UuL+JXf03gXPik5vsj5CEZfdjVMdlRrOpD5Dg2XERHiulYsDO4CGZVsftA/Z4819Slo42RsRED8b+t6EQAPUuAfuYTkbkW6EQkOfWAZUKhmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=HPx6OLEa; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=HPx6OLEa; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="HPx6OLEa";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="HPx6OLEa"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1A6DF6AD07;
	Wed, 20 May 2026 10:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779274660; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=hCSRQOnUYCaSufBzhskSe1eaj1fOYQgcjePcIXpGgAw=;
	b=HPx6OLEatO1cmVIrddCIP7ulLi2vGtHFua93vQpgzgaGh2kyhWvw4uqWw6QOZlwUmsKXzb
	j8b1XDgahN5R7d2ZwfcjUnFcVnd9KkyHxY1049gFY/syPJQ2fgmz4z3oj1pgeHwjtQHEvk
	Pnx87AaJav/lek58dLZCgo6SoVj/V+E=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=HPx6OLEa
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779274660; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=hCSRQOnUYCaSufBzhskSe1eaj1fOYQgcjePcIXpGgAw=;
	b=HPx6OLEatO1cmVIrddCIP7ulLi2vGtHFua93vQpgzgaGh2kyhWvw4uqWw6QOZlwUmsKXzb
	j8b1XDgahN5R7d2ZwfcjUnFcVnd9KkyHxY1049gFY/syPJQ2fgmz4z3oj1pgeHwjtQHEvk
	Pnx87AaJav/lek58dLZCgo6SoVj/V+E=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D703B593AA;
	Wed, 20 May 2026 10:57:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5eoOJqKTDWr3LAAAD6G6ig
	(envelope-from <wqu@suse.com>); Wed, 20 May 2026 10:57:38 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: hch@lst.de,
	linux-raid@vger.kernel.org
Subject: [PATCH RFC] btrfs: disguise single-data-RAID56 as RAID1/RAID1C3
Date: Wed, 20 May 2026 20:27:17 +0930
Message-ID: <a1d63733465229936351804f3760803d5894a962.1779274630.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
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
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim,suse.com:email,suse.com:mid];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Queue-Id: 1A6DF6AD07
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Score: -3.01

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

And this disguise only affect on-disk chunk map, not affecting the
corresponding block groups, so the extra bits like RAID1C3 or RAID56
compatible flags will not be affected.

This method has a minimal impact on the fs, all other operations like
scrub and read-repair, are all based on the chunk map type, so the
disguise method will require no extra modification to those call sites.

Although there are still some locations that are checking against
block_group->flags, e.g. scrub. Those call sites will still get extra
limits assuming the bg is RAID56. But it should not cause any extra
problem.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Reason for RFC:

Although the current patch works fine, it is a little fragile, e.g. at
chunk allocation time, we must use the bg->flags, instead of the
in-memory chunk map type.

I'm wondering if we should introduce some dedicated member, e.g.
btrfs_chunk_map::on_disk_type to handle it.
---
 fs/btrfs/volumes.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 93a923e4ecaf..848eafa5fbf7 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6000,6 +6000,26 @@ struct btrfs_chunk_map *btrfs_alloc_chunk_map(int num_stripes, gfp_t gfp)
 	return map;
 }
 
+/*
+ * For single data stripe RAID56, it's completely RAID1/RAID1C3, as data,
+ * P/Q stripes all match each other, and rotation makes no difference anymore.
+ *
+ * So we still keep the on-disk chunk/bg type, but in memory we change the
+ * chunk map type directly to RAID1/RAID1C3
+ */
+static void change_single_data_raid56_map(struct btrfs_chunk_map *map)
+{
+	if ((map->type & BTRFS_BLOCK_GROUP_RAID56_MASK) == 0)
+		return;
+	if (nr_data_stripes(map) > 1)
+		return;
+	if (map->type & BTRFS_BLOCK_GROUP_RAID5)
+		map->type |= BTRFS_BLOCK_GROUP_RAID1;
+	else
+		map->type |= BTRFS_BLOCK_GROUP_RAID1C3;
+	map->type &= ~BTRFS_BLOCK_GROUP_RAID56_MASK;
+}
+
 static struct btrfs_block_group *create_chunk(struct btrfs_trans_handle *trans,
 			struct alloc_chunk_ctl *ctl,
 			struct btrfs_device_info *devices_info)
@@ -6023,6 +6043,7 @@ static struct btrfs_block_group *create_chunk(struct btrfs_trans_handle *trans,
 	map->io_width = BTRFS_STRIPE_LEN;
 	map->sub_stripes = ctl->sub_stripes;
 	map->num_stripes = ctl->num_stripes;
+	change_single_data_raid56_map(map);
 
 	for (int i = 0; i < ctl->ndevs; i++) {
 		for (int j = 0; j < ctl->dev_stripes; j++) {
@@ -6201,7 +6222,7 @@ int btrfs_chunk_alloc_add_chunk_item(struct btrfs_trans_handle *trans,
 	btrfs_set_stack_chunk_length(chunk, bg->length);
 	btrfs_set_stack_chunk_owner(chunk, BTRFS_EXTENT_TREE_OBJECTID);
 	btrfs_set_stack_chunk_stripe_len(chunk, BTRFS_STRIPE_LEN);
-	btrfs_set_stack_chunk_type(chunk, map->type);
+	btrfs_set_stack_chunk_type(chunk, bg->flags);
 	btrfs_set_stack_chunk_num_stripes(chunk, map->num_stripes);
 	btrfs_set_stack_chunk_io_align(chunk, BTRFS_STRIPE_LEN);
 	btrfs_set_stack_chunk_io_width(chunk, BTRFS_STRIPE_LEN);
@@ -7596,6 +7617,7 @@ static int read_one_chunk(struct btrfs_key *key, struct extent_buffer *leaf,
 	 */
 	map->sub_stripes = btrfs_raid_array[index].sub_stripes;
 	map->verified_stripes = 0;
+	change_single_data_raid56_map(map);
 
 	if (num_stripes > 0)
 		map->stripe_size = btrfs_calc_stripe_length(map);
-- 
2.54.0

