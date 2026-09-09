Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 287C833B6D1
	for <linux-btrfs@vger.kernel.org>; Wed,  9 Sep 2026 17:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788973863; cv=none; b=JRESIye+PNq28p9Y1VQiMlU0jw0cEuR8tCFwMx8XlVANrSYGjyH6deUfWUjOJDok8L3Sc6iiTprGe7itfIDQzI70J0wH3NbSedCx5YBi28Nj1ArOiRq/AcsRFaovyWcB04xuuca6smLHAix3EF6iq9h2+c0KyjjN6Xsli3leFJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788973863; c=relaxed/simple;
	bh=rc6pysinAtxTWfmbt7G11fkKqor3YnttVUGOKHDnERk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=dJI9x/FMZ6kNFQSt7yrTVdfELMSlY/pyR4N3Ed7sC5NbP3RhueSWKf4gV0FxO8eG71vrJxpNZ+wOtSp8i8QfnnMh8693qISoMj3DfmCtjSOkInhL/8W/+KY57TMv7m5DSeNImVBEwgTAV5ab/nHNIGRbgHa8QW2WVYvlEUJzero=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=lLstiXsk; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=xkStEwrc; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="lLstiXsk";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="xkStEwrc"
Received: from pps.filterd (m0167075.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 689GZ5Mi497194
	for <linux-btrfs@vger.kernel.org>; Wed, 9 Sep 2026 13:11:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=lpt2d26XTQe1uORrhGycOSTTTO
	JsJUi2+IgNx3gMRHY=; b=lLstiXskjuHaqDqOOrjd9ZcnX3iz6WlMj1mX+8Uxfz
	eQmxdudmLF9VqBgOBqY35n3VSmWb4AzgwVO2ULOoaUdFwWa/q+Amv/pC2ivMCss5
	bZrEGfDJYInPsq+1vMAU/WZNylbsi0GZZKnIi7nVl5o2I+cFzhS57VgNGAd7n50e
	uiF8dFvCBr/2cS7NsVFudvVAHDjVkaaw5NyEvakrfbbNcFzYCbOIMhpSTultiZeV
	OVaClza1+CgwQ9tmvSk2kWmVzxLAHNn4ik/rzpnLz82/T+1AtPUegzij53zTDtlS
	2A6MRXCq8iUIbE/uU7sRsdLdW5XCrcPr8aSpXU4rkEpg==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4gk0an4ghs-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Wed, 09 Sep 2026 13:11:00 -0400 (EDT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-5304f2b5946so113488711cf.3
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Sep 2026 10:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788973860; x=1789578660; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=lpt2d26XTQe1uORrhGycOSTTTOJsJUi2+IgNx3gMRHY=;
        b=xkStEwrcLztU4C4HqGzZlTRx9MW1j7T/v2IaBrt19p9JNnn5/3pxCeqTj8WqHiYfH8
         YeshfhY2UbqQ+PDr1wxhcM9/tBXLtpjKDUAUqCrFOmqvRulRu+VISEieTjBTh/HkMEtL
         p497Wlj4zFG4xlMCIpgVYQSu4u3Ld7gQD6se+/O3eYKuoUq/QbE/PvX6Q8SodZqmh0JP
         q4EwTUqxmsr4v6Jh33QfhCaWrHjQawPP8YhOTSojJJi+BK9JGIzpX0VyXT6EPIAREtCI
         5llZuKDkYOWhxyx3X/KlcnIxZlRjHpS+JUBaJEQksyWSbMXsdPdggr02Rvw8Cn7fQOLz
         aRWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788973860; x=1789578660;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=lpt2d26XTQe1uORrhGycOSTTTOJsJUi2+IgNx3gMRHY=;
        b=IzxMogV7d+kdkuFRdkcf8iDLQ5/wsCSk4R3KemANh+9Q9/Gk/MkRhQC5gW3dsVohss
         eQyaUXs412KnVDsbEjeDDcAOw0d2AbzOtFA40Y4rcd8I0VZht7oFSc35pBF1q14qWVig
         ET/VUL4A+iH39sIg3VP1zXuvci93dgwdaaKQ02ULQUa8vLnrrargJ6P5gEXqrzFI4OQA
         6ci1SdZ1VwHNn8vVds2gxfLmEGEp0vYEzJKFk4oPClwkINHGIjjPFu8DMnanwFahEZed
         ZkTr1savGrVSL6GATPveeJLOA/g0F+X1CUyCRZLVNYWBVwrlwXNnQojKD7OvqYp+cGJw
         33mQ==
X-Forwarded-Encrypted: i=1; AKwUvBwYpayZD4wBKZutc62539KK0imzhQ1gL8iFC+vNpFQyPNbm8e41kv/QEXLPV5MvyMqlUAXvS1taN1OqdA==@vger.kernel.org
X-Gm-Message-State: AFuF++n9Z/yLqRigJAeuJAwvaVhpxd0MsSso4Di+lhul17FA488naMwV
	ub4QWPASLViLTF68OSa1CYyIF+Rf5Bh0Si3rBrT4r4P2zDOrXmlzvQ/Q6GiKFEA8N36OVjDz3Od
	jqCU6Hm7/mGGxjgjT5MXPS4pzPfMjulmnFbogIHDX4V54WBBzLVaNqiTvw1iGiSopY9zrMEM=
X-Gm-Gg: AYBFou2Q5RseptzNrE8xIFXlocBAZPes8b7Nnt6Mn0aLdedcwxh/eg/TcqW7ui43Uwh
	uEg16PzbSKLs4dQRO7IK4UazBOBPeeF0fGCssAfOQkcKCrSeAYQhDHxUZKcWFIJFCmhJZ0sSd+R
	vWAtEfH+j2P/Urvffi1hu0MTWgOQl0jvow7big77TkMQ4Au7fwqePfKPLml1GG3NribQ8Szpor9
	9vx8sWcZk6B9qvAJaO2EvB5lRUQzp4N4J0eV1eVGxZJQ6Le5bvatXzpsSGBgVXJJc6pRWSJkEBc
	jA7N8vQuIKVEUx8adEJGimJx96v1UTkgnhHSxbRMX9cDhRqzxyCA278fynu134eIKfD+eZrD29V
	QH29y6Vnmt1P3Ro82sn897c1lDi/1WSXx6NxrU68tNH4ytKqm
X-Received: by 2002:a05:622a:2516:b0:517:8011:3a4b with SMTP id d75a77b69052e-530a2c4243dmr110781721cf.21.1788973859979;
        Wed, 09 Sep 2026 10:10:59 -0700 (PDT)
X-Received: by 2002:a05:622a:2516:b0:517:8011:3a4b with SMTP id d75a77b69052e-530a2c4243dmr110780551cf.21.1788973859333;
        Wed, 09 Sep 2026 10:10:59 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-176-193.net.columbia.edu. [128.59.176.193])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5308fc10b78sm64927471cf.30.2026.09.09.10.10.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 10:10:57 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 09 Sep 2026 13:10:48 -0400
Subject: [PATCH] btrfs: use u64 for the page indices in
 heuristic_collect_sample()
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260909-btrfs-heuristic-u64-index-v1-1-8606b3c89807@columbia.edu>
X-B4-Tracking: v=1; b=H4sIABeToWoC/yXMwQrCMAyA4VcZORvoRhnUVxEPtk227FAlaWUw9
 u5WPX6H/z/ASIUMrsMBSm8xeZaO8TJAWh9lIZTcDZObZhdcwFiVDVdqKlYlYZs9Ssm0Y8oxBM+
 ZR8/Q+5cSy/573+5/W4sbpfodwnl+ADUmDJF9AAAA
X-Change-ID: 20260909-btrfs-heuristic-u64-index-cdb994fdf14f
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788973852; l=1567;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=rc6pysinAtxTWfmbt7G11fkKqor3YnttVUGOKHDnERk=;
 b=Z/SSveEx0RWg3+66nrs20K2QIMA0SAKh/FZs6GwHWXnO8lsjr0U83fIjJIglJdv9r9fi4V9fl
 ydmRlI3v6FMD+47h73KbfAjZR1WyaxTPGX44h2g/SaI4o129x7vcFnb
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: 1DD2HY8m5r4uH3kll9ajgA3il-ZXQXia
X-Proofpoint-ORIG-GUID: 1DD2HY8m5r4uH3kll9ajgA3il-ZXQXia
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA5MDE5MSBTYWx0ZWRfX5FvWsGiIkgNU
 zWSyoKAk61w0MTo/W20ybD/WunsL3aRvr2/uH4gf12JWDZMB82wFPAm4j1UvCYM1F3JbylbZE/A
 njDQasQ+kyx3U8vWf2U/n1njDr3hwYOth+D0u4mUIVzHaGrYW2lJAwlITU7RRvnrQMnr7UQJWiO
 bmOWLDXjYEaQqffzPNTfdXyTOErjYiEpdd6ozULMVdUhS44AdV2JGWE3zaXclk7LagDow1VOU41
 VMqUbFzi1cszAQFmw9uhrh9soDo4hfoZPJ8VYAvnV8mIgL2/rKMtvqDv9jRXyLY7SvlC6BLl4vy
 +BoAimq9qWulIi2D12SYkIufEJ4FBlEoF2fhw+aXsLiHFceiPKwzbmxrAUzVVQZplcTtSSOAP5c
 9FtRT4acwpF+6WFdsG3A7sYYnPXe/lmCDKFhjaBaH+DZJsyESRtPQz6M/fmFeMHBiBWKTA1yT8x
 9gDurEgjJbF/TZtOJtA==
X-Authority-Analysis: v=2.4 cv=dbiwG3Xe c=1 sm=1 tr=0 ts=6aa19324 cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=fJxgZNdXt3opHMdyAp+FXA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=HpS3TJQ9O3Ob1ozEcmik:22
 a=6w9P9XadSiK96p_W-bMA:9 a=QEXdDO2ut3YA:10 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA5MDE5MSBTYWx0ZWRfXz5kX/OzPsm0V
 eYfZI/6dfwmHccZ+WiqsW1TPZEbhLiXQPKZAoLAObgjqnYapn7O1lplcNLSbASfhKXlkjA3Acby
 SRYJl5PdQhNaV53rDyqyiRyOuU9i1pp2z99EG1YK6wotv3aMymMp
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11900
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 impostorscore=10 clxscore=1015 priorityscore=1501
 spamscore=0 bulkscore=10 lowpriorityscore=10 malwarescore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609090191

index and index_end are derived from the u64 start and end offsets, and
index is shifted back into a byte offset for offset_in_folio(), which
needs a cast to u64 to be safe on 32-bit. Make them u64 instead so the
cast goes away. They still fit pgoff_t where they are passed to
filemap_get_folio(), as they came from a valid file offset.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/btrfs/compression.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 20169d028961..228d1cdd7c29 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -1489,7 +1489,7 @@ static void heuristic_collect_sample(struct inode *inode, u64 start, u64 end,
 				     struct heuristic_ws *ws)
 {
 	struct folio *folio;
-	pgoff_t index, index_end;
+	u64 index, index_end;
 	u32 i, curr_sample_pos;
 	u8 *in_data;
 
@@ -1517,7 +1517,7 @@ static void heuristic_collect_sample(struct inode *inode, u64 start, u64 end,
 		folio = filemap_get_folio(inode->i_mapping, index);
 		ASSERT(!IS_ERR(folio));
 		in_data = kmap_local_folio(folio,
-				offset_in_folio(folio, (u64)index << PAGE_SHIFT));
+				offset_in_folio(folio, index << PAGE_SHIFT));
 		/* Handle case where the start is not aligned to PAGE_SIZE */
 		i = start % PAGE_SIZE;
 		while (i < PAGE_SIZE - SAMPLING_READ_SIZE) {

---
base-commit: 0fa0a3b3b2b007ab40e87245152e1328703a317e
change-id: 20260909-btrfs-heuristic-u64-index-cdb994fdf14f

Best regards,
--  
Tal Zussman <tz2294@columbia.edu>

