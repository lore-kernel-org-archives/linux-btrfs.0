Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA924B0E4F
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 16:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791822527; cv=none; b=uEHWAlOtSt/d+VMmomqVHf80DC4NzkvuxjeX5h5yIsgWPYl2JXkr6p4UKxQDEFPpgqwbkb0PQsc1covx9vfK5eTLkS6ZdgGAM1Tn6epWINNBE8Sl7N2LkEg/RnsOOg2fHcgzf7sVxJsJD0Jc5soNoBiG1as+aHPRKWaRZWAItbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791822527; c=relaxed/simple;
	bh=YkF6n6KrSYXHfLnMBbpQHGt+oRFC/5olnkHqbiECIYo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=R6OK4aCBAcHDBvwZuF0zwtI5iG/E3Tm3WwGUoQX1Ued3y91p5wc8+XGmfmpXSFDJDzwVkvz3JogEVqhxs5A6tpIBUtAMGzE8OQIJOfflTfpgRsxMS/EqAcsB55Sf0Xek+3SInwGeSD5oXhAHvjE/ye/14EFA0BqsU/iAxRSrhc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=Qk2NHXin; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=JDVeekXB; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="Qk2NHXin";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="JDVeekXB"
Received: from pps.filterd (m0167068.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69CEgpla1023938
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 12:28:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=rLgW
	4+34LZR9EUh5anyclGHbm8K4Gvv/6keOYLGGj1w=; b=Qk2NHXinljLqf72uqdmF
	1h+Q8f73wUReYpaJ8fx4+oQ5ekNZmILQ3C/EWUGNCtMB9ops/ih+idEa3INAi26s
	+cPC/3OCmbN2Zg+RGYgRdC+M7GxwIoFeP67rlWBmvowW99NZpbPI6qL8bWrDlQ//
	F7gJbuyG1UtkBe6CatPow8eNnbouPGJCLq/zXhvTpThS+oPb/TlqDAi/XsUvfmUw
	nrsLWdTEKmThoxoHrpfb77fI1EO5XKe2o8z8B7tYwEbx8Y/XfAy0BAeT2X08tTUs
	DD/PyjENFzZS5rmHx9c11syUJLs3px3Gt2bY3lql8o3FNXeWtn4tWfufYdOKzRcK
	PA==
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4h91bwhb5c-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 12:28:43 -0400 (EDT)
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-9196b477c4cso55473216d6.0
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 09:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1791822522; x=1792427322; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rLgW4+34LZR9EUh5anyclGHbm8K4Gvv/6keOYLGGj1w=;
        b=JDVeekXBMStCur4Jh/pbLO5cvfdape3aPkobtV+fhgW2qg6XBYs4IjhwWyKOBNzLYS
         /yVx7d53knVv6QclZ78SCj5HIZgpCP+XXTldVbyDVh31Yeyg+zKYsHIzWK4DNwG7x7JF
         z2agYF1GqoVl7RjRITtDg4wZvlEdGHBZV2Oh5k6BYTmb4duFY94tdGw4maFN9fWhbzOX
         6QZ+lDPsrMFvBMLf9qqwno0RG0aV5DjNpKJ/YZC5T13laX5YhBPLx5KNe97CxGbkJ5Zs
         OBJ5doF3ExDxl4tcyRCJl1lpWSZZnPqShCQbmSisMAd/YDnRJ9jMGH+jceX1024H/BOC
         90BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791822522; x=1792427322;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rLgW4+34LZR9EUh5anyclGHbm8K4Gvv/6keOYLGGj1w=;
        b=1szkksCw8G3QPOafRGjD/sFk2Py4XEwZKoPdu0gXP5HcMhrUGCY/l3xlGh82xaAih6
         9xyIBZ6aZc9jE5LRJy5GpHWpVzCO04aSXngyDALKdJ7AGvfmnQ3bj28AgONNvlDVEYQL
         csawuoNPOqUCrKXvMd01jDNX8SSNE9vV6mTbvFordpw44Z5xlmUKaF93yqQAbKdw4e0M
         TEUDBuphhdhPU6UuOTqXq3la2DlguTvpuDLtmy9Hkgk6xSNQbHEDU9Z+MyA7WEyzjveF
         SbHyy8ZycypvyZ3JugSf+YxYbv3wgY7HbmSwBusG3tSBxLFL0dOEMuJl/09cfvt4M7By
         of/A==
X-Gm-Message-State: AFq9FYLHV8EppJ5UAbfEydw+8P5w/jC+ChGk8kNku0M19BdX16VPwnWW
	9dh2By8ZGOAcM0TTEeRTCs/pHQsjYl9E0RMpeQSP/OGuXh0KEBXAa0I6yBgF90xbdIB4fTp9R0q
	nkAYkytWqYy+9hHRcNEVvCMl4K2ZxjcYPFHFx8HGiPiNll22Kl8NmvLX43vM0
X-Gm-Gg: AYBFou1yBA5JZokhf1Jy9PGgaEyjERviN7DrJf56AU201JguKuJpKNRSz2/epA1vUUo
	CmGJi4A512yBZKt44aq8jX8ALCau7xdhlOH1dAl2Mekxf4ulC75Vvv17ffrdY7qzuQloTs52oke
	mL+Pahy/UNuuz+UFY8JSQQCcr7aAVSk0iXLKwhkydfLqP55HuQwhhA58u+7zbA0QrqPrqkwdOfw
	YI6fwvRTws9tyVjoTJH+QpdmEG7c1uucded0ROBVsJZdI4eknbBCLudm2/VLYG/rwygjo75tl95
	1DpRL8UNlhR2/1fP0SZZG0zcP1iSywyUjPP8k04mJJWIqLRMJRnlX+d5wDVlyYvcNsAKiyV0x3m
	xOPfHmuLIt3LJx6uZoVH3ljV3O/F4II9EnoZ8kbTOmLWTEP4=
X-Received: by 2002:a05:6214:2528:b0:919:57a8:7537 with SMTP id 6a1803df08f44-91b5d58c56amr153144726d6.18.1791822521818;
        Mon, 12 Oct 2026 09:28:41 -0700 (PDT)
X-Received: by 2002:a05:6214:2528:b0:919:57a8:7537 with SMTP id 6a1803df08f44-91b5d58c56amr153144336d6.18.1791822521220;
        Mon, 12 Oct 2026 09:28:41 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-178-231.net.columbia.edu. [128.59.178.231])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b97c27146sm1411796d6.29.2026.10.12.09.28.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 09:28:40 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 12 Oct 2026 12:28:17 -0400
