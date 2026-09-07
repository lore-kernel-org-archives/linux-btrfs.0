Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE3C041F5F5
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Sep 2026 20:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788812436; cv=none; b=KEq5OP0o63LjgUSjVE645lJnz7J/Usa/1X/LTHXykwV+AD7ucC+CbBPKyufQ6m4WNgnSu6Umq4+oySXGPKeSFliDpprwe+CiADsjmQUzzzADjbWp6eGKvIhFzrP3++RuF/sJXnqvV5hlX52zdSeFPms7gdceyEvc0RsgroVACiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788812436; c=relaxed/simple;
	bh=g2CDSqBl/ImGg6f7xVyfdVp8st71N8auj/JHJ7GqwFk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=chxnbURpYHnikVp/13Smfi722j/iQcaaNcn3CjtxfMGrC4QzrV0vwgUfntF07ANluOas+pxMnwHKiT+0LxdK6Od3cFgnCWTinSX5B84yzjcNmPpd6fCUf6RnVMIhSw9SKzFC+IfeKWlmbOmEWpadEHLS+XGsB9SzhK15oJgGkY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=fA+em0+b; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=4xob2Tu5; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="fA+em0+b";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="4xob2Tu5"
Received: from pps.filterd (m0167070.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 687IZB8C2619583
	for <linux-btrfs@vger.kernel.org>; Mon, 7 Sep 2026 16:20:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=3Q0g
	Ra7dtg3Hs8zCimh8kJ/W2lm6+Rg5TzjBLCjf9Us=; b=fA+em0+bkZObRq19/DRE
	UN4XZKGLjycrxEGxHLn4EwjYYncZyRi8Tm5fHbAeia5ZwhfeUvL4shN9NRWUnXZA
	f/Vkfsezl2P7MZAVDJt+nt7aVkvt3mROWfdT6l87BsmrCjCC9+ZdnT8hhFPQMwVg
	NECJ2jEjLq5+TYUl9X9GaarYEhLoHnY73emx2GOdKQs54Yi1NzmPXV4jqJTRAV7w
	ByZdW/HdJTPb+eTA/SMMvCJ/CSlaoAhoakAlprB1G++WDCPIOg/vHj4Yl4aHF3CH
	CxK2z4ciUI1WPqE/rx/v+ywqyadICx+5J9ph/hdbLHWBfS4VW8LTBQosuvraCd3R
	XA==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4ghdvq5txb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 07 Sep 2026 16:20:29 -0400 (EDT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-52fc16ac179so71009641cf.0
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Sep 2026 13:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788812428; x=1789417228; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3Q0gRa7dtg3Hs8zCimh8kJ/W2lm6+Rg5TzjBLCjf9Us=;
        b=4xob2Tu5qB7+NX1WS9pPhq5/O8IPps1rU8a0eMjWF0qlIYsuvIfqPmNcjDTuoiA3ZE
         ucZMuDm51IxN5MYBf99CboCxS4qMsUJbWqnRnE6raKd2Di6Nvk1+qpku+2RYmMafRIdn
         M9yhbWPisxNOAhJKE9o/y+yGxfraMAo7NDfDTug+Mgge0HjgHzJAJ+x4AZ8P3AyZsPbd
         ZH1WLWJ/rqJX+TrzNQ+d4qex1FS3bXP8tqr+AnNsB/B5M2Lk38w2DsHuw19XrRlaH0uy
         mMt259tGtAhqgmEwPwEocsgmQ0RZ4s/AzzPdu4MSXj0//XfHjZXDXOzo+dn9OcmpolmN
         HnDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788812428; x=1789417228;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3Q0gRa7dtg3Hs8zCimh8kJ/W2lm6+Rg5TzjBLCjf9Us=;
        b=kOBPzy7IWtozs6eIObn8fRorOnsfAv9m6SNjFpAGiNcLFYOCcv5tHURjSkReXzvQbH
         CSnEjXDvrr4FBRPDm2DkPx1Q5MR0jKLTVxiffQ8Xggvw1tA5XcmyvShgH7PYFDLMwTiv
         Rz2XYuiZIXLZRKAbzmvjOIwWQpZONTOFOpdB/0shIFMyKrTUvUviVWgJbTSj4rlLB0sP
         9hdihTEAif33Nyuu6dKF5xgh3SRDR/SfU3lhnDfuX80/P5xyr32D1iWWwvUAFOp7Jxzx
         AAuWyjzFdJky5q/776uZ49FmL9in33useFax6MHdJeT/rVXYW0cUrvp2JRrAFRcKHJoM
         ywqg==
X-Forwarded-Encrypted: i=1; AKwUvBx2aQ5k8xtyflj2f3XSXzZHEaQz6mVqHhxSMRUHF3+Z5MzVu0/4aaumOloiiDbNQvp0DS9YYWnux1jV0A==@vger.kernel.org
X-Gm-Message-State: AFuF++k2Sb4frUa8p7iPPdkaHt95SCz+jqdQtcqjMO9d6L2+IqeDEvUC
	ouqtlc4KFaNNjBh6VAiIdl0R/l+Bv0cEafV4LuOA2SfybEEDl5YsNLuCvFMC1WoA4XEEGADurAZ
	U7s7e4wM/0NgDTi9Q0DWEbzwyuCx/AAeB+AQLRZGG8j3doiK/hSJzryroKavp
X-Gm-Gg: AYBFou1AFNpvHJ/tQE8WX5sfbRbdapWEiZjecwZEbB3r3M3zRq/vxm3ztu2VUzGrRB/
	l2l+CdQ3SrxZJNW6L3rlHU67pmCNr9Hkf1TDQBDkBIH4ych6R+y9h3fNnZKY3uR+/UXaI4TylWn
	/NvLFDKmEG/HSUjx1g/g1tCKeDS2yUnBR2AwurtWRSc00qp/2tyi6Ayu3ZmL0SR04jSXopUgYht
	xNCo9kjsBcyj5+/BE2zAMF5fdLsqHhZCuzztrM6RF1giRJXs7xrNw2jPriuDfUeCKsUIxnhJfYB
	mQayi64dRxQ6RsisAf4svps1sJuysqXnpq7vrBVKt8LMWYRx0vMCJzcN9wiRtaNZedlWm2cOmh/
	vDmYCEezBQDvVM/7j4AIWUV64bVpklJT2zrmGx4ZgTxA=
X-Received: by 2002:a05:622a:1f98:b0:530:42e5:f39b with SMTP id d75a77b69052e-53091348827mr40841411cf.23.1788812428386;
        Mon, 07 Sep 2026 13:20:28 -0700 (PDT)
X-Received: by 2002:a05:622a:1f98:b0:530:42e5:f39b with SMTP id d75a77b69052e-53091348827mr40840811cf.23.1788812427764;
        Mon, 07 Sep 2026 13:20:27 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-176-3.net.columbia.edu. [128.59.176.3])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5305413ce9dsm95062351cf.11.2026.09.07.13.20.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 13:20:27 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 07 Sep 2026 16:20:00 -0400
Subject: [PATCH v2 6/7] btrfs: fix stale function references in compression
 comments
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260907-btrfs-folio-conversions-v2-6-b5fe79f7607b@columbia.edu>
References: <20260907-btrfs-folio-conversions-v2-0-b5fe79f7607b@columbia.edu>
In-Reply-To: <20260907-btrfs-folio-conversions-v2-0-b5fe79f7607b@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788812420; l=1315;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=g2CDSqBl/ImGg6f7xVyfdVp8st71N8auj/JHJ7GqwFk=;
 b=QGa2pMLlpq+DSLcMk7QnBSVbClmGfxhOaq3KwEPUvhHGJBO8hnwiP7nn1EEEYTU0zV66FhgYy
 NJYxeH3zc+/A0xk5FJjHdOAyFQ7lGYHoBhiRuGPHND5nM9WpoQWNjlV
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDIyNCBTYWx0ZWRfX5AWDVDbNijsO
 /EzET4vv+d7xd5aYoYakq/PNHw6FWISBU+sMAFurIWgHmjVgU+srjyzBnNosvXNhpoPNeegKMpA
 CJSClSahAB1zXpAbsmEbfBqOqhd7mnyvJeCt0j1QyAzN19kvpqWk
X-Proofpoint-GUID: xM6ZN3iMkggwlRz864GBEL9uCjOO7S8M
X-Authority-Analysis: v=2.4 cv=f+14wuyM c=1 sm=1 tr=0 ts=6a9f1c8d cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=92j1mJcILCjWExuphHMrQw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=svvvyxlR1OQQkelhaPoB:22
 a=iox4zFpeAAAA:8 a=wS94dJsgKqXJMQyBkfsA:9 a=QEXdDO2ut3YA:10
 a=kacYvNCVWA4VmyqE58fU:22 a=WzC6qhA0u3u7Ye7llzcV:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDIyNCBTYWx0ZWRfX3k2RWmabxALh
 Hec+75zs27isMNOECK4KE5BoTZ7i7HN1ObCpVDFR/7SJQFla+2VPKR9y2FSt457EskvYoyotXKV
 x2QiK8iUQu2fB2VarYfqOaHKCjD8goUowyiWj413ifir8FIZfQxuuJw5xnkNScCIEasdz/X3h/h
 VeHz48DJBi7j3Sd8QVMFEaCEjlqjgjaljeeb6GENcNvtkYNwGHnC4a+B6lpLRoKqVib1ncoDpzR
 f+ItxAB3x7VtHpu6BBnKxWEEukgi+RyBQDL3rRn/xT0dQKg3J3oaEjeosufpo/ML8+1ZhdNldbT
 r5AH9NnTMycyHTVcyxT2ylUSB++RHhhzx/aWXykydn8T8dmLJY7mOy6UiKznbuVrwNGsIdDCIOc
 zkw6xaFRhpwqJlDjLdzVt8QKm6lLAU59mZaArPPDoHp3fWBqkwtoPO/i3Gy4G7w5qp6t9LoxIja
 RLl+npm23yS7hKvsoFA==
X-Proofpoint-ORIG-GUID: xM6ZN3iMkggwlRz864GBEL9uCjOO7S8M
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11899
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 clxscore=1015 malwarescore=0 phishscore=0
 spamscore=0 lowpriorityscore=10 priorityscore=1501 impostorscore=10
 bulkscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609070224

add_ra_bio_pages() was renamed to add_ra_bio_folios(), and
btrfs_compress_filemap_get_folio() wraps filemap_get_folio(), not
find_get_page(). Update the comments accordingly.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/btrfs/compression.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index fa8b92592321..20169d028961 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -431,7 +431,7 @@ static noinline int add_ra_bio_folios(struct inode *inode, u64 compressed_end,
 		}
 
 		/*
-		 * Since add_ra_bio_pages() is always speculative, suppress
+		 * Since add_ra_bio_folios() is always speculative, suppress
 		 * allocation warnings.
 		 */
 		masked_constraint_gfp = mapping_gfp_constraint(mapping, constraint_gfp);
@@ -960,7 +960,7 @@ bool btrfs_compress_level_valid(unsigned int type, int level)
 	return levels->min_level <= level && level <= levels->max_level;
 }
 
-/* Wrapper around find_get_page(), with extra error message. */
+/* Wrapper around filemap_get_folio(), with extra error message. */
 int btrfs_compress_filemap_get_folio(struct address_space *mapping, u64 start,
 				     struct folio **in_folio_ret)
 {

-- 
2.39.5

