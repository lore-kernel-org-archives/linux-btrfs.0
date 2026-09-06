Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CEB43CB8E5
	for <linux-btrfs@vger.kernel.org>; Sun,  6 Sep 2026 22:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788733816; cv=none; b=Stn6soLLSmIBJasdPInM2auaO/B6k493qpztF1MctK5aJGjj1WP+45imKOoDd7OxusC1dZ928XBLtrexEXmI98W+VrnObtXFx9LaDx2uAR60Q2mAYonXimoN6Dv0nkxZ9dOEblco6DywhKhvCHWP5mKlY9uGYWB6w0qMR4Vi8/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788733816; c=relaxed/simple;
	bh=jovNapv+xLpH/I/e/ElKwI9GEREfMqwAcqQebs6v74U=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=scnk1xy0yyLLr1t8B1yNqqSwHArXgxPRnbRnxTXctwMzE/hCKbmroa9Us/ukhyNcoa+jJjYMdP5NkuYceEhWRUJpMFACqgSLkTQZwlByj2vVzGURyStG3VtZi3Z+Zl5N2/Zb7YYA1ZwNu0/7V32DSCkCNDC74ruk3i91HRq8dc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=r3m0mlWQ; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=2VnXtm9u; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="r3m0mlWQ";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="2VnXtm9u"
Received: from pps.filterd (m0167069.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 686Ibw28279524
	for <linux-btrfs@vger.kernel.org>; Sun, 6 Sep 2026 18:30:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=Be/E
	qUUFz0kczsRXaJG36N49Hpssj0V063Ft3ehqjSs=; b=r3m0mlWQWVS/E0tFV3o2
	eXrSeAam+CwQoL3sBqT7Zm9DuXI9jxUl02EibB8CPWeb7fOaXli97/irR28rZAOT
	DO+jZgqV/LofKr4zSq3GzwmxWaTgrgeoLCxhGGpIz8LQnR4QOGdSNHRRVwtE4ASm
	14XRAL31VMcI0/gl2hiqRaA5FJ32SGTWF1Ljlkd8JwwaXr2J/+vBrUIvFpekbuBE
	VWpRm+YgBzbIebvNTC9wyWcLPc5ZVWUbrMhg3o9jJXtE25Cr+s9gLAzZBFxRFQSf
	FspZLOSdAIiLVaZLthUyShWBPpPvczwKt+U70UM1NOk7chdHFndtLaU71kgvairI
	jw==
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4ghbg39as3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Sun, 06 Sep 2026 18:29:59 -0400 (EDT)
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-9105cf082f7so419626d6.2
        for <linux-btrfs@vger.kernel.org>; Sun, 06 Sep 2026 15:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788733799; x=1789338599; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Be/EqUUFz0kczsRXaJG36N49Hpssj0V063Ft3ehqjSs=;
        b=2VnXtm9un4DGyGR22mEa3M72e/AQTj6wcbvjwj1KPnHA3ywaKfG1/q1FFB3R04bft9
         WcsVaR4OeU6S2qUcdCGmwte/C7iDV6I0YmYhzv8/8w8e3Veijx6+ScJstbSiiHzHQHhG
         8aBVHPFumnGue2ifTEA7zMDflWP2iJATltrnf/2GdV+/IRiMRQpeM7Q2/+faAPHAe1ws
         x4lfELY72P0Bfa8QQcgMgXwA+dM8k0mERu+fa+1vbYmfP0s0kmvq5ZHsDrCJYcSt5VBz
         VoRddj2HTrFwS0kVU1XU287UaLU/45vwOdS0c9AUqnIOBWj0j5Wp5FDBVtNCFvc/81ZY
         d63w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788733799; x=1789338599;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Be/EqUUFz0kczsRXaJG36N49Hpssj0V063Ft3ehqjSs=;
        b=hGjeb8KAzj7HDLsHRCN/0q/30L6aq4GWvEqyNKJGZWOMSOsyqkqLVtEmEaFgleqkj1
         Pz9iJEUSyNOKKkGR1i9wPKuZQuAcyiLtkI+NjmJ8NqLuKLeWN29iDjIm6utV1/Vjta24
         v2PpGHid+g/RGJLtpBg88r/gfZsv93HR/fuiEd1tuKCPduvFGBljhae9UA/RjezgXPYR
         1uGQlf2MftDZj8A3Mys7RboRCSXI8D4pzE5KSebNWqpS45F2SPNsqa5OcAJCg2uGoQOo
         0oB7JaYH4K2iA9mAGak9dlA1TlItE68/WwUIXLfcHGwAzqOYLj69h4MLbXY8zw5kC058
         erHw==
X-Forwarded-Encrypted: i=1; AKwUvBxXQKtlRyTIUAoASwbJ0W3TlaPDGOq9AcF8fivlkk2OgnMEnOpcYgsDJkkOxMCOKUFkvJR2SClisn9koQ==@vger.kernel.org
X-Gm-Message-State: AFuF++lWvThlFoJM816IBpz0xTj5025TxVfqlAjui3z6MvmfeFuhAKj3
	HJ5Kk2ORbeDFVTKOmKV/P3HqHI1y5jKGJJzRW2DDcylxHwbp2rf8Wjmmstr7B58mXahXW8C7LUg
	fTXb9nQ0ZLfguB0WOpQiu5int4AFEafotzs+Valvlg2cG8AphtWTB+1TslkiCLBLA1ug7lk4=
X-Gm-Gg: AYBFou0zkCXdokMcoAUr0yYkyaY/aS+Dlgha8s2Tub/OQh7qHGwhPHy9rw10LzhCawb
	tN7T/MuBuKim/Wk2R5/wAXg0jo/AsE4O1Jv8VkFTt7G4FhIF1NVIyWQQAV6psdVGgN5qNZZfix7
	nvbvWHaxBfreuop8gpe8ZEX5keoZeCIhO0VBJU8PMUP+f9SSiHbq5qNsAIdd5CyfLolmK0PvYI2
	76BQu+3z8CWfnbVzyWnJz4IKPKMl6k36sK61VridPQaq2ZNgYlHDLKaI2obEbckItZ8WhquOI+z
	o/I0uCQGMJtb6RuSPvukVxfVNLVo/l192H92bjgyEACDOU+HEhecdcSF5PO1llYJihpQ+ZbKvt9
	Icx7K74bFn2fgDEYQdubrAWiPs6N4+8aGFsZs9HeCGLRmDxl6
X-Received: by 2002:a05:622a:4c14:b0:530:178a:9dc2 with SMTP id d75a77b69052e-53054849698mr219990861cf.16.1788733798726;
        Sun, 06 Sep 2026 15:29:58 -0700 (PDT)
X-Received: by 2002:a05:622a:4c14:b0:530:178a:9dc2 with SMTP id d75a77b69052e-53054849698mr219990391cf.16.1788733798221;
        Sun, 06 Sep 2026 15:29:58 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-176-104.net.columbia.edu. [128.59.176.104])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5305402a7b7sm73048541cf.3.2026.09.06.15.29.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 15:29:57 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Sun, 06 Sep 2026 18:29:34 -0400
