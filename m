Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC682389452
	for <linux-btrfs@vger.kernel.org>; Wed,  9 Sep 2026 17:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788975062; cv=none; b=hIFI2NLxEWLn8l1zOWhMoTwzrcAq6f9Wv6TsOhMANPvy8+dbVp0Rs91Q2BA7ck91KVv2adbEyS90jvrT/Xl1R7WcKlkA8PoBZNfOe4+5v7CzLfikGz5AwR8CKLbp96mffy/N0cmxfyscBWA75a+96vXDiZ6tDuk79Y/qd0GeSpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788975062; c=relaxed/simple;
	bh=7wgB8LKz5jCOpkcEQsOMXq5SneV0WqtBZHXILSLMHtc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QGMFL3E9HVREpplm7n5WFUbVprKXn/yeS3QMrPnDXJAfo7nSDAoXyD0SmRVnwqE5fAP5MOBQXvV7BSnVkfxZyLfgZ/cFwchM+1gn62xlvoY4VLu85cGlBr1r7G+Fj+Kynhv1qpNQKOkCtqYjpH60qgWKQs/kN7cUkZrlnzebYSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=KoQ37XJb; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=B5tLEdTh; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="KoQ37XJb";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="B5tLEdTh"
Received: from pps.filterd (m0499199.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 689HS6px426631
	for <linux-btrfs@vger.kernel.org>; Wed, 9 Sep 2026 13:30:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=AAj9
	+Q3qh/LD3sL2Z6dNf/Zk4ftasodLwoHwWP4PwsA=; b=KoQ37XJbw+9Ia8qZX3Y3
	Gxy4sFAbira3lDq+/ja28WTMAB8meJ0Ji7DP4hG5H66c+C2HJLUHEWiNJUP76+da
	9v0k7B5zZTNKhGROzKTB8QwJGpt2S3xrgeBZ93CZD/HLD4+Sv5Eu8pXQ81+kiRCt
	zrheAdat9HhucfbOevAwg4rn+3aIDW6XkZ04yx8uoFNl2ELJyTcE51TGmNI65r3V
	hGiDcPk3Caj5bMRk4Jq+P9z7cNZ8RgSj6zCw7fmDLz1cRhFvWZFMBbIHoMTwaGwi
	dQPXXhbypgVJ0H4b//bnjB4qbmnhVraVf1X7sgBTgkm76hRapk9RXYPeNYqlZdIG
	mA==
Received: from mail-yx1-f72.google.com (mail-yx1-f72.google.com [74.125.224.72])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gk94yhysx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Wed, 09 Sep 2026 13:30:58 -0400 (EDT)
Received: by mail-yx1-f72.google.com with SMTP id 956f58d0204a3-66988049306so8089117d50.1
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Sep 2026 10:30:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788975057; x=1789579857; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AAj9+Q3qh/LD3sL2Z6dNf/Zk4ftasodLwoHwWP4PwsA=;
        b=B5tLEdThI6qR6/ej+RWs/HR7swmAmVnOXcbrvjbHcRWhnuf0+ZzdIwQVMZyCcUfOGV
         bHOMGNMkgBnRoi/lQO8pHwJ1CtGOVewMJRn23L7X4JTF/cyl/BtbSysJjaMJtrhx+0VZ
         rUN0TaghIvrUMssz2/OtnVIjOG1tWnXMBliN6AVXrPUPvvdngnZyDj6BKgtjMmLT0UQx
         Hi2y1nDk5lI8GCPWEyfTP16hbb0FvXuDJ0UBIjbimOvZUYdhkX3lnbtwHa02nsHz52eE
         fQiql9lWDfJJz3LYP1OxeuNKuEf2Nk5OTEQI8M3e53tNv4QMJ8ztjZnIcGhZxxvFrJRo
         764g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788975057; x=1789579857;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AAj9+Q3qh/LD3sL2Z6dNf/Zk4ftasodLwoHwWP4PwsA=;
        b=WeS/b3aR5Yu1pBmwAMqDt+7VtbTBLP2GezHSz4re9MA9Eg365rbJPkMuRfd6SUdScA
         TatSh9na3CnFJ2P99OonwILeYcFBc4xH9sUIQ2YqH1f+ulA+1pCiWaQFBaBzVJSNooMB
         5NTvhGOx5aC7vNnOcUBjFRU1hJVrbVbG2Oq2+1P7lVV2HLkwC6jBe8f31D+1/fvzEOLt
         qwjTBTSrTO2SEbyyitxZOJ1JQkGLQJaqXPOIDWuaWUbL37GDAqCAIkM45a1bh256Io/C
         h1gMQTEcKw4pog4WG7kORC7R2DoRvg+15wwK1XWbyAd2Uoh3kelSB1o5THpr2mo3fzd9
         BTJg==
X-Forwarded-Encrypted: i=1; AKwUvBxNYMWWpmC1C8C5b7hrv8unPE70i9fwdmmsfsxZUaRVqfPW5yTW3O4SVpP9OPZFNxDIS7oprxTRxNZGoQ==@vger.kernel.org
X-Gm-Message-State: AFuF++m2ZGbt++8SRXNdl3nbYoVVrFDEsfa+JlVmMk74RoaqSrHH9CPb
	AFipuZdMvTPgPrqyaDfOKiAYI7JHGbuy3kkPLlaEM1Bck2tALS/NCKsyl+os2w864m449fzB28z
	BEJEFMXYciU940aZWiQrFa9qBWjJSzXWJAPzduzOxTThwEOtpgFa1k8xkwepE
X-Gm-Gg: AYBFou0AKn1KAPtj9HQ04kyxp353Lpds7l+zahwBG5fD8zTn4HKdAeJGFkfKWRMYCvU
	EubhvSoFcYMSy6QN0LwNxsz6yrX93qRHKx04eq81z0BOmGPnAzQorJbQQ+Fwgn4V5PsAD2KgWgc
	TIMn5VCt9SJ0INa+ti6z3TUysBngFMiIcU+Dan4pfCvz5j3+plxB7iVojZvGJ/0HWokMQW5kfDc
	gXzaHnla7kaR/jp+Pe2AP7LcLtcDaXp+pr3VWiolHvB0iABwMfSHMmsczgsT1+8vHMrIbuXXK/J
	XlRbSZRXYFhj2gERTuPFCELJIh07QLrMZfQWfVNNA0aUoh4KUGVh0U9uaXgSmtvgj+ckGn5+MAB
	NFa1p+2/8WPyQXJbXcU3LbNAPvGiKH3kZJVchFKeQB6gWALaE4IxH
X-Received: by 2002:a05:690e:201a:b0:66f:c1bc:c08f with SMTP id 956f58d0204a3-66fc1bcc8dfmr8361882d50.87.1788975055768;
        Wed, 09 Sep 2026 10:30:55 -0700 (PDT)
X-Received: by 2002:a05:690e:201a:b0:66f:c1bc:c08f with SMTP id 956f58d0204a3-66fc1bcc8dfmr8361429d50.87.1788975054060;
        Wed, 09 Sep 2026 10:30:54 -0700 (PDT)
Received: from [10.207.49.22] (nat-128-59-176-193.net.columbia.edu. [128.59.176.193])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9104067b099sm149064586d6.28.2026.09.09.10.30.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2026 10:30:53 -0700 (PDT)
Message-ID: <69c5a700-c509-42aa-a308-0a4ed70e0dc1@columbia.edu>
Date: Wed, 9 Sep 2026 13:30:52 -0400
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/7] btrfs: convert some struct page users to folios
To: dsterba@suse.cz
Cc: Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        Chris Mason <mason@kernel.org>,
        "Matthew Wilcox (Oracle)"
 <willy@infradead.org>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260907-btrfs-folio-conversions-v2-0-b5fe79f7607b@columbia.edu>
 <f4a415f9-1e3a-4b26-a2a4-61bcc98eb39f@suse.com>
 <20260909140351.GL9053@suse.cz>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <20260909140351.GL9053@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA5MDE5NCBTYWx0ZWRfX450e9N7A/Tc7
 y+QoB4mKwMsx/ff3HKysaElbjuYReD0t6ZKCBqHw0lJyj6kjrXPLOzEJ3dPFawu+fNuAp5aLC3F
 N1+wH4ITIGHGbaVPwMLzXv72WYSpCp4YzQ8NgxCNszLsce8womwR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA5MDE5NCBTYWx0ZWRfX1m0d4lZPvWXe
 ezMkvdo6bepisBUb9dmsFnmdVWxb0s65IKbR7LPFcuS6YdSZjnt9jVGx0IqwFiPoUpzdjdMrFG5
 Qqd4mbyPxPaUjJ24M0+Shcc8eHvM1jL8khhsw51EyPJE+KsfA1UWX73JNSckLqhg4RuI0waNr+/
 PBVsbSPHizXSaMekZgfEwdpLKXKzL3JW2zn8CiDn/1pFKryPXz01AuYprhNSIGk39t5oabpUTVE
 zC1DtK6dRcIutjiGpXpwRHXNCaKCeM84Jm+o/sChXZ7AkqdFV9wJNeQV+wQtOx/yaXQ5quZYDye
 cBrsFKtEAv+amC8R2pme+hpAnFt6qKTyzivjVkvTa0pOZW2EI17serklYMGqm0C6R3myc/dGBkd
 5OlsIX3a+7OqdU2yMJPWSmbZkrqTdfRev5QORQeRkzYTaJjYpb9M+Ax/7KjaufDKBQ26HotdooB
 /pRfIusbEV4RQrKulHA==
