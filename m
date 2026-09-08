Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE4C2199E89
	for <linux-btrfs@vger.kernel.org>; Tue,  8 Sep 2026 01:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788830416; cv=none; b=URWH5THNeJP3V7pKGjiMvDQoksseMYguDsmOskhcPqXeVMJUI+u00xKdKT5OvJUIcrUHcbwOk7KgOougjUdGudESwwqWcSOiIzFw2vNn0za+wOGnxVT2bW+QEMWhSa9tJmyqqcLlrhBwbL0Is+glvn1N8Sapcqb1XS8m4DPW+Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788830416; c=relaxed/simple;
	bh=5BX7b0Fn4lrAd8IzUqTtxpVtKEO9oMmcmNEguv7W6EA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=qsxlgqVj4jgjfDN+QxbvXO6meEM08m3VH4luN6K8RyYWJLDD09nr0op5qwry+g0iGzl7YCQ9PJWxkanO6lOZxCsALqRGiZHQQEVi6yC4XQE7ILibsB2DHaGOab1O2W+QxVHJ0pSeWkMSH8GmTLKmfP19ljdjHGSInrPIbhhYTaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=tx3d9fPp; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=qgtcN+uq; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="tx3d9fPp";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="qgtcN+uq"
Received: from pps.filterd (m0167069.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6880uVxf3139975
	for <linux-btrfs@vger.kernel.org>; Mon, 7 Sep 2026 21:20:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=UA6N
	JYZg/aPbQbH6BdIy9bC46w35+B3geZZbPXF04I4=; b=tx3d9fPpP9MyTAJ8o/DN
	9j8cQ8R9SOWgA+s0xZUaYIdrvTF67MiCjsLKdyQFRGrfzxomupjtZzF0sWVj3PsQ
	4NhZ7CaVI9aoNQfJ527RZRR9l0q6Q41a731/2apeIqtdTz8chQGLnPpwN+c+XneD
	5i8CH+nrh0f7ytnUJUi1V996enL+sQ01TgxHPnc2MVtb29tX5BPBNMdM3B4LcQCz
	kip83siWg8c+JOohV8LeYDeejTYV3BrRZHcM9cuBLKrGS0kNtqmwLquIYNl50uFg
	7GSVR5MjSUJCPUoQFNtvnh7rZQhHQ5o1DE80W65TAIC5kg5pMf3nAGxqgLe7w47f
	2Q==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gj4aas6un-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 07 Sep 2026 21:20:02 -0400 (EDT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-52d33c89a29so91898511cf.1
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Sep 2026 18:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788830402; x=1789435202; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UA6NJYZg/aPbQbH6BdIy9bC46w35+B3geZZbPXF04I4=;
        b=qgtcN+uqzGCzBvtDZreq8vm/tvEEe3NdNSxv+aULtWCpJ1hl6B7Xn8F08DO0DX3nsh
         X0EIcUVF16rvS0mIT0p4voCXMY78bpZk8Law0x5rjVN38NZDpVMVGwfEeMRP4zGGTw7G
         ge3TwJTAwGIqGDrL9Zil5HJ4drh4F6T9beC1TOMGsizA6G1UESDkl5c22eoiygrzkahf
         NA7M91daDMvf0pkG9SP7KLrALhHZj1csRWgc8cpwoUaAuTADlMQYuERG8aTXpTZ6WF7U
         EYrde21nKFlsf3RubkNPep0HZBfp9tO9Fqw/xsaADSHCbbZh77TEd7m8yO4f+RQu1n3o
         i4aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788830402; x=1789435202;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UA6NJYZg/aPbQbH6BdIy9bC46w35+B3geZZbPXF04I4=;
        b=TQ0WvZ04GH6OTpDWDFdh39PSJTmQUQA/JJQvDtFJ+UgoOELN3hCRXtJ1Saqt9sx0I1
         Op0zkd7mFRsZV7Meo3ExCwf4NLMTzQOQeXSPiRZa3Ftf2YiiNkwPcJEqqBGU1uSZ5dZP
         UvCSl7hj5pClV9xeFvBNyryC0f5VCeUUuQ4dgJSQM7wcO32XBb+JLm5E55RFeojKzYPS
         NFjjc7TISSdTUP4mbEBSFXxLmVEm50t8TY8I5iT2NrOQ+Msha65d5FCLFiiCRaIMlSYU
         gwPjBLx8BPs7FnoUhtr75cpeXTTWgDJHlezd9MFAc8mQoCytbZukf/1AQf5YNj+rf8wG
         MLVw==
X-Gm-Message-State: AFuF++k1TmWfkMQpdQOblRLrde13kRW2dZYV4h7Jtss+6XKDlGTNoY4f
	J9Kl+fPVNbE4B/ENZFMi2GEWlGt/5piVXddHZMJ6+e8kmAjdWcUy2GjXUJxPZysmh8kpB9Voj0+
	MrTCipBtaV0C/alxP1Mm/7YK8YesKpw8SwC2qh3yINaTl8ckt4aK+qZvg5Ckk
X-Gm-Gg: AYBFou0cRVoFPLoiiqnWpA2GZeBsg3zXG69l6fQUazYvKGWVWNVZ/LU1luWGrtdzn/g
	gFNR7idXoKAeaLejn01RtGPDb3oEI/dce/TgtEJie7WkFGmj4hOZyjJ+yucUfr2OT4CMc+lzQLT
	lF4b51OCU1jqaFKOk7cXr3jzHETGFtq2i/ZjDUIdtK0WimXeoHRUfR6/HBE9uk6rwKxjTDcGfWw
	Oh3y2VCtLWtoGbYiMm23l7qbHBdq79iL3Gnk9ilyVs7GhBPXamhvW0hAU6r5xnb1AiaKDGdw1Xm
	TB/PA1r/6VEkR2HvROrYB26l44hqODzFe7p+cSc0uVK/5rQZUixRGqE9bDw+81TsTb9zAby7E2R
	m6ls2hrExFuoczfLGaU9aTLpq5YVAwNjbPSMHOCgk2leNbGXBedQ=
X-Received: by 2002:a05:622a:2509:b0:530:50d7:e5b7 with SMTP id d75a77b69052e-530546bdd01mr355760841cf.9.1788830401792;
        Mon, 07 Sep 2026 18:20:01 -0700 (PDT)
X-Received: by 2002:a05:622a:2509:b0:530:50d7:e5b7 with SMTP id d75a77b69052e-530546bdd01mr355760281cf.9.1788830401335;
        Mon, 07 Sep 2026 18:20:01 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91040694543sm104322656d6.33.2026.09.07.18.20.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 18:20:00 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 07 Sep 2026 21:19:28 -0400
Subject: [PATCH 13/15] btrfs: remove the free space inode special cases
 from the COW paths
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260907-btrfs-remove-v1-space-cache-v1-13-5f9a5ba352a7@columbia.edu>
References: <20260907-btrfs-remove-v1-space-cache-v1-0-5f9a5ba352a7@columbia.edu>
In-Reply-To: <20260907-btrfs-remove-v1-space-cache-v1-0-5f9a5ba352a7@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788830387; l=5995;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=5BX7b0Fn4lrAd8IzUqTtxpVtKEO9oMmcmNEguv7W6EA=;
 b=pV5+cJu0SIlo7XQ51kCvxqXHXnQZygQaRxMBYy9ISJDYOhpHtYQY3Lm9Mx90ymliJmAI9SzE+
 nexBfs+A68JCp+0qf9pvHjOwOj0vjHvaMjatZ0YIJeyAigThjldphJd
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDAxMiBTYWx0ZWRfX9v8Moymv1R1S
 PnZ1eVpwZPQiTHW9oLqQLcsvKcA2MjTFq2YDxpe0KESTralyN7ccpvH48tuL9L3j6WU480pDro3
 j9Ecj3KcdEicBr2BuGyR27urbPcDIFqFFi1Tt7f0gAH2aQ29YEXPR6DoPCFzmKaUNEcmEgoZzwM
 M4A7blUUX1d0aEE+IOe0N5nBs0UaOqH83IXtKHB98NHIs5aKy9Y3Tj6Q/n1hg6VUs9W6W8SUgif
 57HjD2sJTjEZzFKe8CDbIKXHTzvoMqd0XcFyngPpum4ePZIRcmvWZcWELnB0wZJwdU1zIXmezLa
 r5MDoOiaQp1dG7oUqPeWE8zD5iFk7x+XbUqgQvNC+O/HZaw1LDwtb4L6VIzXTbXyRnLbJiLlO96
 OVsPqVvkGbDf1zwr2bzkUh+55MJ9Tsptx9RHmyOFlzOnoWWRO7u/dUc+dtgwBYuZB7dp4CtlWfc
 yCYdawG0V6RYljJD3Ag==
X-Proofpoint-GUID: BjoapTHcPbbqRJdTtmDZs500_-t5Sa0W
X-Authority-Analysis: v=2.4 cv=atuCzyZV c=1 sm=1 tr=0 ts=6a9f62c2 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=JR4YdQiviy7OQf72WyZ1:22
 a=2oXXyLKhFp2WroVMdz4A:9 a=QEXdDO2ut3YA:10 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDAxMiBTYWx0ZWRfX9kKI47Yaasgn
 CBs3wDEQ5db6sdk69LY2oYjukFUUud4VcNNvXdrPGqsDypUJ4o/WiX3BMr240PtqvbfKqAeUlLe
 hNjhHiMTT9zoFpc8vkRq04Mok7xLWQsItfz1dJPF4mMXOl5rd7N2
X-Proofpoint-ORIG-GUID: BjoapTHcPbbqRJdTtmDZs500_-t5Sa0W
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11899
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 impostorscore=10 malwarescore=0 lowpriorityscore=10
 spamscore=0 bulkscore=10 clxscore=1015 adultscore=0 priorityscore=1501
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609080012

Free space inodes are never written anymore, so drop the special cases
for them in cow_file_range(), fallback_to_cow(),
can_nocow_file_extent() and btrfs_finish_one_ordered().

Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/btrfs/inode.c | 58 +++++++++++++++-----------------------------------------
 1 file changed, 15 insertions(+), 43 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5e4ecd1fe194..137d2c1d9c97 100644
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

