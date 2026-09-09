Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E53F33115BC
	for <linux-btrfs@vger.kernel.org>; Wed,  9 Sep 2026 04:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788927921; cv=none; b=slYtPFNBcSqpx/ai62toXBU7IZSZu5WnBFfya8AAQr+OhkUJx1HY1msD8fJ9eq/CD9KYCbwIRhfA9Wo32V6ZhDoihqq+IPko81rDfQJSzpd95/JwwEW9ZN+UDFp/1qCLCeoV+ap5D+fuCqAEMeATmxwTwhzRezSeCrYL5xCRXIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788927921; c=relaxed/simple;
	bh=KO8yXtxYH2MCUHZPuhwewSO5ZtrP1TPBrP4qFC82Ig4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LHvVkfbTRNe4oHT1UpHNqLVfbe6blGeUQZbmwNx4p7udwu2/ItlztsXeTOFGxycpE/H5WEDr87a64hlVvAX1Ur03f0pxQ+6q9yy3C93/F1Lf/uvW5UdrAv2HjB2HC0sLqMlQWWXuOmIecRovASJUITGtMtDg0LvJ/9REglur+1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=UzXmIBNa; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=bvJ40Zcs; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="UzXmIBNa";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="bvJ40Zcs"
Received: from pps.filterd (m0499198.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6893F8Vi3566389
	for <linux-btrfs@vger.kernel.org>; Wed, 9 Sep 2026 00:25:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=iSNP
	tExQYSX+MMrAE17ZPKsKoZbCJiQGDmfeE4bJ21M=; b=UzXmIBNaP17M3phBLH4u
	tqDhRBGYAP/2bgl7VUEXw1lgXLTIeSrMhhgJB1Ar8YnRGHSdztm7pBlTEm1HYW+s
	IsbLT2p3bw4fgjc5V99gjjzNqW+py0DG1ub+pHuaC2wgQPC72rqReWTOgqcgDSSf
	yFvZESHRbgItqX3K+JFQtMN68q3PGSKGqNcyyvYAi57+A8CbX2K0cdVP5+/BHsLh
	pxefySrsX9XFtEWh8ECksYAJvQzzvPrn0zfeVebhOTGB1c/Hhqmxm2ICPKbU3Qsy
	eFyv7MuDLamVZkt6ByJmDysEHFnDtipYUPktarnvKwe53F1+9fCqmVm6f8WXScQ7
	Tg==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4gjrmrb842-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Wed, 09 Sep 2026 00:25:12 -0400 (EDT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-9390a2c895bso1091181785a.0
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Sep 2026 21:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788927911; x=1789532711; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iSNPtExQYSX+MMrAE17ZPKsKoZbCJiQGDmfeE4bJ21M=;
        b=bvJ40ZcsotjM3i74cLil0pcJ8y7txo5qZQ19DfsJsIBmZuQnI5eAnZ/Smv50vZO96N
         vGJOznfmDSvY02b3Xgnlp5ePd7sUEzByFxs208Y1m/gCz4/KQCK4FqCbRxSXdcq+zBPH
         xc0D4qksd2I68qdoPF3INhM9za0apilDaX1VQ5qUVRS+QO8vfDMVucjJEDQzTXXC0F7A
         J8/Br7Q8kUGxmsyAoLCshNF2irdnpOMlACnu+mksT/l6WW+WIkqEZsFNiMA+3JZZ3nNl
         +qXGw3xqwD+Mt3ncJYVD5kF7Mbal47Rrc5bEmhYEo3HH0uH4eNIxAqG4sBrvNDoCj1Ek
         g/PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788927911; x=1789532711;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iSNPtExQYSX+MMrAE17ZPKsKoZbCJiQGDmfeE4bJ21M=;
        b=HzqbD8htbkllhJS5bJ8gC7SS6Hcfl7tuYlx5x7ormFKwg7uUkTlMYe3qCaRjgzx3/K
         5iAQdHBBbcu5QM4w8lKSRULlzs4tDACC2tCO31GqT2EwvCePDvnFMmoTrHrr+ltrAGIW
         Qbr0mx0MCBEYxwVIclvJ18p9QuzELiDDWhxOIJ2wtSyapsEkh9sBlh/YF3L1wfg5n1O7
         HLqA7CpbINOvZn0PjY1lopk6e4P89uHOlcZq9wgS2GVF5W11NInBnsSXX0Rq5vpO3EZu
         oZPJfi/rx7jdOSBWJe0y7khOBVxqQmToW3gmlqRSupVXBQw9IGbhUIfMKJ9BqHhO06F8
         hc/w==
X-Forwarded-Encrypted: i=1; AKwUvBxFd5NSvZc9D6A45QboZOGi1RDgSgt9qbmuxl5Dwk8N+Yg96YRMoy9ZCvcsLE9DMJ7HLA/nwuYLC7QuTw==@vger.kernel.org
X-Gm-Message-State: AFuF++k9XeyP92vZ31C2XpYWMaH5h95w2EIo0Zp00XYTdkAqw14cWo6t
	vnIxRMw1tcYOlzTreMf9wFdbIyemG3+O4EjpmSh/4kcrAOYro4HUrRo6B5aLOUQHm5WJqgk58ry
	QTKM5UQDX/8b96d+qw8TzgsQsbD0gP/11ptXjwXuMuL1rqC1VapmNJJyvsgQo
X-Gm-Gg: AYBFou1K8DuqSLbJCsqPakeJS/UfYYjx9MMq+Hvyc6iYTbPJ+oePyxEhEEQS5cSMQ18
	UA6l6C2FPbxNuZf7giLeco9YdQeV6fpqBjRbicJHbWmVAtLT3BKDK5Jr3sQM3Fot/tDN6CEGVMB
	VbNFtW+KVRIZDigRH07Z436smR6Bo82b3Ia5xOCIpowKOt/s9aG/xWXOccctMHhAMWlQ4is/SIO
	4be2/5zOvGDWK3jbEwM+lWCAycgY6eLp6OodQdMynxutNKdbGV2wGRLSxPalz090+3EO0h/IMm6
	mLEqSRx/RA1slOKahEAKXGeobee9Jk8tzkMLuRiwb+j63dVMnUF166O/nwd9twJNHOhusztdtax
	ORhyH/EWKGsgJLp+N8fDy5qPR/SReWSbwMzFIJtBvVm/6usVR6njyAOk=
X-Received: by 2002:a05:620a:4494:b0:937:7836:1501 with SMTP id af79cd13be357-93980599a88mr3451980585a.10.1788927911612;
        Tue, 08 Sep 2026 21:25:11 -0700 (PDT)
X-Received: by 2002:a05:620a:4494:b0:937:7836:1501 with SMTP id af79cd13be357-93980599a88mr3451978385a.10.1788927911180;
        Tue, 08 Sep 2026 21:25:11 -0700 (PDT)
Received: from [192.168.1.62] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-939aff54ae0sm599275785a.8.2026.09.08.21.25.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2026 21:25:10 -0700 (PDT)
Message-ID: <f5eea2fd-61d7-4cba-bd0d-f6d454b8c221@columbia.edu>
Date: Wed, 9 Sep 2026 00:25:10 -0400
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/7] btrfs: convert heuristic_collect_sample() to use
 folios
To: dsterba@suse.cz
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260907-btrfs-folio-conversions-v2-0-b5fe79f7607b@columbia.edu>
 <20260907-btrfs-folio-conversions-v2-5-b5fe79f7607b@columbia.edu>
 <20260909012633.GI9053@suse.cz>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <20260909012633.GI9053@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA5MDA0OCBTYWx0ZWRfX0VzICqWo+J7c
 xE9niFRtYfWlcXvlz5IHefDu7cglIkA2U5n5wv+iNN0p/dBfP5arKVwtO/BDhZwBMCeBM7gm1UN
 deu1ITDFGDCSxu3wo5QbecsqfkUW6Ylg3Mh/1JiV8lc/7YjFXR1D
X-Authority-Analysis: v=2.4 cv=BaXoFLt2 c=1 sm=1 tr=0 ts=6aa0dfa8 cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=BpGzv1V74M3SfeTrGa8v:22
 a=iox4zFpeAAAA:8 a=OO2bWSZ2hmC-76FcYzMA:9 a=QEXdDO2ut3YA:10
 a=NFOGd7dJGGMPyQGDc5-O:22 a=WzC6qhA0u3u7Ye7llzcV:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA5MDA0OCBTYWx0ZWRfX8Dy/U93lheQ0
 aIQlqrJPqAumkwlmlyqIBB9J+A+KjhXNDP7UPpzqPvypXE2LK6KZeXpsZlzmH9VTjC7qBcyT5GH
 8tVC9nJyZ5XAzCZkdD0MYBoFMcwg10Iwab7YSWfIw00xwwtyyRyM4wjXG/dCTkqmVLZz+0bFAOL
 JYELg4j7XR/BZZZYDWJX0QusIyKMpWDO702DJF71Kt3W+5dmd99+5xkZezEFbPvUvXnJ6GAfJOC
 WkUXtWlO0OYg4+1nZhLcdfQjjcLY6qrHwd7KDX4fy4HgcxlPEtZINJt9IwuIPOEsmFRs7fa0hvf
 eGCn3K40HmYkzGH/Kfn02dNVEdfoKJgBT6BScS5U/cMGuwZUtV6aVgEaTlaQnUBRH5jJhN4ba8+
 lwJFPATkKF3e+maZhhkkLTrtosVclGXEj29HuKDFUdTcNF7IU9ZI6anmZ8Y4aKoWkQum3MUqv+O
 WSorWDpeGFnQ7p+nIRw==
X-Proofpoint-ORIG-GUID: 7IYTVwefzsxlANXUiZAaKvuAQ9hqA3KE
X-Proofpoint-GUID: 7IYTVwefzsxlANXUiZAaKvuAQ9hqA3KE
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11900
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 adultscore=0 impostorscore=10 suspectscore=0
 malwarescore=0 lowpriorityscore=10 phishscore=0 bulkscore=10 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609090048

On 9/9/26 4:26 AM, David Sterba wrote:
> On Mon, Sep 07, 2026 at 04:19:59PM -0400, Tal Zussman wrote:
>> Convert the sampling loop to folios. This removes the last caller of
>> find_get_page() in btrfs and saves a call to compound_head() per sampled
>> page. Document that the lookup is not supposed to fail with an ASSERT().
>> 
>> Reviewed-by: Qu Wenruo <wqu@suse.com>
>> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
>> ---
>>  fs/btrfs/compression.c | 10 ++++++----
>>  1 file changed, 6 insertions(+), 4 deletions(-)
>> 
>> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
>> index 979b2ffbd8fc..fa8b92592321 100644
>> --- a/fs/btrfs/compression.c
>> +++ b/fs/btrfs/compression.c
>> @@ -1488,7 +1488,7 @@ static bool sample_repeated_patterns(struct heuristic_ws *ws)
>>  static void heuristic_collect_sample(struct inode *inode, u64 start, u64 end,
>>  				     struct heuristic_ws *ws)
>>  {
>> -	struct page *page;
>> +	struct folio *folio;
>>  	pgoff_t index, index_end;
>>  	u32 i, curr_sample_pos;
>>  	u8 *in_data;
>> @@ -1514,8 +1514,10 @@ static void heuristic_collect_sample(struct inode *inode, u64 start, u64 end,
>>  
>>  	curr_sample_pos = 0;
>>  	while (index < index_end) {
>> -		page = find_get_page(inode->i_mapping, index);
>> -		in_data = kmap_local_page(page);
>> +		folio = filemap_get_folio(inode->i_mapping, index);
>> +		ASSERT(!IS_ERR(folio));
>> +		in_data = kmap_local_folio(folio,
>> +				offset_in_folio(folio, (u64)index << PAGE_SHIFT));
> 
> It would be better to avoid the cast, this is source of subtle errors so
> we try to avoid that. With demise of 32bit architectures it's less of a
> problem because index (pgoff_t) is 64 bit type but still.
> 
> Please insert a patch that changes the type of index and index_end to
> u64, we initialize them from a u64 type anyway and we know the value
> fits to pgoff_t (as argument to filemap_get_folio()).
> 

Makes sense, will do.

