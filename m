Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D6E92D5932
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 14:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792075410; cv=none; b=hp5+IDER6eVVmxSslRySpRNBnCGIN+QekzWl28zs1Xrc2E6Gd3eT0V/Fo8r/3JxVFgLXlGpnMoG4YOyINsn1KH4NtZVJHvty+4ACMPGkaZ4/GTzq1cZhMtJWHk3JupLjQk7qLd/uO6DLgCd1bMOVjHgGjPg9uKkdml8yq3VWlUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792075410; c=relaxed/simple;
	bh=l1msu6fUGlXDLbzJuF3G7A0YIGm5a6dwtgDp6hECOck=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Il3dwrhMLsf10HeHJKcQMlpbxtHEqO+Ue6U3iYKUAKv4/K6e0qqxyDbSztJthg6mnrX9vXTNvMBTZv9JuVrbrxI2Wm5vfqn9CynQmiorszoP5lS8rU92MXY9fEE0ZLqnAbNaKaifEqKmjt3XU8ILPtwpjLXTMmElTP+nzFxsekk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=fuO3v52g; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=ecx+IkK0; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="fuO3v52g";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="ecx+IkK0"
Received: from pps.filterd (m0167073.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69FEY9dO1738826
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 10:43:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=r+qM
	MTrVdByCKG2VkdcgIflOX2Lqg7MaKcwpptJUaBE=; b=fuO3v52gF2kAyaBD4OqH
	kF2yxgx8lgfNmnAp8fkiW4jSMcvFGHxHWU/4APrXFse7QN+jkDQC6IDScJDoFSvg
	FL4tFUWwHm2DVTO52SZKkYjMNoXoRXzetlFKlla/Chy/mZclS4sHF2ymi0LbRS3S
	jWHosz99sj6OuCuaY7a25ygij4MfwL9U1UlV4fOPeU4wznJdP83flU59QpVKHTNE
	gdhbRJm71XejNeGI2bOEWChqiw71BLaw6FcinesuzNBB1Ig5GT2dCCpqcKYPxP1w
	b2eMg7uPIghUHcrAXYCKS9OJAXu7tzuOFVtnpllmyrJ4QOEXzOPjifDoH2GGKGyI
	Ow==
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4hah7jd4h7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 10:43:28 -0400 (EDT)
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-9196b477c4cso1214286d6.0
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 07:43:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1792075408; x=1792680208; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=r+qMMTrVdByCKG2VkdcgIflOX2Lqg7MaKcwpptJUaBE=;
        b=ecx+IkK0Y9MvSy6MZQpSXkrj85cBdtvtGiD+NoqVLZWEQ9ollhKTYpUjp+YygsDq02
         +3D2SnLK+P4C1V8SyVLFweiptuHvisK1U+P+DDVFuBjEswEyfwzMN/h6WBqdK7e4Za2w
         ObAKtkOltVQrZE/pqaKJzz0BcGefXEqpyFHFY7GnH8txzmvRM9DLZsYUri2cpQi2X6lg
         NmVqbxvRtm8M9xIdkmAbwynsbgZ5XELGpYuyHgp17Rb3tUfXZd3mnCMgDNcCiYXfGe2M
         SKm1rop5M5j38U5/Q6w22lEJax4sJekpFZJt1eiIiUQNYKN5yJdhUKAl639XkEUFCNT+
         5LaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792075408; x=1792680208;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=r+qMMTrVdByCKG2VkdcgIflOX2Lqg7MaKcwpptJUaBE=;
        b=Df8X4UAxgmKwyvNFYsTXvIPjT9shD2aLS63iLBnpg3cQLKebfx5RItdC91/dTUHXD1
         Tqqg9iDxMux06fc67AK1Ylo5pFYegTVADw/kzjK1oLouirEPCb5K4aYsAOiNnIYRuhB1
         FYSkZT50+jYEOxylRoFMPt+s+7bY9WvscM+AlQOcInHwTC8pP+CFR59AddURiZbmQE8+
         Wm1LD1XIIy2dnkSiIZiVrNiTHdkvek3JAYxhaljj61On3VYGYjDnkmvZ88rgFlJ77Zmc
         tQwVjdBgmMcrvi26nsrD37VMRlABkzJcqn7ieVtcLD8uUOCFaiChIkSxsKEbVMHQENRT
         PaHg==
X-Gm-Message-State: AFq9FYJrHI4akn2KFSuOQAGR/SOkCU4t5nlOoLdjnpmkTjZGjpYUpWFz
	N4IHsWp5aSPvPls1ZELI8Vv9oQA3xM3M47pBPxChIW0tQ/dpFUBWWmvd/fVuBXZ6PqJ1WRXFXpA
	SvONZi6ygAiArHhNrBaVGdsdNVa4j24Eu3ySSpNQsohggNZCNt06su16i0cxijrZx4fos
X-Gm-Gg: AYBFou0h2YktT2U+lwolWLwn1mDQ/+Wao4Qzc4YEPg0hp2PUJvObl6zs3b+XtD2V07Q
	SJn7dV6YG9V86DQ+b2bgAADyP5U5oe/Ku6eiU3axbWEUNRUoO/utCKv83UzliqoPErygLqqjW6Y
	ocivlXuNw5w6eGR8aSJ92cXT0OtudCJm55xnGUx0P4r+2kpwI7UyxW+knR0G3iX0WKaFbz7c/79
	7lgniDYIjVOu8rYeRDL+dMrMgSDyh36ZBZyInyr5VPqaM4xhcYajVwBh2lLWdT31a9eAyKbf1+7
	4Js20TCd420cvo936v4Hhe4F194DvXxG3kk3hVSM4u2Cbe2i2DDu5C9/kJj9aMQqfKquX6esi8A
	1Rs8623oggzw2yah9C09TdcSMfTh6xuqqYCMtSRRjyAak
X-Received: by 2002:a05:6214:29ec:b0:919:5e97:76b7 with SMTP id 6a1803df08f44-91bc962cadcmr4703576d6.18.1792075407758;
        Thu, 15 Oct 2026 07:43:27 -0700 (PDT)
X-Received: by 2002:a05:6214:29ec:b0:919:5e97:76b7 with SMTP id 6a1803df08f44-91bc962cadcmr4703096d6.18.1792075407148;
        Thu, 15 Oct 2026 07:43:27 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-176-51.net.columbia.edu. [128.59.176.51])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b97b5f323sm83026476d6.20.2026.10.15.07.43.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 07:43:26 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Thu, 15 Oct 2026 10:43:14 -0400
