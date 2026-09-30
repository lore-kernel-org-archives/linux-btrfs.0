Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2FBE3C0A0C
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2026 21:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790804678; cv=none; b=Jhd03Ah4631SeoWqY4eLDs9rGZilG9AITFr3QQGYkzu4Ljo7NfjI4Uec7ze4owrN4Mc/biLRRz/2TkiUTAf8+THeHID9ccbEw5SzKK2SiJtj21Nbj1WyokOLJGVydGEN34GPA26Q9zk7N1LdyN2pXhuv0nsL7DJZH+Ol7sVdIAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790804678; c=relaxed/simple;
	bh=3qwxXe7SPuLtwehKNKo05zePjgRLW6uu0EQS2P3/gss=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Q1q5aBCJKDKI5oi5HL//bf3CXJIy0R3dkqsBJ3iON7nHyvPggV2gqCGsREwJ3P/scJxIVOh4qd8Y7JfC3Hu/EU//W09ViaqqBMN/npJHMisCrYNWNcCV3+C2yB6q5pktI/5lZzMOEk0zg/AjPYiSg2fAgRgc9zVTdgUDqbD+W/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=XEibWUJ6; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="XEibWUJ6"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e79a408deso36835855e9.2
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2026 14:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1790804675; x=1791409475; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=OEqZYM41vpiMicEEYazZhSUUzHFtfeImDOGXFQIwQP8=;
        b=XEibWUJ6/sFlSSxZIzZtelMAyj7H+KKdOEaMPTkth5YAUzQPtTjI4KXuapfeV6kDWo
         2ZallZwfhroInl9P4R2VMTDPQKsRsXynmFUTdNxonyjsiMmQ7sXSNClKdAOmXAC0hvQh
         H3x8ysySVi4Uib/jFYrUnORHuKWkIdluFg6gyyRrHmyDMOUnnGv4UxkpmzBtkBWfyCfs
         Ot/sVXTY0e4AjNRztTpMlHrAJnP534PySoFxb1wJpq5X7n+Eg6qgoSSbOpAfLfk90aXI
         OwGuTCt1uRirn3jKmWPyxRwAyZussW9Lg3JySJQrcxZtJf3Gn2sNDf6ii8abn37Ovj6d
         xxEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790804675; x=1791409475;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OEqZYM41vpiMicEEYazZhSUUzHFtfeImDOGXFQIwQP8=;
        b=lJWI+cc7DEjbA5tGWyDWDKM/xHljdM8rYW3FB2D9sQLiG3bPvKh9lg/cZndInnj3Ye
         lAIKqn6MGQgl4kaTohuGJUr+FVB/MIqQYCj4v/mE3JS4tcwsBFl6JXfcB7RXKDpTNpM8
         hHeJMaBiv/KJCjLG5hVOJvDeUbbrJuvTY6KxNxqmrNvXyClA5Eo1avWxAy/WqcLfhw4g
         yMscf1YgezwISMqI6wfRKKhjh/hRUFKNQjVDFHoGHX0F05DeOrjNsB51kKiGAX0wPFL7
         NHzXJj1k+GudM59or7C/Jk77qHU8CYOiG5hUlUz/119ZCtg+pB0GqaJ3B3gesf3jrzpc
         K1oQ==
X-Forwarded-Encrypted: i=1; AKwUvBysk9lMp8/FYAEBxxhxoXXqoNs6VKJV7GdViaemxbcM+ChWW2gnd9zBCXEqnaklczf5wxdpT+IRsqwbjQ==@vger.kernel.org
X-Gm-Message-State: AFuF++nWXkcGBuG4ZGVioq9QEslj1wNhqgScYgu3F3Kord8zVPhaK4yf
	bXKMw30CIQunaNDfBEj6/ulqs+IaUI9LAn8n/ZiLD3st8RYvMO18KbTs2IQMDjgkKBl+8slOknf
	YS8YpwemERw==
