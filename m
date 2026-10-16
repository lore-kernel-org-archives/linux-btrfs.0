Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742CD2FD1A5
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2026 00:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792111726; cv=none; b=qFEeuu6aCJAI1R7er7Dl9WFvcwoGEEFR7FRdkn18f0aezDqbTJO546KhLb8yFOCIkIGjCl8y4dQIzJN1jlQOd09I17ZHu9XrmvGaroZ7Atg3zmTOx1IDb+W6lYGEthokesPwn16xX+1JAJqZb+Kl6gC4BMR6aK8qMRx1Kpp12bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792111726; c=relaxed/simple;
	bh=YDF+Jw9WhEFY8q2ACPl9pWl8+2m9k/Far09VBjfwnrY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZN0N6AuM1enY+/UOIrcm2Ou5A62nUzFiyhj6q3c5766SpXL/sFI7vnqP/Y5jKPBWWLDVeZxdQpCG+dqcNpb/H709ChYAByhW9vpJ7QFEqaDRZOsu7geVocGgjEH98EGY22XA517+zxdsyOQ2tqUismLhn9yjJs16ZHA7QTiZWEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=GIzBhggB; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=GIzBhggB; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="GIzBhggB";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="GIzBhggB"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AA81B1FD73
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2026 00:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792111722; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iJpJElJjvyVKA3vWpV+8dFR7KtumWB8WdvhdzQiDJjk=;
	b=GIzBhggBXH7Y2Te1nzUINYALTHz4Wj4ArN83RnJ+lcczN3XnTAZCDaQvKdokKqLsFT7ybp
	POpBhVNyCZvc8OPmlVvrBF2+vMgYsZuf5BYFGvEK2xjLuwkxPINsX9pooO1z4j+cd1j8xv
	jQvoUQipy4rMwTvdAh2mldWWgWbpAvg=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792111722; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iJpJElJjvyVKA3vWpV+8dFR7KtumWB8WdvhdzQiDJjk=;
	b=GIzBhggBXH7Y2Te1nzUINYALTHz4Wj4ArN83RnJ+lcczN3XnTAZCDaQvKdokKqLsFT7ybp
	POpBhVNyCZvc8OPmlVvrBF2+vMgYsZuf5BYFGvEK2xjLuwkxPINsX9pooO1z4j+cd1j8xv
	jQvoUQipy4rMwTvdAh2mldWWgWbpAvg=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 989F61339F
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2026 00:48:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id inJNK2V00WojCAAAD6G6ig:T3
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2026 00:48:41 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] btrfs: rename stripe_size inside volumes.c
Date: Fri, 16 Oct 2026 11:18:18 +1030
Message-ID: <d20a83c1a6a7ac4fa0af13846162633dbd0eae28.1792111604.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1792111604.git.wqu@suse.com>
References: <cover.1792111604.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spam-Flag: NO

Rename the "stripe_size" used inside volumes.c by:

- local variable in alloc_virtual_chunk()
- alloc_chunk_ctl::stripe_size
  All rename to "dev_extent_size".

- alloc_chunk_ctl::max_stripe_size
  Rename to "dev_extent_max" as there is already a "dev_extent_min".

- decide_stripe_size*() functions
  Rename to decide_dev_extent_size*().

