Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF664BD346
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 16:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791822539; cv=none; b=YEKi+mjs3TG8zK+EY6CKrRMqoxx8AMOCWjUjbJug44XtbcE1CpyyiocVjm7uS7/1WzNuPh8lEysOmWBaAyBOM0pTIjTsNXjfhaoIN1OPON/WbN10gc1DKhDdq+YAVVVvrS1KnQa6TdtibQXCT/qdFDSOTAC8NykWgsB8uTEylGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791822539; c=relaxed/simple;
	bh=kXKeYZDrmhsgH4LcLH9/gztwdEuA6DajPdb06G4aWqQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=l0PfblsD2klhQWE8jLX+ukcH0GUqqdNkI24MvTqjhw6rPlrMdKvPLr8x54DC4FARUVtiypK4of1n5uxrbkeVaQt5QY4Pb9dSnfFR+EZj+Hr4ZzuNxHEPfgCmNhEPQI4I1H5O2Niyyw0e2jClvg4SUaHXfVH7WCAjc6i9kNNhZAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=OGN27vMA; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=0/N3hUHs; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="OGN27vMA";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="0/N3hUHs"
Received: from pps.filterd (m0499198.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69CEgTW81222154
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 12:28:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=v5pW
	OHzzxUE3EYPrxxG/PmOHE1iIgrDGFIKWIMq94Es=; b=OGN27vMAfYzuEgt4ZijG
	oRAKXwpW0DHMlO8Fa8lKD6zUQh2Aj8BAguvWIikxBQGnL1BtCTGFwlziYxHoWl2M
	a8TpGkVCiZq+Y3PhuYamk435AEXQ8nksiUqa31KeV14sD3jD3li36nyyYC+LJDgl
	2ri4/Y9+RwSs0Ntme1NPIuGfBKqFAk3Z5IMx5zELyw96UmEcR23zQOsyvrW/oZiA
	1Q9l1Kf8/ldgg9CDiMpkrTwiYhLcre2Ys93JWHqjmnQsD6Ks2mUnSWr5Wxal2rgg
	U/yVYzklK/HJi1FcXVRANCusYxJEjWir2K8T68NANqjUhrRBOcwyDDJ8sRws+ttI
	Mg==
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com [209.85.219.69])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4h8y4w2svu-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 12:28:55 -0400 (EDT)
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-91b89614300so18752646d6.1
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 09:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1791822534; x=1792427334; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=v5pWOHzzxUE3EYPrxxG/PmOHE1iIgrDGFIKWIMq94Es=;
        b=0/N3hUHsfUN+i5eU4zT3D6nD/UnyVwjIttLnx+51UjUTIZ3ZFWtiuLTqPtSB+1+7gU
         xlfhGnxFUA0VNSmoWBv/L7DI4bQtv/MpSevkb5LeYsrQ5Eyc+5CMs7uV60ASXLC3l5RI
         l1NixIrOV3EBrjDKa8tzsCHG7UO/mYnlP4PDjdY8C1XYNZ30YQXJ4yqj5LTcbNlATTpW
         4Yd4TkPSUsRXPzWnA8VT9SwUQKgfKk30JsiCOT8iYU0MqAKDJiBJZ/VCkANxy/giwUTx
         cRr8eU4Wos3PHkGo7VDsvEscHr+SzFXEPvnnOUa6tlWP/+ryPFUnFFZa6991rnNf9ymo
         QY+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791822534; x=1792427334;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=v5pWOHzzxUE3EYPrxxG/PmOHE1iIgrDGFIKWIMq94Es=;
        b=e2k1M/h6xAM00Jcr/bZTBJLS6FKbVa+n95fFsuc+yGUqRbA3Sd+uSb3KZ9+HYTLDU5
         P3FGwhMFK6YaZpDA2iKbX8Q+lq+Ruzg3okRsHss1XipYMRd9rezrhOFrXt1D+TySrb6O
         EBTfXP8YnbfckZfZ59S8vcgZdy17QkrZmfJHn8WqN5LALPT9cnnF5S7i/HBTvKWsXOP0
         DXd5OlJpL/yKzLKansQja0x/DP4vItsTAXfUOqVYUDAI4S0/yGe1PoU0xKCnjbF/KoIi
         u1wezIVqmfmmlI7VISgT/IsdXZnMm0Smy/Am8q3v+pWVbm5aSzGRvoU/6NevTht61nvY
         x0ug==