Subject: [PATCH 07/10] btrfs: use folios for reading super blocks from the
 block device
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260906-btrfs-folio-conversions-v1-7-834b9d7b06f5@columbia.edu>
References: <20260906-btrfs-folio-conversions-v1-0-834b9d7b06f5@columbia.edu>
In-Reply-To: <20260906-btrfs-folio-conversions-v1-0-834b9d7b06f5@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788733791; l=3849;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=jovNapv+xLpH/I/e/ElKwI9GEREfMqwAcqQebs6v74U=;
 b=TlxjpbOD8hVpMicJRhhniWV303IHsd1usWSpxmpkraDVVbMQgZenazgdO5TnhegUe94wo98vP
 5FRSFgxDaJ+DYvreByiDxMFLAJCWihNYuoYNOciT/Mpea+HUXGVkt3I
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA2MDI1MiBTYWx0ZWRfXyosh9NV/urhe
 R9XM/K41sTfmVlZawQfFbCg1x0Q3IpVXYi6K6AgQG3PAyVYq2vWufEN6i5eTlYcGXeRkXQIYzjp
 CK/u9g/uB8Nr3hMpm4qBgH4VmYrNB9YyQvO1nSKNBwPPGBI1ogsG
X-Proofpoint-ORIG-GUID: WS7xi-L1gVV0DDS8Sqc0kMGSBCAnBsaU
X-Authority-Analysis: v=2.4 cv=DewnbPtW c=1 sm=1 tr=0 ts=6a9de967 cx=c_pps
 a=oc9J++0uMp73DTRD5QyR2A==:117 a=aNLBvxxoObQFLnBXsbaGlA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=JR4YdQiviy7OQf72WyZ1:22
 a=C-EEzzuqgLcvSd4iXwIA:9 a=QEXdDO2ut3YA:10 a=iYH6xdkBrDN1Jqds4HTS:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA2MDI1MiBTYWx0ZWRfX1xf2nBlnMem/
 byOzMMEkqouN79VsN74Q/oKK5JUR/aXYE5G1GC0loHuMNaS8RphIQ6jb5yHuBMReY3UX2Schiyh
 2OTBk5oQEvlehp7MroI+2BbsZWMgCoCMNX0KtYJtQhX/EI7GTy6YjUYp3wiOFXs4Kqfkb34yoOP
 u8tU+pl/1t9nK1A178zI4uNyzQdDi3F3J7jK+yRFagsrUR2hhI79mBsXEWYPK2uGtSipRWZHgm7
 Ujy9jBPwwuiooG5JlcvDGz34pS/IR2rH2mPNvjnE6TV2Hxu3mIsbcObv3zDamPWMoT1NWEvHvQl
 JfHLcIXCUzhitC/r1Kpmw7HIWOs6aQF0wj+KjbWnEY4CDkAfwzVBXv18q2p+FOkp/8lbSURCCjK
 WUVmQlrqe0uml3qQCC9xao56MRJxhFWiF89ZVdTt2IKmfjvCDtka6fzRw2XGziRuc7O+YBVEgZz
 ZpQCdi3E6akLY2Uufmg==
X-Proofpoint-GUID: WS7xi-L1gVV0DDS8Sqc0kMGSBCAnBsaU
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11898
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 bulkscore=10 malwarescore=0 lowpriorityscore=10
 suspectscore=0 clxscore=1015 impostorscore=10 adultscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609060252

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

