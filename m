Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86D2187346
	for <linux-btrfs@vger.kernel.org>; Sun,  9 Aug 2026 03:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786244612; cv=none; b=mIk/tiVE8PPZ+ecblRFErtWZ1ZAgZcnF5VMeRGxxlIxoxA27z3NsIbqW5EJCacyKLpnbTDnNFZR5I7a15sBwsTLoTPebpjRSJeO+LPlCjcTfVdrsWwJ1ITdvV7C0S8sCXrQCHJWgOBlAGUmWc6GoKj5mvcg3x7rb8fz+DpGl25o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786244612; c=relaxed/simple;
	bh=pFKAVHO3UC8rHLHwhktd9ABPtZh3kAtWUPd+VZ+JPjQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R+UIj4D5yK63nPNUzZdA2PGGSjUnDBPvRx2Uje3iKvoDB37AiNMC3O5e1pOIB19VtpWMlC8RmXJ1kJlw5kdYxPpF+GW9JckcGIqZO8ZKZytfevj3mo/CQFPjLaOh/qKQrT916Xbqyx+tj6qvOES7V97O6oEWdRu4URgGFAdTU84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=P8+mcp86; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="P8+mcp86"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-47fd66a094eso165924f8f.3
        for <linux-btrfs@vger.kernel.org>; Sat, 08 Aug 2026 20:03:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786244609; x=1786849409; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gw66RcIMgJCsboEPeW4HT2ZUrnWgWs8yjL85BOq11U8=;
        b=P8+mcp86gAwWq1Kczze9TwUWCCZK0sncbvOftuGeNqYuZAAqr0sNTKbwK+kl1ynpJc
         nGh/o2uawtkFROsA+bUfANcSXCTCDqOOvjBox6Otem/VPi9BPss8DxB2euouHSpIiSAN
         Q9PDYW7grr/tstnONuXPtyPIE5a2OWhlaLBuYKnEaYDS96Rwt5jOyRu6iZk3o8lAbSWo
         EI54t+MCHY1UQEUECVwimzDOs13C1z9S4IqIqA82pFVytmDyJ2dvOZ/wmTBPZiAsXOyI
         hIpA3EOWDgukCpU3GLaqxBD/g8bKnY+UL+zNd+VGmbaGXb1vsmyhhxxDfFFCnGdDNZfB
         H86Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786244609; x=1786849409;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gw66RcIMgJCsboEPeW4HT2ZUrnWgWs8yjL85BOq11U8=;
        b=I9MwfH8OQed8nvdgfJXGfRo7268TFeH3t12UDxQ17sUyjmTvhWPWRxDNFFaoffCUdD
         LNPkIbBLycIR4eGDuW+AkkjacZ0Y2aD95pHQw44psxTFZ89RFgGXhNaEd2fbEzCcqzmB
         yG7N/xZssfsh5wD0n8TM4F8xXwzSE1GWU5CpB+ea1bdH3ehvgBSovOMT8l8qXSrGxK8j
         QzGyzLk5puougRuJacQp/sEA5G23ZST9d9SlTdR3D7sADDZpiDP3myzHwjfRmRr7oEwD
         cj62uKGNX8tuISK2N+y+Vg3IHivo4y4W/SuCJ6TmXeCawnZm7541+/9ug7ZIRTLvJZbv
         ULeA==
X-Forwarded-Encrypted: i=1; AHgh+RoQbJgn6qK+A9gNj/JjYAmU2ZFluoA4CGBPIGoHFqJ+LDVbEyD9nHP58OcFzck8LWa0zfdkR0BZXFbebQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwxC4tForcCpkqTbLk/DMXxlJ+X5lC9Zlc0o9/05Nrk9rk8f+u7
	FZG9gqDhVmrMas4dEvSa+fR9hbJoq68H0PIJ2ug67uVf2aOoOl57ov3SPfAbRLT4r1Q=
X-Gm-Gg: AR+sD10MpSSVmm+Cs54qjZg5nOkgp7dwxwja/t+fHpa+vcBSwwtLCdJi40HMN++XeiF
	Bndci3iRhyMbd4+1DrDvdhGR4YcoNcFKALE9xeTG0qKb0AigBEX9daTVw3UPEvlVHLZflclmesr
	kJNQI94IitEn8qDLICMN5e/WRHp9wVWR98BhLkcEbllI4qgR9J6qI9AKM4mpulLUT1eGHn3jsgy
	Euyjtr+9fezpEehvf2PvuTdgxalhRLWHdqh1xivM60ZK0Ja6pp6VbwavKLKW7eGTiq65m9/ryyl
	2BN4kK4DBuDmLmprixNil+k5W2iroZXZzfWvwwHkElUtYI1nDnd6gr+P7zRmaT0JmRJufDDCH5S
	ZnFcoGG8kblzKyZIOZnNTJi5WG7HkYupj/VmABtyUVDSEnAVgx3IkG4D+S9QE/ZyOPzNWLqp/0Q
	Tw73OU7yky8Vl+d73cAe7E8eCIF8RjdAChjMCkaqKVhSKm5PnwQ/h2zw==
