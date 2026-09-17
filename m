Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E15B93B7750
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2026 04:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789617650; cv=none; b=SXwxLG8NHP4ee9jy8V2A/bbgJLphW/iPf/7qp6bjIe4VK8f9Kc9JS6jNYj3EOyLX73Mw3KHwT1xgQGzHIYxOa3nIsp6dINbkuBq2GX3QJZvRPKEVLjlSgd9fYbDkjFqsk0bMfAcNUa6H8Mm0Xe2n5doM6y2T5kW7hAXRw5gF2sE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789617650; c=relaxed/simple;
	bh=vKb/gGmZfXP29NVMCIBexCHeMi4FmxmfEWzn7IiL0cs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=jwP3dRF0Q02r7P9GkTY1B7fGZFktHLrLKVJdWsn+6pXK7w7qnXd301yxwbbFdLDqjdn14gwNrK2/UmqtZx0/8hLKicNfzpABj0Zyax74q16qsqRwrZqGWFeLxVDLqjoyN3F2cGNzXhMDl/JSezTi1rT+/wbDbJTnyljtB/RmYTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=IPs6Hh9o; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=3ZRVdTVA; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="IPs6Hh9o";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="3ZRVdTVA"
Received: from pps.filterd (m0167072.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68H2YhTA1938878
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2026 00:00:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=FGtc
	1NLeQBu+kS94gpur8nkzS5KJcdAIY3+s7g2GWMM=; b=IPs6Hh9oUk1kjhoFvM+s
	OoXXRezjo1j+KH3GPGYh/VL+t7jNjA6d4cUUaLvswdK2L8aXwboqSmgkTzIYm/3l
	Hxv2PYzNw/7WsoGKOvYUnkgEyy9CdrY82ddWnta1jlWrJ89xEdiZjpmo24APF4Uf
	CartuFNapCu2dGzgGuRpbP05QgkYjcqbqOA1Xxd06VwUsH46pHYCAtg+D/5dL8oG
	/zslXMgO+0VGCrdvJh4aD++Eq1uHeln3Pr0WkjrVYdp37TGdsJNHvO85GH+rTmRf
	7C/VotIgGzYlN1MfXZIr6G2dMGnVgfQ9jVRJfqI350KYnrgzX9VAMLuKaeK+yTCm
	kw==
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com [209.85.219.69])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gr33qsseq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2026 00:00:43 -0400 (EDT)
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-912054a1c29so5747296d6.2
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 21:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1789617642; x=1790222442; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FGtc1NLeQBu+kS94gpur8nkzS5KJcdAIY3+s7g2GWMM=;
        b=3ZRVdTVAOofZXO0vQ8iNNbK1kMb46/fWNSYunYJV7IvOMAAPprTtkLVeSfcmfXK0DD
         jmgE/93v94u83AJdmG0ji7dwd3P4IsBXeTUhwF/zyIS3D3zRoRxlVo2ROL0TM4bwaq6y
         UyiptV3M28/fxPGSiSmKX8HeHOasuANxeN/bQfZeRQSZXONX5cpiiXZQ60pd/LVmtc9G
         L0dgANB/ZuMYulN+JK7KhUY/QBf9kKU54QouWqnUaO0VvAl+DDjaMBQinGcUL9VHpg3o
         VkIL+YVRGz+385jydLF3MawNZ/YBeZj3paAw5tedRpXUyZ9+5zSCd7tmeNTZ1ahK0PuD
         7VoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789617642; x=1790222442;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FGtc1NLeQBu+kS94gpur8nkzS5KJcdAIY3+s7g2GWMM=;
        b=S/a0+INfiuxI9qewuIk0AVTTOQBUxcKB/63Pp1+gtoQpVzeq3b+7UD/Xa0+VtnYDZr
         v3NfC0iBztOT7jUgGKdpBqmUEIBraMJvQNYrAElFQgfMWXOlwgOyFbCYaqW91Zsjv5O4
         GOXD1T4U1sbLS8KQRq4pMwWzwQY6/LiB9qBONnMgwDD9hr7nlNqWT+4hHV9wRJnX4Ql/
         37mKIibpGJctDl75BcMr4V7zFPg80GGOy4a9EFjygNqhYQi1/LUjAa6n55eDiS3zltsR
         b3+VN2rB4ovX77MYcxnsLywcnYTuKfs1AY140IlFLG2Zdpg8ByZYAeHjL8vHK7EwQ1MD
         fUcg==