Subject: [PATCH v4 05/18] btrfs: remove the v1 space cache write path
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261012-btrfs-remove-v1-space-cache-v4-5-f125bd8c07f9@columbia.edu>
References: <20261012-btrfs-remove-v1-space-cache-v4-0-f125bd8c07f9@columbia.edu>
In-Reply-To: <20261012-btrfs-remove-v1-space-cache-v4-0-f125bd8c07f9@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791822515; l=28330;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=YkF6n6KrSYXHfLnMBbpQHGt+oRFC/5olnkHqbiECIYo=;
 b=b/BbJbEuORSBSukeIY9oGUaAhJws5RYGap3ysNAHxEqSDZSHB5AeVNjdpL213LQGOC5RMMHB2
 1Y6Pm5XV+98A8rhrQGWhYtXC6/8fmujAYNrvP7WCJpwAVA3qHQj6ZYo
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: MRZL__8imeW4e2oueP1vLa13NnUjIHgZ
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEyMDA2NSBTYWx0ZWRfX1pMm5BLy9faO
 4Y7QUO6KQVizwx6K3sT+Cz71sOkxWCxhDCc8uWRgAUhYdEJyTcOJ7dAMVqheJSC678FILo4F06X
 BGfMSjyZUfTwRDfXHNpDuE0LlqIqp/24Gf9H/9gh1VZdQDO9arpr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEyMDA2NSBTYWx0ZWRfX/sQ3qn8SR50s
 HmAKxIIclfHheAKfz2XsCwvZZ5579X9hhuFtvTUYBpxO+iTLoPpHcy9MLp7Sc6+pvNeR7trcvMT
 PqKRpRVoSo9FjjaDwQQGeAtpRW0T0S3sHgHCaW7H9jv/20GWNWsxbmz/Jhv4h+Ltg1N0EwhA1z2
 /L55xn4oITNjo29O3NCJbjxJ0k4VAHEc1+riyF1+jC5jU1WKw9ExmwfiqdVWYPqMyEgHS8N6xOk
 ElWr76ecUQBbizMMr48Rd95l0f4iEllLz+QwW6+cJZ2cCWvtrXQPdsAvOhrsYTEEzpYPQrENjIr
 OLDaxDz50PqODyqwZ/Yze7WCqtY6WpBJmApGOq4jdrHO0AS4ZgyFvhSorw1KHkbZXn18w+NB/hB
 7twmAdh4pEKCi7EaJucK7w6Bx320jeR9Rg/LvI6qDiMNinGu1E04QOTEgwCqX/oIoEHsM1kG3ee
 /8haM5aYBl3FdNa5+fw==
X-Authority-Analysis: v=2.4 cv=VOpIDNPX c=1 sm=1 tr=0 ts=6acd0abb cx=c_pps
 a=7E5Bxpl4vBhpaufnMqZlrw==:117 a=9fnr1hFzp71kSIFw8uYQYA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=usPcmh10W0ubT8QP8_c3:22
 a=bWaUF2WQGDAqRP89i5YA:9 a=QEXdDO2ut3YA:10 a=pJ04lnu7RYOZP9TFuWaZ:22
X-Proofpoint-ORIG-GUID: MRZL__8imeW4e2oueP1vLa13NnUjIHgZ
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11933
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 priorityscore=1501 lowpriorityscore=10
 suspectscore=0 adultscore=0 phishscore=0 bulkscore=10 impostorscore=10
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610120065

Nothing writes out a v1 space cache any more. Remove the writers and
their io_ctl helpers, along with create_free_space_inode() and
btrfs_prealloc_file_range_trans(), whose only user was the cache inode
creation. The io_list and io_ctl block group fields were only used by
the writers, so remove them too.

btrfs_truncate_free_space_cache() only needed the block group to wait
for and clear in-flight cache IO, so drop that parameter.

Assisted-by: LLM
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/btrfs/block-group.c      |   4 -
 fs/btrfs/block-group.h      |   3 -
 fs/btrfs/btrfs_inode.h      |   4 -
 fs/btrfs/free-space-cache.c | 688 --------------------------------------------
 fs/btrfs/free-space-cache.h |  10 -
 fs/btrfs/inode.c            |   9 -
 fs/btrfs/relocation.c       |   2 +-
 7 files changed, 1 insertion(+), 719 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index da96d4d82578..896b003e84ce 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1268,7 +1268,6 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 
 	spin_lock(&trans->transaction->dirty_bgs_lock);
 	WARN_ON(!list_empty(&block_group->dirty_list));
