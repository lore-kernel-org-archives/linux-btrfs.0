Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3293C0635
	for <linux-btrfs@vger.kernel.org>; Sun,  6 Sep 2026 22:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788733798; cv=none; b=tt+Lf/cAGIaYO57XuTUzXWgHHa2PiDP6jEKf0SuehmlADs4AuIafSPkwDDW/AKdWpKCHAFQxOR0Ov0cOJtw6QPPeFYLl4SYTnDBZktCz5U82ZqkuZJ0yph556MlUv+IITc+XfcteAiWgur9ljxfcTmy/nI5gWjZx2cWdWBEvlbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788733798; c=relaxed/simple;
	bh=VQrVn8A0HLSM3sgWrEf2RTYhGAJ0C9CH2J0N54TnyYE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=J/MMM6sSzgmFF6JjdJ14SJqA6nhAYN9jG4Y0PaMymbIQBzRv06FroAjExB99bw6qom4GpUjIM1kLg+qvYGCl5fdmjJBb8M2Vl0/HxQ1q717ec0YSzhuSGD3WUDws//sVV0KXlxqMjBzZDhpsPknGZSnUUYKCjOFclOAQaN2LSTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=r3X7erUK; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=1usJAWnc; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="r3X7erUK";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="1usJAWnc"
Received: from pps.filterd (m0167077.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 686LtC2q472440
	for <linux-btrfs@vger.kernel.org>; Sun, 6 Sep 2026 18:29:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=4fn5
	jWYflJxjCAZuByVB9tQPGJxiwJekj9vVjZtfQ4s=; b=r3X7erUKpzQl1DLAfLHX
	8Krizb3VKv4gi851rovOPiLXvVxq/fXfa/tlNI/9OG053jKBJSoaDCVF9sXktSAo
	P0RK+wziOErCsiQ37Kxy1Tik4Lwb3zREocOb4gy3rT6f4WsZPRiepNHENGEe5zxH
	Vdd8UAxMvvLbVVW+rhaPrSHTD1XixP4JM3vbkH+UaQl7agpHIsXmwiSUqJPscp5l
	9uA4jeQ5fqurPMg2wWb//Ylu3uEuc3ChVy9qE8ZtyuBjd4cPdZDRCMe+2cWsFFmY
	PKlMSKNR1r8WEDM/pTTf5Rr9pYpHjx3siMU34ITWgIqiUBeM+Oon5J4r/s5jWSat
	Zw==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4ghepk0gf7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Sun, 06 Sep 2026 18:29:55 -0400 (EDT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-52ff59f2c47so70224401cf.1
        for <linux-btrfs@vger.kernel.org>; Sun, 06 Sep 2026 15:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788733795; x=1789338595; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4fn5jWYflJxjCAZuByVB9tQPGJxiwJekj9vVjZtfQ4s=;
        b=1usJAWnc7E7Wlo8vim/3m7D27JCdA8zsEoYOMSy4JVqcFa74TyzR1v+FlxP6Bbik9B
         zfBXQq8kW/yg/miRXeOahiuMUYeOzohRM2qpdmqisdOBI5MDoico0eT9x0jp4KGA/K0z
         7Bja/RCgA/qJFYuZ3oN1lYVxVtbHnia+5Z0MkoIogvTOWJ3Z07xLm6QDRA9zx32PqEcE
         tThijFO6RTZlZYmQsD5URiEvjrQRm4mvF6x1uWlJllnrnNyFmE0RYdqFvRAuGrCgzoJy
         K9ahUj0zRsKdjlBEnzjNR3x6TVhDpNgid4bL/Duh6pyKbR6Ye3s/PeRmaRfjmc3NULn+
         seQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788733795; x=1789338595;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4fn5jWYflJxjCAZuByVB9tQPGJxiwJekj9vVjZtfQ4s=;
        b=Vp60BK1Bs5DK0u80mxUNau0bdpPH6p3UXs5KikEowCCVKiFP+bo9JxdoBMQ5XNAzuk
         d5PSThlQiCAXDdusRVjVZY3QHErmM/8BPYoXIOXtNbDLdzJMHQNyIKgcCextGqDsMb4t
         njtnokZDeEJJxFl72fG3PiMuFXGxNbGvz0q3J4ejyiynMAQQAlyzT6D+Nf3kShiBcLgF
         6+zkJOBKOfvuKPRsm2QRLpxp9H7R8sV0BQbV1MwdGjRtjSwdzunM1UnMsrPRtZYD7DaC
         n0xwJDp+dMlqEnqjgXfOC59ycTjrf4AjBEyoM6QlZ5W1hFeZD24tmfyfvrMAolyV9wUg
         3wfw==
X-Forwarded-Encrypted: i=1; AKwUvBxhOpvgDM5Ns1Q3lPfKnSoUcZr/Osfqal9Rm/4+CoDzl0dG983GgeMtOomNWyQGvKcBJTpulHU9eU87nA==@vger.kernel.org
X-Gm-Message-State: AFuF++mo2VCIxVcU0Ze3lPgQn6j2DOFrM26HauLp+eYqgO8AKMJynUj5
	8vOo+hU5ZOt6lxu9hZfeFqZTyirLwz/YKaCYr8yL2OUlyj/giJRLnUSiM3XsxpnI8xvO4ToxC04
	rcBKmX90aMbwH6iidjeyohnaV2UpO97RmLkcrbWVE6g4lFMB2lYKZAbmMWplO
X-Gm-Gg: AYBFou2zp/VbX6sSttyajwQgfW1486Qr4Win3KcdkUr/SsnvoOV7jWmFNiuG2WAbPdM
	2t67Rc31Ulj/sv1VP+Na9ofhx1siG7iZuogD8SuakdbNTA5cpHygDvmg7GOxZg2ZeYpDTy7sk+t
	380eAg4rUMwyLP2WRqfPnNq6kIAS6TmoWH0w66mmwQk3wZRTZQm7w5gdz6RMYsj9Be6QfHo8IxP
	hxnwWGTnijfPbXmYFlylyYB50RmcbzlcuuUsDZWsJ0YGLGXVSBE1bHLsQyYRwn48iGFuQ9NSK+5
	xVlqbIyIIkd8qb5p5M0KY15pEntu0bcb0yTq5VPGFnon91qtnNhhADFT4je5CQjGpNj8XX0E5VJ
	IdOoZ9gHFxLIAY4eXjdz4ONnB8bhyw+KJ3LcRIdzNUQikwJPI
X-Received: by 2002:a05:622a:1183:b0:52f:b372:2ef9 with SMTP id d75a77b69052e-53056214cd5mr137334001cf.20.1788733794510;
        Sun, 06 Sep 2026 15:29:54 -0700 (PDT)
X-Received: by 2002:a05:622a:1183:b0:52f:b372:2ef9 with SMTP id d75a77b69052e-53056214cd5mr137333731cf.20.1788733794047;
        Sun, 06 Sep 2026 15:29:54 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-176-104.net.columbia.edu. [128.59.176.104])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5305402a7b7sm73048541cf.3.2026.09.06.15.29.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 15:29:53 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Sun, 06 Sep 2026 18:29:29 -0400
Subject: [PATCH 02/10] btrfs: tests: convert test_find_delalloc() to use
 folios
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260906-btrfs-folio-conversions-v1-2-834b9d7b06f5@columbia.edu>
References: <20260906-btrfs-folio-conversions-v1-0-834b9d7b06f5@columbia.edu>
In-Reply-To: <20260906-btrfs-folio-conversions-v1-0-834b9d7b06f5@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788733791; l=8260;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=VQrVn8A0HLSM3sgWrEf2RTYhGAJ0C9CH2J0N54TnyYE=;
 b=uZfatUhPgayb3I/w342KTZATxSJcDNIgJLpkescgYGiYBaqgRgOcFrOdnsubisdYVUlZVqfXW
 fSPA83o7InGCqNCveEP9MFkqTr/h4TxeVic/DT/caNnhEwZbhrXNnlU
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=Wc48rUhX c=1 sm=1 tr=0 ts=6a9de963 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=aNLBvxxoObQFLnBXsbaGlA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=QOCMdifcju39GKoXhKua:22
 a=GGKBf0zGomX5QsxccnIA:9 a=QEXdDO2ut3YA:10 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-ORIG-GUID: 9-uMchFyun9HaLjPONtkathvRlmEcAPi
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA2MDI1MiBTYWx0ZWRfX5WVD0nS5n+ZC
 OwJTrqRS4HomK3qS/pIuYqd2F6+Bsq/uizsdx6FOdUXfI7ZUtu6Xo2x1iO3PnCFuukbPYy5HM/8
 DIP72TMcHRHLibYmxUbBOHjFwzrimIe+qkg0YS11A+VujZD4UwCz
X-Proofpoint-GUID: 9-uMchFyun9HaLjPONtkathvRlmEcAPi
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA2MDI1MiBTYWx0ZWRfX0momF6g8pu95
 JB1UamST+1VNE+t2IziZF+wmLPb4HOB1A/DHzPF0/gZPkvwonSK3LstjCJrU9ZKNdxPe7x37hpE
 MVxOMMkvkqQVraKn0mdwglTWGS6OIDPWgNWrlsgfhZ+eU4T4k9SsO4sBRmBoKGlOVL1HicV1pKk
 zZHWiFbs/0Qu3D1MIrtD6LFPFeEYeYkSmARCX1hFvNSI2wyBcdgW1PY3yt5Vh91vZBQWlPvzOw8
 2msXE8eYyL0K0zC/yuD/KpT/jYNFQMEM/RDgzBnsB+kPnYT0cyOLUniESXBojITHO/gBTG9LYgE
 q4TMNYiByy2PrY7y6amIbsNzCD+IZRZIHS/zkPik5UWUJVC/WUaBgqk3N0FGEiVEPcJ+WnvYpaE
 z2V/Ucz5Cjn5DxVO1g+Y2cXPOQQh0CltCEkB7euBAuPDAB72F3dmPH0oQ3J3sXTScao/ls5Topg
 YuhSl7BptzzqpDnn8EA==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11898
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 malwarescore=0 spamscore=0
 lowpriorityscore=10 bulkscore=10 suspectscore=0 clxscore=1015 adultscore=0
 impostorscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609060252

This removes the last btrfs callers of find_or_create_page(),
find_lock_page(), SetPageDirty(), ClearPageDirty(), and get_page(), and
15 calls to compound_head(). The folio lookups return an ERR_PTR instead
of NULL, so adjust the error handling.

Update the comments and test messages accordingly.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/btrfs/tests/extent-io-tests.c | 94 ++++++++++++++++++++--------------------
 1 file changed, 46 insertions(+), 48 deletions(-)

diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io-tests.c
index 6eb55bfb2bd4..3056dd934b54 100644
--- a/fs/btrfs/tests/extent-io-tests.c
+++ b/fs/btrfs/tests/extent-io-tests.c
@@ -112,8 +112,8 @@ static int test_find_delalloc(u32 sectorsize, u32 nodesize)
 	struct btrfs_root *root = NULL;
 	struct inode *inode = NULL;
 	struct extent_io_tree *tmp;
-	struct page *page;
-	struct page *locked_page = NULL;
+	struct folio *folio;
+	struct folio *locked_folio = NULL;
 	/* In this test we need at least 2 file extents at its maximum size */
 	u64 max_bytes = BTRFS_MAX_EXTENT_SIZE;
 	u64 total_dirty = 2 * max_bytes;
@@ -152,23 +152,24 @@ static int test_find_delalloc(u32 sectorsize, u32 nodesize)
 	btrfs_extent_io_tree_init(NULL, tmp, IO_TREE_SELFTEST);
 
 	/*
-	 * First go through and create and mark all of our pages dirty, we pin
-	 * everything to make sure our pages don't get evicted and screw up our
+	 * First go through and create and mark all of our folios dirty, we pin
+	 * everything to make sure our folios don't get evicted and screw up our
 	 * test.
 	 */
 	for (pgoff_t index = 0; index < (total_dirty >> PAGE_SHIFT); index++) {
-		page = find_or_create_page(inode->i_mapping, index, GFP_KERNEL);
-		if (!page) {
-			test_err("failed to allocate test page");
-			ret = -ENOMEM;
+		folio = __filemap_get_folio(inode->i_mapping, index,
+				FGP_LOCK | FGP_ACCESSED | FGP_CREAT, GFP_KERNEL);
+		if (IS_ERR(folio)) {
+			test_err("failed to allocate test folio");
+			ret = PTR_ERR(folio);
 			goto out;
 		}
-		SetPageDirty(page);
+		folio_set_dirty(folio);
 		if (index) {
-			unlock_page(page);
+			folio_unlock(folio);
 		} else {
-			get_page(page);
-			locked_page = page;
+			folio_get(folio);
+			locked_folio = folio;
 		}
 	}
 
@@ -179,8 +180,7 @@ static int test_find_delalloc(u32 sectorsize, u32 nodesize)
 	btrfs_set_extent_bit(tmp, 0, sectorsize - 1, EXTENT_DELALLOC, NULL);
 	start = 0;
 	end = start + PAGE_SIZE - 1;
-	found = find_lock_delalloc_range(inode, page_folio(locked_page), &start,
-					 &end);
+	found = find_lock_delalloc_range(inode, locked_folio, &start, &end);
 	if (!found) {
 		test_err("should have found at least one delalloc");
 		goto out_bits;
@@ -191,8 +191,8 @@ static int test_find_delalloc(u32 sectorsize, u32 nodesize)
 		goto out_bits;
 	}
 	btrfs_unlock_extent(tmp, start, end, NULL);
-	unlock_page(locked_page);
-	put_page(locked_page);
+	folio_unlock(locked_folio);
+	folio_put(locked_folio);
 
 	/*
 	 * Test this scenario
@@ -201,17 +201,17 @@ static int test_find_delalloc(u32 sectorsize, u32 nodesize)
 	 *           |--- search ---|
 	 */
 	test_start = SZ_64M;
-	locked_page = find_lock_page(inode->i_mapping,
-				     test_start >> PAGE_SHIFT);
-	if (!locked_page) {
-		test_err("couldn't find the locked page");
+	locked_folio = filemap_lock_folio(inode->i_mapping,
+					  test_start >> PAGE_SHIFT);
+	if (IS_ERR(locked_folio)) {
+		test_err("couldn't find the locked folio");
+		locked_folio = NULL;
 		goto out_bits;
 	}
 	btrfs_set_extent_bit(tmp, sectorsize, max_bytes - 1, EXTENT_DELALLOC, NULL);
 	start = test_start;
 	end = start + PAGE_SIZE - 1;
-	found = find_lock_delalloc_range(inode, page_folio(locked_page), &start,
-					 &end);
+	found = find_lock_delalloc_range(inode, locked_folio, &start, &end);
 	if (!found) {
 		test_err("couldn't find delalloc in our range");
 		goto out_bits;
@@ -223,12 +223,12 @@ static int test_find_delalloc(u32 sectorsize, u32 nodesize)
 	}
 	if (process_folio_range(inode, start, end,
 				PROCESS_TEST_LOCKED | PROCESS_UNLOCK)) {
-		test_err("there were unlocked pages in the range");
+		test_err("there were unlocked folios in the range");
 		goto out_bits;
 	}
 	btrfs_unlock_extent(tmp, start, end, NULL);
-	/* locked_page was unlocked above */
-	put_page(locked_page);
+	/* locked_folio was unlocked above */
+	folio_put(locked_folio);
 
 	/*
 	 * Test this scenario
@@ -236,16 +236,16 @@ static int test_find_delalloc(u32 sectorsize, u32 nodesize)
 	 *                    |--- search ---|
 	 */
 	test_start = max_bytes + sectorsize;
-	locked_page = find_lock_page(inode->i_mapping, test_start >>
-				     PAGE_SHIFT);
-	if (!locked_page) {
-		test_err("couldn't find the locked page");
+	locked_folio = filemap_lock_folio(inode->i_mapping,
+					  test_start >> PAGE_SHIFT);
+	if (IS_ERR(locked_folio)) {
+		test_err("couldn't find the locked folio");
+		locked_folio = NULL;
 		goto out_bits;
 	}
 	start = test_start;
 	end = start + PAGE_SIZE - 1;
-	found = find_lock_delalloc_range(inode, page_folio(locked_page), &start,
-					 &end);
+	found = find_lock_delalloc_range(inode, locked_folio, &start, &end);
 	if (found) {
 		test_err("found range when we shouldn't have");
 		goto out_bits;
@@ -265,8 +265,7 @@ static int test_find_delalloc(u32 sectorsize, u32 nodesize)
 	btrfs_set_extent_bit(tmp, max_bytes, total_dirty - 1, EXTENT_DELALLOC, NULL);
 	start = test_start;
 	end = start + PAGE_SIZE - 1;
-	found = find_lock_delalloc_range(inode, page_folio(locked_page), &start,
-					 &end);
+	found = find_lock_delalloc_range(inode, locked_folio, &start, &end);
 	if (!found) {
 		test_err("didn't find our range");
 		goto out_bits;
@@ -278,36 +277,35 @@ static int test_find_delalloc(u32 sectorsize, u32 nodesize)
 	}
 	if (process_folio_range(inode, start, end,
 				PROCESS_TEST_LOCKED | PROCESS_UNLOCK)) {
-		test_err("pages in range were not all locked");
+		test_err("folios in range were not all locked");
 		goto out_bits;
 	}
 	btrfs_unlock_extent(tmp, start, end, NULL);
 
 	/*
-	 * Now to test where we run into a page that is no longer dirty in the
+	 * Now to test where we run into a folio that is no longer dirty in the
 	 * range we want to find.
 	 */
-	page = find_get_page(inode->i_mapping,
-			     (max_bytes + SZ_1M) >> PAGE_SHIFT);
-	if (!page) {
-		test_err("couldn't find our page");
+	folio = filemap_get_folio(inode->i_mapping,
+				  (max_bytes + SZ_1M) >> PAGE_SHIFT);
+	if (IS_ERR(folio)) {
+		test_err("couldn't find our folio");
 		goto out_bits;
 	}
-	ClearPageDirty(page);
-	put_page(page);
+	folio_clear_dirty(folio);
+	folio_put(folio);
 
 	/* We unlocked it in the previous test */
-	lock_page(locked_page);
+	folio_lock(locked_folio);
 	start = test_start;
 	end = start + PAGE_SIZE - 1;
 	/*
-	 * Currently if we fail to find dirty pages in the delalloc range we
+	 * Currently if we fail to find dirty folios in the delalloc range we
 	 * will adjust max_bytes down to PAGE_SIZE and then re-search.  If
 	 * this changes at any point in the future we will need to fix this
 	 * tests expected behavior.
 	 */
-	found = find_lock_delalloc_range(inode, page_folio(locked_page), &start,
-					 &end);
+	found = find_lock_delalloc_range(inode, locked_folio, &start, &end);
 	if (!found) {
 		test_err("didn't find our range");
 		goto out_bits;
@@ -319,7 +317,7 @@ static int test_find_delalloc(u32 sectorsize, u32 nodesize)
 	}
 	if (process_folio_range(inode, start, end, PROCESS_TEST_LOCKED |
 				PROCESS_UNLOCK)) {
-		test_err("pages in range were not all locked");
+		test_err("folios in range were not all locked");
 		goto out_bits;
 	}
 	ret = 0;
@@ -328,8 +326,8 @@ static int test_find_delalloc(u32 sectorsize, u32 nodesize)
 		dump_extent_io_tree(tmp);
 	btrfs_clear_extent_bit(tmp, 0, total_dirty - 1, (unsigned)-1, NULL);
 out:
-	if (locked_page)
-		put_page(locked_page);
+	if (locked_folio)
+		folio_put(locked_folio);
 	process_folio_range(inode, 0, total_dirty - 1,
 			    PROCESS_UNLOCK | PROCESS_RELEASE);
 	iput(inode);

-- 
2.39.5

