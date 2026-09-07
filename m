Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFEED41F7F2
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Sep 2026 20:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788812436; cv=none; b=pZ+eHq40Pi0XANV6JWpYVxmI7GluXhewe3NZ79TGphlPPitpohgaTL4e2T/yrMpL55gi4G0nX3w3hjfXwAI3n9O5PiEs764kuK3+C+aLT6iqKhBj5HQ6ByNNd/33hicXen1VcQpmfszDMqri0wpOBGMlClTTZAydsbXRrlafHic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788812436; c=relaxed/simple;
	bh=BcX8eAZRyTKOu9anIq4NjYeefUnKsXm3iDN26nTJMHo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=MeEwyAQICayaZctZ3u0yDDF6dcF4lBwxRWC6NCoIVpkIqFmC6RqAhWHGLWTNpcrBmfvmcdKI63tSvfjYhxjHoV1L8ck+6O4Nlv+/eeao15vPGSBvP0KK3YJQYGFeF6pqY6frvxBu3AgEMCbRSoxOvw53oPwL0rW5WuBqT4gTNfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=nriSgN2A; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=thGtT2Y/; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="nriSgN2A";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="thGtT2Y/"
Received: from pps.filterd (m0499198.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 687IXqcr3505433
	for <linux-btrfs@vger.kernel.org>; Mon, 7 Sep 2026 16:20:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=DZ1+
	6YkyruVGAe1XdJ5/MYgdff65UG0H/MQQoGU3q/A=; b=nriSgN2AxnwodQ+8Uo/9
	fhAeiMtWlgegXFbCZ6mjydZu8+9dlRinqH0cBQq0qVUMlsVJKd5vqM/laPNtV8lZ
	GRF6G7FRrcj+p74B0kw2joQNWoIWsuWd3UpNY71pLJkQHpar9Pj9xUZm6zWfBjXO
	KqYzvDnbZI+z+1yIsHMw4kAfXWm8q7J+LcZ6g5NjvIFLJsnP25jQD/GnrwHiBeyY
	FDyZZ7G55BdtwenCq7uUUGg7B6FcoByCrnpGC3+7Xq8tRUDrGswCXyAyofQuW4c/
	cOx0s124GWmVdJuiThGzB4hggo6QjrpW1y63lAm+Bb9NDjrEk9WVr4ItSso1k6Eh
	Zw==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4ghxx21yj3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 07 Sep 2026 16:20:27 -0400 (EDT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-51bf321d786so33298361cf.1
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Sep 2026 13:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788812427; x=1789417227; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DZ1+6YkyruVGAe1XdJ5/MYgdff65UG0H/MQQoGU3q/A=;
        b=thGtT2Y/UMOYIhFcVSMZJD2oD25djin0eRh6sgAjD+Xta56AoV4E0EBlC/qKmjFDfp
         ov+w3eWm9iQnAR/X/F+0h48XhSc96rXPGAt4dSuJd/IKNQj7yjUQi/EJx3w3Umz1sf1m
         XSZoOgl/xbGYyMG4SsGTf4WWv+23sZlgtgbXn9UMdb+2wmR16loen46PqLzqOKYD2ET+
         SxFb3M2fTvnpuOjx7NxR4rU09/fSyrVpYWIaQQqUvKuwJOdw47M/Yd1HVYlIuLT1XUe7
         UGyLD9MsKqzjP8QvnnQsQE5KmQNvenLCTLKlvSXQFdn/Np7B3om7vw+l6yz8Ng/xfa26
         pXpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788812427; x=1789417227;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DZ1+6YkyruVGAe1XdJ5/MYgdff65UG0H/MQQoGU3q/A=;
        b=KUqWxDyfHyYzZP2wvfLGRGle4EElMEhBwrSMoonmLM4DWTxFuqDDnnUXs6kJyoW1L/
         hqKtEbEO7srzWP7k8W5rIAEHbv1GDYqhPojTrpoBnvMZWu0alR6N3C7AauLxawyn7ZuU
         whsb7D92WsR5VMf9e6SSHlO7t8jbQO5pB0OE2EVlOk6Ru0zw5O0l6xUxJH0bi9qnZ+yl
         OLxOnrElXaj3z5EecIM/SnFlcvO4WM4/zd5pNguUlsoasVQjw9T93yusgXsY5Z0Emhdl
         ckJdwmwZh3QYdqA5gnfVKLgQ3JU/veM1pkEUwX+qEl1jDDUN0coUJpM3Nhi8wzHEyckc
         G1fA==
X-Forwarded-Encrypted: i=1; AKwUvBxnxOAWIN+ZM6TD8uypQpivOpMlb7PVLp+ZPV9m5+8g79+izoDi9g2NomKJcMrLeAHGZNE//g2uWWm/Dw==@vger.kernel.org
X-Gm-Message-State: AFuF++ngTuGrCnQz4lqDeLrYKNb8wQGrB2ebIX3Xgw81cN0jWGETO3YW
	Ic9eYVyK16MSJNoaXHwn+8S+icidzRDC/VZnW3IbEbxYtJCNul0yG+Pb4AJbq4ZiDRweJQS7fxl
	pXLpoBlXZVNru7hOWXmDBwyc2w5J0ljKoEttPlOoqN/C0+GhMVnsNa2zlc7uF
X-Gm-Gg: AYBFou1ELr01EawvtJX5juKAoDL245efB+dPH4z7JFHrpwb4Hd3Sss+rZSJpH6w/V8G
	GbzsrVn91WRGtBUrTKSY/DS2jm6SnktDDmKvKqqMt5U2BrtDdAjMXt0gvGGqIP1QYMhhKqvqdNr
	h0a25CZeyg15WpsYtvvE9B3r+JKq1t91HMrzg1YF/cZ1NHLMGCPWAuFVEMC6j6mEbaOUVe4JFK8
	dYChER5B4RJ/oFMgk9OfD9iOGMtmwv/g3wVMPSe1DLfvm5Oj5byI0nohHTXixlzIOFpLKEjBP0p
	lcSnhta7YdsVep9GeYM03WgnQDEmQk/TCQlB6a8vExk04C1+7OZlkC1X2Fa1Pi7EQVK0V1bcbxi
	xC9pC/IpTVrT8pSwYX0PN6KQ5wbesWym2xOIQ37oOMn8=
X-Received: by 2002:a05:622a:a06:b0:52d:6c37:6853 with SMTP id d75a77b69052e-5305483db56mr276581901cf.16.1788812427323;
        Mon, 07 Sep 2026 13:20:27 -0700 (PDT)
X-Received: by 2002:a05:622a:a06:b0:52d:6c37:6853 with SMTP id d75a77b69052e-5305483db56mr276581321cf.16.1788812426875;
        Mon, 07 Sep 2026 13:20:26 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-176-3.net.columbia.edu. [128.59.176.3])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5305413ce9dsm95062351cf.11.2026.09.07.13.20.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 13:20:26 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 07 Sep 2026 16:19:59 -0400
Subject: [PATCH v2 5/7] btrfs: convert heuristic_collect_sample() to use
 folios
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260907-btrfs-folio-conversions-v2-5-b5fe79f7607b@columbia.edu>
References: <20260907-btrfs-folio-conversions-v2-0-b5fe79f7607b@columbia.edu>
In-Reply-To: <20260907-btrfs-folio-conversions-v2-0-b5fe79f7607b@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788812420; l=1718;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=BcX8eAZRyTKOu9anIq4NjYeefUnKsXm3iDN26nTJMHo=;
 b=gs4Q17e52omuNOjSXOnvvJSvaHUJrhX1NAIyHnz9G84ICSi0uRS80PwzKfTt9PGXV42BB8f3l
 Rcow9nqNT+RDCMnmO8/6MAs/1G8EQHeIDsu2H2HI+733sgKpXd/TiiF
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=YcyNIQRf c=1 sm=1 tr=0 ts=6a9f1c8b cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=92j1mJcILCjWExuphHMrQw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=BpGzv1V74M3SfeTrGa8v:22
 a=iox4zFpeAAAA:8 a=Ih-HaCMmXATMOsCFYvIA:9 a=QEXdDO2ut3YA:10
 a=dawVfQjAaf238kedN5IG:22 a=WzC6qhA0u3u7Ye7llzcV:22
X-Proofpoint-ORIG-GUID: LUNYK1eIYmJ9ApeHisoFKpUC1zRuAIr9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDIyNCBTYWx0ZWRfX0ghqkFYapy6U
 +9vcKhgpAl6OIpaz4LJo5YouHp559fpjjqMRFoVjb4lfRwPYZt6r5K5Yf34TDo6jNCrynhe4gQF
 LOgYqG+1seOUeooqB7XYO84YfERBs2KTquJdCx3BoUTbbP+4MqE2
X-Proofpoint-GUID: LUNYK1eIYmJ9ApeHisoFKpUC1zRuAIr9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDIyNCBTYWx0ZWRfX4ppVb3BEneGj
 CU0fdYz32AqfkQOhMTpGo1CR0zFvDHYSwQwiW32EFtvnTqiK/OPVNqxD+9280XS61GXp9jK7oT0
 6VKWbAiYBOVHNbTHGY3srLf6jMnJi/MksUmLI+JlLabPRn0BYdODoxk7tkMry5DjkG4C/OmVsEe
 hAoVK6cY2RDY08mQRcUVwIsBTkLBfcAcCMDRFOYYSZIYIRs+LFjAX62dLkNk/sgZHkWBYkX7Nra
 s3JUwtlKnp+p2YIHmn5rm8XiYLve1YggGt6+ayW3o2d0o0sIXHnFmP7bpr2DVYH42DSsdapBE+m
 E9vQe1mvXPvHpZWh25eXAasYeVHU1Xlo21jTCCoiKroGhDl83GNQTpCZFN/F4uUAW6jRrg+Pi3b
 QAiXRZJ5rYEwZ5VaLubcxYXZU1mAC0GA6MD6QxrFAn5QUToxObjlJ2mHphd5kXcqf4vmUNup1d1
 2Z+1XXkVj/fsiC4/WxA==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11899
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 lowpriorityscore=10 bulkscore=10
 malwarescore=0 impostorscore=10 suspectscore=0 spamscore=0 phishscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609070224

Convert the sampling loop to folios. This removes the last caller of
find_get_page() in btrfs and saves a call to compound_head() per sampled
page. Document that the lookup is not supposed to fail with an ASSERT().

Reviewed-by: Qu Wenruo <wqu@suse.com>
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

