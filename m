Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD93540B102
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Sep 2026 20:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788812428; cv=none; b=LIb+hnfmfxpL8NZHuZ06dtDplHrnW/PhLkuwig0lceeGaLGqqfUZO0PxMKZxFiMSxdOZ9Y+Kfvg5UQGuU/O+nkbmzpxmWFTapvrm5Ziad3NsmgZlQa7tYJf+7zTyka8PXP4HuEwYJ/lIaOoi0mRQ91LemEu2MmAB02OqovfvQhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788812428; c=relaxed/simple;
	bh=7CrZNHHkxIkuOJo45Q3XSFmINtwFQy/yCbxiey+tcdU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=MFvs7I8hvd7nwobh+F3vLMw9ThSUZyzaDUw/DCj4z06yInftOk20OCQIRQA4/SWsfQ96HM+wbKxLxGPkNPp54z2/SWK7pnXQk7fgNqG9QCIxP8i36FuHZajCbar2U5tjwi29kiod2971GTXfFOXaiTWzA6cjSpCzsVvtKxeVR6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=mTIroMZ9; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=5YpBJbDq; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="mTIroMZ9";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="5YpBJbDq"
Received: from pps.filterd (m0167073.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 687IYr943074871
	for <linux-btrfs@vger.kernel.org>; Mon, 7 Sep 2026 16:20:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=e/8X
	t8rVJr6lIvOnjb1t9hnUD7gb2SHMXo5XIPyUSv4=; b=mTIroMZ9VSQDHSfFIKun
	wnxVGlayuUoRMfa7SKWG+pYEFE21IfX/KHvFXmC68aG0rOzp3w3cn44nE/ZY96i1
	8PsrLwDQYHPFzVXbkVxA811BR51/iUq05Vw9w0sohqNWOzcDUt/u+B19GSUplmUN
	4LK7BhXcOReIj5ElzSsJumDc9eUI5cXWQ9PIZxjLLEJ+RfMWVB4drLz/byeLneGS
	gANXnJlFsCU87BtXnYyO6BcxQ3iP/YEK5rfqVzvMDXZDntPBP80xwR4SSelIsS8j
	mup+R4E+lvT8u91utx+f3a7/kJy7DTuRj6cNB39WeIgC6fMRRUjlY6LdyoETKCkF
	7g==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4ghfawwcqp-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 07 Sep 2026 16:20:23 -0400 (EDT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-53062ec5b9bso49968781cf.2
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Sep 2026 13:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788812423; x=1789417223; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=e/8Xt8rVJr6lIvOnjb1t9hnUD7gb2SHMXo5XIPyUSv4=;
        b=5YpBJbDqi2sF0Q7c27P9G1LZuER82OjJg8+2hh1DXlcQ4EwnmQw4ujtElBzni9tU6F
         I9IwuvwymW3xjySKqJvij5jhS/FiXhg2qVwOsnOGifUxKjKfm6sUzdrLamRmhLZp7vk5
         zo8iQXPN94t2vkJPyPt2S/4KnrpFOcfkHZkXMCapypRWRhEpyFDkKpvwgZ6HLb6JgiXv
         ecP3FwMvDgxw/T2blK/QhTaG1yBcJqZ/ISyk3uF98J8EREg5fszLNw7JYzkZvejMIfUr
         Lv9vvcb6GsITzdRe2tQrZkbyc9YTPOeqe6NXLxPbDrGsX5OhY3ZzsCesubHnH1MmbOqo
         85+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788812423; x=1789417223;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=e/8Xt8rVJr6lIvOnjb1t9hnUD7gb2SHMXo5XIPyUSv4=;
        b=IKT6gZOV6Y46KXQtCTZM3eA9HvPCgttD+gqkmo/znqxYFdLiRuwegSDIuBhs78/2pT
         wIGvZ2WVqLYlniF4vVU9GWqtcoTbFRH1FsxWkbXstfdVmbsEj9FKhiCWcSh9EuwJwyEg
         RuHnLqYO3I0/tiZguwRP9Y3hj0EWH+nlAMz5Uk+G4NFPwJ1kBgK/p1sSMQxImTdODRMw
         Ohet/YaK18Yk8rW/7xWXhpDrnmhlEyr9AjkV22ITCLTljMIluZd37GaN+P+AKOPjrv7c
         E8cs2GUGZwX9u/4K0/EEnILrLEjzjj4xachy0uCFoDI8xp4vhtJppDc7OqgSDcNdYOyX
         5wFg==
X-Forwarded-Encrypted: i=1; AKwUvBy2sPZGonTmSrDrd61T0thGbWP76+U6gSvabXVF8P1UT5Rq26Y38+XOS3JdcP7zds6OaCV3b8m4xaCr0g==@vger.kernel.org
X-Gm-Message-State: AFuF++na609E30TfJhBpaedoOfGHh5g6RH2oUorSd+3dSt3xj/4DAOFJ
	SAnwU4i/rl/OgiDNQV+ag9GrhGj11rxgAZYwH3Zb+GXuvAvpc8wmDHeYiRJZxM2D2x0/I2sRLlK
	yTNHqOK7ooBsuXzgbrT8uweTy5p9JX0MMEUkQSAYGwXI4nT1RI5YUnyNxparc
X-Gm-Gg: AYBFou3zEemtyoKki0dG91t4dYS7O0guD5tOBYNsaEkqw5VCffNyQ8PjsI4QnRl2V2G
	BHCMBNbZNSLdYQuM4rQnMx6GrNXbtN8ujQIBAXLVqOrxr3djUhratEsTu0WSbI1XYdV/+Eljd1s
	eCgUwjpLMq7fTKZeDuLWzTqrL+fPdUdq3hSuptWWsz4ynhdK6tSSOrOHA9fdNHHQXwhLNEisExr
	x3YobviMnC9MII48OolnuqJ/IKuImH24PVpyTX87us43Rl0d8p+H/1eqo91V59/nQ9253dhnO+N
	Vl/C2C8nw3ceyHxCHcj8qHfbIScKC9DwKxyzJeGcS6dNs83Eysmm874/aUGGRsfEi2KEe+u43Tc
	GAaklKHBvxhGJB+BDaNnTgGYw7epyhokSwQCc/BtpybA=
X-Received: by 2002:a05:622a:2483:b0:517:580c:bcd3 with SMTP id d75a77b69052e-5305484e5bbmr272939031cf.19.1788812422949;
        Mon, 07 Sep 2026 13:20:22 -0700 (PDT)
X-Received: by 2002:a05:622a:2483:b0:517:580c:bcd3 with SMTP id d75a77b69052e-5305484e5bbmr272938451cf.19.1788812422567;
        Mon, 07 Sep 2026 13:20:22 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-176-3.net.columbia.edu. [128.59.176.3])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5305413ce9dsm95062351cf.11.2026.09.07.13.20.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 13:20:22 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 07 Sep 2026 16:19:55 -0400
Subject: [PATCH v2 1/7] btrfs: tests: rename process_page_range() to
 process_folio_range()
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260907-btrfs-folio-conversions-v2-1-b5fe79f7607b@columbia.edu>
References: <20260907-btrfs-folio-conversions-v2-0-b5fe79f7607b@columbia.edu>
In-Reply-To: <20260907-btrfs-folio-conversions-v2-0-b5fe79f7607b@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788812420; l=2514;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=7CrZNHHkxIkuOJo45Q3XSFmINtwFQy/yCbxiey+tcdU=;
 b=lUibCyWOXiDPqjCmfOUjNQsuqs5O9ACYkEL544lHBSuJaExgYa0Sz++VVb27Q5qzJgNoTUVlh
 IXovoCjp9O7CV2jA/QkcycZcHLCSu/8ZjlPyeK/mSt289NbyizFJkbB
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: jncPJRP954hq6G-TT9npjoD8jopAzvU9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDIyNCBTYWx0ZWRfX/rlMquZH60FW
 XxaIHrmVjn3OfPr3Zi/B3d7Es44UkuwiZENur/SwU0nYfTi/T3D/XXAQWv2v394kHBud8zLVBxQ
 20kbFfFrlCX/ojjaNM0FJaHP8ZvH6qJ/KXOYWvzNmp7d+u1xhTAA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDIyNCBTYWx0ZWRfXwfgCxkFLpDw6
 aAjdmfemdEVyq8b1OHd9+QIm3ZEo1cJarkgCvoIW4ifzRPVVxWqpwBg5rlIaViz7D0AEnwsrf5+
 f2kQe9sE2pVCJ0YnIfYT3pFq4F0ZFb5NWu/0bFTKw91cz+J7XuNrFe+fy/FLe3b+E2/6qzPq52D
 COuWsUQVhwUNJvpV9RSdrOVrqLdK0/b7QP1RyLSkbX05M5+31/lhJbNQXCBz+lCtghX+qRJ1cTn
 xx9PdgWnskCPJqcNrqT9Bx3//HdCmCTOs7uGloKUe6wKu8oz6AzF3Eys76tM/iMayRosG32dSOP
 HBY1SCfwiB42e0S8zfqbqMOQB+jDklDJEuqb9nsAQKPLDT+O5yDfhvKlgu5BNBJICXsKDqMk1tt
 566ScrIxjSPMT3NVqGsYQttmx384CiaR+ibB9GJYGi6PeO7QBI+xNng6rJY2uA2uN/VZGfeicUB
 Yyh32flxJ5o42dS+eYQ==
X-Proofpoint-ORIG-GUID: jncPJRP954hq6G-TT9npjoD8jopAzvU9
X-Authority-Analysis: v=2.4 cv=bvd8wkai c=1 sm=1 tr=0 ts=6a9f1c87 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=92j1mJcILCjWExuphHMrQw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=jHxIr1HyPKZ_Q5_91PL3:22
 a=iox4zFpeAAAA:8 a=VvYWPSha7RrLN2mrkrMA:9 a=QEXdDO2ut3YA:10
 a=dawVfQjAaf238kedN5IG:22 a=WzC6qhA0u3u7Ye7llzcV:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11899
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=10 malwarescore=0 clxscore=1015 priorityscore=1501
 suspectscore=0 impostorscore=10 phishscore=0 spamscore=0 adultscore=0
 bulkscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609070224

It already operates on folios. No functional change.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/btrfs/tests/extent-io-tests.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io-tests.c
index 23459cd4e503..6eb55bfb2bd4 100644
--- a/fs/btrfs/tests/extent-io-tests.c
+++ b/fs/btrfs/tests/extent-io-tests.c
@@ -18,8 +18,8 @@
 #define PROCESS_RELEASE		(1U << 1)
 #define PROCESS_TEST_LOCKED	(1U << 2)
 
-static noinline int process_page_range(struct inode *inode, u64 start, u64 end,
-				       unsigned long flags)
+static noinline int process_folio_range(struct inode *inode, u64 start, u64 end,
+					unsigned long flags)
 {
 	int ret;
 	struct folio_batch fbatch;
@@ -221,8 +221,8 @@ static int test_find_delalloc(u32 sectorsize, u32 nodesize)
 				test_start, max_bytes - 1, start, end);
 		goto out_bits;
 	}
