Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CFA33CB8F4
	for <linux-btrfs@vger.kernel.org>; Sun,  6 Sep 2026 22:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788733815; cv=none; b=WlmvoQIggJ5h++ao4gOViDCP2bScokYVKCqyvEhtJndH3rgZ/WL1OvpvvDBi8U+VexVXpCf1Rk66WUztnZq9dfq8nkGmju82kMo+m44Afstc2LUWKHpJIKELic4vYq0mPHQMQRD9UczwaDnN11xMTakiiisoo8wZQZv8621Siec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788733815; c=relaxed/simple;
	bh=9HbGVBX5TrUvmHuy2p6Fy4BIU2dMPYb8NT1I6QaaWgo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=aWxpF4U4s3PD3buAitxa8y/qcw9ygl8IH5BaJoeFkcEz6gJKpviwRWUvkPmcSAO0iHntZLCxG/xEvu+06NFXu34iK9IHzqOttBdJGMVWRobY8MOAgxXuZ0TxGapO4Hsz7YkW0QL4JXRcfPLFsXRVCD6PjoXh/2glfOMIOJdtjdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=O8JDc0Bv; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=TLSQ7Wrw; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="O8JDc0Bv";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="TLSQ7Wrw"
Received: from pps.filterd (m0499199.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 686IXVib4098232
	for <linux-btrfs@vger.kernel.org>; Sun, 6 Sep 2026 18:30:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=xck2
	l++QwEZd4WONax1e8sjGplgHuiAYa/+vfb+E6TU=; b=O8JDc0BvfzTwN6A71kvc
	78sjNRJxVpN/LtRo4j/7YhBigUx8UJsv2dCE7CVn1vHEcyBkhZHVAinddv+0Hy8w
	UXgT8SnKhvVR42Ct5faorkOesM159X0DUh47k5bwnc58lBh3MNllVI+n/bchXm07
	teAc7dyjVtheki+hkVZ8I5x53fFO266nb9vvdPxtoE2mBnqSM5HDjZcFnInEDiLJ
	7jFcRmFMCu0XPELpt90OcNX0Ob0NaUIS87LkDB/sXJYrXI5VVFe+ZXg7Mg6SpcNQ
	Au3VMRtm9Smjc6fEVfjLYghEaKycf5TlNXBaKzlKD4l+j/0IsGr7Tu2Zjud89Ric
	qw==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gh1gs3939-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Sun, 06 Sep 2026 18:30:00 -0400 (EDT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-52fc0097865so78862981cf.2
        for <linux-btrfs@vger.kernel.org>; Sun, 06 Sep 2026 15:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788733799; x=1789338599; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xck2l++QwEZd4WONax1e8sjGplgHuiAYa/+vfb+E6TU=;
        b=TLSQ7WrwLeBrpHwVBbVM59ei17LsWIio9X4VZIVeahnkQQeR0W8A5hZnZA6RsnT+LE
         lY+VKmk9f1cxS+2dnqHzbBv9kNamMId4ghvEYgDuZr7zvxj8UyBeB8MX7sB0u5O1EO8P
         LCqQxJeWJN08kntOlRA1SlLnX3GtIuaCeJkq6PuHI8xFOI/0bXHIqIk+A8SzBB2uKF94
         z2Uip46j/LTvf5eVGlgle1X89ZBiSe27CfNzI4yGajpAYHCMLxiIL4gvrR0/wZRALG+H
         mqD1XFIdpZ4JVnnBaoTyNDPzwc8EgtoUdiyvecrSO2JRBCSOYGgxqRj1CeW9Yk9fgwsc
         Rqag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788733799; x=1789338599;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xck2l++QwEZd4WONax1e8sjGplgHuiAYa/+vfb+E6TU=;
        b=sNBNU64SVnGGvhkGHbEEMYKB8AlsMiuSV6JsImzoy2758PGu6ZUTUdELwhUIpPtkZP
         izDG+luQSL3y8X1mF3qgzzNVRZlQd84RU2aI/661l8cYLH+EGizb3V7IeNyO0QvFwKZE
         ks/0epq8ZxeEMIrPurI8J/TMR3v/0kmDln7w4R/d/VCw8HAMUxDtCOWSJtq3ji7VgpJi
         LLMhqyagyUMWOoO3/lWxusCofVZ+IzQGEGl489dEdGCRJks00pM4tipyPljOMEUQ3wDp
         LjN+eq+OQxnM5VCwG7IxP5LYbRlv9tcSCbeXikrab4P2NURype19pzIbfdcD53lz1EUm
         v0NA==
X-Forwarded-Encrypted: i=1; AKwUvBy/qcWUmcUXZaIJ+a1xOIh7oWmOxjoFbmeap+LEFmxk3BimPYH13ezylifFL/uxveynUNlQvdgkHBJh+w==@vger.kernel.org
X-Gm-Message-State: AFuF++lL6A17OwZqNoWqdmktjkyOfPAYtYg7exIQjx+wVBRiRNu44JIS
	x5zTHmYn+ssvCnvCYgrkrJASCNhqeyhH9Myki7VCA6UTjfBsZ+xjvCG4D7DgJCrFWgxTE2k67QP
	qrhFyICxgCusNz/6PSpcY7hZSkBpXg6ZGeji4//SbsbJlTjfoiMTLrHdTcH9+
X-Gm-Gg: AYBFou0sjS8StqK8eNnWJ9b87Vct52Z62oFj77MvnIdFqkBvUj87BS2bQnpFIY2Nu2I
	HTHPgRaGwrkA4Ny4X0J0c0vRMdrCVxqx5zj3nkJIwIkV8skzO4bchU4Z5NwcHmsHhTlpPZTx3Aq
	Tkl8AF2V/SZRK0TXYjqGsZH5PY6wnMzHB4DRs2bjWrnMmCWLx03+HwbzvF0ZWXC8plmb4+JILtw
	4SdeHd7QZuSH1YwErv0b1LkuWKcfRZnxTSSSrPvCNFvS5HmuhYYck4X2Q++wIjYWUe7kPbSZ8qw
	S6vl5AJfmgtjMrmyaKs+xlSbq+nBh2SSL6hcU1JF1naj11TCY1TTmuJqsi0ixsq6Nm9X0f2qkGV
	wXq0IHAs5bL+mwjC1FHIPvPScv0Nv4DGAWmxihcedfbEzGm1x
X-Received: by 2002:a05:622a:4cc5:b0:52f:b6a8:9e56 with SMTP id d75a77b69052e-53054853b18mr211370781cf.19.1788733799453;
        Sun, 06 Sep 2026 15:29:59 -0700 (PDT)
X-Received: by 2002:a05:622a:4cc5:b0:52f:b6a8:9e56 with SMTP id d75a77b69052e-53054853b18mr211370411cf.19.1788733799021;
        Sun, 06 Sep 2026 15:29:59 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-176-104.net.columbia.edu. [128.59.176.104])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5305402a7b7sm73048541cf.3.2026.09.06.15.29.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 15:29:58 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Sun, 06 Sep 2026 18:29:35 -0400
Subject: [PATCH 08/10] btrfs: keep the free space cache inode mapping at
 order 0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260906-btrfs-folio-conversions-v1-8-834b9d7b06f5@columbia.edu>
References: <20260906-btrfs-folio-conversions-v1-0-834b9d7b06f5@columbia.edu>
In-Reply-To: <20260906-btrfs-folio-conversions-v1-0-834b9d7b06f5@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788733791; l=1277;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=9HbGVBX5TrUvmHuy2p6Fy4BIU2dMPYb8NT1I6QaaWgo=;
 b=Of/A+lVYam6wN5OKQ+C7xZ6FkPUqmt9A/7NEW9RznOiCgNOVH1zKFmYmibvLBYCpSsm/08TJn
 uFA1jQtT3sPAi2a2MJxHQLmaV43zZCufcZWTFu2cKM4wCG7E66jEVjX
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: hb2nn6wzHx-ob8dAUIb_rAygRQaxEi0v
X-Authority-Analysis: v=2.4 cv=HbQkiCE8 c=1 sm=1 tr=0 ts=6a9de968 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=aNLBvxxoObQFLnBXsbaGlA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=G--0XuH5328wxK7v7Suf:22
 a=CzLnJ1dVjGlFsHvV59sA:9 a=QEXdDO2ut3YA:10 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA2MDI1MiBTYWx0ZWRfX+b0qEdD8YvKL
 hxFWzbmO8kLRHW6T0oJV35bHLurCFQjBKLcfpJPIuFGUo+BvWBaa5n/Hbz3yyEJEJUK0hXuo8xs
 XTkdyjvyYwQOHj72NybsVnckKLdiUMp7JkmyCqIXUxWAtdXq5VkZ
X-Proofpoint-ORIG-GUID: hb2nn6wzHx-ob8dAUIb_rAygRQaxEi0v
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA2MDI1MiBTYWx0ZWRfX53fTJ+3g1qI6
 NgVH09i8x6BH9fcdx9PcH0jE/hZRJ76ZEJIz/h6xgDpffoIvYWIjbCNiixw7G0Z41WN5HaQeZPg
 8ibnWukVNY71BSZ0jsfMbs4td2DC+CjYOnqXmyqdoTwO2SrlloTQBZT5AE+aVQP01/QghFi4PgS
 rwmR7yYa40btXN5WRp7BUNAjfrwx87LILPB689ZHvYIFvHJGZhojwZVLSn6pW3jUSBRmIOvpzfO
 5LXWl9XbIHSQG6gZccHq3LpRR0lAmY06idfgMq2hlOi51DC1sn6OVUnbXATYDX4iTrsYAGYV7eE
 N/eIi9YkXRliGU78yZ8mJjopCzD0SfR2H4QNM0CYzXZy13HhENDTPdAhRUX4gheOCgQrp3r57n8
 TUa7YBOa8RjYlsrhGPoURauTYgSNoTQUNzTTQWSipJnhFtQLfW0/02fP7mT8s+Pi1qrSuvzVRwI
 foyGy0JaNYqy46s4IbA==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11898
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 phishscore=0 adultscore=0 lowpriorityscore=10
 priorityscore=1501 impostorscore=10 clxscore=1011 suspectscore=0 bulkscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609060252

The free space cache inode is a data inode, so the read path enables
large folios on its mapping. The v1 cache code assumes one page per
folio. With a large folio, consecutive __filemap_get_folio() calls in
io_ctl_prepare_pages() would return the same folio and deadlock on the
second FGP_LOCK.

The v1 on-disk format is PAGE_SIZE granular, so keep the mapping at
order 0 rather than teaching the io_ctl code about large folios.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/btrfs/btrfs_inode.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 89e5e9c0c904..5d85aa69db13 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -502,6 +502,13 @@ static inline void btrfs_set_inode_mapping_order(struct btrfs_inode *inode)
 	/* Metadata inode should not reach here. */
 	ASSERT(is_data_inode(inode));
 
+	/*
+	 * The v1 free space cache operates on PAGE_SIZE chunks and assumes
+	 * one page per folio. Leave it at order 0.
+	 */
+	if (btrfs_is_free_space_inode(inode))
+		return;
+
 	mapping_set_folio_order_range(inode->vfs_inode.i_mapping,
 				      inode->root->fs_info->block_min_order,
 				      inode->root->fs_info->block_max_order);

-- 
2.39.5

