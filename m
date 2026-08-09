Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED6F54652
	for <linux-btrfs@vger.kernel.org>; Sun,  9 Aug 2026 02:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786243997; cv=none; b=Q6ygXB1R/vHz9Ij5wJXEN2hXtDKwcqA4D+C8fee5FM5SuYGgdkiF6UfHfV06PSHkM9wRoahMLw3ws/ufKB9huLnfonUvCVmqt1FJxwYIV6mu9T/xDsRtveReGDiU4T15wdXSEJBbfEzgdg/6EcjeZRvv2Oq6BD9r7DDzj5oCUqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786243997; c=relaxed/simple;
	bh=bvtjhL0EzCy9RSDEnYqDNWo4ocAKai8L5ETPDsan/uQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rjFj6JoWaxLud+Nlvm7xRNYHDwFQK9cjyI9FLhqlaNmU7u0g57Lh25kmh/PK0+PBrqXiSANAkUCAl0V94VDng418fnMGD+IsFePAy71sE8WCZwQml79dVbTBGu1u4Y/Qo8IRYISshbrsGGpMgFDKhrMUyBblc4MSdFlguZUtiwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=C+SrTKjH; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="C+SrTKjH"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-49556f97a9dso4806335e9.1
        for <linux-btrfs@vger.kernel.org>; Sat, 08 Aug 2026 19:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786243994; x=1786848794; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=McAuCQ+QSVvnhVu8kZMBU8rIwlWzwRzXvDpzifBaP10=;
        b=C+SrTKjHvj5M87LPLpi0NkvNJyZP7DtquGLWsxpcL+9wOOIDeIFjx3MFLy2isiJomO
         WNWBuLU/VXXx5HEjpcDaHweryeeoAzADzFZO1TIo7A24K04+DDEa5yGGWE/SO1ufhdSb
         HXwc0gOTKgEbejJrRHVVSvh1ESD7/jsGGpUTxuuE0BE9OclYcluJji7qFZwb2FLe8OUC
         GVJ/nutlyYdnHn6r+xNosobKLSXiEh6aD8/d97hUmI68v2aaLVyPIUDT9pgj8Ndo6Bbc
         zEjDeSwvJ3/bXHUT2qploPn2e8Wqf6hPHvaK09tcybKAzAX5Ws26A45LJQfntoUtMERK
         pVXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786243994; x=1786848794;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=McAuCQ+QSVvnhVu8kZMBU8rIwlWzwRzXvDpzifBaP10=;
        b=EXY1c8lbfmuXuTrTliNelaWtoh+sTmKg60kt4BcmJeKExPKiFgQA+jdrVJjLNq5C42
         jVso2xEiafu2TwyXPqCMLjhfmh3TSrC29wf+N0nL74SFw0va6iMeARyAvVf35rsfQ/1+
         YHfHB58o/NjGkxkRYiVLxHa3f1SSpbX/qI40Wb81EvApvGjx3RHV0dLEcBQe9NOD3RaE
         fDPQrRn7I0zGb7hUs7rHdMNR7+5hX3y6Ee2soQluGIwv1/tlHbzL4Sj5qK4O7x264Hvy
         cQ76234DZkQ0tvhu+luGuYmQwpQTLUwjqeDYgFgx6Vv8WfmV05/bPDV5Zjonkj5yS+Mr
         XU+g==
X-Forwarded-Encrypted: i=1; AHgh+Roxb3qzmBPLnTrwRxD9u+gwJ4uxhMWQaqyVYnauEpfobCJx43rfjfGiPdmY5GZgqBeLtBJQtkwjcjcENg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwiExLyd/w1INowQCpQKH3bZ0SGbCT+B3rI2+HymTcpnDQHykTU
	6IPJYeoARrdxLASimKJrwRjz0rWHhSWFX+EW468B333EO7d9+k32ZPrfR6cbFHWVHTg=
X-Gm-Gg: AR+sD10DhKOo5RPU/yLA3/yPV3jjfxwgENeMxN3rpM4t4VH5g+f36kyMxNPRjTtmPi6
	EnWaVLdCvrDrMnQXis9gj3zOzfMyrP+NIR+jYFpUmrxxURh5Bky0giDUqzuQtFqN1zr0g0YKXCs
	EOJym1D3w3rN4EvCWw1LdBcN4SHfWWjBJYCp7AqqAAEzeOxx9c9wBkdBzpAmbDVRko6HUz4qkxn
	h1LmTZuIBe7vm4MS8frO84740yavniBi8sdEcd1NOWhIQCovNclP+wvH4FYNr4yFAExZZ54LGrE
	fT77gZzo9igctioMsHuYXl5pIjx3X5qhhv/9NtlEL9818wgXsjTG/tYSWOfg6OU9dlxAFbMbA22
	zTjD6VgRv+El8Q5HAsu+e4HQZTf9e9FGYtJi4rubPdlmO9OBUGhao6Ka1gZmiigYtCK0pp1Hy4z
	aRjlNjmn+9R1Rk2ynn1/I6SHzfxJVf/fzmYiWxiXODl4g7SUsoDCsfCLfGoQx45Z0jQw==