This further reduces the confusion between "stripe_size" and
"stripe_len".

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/volumes.c | 92 +++++++++++++++++++++++-----------------------
 1 file changed, 46 insertions(+), 46 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 2db449f7c495..e3886c9035de 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5616,7 +5616,7 @@ static int alloc_virtual_chunk(struct btrfs_fs_info *fs_info,
 	const struct btrfs_raid_attr *raid_attr = &btrfs_raid_array[type];
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
 	struct btrfs_device *device;
-	u64 stripe_size;
+	u64 dev_extent_size;
 	int ndevs = 0;
 
 	lockdep_assert_held(&fs_info->chunk_mutex);
@@ -5673,14 +5673,14 @@ static int alloc_virtual_chunk(struct btrfs_fs_info *fs_info,
 		ndevs = min(ndevs, (int)BTRFS_MAX_DEVS(fs_info));
 
 	/*
-	 * Stripe size will be determined by the device with the least
+	 * Dev extent size will be determined by the device with the least
 	 * unallocated space.
 	 */
-	stripe_size = devices_info[ndevs - 1].total_avail;
+	dev_extent_size = devices_info[ndevs - 1].total_avail;
 
 	for (int i = 0; i < ndevs; i++)
-		devices_info[i].dev->per_profile_allocated += stripe_size;
-	*allocated = div_u64(stripe_size * (ndevs - raid_attr->nparity),
+		devices_info[i].dev->per_profile_allocated += dev_extent_size;
+	*allocated = div_u64(dev_extent_size * (ndevs - raid_attr->nparity),
 			     raid_attr->ncopies);
 	return 0;
 }
@@ -5795,10 +5795,10 @@ struct alloc_chunk_ctl {
 	int ncopies;
 	/* Number of stripes worth of bytes to store parity information */
 	int nparity;
-	u64 max_stripe_size;
 	u64 max_chunk_size;
+	u64 dev_extent_max;
 	u64 dev_extent_min;
-	u64 stripe_size;
+	u64 dev_extent_size;
 	u64 chunk_size;
 	int ndevs;
 	/* Space_info the block group is going to belong. */
@@ -5815,7 +5815,7 @@ static void init_alloc_chunk_ctl_policy_regular(
 	ASSERT(space_info);
 
 	ctl->max_chunk_size = READ_ONCE(space_info->chunk_size);
-	ctl->max_stripe_size = min_t(u64, ctl->max_chunk_size, SZ_1G);
+	ctl->dev_extent_max = min_t(u64, ctl->max_chunk_size, SZ_1G);
 
 	if (ctl->type & BTRFS_BLOCK_GROUP_SYSTEM)
 		ctl->devs_max = min_t(int, ctl->devs_max, BTRFS_MAX_DEVS_SYS_CHUNK);
@@ -5837,14 +5837,14 @@ static void init_alloc_chunk_ctl_policy_zoned(
 	u64 min_chunk_size = min_data_stripes * zone_size;
 	u64 type = ctl->type;
 
-	ctl->max_stripe_size = zone_size;
+	ctl->dev_extent_max = zone_size;
 	if (type & BTRFS_BLOCK_GROUP_DATA) {
 		ctl->max_chunk_size = round_down(BTRFS_MAX_DATA_CHUNK_SIZE,
 						 zone_size);
 	} else if (type & BTRFS_BLOCK_GROUP_METADATA) {
-		ctl->max_chunk_size = ctl->max_stripe_size;
+		ctl->max_chunk_size = ctl->dev_extent_max;
 	} else if (type & BTRFS_BLOCK_GROUP_SYSTEM) {
-		ctl->max_chunk_size = 2 * ctl->max_stripe_size;
+		ctl->max_chunk_size = 2 * ctl->dev_extent_max;
 		ctl->devs_max = min_t(int, ctl->devs_max,
 				      BTRFS_MAX_DEVS_SYS_CHUNK);
 	} else {
@@ -5895,7 +5895,7 @@ static int gather_device_info(struct btrfs_fs_devices *fs_devices,
 	struct btrfs_fs_info *info = fs_devices->fs_info;
 	struct btrfs_device *device;
 	u64 total_avail;
-	u64 dev_extent_want = ctl->max_stripe_size * ctl->dev_stripes;
+	u64 dev_extent_want = ctl->dev_extent_max * ctl->dev_stripes;
 	int ret;
 	int ndevs = 0;
 	u64 max_avail;
@@ -5965,8 +5965,8 @@ static int gather_device_info(struct btrfs_fs_devices *fs_devices,
 	return 0;
 }
 
-static int decide_stripe_size_regular(struct alloc_chunk_ctl *ctl,
-				      struct btrfs_device_info *devices_info)
+static int decide_dev_extent_size_regular(struct alloc_chunk_ctl *ctl,
+					  struct btrfs_device_info *devices_info)
 {
 	/* Number of stripes that count for block group size */
 	int data_stripes;
@@ -5978,8 +5978,8 @@ static int decide_stripe_size_regular(struct alloc_chunk_ctl *ctl,
 	 * The DUP profile stores more than one stripe per device, the
 	 * max_avail is the total size so we have to adjust.
 	 */
-	ctl->stripe_size = div_u64(devices_info[ctl->ndevs - 1].max_avail,
-				   ctl->dev_stripes);
+	ctl->dev_extent_size = div_u64(devices_info[ctl->ndevs - 1].max_avail,
+				       ctl->dev_stripes);
 	ctl->num_stripes = ctl->ndevs * ctl->dev_stripes;
 
 	/* This will have to be fixed for RAID1 and RAID10 over more drives */
@@ -5989,31 +5989,31 @@ static int decide_stripe_size_regular(struct alloc_chunk_ctl *ctl,
 	 * Use the number of data stripes to figure out how big this chunk is
 	 * really going to be in terms of logical address space, and compare
 	 * that answer with the max chunk size. If it's higher, we try to
-	 * reduce stripe_size.
+	 * reduce dev_extent_size.
 	 */
-	if (ctl->stripe_size * data_stripes > ctl->max_chunk_size) {
+	if (ctl->dev_extent_size * data_stripes > ctl->max_chunk_size) {
 		/*
-		 * Reduce stripe_size, round it up to a 16MB boundary again and
+		 * Reduce dev_extent_size, round it up to a 16MB boundary again and
 		 * then use it, unless it ends up being even bigger than the
 		 * previous value we had already.
 		 */
-		ctl->stripe_size = min(round_up(div_u64(ctl->max_chunk_size,
-							data_stripes), SZ_16M),
-				       ctl->stripe_size);
+		ctl->dev_extent_size = min(round_up(div_u64(ctl->max_chunk_size,
+							    data_stripes), SZ_16M),
+					   ctl->dev_extent_size);
 	}
 
-	/* Stripe size should not go beyond 1G. */
-	ctl->stripe_size = min_t(u64, ctl->stripe_size, SZ_1G);
+	/* Dev extent size should not go beyond 1G. */
+	ctl->dev_extent_size = min_t(u64, ctl->dev_extent_size, SZ_1G);
 
 	/* Align to BTRFS_STRIPE_LEN */
-	ctl->stripe_size = round_down(ctl->stripe_size, BTRFS_STRIPE_LEN);
-	ctl->chunk_size = ctl->stripe_size * data_stripes;
+	ctl->dev_extent_size = round_down(ctl->dev_extent_size, BTRFS_STRIPE_LEN);
+	ctl->chunk_size = ctl->dev_extent_size * data_stripes;
 
 	return 0;
 }
 
-static int decide_stripe_size_zoned(struct alloc_chunk_ctl *ctl,
-				    struct btrfs_device_info *devices_info)
+static int decide_dev_extent_size_zoned(struct alloc_chunk_ctl *ctl,
+					struct btrfs_device_info *devices_info)
 {
 	u64 zone_size = devices_info[0].dev->zone_info->zone_size;
 	/* Number of stripes that count for block group size */
@@ -6027,30 +6027,30 @@ static int decide_stripe_size_zoned(struct alloc_chunk_ctl *ctl,
 	       "ndevs=%d max_avail=%llu dev_extent_min=%llu", ctl->ndevs,
 	       devices_info[ctl->ndevs - 1].max_avail, ctl->dev_extent_min);
 
-	ctl->stripe_size = zone_size;
+	ctl->dev_extent_size = zone_size;
 	ctl->num_stripes = ctl->ndevs * ctl->dev_stripes;
 	data_stripes = (ctl->num_stripes - ctl->nparity) / ctl->ncopies;
 
-	/* stripe_size is fixed in zoned filesystem. Reduce ndevs instead. */
-	if (ctl->stripe_size * data_stripes > ctl->max_chunk_size) {
+	/* dev_extent_size is fixed in zoned filesystem. Reduce ndevs instead. */
+	if (ctl->dev_extent_size * data_stripes > ctl->max_chunk_size) {
 		ctl->ndevs = div_u64(div_u64(ctl->max_chunk_size * ctl->ncopies,
-					     ctl->stripe_size) + ctl->nparity,
+					     ctl->dev_extent_size) + ctl->nparity,
 				     ctl->dev_stripes);
 		ctl->num_stripes = ctl->ndevs * ctl->dev_stripes;
 		data_stripes = (ctl->num_stripes - ctl->nparity) / ctl->ncopies;
-		ASSERT(ctl->stripe_size * data_stripes <= ctl->max_chunk_size,
-		       "stripe_size=%llu data_stripes=%d max_chunk_size=%llu",
-		       ctl->stripe_size, data_stripes, ctl->max_chunk_size);
+		ASSERT(ctl->dev_extent_size * data_stripes <= ctl->max_chunk_size,
+		       "dev_extent_size=%llu data_stripes=%d max_chunk_size=%llu",
+		       ctl->dev_extent_size, data_stripes, ctl->max_chunk_size);
 	}
 
-	ctl->chunk_size = ctl->stripe_size * data_stripes;
+	ctl->chunk_size = ctl->dev_extent_size * data_stripes;
 
 	return 0;
 }
 
-static int decide_stripe_size(struct btrfs_fs_devices *fs_devices,
-			      struct alloc_chunk_ctl *ctl,
-			      struct btrfs_device_info *devices_info)
+static int decide_dev_extent_size(struct btrfs_fs_devices *fs_devices,
+				  struct alloc_chunk_ctl *ctl,
+				  struct btrfs_device_info *devices_info)
 {
 	struct btrfs_fs_info *info = fs_devices->fs_info;
 
@@ -6077,9 +6077,9 @@ static int decide_stripe_size(struct btrfs_fs_devices *fs_devices,
 		btrfs_warn_unknown_chunk_allocation(fs_devices->chunk_alloc_policy);
 		fallthrough;
 	case BTRFS_CHUNK_ALLOC_REGULAR:
-		return decide_stripe_size_regular(ctl, devices_info);
+		return decide_dev_extent_size_regular(ctl, devices_info);
 	case BTRFS_CHUNK_ALLOC_ZONED:
-		return decide_stripe_size_zoned(ctl, devices_info);
+		return decide_dev_extent_size_zoned(ctl, devices_info);
 	}
 }
 
@@ -6199,7 +6199,7 @@ static struct btrfs_block_group *create_chunk(struct btrfs_trans_handle *trans,
 
 	map->start = start;
 	map->chunk_len = ctl->chunk_size;
-	map->dev_extent_size = ctl->stripe_size;
+	map->dev_extent_size = ctl->dev_extent_size;
 	map->on_disk_type = type;
 	map->sub_stripes = ctl->sub_stripes;
 	map->num_stripes = ctl->num_stripes;
@@ -6210,7 +6210,7 @@ static struct btrfs_block_group *create_chunk(struct btrfs_trans_handle *trans,
 			int s = i * ctl->dev_stripes + j;
 			map->stripes[s].dev = devices_info[i].dev;
 			map->stripes[s].physical = devices_info[i].dev_offset +
-						   j * ctl->stripe_size;
+						   j * ctl->dev_extent_size;
 		}
 	}
 
@@ -6233,13 +6233,13 @@ static struct btrfs_block_group *create_chunk(struct btrfs_trans_handle *trans,
 		struct btrfs_device *dev = map->stripes[i].dev;
 
 		btrfs_device_set_bytes_used(dev,
-					    dev->bytes_used + ctl->stripe_size);
+					    dev->bytes_used + ctl->dev_extent_size);
 		if (list_empty(&dev->post_commit_list))
 			list_add_tail(&dev->post_commit_list,
 				      &trans->transaction->dev_update_list);
 	}
 
-	atomic64_sub(ctl->stripe_size * map->num_stripes,
+	atomic64_sub(ctl->dev_extent_size * map->num_stripes,
 		     &info->free_chunk_space);
 
 	check_raid56_incompat_flag(info, type);
@@ -6292,7 +6292,7 @@ struct btrfs_block_group *btrfs_create_chunk(struct btrfs_trans_handle *trans,
 	if (ret < 0)
 		return ERR_PTR(ret);
 
-	ret = decide_stripe_size(fs_devices, &ctl, devices_info);
+	ret = decide_dev_extent_size(fs_devices, &ctl, devices_info);
 	if (ret < 0)
 		return ERR_PTR(ret);
 
-- 
2.56.0

