Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B7236E47E
	for <linux-btrfs@vger.kernel.org>; Sun, 12 Jul 2026 05:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783834107; cv=none; b=BHKvv8e5CHpAevxKNkCkstKjyZ9IinUvOVSUwba0ZLP3TG4RdMQ8WXF1BXL7FWS+tQlsQSC8h50ypgFCItdpPGty95RFAP//XIMxourHB8m90DERGYL8T0ZTBkNjXX8mrrmLjJ478JS5YJD1LG5XkrvIeC9/9xX1EAH7bb3XH6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783834107; c=relaxed/simple;
	bh=nOEmK3XB/2Nv0UqKvH+Vxs5Hqf/h1+tTy8igs7+ETwU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iwIWoXawkIjIen6KqJhVzQFpyid7qjn92x5P5ruK2RRC3+2a4dW9llg+30yA96iyqEZH3yoaO5Y0bbN1oRC8889ZBlK3tyU6FqeYMZ+x86y7mqAE52+RUCs3JPDmpQ5DKY9RTEcJBRomts/5WgteVVzDpE5d3+koC6z78KWpZSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=aDiCM6Fp; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="aDiCM6Fp"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-493bfe9f886so10370675e9.0
        for <linux-btrfs@vger.kernel.org>; Sat, 11 Jul 2026 22:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1783834104; x=1784438904; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Q8PFErrnCxf8I5BwHWz04TLQefkdEzOrr9DLWjdlF1M=;
        b=aDiCM6Fpteflo+eLwqRNvPduxN60BFxuSCtuckULf4Ya/9b7d0hVFJV0JIJFmcQ4DC
         d0Nx+aQNtMMn4UO4o2U40S1mq5gd815LnaU/OT2zM0yxPVrTZorsYnpcMiaphq8xhsfV
         uBoha/chj/JQkUx5DeuuX3oS760mu76sPD7hAXIffLpreeF4CxwhncQrvtSKCPhEvyeg
         tU0VjV+rBoksvyZCPyvTLHTGqIsNwJ0PAdxQ/Mo0ytlKWkzF2+aVr2VzSmp7ZfuEQ/Bg
         NH/Cr8YWBN1zJFVlZo7LdsMuzwq8/P9RF7rrGRkOUEOFEAmuPfrm3muVGaLIPv4ivM7S
         buLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783834104; x=1784438904;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Q8PFErrnCxf8I5BwHWz04TLQefkdEzOrr9DLWjdlF1M=;
        b=Rbl91U7ZDdw/MvU47lLuU1BnM73NwIV4wUs/gcNPGyqMxKeL0zNIyBnITrQPICmqHr
         o7PPm99j36TtwTZoOF3Ty5FSHurKG+Q+vfFyMc2J+1gRv/JF//kxv/M3emfoVCaDrXRc
         SIqbsHYXNz5K6IPyDwec7D0NuiJVCj5dtuchB4f5w++I9putnHaUe/DgGOanYvaqn5Sf
         JDm9m5BHNe328Hi/nivQcaPiLhox3d0sAxyFg4tuelrcg3afYEU5e3gK2lNik60Va0ce
         VuwBYPq2d131Nm+NHW2vYurt8GCPIwotm0GgZg9MYEsExsz+FqW+T6VADhdOQFOBjU58
         FevQ==
X-Gm-Message-State: AOJu0YylrBVj/7o+MnLzvr5hkjwwyAzCB+WwgCTG1LerhGjQkuACWoZy
	u6dO0bNcnVVmkkfMCwEokPlzc3WESkW5VN3O/aSKFTbMjKjSpyCEkgvI1SEN4fctcNk=
X-Gm-Gg: AfdE7clM1chONd3LHMIeMp6WXexbWLOn3fc+wkgoAuvrH+m+Jd8ooi8PDz9i+Uxzuag
	pBOsEEVGKVd9DdcWg67VCdLXMDf48uU37dQW63SWu+nIYLncYDoeEx0xZKm1coZsWlw7AqlZQGi
	xKP5IDsW9OMJyLcqeB01wNJN1TD3RMkF4UVE6YSurrOXrZP5ccbg++EURYx45ufuvOiaygymLCE
	cv+h+XkNULh+oYBEw4yr9s4W1c1YOzLDaScLzb2NOMuZvaRmmculm/kvWkkSdqs9ClBjjSVmNoL
	g6UnmrqF3wXIFWVr7JLkBdAF2/hMDfirmGG3gfogvq8iba1PGcMQQukq7z7H5P6w24189AHmFE0
	FmFWHpW8prL75/msZN9Tu1zx3C8EiDcDtHykU1t2VBRsssEbqKd+hiOS/vcUV8xD8xGOGIYKM/R
	RK+HxZIA==
X-Received: by 2002:a05:600c:6216:b0:493:f6f0:d66b with SMTP id 5b1f17b1804b1-4940033a949mr2317865e9.1.1783834104165;
        Sat, 11 Jul 2026 22:28:24 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38a55557f25sm4847558a91.5.2026.07.11.22.28.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Jul 2026 22:28:23 -0700 (PDT)
Message-ID: <79875d25-0476-4330-b6f5-51d213cf6270@suse.com>
Date: Sun, 12 Jul 2026 14:58:17 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: free mapping node on duplicate reloc root
 insert
To: Guanghui Yang <3497809730@qq.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <tencent_39D68A519E8921206E77105E313354703C08@qq.com>
 <tencent_9F36B70488B79803AA2A9E02C52C4FC41007@qq.com>
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
In-Reply-To: <tencent_9F36B70488B79803AA2A9E02C52C4FC41007@qq.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/7/12 12:47, Guanghui Yang 写道:
> __add_reloc_root() allocates a mapping_node before inserting it into
> rc->reloc_root_tree.  If rb_simple_insert() finds an existing entry, it
> returns the existing rb_node and leaves the newly allocated node unlinked.
> 
> The error path then returns -EEXIST without freeing the new node.  Since
> the node was never inserted into reloc_root_tree, the later cleanup in
> put_reloc_control() cannot find it either.
> 
> Free the newly allocated node before returning -EEXIST.
> 
> The callers currently assert that -EEXIST should not happen, so this is a
> defensive cleanup for an unexpected duplicate insert path.  If the path is
> ever reached, the local allocation should still be released.
> 
> Fixes: 57a304cfd43b ("btrfs: do not panic in __add_reloc_root")
> Signed-off-by: Guanghui Yang <3497809730@qq.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

> ---
> Changes in v2:
> - Add Fixes tag as requested by Qu Wenruo.
> 
>   fs/btrfs/relocation.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index fb85bc8b345c..7e451e587726 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -588,6 +588,7 @@ static int __add_reloc_root(struct btrfs_root *root, struct reloc_control *rc)
>   		btrfs_err(fs_info,
>   			    "Duplicate root found for start=%llu while inserting into relocation tree",
>   			    node->bytenr);
> +		kfree(node);
>   		return -EEXIST;
>   	}
>   

