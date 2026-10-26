Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793049142;
	b=mYEht7gNxXJI/knqQjgfdk91iXt00Bw4W0JHs3QH+It2lCivVcfW9RSgM4KPn3CQwopb
	 QTaDR4eHaVgmbuKjwkNojOlkoBt2PS4NCca6NjRLRByYVIzXibhJWhHpaUfkmHOcZJeXS
	 rZ5gUcpme+FbC2JRsOVA18BOIO6ACrkFSfIyUrBvo0f2uXtiLkNQgoyHSlea/HiHum36G
	 NaVumDdrmJynOYDX0Z/OyiD5kbicGQh8X4ROMEpV5vIjW0Z8TmSJnlX2YJ1fL+cDLxD82
	 fh3+5K82pzgMu7/pXvrZf/Eoq2tXLaFO9W7/wpI/PWXNTZ8okGiJkpOxNM3TbVgKvSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793049142;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=mbDPXxXm56BBrLxppgQvJ0EFeHMdLPIiONRkDx7Dsdk=;
	b=odBgTpzvC3YeSI8dSHFnS/DmkFgXxQfffIuckffO5L0Id0RnW1Q9gk2YunmGlvG32jw1
	 ag/ybIxKaFQw5oDCShw58yktHlnvtpFwcqkSLu0K1WunnpVnPs/HqBqGHWCX0P8sjcyiM
	 tvbP5lr5vIz96RI817EamSh8fYGKddtjaaDYe6TA9meMeIzqjGGkBSKisn79GCTi8EnqF
	 ZKEYMuNXPlQsGdNFGPtRt8S51t5zgzG4E8magH9rfvrs/T9wfFOStAGX4FLLfMcVcIYv0
	 XS6Zn70t0R2l4kuT1NQqHrzleMMaUwloJK7956nB+7qoOLH4yR4Ec7zJvk33CmdgsZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=gx2FCVbi;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC3D606A31D
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2026 21:12:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CCC3D606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=gx2FCVbi
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a208d93758so40538435e9.3
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2026 14:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793049140; x=1793653940; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=mbDPXxXm56BBrLxppgQvJ0EFeHMdLPIiONRkDx7Dsdk=;
        b=gx2FCVbiKo6wYib9jpCZdMvyg04jASWE4o5hyWRqqAcizPL6wOGSrqeUAnZeorGpUb
         sK7ILWLPjvyzAHHII98YsSaY3zoNqaEkAtu+5EfGtbqEVrzrivNq1+enABR9dUf0xn75
         NNN1TMUcf/CPbRQ0BDT6qpqUd0SWVcNlaiveBBR4n/d3MVSBunE42gtPdhyEJXDk9u2z
         w9KbiCWUGZrjSl+nThpnWP7tg4ctpf8yyedoiBdZITQDONo/dUOZ352ytPfw9Xjkb7I/
         ZsRmBl/BiayXpQXD5DlyNK2qDaLxa4BkLAkkZ3BMDEQB2hgsq+ncLDOGzsCi5DNNS0Lm
         wZGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793049140; x=1793653940;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mbDPXxXm56BBrLxppgQvJ0EFeHMdLPIiONRkDx7Dsdk=;
        b=uyFD+lwtRsfQcIBYLV5i+d5ncy64wqqYvuH8AAVEgChTKXG9UBoukCY4PQQrBPPrfM
         KNRpPB7dWYb5eYPTtA94Z6j/v96vV3SbQgNYqXEsk35HEz6ZUgH6SqN2cAyyqBIo8IGH
         cZNDCuD37azLP8+V1New1smon3rRmLvLB1fzJdDRVHwsy1ocCZHugN0CqIjo3YL3Lr6W
         pOSrbnoFPlJMUX6QYFDcZHHX/Lsj9+cU3/Yoea4vO4qufG6jQnhIgeyqGov0l86Ke7Yu
         L5T/S7cSNshklprnfF+5PYz+BHHpCXYbROgFN6amuwC0QOu0fcN9z7izzxGcua+mc7un
         IIXg==
X-Forwarded-Encrypted: i=1; AKwUvBwoyolnWeJc7Trp3Tx7yBKfHQeTKVVPUQC5udmTT6grbo6/B5L6dMtuSnbioQN1pgJ+a5GFVYoeX5v3Sg==@vger.kernel.org
X-Gm-Message-State: AFq9FYKTDCru+RDD25/BJeBBQLB3jU0UldyN0qNbYSdF6OZ6Fnhrwa85
	HBQVfylz941yah+eMMRchl0LSLRqH/tT/tRKgFDS156oVZv7fY+m+2I4FUVVhSruQ5uUMzCSDSn
	nL+umVm8=
