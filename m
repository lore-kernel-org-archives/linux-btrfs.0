Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC3A30B51E
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Jul 2026 01:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783388351; cv=none; b=uvKkY80Weq1MjoIe3X68cTpEQMDFPqXeuhzR1kYLm0wi84XW8wPi5a9byRB5ZuK+qrttumhxK3VzSgAYtBxc36RDlgHlyYBuwL5nmgAKewEeIdRUdumO1FUi/ko6s4Sinsuh+2TBJAc4bjXsjkqEEARErWHrhyJb8KwoiFcQRKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783388351; c=relaxed/simple;
	bh=kKtGHeDARbgvLuW2p34rnlkJaB6HjBJuQ4ldrsFubBc=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=U6c3lMKE9j0y9jdTfcx5CltF1Eih+CoAvj4sHIU3ed9JolOuycb3SBxghU4452ClSEedEb5JfZLBexrVe31pPH9s3JcddYxm55fpgxTCrK/P170SG3fkKAZjQAHHSDDXexC2w9mVYgDUWTNeVNJ1iJsx1E57wan3ROOIAxBce3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=DXlD4E/u; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="DXlD4E/u"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-493bf73ec2aso22965395e9.2
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Jul 2026 18:39:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1783388348; x=1783993148; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:to:from:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TTnGlLsg4FIpJReJjAIHVQssDKS61ITWSpUFysQv+Vg=;
        b=DXlD4E/uXQPIMz6fBpgDMx9ejZQsLAr12R26BtNY6tTbLbwEU0LDxXW4XGAVWqVPVM
         xzACQGJjxUmZAqQYOBkTGYohhzRvgEHb6RQYrDeisiFw2oqU+V3qzgIiAnjsO7+LyhA+
         g2vunHPsksoTFSnIk7AEbS+61KhVmq6/OkHMNEM0ranoPjXG9D+0jcnEfcwwbqcLZ//Y
         O38ZpLFKuDeZZtBLMXSAE2+5oyenG9QTYJfHOpmwIznfB5xeVfgjo10EW+VZAXjfeSAO
         bXZfDWFHoiUNQIphzRoqQza2EGCwUK1G9HZW87Cqa0atCdhkhlx2zR6aGCDQ+6ilbgp9
         0kkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783388348; x=1783993148;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TTnGlLsg4FIpJReJjAIHVQssDKS61ITWSpUFysQv+Vg=;
        b=JmIZGHtXQrntTcVQO6VlUl5oXL23i8Yf8DDJwBNVs6yiBHuzKyqW6eoVNIR4Qnk7vo
         Cp6TdLKS4WE53kyJ93WRMOC9PZjBUBgdX4scthEJ4LeMciKENr7NZvv5EonXvZLIAhwu
         RQFv8xk+oG9JIsKjJv/Z/tRDK0HFH/w28m2ZAHkfhWS7n8IYaQzPdkJJVvbsi3YZxfUu
         p3Ubgs7AFUXxbbuyXeNHpd0L/8Mp7djtpXsYWm/+0ncwm/11JvGvWFxaSwSIoo5CWG52
         e4r9s4bnoTx3s/X9Mx3WU7l52+TQP1LNOIP4aF3UW27EykBiPzoQKgjduyYdsYyA4Gqu
         X4aQ==
X-Gm-Message-State: AOJu0Yzc5YgaD+v4vCAxEWucGQQ+hj0CKazMctYC2i158HcTpfwreDGv
	XY5ER/4cxPjeCRuTTCLAHBHhegdN5AViy/lDBaaf5pY5P8vD2EKqBjdk6vznbPRvmxtO8P758s4
	v/w54XWDnNQ==
X-Gm-Gg: AfdE7cmded2fbaCY/X9TLD7Kn7Auoph8m/XKcS7FipNOU4scIaLuyCkA9+MAWQCEZ1I
	NLMlfW84otrrBPPcNPrAEHdpUDHUwS9cepXlVCI9yXnULVY3Dj6stSnaajkNUmemnBhkdZ4hp7H
	B9O/U+cnptM7IH10rBXlv5TJQEPRzpK6v76F6VDTmMPCz6p2rrJytSkuA/Vv6p97gwEvhtv5Ko4
	GXZrPneVAcbDk2cULD7INK5iilc9iTdl42xQAAaXTYjgK7pmOu1m1UD427wy88tj3CGUZ/qdTSW
	85zBN1Bpzdiv88EhRICssJIpVsFuyOtYDwrxAIprufp/tXk0uhmOXq9UbnkY1smrFT1/Cj2vuRa
	rMejZPzy2oGfInx3BSZuaCGgwx933fFcwti59cRajnB99Wf6LgjlvC3qVlfK+oCqNcQk22b1/pK
	egHzZvfKHK/drUEpRz
