Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CBA23B8D40
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 14:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792075425; cv=none; b=pkL8+ubyEje83sFSbfMMBbJymXik8Uv69qUBbTjK2oBzgRFu9ZxJRjuslNA1wbpEGTAaspf70zx5MlIFUT6gDnGV+NJbv7IqxXMqV36wacKaOiF6wD8gyYpYJfwvN6oZGXW7F4BVdfIJVCjzTwH96ZdrkuWCZwqjJOD26e8n4Vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792075425; c=relaxed/simple;
	bh=1G4dl7krOWg30TXJkog4/6kB/GW9Erf8QFwRG6u7HIg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Z+/Z1IgOzphn2NiTXfBRdg0lo4J4sunhZNTwRvoRnxPQzxdGDxwoXH/dLSnkpzlZS33QDubOJRDuposbJ1YCku3i1gp+u7Kt+eK24IqNkBDOUb+dFc0lmYcIAKhrMfQsFRI/zkaPicqHXfJbYwk96/rQe2ZC4kONw8c8pkfuVyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=qPuAIwiD; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=KQZYqreC; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="qPuAIwiD";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="KQZYqreC"
Received: from pps.filterd (m0167077.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69FEY9XV1419249
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 10:43:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=qv0I
	S5elhCWP4RtfRHTL2aHqZhSGZG1qjkZr0kzFM2E=; b=qPuAIwiDGWNzM3Y/gkva
	07OtWbUtjyTpdNQobIyGOxi6TJmHtFEucfxb4rubIIfeDOVsHnneZrc2GHuxji+3
	b7logI7G2y3jxVY48gnPms6uCwc+ZBezNUezWIIMBv9f/UdgET4btW2dcQOA1GP3
	Djyb0LzuX2DNggVZHPOdpubZj2yWN65ge2T9P/55cP6PTUKOlt3Gyxmv9CvwgtNs
	WIsDgpfD0N/WDuPZocWKz9zArm3osiye4rfLc6M4KGtvi15jxEJfPnN55CihPrkJ
	Wk0mNSK8UnxJBmBnK6zVqCxS+tqDBHBSeS3F2RllmjcSOTKj5A7NR9dNpYbI6/SL
	fw==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4hagkhn7tg-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 10:43:42 -0400 (EDT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-51c26012cd0so109342321cf.0
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 07:43:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1792075422; x=1792680222; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qv0IS5elhCWP4RtfRHTL2aHqZhSGZG1qjkZr0kzFM2E=;
        b=KQZYqreCH8h5GrJgvp1e2ulUVnV7jZbIbr8QKg++9faBvbLI9YGzvE72zwTXVf6eq0
         Es9rpPPdBgncalnVAkBziWGxgAaX5rl+It+yA5CS7lH4tTzjXt7d4yNspWXjuiPJ8I0V
         LC5D9cOn+h//msx0qbspV78iUF27Hfx8WvatwmmWSYuK2dJBFjZeAvPkgCxdcqWsGUha
         pb8SE5NWQVWMClg+gC0Pos2+TGBMyOsD0eN7VFNJ8XK2sWw00jWAWYQG2wFHOmOzFX2q
         VNG2Kr70N9OoDA3dmmhvVDXoJj7DL9fuD5chhmv3F+GxxMj9+MKXND13KlXYPMeljhrt
         bFYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792075422; x=1792680222;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qv0IS5elhCWP4RtfRHTL2aHqZhSGZG1qjkZr0kzFM2E=;
        b=lZxuFfOB0wjCUJMI4qTSiQZr64cOwBC8e/+gcmSdxRuZpnhPioKGhMYFEJ+7r0kkDn
         lXG25CxoHSbHoc1ZI45DGnW+Vu23kUbbdjJjlN8cvD9MefoAyNAt3O8LdxvI3SVh5wQu
         6lxQ0gdxW1JNAHq2pDt882D/MgSM4malKeG24QJdrjwRzjdwIdttK0opVtvTtxgl8zy7
         DTldj53NGXkoYa19tWdzZi2GnvrpyqTLy1FRA36Iift+JrPwYjypwWV8pn8Cd1jALA3c
         IMKse0EI6UT184GpDJ8grVJZ8+MPGK1qRlcruI/gp6l33DaYuFcpwxVLAn2w2SdLNI4h
         rKzQ==
X-Gm-Message-State: AFq9FYIi0/3/d7pYLB4xojyRQFp9WBjsQgLGUFS9EjRdYpbdG+MMY0zE
	DDbsVkIDCZdVUR6lUP0GT9zgl2RYoHhjE3uQqpZ6b0ork7zioVYQFGsNDt2otL0pHzQUBAVU8fi
	fUrf107xoFO/1MjXHfG/HsPr0OP/Ca2Ux34VXHJe2bQUfjqrY02LFsogcIhX/
X-Gm-Gg: AYBFou1Du/9EQ6pf6rTnIfv+ArJINEpKAclJvz+NuGSkGY0kVqm+1WOqaZn/bnIJzCq
	snuHhfnJcd4szdf8/U8UELN/zzbjH049E1royd37rv93fng+jSrSQ0Xt+wquuzwZfcVZk4OqpWf
	Dzqinccdbml3225TqT4pcblD40oSzpHMt+pznFiZ5Wna+J8yur/i7Ng7FI6LR0J04zwoNGzVq3i
	YQaeUaaBp+shmKibVChOM02PAXQ6SxGX49FHuzBkZsE9N9fyH7hZIs96TwwuJUfaoJ2gqZ9Fq4d
	zt1P3Bkk0aDGbTDk9Ss3BvufTn4KjLQcwksYJTOT0/uGNqo+josaY2XK1hxL3KKlo2odAMrrPm2
	LzCILmF0XblwrmdAqm4OExKa8f5f8wZ9d+DHmFghYae52
X-Received: by 2002:a05:622a:13d1:b0:535:4428:6baa with SMTP id d75a77b69052e-5359fb27463mr314764071cf.28.1792075421383;
        Thu, 15 Oct 2026 07:43:41 -0700 (PDT)
X-Received: by 2002:a05:622a:13d1:b0:535:4428:6baa with SMTP id d75a77b69052e-5359fb27463mr314763651cf.28.1792075420861;
        Thu, 15 Oct 2026 07:43:40 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-176-51.net.columbia.edu. [128.59.176.51])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b97b5f323sm83026476d6.20.2026.10.15.07.43.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 07:43:40 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Thu, 15 Oct 2026 10:43:23 -0400
Subject: [PATCH v5 10/19] btrfs: remove btrfs_disk_cache_state
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261015-btrfs-remove-v1-space-cache-v5-10-6b31347d9998@columbia.edu>
References: <20261015-btrfs-remove-v1-space-cache-v5-0-6b31347d9998@columbia.edu>
In-Reply-To: <20261015-btrfs-remove-v1-space-cache-v5-0-6b31347d9998@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792075404; l=6218;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=1G4dl7krOWg30TXJkog4/6kB/GW9Erf8QFwRG6u7HIg=;
 b=6gMaWYqKJblIWicdL2Tma8Xo7+jMDeJIJBktrW3/LG/hTQFIhrhspzDWsziA1+9ozDVB22WcS
 fmv8fKnAUkuBK46kxR/ol0YgaeozwKCaRvahFyojaiSWvdLyMeIq6Nh
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=Upr2pOwB c=1 sm=1 tr=0 ts=6ad0e69e cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=NKoNGjn6KhAaSQkl0TXC/A==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=QOCMdifcju39GKoXhKua:22
 a=-H6kAsrtDIwNne7E0FYA:9 a=QEXdDO2ut3YA:10 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-ORIG-GUID: 8f0g3gqpjOfDFsQGgzK2Oy_J2f0FU4eK
X-Proofpoint-GUID: 8f0g3gqpjOfDFsQGgzK2Oy_J2f0FU4eK
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE1MDA1NyBTYWx0ZWRfX0ggioQvw7Obv
 yoqeprLV7Tiih1nuvMIxVRclhxg1b/Cub0FdMyOdED99m+eQO9BVfaH+L0zQmC/HbQ0EykD6CXk
 lQmgbdRRyPHTT44aw/t8GSEFiEbdLVpbfLMsGYPtB0BtUVclfnR2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE1MDA1NyBTYWx0ZWRfX7rKd514SqVwN
 HQxEmO2JznHEWfJqfh9re7h/LUivnrhkejwoLb/ga3nniR8cp0kQ91+ZuQUFMIUXJ24bgV2Y2yX
 1NXNMxdNiclUksgVULYxZADsi0HHG9ClBegvNWj9VhoabkujRMnGanQuCJo5MlGPB85xkgVcwWz
 DcvLTa10WZdMrWt9Efrx0YekTJM8EbMriKnaKLp4lmY5kDle0PbI7gFt4okMgmqaWbTrtZk4EUS
 CQjpJUAv/xFcUB0EC1nQ+Q7LuGzaJYlfYTzYP/M3vlL0JpGDuaa5ou9B0sx0pjumUt0cVfuCleM
 cxtdKk8tv9BlzlIlGys23iWqU8CFWhheArylgyZG28tke5BkXlUafndn9xg4w3rPCNSXsVLz7CH
 NYeLyduCwUkK3F106NfliIUCke7IYdAsoSUAj7cpKNEAm0UuotNk9QgB9qGYNquNf0IAHywaq/I
 afm/VQPNKwAGLO+WhPQ==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11936
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 phishscore=0 adultscore=0 bulkscore=10
 impostorscore=10 clxscore=1015 malwarescore=0 lowpriorityscore=10
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610150057

With neither the writer nor the loader left, nothing acts on
disk_cache_state. Remove it, the need_clear handling when reading block
groups, and the enum. While at it, drop the unused cache_generation
field from struct btrfs_block_group.

lookup_free_space_inode() converted old style space inodes by clearing
disk_cache_state so the cache would be rewritten with the new inode
flags. Without that it only sets flags on the in-memory inode, which
every remaining caller truncates or deletes right after, so drop the
conversion too.

Assisted-by: LLM
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/btrfs/block-group.c      | 32 ++------------------------------
 fs/btrfs/block-group.h      | 10 ----------
 fs/btrfs/disk-io.c          |  4 ----
 fs/btrfs/free-space-cache.c |  8 --------
 4 files changed, 2 insertions(+), 52 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index a11685440e3c..9a98e291769c 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2496,8 +2496,7 @@ static int check_chunk_block_group_mappings(struct btrfs_fs_info *fs_info)
 
 static int read_one_block_group(struct btrfs_fs_info *info,
 				struct btrfs_block_group_item_v2 *bgi,
-				const struct btrfs_key *key,
-				bool need_clear)
+				const struct btrfs_key *key)
 {
 	struct btrfs_block_group *cache;
 	const bool mixed = btrfs_fs_incompat(info, MIXED_GROUPS);
@@ -2523,20 +2522,6 @@ static int read_one_block_group(struct btrfs_fs_info *info,
 
 	btrfs_set_free_space_tree_thresholds(cache);
 
-	if (need_clear) {
-		/*
-		 * When we mount with old space cache, we need to
-		 * set BTRFS_DC_CLEAR and set dirty flag.
-		 *
-		 * a) Setting 'BTRFS_DC_CLEAR' makes sure that we
-		 *    truncate the old free space cache inode and
-		 *    setup a new one.
-		 * b) Setting 'dirty flag' makes sure that we flush
-		 *    the new space cache info onto disk.
-		 */
-		if (btrfs_test_opt(info, SPACE_CACHE))
-			cache->disk_cache_state = BTRFS_DC_CLEAR;
-	}
 	if (!mixed && ((cache->flags & BTRFS_BLOCK_GROUP_METADATA) &&
 	    (cache->flags & BTRFS_BLOCK_GROUP_DATA))) {
 			btrfs_err(info,
@@ -2677,8 +2662,6 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info)
 	struct btrfs_block_group *cache;
 	struct btrfs_space_info *space_info;
 	struct btrfs_key key;
-	bool need_clear = false;
-	u64 cache_gen;
 
 	/*
 	 * Either no extent root (with ibadroots rescue option) or we have
@@ -2699,13 +2682,6 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info)
 	if (!path)
 		return -ENOMEM;
 
-	cache_gen = btrfs_super_cache_generation(info->super_copy);
-	if (btrfs_test_opt(info, SPACE_CACHE) &&
-	    btrfs_super_generation(info->super_copy) != cache_gen)
-		need_clear = true;
-	if (btrfs_test_opt(info, CLEAR_CACHE))
-		need_clear = true;
-
 	while (1) {
 		struct btrfs_block_group_item_v2 bgi;
 		struct extent_buffer *leaf;
@@ -2734,7 +2710,7 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info)
 
 		btrfs_item_key_to_cpu(leaf, &key, slot);
 		btrfs_release_path(path);
-		ret = read_one_block_group(info, &bgi, &key, need_clear);
+		ret = read_one_block_group(info, &bgi, &key);
 		if (ret < 0)
 			goto error;
 		key.objectid += key.offset;
@@ -3597,10 +3573,6 @@ int btrfs_update_block_group(struct btrfs_trans_handle *trans,
 	spin_lock(&space_info->lock);
 	spin_lock(&cache->lock);
 
-	if (btrfs_test_opt(info, SPACE_CACHE) &&
-	    cache->disk_cache_state < BTRFS_DC_CLEAR)
-		cache->disk_cache_state = BTRFS_DC_CLEAR;
-
 	old_val = cache->used;
 	if (alloc) {
 		old_val += num_bytes;
diff --git a/fs/btrfs/block-group.h b/fs/btrfs/block-group.h
index f7346a0170fc..d567ed822e55 100644
--- a/fs/btrfs/block-group.h
+++ b/fs/btrfs/block-group.h
@@ -20,13 +20,6 @@ struct btrfs_fs_info;
 struct btrfs_inode;
 struct btrfs_trans_handle;
 
-enum btrfs_disk_cache_state {
-	BTRFS_DC_WRITTEN,
-	BTRFS_DC_ERROR,
-	BTRFS_DC_CLEAR,
-	BTRFS_DC_SETUP,
-};
-
 enum btrfs_block_group_size_class {
 	/* Unset */
 	BTRFS_BG_SZ_NONE,
@@ -131,7 +124,6 @@ struct btrfs_block_group {
 	u64 delalloc_bytes;
 	u64 bytes_super;
 	u64 flags;
-	u64 cache_generation;
 	u64 global_root_id;
 	u64 remap_bytes;
 	u32 identity_remap_count;
@@ -171,8 +163,6 @@ struct btrfs_block_group {
 	unsigned long full_stripe_len;
 	unsigned long runtime_flags;
 
-	enum btrfs_disk_cache_state disk_cache_state;
-
 	/* Cache tracking stuff */
 	enum btrfs_caching_type cached;
 	struct btrfs_caching_control *caching_ctl;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 4056ad1ab728..82b3b4579880 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4863,10 +4863,6 @@ void btrfs_cleanup_dirty_bgs(struct btrfs_transaction *cur_trans,
 					 dirty_list);
 
 		list_del_init(&cache->dirty_list);
-		spin_lock(&cache->lock);
-		cache->disk_cache_state = BTRFS_DC_ERROR;
-		spin_unlock(&cache->lock);
-
 		spin_unlock(&cur_trans->dirty_bgs_lock);
 		btrfs_put_block_group(cache);
 		btrfs_dec_delayed_refs_rsv_bg_updates(fs_info);
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 1e2fc2884d07..e82216ebd5d0 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -124,7 +124,6 @@ struct inode *lookup_free_space_inode(struct btrfs_block_group *block_group,
 {
 	struct btrfs_fs_info *fs_info = block_group->fs_info;
 	struct inode *inode = NULL;
-	u32 flags = BTRFS_INODE_NODATASUM | BTRFS_INODE_NODATACOW;
 
 	spin_lock(&block_group->lock);
 	if (block_group->inode)
@@ -139,13 +138,6 @@ struct inode *lookup_free_space_inode(struct btrfs_block_group *block_group,
 		return inode;
 
 	spin_lock(&block_group->lock);
-	if (!((BTRFS_I(inode)->flags & flags) == flags)) {
-		btrfs_info(fs_info, "Old style space inode found, converting.");
-		BTRFS_I(inode)->flags |= BTRFS_INODE_NODATASUM |
-			BTRFS_INODE_NODATACOW;
-		block_group->disk_cache_state = BTRFS_DC_CLEAR;
-	}
-
 	if (!test_and_set_bit(BLOCK_GROUP_FLAG_IREF, &block_group->runtime_flags))
 		block_group->inode = BTRFS_I(igrab(inode));
 	spin_unlock(&block_group->lock);

-- 
2.39.5