Subject: [PATCH v5 01/19] btrfs: drop the extent maps of the written part
 of a failed ordered extent
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261015-btrfs-remove-v1-space-cache-v5-1-6b31347d9998@columbia.edu>
References: <20261015-btrfs-remove-v1-space-cache-v5-0-6b31347d9998@columbia.edu>
In-Reply-To: <20261015-btrfs-remove-v1-space-cache-v5-0-6b31347d9998@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792075404; l=1368;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=l1msu6fUGlXDLbzJuF3G7A0YIGm5a6dwtgDp6hECOck=;
 b=DMD8OvzP/ioXtpq5AhK9LPvKupQnfJP46F8KBx2gZrxrFCkp1/9rryjuvXVJdBAUjdyKc0Hbt
 gsUyAtAEO73Bm6rf2Wcb3sF2CBansT4yC7yQt35VOqMWrDLOD5ptOMC
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE1MDA1NyBTYWx0ZWRfX6BvIczL2+fwi
 bkHdVmeycnJlFejsvxbFDU5B4axz03GBB4D2OL4FAqOqK8U7alFMxdAqtmTxn62HxO+t18L/8Ty
 /wMxZwpiDycErzka8ttk1terhfTTJcqye09x5jfOnXcDnInCvCy+
X-Proofpoint-GUID: 5lq_JVcPe1xhdiHKPhsz5rhQ9Z-gUJ5D
X-Authority-Analysis: v=2.4 cv=Q7RHcI2a c=1 sm=1 tr=0 ts=6ad0e690 cx=c_pps
 a=7E5Bxpl4vBhpaufnMqZlrw==:117 a=NKoNGjn6KhAaSQkl0TXC/A==:17
 a=zFgV0_0DlQRWwMvk:21 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=x7bEGLp0ZPQA:10
 a=A0y_DWxS2BwA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22
 a=jHxIr1HyPKZ_Q5_91PL3:22 a=IbTQtsteKuFIr66F210A:9 a=QEXdDO2ut3YA:10
 a=pJ04lnu7RYOZP9TFuWaZ:22
X-Proofpoint-ORIG-GUID: 5lq_JVcPe1xhdiHKPhsz5rhQ9Z-gUJ5D
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE1MDA1NyBTYWx0ZWRfXzqmVZI0AclQA
 TyKsfhFY65GJ8FXt2DpKrHRxXOgZvL7hM2FMN6XKeDpIzSTVoX4PvfVKK6bREiM9oS49CdfFYLw
 kx3ia0poy/dTcLYdM2dC1UHJXDHgMXV7P/qLJ6HzTOQ3iWR6dvObsQmPNW1fgF7QcHYPB3QRJDU
 +lk1fBdWs1qP3MwZHHsTbjXEcewao1VtxAY3W3aQ30D/in48LTUlohF3b7iDXJ779HapFYfsSFM
 MzLkF8U+YIJlFJRlvzCDQHAsITSMh2tBlrA3/adNJb9IP7SLK0UUhc1ygnnUDuQlcbGh6mzWBbm
 4ydX7ugX9m43TRtmc9AXASlNcSllcNgZ+NXf83rZR1Ut/hHaVG8Mon0llnA8Q7CVANKC7x5iCov
 OMTCxHiXct0VKN+Sxtrx5ZxRRf2h7/TnP+yyv1TTDbW5vfcIM5vMX2ECtYRO7uMqBiobbd/vrFl
 nWEs5/+syd5FHYnydvQ==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11936
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=10 spamscore=0 phishscore=0 impostorscore=10 adultscore=0
 lowpriorityscore=10 priorityscore=1501 malwarescore=0 clxscore=1015
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610150057

If a truncated ordered extent fails to complete, the extent maps for the
part that was written are kept while the extent itself is freed below.
A later read can follow them to blocks that have been reallocated.
Drop the maps for the whole range on error.

Fixes: 77cef2ec5484 ("Btrfs: allow partial ordered extent completion")
Assisted-by: LLM
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/btrfs/inode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 343b6402bb35..271f6024b72b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3390,6 +3390,8 @@ int btrfs_finish_one_ordered(struct btrfs_ordered_extent *ordered_extent)
 
 		/*
 		 * Drop extent maps for the part of the extent we didn't write.
+		 * On error the written part is freed below as well, so drop
+		 * its maps too.
 		 *
 		 * We have an exception here for the free_space_inode, this is
 		 * because when we do btrfs_get_extent() on the free space inode
@@ -3405,7 +3407,7 @@ int btrfs_finish_one_ordered(struct btrfs_ordered_extent *ordered_extent)
 		if (!btrfs_is_free_space_inode(inode)) {
 			u64 unwritten_start = start;
 
-			if (truncated)
+			if (truncated && !ret)
 				unwritten_start += logical_len;
 
 			btrfs_drop_extent_map_range(inode, unwritten_start,

-- 
2.39.5

