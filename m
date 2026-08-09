Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A7478F2B
	for <linux-btrfs@vger.kernel.org>; Sun,  9 Aug 2026 22:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786313814; cv=none; b=bgnctvMytzRt5uxvYEPcVteO+dKBm+BdieCMpkBqJgJcg7Epb44qiOYUEuo/TlI6wvBiXaztOA/X3m4odYlCMFMJd8pnpvormIi4SbwikZlYAafxTdnu+e1JlyV9DjwJXI0oJsvpNS1ANKUBNbwpiJ8zNxbMrnFfCqK9nUV7RfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786313814; c=relaxed/simple;
	bh=lT05n1ATxAJG/9sVAqbMnZsJHlXsVHhNtW76C6i7/wA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IMPT51Vqt1qWZ2bktEyKCmUBlIDdQUs1rKz0gytKogMhyl3z5hlTRD4u8/Pl8ccGqNVQXs+dz1/gBAiloXLKAbgK3UO0QoVOK57qU+cSFuRLEblIW92HTvTiUYNXPLbHZ3CextZ+rvLt+lAS7SC8hLs0+usfYJntmne5ejQy0As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=A56E/z/X; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="A56E/z/X"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-49557167508so9911035e9.1
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Aug 2026 15:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786313811; x=1786918611; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PENaDpyiGPU1EsvimlIwrfW3oiJLG5x6xCGW3ISxE+w=;
        b=A56E/z/Xnl4+oOhXZIP+AHTqfpFUglWu5pqG7J8pTnx4A9IdBrP4zzWJEt0iejlnn3
         kpITdes9ygpG5a/FodlEJWPSvRM2Y23/qL3v9Kq3qRzkAMuLQM+/fMrr8laD6CaA4r0k
         PEKV2C4FKr71Dny00Mvb88mlCz97GTEN5rSxuCCVtMZGhtsvf1+iXT5yJrcV6GgMt2VF
         uxJgmlmuVGfX7YbfYAwpRuUv6D1QbM1lBpPwHF16j+5EUi+DpOAPNSJcQzaTDRDHyLzY
         8U6w4QSpeNAPcVYQ0jQjTyKNOrJ9cXlMT/MholmGf3YrfI7ubAA1HucISE22aMGfMMlo
         jwpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786313811; x=1786918611;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PENaDpyiGPU1EsvimlIwrfW3oiJLG5x6xCGW3ISxE+w=;
        b=oZ0qlrUuWPKtoVjN4RktLDd/rpxMx74X+17Y2UQ5ytXdsoDQbCB8MQ2kfr6GA0luUS
         wgrTK32tN8dO6tuKy5eehYdgGw1+ludlQhQRel8+SkIpXjrfBM7Qmncz6SVu5F+qm4Bk
         XRuFXxuHOUPlvicsqyK7nOYfEVNEnKp/HrCJq2wh8OBXxBxM3n1kePOnP9f1RRzVciIz
         oZsNlJyzvPOTVwqqzpSn1J56pKGOb2KxeDLjbHFOjLIzuDoUSpTlzekVBgajPkcqPfDP
         F7zsihRtudscIbrf5WXWuD19Ym6KK32rGaJUaUws0LE/8tEZa0J091gpnXAqIRVv0g+d
         dQzQ==
X-Forwarded-Encrypted: i=1; AHgh+RpfFSskHzB0MHeZ2B/XuUArlb5erFGla9De5JZpp+/0nmVCNK8tVKy3y183Q1LdM12bLk7rbg3WObnxew==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzj0+fUj5EQf4+69P6HmRtOssGdY36ns14UvK2MFkEr4uFXkx4F
	XhjFFfzSSF1SOLvGkeCJWqKZKxzmSPl4JOIKOYanFmk6Bcbpto8SrU3gSnsAQJcugJY=
