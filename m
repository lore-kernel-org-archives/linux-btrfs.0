Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794539887;
	b=eUz8a8dUE27zOPgyF/F63GQJxEs/7Hbnvliz/p2FLSZApHDej/SnSmqxOs6XNjJKs4rG
	 tYCb47Olv9TCrzAsVieM+OFsNVTfKeI86PrAs9yHiTgQpKRwpNqyY+B9xrAZ8nHJcCGJw
	 0jxyTqg3sEKbMYmGaEAZZU2rKcMGTrGETSdbP1MHkMlxZNxQQEHzUb/HX3yxQWlfzjwV5
	 zaH+EZiLIcyNOJkn5l7hjFaOA0jgFS73rhKlWo0sG2BS2eKe/ZhO8TBY00oVihWL9QIbL
	 13dz9zJkouDzIv8YRzSJWxD/hBSyz3mPAf4OYvM84wlPJu+i6TgSM8mvMtVZAit/Srg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794539887;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=dj2jytBobitYL3O3uLExbSEUkPVT522IKzMLHjMhss8=;
	b=MIEmljK8pOoQ7KFHPxVV1GuyUSeOcWe9Xw2DjD0Mo53JPY15h2iyzzh3sViDA1koJqg4
	 SfVez1xcwJrweWhiD/hhRZ1a69e/dbneI3voNXbrovyXLh60Vx88ifZMgEHxoSxEC0T3V
	 IsVyt4yufpPCLOYAmq3s+IWCJ8GVDf5WKrd20NVgl/SnGNPAyA+xswW1rGHACyNILlaP2
	 sqVESsdZtjRyzydT30c9PXNHxmrYOjeUVl+yVizTGJ4Ki9nCbip+lXOWNHYYeorvDbwZZ
	 K8VpQ9/74nhQNxOJjaWZTV/uDXBODhVGyfNO6WJlYSVX7vv2tf9uFCY+raM19E4jq5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=DgnRwtJQ;
	arc=none smtp.remote-ip=209.85.218.48
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECED2606A321
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 03:18:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ECED2606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=DgnRwtJQ
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c4395d31228so74672766b.1
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2026 19:18:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1794539885; x=1795144685; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=dj2jytBobitYL3O3uLExbSEUkPVT522IKzMLHjMhss8=;
        b=DgnRwtJQYF/wsZpLG76HypnGF+SutO9ywCF35p25rlUcWRARczBHlAG16eV3EYuuoL
         XBdjedfKX1CHzb511JQJa5FaubzP9dyap/1Ze2N8t10OlM7h6kEkndUY1qzQJaSfoK1t
         QE75qAgQAjIriEQAFTcth7gbb95yBEXDQfjL10eIun9OOxLt5kB2i7Lsulq48WJwuPxf
         dJ7sBEdFjYJYbq1QmD4cOIVVW19amnF6d44zbDhYEJfNvpRtqGErwEphFZMx+pbbV9zd
         DcBoLZQqczkm1rD9dGC8JKFmAqj0GQDLkv2K6zeQ5fUkpxm0ATlKGYSbHixRxGDWw1kU
         Akdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794539885; x=1795144685;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dj2jytBobitYL3O3uLExbSEUkPVT522IKzMLHjMhss8=;
        b=WK7HRUMTpPehGHTD3vHLJwuXhlPsMAmWM9K7CBr8SQP1W7/C4sfZitxHRC4LTceXY7
         0nmV69vEoPS8chkRoBgE38qBDF6yCBHvFAVzt/JUdM9jOfstF3+fVT+E6KMKBgx6WrwR
         OEzw090hbH63vDGYQHo0RKv332gU+D9Kg28M84BWgFYxboyyVQoZkzFQ8PL+jXzPUB4k
         pom3nDE+kSGrH8BFtczOjcPztw3C81epzzituzb2ClBIZj3xw6wmrIF5NGZk5VHSVif7
         TZiFmoyur/She//WV3r6LWTjJmJ/6Q/TxYkNzqQkfHngOYLC5EZnpni6u0C1I3mRjEjl
         NFFQ==
X-Forwarded-Encrypted: i=1; AL+hErHPzDrc8k1F+8AMdQUy43ZNl0gzZ6Z65n7GGbdyMHlv4O6rZO0Eob/hyU4CbTr/QvZYvCbSIum4NtXR0A==@vger.kernel.org
X-Gm-Message-State: APuU4Z/4JjL4NrDHMQKBdjQoEc+GC/cgCxtLmhckiRgH2OUloB9LHb12
	y8qK4NPBkOTq4MIyl6dTphIPGfLVrOgmlNl97YnF5LtHEC7KEKeixslT3+79PiCrVUU=