X-Authority-Analysis: v=2.4 cv=aKXAb79m c=1 sm=1 tr=0 ts=6aa197d2 cx=c_pps
 a=VEzVgl358Dq0xwHDEbsOzA==:117 a=fJxgZNdXt3opHMdyAp+FXA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=G--0XuH5328wxK7v7Suf:22
 a=VwQbUJbxAAAA:8 a=5BRWRVQc9f5d6B_jiFgA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=uujmmnXaIg8lM0-o0HFK:22
X-Proofpoint-ORIG-GUID: 15W_qRYHwnldCm6wluPjBxopfe1N1nv4
X-Proofpoint-GUID: 15W_qRYHwnldCm6wluPjBxopfe1N1nv4
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11900
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 suspectscore=0 clxscore=1015 phishscore=0 malwarescore=0
 lowpriorityscore=10 spamscore=0 adultscore=0 bulkscore=10 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609090194

On 9/9/26 5:03 PM, David Sterba wrote:
> On Wed, Sep 09, 2026 at 03:40:47PM +0930, Qu Wenruo wrote:
>> 
>> 
>> 在 2026/9/8 05:49, Tal Zussman 写道:
>> > This series converts three areas of btrfs that still use struct page:
>> > 
>> > 1. The extent-io tests. test_find_delalloc() uses the page APIs, and the
>> >     extent buffer memory checks assume one page per folio.
>> > 
>> > 2. Compression. btrfs_compr_pool_scan() walks the folio pool as struct
>> >     page, the last use of page->lru in btrfs, and the heuristic sampler
>> >     is the last caller of find_get_page().
>> > 
>> > 3. Super block reads. btrfs_read_disk_super() and the zoned super block
>> >     log comparison are the last page cache lookups by page in btrfs.
>> > 
>> > Tested with KASAN, lockdep, DEBUG_VM and the btrfs selftests enabled.
>> > xfstests' compress group under compress=zstd and the btrfs group both
>> > pass.
>> 
>> Now pushed to for-next branch.
> 
> Tal, please send the cast removal I asked for in patch 5 separately. Thanks.
> 

Done: https://lore.kernel.org/linux-btrfs/20260909-btrfs-heuristic-u64-index-v1-1-8606b3c89807@columbia.edu/T/#u
