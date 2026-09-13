Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE4D3921C6
	for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 21:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789334499; cv=none; b=sFH5qCkJVPvuf3HXrginMNnCtR1b4fqDRTj1y/yGxWyEYSlB8tSJ43t5M1xS9tDeM4smTTtmEE0N1vljwXBLaYpe8k0c+ew97o7yhQBvBMUqAKVQaNce6+DfmrNThMuNJ5EcA94ldI5cjihIxtIL9RSBNGeTXOOBGOugZljeTDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789334499; c=relaxed/simple;
	bh=HdeCUQk+ecGhJfYRWqbSdat+3roKzCrHRSLpkYGjVNg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=TCSG9AWOYLHSLGh4AOgTU/5lDEbBRW88wNidv2Pu50TtAdk9Oobvhf9NrKRObHQzZDOvlbDgaQPrBxdvb4Povnq4DsbaFQukYChAJC4FPtCqBdoPJteetecRd0wK7mL+0uF81VKbsHbUyDbiJgk1QgEHLuImTh3kG9x7+FCIo+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=dR98ATwI; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=UXCygE8+; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="dR98ATwI";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="UXCygE8+"
Received: from pps.filterd (m0499198.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68DKXj7s1191478
	for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 17:21:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=lCAz
	fzDZ4UxiQ0/InC3dh+MEBGzJ4Gj38MBd2fo6ivs=; b=dR98ATwIJ6CwIp9Lxczm
	AjyP+IM3q7qES8EKLD2frMYhJ1G3264boXAJU8JyPVdB/LLEMuv8630SWaQEilS/
	uB80mWJQ47/mKjk97EpGMmjBEVCWI1f3jv9HtSL0F/lo8ljtkuAOo3WLAQM+6BNi
	8QdUvoRvQJpAzYVcfo4W6S15BWOSTDl8ews6zBWva/DIUsI7HZh6ljm73p4rABG8
	UtxJSEPnO+2oPNTPHmrn1zCuPmeSJOwCasUbNXN9qoEAsJI08iv6VwlGZZiQd/dG
	FSYnyRE9OJzao2YTiTbSGRusqYgut7CA3F7SttWAtrp0hciDUrH0IgpZJEl8pYqM
	UQ==
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com [209.85.219.69])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4gnqqt2s1e-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 17:21:33 -0400 (EDT)
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-91051512080so45654376d6.3
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 14:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1789334493; x=1789939293; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lCAzfzDZ4UxiQ0/InC3dh+MEBGzJ4Gj38MBd2fo6ivs=;
        b=UXCygE8+JSkhnwDPLiyJPjoUbqp/de64qWpIj3JKAl1ivqF4J+uS4xW7q0U8WdAUHf
         zZpjNVthfeXtfxz6vEKph0cHSlzCHTYJxT3mFuel2gldVjvhofL4KAGFTIpZL9XJ31yt
         1sm/ZCYzm1r0XgvNBQZ/+w/K75iw4dcYy0Rfot4yjnXxc5l+zro5SQTewc9oAc+KXbU6
         46sExecr5GUptoWvb9h/9SfJ19RnZ9OwR18cz9ypISt+WmCMZBMCxXEpSImxJl0w1Sf4
         8byxnid71oX6MEyxNyozXVnV7SXeV+ZKpYpw6UGkcKAGoR79FH8O9616LV/qV4QKMXLg
         Z65A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789334493; x=1789939293;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lCAzfzDZ4UxiQ0/InC3dh+MEBGzJ4Gj38MBd2fo6ivs=;
        b=KOHidLY4LT1SHDbqd7G6r6oFnnQ3fHi7g36ci7KzeoSw162HzStU4Cj0+pwZ5vqqzr
         FdIyJXAVpYpGQlSTazo4RlJ7xuaQsn8oTghHi43MbYMl19Mi1A5lwsV25tCwgppe9HJP
         9jwN1s4+LHLrRpv7jYhBleogl5rFj3P2HkRhBIZT6vYS4S0IMhZ5jCdQjHbxW/8sTZf9
         qh/IBqXHiwItVtYG9TN96XiWjyIQFPKeJlcHHDhzpT/H8S/C7P5ibY2NBUiLXhTB57m9
         vSNCM+TVBETnYZmmfUcLJTklaoY2CjLmPCvtv7D2j3Dv++/s5uFuUVIOlM/1Mw4H/HSR
         KZww==
X-Gm-Message-State: AFuF++k9Drn4t3HNRzuxv7TVH4b242SXC3n/iVWcgjvQAHCznhoOBx37
	hbdJ6CTwNyFUoBdPMfF0uup7qbWLcEojKpFEzcz+ZfNZdsYakDnZlk1ebi89cKpqw6kvU9qmbyR
	toP9Gx8DQ0XBk/i9r2DApPnYR+s7QDYjFdP2p8baGg4U413x8gwDD7yXTQ1zT
