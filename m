Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7304BB808
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 16:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791822539; cv=none; b=AYMZ71HS0zubnmBFhrnx0LREhAE6bOkR+3qxp6YcA+zjaA+3Jx8oE+Q13pdnLNzK8f+LKD8KDxdTfD+QF/k5vjA74Y6isCS4Cz9zK8njtmZtEnyKgCpLWfhsG8jTW/14XyZEp5Ww7zAjUpqwOJdQOSU9TleG+MNokrd5NJytl5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791822539; c=relaxed/simple;
	bh=ntgtmQwOR/1gGUXFgL2raQZ0p7fFOeh+HmbNiYdaCi8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=XFbrXVE4dqcQGC+mtDpmP1nRQvlSrYujlBAQqaISZWnQv3WNU9K905TqaQtgE5KPLkojinWbgNopR/zPEjAt10z/gZoNxzzdcE9Mazw4dMfVibBkh69mdlgbEE4iPJO+kEGQxdfeEBwinU316+2JZn3mQ7kb4yIF6MkXkZ0pgBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=nhVWus0l; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=eKRBrsnM; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="nhVWus0l";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="eKRBrsnM"
Received: from pps.filterd (m0499198.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69CEgTeR1222137
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 12:28:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=2jwb
	ccsJz6WrPoqWzLm66RWjEqeiDyrW5BNsZPM1E/4=; b=nhVWus0lxJuI5dOPZHs0
	lIvjXRjiOb0VTRNBTFACSfW8fYe8upfSVD+GPqaxfZGO3cULOQMCgAv4BzN16dST
	hUIEHS/Vdzm7/9D3gPylrov4yBAtrmonO8zPoXfHlPHQ/6qmOnh5oNMZCsJn8flh
	zqjU/UKbABW9xYVrlDBuYJ3m7ySbh37MYmhrDM86G4zkP+SowfxcF8vWkGKAU9Jf
	LhEmwwuMBj5+ZhfyJggxpg69C/6NLJ1yoqy5we4fMiqmpCP6VYmbg2DlOQ1ZEh4A
	cDVQlWQq5linVAJ7tZnpylhypxpbCcM0rBp/sIsj9dQ+00DpF++DiqMQA8tkBkQc
	Kg==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4h8y4w2svp-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 12:28:54 -0400 (EDT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-535252004e9so54075841cf.1
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 09:28:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1791822534; x=1792427334; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2jwbccsJz6WrPoqWzLm66RWjEqeiDyrW5BNsZPM1E/4=;
        b=eKRBrsnMNdK61EIs+OK7VAyRVhrtnEOs8eATHKipSyP/ncamDl/KfBkWBRcGAqytzM
         mE4cGYLR5ycs0sSeAichXVe1peGGVW638FW6v4EAYLX8QiGExWptAJOoLiFGVSvfu8na
         Bub7V6ki64eZU/iD5DQTxy46tfqgMEGcmozzVG4E8Gacm4oHo2My5vNLbNxsff5Ikm5X
         S5S0ZWLhIzXmR8QTSVtrvG3FetEY21Vm/5aWpZuO3EkNZeUs1loYmROClEytq9PKYEgR
         kvZUeDbkt0lNiZsnXNYu2lpFqlOiVVt47dleffTGEKAcFbJO/b2lHMa3+ovl/TMdJrGG
         XDcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791822534; x=1792427334;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2jwbccsJz6WrPoqWzLm66RWjEqeiDyrW5BNsZPM1E/4=;
        b=koLn60ullgJM5Bd3XEpi16/pH7x1AmoAockVvl1qdePE6tg8ps+FNI6dZT3cjt4+hT
         EOkuY4JDeqoJyZXE6Q4ZcO9k5Dny570fZSjXuGQC5xCNZAKEYZtQhx/hCv3aC3PHfUc5
         k1BPKSczANNjVhkZ/OlDmQvVSY59q1GUnZaZqsYGuvRUEVkWoa/lLMHKP30Mx3ucVxXl
         eT/IpnJZWv04e57/ck694+EFlN0FEYAVrAxRvnQzvUHgh+79f4XBgP00GcxUkQK3527N
         R8yJa61Lo5sjLP1Heuh2WdUvDxbaAj2+oxBKkAkNBDsg1UbQ0RYqR+qXZcZaGxGs+X6d
         XMzQ==
X-Gm-Message-State: AFq9FYIZzaX1ENFTUBvydgxWrcbUK42hFk6emKYN1Qh8KV2a3JeIvvS6
	154eY9ZiDVGWdpS9ntFVcBJD/xd/oY7TnnxKgI46lo6BfUulxijW4yIq82fEleBGolsg1c/yx2s
	qmQa8nWS6Sk18mkKkaXMKJ8Fl1UiqUXsQQqklHxd71uTGySza7ZrjuALIl12N
X-Gm-Gg: AYBFou0DhyiqEY3/VSorCosHdSIYrB4qGhltueAO+z9cqmNh4k+dOfrlLGjQNiJdGjw
	K1IAEhzQpbXP1BJt0ih1zwh2OZ2uUxcSjjj+0SWDngtJZ62PjXq1uV4agPn0fZXTx68UVkpRvWM
	Yt6dGv7ekibuAMX5xNqjYYn6abZukcxuCXsMS5Q0OesZ+43IuZ/6Ej76npPgB3Y0BppumZEoehl
	1WAMCQTfXc7ITUIUjf5VtKgeqi1YJVktNs1yu1WK62icBrpSVcLrj9iZjwt95Uv9de8R9LDtzU5
	FfHyZg/qgs3rA7344bd9+URfqYDAPDaTFMqS6KFOlcqa8NRUz8ed5Of/5dPCXVMUHFUhMZf5zXr
	YEy9PdJDA5vSF55qGxA9A3XbY0z8BuZJbYMON8/0v9cT7bd4=
X-Received: by 2002:a05:622a:1244:b0:535:baa:a78a with SMTP id d75a77b69052e-5359fb5eb12mr140725381cf.39.1791822533516;
        Mon, 12 Oct 2026 09:28:53 -0700 (PDT)
X-Received: by 2002:a05:622a:1244:b0:535:baa:a78a with SMTP id d75a77b69052e-5359fb5eb12mr140725051cf.39.1791822532988;
        Mon, 12 Oct 2026 09:28:52 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-178-231.net.columbia.edu. [128.59.178.231])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b97c27146sm1411796d6.29.2026.10.12.09.28.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 09:28:51 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 12 Oct 2026 12:28:27 -0400
Subject: [PATCH v4 15/18] btrfs: remove the free space inode special cases
 from the COW paths
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261012-btrfs-remove-v1-space-cache-v4-15-f125bd8c07f9@columbia.edu>
References: <20261012-btrfs-remove-v1-space-cache-v4-0-f125bd8c07f9@columbia.edu>
In-Reply-To: <20261012-btrfs-remove-v1-space-cache-v4-0-f125bd8c07f9@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791822515; l=5975;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=ntgtmQwOR/1gGUXFgL2raQZ0p7fFOeh+HmbNiYdaCi8=;
 b=f6H+TrWKzJ96Uv7RZPOfxdnwHyTY2iksxKTwFilJc2q6vU9HoR82m/qEThwaGldAKkK4lvfb9
 c+TghikPlEVA+jxm3LS3jBt9PR/auEPGSQMhY1aZtsJOe3068q4Qlai
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEyMDA2NSBTYWx0ZWRfX+YizN5Ve0JhX
 cuqJ4uhtzgrV/cY3xnMrJg/8uP1Pmd4VExVf16bBEzFdIXz1v04v50dD5uc0FR2Jy/OJX5ofG4D
 YbTxgyOYqNN1/vBuWcUwDDef3b7+O6H8k+103NnwT9wwalb71E8j
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEyMDA2NSBTYWx0ZWRfXxA8KKYM8HmDw
 BWVukdfZKmxRUkQE0rN/MoW/SJ8srwRpiUxgZ/TN1ORcgQclt+H2Q9RqcbJz1CImng88BiPH5E+
 /HIQwTZwDLymFz51OEQBabf+MYvY9CX3yjf46TaelSXJTM9mLnnsll7yqup8LHASsGUSXpAHCjN
 B2/Euv4zBHrAQps5SH8+rfmMYFk+Zrvg/yEM1n7MVwA/+Qw/QbbKnm6jwP88NStJJk851FMsF0r
 MHdwMIRes+o2dqB59AjBgjGcG8FlMQlRqg8sNFQmEGqm88infCBhuSqD/VeJA/8UkOBOKD2p1nd
 ewHiMLoC6eXUvdvVhTdj8lbclGzUzFoVADu9Gp9ZCc+hYQABnVMq+IeMPNtOIEx1UOXnBW84kK7
 tULV91WY4YRGHPhmoHgk8KZsslcwedOG5bvjd/nQeD4n5GgzdHStegPAWA+prBlfMiNvzGcHEFa
 dY+rr3Aua8lDQBiZX/w==
X-Authority-Analysis: v=2.4 cv=GOydgeNK c=1 sm=1 tr=0 ts=6acd0ac6 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=9fnr1hFzp71kSIFw8uYQYA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=BpGzv1V74M3SfeTrGa8v:22
 a=2oXXyLKhFp2WroVMdz4A:9 a=QEXdDO2ut3YA:10 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-ORIG-GUID: OpSaiDU5VKr9WVFaQNjbtC5Ftv_ayuCA
X-Proofpoint-GUID: OpSaiDU5VKr9WVFaQNjbtC5Ftv_ayuCA
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11933
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=10 phishscore=0 adultscore=0 impostorscore=10
 malwarescore=0 priorityscore=1501 lowpriorityscore=10 clxscore=1015
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610120065

Free space inodes are never written anymore, so drop the special cases
for them in cow_file_range(), fallback_to_cow(),
can_nocow_file_extent() and btrfs_finish_one_ordered().

Assisted-by: LLM
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/btrfs/inode.c | 58 +++++++++++++++-----------------------------------------
 1 file changed, 15 insertions(+), 43 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b7e8a17d3861..5a8f028b2a7d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1369,11 +1369,6 @@ static noinline int cow_file_range(struct btrfs_inode *inode,
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
@@ -1683,7 +1678,6 @@ static int fallback_to_cow(struct btrfs_inode *inode,
 			   struct folio *locked_folio, const u64 start,
 			   const u64 end)
 {
-	const bool is_space_ino = btrfs_is_free_space_inode(inode);
 	const bool is_reloc_ino = btrfs_is_data_reloc_root(inode->root);
 	const u64 range_bytes = end + 1 - start;
 	struct extent_io_tree *io_tree = &inode->io_tree;
@@ -1716,23 +1710,22 @@ static int fallback_to_cow(struct btrfs_inode *inode,
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
@@ -1797,7 +1790,6 @@ static int can_nocow_file_extent(struct btrfs_path *path,
 				 struct btrfs_inode *inode,
 				 struct can_nocow_file_extent_args *args)
 {
-	const bool is_freespace_inode = btrfs_is_free_space_inode(inode);
 	struct extent_buffer *leaf = path->nodes[0];
 	struct btrfs_root *root = inode->root;
 	struct btrfs_file_extent_item *fi;
@@ -1810,8 +1802,7 @@ static int can_nocow_file_extent(struct btrfs_path *path,
 	bool nowait = path->nowait;
 
 	/* If there are pending snapshots for this root, we must do COW. */
-	if (args->writeback_path && !is_freespace_inode &&
-	    atomic_read(&root->snapshot_force_cow))
+	if (args->writeback_path && atomic_read(&root->snapshot_force_cow))
 		goto out;
 
 	fi = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_file_extent_item);
@@ -1860,7 +1851,6 @@ static int can_nocow_file_extent(struct btrfs_path *path,
 
 	ret = btrfs_cross_ref_exist(inode, key->offset - args->file_extent.offset,
 				    args->file_extent.disk_bytenr, path);
-	WARN_ON_ONCE(ret > 0 && is_freespace_inode);
 	if (ret != 0)
 		goto out;
 
@@ -1895,7 +1885,6 @@ static int can_nocow_file_extent(struct btrfs_path *path,
 	ret = btrfs_lookup_csums_list(csum_root, io_start,
 				      io_start + args->file_extent.num_bytes - 1,
 				      NULL, nowait);
-	WARN_ON_ONCE(ret > 0 && is_freespace_inode);
 	if (ret != 0)
 		goto out;
 
@@ -3221,6 +3210,7 @@ int btrfs_finish_one_ordered(struct btrfs_ordered_extent *ordered_extent)
 	int compress_type = 0;
 	int ret = 0;
 	u64 logical_len = ordered_extent->num_bytes;
+	u64 unwritten_start;
 	bool truncated = false;
 	bool clear_reserved_extent = true;
 	unsigned int clear_bits = 0;
@@ -3382,29 +3372,11 @@ int btrfs_finish_one_ordered(struct btrfs_ordered_extent *ordered_extent)
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