X-Received: by 2002:a05:600c:c8c:b0:496:c18c:f9a3 with SMTP id 5b1f17b1804b1-4994e79dc76mr407173405e9.5.1786243993877;
        Sat, 08 Aug 2026 19:53:13 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315beb877b4sm29303515eec.19.2026.08.08.19.53.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Aug 2026 19:53:12 -0700 (PDT)
Message-ID: <f190abba-cbe0-4ffa-a815-00286b5f0c88@suse.com>
Date: Sun, 9 Aug 2026 12:23:08 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] btrfs: also validate compression levels in
 btrfs_compress_is_valid_type()
To: koraynilay <koray.fra@gmail.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>
Cc: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>, linux-btrfs@vger.kernel.org
References: <20260809015054.779137-1-koray.fra@gmail.com>
 <20260809015054.779137-3-koray.fra@gmail.com>
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
In-Reply-To: <20260809015054.779137-3-koray.fra@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/8/9 11:20, koraynilay 写道:
> Change btrfs_compress_is_valid_type() to use btrfs_match_compress_type()
> and btrfs_compress_str2level() instead of a simple strncmp, which would
> validate even incorrect strings (e.g. "zstd:invalid" or "zstdinvalid").
> 
> This also makes the function validate levels in the same way the
> compress= option gets parsed, allowing bigger or smaller values, but
> still clamping them to the min or max supported.
> 
> Furthermore, remove the len parameter, since now it requires a
> NUL-terminated string because of btrfs_compress_str2level(); this change
> is fine because btrfs_compress_is_valid_type() is used only once in
> props.c
> 
> Assisted-by: Gemini:3.1-pro antigravity-cli-1.1.5
> Signed-off-by: koraynilay <koray.fra@gmail.com>
> ---
>   fs/btrfs/compression.c | 11 ++++++++---
>   fs/btrfs/compression.h |  2 +-
>   2 files changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index 58138f300b58..833c5f45afec 100644
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -70,18 +70,23 @@ static struct compressed_bio *alloc_compressed_bio(struct btrfs_inode *inode,
>   	return to_compressed_bio(bbio);
>   }
>   
> -bool btrfs_compress_is_valid_type(const char *str, size_t len)
> +bool btrfs_compress_is_valid_type(const char *str)

Please make sure every commit compiles, this will easily break bisection.

You're changing a function prototype and implementation without 
modifying any callers, this fails compiling.

Furthermore, I do not think it's a good idea to just rely on the strlen().

E.g. if a crafted image removing the last terminating NUL, relying 
strlen() can easily go beyond the expected string.

I think the change to remove @len is going to reduce the robustness of 
the original code.

Thanks,
Qu

>   {
> +	size_t len = strlen(str);
>   	int i;
>   
>   	for (i = 1; i < ARRAY_SIZE(btrfs_compress_types); i++) {
>   		size_t comp_len = strlen(btrfs_compress_types[i]);
> +		const char *comp_type = btrfs_compress_types[i];
> +		int tmp_level;
>   
>   		if (len < comp_len)
>   			continue;
>   
> -		if (!strncmp(btrfs_compress_types[i], str, comp_len))
> -			return true;
> +		if (btrfs_match_compress_type(str, comp_type, true)) {
> +			if (btrfs_compress_str2level(i, str + comp_len, &tmp_level) == 0)
> +				return true;
> +		}
>   	}
>   	return false;
>   }
> diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
> index e67ba47b4cdc..c63bed9f4152 100644
> --- a/fs/btrfs/compression.h
> +++ b/fs/btrfs/compression.h
> @@ -132,7 +132,7 @@ extern const struct btrfs_compress_levels btrfs_lzo_compress;
>   extern const struct btrfs_compress_levels btrfs_zstd_compress;
>   
>   const char* btrfs_compress_type2str(enum btrfs_compression_type type);
> -bool btrfs_compress_is_valid_type(const char *str, size_t len);
> +bool btrfs_compress_is_valid_type(const char *str);
>   
>   int btrfs_compress_heuristic(struct btrfs_inode *inode, u64 start, u64 end);
>   

