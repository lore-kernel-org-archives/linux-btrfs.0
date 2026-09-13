Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5285038655B
	for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 21:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789334494; cv=none; b=BNra6S12HuNiVAExItQU6Uv7JgzcoQI1HXh9AaXKLXAYF0ZqIoQ7UUomNOANAeo5/aUPorb2BMTpLuaY8Poqq8nBxFcoaPvhRU0voxyyxtCI12uTg/fWl+zi6cd+kqgYT9XH8EQGugCEpfQ4I//VQ4zPAINFHNPrB8Z4O4xYFsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789334494; c=relaxed/simple;
	bh=iYy4WxMcz/YHrl99boX04beNvLAWKmxd+zXgrgEEPaA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=tNBJLFLDia8IQE4vyYtCJz+TQKP6uazJFQUbsxj5WrtkIAoaSdZ22ldgBtg4Df0OQvgdWgQOivzV4XQki/qaakaspNONXzKvhOs4gUNYtYEm5H9Nl7pJxxoEwckU30/Qkr/E5mI/IePQ2Xwwx9tjIGvjDsmcK7IWKOV9sBJL3ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=kJOjF94G; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=381MI48+; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="kJOjF94G";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="381MI48+"
Received: from pps.filterd (m0167076.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68DKXd4T646652
	for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 17:21:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=xEFZ
	MPyLnIooECi5s+6fgH1R/MlB033qsGA9CrfjzEw=; b=kJOjF94GgT3RXu0fR/HW
	snc6WDzwpBuixL2diWmPaM+HawGv00ptl+5OFBjLSygZUnJDy9sojBrqXDpxld09
	rFoUPQtHjQZjWdedYy7G78mg15Kv1ntTHXreKuek4De3wX9C1ShqusLN7LOetf+3
	W96Dkpjz0BlQPl3BtC2iMtlO4TU8YbGrMNQ4roIE1/f6AFeUiUKVLCzhcf778tiq
	m1uscWVHW8kBc4n8DylGEJ4GfIwn34OzScoKz+4wPvf8WtaltNamQbltwvtdJo0E
	H1BQE9z6YTkGCHe3Q2Rc5K9M0jqWadV28Orktezmpa62XSzJeZ7uCLnBWVxGvAPs
	FQ==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4gp0qmgpvs-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 17:21:29 -0400 (EDT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-93a0b66ecd9so143722885a.2
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 14:21:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1789334489; x=1789939289; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xEFZMPyLnIooECi5s+6fgH1R/MlB033qsGA9CrfjzEw=;
        b=381MI48+UrRvmKP8CuY0aC5MtIhNgDutLdhXuqDurmUG+0pmHqcIRp3RpeCPpY38Qe
         2nDp5piT/rST3EtOrrO4vyf2C8OXYO3m5M2+j0DnqbKx5JiwClw3jprcB5u6ccrLac2H
         eNvIqs/pplvaz5jqM+rJzsrMCG16OFrDhgy7ZI2czQwIiOpYnBIgKRAoQWKelE2vjBX1
         1w8IA7uu4PMrFp39xBu2P3Ewh4QfBkDQaux6M/YyB5lk+wi1vyBjkdlY7s/3Ri+gOVF6
         dQPTbQTJF2mej/DoFO+9E1XnuH31c/K6N1xUEbfoh2oZ0QPa6TolFoo5pnFdRIgCJfkF
         d3Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789334489; x=1789939289;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xEFZMPyLnIooECi5s+6fgH1R/MlB033qsGA9CrfjzEw=;
        b=j6zwke0yJl/Q34MbkIpZl4aGr8v+fzqjVxUpYPXK+WCJJQnEnbYxP4isNSENYm4uZd
         W2BsrwUzYI7gzsLXQZNtOz/56Tqdgy+byimjHbLEKuL04hrCEJvNEC8aUAmCu/BXcUyh
         rsfy6gCC1dgqCs6k1ndolidZufCT4JwqialV3kuIGpJ8qmdqcI/r2tYlVrWb/6GFWQzr
         IdsbD4RHcE/9M75pvQ4XAL0vpikXnrr1gAfJc7t2s7CfHDe8yF9LLE99ZQh7NJSWnxek
         oTn2UkCgnfK7ZiNg6V2SLqkgpXCfunUVfkM/GdEqpL4GhItQ007hDIPxQ9xtyYCabVtK
         a5Ug==
X-Gm-Message-State: AFuF++k1q/cPEJRNSdtqVmy+KbLzZMC9pBip2uzj1d6gbY3sa9JP3FwM
	UcItoCqazw7XpRayTmPYheGz2m5J1iNGQes10OlPPhvwcgs1VZs5edHWpXCN+B0VFnjrldQXO1Q
	tVaG2ESDCbOsnlon6sBmdbWoJoYh3GLsVsWvvErXfj5c1TnbZpikWvd3zuLzZ7ZqRqNROWaU=
X-Gm-Gg: AYBFou2Lym7fp67XW/hINnMWg/PuHqw6v9Rfm2kvZgBQt/tZ2PtFv8NTXM1xclhrdUT
	uhZXwOqfuQGghAH9JeeefTzh4bYHihbl8huc6wplKQVMrM8YXFamLd/zKbBaEt61gnXo3MzZlaa
	yTorZgOAIs77SYr09/tx/Xh8A6Vk3y5YyzIPyKtunkL571UHbbyjT1ei15NYy5tTcTXT0aNvZ5Q
	oap9bQGUUYSFZ9qiGD0sNIkgCJj3LXMHIC3CRGysMRb1DB5KtZo0JYT09BjDsEbXeTL7DNyz+Lc
	xGUJ7i+Dp9EynAwzt2cCPekaPufM//WhHdJL1a8NiN+JVCY7/b0sFsN5I06PpgotCuv1eAUU+dp
	DgakVLpgbhFa3UzRCK5830UySpOylKRaCtJ6ea9aohEMErYOXRzLhTQ==
X-Received: by 2002:a05:620a:4150:b0:936:af9f:4c30 with SMTP id af79cd13be357-939ea16abecmr1725635885a.25.1789334488804;
        Sun, 13 Sep 2026 14:21:28 -0700 (PDT)
X-Received: by 2002:a05:620a:4150:b0:936:af9f:4c30 with SMTP id af79cd13be357-939ea16abecmr1725633085a.25.1789334488173;
        Sun, 13 Sep 2026 14:21:28 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-179-215.net.columbia.edu. [128.59.179.215])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120f4d3a50sm78432696d6.40.2026.09.13.14.21.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2026 14:21:27 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Sun, 13 Sep 2026 17:21:14 -0400
Subject: [PATCH v2 02/16] btrfs: remove the v1 space cache writeout from
 the transaction commit
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260913-btrfs-remove-v1-space-cache-v2-2-186767a7e106@columbia.edu>
References: <20260913-btrfs-remove-v1-space-cache-v2-0-186767a7e106@columbia.edu>
In-Reply-To: <20260913-btrfs-remove-v1-space-cache-v2-0-186767a7e106@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789334484; l=23733;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=iYy4WxMcz/YHrl99boX04beNvLAWKmxd+zXgrgEEPaA=;
 b=vvMTzc+mB0nVXxXRR3u0kpMMrOqco1asCMkV1KRj8SoBzl431S6hCko9eqIIE68sDS+Ocpeka
 bHxU7OwFuGrBQQQMMJM5rNlIntiwUcP7FiSOPB+ZZAfQXC06EkAdzik
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEzMDMwNCBTYWx0ZWRfX+L3Ax7WvhK1Y
 UEf/S2q0e0wyLH8p3aNxDsVO0CgofVEgsIHTaFuNRLQzY8+yYtoRgHsWl0sX7ojKfqE/mX5CsOg
 lT397kOvclYR8n+aFk5NqAGVMxlTwucZVfj6AF3/P1CaxzRrb3za
X-Proofpoint-ORIG-GUID: 6JaaTZoQAlfXKJDjK1Gw30KVi554yhLi
X-Authority-Analysis: v=2.4 cv=EJ6TQFZC c=1 sm=1 tr=0 ts=6aa713d9 cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=2jelXx5xVcRIF5zNctN5Qg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=Qm0qsxP7aFY2tkT6R2MF:22
 a=_t22J9a6CU8Tmy3Ye64A:9 a=QEXdDO2ut3YA:10 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEzMDMwNCBTYWx0ZWRfX7sh2X52YFFE4
 V3Gv8Q1gbOVKN+8GvwqWKGtSST2HtU060Mxkh4Rv933nUpzmyp0ix7ZLFHcTmmhJOfQLlL+ijsp
 4he1I/YNnRJWuYqPuOd46IKVCVypHex0UkX5NbkrOYKq66+fHl1xfc0uCOWe8IrtKb7UVEJX4H9
 yIOxtrKhEas334gXs9WyZp7wLGHJBnAExC3VPjtZJamHW4WLLbE+WRS7OyEKgFvVyEYDBlpRwDQ
 gZ34yyih4xpR/ACYfxTONXLLHqrOWlLLSCKgT5DgfPlio7cR29WKlkoRFU4tO6PZPm8AsqGi+aP
 N7/oVg6U+iG1q2uOsiUcn3CJl3vCwdP3eDRe5Edk6UOuBH4i8nBLkE4/Hqnbsm6aE3vl3l/cXXS
 D1dy/DfjQiDwSR8tB6JJS14djTAYumzNUh8kwZFQYa/qNBq2Wlic9txFthqkRuElHTy+K3YZI7H
 C0JK/MStLgO6F5nzIQw==
X-Proofpoint-GUID: 6JaaTZoQAlfXKJDjK1Gw30KVi554yhLi
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11904
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=10 malwarescore=0 phishscore=0 clxscore=1015
 impostorscore=10 adultscore=0 lowpriorityscore=10 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609130304

Nothing sets SPACE_CACHE anymore, so the dirty block group writers never
have a cache to write out or wait for. Remove cache_save_setup(),
btrfs_setup_space_cache(), the io_list handling, the io_bgs list and
BTRFS_TRANS_CACHE_ENOSPC, and the abort-time cleanup of in-flight cache
IO.

The -ENOENT retry in btrfs_write_dirty_block_groups() handled a free
space endio worker creating a block group during the commit critical
section, so drop it too.

Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/btrfs/block-group.c | 407 +++----------------------------------------------
 fs/btrfs/block-group.h |   1 -
 fs/btrfs/disk-io.c     |  44 ------
 fs/btrfs/transaction.c |   9 +-
 fs/btrfs/transaction.h |  18 ---
 5 files changed, 25 insertions(+), 454 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index ee182369254c..a04dd8244c81 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1194,36 +1194,15 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 		goto out;
 	}
 