-	if (process_page_range(inode, start, end,
-			       PROCESS_TEST_LOCKED | PROCESS_UNLOCK)) {
+	if (process_folio_range(inode, start, end,
+				PROCESS_TEST_LOCKED | PROCESS_UNLOCK)) {
 		test_err("there were unlocked pages in the range");
 		goto out_bits;
 	}
@@ -276,8 +276,8 @@ static int test_find_delalloc(u32 sectorsize, u32 nodesize)
 			 test_start, total_dirty - 1, start, end);
 		goto out_bits;
 	}
-	if (process_page_range(inode, start, end,
-			       PROCESS_TEST_LOCKED | PROCESS_UNLOCK)) {
+	if (process_folio_range(inode, start, end,
+				PROCESS_TEST_LOCKED | PROCESS_UNLOCK)) {
 		test_err("pages in range were not all locked");
 		goto out_bits;
 	}
@@ -317,8 +317,8 @@ static int test_find_delalloc(u32 sectorsize, u32 nodesize)
 			 test_start, test_start + PAGE_SIZE - 1, start, end);
 		goto out_bits;
 	}
-	if (process_page_range(inode, start, end, PROCESS_TEST_LOCKED |
-			       PROCESS_UNLOCK)) {
+	if (process_folio_range(inode, start, end, PROCESS_TEST_LOCKED |
+				PROCESS_UNLOCK)) {
 		test_err("pages in range were not all locked");
 		goto out_bits;
 	}
@@ -330,8 +330,8 @@ static int test_find_delalloc(u32 sectorsize, u32 nodesize)
 out:
 	if (locked_page)
 		put_page(locked_page);
-	process_page_range(inode, 0, total_dirty - 1,
-			   PROCESS_UNLOCK | PROCESS_RELEASE);
+	process_folio_range(inode, 0, total_dirty - 1,
+			    PROCESS_UNLOCK | PROCESS_RELEASE);
 	iput(inode);
 out_root_info:
 	btrfs_free_dummy_root(root);

-- 
2.39.5

