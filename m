Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0414E2EEE92
	for <linux-btrfs@vger.kernel.org>; Tue,  8 Sep 2026 01:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788830408; cv=none; b=TegE++qbhCAE2THaHUErQL+nMQCiApoJhYaFMJpCZKYGFjbmnp5wam/abQh9Wh6FphFZ/Ho/WUQV4hJ9Xh3HGf6nOwzNP+o/nbha0Z4sdpOLcqexCOSl2WlLKOOuFmpb4YdQ2tcj/ktFC2TO77OONMPFc4CNxFDeP59+y/Bhwso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788830408; c=relaxed/simple;
	bh=cE1MY+QR9iC20Pf8qIeMitWSw7Yh6AG3T3QMGQ9WnS4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=BrLZch0xPXogXHdxYKMyHIaNM0rqp2dHTbdBUnxo+0PYArjmxT6yTbww/e9+9LM8kQ8c9nVg1iG2pROcx+jUiWSEWGk6UZJgAW3otDIB/YikdAmWsz/MFzEn7zez8gfTsV0c2SKq3clnfqFDgFhqdG0kbjscCV8tsIIu+voolkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=oKFfsaXV; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=2JUgJjKl; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="oKFfsaXV";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="2JUgJjKl"
Received: from pps.filterd (m0167068.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6880uWio4105008
	for <linux-btrfs@vger.kernel.org>; Mon, 7 Sep 2026 21:19:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=VhNn
	j1S4XIsI2rJ3RnkMhf4wAu+3j+XovVvQFH44tpQ=; b=oKFfsaXVFMoPvGbzn+b3
	0iZfS/ggTaIud2+GHtcP50eJRaihVui+Npt8rV2/D9S/pLvgFKZJx5pydkDLbU3M
	nIRHKCCnZD/p+pnw/06gLGIUgwRAyrNecTN6RZ+4Uu8mTIblai8IVopbvowFtzVK
	0SKPy3FqL6lTEKoI6yqi8QT/3fnZGtfxaNLg78uqFaopl8OfGwzyFX+uLEcyNvLy
	NCPBpn+rXKeZ65KYMw74lMJlTTRwt9BF9BuN7BJv2jW+u0S1wrW5uC1JwmPDJgfd
	0Ni0Blb7IAyanlsrmrmY/hhOzUKju7ftQl6IzypDL9pfcUbRJRrLi59cvkV9ipB9
	VQ==
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gj3ga9fa8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 07 Sep 2026 21:19:57 -0400 (EDT)
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-90c8da50f4fso55727436d6.0
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Sep 2026 18:19:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788830396; x=1789435196; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VhNnj1S4XIsI2rJ3RnkMhf4wAu+3j+XovVvQFH44tpQ=;
        b=2JUgJjKlOc1K2HKdKMeJaMjrRCkwQ+w8mGtOX1JvymRqLQqeS8zDeVvbLZUfm8Z9Mw
         d4nQzXWepzXhbPXF7tL0Iuv8CpVNv8j5NXttt/ZHfhUdWi79GrYMGs8gcC6a3IdoqnhV
         IPcQ0xBAtDOMJjLQ+kn1I7LAXRR5lb7Z+4yG0Ma+vZaRjGuYsMUp9h4SCJXaMRISLYp7
         +SOD2xi8RamoxGbPKE1HO/uA1IDe6U4U28/HRCrc5hEYVQ4JVMHKGcx5UkPmUWV0nLyc
         F/+rS8XVQJMdVJmiOVw1hrXIA6vJHqI/2lwJcD1DuBg9L9teeLzoPOsinsN7nKLCPH6K
         OXRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788830396; x=1789435196;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VhNnj1S4XIsI2rJ3RnkMhf4wAu+3j+XovVvQFH44tpQ=;
        b=Xulck9vwyX5r+2sD2I/PhMBu0aSWCR9aaTbeKWyKWQqNpXr0ztGJAI3CVi11u3lOaq
         dRpxsACWpjIMqCnXYcPrWcHetogQKNCRUoskZWQQYoQyFNyU8HxHOZaci5QFPvo63ey7
         +jz4IjTRm/a4+QI/XX+zH/YAS32ZncNY1AmZ6VW79eEeoLl4QLbvfmZGaJkV4Wf3mrwI
         w0GCoPvPceHN4fkidhJ9Zgwq3+QjA7QNt/zXvnGGZ6uHYgrppR1OhTtqwpSw9DAi2Q3d
         KcTT/s0y+Ew9+kbbqcxtLnQ1W3S2I3hGRYb8QTgWRJH5/ukdebaBZQ219zqktiF3itfG
         rmLg==
X-Gm-Message-State: AFuF++lCnTgeKWfe/OyHxqSDMJbzhf5JUX07DDZwhszGZ3UqELEe9TW4
	7j4r34PBq1+KN1xeuSO05YubMFSqew0C1uck/1YzorAZcZZ78yhazX4swmYpgtVHG3GL+3MHU4F
	ZSdCBppKqqckQgdtzxnZtyCdREh4kGTsVRCxvA4bCJmu1INc5N1p2NCwzv9Xa
X-Gm-Gg: AYBFou0CObiv3bLl/f8NUKulxXStL60vQj0FtfO1KXUwhP+a7kzG7koVHO/92N/kP/e
	ANMy9r9Du88QsjZjgfI4m7ZN75pxcobM7oyt9gs/qegzTcujp1MBK5+0ZAxqzzgaAjPqzG+7+nq
	xuu3HdyWkMrC8P1hUGHgu8vg8Q0SCnM3G/xMxCQBnbDx9Dg/UClRVNjmXZdXQ/ztr2dtU68PeYx
	zhykggiY125WGNoOPGy8/P1bWuPXcP/u4VSNuv9dnX5ZoIPTSZLdqnfDQrMRDe5myW/rLOq62zd
	nAfe0I7qaaFcRSmbQjpDVpBnijZlT2CgZT7FqZQzwhDXuvnch2xgXTV4utD24AldngGXUioGF7y
	iTsu2QcA+3+az51T6Sla519/m4+TLmYDFNBh3nAx3SCZ9dNlUr8U=
X-Received: by 2002:ad4:5dc8:0:b0:910:49d1:3a8a with SMTP id 6a1803df08f44-91049d1469fmr218429656d6.21.1788830396621;
        Mon, 07 Sep 2026 18:19:56 -0700 (PDT)
X-Received: by 2002:ad4:5dc8:0:b0:910:49d1:3a8a with SMTP id 6a1803df08f44-91049d1469fmr218429116d6.21.1788830396139;
        Mon, 07 Sep 2026 18:19:56 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91040694543sm104322656d6.33.2026.09.07.18.19.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 18:19:55 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 07 Sep 2026 21:19:22 -0400
Subject: [PATCH 07/15] btrfs: remove btrfs_disk_cache_state
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260907-btrfs-remove-v1-space-cache-v1-7-5f9a5ba352a7@columbia.edu>
References: <20260907-btrfs-remove-v1-space-cache-v1-0-5f9a5ba352a7@columbia.edu>
In-Reply-To: <20260907-btrfs-remove-v1-space-cache-v1-0-5f9a5ba352a7@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788830387; l=5421;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=cE1MY+QR9iC20Pf8qIeMitWSw7Yh6AG3T3QMGQ9WnS4=;
 b=wsrjBGTuntL7ewV8VRDr7/YUlMTyX6fxajnU0T1dEgF/7uUMV7LOd1Yx3RE+bIsQ94Gt8BWm0
 bs876ymPH40D6A9/YIAig8t0QBdNeh9D40nwAjm/3wb7Svkx56ZIDBO
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: pepCFn0a0anhmULrOgFP4cz4A0JyZ5dy
X-Proofpoint-ORIG-GUID: pepCFn0a0anhmULrOgFP4cz4A0JyZ5dy
X-Authority-Analysis: v=2.4 cv=C7vZDwP+ c=1 sm=1 tr=0 ts=6a9f62bd cx=c_pps
 a=oc9J++0uMp73DTRD5QyR2A==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=usPcmh10W0ubT8QP8_c3:22
 a=CrexS6knh-isOgJd2j4A:9 a=QEXdDO2ut3YA:10 a=iYH6xdkBrDN1Jqds4HTS:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDAxMSBTYWx0ZWRfX+qGwBdTooLYW
 5KlsmKetdBBqpEFGfoaoEsNbvXheR84FcXxRFHew0k07mJ4Zbhc/j/S8Kwc20wPh2RNn7b3IxbK
 L+DqN/NSSfIU5HVT4UzeuvTMX5G6qNYTT2pk/5p9bgA3RsqpPlYv0TaTG7JhxK+1w1QpbiTDktS
 x8Ic6tD/bvR1gH1Y62Wi6+JNq1XuVdMQ85P+q+7vNEqklmq6utQRx2q83p8iTjkZpCBACNb91uY
 WvXrh2tfC8wm26EJYZvkYeBIq9Nssuj6qPCchCWLbhO7qr9nJ1L8uqN2wPqCkYguGu/5NrvcRa7
 eaeGdD5hdR9Hvep0pIOqACvX41Ele+Yibtc6e6/ytGZcVKm9V2g7ho5PA1XCNP285ZlP61dKGY6
 5Z1rk3kOgsoLPEQq7GJtjy3NpWvn9v6Oo/nljK3Lgna7oIkLcKngOTytNaIKavjj2LVWeGkNvzs
 5NkMXj+bIcQELm1XKmg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDAxMSBTYWx0ZWRfX3o5Gxeq+t5m/
 ILSemoJ7IhB/18TKXle1qRQ+ntBIZtymThptrIRaNmYq6kNyQsvpFh1HhoD2k0/j0qgagMG8ZMB
 oROowdaRRHlq/EprX3XuDBAWggAdCpsrr/CEZuXekQSsMjai7ARs
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11899
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 clxscore=1015 phishscore=0 suspectscore=0 lowpriorityscore=10
 bulkscore=10 impostorscore=10 spamscore=0 priorityscore=1501 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609080011

With neither the writer nor the loader left, nothing acts on
disk_cache_state. Remove it, the need_clear handling when reading block
groups, and the enum. While at it, drop the unused cache_generation
field from struct btrfs_block_group.

Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/btrfs/block-group.c      | 32 ++------------------------------
 fs/btrfs/block-group.h      | 10 ----------
 fs/btrfs/disk-io.c          |  4 ----
 fs/btrfs/free-space-cache.c |  1 -
 4 files changed, 2 insertions(+), 45 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 47d48b4abf17..cc8207b028fa 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2448,8 +2448,7 @@ static int check_chunk_block_group_mappings(struct btrfs_fs_info *fs_info)
 
 static int read_one_block_group(struct btrfs_fs_info *info,
 				struct btrfs_block_group_item_v2 *bgi,
-				const struct btrfs_key *key,
-				bool need_clear)
+				const struct btrfs_key *key)
 {
 	struct btrfs_block_group *cache;
 	const bool mixed = btrfs_fs_incompat(info, MIXED_GROUPS);
@@ -2475,20 +2474,6 @@ static int read_one_block_group(struct btrfs_fs_info *info,
 
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
@@ -2629,8 +2614,6 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info)
 	struct btrfs_block_group *cache;
 	struct btrfs_space_info *space_info;
 	struct btrfs_key key;
-	bool need_clear = false;
-	u64 cache_gen;
 
 	/*
 	 * Either no extent root (with ibadroots rescue option) or we have
@@ -2651,13 +2634,6 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info)
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
@@ -2686,7 +2662,7 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info)
 
 		btrfs_item_key_to_cpu(leaf, &key, slot);
 		btrfs_release_path(path);
-		ret = read_one_block_group(info, &bgi, &key, need_clear);
+		ret = read_one_block_group(info, &bgi, &key);
 		if (ret < 0)
 			goto error;
 		key.objectid += key.offset;
@@ -3539,10 +3515,6 @@ int btrfs_update_block_group(struct btrfs_trans_handle *trans,
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
index 1cd44a5c193f..4ce07657d2ab 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4877,10 +4877,6 @@ void btrfs_cleanup_dirty_bgs(struct btrfs_transaction *cur_trans,
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
index a25c4db561b4..57991a413f82 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -143,7 +143,6 @@ struct inode *lookup_free_space_inode(struct btrfs_block_group *block_group,
 		btrfs_info(fs_info, "Old style space inode found, converting.");
 		BTRFS_I(inode)->flags |= BTRFS_INODE_NODATASUM |
 			BTRFS_INODE_NODATACOW;
-		block_group->disk_cache_state = BTRFS_DC_CLEAR;
 	}
 
 	if (!test_and_set_bit(BLOCK_GROUP_FLAG_IREF, &block_group->runtime_flags))

-- 
2.39.5

