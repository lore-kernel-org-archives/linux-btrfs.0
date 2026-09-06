Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC92F3CF217
	for <linux-btrfs@vger.kernel.org>; Sun,  6 Sep 2026 22:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788733813; cv=none; b=bw9z1KcNN5cBryStF6QmQ9cf5zTirBt1ZH+FUz+48s+HYqd8NWaXECdJUTUnk2h7NgNIyFYnTK3Aot0i/X1lW2Su0ntrtSjXsKxfOZJxQxBFfgvRM4chPyYEx+mk3zdaflE9Nc61cRM43Wkz+lnzaoxkaGil23+1BIfIx9/ijXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788733813; c=relaxed/simple;
	bh=CJnstd+kkeK8rQHvGFsaX4UzZNSv2sQ+ooNQiOqyXWc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Vkf2eRO8YL4i1QbTluLvgH25BCem0ahnrnxGVPzdH9zbqwrOwYSxFCtAzQQGVqgafXTe+CdJXekeXnctKQbmes2icDpoXsBTXG1qHIdWk7g7oc8V2grtoIANYgQvBnksbtyd439iXMB8o1YFPZQ32+yl8N89rdEhwLUyq4b23nI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=VeVhcdbM; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=lA5XFPAB; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="VeVhcdbM";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="lA5XFPAB"
