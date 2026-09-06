Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83D73C0A11
	for <linux-btrfs@vger.kernel.org>; Sun,  6 Sep 2026 22:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788733800; cv=none; b=S22KT1jsnIs40/kbmoZJIyUlM7+TtZPo4b7BpxCr2yisEicyyek4XdQbjuzJq7zuhgW0NO0hfefKAv0jxJcM0jNRHmAMhmHZtk5jtO+tpraA1ACHHPj/YY3zgEqplRejRYk2uXAuZZMzbJNLt1UQ42PMByDRgDEQ0JEaSk5sAf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788733800; c=relaxed/simple;
	bh=r9OP5EqiRX6SdvmJ7fyAxljdJB91QgBIXVyOwYRs5ZY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=K+9Q3cWpR8B20jyqCS18xzdNvA+RlO+jY7AWkVBxirK5OKE0D15xsTcUs+JIVKoG5RWPyFg03kyDpaitd5Kcv8NO1lGlz3Qyqxa38++OUJ9SaQVML3OBHtpcXnm8YRBKO3DiVHyKLwi2zNmCAbKVTQeeHYAV2Vua759xy8c1N8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=E4HXze3l; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=GwmCNivr; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="E4HXze3l";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="GwmCNivr"
Received: from pps.filterd (m0167073.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 686KY1k1438778
	for <linux-btrfs@vger.kernel.org>; Sun, 6 Sep 2026 18:29:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=Rlqq
	ceqVEqJYjo89RGpGLYw0GPiQZZ2db6ApcR0uysw=; b=E4HXze3lmSdqJx7uNNAG
	lIc4Qacom4zMHItDtIVVPwQbP9wT80Ufw1K/5cdecC/cv/JbZE+Oey044y+Y/eNc
	XtTTxAsah+cidlDoqUxeXtxV9rzFIegWWzlGgo8P5613e7g0fYKyflU200vKAPKK
	RHE+q5egOdkq/Zr2RwJMLWNjlGC9zeU7/RMHV4JIJPA+tuTX0uY2oMGVAVRt37xw
	RNmOYhzpImafH6aflbzUHuIJDICDD3eZ554JOmmwiIZVub74z0PBj7tKuQ/dkVll
	TpNFnJAmawzRQwHZTlq68H7ZGq1bbpAcn7QdzupkhiY73D4v3WS9lWz6RO6lASIk
	kg==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4ghfawrbtr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Sun, 06 Sep 2026 18:29:57 -0400 (EDT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-51c26012cd0so52561021cf.0
        for <linux-btrfs@vger.kernel.org>; Sun, 06 Sep 2026 15:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788733797; x=1789338597; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RlqqceqVEqJYjo89RGpGLYw0GPiQZZ2db6ApcR0uysw=;
        b=GwmCNivrim5E3w1fIZdVwde1N4hr8n34vF+cAjqiYMujtosFy4YTZxNu7fZ+YnH7sX
         ZCbRkq3swTAOl4xIqtfTGtjmsm9OP8lLj974eb/CMacBwyk8m6gcbmbAfAN9miV9zgAN
         dDq8P8DdNOAoVT9wnmblFOdhCt62o9SFr8OYPYwAK3yNDPHgxtgRURgh2XkaF0DSwi9v
         RjhjxFSzO8BljGcqcJbqEzJA/8LXYln1ZSx4ugVkXdbypZRLxov40mZyVG24kA2nS1Qj
         sA1FSnWmMVCfTlAu5TxQHKZKHeAaF6DoDRzs0iC/v6FPWM6MXZKb1f/SWLj4jCTcuFAK
         HFgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788733797; x=1789338597;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RlqqceqVEqJYjo89RGpGLYw0GPiQZZ2db6ApcR0uysw=;
        b=nmIUMBE6PJ8B5492Yr495OuCW87qj02+Me+wPGKuCDzJK4f6bqqXgo9NtbOtEUnFh6
         qKAsa3oNzmqsGHyQt+8K/YoRinn7VGFKKj16DN55sE4LKJ+wBuIj16I5+e9/D7Cfz7Ld
         W8NaN2ehMj2/LSgqsdsdd/Gx+zp59GLL11oOXqHOtXk6Qr8j5c0bQOPjIVyHcEd9aw3e
         n8p9c0/E5mGNfj29zHPB7gBOKRkdI5zUjs/5ylMqGrB7AvS1JxE9wY/zWgcDSxHnFG+f
         yOgHS5kuvS6r9m/vgOXXuydNeYRY3h2I3shU74nS1/AyrCcfWCwA8t9UJaiATYaNSQG0
         NTsw==
X-Forwarded-Encrypted: i=1; AKwUvBwXPfgQXR9gQTSMy3yxeShEbPk5ncnewiCLZ/VVWNbA0qHJqcE9nDfOpEhhC8ycoB7Wd6iDaLV4vo/6AA==@vger.kernel.org
X-Gm-Message-State: AFuF++kLHWKw3+O9jMb6b5c3zor9P3gewO9dmkLcWO1NVjWapTOLWaa6
	hUBNnRdC2dQTRCkDEUyQYBzm1F44NJPakEUUWKqP2m/R5sFOg7qPDR/6XNVP4bHSUGEp4tCRhzu
	nKoddF82D1CcXMhmnPP7iB7FxHluhM6cc2Y2Zq6RRnULaPIBuAQYx9saXADjc
X-Gm-Gg: AYBFou0gR2Uc1Nmb9/PjX8uJ8ErZI/S3H0weqU57kNqPzggBj+n+7feJnRNwfqyiB2v
	v2dB8ja8VjVSkObGl+/06edCOpi7wZZfixwaG7HAChXD4sLbJo5DQzZxn8TAwm+v+64jy6XTdvM
	sNDd0RWJLM++VSzE7ee4UxQggrx7UerXzdr93wlcGDd431LGV91lpj+A+Xb7xXaXoqLtC9in9Im
	yBgwA4xUPNJeNmx5ouCx8//7xYsZJvlBB1GvN8VbmRmJyRf9hY14Vinb1AUWbv3BuL4lXqhdglo
	h+jHuC3/06ygSH9VGBiCdJ3hdhZQGTQhDCRFi1cjisHLAYaSs5BqnYjTWw96DmpRLcGYY6Yyzcc
	nc3aWnh3Vb18lKEJP5yZszJrcb/Mi7tdq9vLyDimuE2IDiuHn
X-Received: by 2002:a05:622a:1114:b0:517:6550:2a0 with SMTP id d75a77b69052e-5305482cdbemr206755201cf.19.1788733797002;
        Sun, 06 Sep 2026 15:29:57 -0700 (PDT)
X-Received: by 2002:a05:622a:1114:b0:517:6550:2a0 with SMTP id d75a77b69052e-5305482cdbemr206754771cf.19.1788733796515;
        Sun, 06 Sep 2026 15:29:56 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-176-104.net.columbia.edu. [128.59.176.104])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5305402a7b7sm73048541cf.3.2026.09.06.15.29.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 15:29:56 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Sun, 06 Sep 2026 18:29:32 -0400
Subject: [PATCH 05/10] btrfs: convert heuristic_collect_sample() to use
 folios
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260906-btrfs-folio-conversions-v1-5-834b9d7b06f5@columbia.edu>
References: <20260906-btrfs-folio-conversions-v1-0-834b9d7b06f5@columbia.edu>
In-Reply-To: <20260906-btrfs-folio-conversions-v1-0-834b9d7b06f5@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788733791; l=1679;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=r9OP5EqiRX6SdvmJ7fyAxljdJB91QgBIXVyOwYRs5ZY=;
 b=OZIHZRewCdU2sBf3GHMjO3+KrcVDSqwCPzT2v6NGHQlZRX4eVUsC8Mo98Ns5cMznUHveglnKc
 JjjjQrwZ+yeDy2QV2hxCvgvGkfixrpbiB3CrsbdsT3Sjc7X2BwyIjHb
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: 0IVr1mcZFTTzGYCpwXceuXVIECzY6FR_
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA2MDI1MiBTYWx0ZWRfX84PV/dEvqb42
 ZD3uRB9QRtfjzJQ53rEx0qdGy+L7B8R9Nv6MJ3ZGKyXAcirVw+8eCe1N7V1WWLRS2pbUWwn7k8H
 DkuNWydJyGGcWWlrrN2Fy5dCDGrr7gdrVQvfgwBh4y5snJSuelI+
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA2MDI1MiBTYWx0ZWRfX+CLxM5nAeqMf
 ExJM83h+eDVbDT0BL6l1jCBbjd1vGMF+Ibh7SZMU97eg/UQ1ZUgWwk9rzjdP7PDyOnx4gLMivpL
 rx3wL+nXZTUSjOi4ZFxJ7K5yXitTta+VxQruhjahrxRjipspj/gthvw0T7+qZflchlw79PtwauG
 1suU8zjmcuGgCH2mZQHCEReSkdrIYRSf2Lmi1i9GAhVTxHE6hAjiP/sDZOfbV4WsF6m+GfHWZyh
 VARqkbhMezYfW0O53fhxi4oU00F5afERtOzCTnVC4kIOREOwMWfccGzfkbqeGKlCHW7vJ7Nq7Dh
 5Q+uA2KMueb7ZQDooeOL7fwwq7uZ4BrcsKuF6349EKIgFnp6pp0VoLez6rJM2jddl8lrYkDfhjC
 DOoC8sVrThuR05TaqZlr+bta1815OzmU+rZc9K74139BbLQrjrneortAc4dy2jR+P3upypEkpkg
 KM8of4/FMQpAIRr3Jkg==
X-Proofpoint-ORIG-GUID: 0IVr1mcZFTTzGYCpwXceuXVIECzY6FR_
X-Authority-Analysis: v=2.4 cv=bvd8wkai c=1 sm=1 tr=0 ts=6a9de965 cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=aNLBvxxoObQFLnBXsbaGlA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=jHxIr1HyPKZ_Q5_91PL3:22
 a=drElJZGrh8K5ZkQw8CAA:9 a=QEXdDO2ut3YA:10 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11898
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=10 malwarescore=0 clxscore=1015 priorityscore=1501
 suspectscore=0 impostorscore=10 phishscore=0 spamscore=0 adultscore=0
 bulkscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609060252

Convert the sampling loop to folios. This removes the last caller of
find_get_page() in btrfs and saves a call to compound_head() per sampled
page. Document that the lookup is not supposed to fail with an ASSERT().

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/btrfs/compression.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 979b2ffbd8fc..fa8b92592321 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -1488,7 +1488,7 @@ static bool sample_repeated_patterns(struct heuristic_ws *ws)
 static void heuristic_collect_sample(struct inode *inode, u64 start, u64 end,
 				     struct heuristic_ws *ws)
 {
-	struct page *page;
+	struct folio *folio;
 	pgoff_t index, index_end;
 	u32 i, curr_sample_pos;
 	u8 *in_data;
@@ -1514,8 +1514,10 @@ static void heuristic_collect_sample(struct inode *inode, u64 start, u64 end,
 
 	curr_sample_pos = 0;
 	while (index < index_end) {
-		page = find_get_page(inode->i_mapping, index);
-		in_data = kmap_local_page(page);
+		folio = filemap_get_folio(inode->i_mapping, index);
+		ASSERT(!IS_ERR(folio));
+		in_data = kmap_local_folio(folio,
+				offset_in_folio(folio, (u64)index << PAGE_SHIFT));
 		/* Handle case where the start is not aligned to PAGE_SIZE */
 		i = start % PAGE_SIZE;
 		while (i < PAGE_SIZE - SAMPLING_READ_SIZE) {
@@ -1529,7 +1531,7 @@ static void heuristic_collect_sample(struct inode *inode, u64 start, u64 end,
 			curr_sample_pos += SAMPLING_READ_SIZE;
 		}
 		kunmap_local(in_data);
-		put_page(page);
+		folio_put(folio);
 
 		index++;
 	}

-- 
2.39.5