-	WARN_ON(!list_empty(&block_group->io_list));
 	spin_unlock(&trans->transaction->dirty_bgs_lock);
 
 	btrfs_remove_free_space_cache(block_group);
@@ -2454,7 +2453,6 @@ static struct btrfs_block_group *btrfs_create_block_group(
 	INIT_LIST_HEAD(&cache->ro_list);
 	INIT_LIST_HEAD(&cache->discard_list);
 	INIT_LIST_HEAD(&cache->dirty_list);
-	INIT_LIST_HEAD(&cache->io_list);
 	INIT_LIST_HEAD(&cache->active_bg_list);
 	btrfs_init_free_space_ctl(cache, cache->free_space_ctl);
 	atomic_set(&cache->frozen, 0);
@@ -4338,7 +4336,6 @@ void btrfs_put_block_group_cache(struct btrfs_fs_info *info)
 			block_group->inode = NULL;
 			spin_unlock(&block_group->lock);
 
-			ASSERT(block_group->io_ctl.inode == NULL);
 			iput(&inode->vfs_inode);
 		} else {
 			spin_unlock(&block_group->lock);
@@ -4475,7 +4472,6 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info)
 		btrfs_remove_free_space_cache(block_group);
 		ASSERT(block_group->cached != BTRFS_CACHE_STARTED);
 		ASSERT(list_empty(&block_group->dirty_list));
-		ASSERT(list_empty(&block_group->io_list));
 		ASSERT(list_empty(&block_group->bg_list));
 		ASSERT(refcount_read(&block_group->refs) == 1);
 		ASSERT(block_group->swap_extents == 0);
diff --git a/fs/btrfs/block-group.h b/fs/btrfs/block-group.h
index d69432b236ec..f7346a0170fc 100644
--- a/fs/btrfs/block-group.h
+++ b/fs/btrfs/block-group.h
@@ -228,9 +228,6 @@ struct btrfs_block_group {
 
 	/* For dirty block groups */
 	struct list_head dirty_list;
-	struct list_head io_list;
-
-	struct btrfs_io_ctl io_ctl;
 
 	/*
 	 * Incremented when doing extent allocations and holding a read lock
diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 03c00c99099d..d1c014da52a3 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -598,10 +598,6 @@ int btrfs_wait_on_delayed_iputs(struct btrfs_fs_info *fs_info);
 int btrfs_prealloc_file_range(struct inode *inode, int mode,
 			      u64 start, u64 num_bytes, u64 min_size,
 			      loff_t actual_len, u64 *alloc_hint);
-int btrfs_prealloc_file_range_trans(struct inode *inode,
-				    struct btrfs_trans_handle *trans, int mode,
-				    u64 start, u64 num_bytes, u64 min_size,
-				    loff_t actual_len, u64 *alloc_hint);
 int btrfs_run_delalloc_range(struct btrfs_inode *inode, struct folio *locked_folio,
 			     u64 start, u64 end, struct writeback_control *wbc);
 void btrfs_queue_writepage_fixup(struct btrfs_inode *inode, struct folio *folio);
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 4572b3d64210..87db711278a7 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -164,78 +164,6 @@ struct inode *lookup_free_space_inode(struct btrfs_block_group *block_group,
 	return inode;
 }
 
-static int __create_free_space_inode(struct btrfs_root *root,
-				     struct btrfs_trans_handle *trans,
-				     struct btrfs_path *path,
-				     u64 ino, u64 offset)
-{
-	struct btrfs_key key;
-	struct btrfs_disk_key disk_key;
-	struct btrfs_free_space_header *header;
-	struct btrfs_inode_item *inode_item;
-	struct extent_buffer *leaf;
-	/* We inline CRCs for the free disk space cache */
-	const u64 flags = BTRFS_INODE_NOCOMPRESS | BTRFS_INODE_PREALLOC |
-			  BTRFS_INODE_NODATASUM | BTRFS_INODE_NODATACOW;
-	int ret;
-
-	ret = btrfs_insert_empty_inode(trans, root, path, ino);
-	if (ret)
-		return ret;
-
-	leaf = path->nodes[0];
-	inode_item = btrfs_item_ptr(leaf, path->slots[0],
-				    struct btrfs_inode_item);
-	btrfs_item_key(leaf, &disk_key, path->slots[0]);
-	memzero_extent_buffer(leaf, (unsigned long)inode_item,
-			     sizeof(*inode_item));
-	btrfs_set_inode_generation(leaf, inode_item, trans->transid);
-	btrfs_set_inode_size(leaf, inode_item, 0);
-	btrfs_set_inode_nbytes(leaf, inode_item, 0);
-	btrfs_set_inode_uid(leaf, inode_item, 0);
-	btrfs_set_inode_gid(leaf, inode_item, 0);
-	btrfs_set_inode_mode(leaf, inode_item, S_IFREG | 0600);
-	btrfs_set_inode_flags(leaf, inode_item, flags);
-	btrfs_set_inode_nlink(leaf, inode_item, 1);
-	btrfs_set_inode_transid(leaf, inode_item, trans->transid);
-	btrfs_set_inode_block_group(leaf, inode_item, offset);
-	btrfs_release_path(path);
-
-	key.objectid = BTRFS_FREE_SPACE_OBJECTID;
-	key.type = 0;
-	key.offset = offset;
-	ret = btrfs_insert_empty_item(trans, root, path, &key,
-				      sizeof(struct btrfs_free_space_header));
-	if (ret < 0) {
-		btrfs_release_path(path);
-		return ret;
-	}
-
-	leaf = path->nodes[0];
-	header = btrfs_item_ptr(leaf, path->slots[0],
-				struct btrfs_free_space_header);
-	memzero_extent_buffer(leaf, (unsigned long)header, sizeof(*header));
-	btrfs_set_free_space_key(leaf, header, &disk_key);
-	btrfs_release_path(path);
-
-	return 0;
-}
-
-int create_free_space_inode(struct btrfs_trans_handle *trans,
-			    struct btrfs_block_group *block_group,
-			    struct btrfs_path *path)
-{
-	int ret;
-	u64 ino;
-
-	ret = btrfs_get_free_objectid(trans->fs_info->tree_root, &ino);
-	if (ret < 0)
-		return ret;
-
-	return __create_free_space_inode(trans->fs_info->tree_root, trans, path,
-					 ino, block_group->start);
-}
-
 /*
  * inode is an optional sink: if it is NULL, btrfs_remove_free_space_inode
  * handles lookup, otherwise it takes ownership and iputs the inode.
@@ -302,7 +230,6 @@ int btrfs_remove_free_space_inode(struct btrfs_trans_handle *trans,
 }
 
 int btrfs_truncate_free_space_cache(struct btrfs_trans_handle *trans,
-				    struct btrfs_block_group *block_group,
 				    struct inode *vfs_inode)
 {
 	struct btrfs_truncate_control control = {
@@ -316,33 +243,6 @@ int btrfs_truncate_free_space_cache(struct btrfs_trans_handle *trans,
 	struct btrfs_root *root = inode->root;
 	struct extent_state *cached_state = NULL;
 	int ret = 0;
-	bool locked = false;
-
-	if (block_group) {
-		BTRFS_PATH_AUTO_FREE(path);
-
-		path = btrfs_alloc_path();
-		if (!path) {
-			ret = -ENOMEM;
-			goto fail;
-		}
-		locked = true;
-		mutex_lock(&trans->transaction->cache_write_mutex);
-		if (!list_empty(&block_group->io_list)) {
-			list_del_init(&block_group->io_list);
-
-			btrfs_wait_cache_io(trans, block_group, path);
-			btrfs_put_block_group(block_group);
-		}
-
-		/*
-		 * now that we've truncated the cache away, its no longer
-		 * setup or written
-		 */
-		spin_lock(&block_group->lock);
-		block_group->disk_cache_state = BTRFS_DC_CLEAR;
-		spin_unlock(&block_group->lock);
-	}
 
 	btrfs_i_size_write(inode, 0);
 	truncate_pagecache(vfs_inode, 0);
