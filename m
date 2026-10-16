Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C2A5A0AC1
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2026 18:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792174425; cv=none; b=OVwhmHoaGCMzjYYwdXpXKEBcfpUCGdK0pBmXp4Q6qrn5LXnD9tzZTwGPEWYePLzQuM3aCK27TYEgInPmKuXrymSxSawheFAetUbZ/mYHT2RKb0G42bIXyzQwQbEv8KiErt/gTfAzVnIqQ64GyyehH4wnsFMfmlx6GXfHi/r7prI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792174425; c=relaxed/simple;
	bh=Mymbohpt0Y+5l/brtV0gTau6kwhogaDOjohzEf2vrSs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HMyLix7a5JBEnxzBClDrI4SvPXHivSpkjUmAtFrdZELCQCMV0UuIM6K7+YgXwOWqhZ6JkJSX4Tw6es7PQQsLw0f8Lpxz4K83EJlLt2AKfCHu11aP29B/Kk6GQrVUtmSVgqNadktFTT5iPu7pyHutlH2QFbkO2rVuIdZtyzgCQtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=uY0TGkfG; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=5C8Je9ya; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="uY0TGkfG";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="5C8Je9ya"
Received: from pps.filterd (m0167077.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69GGXsKo590834
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2026 14:13:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=N4Ej
	B4p+cD9UvTg3xutzvmaxfts/TMjZMsHJnNN26iw=; b=uY0TGkfGA4i9k5R4C8XH
	9et4ZxQ7tqieqmiBbDvrWTQIxpMAMSu3lPo/QMnglnWQrdkcmAoI1Rk2ywj5PvB/
	otD8wPGG8p8t1BZAbbYJQM0Ht+ZdkV7xD9JCMVkXCzt1/AwjlCDWu1kHIKTU+qUA
	L5YkLNQ+WLH3nYsRbZ2KGqpJZFoICwg6mxwyoGH5FlliDL0UmzVSpoMkgNKe5Lkf
	yYmSKWZlhbX34M0N8jEpmjLc+Y+Svnvr3d55nCtDMxzb+Ux31qksc2fWvPSURSJB
	0eVENl8TxmNvJz6Ri+x0bS+P4fF9MVVTKjmYDNOObzWsqImkc1stM9Aommcoy+X0
	Ag==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4hbhuauvj1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2026 14:13:43 -0400 (EDT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-5338974c0ceso4837891cf.0
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2026 11:13:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1792174422; x=1792779222; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=N4EjB4p+cD9UvTg3xutzvmaxfts/TMjZMsHJnNN26iw=;
        b=5C8Je9ya9EZLpIy4ADeGS45xqKoPRkeuF3MKDXdpqFPKhKxMkYNpcApGhL3WFPECkR
         W98oAh8rJPFU4JtGPGNlQQXyzyYL5rFHq3i8O9kIq7CEUaju8+ox3O3ZJqr625vcWa8u
         fJ6BVfGNqUX8O32kbgW65SEtLvd8jsuC7/86HLwDFRhKTCsqwJUIptpmfpC2HFwQ9rAR
         HAK3nG60AEYbCgx1d1Lhy0KoKBtr+Ac69b6FRdom7aYWxzZqYTA5OKL037gg03dBdcNl
         pYT19flD6k8jCQJ2AtpARvC529/jQzETz+UlFpAPyNiaNKiZ2lrf/aEhODBn4ClxGhNH
         3evQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792174422; x=1792779222;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=N4EjB4p+cD9UvTg3xutzvmaxfts/TMjZMsHJnNN26iw=;
        b=AjopSyc0eImdG/EoIlJGVOGUWmAXB4Ku2imVIM6MYC/h9uOdPXR1dBqyv7gRUhCN5Q
         MC2G5+eqZkCVhrqfu3+xgYJGuwUZMPX1MJxliZRt9xMu8421LpmjCRmCUSm1c948rpcD
         77ov7Dra+8qpFI2L+VMpMvwNrIAz/Hv57UcZxjujX2SHtoGWGYIGvsp2iNQ1UYTdLK90
         HOPC4xEzD2APvMLAE1mi+pAIOIl0dZ8HQkeAaCB9qeheiBVVPHTfQ5JgTaKEigvhiBar
         2IBu+N4Fc8sa5duK610D22h+yy7JEULV4JyQZGeAuAC/Bn6HubHz3uQQHMAP4GhzLEWE
         Qh5w==
X-Forwarded-Encrypted: i=1; AKwUvBxFGkiaXKcwqJmi0acTpyGB0BJMaSWv599VTzFSm7Rbi+yTDz6jr3c7gzpeqhzlZ1X2sf+sTyvdwo1BOQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYIWhV8/Jusww+6TUw3fQ2pUS4PpmLg/m7wy45Z4yC2HWARah90U
	BnRfmt4/97Lk17bhHrJ5m1489XuA79dhtJv6Nn+kOOgjTGikYZ/1OmP0iro6k/WveWCtRHBfRdP
	zSrg4UyE73L/lU7pM80s2FVcIkeFeU7BjGtHuveZSIMTEY61U1aES4hfWnPK7
X-Gm-Gg: AYBFou38UwU55BpkMl7DvqXR1Mn3koCALfehi142/VheqWMTJEv4yWTP/mSUtVOi1Xm
	/T5o3VxnpdSu2NYvXt1ARopYeiQIWDMucHFHBziw43Adet1+ROGESSwwmEYhMbZRJ/5Vv0R2zm/
	uiG8NOD+xflWMGAWQcpkGEnADX2iJ3OTNhStm5f/YlR/RWqsrB19rNb9qgJ3XGTwZOmwHBdb7Ff
	cohcdO//NCiExreBES/2jOg2jYMaVJg/26PWVvc5jWqRSMeFw22mfGuMp/DdUkCPz5jkxNDyZXT
	YwmMwXLUQhh+2jmGpvlTfGtABhWgW1le/r420acsESpcBoEITpQ0QndrOf9u8aRioWVfqqim36R
	pvdBZVh1UcQx15wsX6IaytdXbmJNOl37bjDpJ/R4rpRUYnop2
X-Received: by 2002:a05:622a:488d:b0:535:b57f:8045 with SMTP id d75a77b69052e-536460744a9mr4177471cf.51.1792174422592;
        Fri, 16 Oct 2026 11:13:42 -0700 (PDT)
X-Received: by 2002:a05:622a:488d:b0:535:b57f:8045 with SMTP id d75a77b69052e-536460744a9mr4176951cf.51.1792174422051;
        Fri, 16 Oct 2026 11:13:42 -0700 (PDT)
Received: from [10.207.9.0] (nat-128-59-178-241.net.columbia.edu. [128.59.178.241])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5362a8e5831sm29040951cf.10.2026.10.16.11.13.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Oct 2026 11:13:41 -0700 (PDT)
Message-ID: <46a68d1c-85a4-4e1a-ae85-80d0148e93de@columbia.edu>
Date: Fri, 16 Oct 2026 14:13:41 -0400
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/19] btrfs: remove the v1 space cache
To: dsterba@suse.cz
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20261015-btrfs-remove-v1-space-cache-v5-0-6b31347d9998@columbia.edu>
 <20261016171411.GB1310987@suse.cz>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <20261016171411.GB1310987@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: ag3GRBBFvRh31ShvXZT9gB-BVediFFBX
X-Authority-Analysis: v=2.4 cv=LbSpeTfi c=1 sm=1 tr=0 ts=6ad26957 cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=4lNGE6/ihKpdiDSMgFMHRw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=QOCMdifcju39GKoXhKua:22
 a=nhTHtjtXtYO63iGQC_kA:9 a=QEXdDO2ut3YA:10 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDA3MiBTYWx0ZWRfX7HTenqjywPCh
 IdX6gQ9dmNoNfSfDFohRDLUuFT1fCgZ0NOsJScmf8pzhKwnBRll2Ydr76LzafA512uR/SjhCwWC
 Ox+5wqJ0vYMER/Ceb+DyP0zv+V5jJE0HDzuRFJnSJHcMQUacjTl5
X-Proofpoint-GUID: ag3GRBBFvRh31ShvXZT9gB-BVediFFBX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDA3MiBTYWx0ZWRfXzey/mjsPVfF4
 a0011gm36t5wvdOwmtuIitP9IACyQxDtpVwaMpG5dGDGaRGFLFbmHZH2tnX/EIaxgblBmP8ea8o
 R4Hw/m1D2MAzG9U31teJKHTIkiDIioHjul3uUSiDGXm/JMNUxIGW/pTsyhz6SK9CAtrK4lExBoD
 6KRBGaIRv6Y10/gZhVMkdO3K/1rxTapuNm8tSUmfKkkXPjh9VR/kALfNpu/cldLrg9Mu111cWDv
 e9V7Zm6tac7rmLSODsy3pNy3fWjagoVB+kSjXtgzSJzQboBR9mtn9G170juYLaaSxhJwcztNVB/
 SjnD25NzmCI/lEw0xE9z2uQlfabHDA8jW/L2K603jJF4WdwF4kc52Mk5YBmaHXlIKbHhK1Stl5G
 W2jrkHaxqfV1xLgDJBSDS8W6kYeqygryCu+ZE3CLEckv7bb1cWQj5kSAsk/kSj3O7jE/y8rEpsL
 hNyaCve7LY0NkF9saxw==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11937
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=10 bulkscore=10 lowpriorityscore=10
 phishscore=0 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610160072

On 10/16/26 1:14 PM, David Sterba wrote:
>
> Thanks for the update, I've moved the patchset to for-next. Current plan
> is to send it as a separate pull request for 7.4.
> 

Sounds good, thank you!