X-Gm-Message-State: AFuF++kb6bYm0JHcRefr5CyQsSaEThf05rezF9HUhHQvRXQtD3asH97E
	/VdjETs1MyhW5/2YqajkCkQLvyN+lTHduUacK9uG1pPKdNXpxWaYdfVBtohD9ZZzf/cXVbdfYph
	r3mmrLSrOXgZRszETZYirOPP2Mt9odntVxzMoJFEZdyUmXnXIl9qIgsXO553B
X-Gm-Gg: AYBFou2AgN6vixchYLxt556ro4h7VzyJXJw2jaJO3Gr3qj1WMcb0YwyGcL+3G+L0nD8
	1Z00e6JvEx+VctPGjBQPNW9C8ECuqSoOBvdYAui0HXtOQZ8NfhZjmDAZ4L7gA45HVDNwdEAtzAd
	b1gZvIQeTzC3e/7NsmdNqkOJAQcNH364NP9Iq4ZSVPX9jlrB/wji5z1h7Mfe4rPkvRZfN29S4Sy
	0rlwiSOTSZ751N/ojUKH32iw7rI13xZjG2QA+h1USzKFLPaOKLEj1wJYrmc3WxZN5Er6W2IR5Dt
	mPy6e3qnqOuU8KtLKE12M9rIdKkCjqLBpg7CAEn+RX4EPWwubXxn3htJOk4I1RV+vydEEO88+J3
	sUFErADsiX9ta079hjKNU/Yt9UWxmzic8yjWacpm9cGDbYA==
X-Received: by 2002:a05:6214:5d82:b0:910:4954:7992 with SMTP id 6a1803df08f44-9123d62eb5bmr100997926d6.0.1789617641832;
        Wed, 16 Sep 2026 21:00:41 -0700 (PDT)
X-Received: by 2002:a05:6214:5d82:b0:910:4954:7992 with SMTP id 6a1803df08f44-9123d62eb5bmr100997186d6.0.1789617641282;
        Wed, 16 Sep 2026 21:00:41 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9123beadde6sm41748766d6.35.2026.09.16.21.00.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 21:00:40 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Thu, 17 Sep 2026 00:00:10 -0400
Subject: [PATCH v3 14/17] btrfs: remove the free space inode special cases
 from the COW paths
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260916-btrfs-remove-v1-space-cache-v3-14-10ebde03b96f@columbia.edu>
References: <20260916-btrfs-remove-v1-space-cache-v3-0-10ebde03b96f@columbia.edu>
In-Reply-To: <20260916-btrfs-remove-v1-space-cache-v3-0-10ebde03b96f@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789617622; l=5995;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=vKb/gGmZfXP29NVMCIBexCHeMi4FmxmfEWzn7IiL0cs=;
 b=vfPdwZEzVjmRUbyCBqWNioCxb5vsagNpbfCKMM+j/XKWvAaEJjeaSwMXR4d38wIucdwb4OVBt
 XjkqCyz+wRyAb78zq68DRWevjofRkmBwH0lpE7rbtJYkCdHToKdNFOr
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: WX8NV39pq46D45Sumn9tCIo6v6MHfbTM
X-Proofpoint-ORIG-GUID: WX8NV39pq46D45Sumn9tCIo6v6MHfbTM
X-Authority-Analysis: v=2.4 cv=O72sLx9W c=1 sm=1 tr=0 ts=6aab65eb cx=c_pps
 a=wEM5vcRIz55oU/E2lInRtA==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=SsB-OO3BMngHh3ZO9fOt:22
 a=2oXXyLKhFp2WroVMdz4A:9 a=QEXdDO2ut3YA:10 a=OIgjcC2v60KrkQgK7BGD:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE3MDA0NyBTYWx0ZWRfX0mZamcZZRbLF
 dPD58obGLk6NJvbSW2M9O1D8/ESwdiAI9Sgl7pIhnvow8v8cruopY3tEfmq3ik3+sTNi5lwb4ax
 oReqJlpldmtawV8F5Yy5Z8we5qnfgw657500TexBYjEOmEjN/dP17qO7fa9wNWnkc/djoMTssZd
 q3fn1mzperUMNzj78N+WGXuf5llH2KBDaFpvFG+Sd5/OpddCmtElMKYTRClbmgX9FKJ6IPOQu5E
 kvlioYiQrfK416O0agWRFpkg9f1y57XCoPZGgci0rOhJu2RL9OTQGQuVq88/Cmku6+wFsAGaCp9
 cOe4S0Y97rH2tE3HTyDBdIapBYLE4nZO/OMaaJOcc7cqlM4CfH4hu8sp3sEU4CLQFd7G3vvgCy1
 VqQ6OIVA1IFn7ZGZn1sSHBXmbuzBmTT10Rsy2/uUxI0BxMYtEhj2vBN9ukf0odpfd83mMt451HC
 ey5qla1ycCAyinQJY0w==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE3MDA0NyBTYWx0ZWRfX1eqWNqWnOQH+
 2EVRDIsUVwyJRKT+dIkZ7WzpA+SeMP5asTUKbut8Dy2YL1z5wcgrdde4g2qfvSRCnWamIZS5OaR
 H0kkPegMFrw/Klr0Yk7KWTGM9/HoRPPlaI9w4rSyIkFE53c+u6uS
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11907
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 spamscore=0 suspectscore=0 lowpriorityscore=10
 priorityscore=1501 bulkscore=10 adultscore=0 clxscore=1015 malwarescore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609170047