X-Gm-Gg: AYBFou0h7KmpTtGUsen4xCxlcdQNrPy/lzQIWYTxhjjQlc0M6YbcRLuaeEMKDQDjE9C
	5wLR/N8gILkaGwYY3tpY/KHmM9clFfrSRPfuW3+888yWaYCShGOT1QtDQaGDWTuiIUr2GFRHmam
	82+YgzPkFAniZtgIklKcmgCIf4XND6+LrAYIg2yq2kXLRfSAFvdsQY0sDGt8Vue3dFAI6fKgaLr
	YAr2WqJtMMcEFxgaVoejez69XJzKuuot3x6Up3c460Pv7cu1dToIPudshqKlY4teATzV5FlL+Ti
	pKbJZ9ZiCKSNdRuai92NH+Mkxik/9fZg3ycMtrTqmHC4yNOLdbU6MLms02cxwqjRmWbKY2F5/9v
	4U4d2kg8h5kHNTQ8xj0atXGrUpGlX037eZheMhL0iRaebdtfI30JoLrGcfFKcdovdSaW2ZhjaRG
	7valM0Z4mf8SARyHW34GmBBu3XtZF+dtENZjBNy9C3Ym5tZUQcusybouZedyHDGc4=
X-Received: by 2002:a05:600c:4f50:b0:49f:e701:51c8 with SMTP id 5b1f17b1804b1-4a01afe1e3fmr57734485e9.9.1790804674860;
        Wed, 30 Sep 2026 14:44:34 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e30099a3f0sm2417045ad.23.2026.09.30.14.44.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2026 14:44:33 -0700 (PDT)
Message-ID: <09d5b3e0-c0e4-48a3-86d4-e52ece374bad@suse.com>
Date: Thu, 1 Oct 2026 07:14:30 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: fix off-by-one end offset check in
 report_setget_bounds()
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <d424b06da106d3e4bc54416eca428701647e8f08.1790781569.git.fdmanana@suse.com>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJqqw0NBQkUl/JeAAoJEMI9kfOh
 Jf6o/xYH/3AaWnGSq58XnY/T3/YYjr6g+TUZxa7MPyiYTELNpNlvmNlbtbAL0nW0LNvkeiqf
 SmYA+xkwY4RbxnZYQK0H5iv2w1eqa9qqFZb4bIBRmTapu26GEEkpad0W0ZhoSPMO8bV2Bwkf
 YdtPZQLaeUKvHZqNqBKnmtRLQj2Cgy3kuXX3bEGvWjzUOxPUSCj/S++JWBewMdMBPT62vZM0
 3156gfn5mHA94s2p+NFJoWkERY+JPTMu9NISkpD7yuGhXN88qd/aqD0RrlhxvKsrQogdPwn9
 vP18FGG3CRlHtOvOLVoY5NKSOWTDc+o+8t2XEETFTGbKYTcqeTzi4SxhvBLtTinOwE0EWdWB
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
In-Reply-To: <d424b06da106d3e4bc54416eca428701647e8f08.1790781569.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/10/1 00:49, fdmanana@kernel.org 写道:
> From: Filipe Manana <fdmanana@suse.com>
> 
> The addressable range with an extent buffer goes from byte 0 to byte
> eb->len - 1, so if a byte address matches eb->len, it's already beyond
> the addressable range and we should log that it's bad start address
> and not end address.
> 
> Fixes: 234fdd2815ce ("btrfs: remove redundant check in up check_setget_bounds")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/accessors.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/accessors.c b/fs/btrfs/accessors.c
> index 1248aa2535d3..d63ac6eb92de 100644
> --- a/fs/btrfs/accessors.c
> +++ b/fs/btrfs/accessors.c
> @@ -16,7 +16,7 @@ static void __cold report_setget_bounds(const struct extent_buffer *eb,
>   
>   	btrfs_warn(eb->fs_info,
>   		   "bad eb member %s: ptr 0x%lx start %llu member offset %lu size %d",
> -		   (member_offset > eb->len ? "start" : "end"),
> +		   (member_offset >= eb->len ? "start" : "end"),
>   		   (unsigned long)ptr, eb->start, member_offset, size);
>   }
>   

