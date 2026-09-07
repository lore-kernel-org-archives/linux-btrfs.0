Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F5E541DE11
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Sep 2026 20:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788812432; cv=none; b=ZeOeDHZ0zCtjtqlIvqome5VmwZWwXLdzrSQx8HqoUxsuHlZwjHEil17nRaLmoKm+c5Ba4mgbrV38kdlZp2gB+t1IzTo+d2hbmGUaa4aCmd5iHhIx8RsIO5FhODss+BDAS+2uf4nwTw6Hla7eWeyKNUK2DYP/yFBE6j43swITxBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788812432; c=relaxed/simple;
	bh=Q8ljCQeoaeoN+ae43nM2Vv6Q0j+dQccM2ug41NNICUI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=L24fDwIdYDdAj1k9SO+ENiw2uv+HdrllWj1OO00auUhQILH3pX996CpNncliSPBG1c8OKn4T8gpK8AZRsmZU6DVGi5yce5erFPZhyra66ciTXGVMGZX41O4FsJhm3GR/qg7DXejhvtMj6PSNMTZmb0/BuLxzVhoVGebtQK6Hf7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=Ol6vKf75; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=xgoRXZf7; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="Ol6vKf75";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="xgoRXZf7"
Received: from pps.filterd (m0167068.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 687JVOPv3457727
	for <linux-btrfs@vger.kernel.org>; Mon, 7 Sep 2026 16:20:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=XJQN
	0uKsYlPtSkjrcSF9XbS467Wd3IrFH8lDz1PZ5Zk=; b=Ol6vKf75F4xp2P+zi7Co
	LUaNmpH6lhq6p1fumZkEBryc1duoY2ZRB94Q5yE43JpDobCHrF05uM4Zh3F92jE2
	zo2kBlAyb234m4wxrD0MAGVgQBhuRwKgF5WhQXnq3BMp+gp4E/HB2z79rXehLvo8
	k5V7ZmEwXe6KZfhOBStbeYYVvPMhiTOHviA7eoyv8LjdLi5WxgGba5sPfnzmcI3R
	rzs1BA8K4w1zrVL3GNqwGRVIPOr+gM40Na32s59afScRTQhq400o0x/u/2QlAR2/
	vGqWKK97qW+hiti0F5lQgaIQBBPsIRmwsu5sXbX1XHlM2QnzNTEPIpaq0yQM6gEz
	Ow==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gj3ga879j-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 07 Sep 2026 16:20:27 -0400 (EDT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-52dcf1bb6e9so77749491cf.1
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Sep 2026 13:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788812426; x=1789417226; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XJQN0uKsYlPtSkjrcSF9XbS467Wd3IrFH8lDz1PZ5Zk=;
        b=xgoRXZf70J2ihezYa15K4VNEi43+z9Vit/bxl60nkSaYMDgRLk68DSC+WBlViT8nZe
         o+OGo83UWVPIioZjBAh7Yc7hkiaYBrz4QsmgfSGtjpp2B2TNHMkGTZUR6CbDaMZMNm1m
         KSTaEzaxR8MJeexR6M7Nqny1+to0khIBYjm1e7pMfYgc/rHbVwP6d11avZW2DMzlkiL8
         ynLZGyHN9ypbTw8lacZo8Zi8DtQsIG17wUrVSpCBPKyZiwbvSq7f+JSCoATSCvivo6+w
         FLxLPWNcwi0LJw40fsoYxZN6TRf7P5zrR67kBsF2GPdXKeCG8hAB9lertpuJfdMlM1rr
         EEqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788812426; x=1789417226;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XJQN0uKsYlPtSkjrcSF9XbS467Wd3IrFH8lDz1PZ5Zk=;
        b=Zqzig43gUvDF06NDczGiOf9QtUI3IMza8AiY7PK4x7fLfUt0J2nxeb9Ezr+Jk89GvR
         5usjt4M7OcEFKIMSuL6lRVGbXm1I2jTm/gIUEaaoUrwDslgW1H5/z01r6DoZSXx/IWr6
         sIIeLdbex0JbsYB8VFU7aGYEYEBDbcP5XmNV1LyEXlS/kuVcA9/1fIt58gpz3LaZAbxZ
         LkcgzaT4ddAnuOuLSQ3EGObFafM17mOqP6/HnanhoNGAXoJzj8bWdVL/6SWDpKVLhmTP
         95qh+yw3Kgcha/mdLtYJYaKF/lOIA9neuxoT2ncGoez5zvQQYtn8m51OAAqX5bJbG2mC
         tfnw==
X-Forwarded-Encrypted: i=1; AKwUvBykJQUUc9degqITuUR+q9UCekzf8Bc+DaymdaIJocJVwQN6QfhjbT1IIlroLobI8/q6iFdBa4x0Nm0x+A==@vger.kernel.org
X-Gm-Message-State: AFuF++mGr5WJAxXYNefQxNDOHxpTAgnA26xj+hBTc1Xyo+r7f9qWbJqz
	0T5uVSRbcyEW8fmuJCu1ILETR1Fr4nlLzDCJXvZnuJGZuMA3xFFXNmZ2m9x9ch9J11cosYjzxae
	QfNTG9POVx8ApKOinU9t5dWSWdm72BrKb7jaPUIPbIzZh/bXBE/8tcZpEDjFVqpVLgUyRe4w=
X-Gm-Gg: AYBFou0V850b4/qQl+vuppPFPlcgwn3RKbruyA92aXCveEkVI8J4X4uMBkbjVZ49vzK
	6g2BMm8rCBMy1GiTAvE17ji9l/ba1SD7TloFS+irSgTw7NylLSPi1OssPcqvAl4vMdk4sc05Kbq
	M5/JRcGdEcrDXtjv8fE6t1Vo1XvbhrC+RDi/S7F20V6lGj6UYCgTuJrX5YtG87d7KgVdn9HMOMu
	43otRdcd+23mGUx3ekcAezRYjzLVhmn26eVZOSV4pqivscFkVpA0YBJa1HC1CuPFFGOksK+IHSN
	Lm3KFXkzL/XU8OdL5ji81QcaDrmXQu0Bl6f5+a8LnpvU4RHv6tCH+7h/skamKo9jSjeZZwsA9Hg
	fYuQio05PB/RFmGKkjiKiWvYkFnpj/+67YfNxzSyKvDs=
X-Received: by 2002:ac8:5756:0:b0:530:4773:1142 with SMTP id d75a77b69052e-5304773137emr248442091cf.32.1788812426372;
        Mon, 07 Sep 2026 13:20:26 -0700 (PDT)
X-Received: by 2002:ac8:5756:0:b0:530:4773:1142 with SMTP id d75a77b69052e-5304773137emr248441821cf.32.1788812425889;
        Mon, 07 Sep 2026 13:20:25 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-176-3.net.columbia.edu. [128.59.176.3])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5305413ce9dsm95062351cf.11.2026.09.07.13.20.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 13:20:25 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 07 Sep 2026 16:19:58 -0400
Subject: [PATCH v2 4/7] btrfs: convert btrfs_compr_pool_scan() to use
 folios
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260907-btrfs-folio-conversions-v2-4-b5fe79f7607b@columbia.edu>
References: <20260907-btrfs-folio-conversions-v2-0-b5fe79f7607b@columbia.edu>
In-Reply-To: <20260907-btrfs-folio-conversions-v2-0-b5fe79f7607b@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788812420; l=1104;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=Q8ljCQeoaeoN+ae43nM2Vv6Q0j+dQccM2ug41NNICUI=;
 b=2RXfdIhT6KuiqFb0u1aNi27qH93hxs1M9rXGGcYK2FV81QV9J1dkThrohMqPvhO7ztYr9AdCt
 S0qobHWeNoNAllmsgkxqYm3KvELi80dIIFXuMlPbKUYx4oO6RnU4h95
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: paf5mOKIzRxYDVVTyCv8y16oFxuD3KQi
X-Proofpoint-ORIG-GUID: paf5mOKIzRxYDVVTyCv8y16oFxuD3KQi
X-Authority-Analysis: v=2.4 cv=C7vZDwP+ c=1 sm=1 tr=0 ts=6a9f1c8b cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=92j1mJcILCjWExuphHMrQw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=usPcmh10W0ubT8QP8_c3:22
 a=iox4zFpeAAAA:8 a=HJL5WrqY3U93294rNdcA:9 a=QEXdDO2ut3YA:10
 a=uxP6HrT_eTzRwkO_Te1X:22 a=WzC6qhA0u3u7Ye7llzcV:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDIyNCBTYWx0ZWRfXwI6uTZKI8qvu
 La8wCbcH+JP0cQAKBWIhBIUyr7dxHrBVfPo8TEcFwkAQatmmK2IjpAzxhm/foIOkXWYeFb2APPd
 dLdA6bz+qO5gBW18KdyTldVHurV/6ylRp16votcwW9AVFpDEX7EvaRRg80y2FVHcdViqLrapmMu
 HEZM0VpIdqRbJCCRC7xJtxgtDY/l4dc1GqyeUHNnAxzJpwWix9OAbFjaHkgXyYffiP8DNcWqDQR
 uxctZMtA3VU6Zv8oyhm8R1LfIpxQhmkm14dweenZB5LU6BpZQsLeaYCCzvoNn1eS1RK/d1dl2SV
 6FXAs6gsS7do6Ws65yJ1LfUf6N+tZ7jDS6Mj2Q5zpOZFmQF5Tvg9GLM9RaZhmsczg1wc3lAxOrc
 SkGwaThOYJunzlloNyf4s9G1gS+Ax5zwmPk5hsAdjrzTU0DZSpepsPJ0YR699FuigQfc+xzZVgA
 HTp5Aa43dG/W6L0bI0g==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDIyNCBTYWx0ZWRfX75478sal2FO0
 33CYZ9LqmtE0NkTNzRxtv1zWhKr2Yx0tg6JbHsHP/cLxUZfINQzRrsW8ivP5DiVhzL6oVpV5Pc9
 2lsFtiHwcuLbFGqSKmRUPlO5HSIVOdbACSQU5ln5WE715wuCMt5i
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11899
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 clxscore=1015 phishscore=0 suspectscore=0 lowpriorityscore=10
 bulkscore=10 impostorscore=10 spamscore=0 priorityscore=1501 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609070224

The compression pool holds order-0 folios, but btrfs_compr_pool_scan()
walks it as struct page through page->lru. Walk it as folios, matching
the other compression pool functions. This removes the last use of
page->lru in btrfs and saves a call to compound_head() per freed
folio.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/btrfs/compression.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index c62b5148d5ac..979b2ffbd8fc 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -168,10 +168,10 @@ static unsigned long btrfs_compr_pool_scan(struct shrinker *sh, struct shrink_co
 	spin_unlock(&compr_pool.lock);
 
 	list_for_each_safe(tmp, next, &remove) {
-		struct page *page = list_entry(tmp, struct page, lru);
+		struct folio *folio = list_entry(tmp, struct folio, lru);
 
-		ASSERT(page_ref_count(page) == 1);
-		put_page(page);
+		ASSERT(folio_ref_count(folio) == 1);
+		folio_put(folio);
 	}
 
 	return freed;

-- 
2.39.5