@@ -366,8 +266,6 @@ int btrfs_truncate_free_space_cache(struct btrfs_trans_handle *trans,
 	ret = btrfs_update_inode(trans, inode);
 
 fail:
-	if (locked)
-		mutex_unlock(&trans->transaction->cache_write_mutex);
 	if (ret)
 		btrfs_abort_transaction(trans, ret);
 
@@ -500,21 +398,6 @@ static int io_ctl_prepare_pages(struct btrfs_io_ctl *io_ctl, bool uptodate)
 	return 0;
 }
 
-static void io_ctl_set_generation(struct btrfs_io_ctl *io_ctl, u64 generation)
-{
-	io_ctl_map_page(io_ctl, 1);
-
-	/*
-	 * Skip the csum areas.  If we don't check crcs then we just have a
-	 * 64bit chunk at the front of the first page.
-	 */
-	io_ctl->cur += (sizeof(u32) * io_ctl->num_pages);
-	io_ctl->size -= sizeof(u64) + (sizeof(u32) * io_ctl->num_pages);
-
-	put_unaligned_le64(generation, io_ctl->cur);
-	io_ctl->cur += sizeof(u64);
-}
-
 static int io_ctl_check_generation(struct btrfs_io_ctl *io_ctl, u64 generation)
 {
 	u64 cache_gen;
@@ -538,23 +421,6 @@ static int io_ctl_check_generation(struct btrfs_io_ctl *io_ctl, u64 generation)
 	return 0;
 }
 
-static void io_ctl_set_crc(struct btrfs_io_ctl *io_ctl, int index)
-{
-	u32 *tmp;
-	u32 crc = ~(u32)0;
-	unsigned offset = 0;
-
-	if (index == 0)
-		offset = sizeof(u32) * io_ctl->num_pages;
-
-	crc = crc32c(crc, io_ctl->orig + offset, PAGE_SIZE - offset);
-	btrfs_crc32c_final(crc, (u8 *)&crc);
-	io_ctl_unmap_page(io_ctl);
-	tmp = page_address(io_ctl->pages[0]);
-	tmp += index;
-	*tmp = crc;
-}
-
 static int io_ctl_check_crc(struct btrfs_io_ctl *io_ctl, int index)
 {
 	u32 *tmp, val;
@@ -584,76 +450,6 @@ static int io_ctl_check_crc(struct btrfs_io_ctl *io_ctl, int index)
 	return 0;
 }
 
