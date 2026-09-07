Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72603403E87
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Sep 2026 20:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788812436; cv=none; b=YswzhcAjGGEf8YPqXEmj5toNtAj91D14TET+JakxdlS+U3K48hnQd6VY6GjT9YuKWPmWPS7EiPCMp8CJfBuhEa/Y7D4rtg/rutQQxq6/umOudF7/0MdDwTsPuiC1d2QNFJITzG4qhyONo8HBpKsf+xCLQYwxhYFrd6sSCXNujqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788812436; c=relaxed/simple;
	bh=RYBxJl93h958FQK8RkWgp+MkOua/aYnCMeTqxN34xTw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=tiUK+kdawTveYnqYUU4QXL5jCeIZkEmw3VrWoZg2r5xExGbSWFZqYaLzhZwfj4MqdHA7pO3gaAU44CWXlHS9JkYMHA/r80EHKnK/QCVjh+WRdxTTl0hVrCGX37QO3LN2uAq2RiVghFBfC2mSMM0ng7a5xwqZ1+Q8tkh3gAurkjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=F4RN1cb8; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=W8zfx/Tw; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="F4RN1cb8";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="W8zfx/Tw"
Received: from pps.filterd (m0167073.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 687IXvQE3072850
	for <linux-btrfs@vger.kernel.org>; Mon, 7 Sep 2026 16:20:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=w3o/
	sHf38x/eQVx++9WePfix9UGFsLhy3c0Xy3Gsc0g=; b=F4RN1cb8mQLXP7aUaDV7
	yFGepUAn85Mn6TThwnkMl8J7V69TIKaHmqbzI9kxrDSiDhrSD7OLmUEIeWOtH/dF
	AHCYERrCv/9dx2dQLbamSmrq7Iw3ow4cufGWUYewkys3S7Bil0F+L9M+MP6WOutN
	YeLeVjkhmcRo9AA4os4ImoaYgRbWT4cDlefs+PMr6TjUvSRLb+1k34KMU0ePq8rL
	JCmHVn67BoppIJOc8a2O38ogh2Tmf14vN6bC9zbQdut2FDKlR20AgKbR2ihQRxGv
	h7Ni2qXdvACOK4qyzcvS60S9q9MbHXzOaN8dsPmGd6JbjH+2clqD2ooUumH4oGqH
	Zw==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4ghfawwcrq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 07 Sep 2026 16:20:29 -0400 (EDT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-51c1d30035dso47581861cf.2
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Sep 2026 13:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788812429; x=1789417229; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=w3o/sHf38x/eQVx++9WePfix9UGFsLhy3c0Xy3Gsc0g=;
        b=W8zfx/Twx0H7+yLTcHQF5WBQR4FgpkjB2Wy6j6qQZXtbXQCPUenGN3Qu+BLg+iaD61
         w8GM29v/Gzg9iNVC0VP6zPa8nK0LiDI6sxczj5zjRS5M3T96/bTMcT9at9qxKwcBSguW
         ObFcJMcPel3yoasjjOrT+NVwjNnPX4l110qXW85G5DXqhJ78RAeRrFaEALpr/3D6S8XB
         biXTBdZC/umDTqtSuaXVCes3xCuC1HAxSL/nNa/qg+yg2b5ppYLA3Vlo8YU3AWIHy0x/
         GMMwtKEYBBebWb1dOGQxyjzOr6RSItjWo6JYNQX+XNRkozgZEm89k3qWp9G6NUxaMV/g
         Hpzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788812429; x=1789417229;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=w3o/sHf38x/eQVx++9WePfix9UGFsLhy3c0Xy3Gsc0g=;
        b=NbLRwLW731VM0GkSn5+euCUGK1tJbqCX2099JDFNNM4TVuIO/iOj1skSdmJUow29C3
         UfwJEWsa29BX+Igpd82shz77tgu/quQSfwwC6L77027xCTxhDquxcVWQy4yxMh2p9qKa
         pyA/IIROO3XKcEGdj3Hqz9WtZN23ijP3EIwPz2Gzt9qCBPgcdTIvmjl7FTraXrbq78m/
         s/G81ios2uOq/PWaJpnzKj+zXXTgxng8U2kG48AxMkODS1sccIjAsmw+RA+r7u0TScS3
         6Vqdpk9f7a4Ab6eMj1gtNtA5SFn9l8H33zclpw8rBwFqrXa+JgKsRXdju+PciFLN5ESm
         qVJQ==
X-Forwarded-Encrypted: i=1; AKwUvBzhqtzWQRYGhZtckAbwAC144G0V5CNVkxgsBRE7n5Eoq+c/r+ogdHLOfULbtmbSHN6EDD06PtNssh6gEg==@vger.kernel.org
X-Gm-Message-State: AFuF++mEG17cVsEASDbV1ptkgRCIOdSaY0RdGoQvqEF3FYtoJfNVcso0
	Ca9GUtBj9SMZVN5w+Ww2kLF6Vsz4+OpPaMuU7LK2IMc5iwXdmgO7orAAP+JcHewjijHlD99WYEM
	PVeGBPQ/Gjmjl+DhYTleeiWMWpws/ejBpfdhtbseOQYJb/uqD3+0WtmP/yOxo
X-Gm-Gg: AYBFou2Z/G7S6+PgE8euaZhze1RSPkIh++aD+MhCW/HiYvAmjrRsDvj4Awf6xkEtWUu
	IwicAWOQLt+VgdspqMkw9ARA4SNmNBeDrlUKl+L7MlEMcPNl0ITlCOlJx33bjUR0FwMD1pp24c2
	Eac5GQ3gsot1twqlMNm6R3zpJASuSfxTfctGlN1t+LMbdPEitdOBb3/lJlBmyWv6yG8hKBMnQru
	VnWergmCL0165NOZS9+FvTNib4bKp5MwZtSCirCmHAcf7fobuA9EtAHbRGTCXGnLoo/rkX7vP2m
	RANWOEM2P5gVx9CqjRSIBEKL3Ut64XQxtl2YkgXHebi1jx8E0ihEFZi0BhbX7iYbM6BUlSy3X1M
	Xz9izLYPEEhRmqE+e+rLqJmnRGYVXDTzZ+M1NRWgaF9k=
X-Received: by 2002:a05:622a:c84:b0:51b:f40b:2fb5 with SMTP id d75a77b69052e-5305482a9fcmr267886201cf.17.1788812429132;
        Mon, 07 Sep 2026 13:20:29 -0700 (PDT)
X-Received: by 2002:a05:622a:c84:b0:51b:f40b:2fb5 with SMTP id d75a77b69052e-5305482a9fcmr267885621cf.17.1788812428647;
        Mon, 07 Sep 2026 13:20:28 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-176-3.net.columbia.edu. [128.59.176.3])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5305413ce9dsm95062351cf.11.2026.09.07.13.20.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 13:20:28 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 07 Sep 2026 16:20:01 -0400
Subject: [PATCH v2 7/7] btrfs: use folios for reading super blocks from the
 block device
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260907-btrfs-folio-conversions-v2-7-b5fe79f7607b@columbia.edu>
References: <20260907-btrfs-folio-conversions-v2-0-b5fe79f7607b@columbia.edu>
In-Reply-To: <20260907-btrfs-folio-conversions-v2-0-b5fe79f7607b@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788812420; l=3888;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=RYBxJl93h958FQK8RkWgp+MkOua/aYnCMeTqxN34xTw=;
 b=hz3WxTt80OAC0IjpP7autduLptHKjPXS6RtlplpD91GKIqF8ntxt0EezJrokIwP4pHx+TjdKF
 vcNcXO8TVCGCMVQmGB5C6brWo9z13UFaVIMOM92ZfrvsDK6DaaYlwF0
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: lD5mM7Cgssfsya7cqbs2Q2ihyqnhsw2f
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDIyNCBTYWx0ZWRfX+aI0R8SOZ+HI
 VcXQtJa/PkwsJG+Z/f7ry5C30NsCAtrzBZqZa5KnjeIe49OHi1Gjvo0lnj73paez6zouMm7rrK/
 AF+uZksWkJzHhrmMUIZ6uEqIZZLzzJ0t2VcHkiH1EeQzodhQBXYy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDIyNCBTYWx0ZWRfX1co8GWrf8nN5
 2dl0b0vjNFOeZiXDHtICRaJqKVgJEVwQvkEGuqjRHMf1AMRGG1ix5vOyjXjpBNPuCm7W8VJSOA2
 GGJta/A5uNCrcp+THEpFnwMyF66/Tgq/p7EsftvBNZ5jWWc11DGJKoplDQVwiHlgiHyMYNFu3g+
 qLqwqECv1Ao6zuvWiei7i5QHlOY8ExnFzN02M3cCi1Bxj4tPaQka3CSDL+csiRZ2gT7Km5vFWfD
 qCTijWgYUb89oHeMOLY+e1B12v78lpb4iFccIRmIAzVtop0rSdMRt9YrE7dl6U36rN7pJm6q1sN
 OH0x4RcLGgfejbS7vJGGDfwCHdjqfB8jPPAYO9sKBKdBNpxM0ZJ7Q2HFeCQLOxMtRRaeDr/drux
 Q2AB79G5M1m7RU07OChUqQunS28AfTIZNuBLFzVzj46+/g5QiiQq4W6gsk3LIBIlVZ8aKkMHQBX
 pHpQaHHamOw3bfCkgLg==
X-Proofpoint-ORIG-GUID: lD5mM7Cgssfsya7cqbs2Q2ihyqnhsw2f
X-Authority-Analysis: v=2.4 cv=bvd8wkai c=1 sm=1 tr=0 ts=6a9f1c8d cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=92j1mJcILCjWExuphHMrQw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=jHxIr1HyPKZ_Q5_91PL3:22
 a=iox4zFpeAAAA:8 a=C-EEzzuqgLcvSd4iXwIA:9 a=QEXdDO2ut3YA:10
 a=uxP6HrT_eTzRwkO_Te1X:22 a=WzC6qhA0u3u7Ye7llzcV:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11899
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=10 malwarescore=0 clxscore=1015 priorityscore=1501
 suspectscore=0 impostorscore=10 phishscore=0 spamscore=0 adultscore=0
 bulkscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609070224

btrfs_read_disk_super() and the zoned super block log comparison go
through read_cache_page_gfp() and page_address(), and
btrfs_release_disk_super() recovers the page with virt_to_page(). Use
mapping_read_folio_gfp(), folio_address(), and virt_to_folio() instead.
This removes the last callers of read_cache_page_gfp() and put_page()
in btrfs.

Compute the super block address with offset_in_folio() as
write_dev_supers() does, rather than assuming it is at the start of
the page.

Assisted-by: Claude:claude-fable-5-1
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/btrfs/volumes.c | 16 +++++++---------
 fs/btrfs/zoned.c   | 12 ++++++------
 2 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 949e40baff33..4ddabadc9188 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1327,16 +1327,14 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 
 void btrfs_release_disk_super(struct btrfs_super_block *super)
 {
-	struct page *page = virt_to_page(super);
-
-	put_page(page);
+	folio_put(virt_to_folio(super));
 }
 
 struct btrfs_super_block *btrfs_read_disk_super(struct block_device *bdev,
 						int copy_num, bool drop_cache)
 {
 	struct btrfs_super_block *super;
-	struct page *page;
+	struct folio *folio;
 	u64 bytenr, bytenr_orig;
 	struct address_space *mapping = bdev->bd_mapping;
 	int ret;
@@ -1357,7 +1355,7 @@ struct btrfs_super_block *btrfs_read_disk_super(struct block_device *bdev,
 		ASSERT(copy_num == 0);
 
 		/*
-		 * Drop the page of the primary superblock, so later read will
+		 * Drop the folio of the primary superblock, so later read will
 		 * always read from the device.
 		 */
 		invalidate_inode_pages2_range(mapping, bytenr >> PAGE_SHIFT,
@@ -1365,12 +1363,12 @@ struct btrfs_super_block *btrfs_read_disk_super(struct block_device *bdev,
 	}
 
 	filemap_invalidate_lock_shared(mapping);
-	page = read_cache_page_gfp(mapping, bytenr >> PAGE_SHIFT, GFP_NOFS);
+	folio = mapping_read_folio_gfp(mapping, bytenr >> PAGE_SHIFT, GFP_NOFS);
 	filemap_invalidate_unlock_shared(mapping);
-	if (IS_ERR(page))
-		return ERR_CAST(page);
+	if (IS_ERR(folio))
+		return ERR_CAST(folio);
 
-	super = page_address(page);
+	super = folio_address(folio) + offset_in_folio(folio, bytenr);
 	if (btrfs_super_magic(super) != BTRFS_MAGIC ||
 	    btrfs_super_bytenr(super) != bytenr_orig) {
 		btrfs_release_disk_super(super);
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 08a15465a087..a1ef8caaacda 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -123,24 +123,24 @@ static int sb_write_pointer(struct block_device *bdev, struct blk_zone *zones,
 	} else if (full[0] && full[1]) {
 		/* Compare two super blocks */
 		struct address_space *mapping = bdev->bd_mapping;
-		struct page *page[BTRFS_NR_SB_LOG_ZONES];
 		struct btrfs_super_block *super[BTRFS_NR_SB_LOG_ZONES];
 
 		for (int i = 0; i < BTRFS_NR_SB_LOG_ZONES; i++) {
 			u64 zone_end = (zones[i].start + zones[i].capacity) << SECTOR_SHIFT;
 			u64 bytenr = ALIGN_DOWN(zone_end, BTRFS_SUPER_INFO_SIZE) -
 						BTRFS_SUPER_INFO_SIZE;
+			struct folio *folio;
 
 			filemap_invalidate_lock_shared(mapping);
-			page[i] = read_cache_page_gfp(mapping,
-					bytenr >> PAGE_SHIFT, GFP_NOFS);
+			folio = mapping_read_folio_gfp(mapping, bytenr >> PAGE_SHIFT,
+						       GFP_NOFS);
 			filemap_invalidate_unlock_shared(mapping);
-			if (IS_ERR(page[i])) {
+			if (IS_ERR(folio)) {
 				if (i == 1)
 					btrfs_release_disk_super(super[0]);
-				return PTR_ERR(page[i]);
+				return PTR_ERR(folio);
 			}
-			super[i] = page_address(page[i]);
+			super[i] = folio_address(folio) + offset_in_folio(folio, bytenr);
 		}
 
 		if (btrfs_super_generation(super[0]) >

-- 
2.39.5