X-Gm-Gg: AYBFou2Vz5GNSUj/RLLOEjFfXynleRAkbr4SBQnDH80NRRBflQvIYb6MSGxkPDuhUqm
	Xa1UO6DbFQIXLaDqqm0ehIBjCrq5Qb9rODhDJGN8BSqpiddRzQMitn9uKCg0jBHk1CXHX/C75Up
	IvkTPJqk25IKUaCoq1vsGTMNg2EJr/s9g4N9+Pnl4Ahe2ZGud7wQsmvu6XCrZEFIO5pOR/s+stl
	81k8fnDTK3VWfcWdbPh6Q2SINLWwj6HZJGmM4BUjy+fnn45BpT4wMWEpEsVO66jiw3KciJcsSDo
	9yfnUq2n/5JkQoIDJMMURiIXBKs6004DssJbrEgiWUTKmGLNFbHceDr/BXhoYWElGWcxYgrb8K5
	xFaiOXppDcpBKrkD5qHDpfvLgzH+m1BD2uvALPUADAriwj3pIN3aWX5TKgNszb+yr+ANsfTtJgn
	NPmXQMFqK2MwgCVvc00WthwA4AfqDECpYKHEDwrV+gYsg4Mh6NaW65YgTjLmr84MG4GPVZmn6TU
	/wvE9lFmVmOaIJRJ37rm7cA0eYepaRkhVWz69akZEgHok2KYcH6jjSqU0pwdqc+zd1W+cjgBn5G
	mldxyzLVeJuBHiaCjAb2+A==
X-Received: by 2002:a17:906:dc8c:b0:c50:6bfa:3235 with SMTP id a640c23a62f3a-c50963c3a6fmr97033266b.45.1794539885147;
        Thu, 12 Nov 2026 19:18:05 -0800 (PST)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1b25a365asm618199a91.1.2026.11.12.19.18.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Nov 2026 19:18:04 -0800 (PST)
Message-ID: <5982324f-3acf-4f8e-868e-a379356688d3@suse.com>
Date: Fri, 13 Nov 2026 13:48:00 +1030
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
Subject: Re: [PATCH] btrfs: fix double release of space when cloning
 compressed inline extent
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <74b6b5edcf6a3c1105cc660809c2e4c8a9049b4d.1794515528.git.fdmanana@suse.com>
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
In-Reply-To: <74b6b5edcf6a3c1105cc660809c2e4c8a9049b4d.1794515528.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/11/13 07:02, fdmanana@kernel.org 写道:
> From: Filipe Manana <fdmanana@suse.com>
> 
> In copy_inline_to_page(), if we fail to decompress the inline extent, we
> jump to the out_unlock label and release the reserved data and metadata
> space with a call to btrfs_delalloc_release_space(). However we leave the
> range in the inode's io_tree maked as delalloc, which was set by
> btrfs_reset_extent_delalloc(), and that means when someone later clears
> the delalloc range, using EXTENT_DO_ACCOUNTING (like
> btrfs_reset_extent_delalloc() does), it will release again the space.
> 
> This does not happen for uncompressed inline extents, because after the
> call to btrfs_reset_extent_delalloc() we can't get any other errors.
> 
> Link: https://sashiko.dev/#/bug/linux-52478dd4-bd10-48de-baba-a527b38b64aa
> Fixes: 05a5a7621ce6 ("Btrfs: implement full reflink support for inline extents")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/reflink.c | 15 ++++++++++++++-
>   1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
> index 5154db82ef3e..ecef21773027 100644
> --- a/fs/btrfs/reflink.c
> +++ b/fs/btrfs/reflink.c
> @@ -120,8 +120,21 @@ static int copy_inline_to_page(struct btrfs_inode *inode,
>   		ret = btrfs_decompress(comp_type, data_start, folio,
>   				       offset_in_folio(folio, file_offset),
>   				       inline_size, datal);
> -		if (ret)
> +		if (ret) {
> +			/*
> +			 * btrfs_reset_extent_delalloc() set the range as
> +			 * delalloc, so clear it, otherwise we will free the
> +			 * reserved data and metadata space twice, once below by
> +			 * btrfs_delalloc_release_space() and once again when
> +			 * someone else clears the delalloc range with
> +			 * EXTENT_DO_ACCOUNTING (like
> +			 * btrfs_reset_extent_delalloc() does).
> +			 */
> +			btrfs_clear_extent_bit(&inode->io_tree, file_offset,
> +					       range_end, EXTENT_DELALLOC |
> +					       EXTENT_DELALLOC_NEW, NULL);
>   			goto out_unlock;
> +		}
>   		flush_dcache_folio(folio);
>   	}
>   