X-Gm-Message-State: AFq9FYLx4qJ/Go4L/8VM7vqYflI4uw8YjSacr6mm+WHMPreWLEbTiBgn
	NfxXP/jigRXD7GbwJL7W6OFJYQmgmJBzKBEgancaPWqjXPk5lTCj/MX7xMPg3VnwyqUIWVq6tDG
	WyhygsOG1qHptbFVrcF+6EdheU7EsmRzvXTAkvqjsvtRXiZzn3a7rJq6RCidlhstSfq2X
X-Gm-Gg: AYBFou2H7t4mv0je+2zrudiem/7jd8P/R9k1rC70ZMp4kD+Ag3vZrXg2611fvYLRJHU
	NGzvZaJPfM+o40g2sNceP8HKLyDorYOAJF5ZE6mcVvznbUsF+ss0KLIZnjFuf1JPyoHiHrl+ES7
	9gDAoS1IN5kQigi1MiXFP305XIBWXWJ5fQVfrnMiowa2KW83DxgzMW33ybC/HlFayGdSDus1G+z
	h9gu53DC+PCNRBsru27zQqW08h4XVI04aPrxti1PJ5jPKX9/CVzxRzoPrAGE+HQLGGveaP9d3Z+
	2WEc+AGhUxOA47E+PqFmVcLM+JNM5/nvzeIOdnqCMgHZLfhBlSGZRluM7Lk2hYEqyjTw7i80Vv4
	esJJph2aEMYJa8BjBJX0szAczswXkd3Ca4+oPJRgBEwT7yeA=
X-Received: by 2002:a05:6214:2343:b0:915:eacb:cb90 with SMTP id 6a1803df08f44-91b552f855bmr189443316d6.5.1791822534645;
        Mon, 12 Oct 2026 09:28:54 -0700 (PDT)
X-Received: by 2002:a05:6214:2343:b0:915:eacb:cb90 with SMTP id 6a1803df08f44-91b552f855bmr189443006d6.5.1791822534236;
        Mon, 12 Oct 2026 09:28:54 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-178-231.net.columbia.edu. [128.59.178.231])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b97c27146sm1411796d6.29.2026.10.12.09.28.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 09:28:53 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 12 Oct 2026 12:28:28 -0400
Subject: [PATCH v4 16/18] btrfs: stop special-casing free space inodes in
 the delalloc accounting
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261012-btrfs-remove-v1-space-cache-v4-16-f125bd8c07f9@columbia.edu>
References: <20261012-btrfs-remove-v1-space-cache-v4-0-f125bd8c07f9@columbia.edu>
In-Reply-To: <20261012-btrfs-remove-v1-space-cache-v4-0-f125bd8c07f9@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791822515; l=2876;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=kXKeYZDrmhsgH4LcLH9/gztwdEuA6DajPdb06G4aWqQ=;
 b=TJiFx793FqUHaEgxbyZv57XGH9dDWdAtIfmHJ1ZtuqkU5YJSSL2bWUY40xrQkt3ew1kcTlSn7
 st8GsMuN/VdBAMCVrzkXU6TQsqyl7Hc/GWT6fPUjmdHRzY96/j+AnHq
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEyMDA2NSBTYWx0ZWRfX1nLHlNWRCA7L
 MGEqnRGhl4RFBpfiRQ9ImHlKVxiNolpdnJ/kAdRZmQavecnM1m1CBw7jweJ/NEEY91xJ4e4PNBd
 AiYaQ/BvzoGotYLffudU4lunW8veJr7uEPwnHVs+Of9Va1ARxt9h
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEyMDA2NSBTYWx0ZWRfX+BTAnbd7uc0g
 uvCQ8zjPEovZkfgVdMguWiGGO3NY/r9NfjDtfZOOZ7RX8Qu2olEVuobPg0FOMrKRMzyqUMbuX3T
 zx8Cvj6Ka5SDfmfupDhBpGAF74VXgnOtnuuE20U2870hhw9G49SPX2X0jGhDY90ZOiGqPPC+P3z
 6RitBI5lWJDYN2oCfj8yJJXCtQCWPOJnFXRraqT3+YIFSxS41xkWeCUUaj6nneYG+Om40BobMku
 m5r67SxSnDC4sNy+IYvSQ8VM3nkjrY8hMo3xa7tlBp8Z9RBC1RkVncIsfoqLrjwI5CLYhKzAWhG
 13neo5RSdIRl5znqejysQUjHG7xLOB8f9DIN3Kqbem7Sd78UC4hZqohn4Xc+MQt43jPV3y80sia
 S7a5ImT32uq4kosbQoPKtsCeCDLbEXGatdVaTiaoHwLuw7V9Fs7vLHVwJd78R2bvmYBM7jnl258
 4m9NUvwUMdCnHrT7Mrw==
