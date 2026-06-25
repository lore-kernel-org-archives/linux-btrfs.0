Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A4B0340260
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jun 2026 23:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782431446; cv=none; b=o4vDR6c6SNRDP2oMtMq7fX1bBejZvJ8rRpJkZw91RSg4DxJgulLlkqL7LuwTclu6HdrJHiRgfzSvxYN0x4koRU36ASt10Bb6rsYxIxZ2v1bQhQDe6eVnOEcIKvjbqkr+vzHDv3KSQ3K+YdoCTMmZs+rdlLcqEj3DQ19kfwRD3LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782431446; c=relaxed/simple;
	bh=nT5ippKbARbEmf7+nZfwlljdT4pcoLoJ6SYFvIBYTzo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AszFyI6NnBIudBLrgniaoiC38UQF+hvwQtXluZTUjX6TVsy5cv+Elt1dQUxEv4vwAVpkpHth5YwpnyXvDVWaeZohnmbEOLOgbbHOQ2AnH/igDG0AKEFmLTRSGDNiEOmGSfWBC/r25fhk6KhCPfvVS94XW8ZTSYHvDBknMju76y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Qu8jnSCs; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Qu8jnSCs"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-490b64c8311so4156925e9.3
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Jun 2026 16:50:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1782431444; x=1783036244; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=E0PvYjpYa6mb+iHjFo6oq0Zkj+l2qZIqxdP1OVCfZgI=;
        b=Qu8jnSCs3wIiiuHvZxqSNuzaSKg8c2yilSxV5Xp47woee+FjCYUISaD+1hNjR/vgZN
         m2H3UEDwEF0+H/ZjMKEAGj84D+3ERN82BeU1wR8/SWzYrGs4BXGGU3mMXQJ8TQ6z2746
         gV7Hpzkb7HpezLk2NKJ0Y+bYpw8qTakkOvcMHTQ8fM5ekKitgVrvJVALGfxqfNatKpbH
         Acy9kUxZtRSSyca99SOKZl5xn/5KU3w8AniRbvKCGTS0UgavSEUvPLLbTFQigqaM3MOW
         FrdvKaLM6k/W/PZUpyEOBnSXId9T6j6NXZhLDHwaostE011Y01vG+0ZowDnUmLx477dx
         cESA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782431444; x=1783036244;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=E0PvYjpYa6mb+iHjFo6oq0Zkj+l2qZIqxdP1OVCfZgI=;
        b=Q8wYRJ75qJxuOgmakIWnSv2ZuiM+3qXpSSnfurjcEI0xS7TTo1hUM8mkwjjLdjJ8O7
         Ny0MCW1aTssVQrWyxLK9AtCGTamqgQ5XDimOOSMGAQqqb+pwQv/QqBd1hGBMEE5q5m85
         MMAZdDlpCGzRwLtesvBYSZO2YcoivsniVk1L0PsAut1qnbz3txc8IDIPBkpZTM11b8JJ
         2IvUswUv12omse2bHZu0IvCq1pJQSAvqA9jd8+OjNJjW5gk+Q/jk/pybr0456seYUqi9
         x9v4CVxkgzZg6Pf4rDK3nhxnZQmACKUXspGAAeqJ9VGXoCp9EzppMr5xP2VrSEKQ4B5O
         BNBw==
X-Forwarded-Encrypted: i=1; AFNElJ8XYanyRZ0a+J41U5obImA/9/MYGzfiy2hLj3zuoTotFLFnCR1VoQCPcgHxN0FIa5sLxJWbRSYHc0Tujg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxF9zOfQtUI5+UgX9sVli+FcrzDr6Sr6MZ1p/BnHNAEObo/4Sd+
	zsoQRsjCzpJ5wwhjvg0avkDEDh5T4VB/Zo4pTfDL1wQnvSZFieny24dhGOxx9ceefsU=