-static int io_ctl_add_entry(struct btrfs_io_ctl *io_ctl, u64 offset, u64 bytes,
-			    void *bitmap)
-{
-	struct btrfs_free_space_entry *entry;
-
-	if (!io_ctl->cur)
-		return -ENOSPC;
-
-	entry = io_ctl->cur;
-	put_unaligned_le64(offset, &entry->offset);
-	put_unaligned_le64(bytes, &entry->bytes);
-	entry->type = (bitmap) ? BTRFS_FREE_SPACE_BITMAP :
-		BTRFS_FREE_SPACE_EXTENT;
-	io_ctl->cur += sizeof(struct btrfs_free_space_entry);
-	io_ctl->size -= sizeof(struct btrfs_free_space_entry);
-
-	if (io_ctl->size >= sizeof(struct btrfs_free_space_entry))
-		return 0;
-
-	io_ctl_set_crc(io_ctl, io_ctl->index - 1);
-
-	/* No more pages to map */
-	if (io_ctl->index >= io_ctl->num_pages)
-		return 0;
-
-	/* map the next page */
-	io_ctl_map_page(io_ctl, 1);
-	return 0;
-}
-
-static int io_ctl_add_bitmap(struct btrfs_io_ctl *io_ctl, void *bitmap)
-{
-	if (!io_ctl->cur)
-		return -ENOSPC;
-
-	/*
-	 * If we aren't at the start of the current page, unmap this one and
-	 * map the next one if there is any left.
-	 */
-	if (io_ctl->cur != io_ctl->orig) {
-		io_ctl_set_crc(io_ctl, io_ctl->index - 1);
-		if (io_ctl->index >= io_ctl->num_pages)
-			return -ENOSPC;
-		io_ctl_map_page(io_ctl, 0);
-	}
-
-	copy_page(io_ctl->cur, bitmap);
-	io_ctl_set_crc(io_ctl, io_ctl->index - 1);
-	if (io_ctl->index < io_ctl->num_pages)
-		io_ctl_map_page(io_ctl, 0);
-	return 0;
-}
-
-static void io_ctl_zero_remaining_pages(struct btrfs_io_ctl *io_ctl)
-{
-	/*
-	 * If we're not on the boundary we know we've modified the page and we
-	 * need to crc the page.
-	 */
-	if (io_ctl->cur != io_ctl->orig)
-		io_ctl_set_crc(io_ctl, io_ctl->index - 1);
-	else
-		io_ctl_unmap_page(io_ctl);
-
-	while (io_ctl->index < io_ctl->num_pages) {
-		io_ctl_map_page(io_ctl, 1);
-		io_ctl_set_crc(io_ctl, io_ctl->index - 1);
-	}
-}
-
 static int io_ctl_read_entry(struct btrfs_io_ctl *io_ctl,
 			    struct btrfs_free_space *entry, u8 *type)
 {
@@ -1075,490 +871,6 @@ int load_free_space_cache(struct btrfs_block_group *block_group)
 	return ret;
 }
 