X-Authority-Analysis: v=2.4 cv=GOydgeNK c=1 sm=1 tr=0 ts=6acd0ac7 cx=c_pps
 a=wEM5vcRIz55oU/E2lInRtA==:117 a=9fnr1hFzp71kSIFw8uYQYA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=BpGzv1V74M3SfeTrGa8v:22
 a=bn-TaVTt-omw3cABb-QA:9 a=QEXdDO2ut3YA:10 a=OIgjcC2v60KrkQgK7BGD:22
X-Proofpoint-ORIG-GUID: 3DBij5Ip23fH7dq4wDdQPimz322ejAre
X-Proofpoint-GUID: 3DBij5Ip23fH7dq4wDdQPimz322ejAre
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11933
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=10 phishscore=0 adultscore=0 impostorscore=10
 malwarescore=0 priorityscore=1501 lowpriorityscore=10 clxscore=1015
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610120065

Free space inodes never have delalloc or outstanding extents any more,
so they don't need to be kept off the root's delalloc inode list, out of
the outstanding extents tracepoint, or exempt from the delalloc metadata
release, which skipped the tree root since free space inodes are its
only inodes with data.

Assisted-by: LLM
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/btrfs/btrfs_inode.h |  2 --
 fs/btrfs/inode.c       | 13 +++----------
 2 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index d1c014da52a3..f7aa0d145185 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -409,8 +409,6 @@ static inline void btrfs_mod_outstanding_extents(struct btrfs_inode *inode,
 {
 	lockdep_assert_held(&inode->lock);
 	inode->outstanding_extents += mod;
-	if (btrfs_is_free_space_inode(inode))
-		return;
 	trace_btrfs_inode_mod_outstanding_extents(inode->root, btrfs_ino(inode),
 						  mod, inode->outstanding_extents);
 }
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5a8f028b2a7d..e715b52fc60d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2632,7 +2632,7 @@ void btrfs_set_delalloc_extent(struct btrfs_inode *inode, struct extent_state *s
 		 * and are therefore protected against concurrent calls of this
 		 * function and btrfs_clear_delalloc_extent().
 		 */
-		if (!btrfs_is_free_space_inode(inode) && prev_delalloc_bytes == 0)
+		if (prev_delalloc_bytes == 0)
 			btrfs_add_delalloc_inode(inode);
 	}
 
@@ -2676,13 +2676,7 @@ void btrfs_clear_delalloc_extent(struct btrfs_inode *inode,
 		btrfs_mod_outstanding_extents(inode, -num_extents);
 		spin_unlock(&inode->lock);
 
-		/*
-		 * We don't reserve metadata space for space cache inodes so we
-		 * don't need to call delalloc_release_metadata if there is an
-		 * error.
-		 */
-		if (bits & EXTENT_CLEAR_META_RESV &&
-		    root != fs_info->tree_root)
+		if (bits & EXTENT_CLEAR_META_RESV)
 			btrfs_delalloc_release_metadata(inode, len, true);
 
 		/* For sanity tests. */
@@ -2690,7 +2684,6 @@ void btrfs_clear_delalloc_extent(struct btrfs_inode *inode,
 			return;
 
 		if (!btrfs_is_data_reloc_root(root) &&
-		    !btrfs_is_free_space_inode(inode) &&
 		    !(state->state & EXTENT_NORESERVE) &&
 		    (bits & EXTENT_CLEAR_DATA_RESV))
 			btrfs_free_reserved_data_space_noquota(inode, len);
@@ -2708,7 +2701,7 @@ void btrfs_clear_delalloc_extent(struct btrfs_inode *inode,
 		 * and are therefore protected against concurrent calls of this
 		 * function and btrfs_set_delalloc_extent().
 		 */
-		if (!btrfs_is_free_space_inode(inode) && new_delalloc_bytes == 0) {
+		if (new_delalloc_bytes == 0) {
 			spin_lock(&root->delalloc_lock);
 			btrfs_del_delalloc_inode(inode);
 			spin_unlock(&root->delalloc_lock);

-- 
2.39.5

