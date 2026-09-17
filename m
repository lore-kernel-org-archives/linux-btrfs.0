Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5041B3C1D41
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2026 04:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789617640; cv=none; b=oG3qEgqaiI7hOjmlFt0fW6BPk6F0c6kkRQUmAft1EyXkXlLgZlpDNGZ9ZAXVWWwcvYqrrTCIOLGwaYwMYW7DSGzDmtkzqm484HrAjWwNGc2SpnuMcTePBjLQT/odZb6bfsmyP81w+OiY7hkmYiY+UIfzfJDNui0PpzSQSesDWt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789617640; c=relaxed/simple;
	bh=rulmlM26V12Eg+K7SQZ/FyXPG7ub2C5fYZrfS5dFjSk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=hLe7w4+hHTPggH+hC6OQ5Wt0IVB46Bj6IzaC8MAITqq6hWpSKHGGVQWPNmGLK3r9qHmSK6DaU5fUz0HkBeoPLbGSJoBFbQHFRZ38W+Pq2KrcDJ5CvUyEEc6eXMQd8MsXx8R6rWc8QrY+nZnqH8iadxlWe3GgFG89cxI3d0htJus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=N4PX21j2; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=tjvWHdBq; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="N4PX21j2";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="tjvWHdBq"
Received: from pps.filterd (m0167072.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68H2YA8T1938436
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2026 00:00:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=OnlL
	M7eRN8QFBco+RjUrDttkRnm/OziXiXr6FMqlxo4=; b=N4PX21j2obYubWrVPPsB
	zuABRW6ufw2idxmjZtHD29kJjwn8Da3/iy2SvDqVRV2WkBPrgdadEiTwgpx62428
	8px7Csylle//FJnadPCM7y85oAWuCAFFVUzzGhM2jEIngF3MuO5gT4Fa37locJOW
	8X9Ic5M9FoVHdHPhgVmUWBsEOyJ2XcdND92/+OgEFLim5j6zobLh4TKMMAVCNxxt
	40iSN+pSZqIwV3X/FqLfWzeo1NDZh7bth7AfW5OQtpSPDnNR1XVWHnRsgCQZln9i
	y34owBuKr/MFLyTMH+XvVIJZ1ztnTabzgjllnJyVX5dL8r+1oMfsXBGElB7ICtJk
	0Q==
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gr33qsscj-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2026 00:00:36 -0400 (EDT)
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-90e98e74535so7559406d6.1
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 21:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1789617635; x=1790222435; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OnlLM7eRN8QFBco+RjUrDttkRnm/OziXiXr6FMqlxo4=;
        b=tjvWHdBqwNxDij/8D2hZ1P36ZkEug1Zrhkd3cWMIRP8YeEQB7MUQug5XpuQMcL7FzN
         x6eCKINB8FrTiLx+rRAgcq6FMX2m36par2loW2TBwbKOmLrLkQ7FRyWdsuOUQhfQZ6CT
         sIcviMNgJkOA//86/RrVcnBjuX4uK26nVsInv+oNa05P/IiafG28D8gjQvNRy8N1zc4R
         WXObn1/+hTOofBe39dLSxlAv+qS2d94k2cH09hILyzWRWk3i0piq4qhXa6gZcEd5nOpe
         L0KvA3u+OfzNq3vGKxjYjgaytydBBeQ2nWZwcX21XpGnngEGRduX/vp7OjqRT//rWawW
         mCaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789617635; x=1790222435;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OnlLM7eRN8QFBco+RjUrDttkRnm/OziXiXr6FMqlxo4=;
        b=ln6YNXxSYcj+D5YgIfS3mGTAR09JYOP2eiC8aq+rDrUtwdPKNOwxDfvl07vS5CeAVX
         cVCrOYbun+cve5foPdj101QXO+hsqA1I6pRRIVJq/CsyHNlLcIo9Cf12wjwP4uuQ0xiN
         AmAhpJSHf5RDOVq/oY/I+ly4PAfH/n5B99MfHpUZ+I8pXQllvu7E4bE+ED/P2ELnhXBQ
         3UeGnDVAxsvqQpnIBElhFnc1f5axM4QhXmW1EVjMbBMT/fSXmM3/+d+zee+/w2dyWVyM
         P2HMcfjd/+qy0+AL3ph3apYpdfY5sfgLP780PKjTVweDxJe06Ob6aur0BuzJQdgMZNnR
         1Zjg==
X-Gm-Message-State: AFuF++ngIsw/hMWIuu0Cvoyzh1dhoRD17rQwq33s9R8pHD5VSUXpMvyg
	F9SfSdEYhMQIYsOcSxVdRT9nNRbWkXhtJ7qfvCt6AaPsSrikVkkSF6yxV/pKQfUhDcavegH4f+o
	0XVqRadsH46u9ZIVKeLKRm199RzKpPo5vjxA78x682BCxC4M9llJJvP33tF/Q
X-Gm-Gg: AYBFou0qbfL4zfEtZcXnwyrzpiLxdYkfIm2rdhpi5rhsN1i0vCbnzBUC+67hUuU1Xmn
	m/gt0Z31F2UmQ4OfOqp40kDMydmnFRbKqak/OONImx/Y2qSt4UiPyodtETVCX9TNkvPLlkrKEr8
	ivF6gzC/d8at0Pn74L/P0ZgklekPBSJBihmzO0A1CQ9Nyu80DV9bIKSJWb4vcsRqdJD+WpWR0tN
	Oxar7UpapxoO04r2ucqbyKhI5cnkjBETEnOX2KeyMuLDVceBv8VlyOzOJFWupVrqlUEFbvO/g//
	hGXIcC0veF4CK1Ot19u0GI/NpQq4FrFYEbAFP3X19c9b08jSNBteFZzqw+54BfXLDyT2mkqEGTq
	a0I/xdIMJ3Z7WkbHj70GG7C17Mw1InfVAD++dtETBMmnJ2w==
X-Received: by 2002:a05:6214:5d05:b0:912:127c:d7fc with SMTP id 6a1803df08f44-9123d7dbe02mr118184086d6.37.1789617635368;
        Wed, 16 Sep 2026 21:00:35 -0700 (PDT)
X-Received: by 2002:a05:6214:5d05:b0:912:127c:d7fc with SMTP id 6a1803df08f44-9123d7dbe02mr118183726d6.37.1789617634866;
        Wed, 16 Sep 2026 21:00:34 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9123beadde6sm41748766d6.35.2026.09.16.21.00.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 21:00:34 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Thu, 17 Sep 2026 00:00:04 -0400
Subject: [PATCH v3 08/17] btrfs: remove btrfs_disk_cache_state
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260916-btrfs-remove-v1-space-cache-v3-8-10ebde03b96f@columbia.edu>
References: <20260916-btrfs-remove-v1-space-cache-v3-0-10ebde03b96f@columbia.edu>
In-Reply-To: <20260916-btrfs-remove-v1-space-cache-v3-0-10ebde03b96f@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789617622; l=6238;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=rulmlM26V12Eg+K7SQZ/FyXPG7ub2C5fYZrfS5dFjSk=;
 b=l7I3D8GkAZG1CegWVZXzayXMbxr6vC/8EhbT2Z6HLIO+0T0PevIIqJL7/ypJgaMLOlN7VypN4
 g//yYoyRUMOANUnzbBoVUARDPoqDJoHHtzvo6UQoZtq6IvuWCm4BHvh
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: FrTEGY_MhGPYyE3tkvqBiEHPTJD81EOG
X-Proofpoint-ORIG-GUID: FrTEGY_MhGPYyE3tkvqBiEHPTJD81EOG
X-Authority-Analysis: v=2.4 cv=O72sLx9W c=1 sm=1 tr=0 ts=6aab65e4 cx=c_pps
 a=oc9J++0uMp73DTRD5QyR2A==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=SsB-OO3BMngHh3ZO9fOt:22
 a=-H6kAsrtDIwNne7E0FYA:9 a=QEXdDO2ut3YA:10 a=iYH6xdkBrDN1Jqds4HTS:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE3MDA0NyBTYWx0ZWRfXxqwkncM5p/TH
 aoHriWRj6WLPusr3tfG0X/HBnOAqWrqGm58RLmqbR5vgde2eUiO2KaT4AMl/kNTI5QLZDH+yKhJ
 Htdzsxma3DxA94Zh9CM5EFXQYyh5DbwjvL0XZFBgTjKH5zAgHBCOxCX8K1WTqgG9tuOOUb2UbOR
 T6jJiutxIGJm0Sq4zrhonlsAEMHQdywuB0J+/T5i2rLDGi7LrSICYD8vuAdriBfVBUQcvk5HTv+
 RDha9TwqY9wcYEFI2NI+lLbrU2z25BaLgpLad5i+aLgTCT/cQK0OfvmvTQAYCDF14t2ehU9kxLi
 VYJZtTg+8JFv9KtLnWBCwwY14iygKGXz6bLmhV/9pSFFvRZ/DAsIP1xPUZsviqQKEiQ4jRICLat
 k/hmJmQiZfvCRcYd7T3cdpKAv8LK4OcTWbqRV75K3pLw9wxG8MuwbP7aYdvTxeTzN09JuHK3ccx
 /jnb3wKq3EjK0PzyYxQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE3MDA0NyBTYWx0ZWRfXw3sr74aoKsQw
 yFalyGAoKKGL/v6PnnINcgEgKBuGz75AP1COswrzeNwF3pBO3u/kr6LmGGMoR6kZa9DzFerOoQT
 I06HVfHQ7HB18zq9YFZEVbQnpIRDzYTK6UAOPRopgZNJAZTJUClb
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11907
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 spamscore=0 suspectscore=0 lowpriorityscore=10
 priorityscore=1501 bulkscore=10 adultscore=0 clxscore=1015 malwarescore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609170047

With neither the writer nor the loader left, nothing acts on
disk_cache_state. Remove it, the need_clear handling when reading block
groups, and the enum. While at it, drop the unused cache_generation
field from struct btrfs_block_group.

lookup_free_space_inode() converted old style space inodes by clearing
disk_cache_state so the cache would be rewritten with the new inode
flags. Without that it only sets flags on the in-memory inode, which
every remaining caller truncates or deletes right after, so drop the
conversion too.

Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/btrfs/block-group.c      | 32 ++------------------------------
 fs/btrfs/block-group.h      | 10 ----------
 fs/btrfs/disk-io.c          |  4 ----
 fs/btrfs/free-space-cache.c |  8 --------
 4 files changed, 2 insertions(+), 52 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 972909b52a39..7c5f80f4aa79 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2454,8 +2454,7 @@ static int check_chunk_block_group_mappings(struct btrfs_fs_info *fs_info)
 
 static int read_one_block_group(struct btrfs_fs_info *info,
 				struct btrfs_block_group_item_v2 *bgi,
-				const struct btrfs_key *key,
-				bool need_clear)
+				const struct btrfs_key *key)
 {
 	struct btrfs_block_group *cache;
 	const bool mixed = btrfs_fs_incompat(info, MIXED_GROUPS);
@@ -2481,20 +2480,6 @@ static int read_one_block_group(struct btrfs_fs_info *info,
 
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
@@ -2635,8 +2620,6 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info)
 	struct btrfs_block_group *cache;
 	struct btrfs_space_info *space_info;
 	struct btrfs_key key;
-	bool need_clear = false;
-	u64 cache_gen;
 
 	/*
 	 * Either no extent root (with ibadroots rescue option) or we have
@@ -2657,13 +2640,6 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info)
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
@@ -2692,7 +2668,7 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info)
 
 		btrfs_item_key_to_cpu(leaf, &key, slot);
 		btrfs_release_path(path);
-		ret = read_one_block_group(info, &bgi, &key, need_clear);
+		ret = read_one_block_group(info, &bgi, &key);
 		if (ret < 0)
 			goto error;
 		key.objectid += key.offset;
@@ -3555,10 +3531,6 @@ int btrfs_update_block_group(struct btrfs_trans_handle *trans,
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
index 939d4bfbd4b4..eac794a053cd 100644
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
index f256a91f58b4..881d95080709 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4864,10 +4864,6 @@ void btrfs_cleanup_dirty_bgs(struct btrfs_transaction *cur_trans,
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
index a25c4db561b4..3ba9ed4a39d0 100644
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