X-Gm-Gg: AR+sD12La78cr6RvBYUX4IEhy/ZwASXsK1M2BeZQaIwm6alcGZOHpPKTq9I4L6de7OK
	WobmtuQtUnR/oIu3sNgvNOOxLbITUIPiJaka5HxMU19JUoUKY5LHe6svBWsPTXv89vskJWEaxPx
	YVCLyTjc191ZWkStyOwXUPVVErIng246CXcpUcKfuN7SJA8zboM4aD/lceHISaM/9LHY14y7/Xl
	HlvtZyW41i9G4mkjQ7yKhZ7Gfnhr9GYErOEr2qH7apebtyrPlg9vNa1XXjiF75YE39ET9Q2/p6c
	hT8mu8YW0WDG8ThpLVbGHtSS/uYyMDW3SlTfupt8zHuyXSnJDJUFyyk5aeXEeSEZK0hkF/06FWg
	aUpkyndyzEFUKkgjluzdEvV86yGpi/280dNfLqQJEsg/59V/t5aF5G+D3YAcpfiY/Vgmd2vQhzb
	1LK2ILkApXoXcBep+VLbldE+SUD8yEOobnMFmRXsxMJhrbrt4owM5xxciK2STlwpbr
X-Received: by 2002:a05:600c:e557:10b0:496:c06b:9fb4 with SMTP id 5b1f17b1804b1-4994e7cbbd0mr412723835e9.14.1786313810803;
        Sun, 09 Aug 2026 15:16:50 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315be86e917sm40278558eec.5.2026.08.09.15.16.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Aug 2026 15:16:49 -0700 (PDT)
Message-ID: <60592a20-9280-49a2-ba92-a51f8616b4e3@suse.com>
Date: Mon, 10 Aug 2026 07:46:43 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/5] btrfs: fix -o compress= level getting inherited by
 compression xattr property
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
 koraynilay <koray.fra@gmail.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 linux-btrfs@vger.kernel.org
References: <20260809185303.600071-1-koray.fra@gmail.com>
 <20260809185303.600071-2-koray.fra@gmail.com>
 <anjf71ZUXUC4dd1W@hungrycats.org>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
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
In-Reply-To: <anjf71ZUXUC4dd1W@hungrycats.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/8/10 05:45, Zygo Blaxell 写道:
> On Sun, Aug 09, 2026 at 08:52:59PM +0200, koraynilay wrote:
>> When setting the btrfs.compression xattr, btrfs uses the mount option level
>> (since levels in the xattr aren't supported yet) to compress the data, even
>> if the compression algorithm between the property and the compress= option
>> are different (!!).
>> For example, when mounting with compress=zstd:15 and setting
>> btrfs.compression=zlib, the data would get compressed at zlib:9, because
>> btrfs would take "zlib" from the xattr but "15" from the mount option,
>> which would then get correctly clamped at 9.
>>
>> To fix, just hard-code the compress level at 0, forcing the property's
>> algorithm default.
>>
>> Reported-by: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
>> Signed-off-by: koraynilay <koray.fra@gmail.com>
>> ---
>>   fs/btrfs/inode.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> index 2534cd9284d5..6d7f2aa2555c 100644
>> --- a/fs/btrfs/inode.c
>> +++ b/fs/btrfs/inode.c
>> @@ -938,6 +938,7 @@ static void compress_file_range(struct btrfs_work *work)
>>   		compress_level = inode->defrag_compress_level;
>>   	} else if (inode->prop_compress) {
>>   		compress_type = inode->prop_compress;
>> +		compress_level = 0;
> 
> This set to zero should be conditional on inode->prop_compress !=
> fs_info->compress_type; otherwise, it prevents the compress-level mount
> option from working in the common case where 'btrfs.compression=zstd'
> or 'chattr +c' has been set.

No, read this discussion.

https://lore.kernel.org/linux-btrfs/DKK0XWCI89MM.2G6KD41GSR46J@gmail.com/T/#m79e6c1ecbcc61ebb57dca5cbb3eceabd052ecdbc

> 
>>   	}
>>   
>>   	/* Compression level is applied here. */
>> @@ -2326,6 +2327,7 @@ static int run_delalloc_inline(struct btrfs_inode *inode, struct folio *locked_f
>>   			compress_level = inode->defrag_compress_level;
>>   		} else if (inode->prop_compress) {
>>   			compress_type = inode->prop_compress;
>> +			compress_level = 0;
>>   		}
>>   		cb = btrfs_compress_bio(inode, 0, blocksize, compress_type, compress_level, 0);
>>   		if (IS_ERR(cb)) {
>> -- 
>> 2.55.0
>>
>>