X-Gm-Gg: AfdE7clYJ/OuQxT4AuVTm7m2tm1MsehztpCmdc7K7OwDFGbFVT1TRNY5HJ66ClyMbqD
	GvkVotuRPkETghrJBGku+GujU2sTTUYmWZkqrSMNDVt90ZLD9YohODxbgBpyxW9CV3jBn5yLrfp
	uCq8SpmHd6nAMBANc1Z7KgV4oHxsEs4Oz4dDV0pu9bzO/kqtH6WKeygOS9BffsEa/K7TP0gLZa+
	HkCNmed0ckgspY5GXc4+WQMkF3DuIKp0bvLhNB5JyCB6Vj5LpwKuALjheLOeOfMU3mvhPVleRB0
	xLMbrXIqzxxiZHfh5GK8B/Og0ph1IxUX5c1d9br5YZFNVpohXtbAR/n3GYMZd+deMD7Tbu4ieHB
	KAUymXO1pI41RoRnhBwPshmTpiXki7308zDS+4O/0zEGqUcLGjkJD9PilMoG0DomSqZ6ygZvIfG
	E85smcvMbo8GCYgHT4p0D4X1GHjyRhn/rJWx6swYJYkHkgN6fZ21Q=
X-Received: by 2002:a05:600d:8489:10b0:490:9588:bdae with SMTP id 5b1f17b1804b1-49266899f97mr50891175e9.18.1782431443612;
        Thu, 25 Jun 2026 16:50:43 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-139d8f77602sm11019674c88.8.2026.06.25.16.50.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2026 16:50:42 -0700 (PDT)
Message-ID: <867a944d-3a26-4248-b0aa-f10247196502@suse.com>
Date: Fri, 26 Jun 2026 09:20:37 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/8] btrfs-progs: print encryptin type field of file
 extents
To: Daniel Vacek <neelx@suse.com>, David Sterba <dsterba@suse.com>
Cc: linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
References: <20260624165144.556908-1-neelx@suse.com>
 <20260624165144.556908-6-neelx@suse.com>
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
In-Reply-To: <20260624165144.556908-6-neelx@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/6/25 02:21, Daniel Vacek 写道:
> From: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> 
> Encrypted file extents now have the 'encryption' field set to an
> encryption type.  Let's print it.
> 
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> Signed-off-by: Daniel Vacek <neelx@suse.com>
> ---
>   check/main.c               | 1 -
>   kernel-shared/print-tree.c | 2 ++
>   2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/check/main.c b/check/main.c
> index dedb4db4..a32247b3 100644
> --- a/check/main.c
> +++ b/check/main.c
> @@ -1778,7 +1778,6 @@ static int process_file_extent(struct btrfs_root *root,
>   			rec->errors |= I_ERR_BAD_FILE_EXTENT;
>   		if (extent_type == BTRFS_FILE_EXTENT_PREALLOC &&
>   		    (btrfs_file_extent_compression(eb, fi) ||
> -		     btrfs_file_extent_encryption(eb, fi) ||

May I ask why preallocated file extent would have encryption value set?

My common sense says that encryption policy should only be set for 
regular file extents.

Thanks,
Qu

>   		     btrfs_file_extent_other_encoding(eb, fi)))
>   			rec->errors |= I_ERR_BAD_FILE_EXTENT;
>   		if (compression && rec->nodatasum)
> diff --git a/kernel-shared/print-tree.c b/kernel-shared/print-tree.c
> index 0afa3696..159f0825 100644
> --- a/kernel-shared/print-tree.c
> +++ b/kernel-shared/print-tree.c
> @@ -471,6 +471,8 @@ static void print_file_extent_item(struct extent_buffer *eb,
>   	printf("\t\textent compression %hhu (%s)\n",
>   			btrfs_file_extent_compression(eb, fi),
>   			compress_str);
> +	printf("\t\textent encryption %hhu\n",
> +			btrfs_file_extent_encryption(eb, fi));
>   }
>   
>   /* Caller should ensure sizeof(*ret) >= 16("DATA|TREE_BLOCK") */