X-Received: by 2002:a05:600c:1f96:b0:493:e365:7630 with SMTP id 5b1f17b1804b1-4994e7cbc2fmr363576825e9.14.1786244608828;
        Sat, 08 Aug 2026 20:03:28 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315be8a754dsm23602475eec.11.2026.08.08.20.03.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Aug 2026 20:03:27 -0700 (PDT)
Message-ID: <fbb3bc20-0f05-41ae-9385-c06c492e6004@suse.com>
Date: Sun, 9 Aug 2026 12:33:23 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] btrfs: support inheritance for per-inode
 compression levels
To: koraynilay <koray.fra@gmail.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>
Cc: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>, linux-btrfs@vger.kernel.org
References: <20260809015054.779137-1-koray.fra@gmail.com>
 <20260809015054.779137-5-koray.fra@gmail.com>
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
In-Reply-To: <20260809015054.779137-5-koray.fra@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/8/9 11:20, koraynilay 写道:
> Change prop_handler's extract() signature to take an output buffer and
> its length. This allows for the algo:level string to be generated
> dynamically, but now the caller is in charge of managing that buffer
> memory. Before this patch prop_compression_extract() would return only
> the address of statically compiled string without being able to add the
> level, now it concatenates the level to that statically compiled string.
> 
> This signature change is fine because the only currently supported prop
> is compression, so there is only 1 extract() function.
> 
> Assisted-by: Gemini:3.1-pro antigravity-cli-1.1.5
> Signed-off-by: koraynilay <koray.fra@gmail.com>
> ---
>   fs/btrfs/props.c | 14 +++++++++++---
>   1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
> index f79a61a2759f..9c97792800fb 100644
> --- a/fs/btrfs/props.c
> +++ b/fs/btrfs/props.c
> @@ -27,7 +27,7 @@ struct prop_handler {
>   	int (*validate)(const struct btrfs_inode *inode, const char *value,
>   			size_t len);
>   	int (*apply)(struct btrfs_inode *inode, const char *value, size_t len);
> -	const char *(*extract)(const struct btrfs_inode *inode);
> +	const char *(*extract)(const struct btrfs_inode *inode, char *buf, size_t len);
>   	bool (*ignore)(const struct btrfs_inode *inode);
>   	int inheritable;
>   };
> @@ -395,12 +395,19 @@ static bool prop_compression_ignore(const struct btrfs_inode *inode)
>   	return false;
>   }
>   
> -static const char *prop_compression_extract(const struct btrfs_inode *inode)
> +static const char *prop_compression_extract(const struct btrfs_inode *inode,
> +					    char *buf, size_t len)
>   {
>   	switch (inode->prop_compress) {
>   	case BTRFS_COMPRESS_ZLIB:
>   	case BTRFS_COMPRESS_LZO:
>   	case BTRFS_COMPRESS_ZSTD:
> +		if (inode->prop_compress_level) {
> +			snprintf(buf, len, "%s:%d",
> +				 btrfs_compress_type2str(inode->prop_compress),
> +				 inode->prop_compress_level);
> +			return buf;
> +		}
>   		return btrfs_compress_type2str(inode->prop_compress);
>   	default:
>   		break;
> @@ -437,6 +444,7 @@ int btrfs_inode_inherit_props(struct btrfs_trans_handle *trans,
>   		const struct prop_handler *h = &prop_handlers[i];
>   		const char *value;
>   		u64 num_bytes = 0;
> +		char buf[16];

Please use a macro to define the value.

In a perfect world, we want some way to determine the max string size at 
compile time, comparing the max length of "zlib", "zstd", "lzo", "none" 
with extra ":" and possible level values, but we do not have an easy way 
to do that.

So a comment on the how the size is calculated would be enough, e.g. the 
maximum length is "zstd:-15" with terminating 0, and round it up to 
power of 2 for future expansion.

Thanks,
Qu
>   
>   		if (!h->inheritable)
>   			continue;
> @@ -444,7 +452,7 @@ int btrfs_inode_inherit_props(struct btrfs_trans_handle *trans,
>   		if (h->ignore(inode))
>   			continue;
>   
> -		value = h->extract(parent);
> +		value = h->extract(parent, buf, sizeof(buf));
>   		if (!value)
>   			continue;
>   