Free space inodes are never written anymore, so drop the special cases
for them in cow_file_range(), fallback_to_cow(),
can_nocow_file_extent() and btrfs_finish_one_ordered().

Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/btrfs/inode.c | 58 +++++++++++++++-----------------------------------------
 1 file changed, 15 insertions(+), 43 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index dec1a848c7ca..c8292174b550 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1366,11 +1366,6 @@ static noinline int cow_file_range(struct btrfs_inode *inode,
 		goto out_unlock;
 	}
 
-	if (btrfs_is_free_space_inode(inode)) {
-		ret = -EINVAL;
-		goto out_unlock;
-	}
-
 	num_bytes = ALIGN(end - start + 1, blocksize);
 	num_bytes = max(blocksize,  num_bytes);
 	ASSERT(num_bytes <= btrfs_super_total_bytes(fs_info->super_copy));
@@ -1680,7 +1675,6 @@ static int fallback_to_cow(struct btrfs_inode *inode,
 			   struct folio *locked_folio, const u64 start,
 			   const u64 end)
 {
-	const bool is_space_ino = btrfs_is_free_space_inode(inode);
 	const bool is_reloc_ino = btrfs_is_data_reloc_root(inode->root);
 	const u64 range_bytes = end + 1 - start;
 	struct extent_io_tree *io_tree = &inode->io_tree;
@@ -1713,23 +1707,22 @@ static int fallback_to_cow(struct btrfs_inode *inode,
 	 *    extent_clear_unlock_delalloc()) the bytes_may_use counter of the
 	 *    data space info, which we incremented in the step above.
 	 *
-	 * If we need to fallback to cow and the inode corresponds to a free
-	 * space cache inode or an inode of the data relocation tree, we must
-	 * also increment bytes_may_use of the data space_info for the same
-	 * reason. Space caches and relocated data extents always get a prealloc
-	 * extent for them, however scrub or balance may have set the block
-	 * group that contains that extent to RO mode and therefore force COW
-	 * when starting writeback.
+	 * If we need to fallback to cow and the inode is in the data relocation
+	 * tree, we must also increment bytes_may_use of the data space_info for
+	 * the same reason. Relocated data extents always get a prealloc extent,
+	 * however scrub or balance may have set the block group that contains
+	 * that extent to RO mode and therefore force COW when starting
+	 * writeback.
 	 */
 	btrfs_lock_extent(io_tree, start, end, &cached_state);
 	count = btrfs_count_range_bits(io_tree, &range_start, end, range_bytes,
 				       EXTENT_NORESERVE, false, NULL);
-	if (count > 0 || is_space_ino || is_reloc_ino) {
+	if (count > 0 || is_reloc_ino) {
 		u64 bytes = count;
 		struct btrfs_fs_info *fs_info = inode->root->fs_info;
 		struct btrfs_space_info *sinfo = fs_info->data_sinfo;
 
-		if (is_space_ino || is_reloc_ino)
+		if (is_reloc_ino)
 			bytes = range_bytes;
 
 		spin_lock(&sinfo->lock);
@@ -1794,7 +1787,6 @@ static int can_nocow_file_extent(struct btrfs_path *path,
 				 struct btrfs_inode *inode,
 				 struct can_nocow_file_extent_args *args)
 {
-	const bool is_freespace_inode = btrfs_is_free_space_inode(inode);
 	struct extent_buffer *leaf = path->nodes[0];
 	struct btrfs_root *root = inode->root;
 	struct btrfs_file_extent_item *fi;
@@ -1807,8 +1799,7 @@ static int can_nocow_file_extent(struct btrfs_path *path,
 	bool nowait = path->nowait;
 
 	/* If there are pending snapshots for this root, we must do COW. */
-	if (args->writeback_path && !is_freespace_inode &&
-	    atomic_read(&root->snapshot_force_cow))
+	if (args->writeback_path && atomic_read(&root->snapshot_force_cow))
 		goto out;
 
 	fi = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_file_extent_item);
@@ -1857,7 +1848,6 @@ static int can_nocow_file_extent(struct btrfs_path *path,
 
 	ret = btrfs_cross_ref_exist(inode, key->offset - args->file_extent.offset,
 				    args->file_extent.disk_bytenr, path);
-	WARN_ON_ONCE(ret > 0 && is_freespace_inode);
 	if (ret != 0)
 		goto out;
 
@@ -1892,7 +1882,6 @@ static int can_nocow_file_extent(struct btrfs_path *path,
 	ret = btrfs_lookup_csums_list(csum_root, io_start,
 				      io_start + args->file_extent.num_bytes - 1,
 				      NULL, nowait);
-	WARN_ON_ONCE(ret > 0 && is_freespace_inode);
 	if (ret != 0)
 		goto out;
 
@@ -3203,6 +3192,7 @@ int btrfs_finish_one_ordered(struct btrfs_ordered_extent *ordered_extent)
 	int compress_type = 0;
 	int ret = 0;
 	u64 logical_len = ordered_extent->num_bytes;
+	u64 unwritten_start;
 	bool truncated = false;
 	bool clear_reserved_extent = true;
 	unsigned int clear_bits = 0;
@@ -3364,29 +3354,11 @@ int btrfs_finish_one_ordered(struct btrfs_ordered_extent *ordered_extent)
 		if (ret)
 			btrfs_mark_ordered_extent_error(ordered_extent);
 
-		/*
-		 * Drop extent maps for the part of the extent we didn't write.
-		 *
-		 * We have an exception here for the free_space_inode, this is
-		 * because when we do btrfs_get_extent() on the free space inode
-		 * we will search the commit root.  If this is a new block group
-		 * we won't find anything, and we will trip over the assert in
-		 * writepage where we do ASSERT(em->block_start !=
-		 * EXTENT_MAP_HOLE).
-		 *
-		 * Theoretically we could also skip this for any NOCOW extent as
-		 * we don't mess with the extent map tree in the NOCOW case, but
-		 * for now simply skip this if we are the free space inode.
-		 */
-		if (!btrfs_is_free_space_inode(inode)) {
-			u64 unwritten_start = start;
-
-			if (truncated)
-				unwritten_start += logical_len;
-
-			btrfs_drop_extent_map_range(inode, unwritten_start,
-						    end, false);
-		}
+		/* Drop extent maps for the part of the extent we didn't write. */
+		unwritten_start = start;
+		if (truncated)
+			unwritten_start += logical_len;
+		btrfs_drop_extent_map_range(inode, unwritten_start, end, false);
 
 		/*
 		 * If the ordered extent had an IOERR or something else went

-- 
2.39.5