X-Received: by 2002:a05:600c:1912:b0:492:4a56:690b with SMTP id 5b1f17b1804b1-493df0b4ea7mr33702515e9.35.1783388348286;
        Mon, 06 Jul 2026 18:39:08 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13b659d8da9sm2802336c88.14.2026.07.06.18.39.06
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jul 2026 18:39:07 -0700 (PDT)
Message-ID: <5185687e-8993-4736-a592-054e2b5be276@suse.com>
Date: Tue, 7 Jul 2026 11:09:03 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] btrfs: unify folio dirty flag clearing
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
References: <cover.1778131118.git.wqu@suse.com>
 <62add3b3ebcea3387c329744102bdf2f8bffda65.1778131118.git.wqu@suse.com>
Content-Language: en-US
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXVgBQkQ/lqxAAoJEMI9kfOh
 Jf6o+jIH/2KhFmyOw4XWAYbnnijuYqb/obGae8HhcJO2KIGcxbsinK+KQFTSZnkFxnbsQ+VY
 fvtWBHGt8WfHcNmfjdejmy9si2jyy8smQV2jiB60a8iqQXGmsrkuR+AM2V360oEbMF3gVvim
 2VSX2IiW9KERuhifjseNV1HLk0SHw5NnXiWh1THTqtvFFY+CwnLN2GqiMaSLF6gATW05/sEd
 V17MdI1z4+WSk7D57FlLjp50F3ow2WJtXwG8yG8d6S40dytZpH9iFuk12Sbg7lrtQxPPOIEU
 rpmZLfCNJJoZj603613w/M8EiZw6MohzikTWcFc55RLYJPBWQ+9puZtx1DopW2jOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXWBBQkQ/lrSAAoJEMI9kfOhJf6o
 cakH+QHwDszsoYvmrNq36MFGgvAHRjdlrHRBa4A1V1kzd4kOUokongcrOOgHY9yfglcvZqlJ
 qfa4l+1oxs1BvCi29psteQTtw+memmcGruKi+YHD7793zNCMtAtYidDmQ2pWaLfqSaryjlzR
 /3tBWMyvIeWZKURnZbBzWRREB7iWxEbZ014B3gICqZPDRwwitHpH8Om3eZr7ygZck6bBa4MU
 o1XgbZcspyCGqu1xF/bMAY2iCDcq6ULKQceuKkbeQ8qxvt9hVxJC2W3lHq8dlK1pkHPDg9wO
 JoAXek8MF37R8gpLoGWl41FIUb3hFiu3zhDDvslYM4BmzI18QgQTQnotJH8=
In-Reply-To: <62add3b3ebcea3387c329744102bdf2f8bffda65.1778131118.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/5/7 14:59, Qu Wenruo 写道:
> Currently during folio writeback, we call folio_clear_dirty_for_io()
> before extent_writepage(), which causes folio dirty flag to be cleared,
> but without touching the subpage bitmaps.
> 
> This works fine for the bio submission path, as we always call
> btrfs_folio_clear_dirty() to clear the subpage bitmap.
> 
> But this is far from consistent, thus this patch is going to unify the
> behavior to always use btrfs_folio_clear_dirty() helper to clear both
> folio flag and subpage bitmap.
> 
> This involves:
> 
> - Replace folio_clear_dirty_for_io() with folio_test_dirty()
>    There is only one call site calling folio_clear_dirty_for_io() outside
>    of subpage.c, that's inside extent_write_cache_pages() just before
>    extent_writepage().
> 
[...]
> @@ -2585,7 +2596,7 @@ static int extent_write_cache_pages(struct address_space *mapping,
>   			}
>   
>   			if (folio_test_writeback(folio) ||
> -			    !folio_clear_dirty_for_io(folio)) {
> +			    !folio_test_dirty(folio)) {

This is causing regression related to cachestat() reporting.

On 64K page sized systems, even if we have written back all dirty pages, 
the xarray will still have PAGECACHE_TAG_DIRTY for the folio.

Normally that tag is cleared when calling folio_start_writeback() on a 
non-dirty folio, but it still looks like something is missing between 
clearing the last dirty block and submitting the last dirty block.

Will try to figure out the root cause and get it fixed.

But if the root fix doesn't come in time, I'd revert this only line to 
get the regression fixed first.

Thanks,
Qu
