Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 386D8415B6C
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Sep 2026 20:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788812432; cv=none; b=C+JzvOhcEHsuQGlvwaypTEwoTKxFN2MsPfaM2vdPdSALDn5Z8FvGB0ezQ59m1gdiXI3pTVou45AY225xuog9MgUvcaCo5Hba6NzY234dqTrGgHJDL8sUEMzm+0XW1fpmaP/405sQXBvCT/9qD3IBrtjpzLYsYqVzV59shjRFZ38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788812432; c=relaxed/simple;
	bh=avES3bG48BLV1EAoCdOHxxuCdmO1REtwTj45aoG+V+0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=knjivV5vWmOLHhvzUnTSuAzBzT2oeEmvN11ofmcmAaiHYqiDam+CGOQ6aDMOdavx67ip31l8o43bCI9HzalndT3ALhRPct2iWWNGXAHaQ1r9P4b1uPO+y0WUumOMBKSc9nC56q0Np4JZnp/AHIjYtnjcZwl+oCbwGq/vxxMciPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=F7ykB1aW; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=tVITpLer; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="F7ykB1aW";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="tVITpLer"
Received: from pps.filterd (m0167074.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 687IcpGf3013092
	for <linux-btrfs@vger.kernel.org>; Mon, 7 Sep 2026 16:20:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=tgPL
	3vWXO3hhdRWSeoslHgoDQM0KiG0xJ73uDx2uH0Y=; b=F7ykB1aWB8Sd51fi1N62
	6Zn6Xd1AKTyAVV3R06c2AehkbLf6ip/arw4FlV6JGAJu0txRm3+dUZRvPVAb3Vvl
	jdMJede5LUStSiONd937U5aP7iH7rs2RvNc5e42ItzmPg1H+JCPdCwbguEZGF4o4
	Hlax3EyAkl2gPMKsiTncg9shaMtB779VtnA+kkRP0zuwc3mno3jpajOnImW4ukYW
	Z/lgMIwZs/k+6d7W1dd4GVHPsq0RAPukuZUX7777dd0Ag74+JFqHLK6xMXDuoU6O
	GZvWEiY367QeSgP6cqbmmGUevWQtkj/DqrxqMi3H01y9+gCWRirBomFq8V4Bcrjg
	Qg==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4ghf7qnc8d-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 07 Sep 2026 16:20:24 -0400 (EDT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-52ce64c41efso96310071cf.3
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Sep 2026 13:20:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788812424; x=1789417224; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tgPL3vWXO3hhdRWSeoslHgoDQM0KiG0xJ73uDx2uH0Y=;
        b=tVITpLerDJj7Mkh1878bt8vagalozRV1iDZBjE/KduJn+PUyb5Q5jEeQF2nEZNUHOe
         Z7tOPEalyAfP8YZmdcR7DZF/JAwDsvGIYMIjVb8eF3Z5QsQeVP9V63nwamZCxyukthEG
         kWp9ijFn/sJwz7FVNyNdm6/8Eg7LHUvntgNhC8Ow3t3H6Gv9aPA+o3afVhyBOpRXip77
         E5Ipe8BJrgBVUAP63c5JoE3pS7VscmI64dyQcOZjEv1drg2fUdJccbdl/9FgQDNSF3I8
         9Xk4JZ2w9w8UAzQN/IHxXgFsFRnyyTasi6+cNeEWqn0o4Fj1FsezKhpUQxkHLOVs/2ra
         /Brg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788812424; x=1789417224;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tgPL3vWXO3hhdRWSeoslHgoDQM0KiG0xJ73uDx2uH0Y=;
        b=R85JD32yRs5ad27ondPUbT6uW3AI0KsjuNAZhZDa1JuA5Sd7oYsR0haZnnSM2mre9C
         GdEzHd4cnZiftA2HhPlMKPcA3gTTvjIfnBfCR1kNX8mrhqH2DBDGAgwnXxc4G9HbtzQ+
         7reLqegxUGhC0/5m7rkRWyL6kYdbz9yEL7pdM6MfpCd1xub5Eg+SLgNvKwWbePEMC5Vb
         RjZqAF31F7EoJRhtjP7nWGPdfGUdFIf+k4XVq95LB7XxeSS1bL/5S9KI3j19l/QGerNN
         PC2f+nab8qiGaFizkXOmExKzFG50tYQ/Kq3aluLZPCnOqL0Ca5TcBE3VJ2ou48lPrkNc
         uqyg==
X-Forwarded-Encrypted: i=1; AKwUvByNCCneIs06P029zFsu0PkNHqxJYGxq5dkWo4xDpxsOlYYwx3yyQ+YbJaHlQd9nbVrBSh6yXRSOdlOwsQ==@vger.kernel.org
X-Gm-Message-State: AFuF++l++oMGg+UzHl7IjDE14HFCdX2bt0UFphQcT39hUrYgqXnyABA2
	GXYySOokFhHenZm46j2Ryc+7q7UHIupvZB0h3y5b8ptkKN8mmrhqOgi4IaKx8ahDT6074wYbgxZ
	v0KtwglnkrGHVwRe8fTuzwYkZhLInG6/kb4Ud5X4WwjaVoPH37Afx9U5kS7e5
X-Gm-Gg: AYBFou29jzzEB+HTM+1G2YFOWKSSA/tpnw2A2XsjGqEN6GsvbfJpSU8OK45mBNFSHy5
	LG/MAGmk/UNPTWjX/wt/YgReGBO2ftphZE6tmh+3g/ZnE21wtFirg1mgOVgGE6DXR6K2EboqKq1
	4e+JeYCfbsC+VkfxXK1qWj1WXOCe/VxKMEvT2GJ18NfgYk8O3RpSGDo0CwR2k9yXJRhw8vKRhS3
	0oxAsU0hg4LtnGER+vRYKwFfp8RGxQ3lFQm7N9frPisOMvuM3Q/TbmEF+2ckLCZ0azuSsIKXsN5
	xJmTuOSn9AQz5nvB7LDHXl8dvxCpWFsK5yzcWkXPBs0lPaQ4JNcp5xIaADbrkiF2+HPp8UT6zue
	c18B1ScAgGh0S1iOPqZwp3w78LJsUFgvIph2loBozg34=
X-Received: by 2002:a05:622a:d19:b0:530:74c2:2a59 with SMTP id d75a77b69052e-53074c26c9dmr131540851cf.37.1788812423896;
        Mon, 07 Sep 2026 13:20:23 -0700 (PDT)
X-Received: by 2002:a05:622a:d19:b0:530:74c2:2a59 with SMTP id d75a77b69052e-53074c26c9dmr131540311cf.37.1788812423425;
        Mon, 07 Sep 2026 13:20:23 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-176-3.net.columbia.edu. [128.59.176.3])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5305413ce9dsm95062351cf.11.2026.09.07.13.20.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 13:20:22 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 07 Sep 2026 16:19:56 -0400
Subject: [PATCH v2 2/7] btrfs: tests: convert test_find_delalloc() to use
 folios
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260907-btrfs-folio-conversions-v2-2-b5fe79f7607b@columbia.edu>
References: <20260907-btrfs-folio-conversions-v2-0-b5fe79f7607b@columbia.edu>
In-Reply-To: <20260907-btrfs-folio-conversions-v2-0-b5fe79f7607b@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788812420; l=8635;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=avES3bG48BLV1EAoCdOHxxuCdmO1REtwTj45aoG+V+0=;
 b=u6Z/NPXQqwpX9Hxw2oRzDdYGukmK5kzfapX6Oxaso1TnfRrJgYfbRicx7YCy5KNoytDTDShhu
 Y0zOj0toVa7BaQL5HW4srwnGl6ll7TSY8EfT+2MY45ANzrPkuBpQN0x
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-ORIG-GUID: RQn0LXZK5hT9YVpBh1WEf6tkOuDUaisf
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDIyMyBTYWx0ZWRfX0xb7SwarQgZg
 KMT9MlYHJaVhvuoPXrLKip8Vx4iD24jpoiqiKeHJMmOjN2amIn2SI2ARfBGoXb8yEBTCBHpeSPF
 ZENRkl87IkjwaGZWYZq/ebWRjjhrnn2ecixCJrJTP7MeC5s5J0Ek
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDIyMyBTYWx0ZWRfX+of3DIXtOC7K
 5hz3jHnArq2avJEiq/xU6O7LuVNzoItuvrhzr3NGehjzgipOUVTSr75GeGWUUHSYiTIAbSfJNED
 +QRDZgi6yui2xnLnDzk6rwWl6/rjH7mUs0DoyziP4Dsw0wPbp6wOzrHgfzVQ24mR0o5N58i9lBX
 0tLBWrFSC8Orji6EKN9BG7N3eFC+roqKDYQUHRcdJxwsB1T3SGQa4QMmKuzSTlsMUmjW4lZPpKf
 M0ZsHlYKv0OIu0dxjlsj/Nv9laS7UfdUIb8vX15llQ3RRPiJrSYUEqOjM24x+OJTSWkuATdKrKB
 i5mWLGIMPR0F7w/rHrRR6OAH5+Ex3kVu1cstmoZffsfELdcbyUqZj+jfrumH+McaLeRjz9x82tY
 KjktAGf6ndPL4ISIfsc/KW/unMGDCWx4VafFsqalOaBWW1sLhxOb/X2ERQZ5bGGSLBLarwFTJkj
 btd/Zk+MQEa1ug0ftpw==
X-Authority-Analysis: v=2.4 cv=N94Z0W9B c=1 sm=1 tr=0 ts=6a9f1c88 cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=92j1mJcILCjWExuphHMrQw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=azVShVRs0zEubeQ0wG0L:22
 a=GGKBf0zGomX5QsxccnIA:9 a=QEXdDO2ut3YA:10 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-GUID: RQn0LXZK5hT9YVpBh1WEf6tkOuDUaisf
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11899
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=10 suspectscore=0 clxscore=1015 impostorscore=10
 malwarescore=0 lowpriorityscore=10 phishscore=0 adultscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609070223

This removes the last btrfs callers of find_or_create_page(),
find_lock_page(), SetPageDirty(), ClearPageDirty(), and get_page(), and
15 calls to compound_head(). The folio lookups return an ERR_PTR instead
of NULL, so adjust the error handling.

Update the comments and test messages accordingly.

The test still works in PAGE_SIZE units, which relies on the test inode
never getting large folios, so assert that the folios are order-0 where
that matters.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/btrfs/tests/extent-io-tests.c | 99 +++++++++++++++++++++-------------------
 1 file changed, 51 insertions(+), 48 deletions(-)

diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io-tests.c
index 6eb55bfb2bd4..e7aa8bc04706 100644
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
@@ -152,23 +152,26 @@ static int test_find_delalloc(u32 sectorsize, u32 nodesize)
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
+		/* The ranges below assume page sized folios. */
+		ASSERT(folio_order(folio) == 0);
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
 
@@ -179,8 +182,7 @@ static int test_find_delalloc(u32 sectorsize, u32 nodesize)
 	btrfs_set_extent_bit(tmp, 0, sectorsize - 1, EXTENT_DELALLOC, NULL);
 	start = 0;
 	end = start + PAGE_SIZE - 1;
-	found = find_lock_delalloc_range(inode, page_folio(locked_page), &start,
-					 &end);
+	found = find_lock_delalloc_range(inode, locked_folio, &start, &end);
 	if (!found) {
 		test_err("should have found at least one delalloc");
 		goto out_bits;
@@ -191,8 +193,8 @@ static int test_find_delalloc(u32 sectorsize, u32 nodesize)
 		goto out_bits;
 	}
 	btrfs_unlock_extent(tmp, start, end, NULL);
-	unlock_page(locked_page);
-	put_page(locked_page);
+	folio_unlock(locked_folio);
+	folio_put(locked_folio);
 
 	/*
 	 * Test this scenario
@@ -201,17 +203,18 @@ static int test_find_delalloc(u32 sectorsize, u32 nodesize)
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
+	ASSERT(folio_order(locked_folio) == 0);
 	btrfs_set_extent_bit(tmp, sectorsize, max_bytes - 1, EXTENT_DELALLOC, NULL);
 	start = test_start;
 	end = start + PAGE_SIZE - 1;
-	found = find_lock_delalloc_range(inode, page_folio(locked_page), &start,
-					 &end);
+	found = find_lock_delalloc_range(inode, locked_folio, &start, &end);
 	if (!found) {
 		test_err("couldn't find delalloc in our range");
 		goto out_bits;
@@ -223,12 +226,12 @@ static int test_find_delalloc(u32 sectorsize, u32 nodesize)
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
@@ -236,16 +239,17 @@ static int test_find_delalloc(u32 sectorsize, u32 nodesize)
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
+	ASSERT(folio_order(locked_folio) == 0);
 	start = test_start;
 	end = start + PAGE_SIZE - 1;
-	found = find_lock_delalloc_range(inode, page_folio(locked_page), &start,
-					 &end);
+	found = find_lock_delalloc_range(inode, locked_folio, &start, &end);
 	if (found) {
 		test_err("found range when we shouldn't have");
 		goto out_bits;
@@ -265,8 +269,7 @@ static int test_find_delalloc(u32 sectorsize, u32 nodesize)
 	btrfs_set_extent_bit(tmp, max_bytes, total_dirty - 1, EXTENT_DELALLOC, NULL);
 	start = test_start;
 	end = start + PAGE_SIZE - 1;
-	found = find_lock_delalloc_range(inode, page_folio(locked_page), &start,
-					 &end);
+	found = find_lock_delalloc_range(inode, locked_folio, &start, &end);
 	if (!found) {
 		test_err("didn't find our range");
 		goto out_bits;
@@ -278,36 +281,36 @@ static int test_find_delalloc(u32 sectorsize, u32 nodesize)
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
+	ASSERT(folio_order(folio) == 0);
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
@@ -319,7 +322,7 @@ static int test_find_delalloc(u32 sectorsize, u32 nodesize)
 	}
 	if (process_folio_range(inode, start, end, PROCESS_TEST_LOCKED |
 				PROCESS_UNLOCK)) {
-		test_err("pages in range were not all locked");
+		test_err("folios in range were not all locked");
 		goto out_bits;
 	}
 	ret = 0;
@@ -328,8 +331,8 @@ static int test_find_delalloc(u32 sectorsize, u32 nodesize)
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