-	/*
-	 * get the inode first so any iput calls done for the io_list
-	 * aren't the final iput (no unlinks allowed now)
-	 */
 	inode = lookup_free_space_inode(block_group, path);
 
-	mutex_lock(&trans->transaction->cache_write_mutex);
-	/*
-	 * Make sure our free space cache IO is done before removing the
-	 * free space inode
-	 */
 	spin_lock(&trans->transaction->dirty_bgs_lock);
-	if (!list_empty(&block_group->io_list)) {
-		list_del_init(&block_group->io_list);
-
-		WARN_ON(!IS_ERR(inode) && inode != block_group->io_ctl.inode);
-
-		spin_unlock(&trans->transaction->dirty_bgs_lock);
-		btrfs_wait_cache_io(trans, block_group, path);
-		btrfs_put_block_group(block_group);
-		spin_lock(&trans->transaction->dirty_bgs_lock);
-	}
-
 	if (!list_empty(&block_group->dirty_list)) {
 		list_del_init(&block_group->dirty_list);
 		remove_rsv = true;
 		btrfs_put_block_group(block_group);
 	}
 	spin_unlock(&trans->transaction->dirty_bgs_lock);
-	mutex_unlock(&trans->transaction->cache_write_mutex);
 
 	ret = btrfs_remove_free_space_inode(trans, inode, block_group);
 	if (unlikely(ret)) {
@@ -3373,197 +3352,6 @@ static int update_block_group_item(struct btrfs_trans_handle *trans,
 
 }
 
-static void cache_save_setup(struct btrfs_block_group *block_group,
-			     struct btrfs_trans_handle *trans,
-			     struct btrfs_path *path)
-{
-	struct btrfs_fs_info *fs_info = block_group->fs_info;
-	struct inode *inode = NULL;
-	struct extent_changeset *data_reserved = NULL;
-	u64 alloc_hint = 0;
-	int dcs = BTRFS_DC_ERROR;
-	u64 cache_size = 0;
-	int retries = 0;
-	int ret = 0;
-
-	if (!btrfs_test_opt(fs_info, SPACE_CACHE))
-		return;
-
-	/*
-	 * If this block group is smaller than 100 megs don't bother caching the
-	 * block group.
-	 */
-	if (block_group->length < (100 * SZ_1M)) {
-		spin_lock(&block_group->lock);
-		block_group->disk_cache_state = BTRFS_DC_WRITTEN;
-		spin_unlock(&block_group->lock);
-		return;
-	}
-
-	if (TRANS_ABORTED(trans))
-		return;
-again:
-	inode = lookup_free_space_inode(block_group, path);
-	if (IS_ERR(inode) && PTR_ERR(inode) != -ENOENT) {
-		ret = PTR_ERR(inode);
-		btrfs_release_path(path);
-		goto out;
-	}
-
-	if (IS_ERR(inode)) {
-		if (retries) {
-			ret = PTR_ERR(inode);
-			btrfs_err(fs_info,
-				  "failed to lookup free space inode after creation for block group %llu: %d",
-				  block_group->start, ret);
-			goto out_free;
-		}
-		retries++;
-
-		if (block_group->ro)
-			goto out_free;
-
-		ret = create_free_space_inode(trans, block_group, path);
-		if (ret)
-			goto out_free;
-		goto again;
-	}
-
-	/*
-	 * We want to set the generation to 0, that way if anything goes wrong
-	 * from here on out we know not to trust this cache when we load up next
-	 * time.
-	 */
-	BTRFS_I(inode)->generation = 0;
-	ret = btrfs_update_inode(trans, BTRFS_I(inode));
-	if (unlikely(ret)) {
-		/*
-		 * So theoretically we could recover from this, simply set the
-		 * super cache generation to 0 so we know to invalidate the
-		 * cache, but then we'd have to keep track of the block groups
-		 * that fail this way so we know we _have_ to reset this cache
-		 * before the next commit or risk reading stale cache.  So to
-		 * limit our exposure to horrible edge cases lets just abort the
-		 * transaction, this only happens in really bad situations
-		 * anyway.
-		 */
-		btrfs_abort_transaction(trans, ret);
-		goto out_put;
-	}
-
-	/* We've already setup this transaction, go ahead and exit */
-	if (block_group->cache_generation == trans->transid &&
-	    i_size_read(inode)) {
-		dcs = BTRFS_DC_SETUP;
-		goto out_put;
-	}
-
-	if (i_size_read(inode) > 0) {
-		ret = btrfs_check_trunc_cache_free_space(fs_info,
-					&fs_info->global_block_rsv);
-		if (ret)
-			goto out_put;
-
-		ret = btrfs_truncate_free_space_cache(trans, NULL, inode);
-		if (ret)
-			goto out_put;
-	}
-
-	spin_lock(&block_group->lock);
-	if (block_group->cached != BTRFS_CACHE_FINISHED ||
-	    !btrfs_test_opt(fs_info, SPACE_CACHE)) {
-		/*
-		 * don't bother trying to write stuff out _if_
-		 * a) we're not cached,
-		 * b) we're with nospace_cache mount option,
-		 * c) we're with v2 space_cache (FREE_SPACE_TREE).
-		 */
-		dcs = BTRFS_DC_WRITTEN;
-		spin_unlock(&block_group->lock);
-		goto out_put;
-	}
-	spin_unlock(&block_group->lock);
-
-	/*
-	 * We hit an ENOSPC when setting up the cache in this transaction, just
-	 * skip doing the setup, we've already cleared the cache so we're safe.
-	 */
-	if (test_bit(BTRFS_TRANS_CACHE_ENOSPC, &trans->transaction->flags))
-		goto out_put;
-
-	/*
-	 * Try to preallocate enough space based on how big the block group is.
-	 * Keep in mind this has to include any pinned space which could end up
-	 * taking up quite a bit since it's not folded into the other space
-	 * cache.
-	 */
-	cache_size = div_u64(block_group->length, SZ_256M);
-	if (!cache_size)
-		cache_size = 1;
-
-	cache_size *= 16;
-	cache_size *= fs_info->sectorsize;
-
-	ret = btrfs_check_data_free_space(BTRFS_I(inode), &data_reserved, 0,
-					  cache_size, false);
-	if (ret)
-		goto out_put;
-
-	ret = btrfs_prealloc_file_range_trans(inode, trans, 0, 0, cache_size,
-					      cache_size, cache_size,
-					      &alloc_hint);
-	/*
-	 * Our cache requires contiguous chunks so that we don't modify a bunch
-	 * of metadata or split extents when writing the cache out, which means
-	 * we can enospc if we are heavily fragmented in addition to just normal
-	 * out of space conditions.  So if we hit this just skip setting up any
-	 * other block groups for this transaction, maybe we'll unpin enough
-	 * space the next time around.
-	 */
-	if (!ret)
-		dcs = BTRFS_DC_SETUP;
-	else if (ret == -ENOSPC)
-		set_bit(BTRFS_TRANS_CACHE_ENOSPC, &trans->transaction->flags);
-
-out_put:
-	iput(inode);
-out_free:
-	btrfs_release_path(path);
-out:
-	spin_lock(&block_group->lock);
-	if (!ret && dcs == BTRFS_DC_SETUP)
-		block_group->cache_generation = trans->transid;
-	block_group->disk_cache_state = dcs;
-	spin_unlock(&block_group->lock);
-
-	extent_changeset_free(data_reserved);
-}
-
-int btrfs_setup_space_cache(struct btrfs_trans_handle *trans)
-{
-	struct btrfs_fs_info *fs_info = trans->fs_info;
-	struct btrfs_block_group *cache, *tmp;
-	struct btrfs_transaction *cur_trans = trans->transaction;
-	BTRFS_PATH_AUTO_FREE(path);
-
-	if (list_empty(&cur_trans->dirty_bgs) ||
-	    !btrfs_test_opt(fs_info, SPACE_CACHE))
-		return 0;
-
-	path = btrfs_alloc_path();
-	if (!path)
-		return -ENOMEM;
-
-	/* Could add new block groups, use _safe just in case */
-	list_for_each_entry_safe(cache, tmp, &cur_trans->dirty_bgs,
-				 dirty_list) {
-		if (cache->disk_cache_state == BTRFS_DC_CLEAR)
-			cache_save_setup(cache, trans, path);
-	}
-
-	return 0;
-}
-
 /*
  * Transaction commit does final block group cache writeback during a critical
  * section where nothing is allowed to change the FS.  This is required in
@@ -3582,10 +3370,8 @@ int btrfs_start_dirty_block_groups(struct btrfs_trans_handle *trans)
 	struct btrfs_block_group *cache;
 	struct btrfs_transaction *cur_trans = trans->transaction;
 	int ret = 0;
-	int should_put;
 	BTRFS_PATH_AUTO_FREE(path);
 	LIST_HEAD(dirty);
-	struct list_head *io = &cur_trans->io_bgs;
 	int loops = 0;
 
 	spin_lock(&cur_trans->dirty_bgs_lock);
@@ -3608,34 +3394,13 @@ int btrfs_start_dirty_block_groups(struct btrfs_trans_handle *trans)
 		}
 	}
 
-	/*
-	 * cache_write_mutex is here only to save us from balance or automatic
-	 * removal of empty block groups deleting this block group while we are
-	 * writing out the cache
-	 */
-	mutex_lock(&trans->transaction->cache_write_mutex);
 	while (!list_empty(&dirty)) {
 		bool drop_reserve = true;
 
 		cache = list_first_entry(&dirty, struct btrfs_block_group,
 					 dirty_list);
-		/*
-		 * This can happen if something re-dirties a block group that
-		 * is already under IO.  Just wait for it to finish and then do
-		 * it all again
-		 */
-		if (!list_empty(&cache->io_list)) {
-			list_del_init(&cache->io_list);
-			btrfs_wait_cache_io(trans, cache, path);
-			btrfs_put_block_group(cache);
-		}
-
 
 		/*
-		 * btrfs_wait_cache_io uses the cache->dirty_list to decide if
-		 * it should update the cache_state.  Don't delete until after
-		 * we wait.
-		 *
 		 * Since we're not running in the commit critical section
 		 * we need the dirty_bgs_lock to protect from update_block_group
 		 */
@@ -3643,72 +3408,35 @@ int btrfs_start_dirty_block_groups(struct btrfs_trans_handle *trans)
 		list_del_init(&cache->dirty_list);
 		spin_unlock(&cur_trans->dirty_bgs_lock);
 
-		should_put = 1;
-
-		cache_save_setup(cache, trans, path);
-
-		if (cache->disk_cache_state == BTRFS_DC_SETUP) {
-			cache->io_ctl.inode = NULL;
-			ret = btrfs_write_out_cache(trans, cache, path);
-			if (ret == 0 && cache->io_ctl.inode) {
-				should_put = 0;
-
-				/*
-				 * The cache_write_mutex is protecting the
-				 * io_list, also refer to the definition of
-				 * btrfs_transaction::io_bgs for more details
-				 */
-				list_add_tail(&cache->io_list, io);
-			} else {
-				/*
-				 * If we failed to write the cache, the
-				 * generation will be bad and life goes on
-				 */
-				ret = 0;
-			}
-		}
-		if (!ret) {
-			ret = update_block_group_item(trans, path, cache);
-			/*
-			 * Our block group might still be attached to the list
-			 * of new block groups in the transaction handle of some
-			 * other task (struct btrfs_trans_handle->new_bgs). This
-			 * means its block group item isn't yet in the extent
-			 * tree. If this happens ignore the error, as we will
-			 * try again later in the critical section of the
-			 * transaction commit.
-			 */
-			if (ret == -ENOENT) {
-				ret = 0;
-				spin_lock(&cur_trans->dirty_bgs_lock);
-				if (list_empty(&cache->dirty_list)) {
-					list_add_tail(&cache->dirty_list,
-						      &cur_trans->dirty_bgs);
-					btrfs_get_block_group(cache);
-					drop_reserve = false;
-				}
-				spin_unlock(&cur_trans->dirty_bgs_lock);
-			} else if (ret) {
-				btrfs_abort_transaction(trans, ret);
+		ret = update_block_group_item(trans, path, cache);
+		/*
+		 * Our block group might still be attached to the list of new
+		 * block groups in the transaction handle of some other task
+		 * (struct btrfs_trans_handle->new_bgs). This means its block
+		 * group item isn't yet in the extent tree. If this happens
+		 * ignore the error, as we will try again later in the critical
+		 * section of the transaction commit.
+		 */
+		if (ret == -ENOENT) {
+			ret = 0;
+			spin_lock(&cur_trans->dirty_bgs_lock);
+			if (list_empty(&cache->dirty_list)) {
+				list_add_tail(&cache->dirty_list,
+					      &cur_trans->dirty_bgs);
+				btrfs_get_block_group(cache);
+				drop_reserve = false;
 			}
+			spin_unlock(&cur_trans->dirty_bgs_lock);
+		} else if (ret) {
+			btrfs_abort_transaction(trans, ret);
 		}
 
-		/* If it's not on the io list, we need to put the block group */
-		if (should_put)
-			btrfs_put_block_group(cache);
+		btrfs_put_block_group(cache);
 		if (drop_reserve)
 			btrfs_dec_delayed_refs_rsv_bg_updates(fs_info);
-		/*
-		 * Avoid blocking other tasks for too long. It might even save
-		 * us from writing caches for block groups that are going to be
-		 * removed.
-		 */
-		mutex_unlock(&trans->transaction->cache_write_mutex);
 		if (ret)
 			goto out;
-		mutex_lock(&trans->transaction->cache_write_mutex);
 	}
-	mutex_unlock(&trans->transaction->cache_write_mutex);
 
 	/*
 	 * Go through delayed refs for all the stuff we've just kicked off
@@ -3722,7 +3450,7 @@ int btrfs_start_dirty_block_groups(struct btrfs_trans_handle *trans)
 		list_splice_init(&cur_trans->dirty_bgs, &dirty);
 		/*
 		 * dirty_bgs_lock protects us from concurrent block group
-		 * deletes too (not just cache_write_mutex).
+		 * deletes.
 		 */
 		if (!list_empty(&dirty)) {
 			spin_unlock(&cur_trans->dirty_bgs_lock);
@@ -3747,121 +3475,34 @@ int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans)
 	struct btrfs_block_group *cache;
 	struct btrfs_transaction *cur_trans = trans->transaction;
 	int ret = 0;
-	int should_put;
 	BTRFS_PATH_AUTO_FREE(path);
-	struct list_head *io = &cur_trans->io_bgs;
 
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
 
-	/*
-	 * Even though we are in the critical section of the transaction commit,
-	 * we can still have concurrent tasks adding elements to this
-	 * transaction's list of dirty block groups. These tasks correspond to
-	 * endio free space workers started when writeback finishes for a
-	 * space cache, which run inode.c:btrfs_finish_ordered_io(), and can
-	 * allocate new block groups as a result of COWing nodes of the root
-	 * tree when updating the free space inode. The writeback for the space
-	 * caches is triggered by an earlier call to
-	 * btrfs_start_dirty_block_groups() and iterations of the following
-	 * loop.
-	 * Also we want to do the cache_save_setup first and then run the
-	 * delayed refs to make sure we have the best chance at doing this all
-	 * in one shot.
-	 */
 	spin_lock(&cur_trans->dirty_bgs_lock);
 	while (!list_empty(&cur_trans->dirty_bgs)) {
 		cache = list_first_entry(&cur_trans->dirty_bgs,
 					 struct btrfs_block_group,
 					 dirty_list);
-
-		/*
-		 * This can happen if cache_save_setup re-dirties a block group
-		 * that is already under IO.  Just wait for it to finish and
-		 * then do it all again
-		 */
-		if (!list_empty(&cache->io_list)) {
-			spin_unlock(&cur_trans->dirty_bgs_lock);
-			list_del_init(&cache->io_list);
-			btrfs_wait_cache_io(trans, cache, path);
-			btrfs_put_block_group(cache);
-			spin_lock(&cur_trans->dirty_bgs_lock);
-		}
-
-		/*
-		 * Don't remove from the dirty list until after we've waited on
-		 * any pending IO
-		 */
 		list_del_init(&cache->dirty_list);
 		spin_unlock(&cur_trans->dirty_bgs_lock);
-		should_put = 1;
-
-		cache_save_setup(cache, trans, path);
 
 		if (!ret)
 			ret = btrfs_run_delayed_refs(trans, U64_MAX);
-
-		if (!ret && cache->disk_cache_state == BTRFS_DC_SETUP) {
-			cache->io_ctl.inode = NULL;
-			ret = btrfs_write_out_cache(trans, cache, path);
-			if (ret == 0 && cache->io_ctl.inode) {
-				should_put = 0;
-				list_add_tail(&cache->io_list, io);
-			} else {
-				/*
-				 * If we failed to write the cache, the
-				 * generation will be bad and life goes on
-				 */
-				ret = 0;
-			}
-		}
 		if (!ret) {
 			ret = update_block_group_item(trans, path, cache);
-			/*
-			 * One of the free space endio workers might have
-			 * created a new block group while updating a free space
-			 * cache's inode (at inode.c:btrfs_finish_ordered_io())
-			 * and hasn't released its transaction handle yet, in
-			 * which case the new block group is still attached to
-			 * its transaction handle and its creation has not
-			 * finished yet (no block group item in the extent tree
-			 * yet, etc). If this is the case, wait for all free
-			 * space endio workers to finish and retry. This is a
-			 * very rare case so no need for a more efficient and
-			 * complex approach.
-			 */
-			if (ret == -ENOENT) {
-				wait_event(cur_trans->writer_wait,
-				   atomic_read(&cur_trans->num_writers) == 1);
-				ret = update_block_group_item(trans, path, cache);
-				if (ret)
-					btrfs_abort_transaction(trans, ret);
-			} else if (ret) {
+			if (ret)
 				btrfs_abort_transaction(trans, ret);
-			}
 		}
 
-		/* If its not on the io list, we need to put the block group */
-		if (should_put)
-			btrfs_put_block_group(cache);
+		btrfs_put_block_group(cache);
 		btrfs_dec_delayed_refs_rsv_bg_updates(fs_info);
 		spin_lock(&cur_trans->dirty_bgs_lock);
 	}
 	spin_unlock(&cur_trans->dirty_bgs_lock);
 
-	/*
-	 * Refer to the definition of io_bgs member for details why it's safe
-	 * to use it without any locking
-	 */
-	while (!list_empty(io)) {
-		cache = list_first_entry(io, struct btrfs_block_group,
-					 io_list);
-		list_del_init(&cache->io_list);
-		btrfs_wait_cache_io(trans, cache, path);
-		btrfs_put_block_group(cache);
-	}
-
 	return ret;
 }
 
diff --git a/fs/btrfs/block-group.h b/fs/btrfs/block-group.h
index 69d56864d4ba..97c8565ae4fc 100644
--- a/fs/btrfs/block-group.h
+++ b/fs/btrfs/block-group.h
@@ -368,7 +368,6 @@ int btrfs_inc_block_group_ro(struct btrfs_block_group *cache,
 void btrfs_dec_block_group_ro(struct btrfs_block_group *cache);
 int btrfs_start_dirty_block_groups(struct btrfs_trans_handle *trans);
 int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans);
-int btrfs_setup_space_cache(struct btrfs_trans_handle *trans);
 int btrfs_update_block_group(struct btrfs_trans_handle *trans,
 			     u64 bytenr, u64 num_bytes, bool alloc);
 int btrfs_add_reserved_bytes(struct btrfs_block_group *cache,
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 819727460bcf..f544c457d4ab 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4860,26 +4860,6 @@ static void btrfs_destroy_pinned_extent(struct btrfs_fs_info *fs_info,
 	}
 }
 
-static void btrfs_cleanup_bg_io(struct btrfs_block_group *cache)
-{
-	struct inode *inode;
-
-	inode = cache->io_ctl.inode;
-	if (inode) {
-		unsigned int nofs_flag;
-
-		nofs_flag = memalloc_nofs_save();
-		invalidate_inode_pages2(inode->i_mapping);
-		memalloc_nofs_restore(nofs_flag);
-
-		BTRFS_I(inode)->generation = 0;
-		cache->io_ctl.inode = NULL;
-		iput(inode);
-	}
-	ASSERT(cache->io_ctl.pages == NULL);
-	btrfs_put_block_group(cache);
-}
-
 void btrfs_cleanup_dirty_bgs(struct btrfs_transaction *cur_trans,
 			     struct btrfs_fs_info *fs_info)
 {
@@ -4891,13 +4871,6 @@ void btrfs_cleanup_dirty_bgs(struct btrfs_transaction *cur_trans,
 					 struct btrfs_block_group,
 					 dirty_list);
 
-		if (!list_empty(&cache->io_list)) {
-			spin_unlock(&cur_trans->dirty_bgs_lock);
-			list_del_init(&cache->io_list);
-			btrfs_cleanup_bg_io(cache);
-			spin_lock(&cur_trans->dirty_bgs_lock);
-		}
-
 		list_del_init(&cache->dirty_list);
 		spin_lock(&cache->lock);
 		cache->disk_cache_state = BTRFS_DC_ERROR;
@@ -4909,22 +4882,6 @@ void btrfs_cleanup_dirty_bgs(struct btrfs_transaction *cur_trans,
 		spin_lock(&cur_trans->dirty_bgs_lock);
 	}
 	spin_unlock(&cur_trans->dirty_bgs_lock);
-
-	/*
-	 * Refer to the definition of io_bgs member for details why it's safe
-	 * to use it without any locking
-	 */
-	while (!list_empty(&cur_trans->io_bgs)) {
-		cache = list_first_entry(&cur_trans->io_bgs,
-					 struct btrfs_block_group,
-					 io_list);
-
-		list_del_init(&cache->io_list);
-		spin_lock(&cache->lock);
-		cache->disk_cache_state = BTRFS_DC_ERROR;
-		spin_unlock(&cache->lock);
-		btrfs_cleanup_bg_io(cache);
-	}
 }
 
 static void btrfs_free_all_qgroup_pertrans(struct btrfs_fs_info *fs_info)
@@ -4960,7 +4917,6 @@ void btrfs_cleanup_one_transaction(struct btrfs_transaction *cur_trans)
 
 	btrfs_cleanup_dirty_bgs(cur_trans, fs_info);
 	ASSERT(list_empty(&cur_trans->dirty_bgs));
-	ASSERT(list_empty(&cur_trans->io_bgs));
 
 	list_for_each_entry_safe(dev, tmp, &cur_trans->dev_update_list,
 				 post_commit_list) {
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 6802b94ed76f..6a36d29406c3 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -379,7 +379,6 @@ static noinline int join_transaction(struct btrfs_fs_info *fs_info,
 	INIT_LIST_HEAD(&cur_trans->dev_update_list);
 	INIT_LIST_HEAD(&cur_trans->switch_commits);
 	INIT_LIST_HEAD(&cur_trans->dirty_bgs);
-	INIT_LIST_HEAD(&cur_trans->io_bgs);
 	INIT_LIST_HEAD(&cur_trans->dropped_roots);
 	mutex_init(&cur_trans->cache_write_mutex);
 	spin_lock_init(&cur_trans->dirty_bgs_lock);
@@ -1363,7 +1362,6 @@ static noinline int commit_cowonly_roots(struct btrfs_trans_handle *trans)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct list_head *dirty_bgs = &trans->transaction->dirty_bgs;
-	struct list_head *io_bgs = &trans->transaction->io_bgs;
 	struct extent_buffer *eb;
 	int ret;
 
@@ -1393,10 +1391,6 @@ static noinline int commit_cowonly_roots(struct btrfs_trans_handle *trans)
 	if (ret)
 		return ret;
 
-	ret = btrfs_setup_space_cache(trans);
-	if (ret)
-		return ret;
-
 again:
 	while (!list_empty(&fs_info->dirty_cowonly_roots)) {
 		struct btrfs_root *root;
@@ -1417,7 +1411,7 @@ static noinline int commit_cowonly_roots(struct btrfs_trans_handle *trans)
 	if (ret)
 		return ret;
 
-	while (!list_empty(dirty_bgs) || !list_empty(io_bgs)) {
+	while (!list_empty(dirty_bgs)) {
 		ret = btrfs_write_dirty_block_groups(trans);
 		if (ret)
 			return ret;
@@ -2543,7 +2537,6 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	switch_commit_roots(trans);
 
 	ASSERT(list_empty(&cur_trans->dirty_bgs));
-	ASSERT(list_empty(&cur_trans->io_bgs));
 	update_super_roots(fs_info);
 
 	btrfs_set_super_log_root(fs_info->super_copy, 0);
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 3a57f227b5ed..8245a58587c0 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -47,7 +47,6 @@ enum btrfs_trans_state {
 
 #define BTRFS_TRANS_HAVE_FREE_BGS	0
 #define BTRFS_TRANS_DIRTY_BG_RUN	1
-#define BTRFS_TRANS_CACHE_ENOSPC	2
 
 struct btrfs_transaction {
 	u64 transid;
@@ -78,23 +77,6 @@ struct btrfs_transaction {
 	struct list_head dev_update_list;
 	struct list_head switch_commits;
 	struct list_head dirty_bgs;
-
-	/*
-	 * There is no explicit lock which protects io_bgs, rather its
-	 * consistency is implied by the fact that all the sites which modify
-	 * it do so under some form of transaction critical section, namely:
-	 *
-	 * - btrfs_start_dirty_block_groups - This function can only ever be
-	 *   run by one of the transaction committers. Refer to
-	 *   BTRFS_TRANS_DIRTY_BG_RUN usage in btrfs_commit_transaction
-	 *
-	 * - btrfs_write_dirty_blockgroups - this is called by
-	 *   commit_cowonly_roots from transaction critical section
-	 *   (TRANS_STATE_COMMIT_DOING)
-	 *
-	 * - btrfs_cleanup_dirty_bgs - called on transaction abort
-	 */
-	struct list_head io_bgs;
 	struct list_head dropped_roots;
 	struct extent_io_tree pinned_extents;
 

-- 
2.39.5