X-Gm-Gg: AYBFou2lD12nhoc8GuqNBYirlKkgRm6Dmjj2LhipC0e9WTxBzk4MYSkmfgC6DOa3t6n
	4SkOA/iAUEZ/12BvMQ5nSdGSredPiicjhBhI0Hc6g8W/wWG7UAUq5K0cQWGSsqpsdfIv1p9wU3P
	9QpOmhMbUCe9hrfhPxgyiTl1bHHxO9abixw2VDiSafrF1GEAPH9VAUbTNvTfsTl7ZwfhFjFdEWu
	x+L9nzrEtlRNF+LkK6UODQihKUbv8CTM8qt/Zv7iKCe43JEIPDTc4BGG6UwsCOD6QjQ0vEFSnTz
	xi6HQbpq7G9SPbnEVEjZ3zi9VNd+1TarMXfI/jL87ytrZb0dmbQCOdnrRNVdUtmti1fswjtuau1
	a2+TrjqWQPZhptePE/jItvDDKsbvTXKHGwAoE+CMIvrSjyQHhhxJ+t2FkofzNiNqGvsP10yLgYB
	hjWsbVtXVMrDeAxISIPgrTHphByOnernifkxR4lOO2N5k2C5zKEDZaFEj0fQk1dtydicUjf9f01
	2SkCjqjw+ecx1LxkwLB6RgvqX/eBuUOfwC3EYByrCHp1Dat
X-Received: by 2002:a05:600c:620b:b0:4a1:c6fd:4db0 with SMTP id 5b1f17b1804b1-4a35aca41e4mr128498635e9.19.1793049140200;
        Mon, 26 Oct 2026 14:12:20 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3adebb1e37esm6587933a91.4.2026.10.26.14.12.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Oct 2026 14:12:18 -0700 (PDT)
Message-ID: <44b36ec0-429d-4e23-b0a0-d590c1dda9a3@suse.com>
Date: Tue, 27 Oct 2026 07:42:14 +1030
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: zlib: use memcpy_from_folio() in
 copy_data_into_buffer()
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <546ae2935e37e248c86616aa0cb6a00d4a1547cd.1793036271.git.fdmanana@suse.com>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJq3ujyBQkUpLw5AAoJEMI9kfOh
 Jf6o8OIH/0mqW+TQM4m2x3hCsnK+oB4yJH1qnGvIhFF/Lhs48wI02sGh6/4aA0hkCDfd9LHQ
 +ci4FUepZ9y4VS01+oIExbg/8ytzGYTzLtb44jK2GBOBVSJkMiha6jp22XFt7WUkT/tvbreu
 WWdGsaJIRQaZChy7xsMI8lqQ2WdmluZJ4LT0wD3l/l6QU1ZseMGySebdY9sVOQEOJNV7Qj92
 /KOAFNmeZshV/qDI8Iw1RTs6TvLqCcqmlZLCmJkYSVhT1RonWRren8xIRcFEgMe004IDnt7V
 qdQhk/nhTS9x9MBAhMRl0TTE1VKDLvVALsud3iZLrmmtYvwPApzGJk052f0m28vOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJq3ukKBQkUzDspAAoJEMI9kfOhJf6o
 SNsH/1ysUWOKmzY0rGS3ZdS61QgqMGhSWD/EJ4UiPw+xO4l4+GtX0fOAqxqsmBKqje3vyhBa
 Z5o/1Y+gNiN+E6RBcSz4b1TAd78sQ2bvT5DWOvBjeeVxHdiuQMIn4S8xk5ZpySBw5ifjoiuL
 0M33UVtJOzM8yfAeL+d/Rp4leJw72SutjkLyZTG/gJIp4pJGD/kFHn24OLL0IxEcO0gOekNZ
 os5e1R6jAJ2ILk7+MDnvU8wXHcCiVzuDhJLI1tih1uUIE50muHQJWbYuVBbdJeu8WlIDDssx
 UOCxLylNG3gDXV5MhLubPTOpp9OiFc/XC37nvkgEcrlmlOFBv4/NJCbECpo=
In-Reply-To: <546ae2935e37e248c86616aa0cb6a00d4a1547cd.1793036271.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/10/27 04:09, fdmanana@kernel.org 写道:
> From: Filipe Manana <fdmanana@suse.com>
> 
> We are manually mapping the folio, copying from it with memcpy() and then
> unmapping, but this can all simply be done with memcpy_from_folio() that
> is provided by the MM layer. So use memcpy_from_folio() instead.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/zlib.c | 6 ++----
>   1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
> index e995d0b1452b..1f2a91f966a2 100644
> --- a/fs/btrfs/zlib.c
> +++ b/fs/btrfs/zlib.c
> @@ -122,7 +122,6 @@ static int copy_data_into_buffer(struct address_space *mapping,
>   
>   	while (cur < filepos + length) {
>   		struct folio *folio;
> -		void *data_in;
>   		unsigned int offset;
>   		unsigned long copy_length;
>   		int ret;
> @@ -135,9 +134,8 @@ static int copy_data_into_buffer(struct address_space *mapping,
>   		copy_length = min(folio_size(folio) - offset,
>   				  filepos + length - cur);
>   
> -		data_in = kmap_local_folio(folio, offset);
> -		memcpy(workspace->buf + cur - filepos, data_in, copy_length);
> -		kunmap_local(data_in);
> +		memcpy_from_folio(workspace->buf + cur - filepos, folio, offset,
> +				  copy_length);
>   		folio_put(folio);
>   		cur += copy_length;
>   	}