Received: from pps.filterd (m0167075.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 686KRsA9306765
	for <linux-btrfs@vger.kernel.org>; Sun, 6 Sep 2026 18:29:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=CfC9
	I79u0yHSazTNK3oQEllakS5tB7xZvD5W+HI/8UA=; b=VeVhcdbMErUB3nR9qYBN
	DcGug7nWorR80yaGbRyXmoOn6kV+HUUYuMEmUU0jiobSCQH+AoqWLEie3C5AM9Hg
	upqH6I55pH3UFfQV0uUfE92ipi3hvu9wWCD2F3tXy46haTGLrOvErODMv+PqnQ+3
	1hoQTmuGDxfN7/Kr6IObxwy9VORIoSxrF4kA1msJK67IvIiZYqHUK4A/v6z6iC/5
	s/8B4hHNF2rXXOmTAg+WqACxOpJF+Wmj2+ubIrytpyr/2aWro/vf0QWXket243X0
	oaNZYsurdDHn4pRD/1M0abSccelnTTLjebDpOmt5rAzDnVsuFUc0iU3l74S8BwaB
	bA==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4ghf7krcpb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Sun, 06 Sep 2026 18:29:58 -0400 (EDT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-52ce3c7cb2eso60338591cf.3
        for <linux-btrfs@vger.kernel.org>; Sun, 06 Sep 2026 15:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788733797; x=1789338597; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CfC9I79u0yHSazTNK3oQEllakS5tB7xZvD5W+HI/8UA=;
        b=lA5XFPABt2dx37tDBneR3VTl0iykwdlt819f1wSNdae5M9skytNzNlujDynTfn3Ed9
         0DNpBAne51b1tXtO+7lXL239mKkddjkwklxzo4zQiRszgFRb/fVvhAw/SV0PqXyvYxYJ
         uXig5GmVqm8JYxGIeW4ZREloMjVW6n8LU93y00xDC7J4aDDS5j2pwBYP6HAhRAheTvqv
         0fM6d+QvpTz38dRxT3bkuvTho5G/mBz/aWVJtY12YtQy0rziCq2rEPEVYTagU+ICyaxq
         Z42/8bqnvu6mbqqNme/jkRwFBt37hgfpBfaZqBhMn1UoosOm9+lysXBMH+yjgjMXyxOy
         MNag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788733797; x=1789338597;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CfC9I79u0yHSazTNK3oQEllakS5tB7xZvD5W+HI/8UA=;
        b=j5S6Ro1GJA8N27eoWQ1FcMzFgXdPR2mG/r2WqNxUjBvbOivFrQQiFkCgcAlpmeEQkj
         +GwJc51DBKV5YdotdlTeZp4Ni/XWXRp4sWKkjwBpZaFBTUmjoFdMXxTHIxti20br8g8j
         q8VeqYgosg3lPfwdJQ8cy6IL/m4jzlqFrqkVOS/iSAEdPzmij9Hkmg2Q/VWfvP0OcJMx
         gL/M9JBl/634tuWHslQ5GQUtti9tycppG4A2A0DVhvBgUilJ7fHQnzGNud6Wf/Kg1FIL
         GpukzaP+O5PkOcO2trcoKBmfj9o9sxkS0lU80FZUQjaDeq8ATPyPJ8i6DFefcUvij1DP
         YDrQ==
X-Forwarded-Encrypted: i=1; AKwUvBywuh+Dr1TmGpv+3Nj5/+M00rzNZrPzg48zgZXccxUIEjldLOWxHtlJZLi8nrTKhr+RENJc1SU7CInMJw==@vger.kernel.org
X-Gm-Message-State: AFuF++kmFL4hTsu2LdQgIU77eFGWizrhdjjbmvgPZOzA8uyEa2EoGHOj
	9jECbNbpumzguG/m18gDKpfHo3uBRaxdoFFZUl2UOPwSA5Awu+34+ZyxxNeWO3I0WA4306fBaFR
	SDuq9xLysReeQiI75qJV3hofyajHOD8DLbJZCEWR36hoObqkxk6ZbOVuoyGs4
X-Gm-Gg: AYBFou3MqfodHvyvTeO6m0Q8D6eiU0S+VuwPD3b60/niOzbBb1akSPugUV3STpd3wyr
	1lUdAYlH6IiVAiSSiJA7lu8rhp8E7c562lxt6Gs+BozGDWCe5ivn8hTrvckMSV1XLxG691wTEbg
	R79tqQbaUp3W0ED+aYvTBVVG/xm+/NkVra8DJVubPZkF3vqRladQygPMQ60X3A28cYorIvHjq83
	lDDvpsfnILEgkAkE+PMxKgXgPtVM2UuUTFH0A30CxT0ka94WZiHJZlDYjN8eZPe41J0cyAwJ2bB
	YR6UY+QWO2Gg2PVytfgQYdGvelhFupev5uqRpkTkuO87Oy6SjW9Y4gUtHt2rdCAfGcQhIR3Z/CU
	F+ePjRZ/2LKdhZsZSx5iS+uEtt1+DpYuIxfXxXZGgX/dkil4s
X-Received: by 2002:a05:622a:a05:b0:51c:fc4:a144 with SMTP id d75a77b69052e-53054800802mr226686451cf.4.1788733797682;
        Sun, 06 Sep 2026 15:29:57 -0700 (PDT)
X-Received: by 2002:a05:622a:a05:b0:51c:fc4:a144 with SMTP id d75a77b69052e-53054800802mr226686061cf.4.1788733797246;
        Sun, 06 Sep 2026 15:29:57 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-176-104.net.columbia.edu. [128.59.176.104])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5305402a7b7sm73048541cf.3.2026.09.06.15.29.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 15:29:56 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Sun, 06 Sep 2026 18:29:33 -0400
Subject: [PATCH 06/10] btrfs: fix stale function references in compression
 comments
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260906-btrfs-folio-conversions-v1-6-834b9d7b06f5@columbia.edu>
References: <20260906-btrfs-folio-conversions-v1-0-834b9d7b06f5@columbia.edu>
In-Reply-To: <20260906-btrfs-folio-conversions-v1-0-834b9d7b06f5@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788733791; l=1276;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=CJnstd+kkeK8rQHvGFsaX4UzZNSv2sQ+ooNQiOqyXWc=;
 b=wNakc2lD1D1Qxekt9Elvfw9A3rdleSrn6O45KjMVHUTXImAdH+dOdQInotuFk1LY51uR7P3r5
 WjB9lAd+kaJCEFk5h6e2zb0n5nJvu/JKtFtKQ9a3f0LOXwgQSpSSsn2
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-ORIG-GUID: 45fkaneNYcE6sMTQQ25OZDrmCXZssQoS
X-Authority-Analysis: v=2.4 cv=RrD16imK c=1 sm=1 tr=0 ts=6a9de966 cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=aNLBvxxoObQFLnBXsbaGlA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=HpS3TJQ9O3Ob1ozEcmik:22
 a=wS94dJsgKqXJMQyBkfsA:9 a=QEXdDO2ut3YA:10 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA2MDI1MiBTYWx0ZWRfX5fzFT90uvAjX
 NRKNaBVItSOiPQFwI1CxOimuNdKGiqRoA7UZsgfK822SNoz9T9hgCAI6pYU5arFfZqKxkmK7Pva
 JaWIsdCeydK8h9QLhRCn1y/a8kmNcl91u6YxZiL5NLZXbAqWpMX6P+lqUd+GHqF5GuZaJIAyY+i
 2+8gS/HrSjtmQx6lBvQajDIOTF16MLg9Q4la+fDD+Tb6x90MBZZNPwxP7qVMQXWeLbbBSb09PdX
 0H3VXl+6c3sui17tXUZdGa/OkXMD/NH1qYTFoJ4Pj6zEeMKYGG4NC/qfdWsT9ejFYPEVVdCTwob
 9QklIMQP8C4Zu7kQCRKGPySMUwQkF5u+XT3GNgG+hQ56aFnkXvHY0MbF/2HPf5w4T+eO9Y1IpRj
 c0gJ0QGsbEqh2Io2QHiCItSDIkEBvBg+dA7Km3CMD8qzWevseS2Bx3WAAzIKKFAb1jnTwugp9kn
 pXqZVXH20J1DIJ60o0A==
X-Proofpoint-GUID: 45fkaneNYcE6sMTQQ25OZDrmCXZssQoS
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA2MDI1MiBTYWx0ZWRfX0IRyO1IdzOy/
 Q72A29QVdrczTAV0mNlF3Kj4W2ZVn9NwsoaAQHD2dyWzjjp6FMhJGX9vrAXISxvKVBS3uDfx12M
 lXXLhD9semORtMhmKGc6Sdjpt9C84jHUCf0RDyuDKbsnnAc0DlqK
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11898
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 suspectscore=0 phishscore=0 bulkscore=10 priorityscore=1501
 adultscore=0 clxscore=1011 malwarescore=0 lowpriorityscore=10 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609060252

add_ra_bio_pages() was renamed to add_ra_bio_folios(), and
btrfs_compress_filemap_get_folio() wraps filemap_get_folio(), not
find_get_page(). Update the comments accordingly.

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