X-Gm-Gg: AYBFou09ETi8VhtyxUUwxXzbFIh9/E6xbodktPWXlDxj8HN+XRndRpqz6SQcOUP4qwA
	qTE4NQWBQE61U/sM7zGx4E2/kjhs+80s7sofExK2DIVdZosaWuNjGW+daP4QZzcdyld9oQBLhVx
	9JAmOLM34kNnPmkOAzrxAyHH9rRwb6e1WRtb0YaoR78Z5tFYGPTJYge+NK/g22Q+leoogNKnCYc
	fH3mJu6hiys8Hdx3t/A6nOWX54tcQSyoTlhbYBQMVGCTJBVMimdHYyhzzOh56ka0uBqoLr0bK2n
	PUyehB1ugz1qtlELpwKP00Fkver5YfoTe2hg2OrTvql2HdlZ+wneJ8zK91uoFVyE5W5yVDtON9z
	r9fF/YtNUO4kzFkcH/la/XG5CPhp5R0gQbrxHwWKPaYfku2X5V/0iSw==
X-Received: by 2002:a05:6214:3d99:b0:912:bd1:49f5 with SMTP id 6a1803df08f44-9121d8efdf6mr128348976d6.10.1789334493353;
        Sun, 13 Sep 2026 14:21:33 -0700 (PDT)
X-Received: by 2002:a05:6214:3d99:b0:912:bd1:49f5 with SMTP id 6a1803df08f44-9121d8efdf6mr128348816d6.10.1789334492878;
        Sun, 13 Sep 2026 14:21:32 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-179-215.net.columbia.edu. [128.59.179.215])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120f4d3a50sm78432696d6.40.2026.09.13.14.21.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2026 14:21:32 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Sun, 13 Sep 2026 17:21:19 -0400
Subject: [PATCH v2 07/16] btrfs: remove btrfs_disk_cache_state
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260913-btrfs-remove-v1-space-cache-v2-7-186767a7e106@columbia.edu>
References: <20260913-btrfs-remove-v1-space-cache-v2-0-186767a7e106@columbia.edu>
In-Reply-To: <20260913-btrfs-remove-v1-space-cache-v2-0-186767a7e106@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789334484; l=5421;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=HdeCUQk+ecGhJfYRWqbSdat+3roKzCrHRSLpkYGjVNg=;
 b=M6LmKrgNlr9shNqT6BX7WO0hUIabaX4460JVgsXyjTkBg7iDXhCj2dGrRzEcXzvI7+c2iob6N
 gdSFc56tizFARWpa6b2XaJRVY4AKtmgZbdjWbjoEfQC1tEZmT0CU/wE
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=N8y8hG9B c=1 sm=1 tr=0 ts=6aa713dd cx=c_pps
 a=wEM5vcRIz55oU/E2lInRtA==:117 a=2jelXx5xVcRIF5zNctN5Qg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=BpGzv1V74M3SfeTrGa8v:22
 a=CrexS6knh-isOgJd2j4A:9 a=QEXdDO2ut3YA:10 a=OIgjcC2v60KrkQgK7BGD:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEzMDMwNCBTYWx0ZWRfX1scnnUsxBuJi
 sZ4KjVDk3NTxJkV0cOoNUG7df3CfLOGknMHYF0yIDEjbBh146kqfs4FSshAhVsMBJv27FkS/+63
 o8bJHVnesW3Zp3MSLCbRor6a9W7Ov2UJvUw4ShUsDn8wvF3in82w
X-Proofpoint-ORIG-GUID: NU6xjB9By4gSCfYmQmYMW8t3BO3oyH72
X-Proofpoint-GUID: NU6xjB9By4gSCfYmQmYMW8t3BO3oyH72
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEzMDMwNCBTYWx0ZWRfXyrk5SdJUeB0e
 BfBsusDTRNRj8KOpAZ17CGzIOmrW8/Rg/0kuXd3MMHnCo56JJ+4GeeFYWPZqVwxOsRCgWH6xlS0
 oiIMXGWRCkomXrywkuTmbij1typ7uCQUpXlCk1Sf8fOTM6RpIvp5FE1kjrnkRYrCveYygUoMC4o
 l/XIGM1vWNqLWRLc96mNy5wf9GehFDLr8Qt5POY91RnVkQ+9ki62lsfn3jOp5Y2CxU7goWuw6P1
 ngcpMnQpPSbnQ4cT9FCCH2EnBJYUcY3IvgadNigShfNyrdBr+8aqzznxhfPHqVq/ud/AZIfUnjj
 ZsYM88EcKP8N4dSJ1/hc51JoBqXI42KBI3Wr059slYC8smkeqf2iyjW8rnxuxgoNi30Q69Sesp7
 aMSPJkvCUWTze7zQanSCEmj0Lb9eZ3JbWMa8b23tBfSXFez8XbaoV9qgIXCV1kPxa7PsCg/lNuK
 IAGTaGHpsvYx6mSmb2g==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11904
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=10 spamscore=0 clxscore=1015 suspectscore=0 lowpriorityscore=10
 adultscore=0 priorityscore=1501 phishscore=0 impostorscore=10 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609130304

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