-static noinline_for_stack
-int write_cache_extent_entries(struct btrfs_io_ctl *io_ctl,
-			      struct btrfs_block_group *block_group,
-			      int *entries, int *bitmaps,
-			      struct list_head *bitmap_list)
-{
-	int ret;
-	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
-	struct btrfs_free_cluster *cluster = NULL;
-	struct btrfs_free_cluster *cluster_locked = NULL;
-	struct rb_node *node = rb_first(&ctl->free_space_offset);
-	struct btrfs_trim_range *trim_entry;
-
-	/* Get the cluster for this block_group if it exists */
-	if (!list_empty(&block_group->cluster_list)) {
-		cluster = list_first_entry(&block_group->cluster_list,
-					   struct btrfs_free_cluster, block_group_list);
-	}
-
-	if (!node && cluster) {
-		cluster_locked = cluster;
-		spin_lock(&cluster_locked->lock);
-		node = rb_first(&cluster->root);
-		cluster = NULL;
-	}
-
-	/* Write out the extent entries */
-	while (node) {
-		struct btrfs_free_space *e;
-
-		e = rb_entry(node, struct btrfs_free_space, offset_index);
-		*entries += 1;
-
-		ret = io_ctl_add_entry(io_ctl, e->offset, e->bytes,
-				       e->bitmap);
-		if (ret)
-			goto fail;
-
-		if (e->bitmap) {
-			list_add_tail(&e->list, bitmap_list);
-			*bitmaps += 1;
-		}
-		node = rb_next(node);
-		if (!node && cluster) {
-			node = rb_first(&cluster->root);
-			cluster_locked = cluster;
-			spin_lock(&cluster_locked->lock);
-			cluster = NULL;
-		}
-	}
-	if (cluster_locked) {
-		spin_unlock(&cluster_locked->lock);
-		cluster_locked = NULL;
-	}
-
-	/*
-	 * Make sure we don't miss any range that was removed from our rbtree
-	 * because trimming is running. Otherwise after a umount+mount (or crash
-	 * after committing the transaction) we would leak free space and get
-	 * an inconsistent free space cache report from fsck.
-	 */
-	list_for_each_entry(trim_entry, &ctl->trimming_ranges, list) {
-		ret = io_ctl_add_entry(io_ctl, trim_entry->start,
-				       trim_entry->bytes, NULL);
-		if (ret)
-			goto fail;
-		*entries += 1;
-	}
-
-	return 0;
-fail:
-	if (cluster_locked)
-		spin_unlock(&cluster_locked->lock);
-	return -ENOSPC;
-}
-
-static noinline_for_stack int
-update_cache_item(struct btrfs_trans_handle *trans,
-		  struct btrfs_root *root,
-		  struct inode *inode,
-		  struct btrfs_path *path, u64 offset,
-		  int entries, int bitmaps)
-{
-	struct btrfs_key key;
-	struct btrfs_free_space_header *header;
-	struct extent_buffer *leaf;
-	int ret;
-
-	key.objectid = BTRFS_FREE_SPACE_OBJECTID;
-	key.type = 0;
-	key.offset = offset;
-
-	ret = btrfs_search_slot(trans, root, &key, path, 0, 1);
-	if (ret < 0) {
-		btrfs_clear_extent_bit(&BTRFS_I(inode)->io_tree, 0, inode->i_size - 1,
-				       EXTENT_DELALLOC, NULL);
-		return ret;
-	}
-	leaf = path->nodes[0];
-	if (ret > 0) {
-		struct btrfs_key found_key;
-		ASSERT(path->slots[0]);
-		path->slots[0]--;
-		btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
-		if (found_key.objectid != BTRFS_FREE_SPACE_OBJECTID ||
-		    found_key.offset != offset) {
-			btrfs_clear_extent_bit(&BTRFS_I(inode)->io_tree, 0,
-					       inode->i_size - 1, EXTENT_DELALLOC,
-					       NULL);
-			btrfs_release_path(path);
-			return -ENOENT;
-		}
-	}
-
-	BTRFS_I(inode)->generation = trans->transid;
-	header = btrfs_item_ptr(leaf, path->slots[0],
-				struct btrfs_free_space_header);
-	btrfs_set_free_space_entries(leaf, header, entries);
-	btrfs_set_free_space_bitmaps(leaf, header, bitmaps);
-	btrfs_set_free_space_generation(leaf, header, trans->transid);
-	btrfs_release_path(path);
-
-	return 0;
-}
-
-static noinline_for_stack int write_pinned_extent_entries(
-			    struct btrfs_trans_handle *trans,
-			    struct btrfs_block_group *block_group,
-			    struct btrfs_io_ctl *io_ctl,
-			    int *entries)
-{
-	u64 start, extent_start, extent_end, len;
-	const u64 block_group_end = btrfs_block_group_end(block_group);
-	struct extent_io_tree *unpin = NULL;
-	int ret;
-
-	/*
-	 * We want to add any pinned extents to our free space cache
-	 * so we don't leak the space
-	 *
-	 * We shouldn't have switched the pinned extents yet so this is the
-	 * right one
-	 */
-	unpin = &trans->transaction->pinned_extents;
-
-	start = block_group->start;
-
-	while (start < block_group_end) {
-		if (!btrfs_find_first_extent_bit(unpin, start,
-						 &extent_start, &extent_end,
-						 EXTENT_DIRTY, NULL))
-			return 0;
-
-		/* This pinned extent is out of our range */
-		if (extent_start >= block_group_end)
-			return 0;
-
-		extent_start = max(extent_start, start);
-		extent_end = min(block_group_end, extent_end + 1);
-		len = extent_end - extent_start;
-
-		*entries += 1;
-		ret = io_ctl_add_entry(io_ctl, extent_start, len, NULL);
-		if (ret)
-			return -ENOSPC;
-
-		start = extent_end;
-	}
-
-	return 0;
-}
-
-static noinline_for_stack int
-write_bitmap_entries(struct btrfs_io_ctl *io_ctl, struct list_head *bitmap_list)
-{
-	struct btrfs_free_space *entry, *next;
-	int ret;
-
-	/* Write out the bitmaps */
-	list_for_each_entry_safe(entry, next, bitmap_list, list) {
-		ret = io_ctl_add_bitmap(io_ctl, entry->bitmap);
-		if (ret)
-			return -ENOSPC;
-		list_del_init(&entry->list);
-	}
-
-	return 0;
-}
-
-static int flush_dirty_cache(struct inode *inode)
-{
-	int ret;
-
-	ret = btrfs_wait_ordered_range(BTRFS_I(inode), 0, (u64)-1);
-	if (ret)
-		btrfs_clear_extent_bit(&BTRFS_I(inode)->io_tree, 0, inode->i_size - 1,
-				       EXTENT_DELALLOC, NULL);
-
-	return ret;
-}
-
-static void noinline_for_stack
-cleanup_bitmap_list(struct list_head *bitmap_list)
-{
-	struct btrfs_free_space *entry, *next;
-
-	list_for_each_entry_safe(entry, next, bitmap_list, list)
-		list_del_init(&entry->list);
-}
-
-static void noinline_for_stack
-cleanup_write_cache_enospc(struct inode *inode,
-			   struct btrfs_io_ctl *io_ctl,
-			   struct extent_state **cached_state)
-{
-	io_ctl_drop_pages(io_ctl);
-	btrfs_unlock_extent(&BTRFS_I(inode)->io_tree, 0, i_size_read(inode) - 1,
-			    cached_state);
-}
-
-static int __btrfs_wait_cache_io(struct btrfs_root *root,
-				 struct btrfs_trans_handle *trans,
-				 struct btrfs_block_group *block_group,
-				 struct btrfs_io_ctl *io_ctl,
-				 struct btrfs_path *path, u64 offset)
-{
-	int ret;
-	struct inode *inode = io_ctl->inode;
-
-	if (!inode)
-		return 0;
-
-	/* Flush the dirty pages in the cache file. */
-	ret = flush_dirty_cache(inode);
-	if (ret)
-		goto out;
-
-	/* Update the cache item to tell everyone this cache file is valid. */
-	ret = update_cache_item(trans, root, inode, path, offset,
-				io_ctl->entries, io_ctl->bitmaps);
-out:
-	if (ret) {
-		invalidate_inode_pages2(inode->i_mapping);
-		BTRFS_I(inode)->generation = 0;
-		if (block_group)
-			btrfs_debug(root->fs_info,
-	  "failed to write free space cache for block group %llu error %d",
-				  block_group->start, ret);
-	}
-	btrfs_update_inode(trans, BTRFS_I(inode));
-
-	if (block_group) {
-		/* the dirty list is protected by the dirty_bgs_lock */
-		spin_lock(&trans->transaction->dirty_bgs_lock);
-
-		/* the disk_cache_state is protected by the block group lock */
-		spin_lock(&block_group->lock);
-
-		/*
-		 * only mark this as written if we didn't get put back on
-		 * the dirty list while waiting for IO.   Otherwise our
-		 * cache state won't be right, and we won't get written again
-		 */
-		if (!ret && list_empty(&block_group->dirty_list))
-			block_group->disk_cache_state = BTRFS_DC_WRITTEN;
-		else if (ret)
-			block_group->disk_cache_state = BTRFS_DC_ERROR;
-
-		spin_unlock(&block_group->lock);
-		spin_unlock(&trans->transaction->dirty_bgs_lock);
-		io_ctl->inode = NULL;
-		iput(inode);
-	}
-
-	return ret;
-
-}
-
-int btrfs_wait_cache_io(struct btrfs_trans_handle *trans,
-			struct btrfs_block_group *block_group,
-			struct btrfs_path *path)
-{
-	return __btrfs_wait_cache_io(block_group->fs_info->tree_root, trans,
-				     block_group, &block_group->io_ctl,
-				     path, block_group->start);
-}
-
-/*
- * Write out cached info to an inode.
- *
- * @inode:       freespace inode we are writing out
- * @ctl:         free space cache we are going to write out
- * @block_group: block_group for this cache if it belongs to a block_group
- * @io_ctl:      holds context for the io
- * @trans:       the trans handle
- *
- * This function writes out a free space cache struct to disk for quick recovery
- * on mount.  This will return 0 if it was successful in writing the cache out,
- * or an errno if it was not.
- */
-static int __btrfs_write_out_cache(struct inode *inode,
-				   struct btrfs_block_group *block_group,
-				   struct btrfs_trans_handle *trans)
-{
-	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
-	struct btrfs_io_ctl *io_ctl = &block_group->io_ctl;
-	struct extent_state *cached_state = NULL;
-	LIST_HEAD(bitmap_list);
-	int entries = 0;
-	int bitmaps = 0;
-	int ret;
-	bool must_iput = false;
-	int i_size;
-
-	if (!i_size_read(inode))
-		return -EIO;
-
-	WARN_ON(io_ctl->pages);
-	ret = io_ctl_init(io_ctl, inode, 1);
-	if (ret)
-		return ret;
-
-	if (block_group->flags & BTRFS_BLOCK_GROUP_DATA) {
-		down_write(&block_group->data_rwsem);
-		spin_lock(&block_group->lock);
-		if (block_group->delalloc_bytes) {
-			block_group->disk_cache_state = BTRFS_DC_WRITTEN;
-			spin_unlock(&block_group->lock);
-			up_write(&block_group->data_rwsem);
-			BTRFS_I(inode)->generation = 0;
-			ret = 0;
-			must_iput = true;
-			goto out;
-		}
-		spin_unlock(&block_group->lock);
-	}
-
-	/* Lock all pages first so we can lock the extent safely. */
-	ret = io_ctl_prepare_pages(io_ctl, false);
-	if (ret)
-		goto out_unlock;
-
-	btrfs_lock_extent(&BTRFS_I(inode)->io_tree, 0, i_size_read(inode) - 1,
-			  &cached_state);
-
-	io_ctl_set_generation(io_ctl, trans->transid);
-
-	mutex_lock(&ctl->cache_writeout_mutex);
-	/* Write out the extent entries in the free space cache */
-	spin_lock(&ctl->tree_lock);
-	ret = write_cache_extent_entries(io_ctl, block_group, &entries, &bitmaps,
-					 &bitmap_list);
-	if (ret)
-		goto out_nospc_locked;
-
-	/*
-	 * Some spaces that are freed in the current transaction are pinned,
-	 * they will be added into free space cache after the transaction is
-	 * committed, we shouldn't lose them.
-	 *
-	 * If this changes while we are working we'll get added back to
-	 * the dirty list and redo it.  No locking needed
-	 */
-	ret = write_pinned_extent_entries(trans, block_group, io_ctl, &entries);
-	if (ret)
-		goto out_nospc_locked;
-
-	/*
-	 * At last, we write out all the bitmaps and keep cache_writeout_mutex
-	 * locked while doing it because a concurrent trim can be manipulating
-	 * or freeing the bitmap.
-	 */
-	ret = write_bitmap_entries(io_ctl, &bitmap_list);
-	spin_unlock(&ctl->tree_lock);
-	mutex_unlock(&ctl->cache_writeout_mutex);
-	if (ret)
-		goto out_nospc;
-
-	/* Zero out the rest of the pages just to make sure */
-	io_ctl_zero_remaining_pages(io_ctl);
-
-	/* Everything is written out, now we dirty the pages in the file. */
-	i_size = i_size_read(inode);
-	for (int i = 0; i < round_up(i_size, PAGE_SIZE) / PAGE_SIZE; i++) {
-		u64 dirty_start = i * PAGE_SIZE;
-		u64 dirty_len = min_t(u64, dirty_start + PAGE_SIZE, i_size) - dirty_start;
-
-		ret = btrfs_dirty_folio(BTRFS_I(inode), page_folio(io_ctl->pages[i]),
-					dirty_start, dirty_len, &cached_state, false);
-		if (ret < 0)
-			goto out_nospc;
-	}
-
-	if (block_group->flags & BTRFS_BLOCK_GROUP_DATA)
-		up_write(&block_group->data_rwsem);
-	/*
-	 * Release the pages and unlock the extent, we will flush
-	 * them out later
-	 */
-	io_ctl_drop_pages(io_ctl);
-	io_ctl_free(io_ctl);
-
-	btrfs_unlock_extent(&BTRFS_I(inode)->io_tree, 0, i_size_read(inode) - 1,
-			    &cached_state);
-
-	/*
-	 * at this point the pages are under IO and we're happy,
-	 * The caller is responsible for waiting on them and updating
-	 * the cache and the inode
-	 */
-	io_ctl->entries = entries;
-	io_ctl->bitmaps = bitmaps;
-
-	ret = btrfs_fdatawrite_range(BTRFS_I(inode), 0, (u64)-1);
-	if (ret)
-		goto out;
-
-	return 0;
-
-out_nospc_locked:
-	cleanup_bitmap_list(&bitmap_list);
-	spin_unlock(&ctl->tree_lock);
-	mutex_unlock(&ctl->cache_writeout_mutex);
-
-out_nospc:
-	cleanup_write_cache_enospc(inode, io_ctl, &cached_state);
-
-out_unlock:
-	if (block_group->flags & BTRFS_BLOCK_GROUP_DATA)
-		up_write(&block_group->data_rwsem);
-
-out:
-	io_ctl->inode = NULL;
-	io_ctl_free(io_ctl);
-	if (ret) {
-		invalidate_inode_pages2(inode->i_mapping);
-		BTRFS_I(inode)->generation = 0;
-	}
-	btrfs_update_inode(trans, BTRFS_I(inode));
-	if (must_iput)
-		iput(inode);
-	return ret;
-}
-
-int btrfs_write_out_cache(struct btrfs_trans_handle *trans,
-			  struct btrfs_block_group *block_group,
-			  struct btrfs_path *path)
-{
-	struct btrfs_fs_info *fs_info = trans->fs_info;
-	struct inode *inode;
-	int ret = 0;
-
-	spin_lock(&block_group->lock);
-	if (block_group->disk_cache_state < BTRFS_DC_SETUP) {
-		spin_unlock(&block_group->lock);
-		return 0;
-	}
-	spin_unlock(&block_group->lock);
-
-	inode = lookup_free_space_inode(block_group, path);
-	if (IS_ERR(inode))
-		return 0;
-
-	ret = __btrfs_write_out_cache(inode, block_group, trans);
-	if (ret) {
-		btrfs_debug(fs_info,
-	  "failed to write free space cache for block group %llu error %d",
-			  block_group->start, ret);
-		spin_lock(&block_group->lock);
-		block_group->disk_cache_state = BTRFS_DC_ERROR;
-		spin_unlock(&block_group->lock);
-
-		block_group->io_ctl.inode = NULL;
-		iput(inode);
-	}
-
-	/*
-	 * if ret == 0 the caller is expected to call btrfs_wait_cache_io
-	 * to wait for IO and put the inode
-	 */
-
-	return ret;
-}
-
 static inline unsigned long offset_to_bit(u64 bitmap_start, u32 unit,
 					  u64 offset)
 {
diff --git a/fs/btrfs/free-space-cache.h b/fs/btrfs/free-space-cache.h
index 53fe8e293af1..2432f1783f47 100644
--- a/fs/btrfs/free-space-cache.h
+++ b/fs/btrfs/free-space-cache.h
@@ -105,23 +105,13 @@ int __init btrfs_free_space_init(void);
 void __cold btrfs_free_space_exit(void);
 struct inode *lookup_free_space_inode(struct btrfs_block_group *block_group,
 		struct btrfs_path *path);
-int create_free_space_inode(struct btrfs_trans_handle *trans,
-			    struct btrfs_block_group *block_group,
-			    struct btrfs_path *path);
 int btrfs_remove_free_space_inode(struct btrfs_trans_handle *trans,
 				  struct inode *inode,
 				  struct btrfs_block_group *block_group);
 
 int btrfs_truncate_free_space_cache(struct btrfs_trans_handle *trans,
-				    struct btrfs_block_group *block_group,
 				    struct inode *inode);
 int load_free_space_cache(struct btrfs_block_group *block_group);
-int btrfs_wait_cache_io(struct btrfs_trans_handle *trans,
-			struct btrfs_block_group *block_group,
-			struct btrfs_path *path);
-int btrfs_write_out_cache(struct btrfs_trans_handle *trans,
-			  struct btrfs_block_group *block_group,
-			  struct btrfs_path *path);
 
 void btrfs_init_free_space_ctl(struct btrfs_block_group *block_group,
 			       struct btrfs_free_space_ctl *ctl);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 343b6402bb35..c28642c6aa0e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9388,15 +9388,6 @@ int btrfs_prealloc_file_range(struct inode *inode, int mode,
 					   NULL);
 }
 
-int btrfs_prealloc_file_range_trans(struct inode *inode,
-				    struct btrfs_trans_handle *trans, int mode,
-				    u64 start, u64 num_bytes, u64 min_size,
-				    loff_t actual_len, u64 *alloc_hint)
-{
-	return __btrfs_prealloc_file_range(inode, mode, start, num_bytes,
-					   min_size, actual_len, alloc_hint, trans);
-}
-
 /*
  * NOTE: in case you are adding MAY_EXEC check for directories:
  * we are marking them with IOP_FASTPERM_MAY_EXEC, allowing path lookup to
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 65cb9dcf0aac..b2ac5b836b21 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3356,7 +3356,7 @@ static int delete_block_group_cache(struct btrfs_block_group *block_group,
 		goto out;
 	}
 
-	ret = btrfs_truncate_free_space_cache(trans, block_group, inode);
+	ret = btrfs_truncate_free_space_cache(trans, inode);
 
 	btrfs_end_transaction(trans);
 	btrfs_btree_balance_dirty(fs_info);

-- 
2.39.5

