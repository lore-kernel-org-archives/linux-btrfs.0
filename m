Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70D75565105
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Oct 2026 18:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792000808; cv=none; b=rApj1kc8/4Z5c85VENRBTaOQTyUgRoyxrjbeRXRd6WaCOCISptD+c6lHgOVAvwehxyNqRdfAVOJvsBu2REyRfpUpn4SmhR2+FPnt0OJweBKPAwF89QFmstXiTk4ba8Bnv09+6cqI1tVObrC0ZQ6I/4+aF93BW+EhHmf8z7g/CqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792000808; c=relaxed/simple;
	bh=SnnbpgzsDV974jbRJz0lX+Is3nTo81dEnnsUYCzxTLc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f28rWrAFyT5wVulNO7omkSbBoqombwA12yLGykOAFIE4dX8LOqM6iM5T9adglfaj44pn0wi1lHvtnHrk3doyHeT9CqdEB0TEjcU5f77WAHxN9/o8xVPiEfgUNuXoSjdeFDkxRNBTWjkJCRsqUVnSTY3+oYMDRkp1STFVuh7rVGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=s7uGOUb3; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=HuSRMH4q; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="s7uGOUb3";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="HuSRMH4q"
Received: from pps.filterd (m0167077.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69EHNqFo2921916
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Oct 2026 14:00:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=CEcN
	BxFn1YRqFoXuxQm8S+kMuXOXL2RaXN5t9JDLXWg=; b=s7uGOUb3yG4+027fLEGd
	cSD7h7i5r4uusPq29VaE1jgnezTq3aNve3p+UoUgYOc3/uIJgk8INUtvmjBFgkE7
	egO4tRrrGw4J3I7my4flAXCk7b5g5zSFo+sWdXKW86LHa3t2RZ9nUD/eF2Wmvjyt
	q6BU2N7HhYomrksKrFQK9zjLN9LYD/7lh5nDRbAR6DSwFBMQw6Z7GN3rSGSz5D1i
	e1bCE3UqVCHRGZTsywgfw+ZKYlybxwU6w7XroPgtQzdVme6smkLw7GJKMew7UHZL
	t+J28OUE9GMapKif40nSC/QfeSLxTAB+qtRkh5lrWXiuBiRGUdNLCFy4kOshKZdm
	QQ==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4ha6c7c5gu-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Oct 2026 14:00:06 -0400 (EDT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-5358515b4easo82009151cf.0
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Oct 2026 11:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1792000806; x=1792605606; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CEcNBxFn1YRqFoXuxQm8S+kMuXOXL2RaXN5t9JDLXWg=;
        b=HuSRMH4qywJihDf3VfBWKSRR5VgBfY00NNj1d05chxoU4nVH5LqOGDxFc4gc2TkgNI
         XazHkoaTwII99cvKG/dDxLxh61Z4KnmCQ8zgJHELMFmxlEnjS2o51+iHNIlNvQN7iMyu
         iQSKmAnbJZNrGltySt551npeBSXA2m4BHRUd33+beZWR+WbKVvwny5ToEW86ZU81MVL5
         sSALhZyAeuNfDkyFt+54EaAYaTnIDAuj1l5CQGFkJymi63odM92PhwW4wkYHJ2ZP4G2u
         nJSIoKLMgtj4+RyRog5aA/IajdoywCGxtjk9e3xpdlUqQ5H04cyemVzh3bUmXYvwp58v
         Bvpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792000806; x=1792605606;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CEcNBxFn1YRqFoXuxQm8S+kMuXOXL2RaXN5t9JDLXWg=;
        b=qfubszulAj2Mx7gVDnKtsyN/jx0qB/0YRZ52aw8huc1REJKosViYCFcE2f1++Y6GV+
         ZXHFP9zR5YnnECXsZpJ10utEGAuEsxmrEJ2rMuUEkR5MLCvOYXr8Fv0q3PQofLgJWFQZ
         4/5zzrVOF/DHa5f6wDcD0OCzdCw9+mhWvlTtdAdW8pUFlTQ6WaccdLmAdwIHPanEncj2
         AP5OUAPbi5ALYQL3DxFjw4iJUzVfIngPsDKEfZTNT8wXZRVQ4cvzpr8sJc1elAubGNOL
         JIGSTws+mD5qc7D9FsY2kT/1b1oX3jgtdN2RoJpxK7EEh3qpyT5KjsYZFixpTth8rOH8
         Ha2g==
X-Forwarded-Encrypted: i=1; AKwUvBz7QRg09JlaIIcENm2zjoblMZcB+yOQ483yoW/Zjan1gVuy8T1+aLrc1+kAVwRPWAkru21uh4C3k1AWig==@vger.kernel.org
X-Gm-Message-State: AFq9FYLpNNmF9PXE/Dw86dvsyHDda9FEV9mdhz/Hnvg0Zmr2/AANB4EH
	NAM8qd569zYwhBVhbX6+ngc0HYkVhDisfMLumyWBco1M93uNj9U8HcS8229WnGo/938yfA9mD6s
	aH5fMcy4JMMHol1L1xJDnknhlUuj83j33l2WtdNkgr/3OtIapUvc6ggNm4pri
X-Gm-Gg: AYBFou1GdOwU1VdYAJ9L+cSLh9EZW32Wr6kiiyjyTTxEUUFT0+FInN9LPp+9BZtwz65
	H9SHm+P7sWG/jg8ebiI8SDAdxesaFvw2MhKhIsjSCAi+gMy9DbNpP74eV6TMH/XCI4hCxqd6Tud
	8134S30s4wUu5ddLZhQoLh76VbaCNVXhFkaWSUD4pueuHDV2ZhMenkq0NDYFyF3IzEL/LWwesPt
	r9PobFzL3B8cTKR5S+d3JGqrDFCu2FaIKM51aOf1J0TB60zjjDqcKvlEFba0go/pipZnLd/xjRT
	spxA0OG4gsbs5ddkHDrxuuC0cgxeoloqYos8Hss+YuXANhzI0kyX01Tw/8My+G+HO3nY9tY0uSJ
	WQ1ua2fBBkldvn4tG0Fw1Ayxpfa5ETG17loN9rdi1tC27FIfz
X-Received: by 2002:a05:622a:428b:b0:533:3911:f504 with SMTP id d75a77b69052e-5359fdf2526mr271506441cf.57.1792000805564;
        Wed, 14 Oct 2026 11:00:05 -0700 (PDT)
X-Received: by 2002:a05:622a:428b:b0:533:3911:f504 with SMTP id d75a77b69052e-5359fdf2526mr271505941cf.57.1792000804977;
        Wed, 14 Oct 2026 11:00:04 -0700 (PDT)
Received: from [10.207.9.0] (nat-128-59-176-148.net.columbia.edu. [128.59.176.148])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53612830ec3sm2952541cf.27.2026.10.14.11.00.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Oct 2026 11:00:04 -0700 (PDT)
Message-ID: <7eee4fcf-1348-4d60-a1ec-cd3b76eb5904@columbia.edu>
Date: Wed, 14 Oct 2026 14:00:04 -0400
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 00/18] btrfs: remove the v1 space cache
To: dsterba@suse.cz
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20261012-btrfs-remove-v1-space-cache-v4-0-f125bd8c07f9@columbia.edu>
 <20261013122214.GA1310987@suse.cz>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <20261013122214.GA1310987@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: tcitI_4Sx_TMSiO3xX1KHVZIA9yeMqiN
X-Authority-Analysis: v=2.4 cv=G/CJgNk5 c=1 sm=1 tr=0 ts=6acfc326 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=dxtdfZqDOO0kCslK4e47hQ==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=QOCMdifcju39GKoXhKua:22
 a=TKffICSxeowAhaLLEZsA:9 a=QEXdDO2ut3YA:10 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE0MDA3MSBTYWx0ZWRfX3h8kSpFQ/COJ
 jJ1Ly+X/4EBKJ9gbg2ssyamxgSJuXB7fh5on0lAcuy2IWKYRD1IRD7BErj8MtuxyaJAJ6iRv+eC
 qf734RYFgE9UmcMkHjq+KTu5E30uBsBAXD1N2IN5AmQwhT5htHPY
X-Proofpoint-GUID: tcitI_4Sx_TMSiO3xX1KHVZIA9yeMqiN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE0MDA3MSBTYWx0ZWRfXx+mtXNG+NdWc
 rZcrTfvo3Dzu4SZXibyM2ihweaH7QgWU5rjFOd3pB6g6GsfOwzHXIsQ4JbT9uj6Urc6PPOb88PL
 D07Chvk7wettDxxsIytPNaydv7ildXqHbJhiWDVKZDhXQc3Jf0KMygUNsA8q4J7DqZjq9fxeuxB
 17ulO/pA96nEZZ3YHG29esssKxIJpecZ8wCNjVU3vAxNopNUkSlspjZsrGjgKRhHXqJaXz7huzt
 q/Fm0UUAZLFw42vZ9PRxjRt120yw8iO/qg49O3ekfpVrpsYT5sxWiN1v/fjdtjwRJpnvwNk1jsO
 88EnL4GvBUp7qTh3bpOnlEfk8Q21hLCbaHX5GY74rGsvxO3rK0I3brBSXvHb5QJNKJugi+plvfL
 /wDadndXknlgebRjTgXPQWe89hmGjiX4IpSWzR38iWnWWuVTOtu44qs7VK3MHg/yhfbXY+xDYis
 PRgkA/nHZMNma08dnqg==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11935
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 adultscore=0 phishscore=0 spamscore=0 priorityscore=1501
 clxscore=1015 bulkscore=10 lowpriorityscore=10 malwarescore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610140071

On 10/13/26 8:22 AM, David Sterba wrote:
> 
> Thanks, unfortunatelly this did not make it into the 7.4 pull as the
> freeze was yesterday and I was not able to process the v3 last week.
> The v4 still has some issues reported by sashiko. It could be still
> possible to send that separately as 2nd pull to 7.4 because the code has
> been in linux-next, small fixups would be possible, and it's code
> removal.
> 

No problem. I took a look at the Sashiko feedback. It looks like a
rare pre-existing issue, with the fix being to change the `if (truncate)`
to `if (truncate && !ret)`. I can prepend a standalone fix for this at the
start of the series and respin.

Thanks,
Tal
