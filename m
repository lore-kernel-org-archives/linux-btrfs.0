Received: from mail-ej2-f18.google.com (mail-ej2-f18.google.com [74.125.228.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E563E4A3843
	for <linux-btrfs@vger.kernel.org>; Sat, 26 Sep 2026 21:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790457743; cv=none; b=FkcT49pxAWF38rAr7XL9wTYXb81v8gAC8PBCAU3NIjKBmcYJ8FgyCNBIbmMiBwaEPgX56nT20to/62ln0sWrfTmZd8aOa0mOUAN3ccJqVaUcSpSRNRHNr/SBtHbrWcQdene+vkEpBrZ2YwmNIfzvJB0YU0+bPp3XJ4PdKARGIXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790457743; c=relaxed/simple;
	bh=2mTri71uNiEmsPH+mMJhT9tNhiUgh8M0ciZBOp6m704=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OGejsKPG4iM5PtIfSfVatFtN/jh0+o+oAXlEZq9/dHvowrZMpHCuG1DjVi593R/WicjSkgdtNzxPF8urT9qmOxyGVTetQv61g70pqMZQab+Bi+6lRxYR/DKIbvG7k0pRY/sh4moESfuqN/1l25zaSahmbxBeN7pp+uHZes5rtdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=NUnx0KhI; arc=none smtp.client-ip=74.125.228.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="NUnx0KhI"
Received: by mail-ej2-f18.google.com with SMTP id a640c23a62f3a-c2b40e4744eso119058866b.2
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Sep 2026 14:22:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1790457737; x=1791062537; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=skUUnKRXWcm12ROw8/UiYVb1bcscz3HcOKZ3b17jq10=;
        b=NUnx0KhIBLr7/13BZeQgyBhqR7jcKzwWbcRD43EwK5F9dPCyEEyMp9oF77kVdTCero
         NVvFbsQgn9NrZ8Pap9Zrz7ocFQQMc82NE3p+PoaBSU/K20rH+f+qnuzEBBUXBWPAoQXV
         xSSqFCS8w9a0Ur2AH3BOJ8wg6dEA1v1bh0+rEGEsCBkrXqWoJUAFyOcktmTEMw3h5q1j
         xrGE+1Sxu5RyszJ2d13vd5njPe1zsBLxbCF/P52dilmGJ/gUci4aPWgKAvq/zme98KaL
         USIs5t43psGG2SMLURvIatXDeLiqKCOKWYa1rA75BhzlGRO8pW95VeM9qVjBhNQExjVu
         7Ryg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790457737; x=1791062537;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=skUUnKRXWcm12ROw8/UiYVb1bcscz3HcOKZ3b17jq10=;
        b=2JIfJ6W4VpNTHBW9Qn8uaAdN10Kspl1J/FRMZmgAo9TFdn0VQ7fl8F18zo4xa9bqY7
         TNhyyTBZDZYG0CB5lcPE+klsDftv/rI2eI8h72lw30x3oJGaYDgqX25Ak7Us4CLepSzB
         cdLLVKJgbqbV328+otq3pIsgMw3En3u0q6QADOUcXDOrFtHmOMx20pMrQLkY13facPLv
         7csZwcHJIZaHxco3haMkSMe7XwHY503uKnViPhXCWl2cy/zVHBP6H0OCd9yW0oX0EBgK
         IrK48TXpmFQ3f1swzb5ZgzxfZmHGddB9beyRPjmWsm/lieMdaH1qvGKKc0mtvXQcbBsA
         +Ghw==
X-Forwarded-Encrypted: i=1; AKwUvBzIMeKB4iU2tbKcB8+fAzlCGW95I5jaH6tf+onDPFTSGbCw76HdzWLrBVohdOxGmmgoCIvwGDSsLFtelQ==@vger.kernel.org
X-Gm-Message-State: AFuF++lJ9ToAIZTNVxcx0FJqif0WnyY1zCKr+LD1uxgMzFQDk9vSf2fK
	R23yvf7NFkm3cW7r4m+NI1gJonUeOc4MKBFj3GUn93UleC9Xml89zOhAYJu+djEOkx4=
X-Gm-Gg: AYBFou2PkQvkn4TMlesGVdjX1HrjtKxhXxnA4a2ped5nTJZZH07CPnAWQ/rchTY3VW8
	QI5+tsnXxV4K8vg4A6gSh2PVQwA8rGHEW120Teb3lqzU6SYPe7yPlaZNTqAsf2QdfWBDQ8vzB7L
	NMViTirqDLwO83M1efq5fzkgzdCDielaQAOqImGq2lGY7+/yJyQpBqm3jutuizP0wZtTM6CobDw
	6qPGpT54UHf+dVJqoSqNnsgf+EZe+YPNgvDcZIMNjy5ZJOHP89iY0j6TSf4IMUQ2OlBoIa4Mfij
	jaJzOILSlflLWjYWiqZDteUqqzniJwS3Pgv6rY5EWUOXDbRnwL52CmO9+jCv9abHb9ZH197+tgR
	x/HqmrEscpYAuK+2qPN0HwSacTbGSXZqMMXMXoFeM62Q7iOkIm/wlPcChZkbL04EzbwerpLSMMF
	KJmqWuHNW6NGfSjoD7REThXKzEvhSONsC0jWVvEtj7PhKVYDxyR114sFXUFqFJY0c=
X-Received: by 2002:a17:907:c317:b0:c26:1649:47ab with SMTP id a640c23a62f3a-c2ac53c3702mr751964866b.33.1790457737059;
        Sat, 26 Sep 2026 14:22:17 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc78794331fsm2678892a12.20.2026.09.26.14.22.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Sep 2026 14:22:14 -0700 (PDT)
Message-ID: <18af260e-b53e-4156-a6a3-e34d9b3b6293@suse.com>
Date: Sun, 27 Sep 2026 06:52:09 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: use strstarts() and str_has_prefix() for prefix
 checks
To: George Hu <integral@archlinux.org>
Cc: dsterba@suse.com, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, mason@kernel.org
References: <a7d68d73-3ba1-46d3-a6c9-5ee213e5b551@suse.com>
 <20260926122217.22759-1-integral@archlinux.org>
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
In-Reply-To: <20260926122217.22759-1-integral@archlinux.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/9/26 21:52, George Hu 写道:
> Replace strncmp() prefix checks with strstarts() when only a boolean result
> is needed, and with str_has_prefix() when the prefix length is needed after
> a successful match.
> 
> This makes prefix checks clearer and more concise.
> 
> Signed-off-by: George Hu <integral@archlinux.org>
> ---
> V1 -> V2:
>   - Avoid replacing strncmp() with strstarts() when the parameter is
>     not NUL terminated
>   - Revise subject
> 
>   fs/btrfs/super.c | 5 ++---
>   fs/btrfs/xattr.c | 3 +--
>   2 files changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index ddb620ac241b..287cdc45bef8 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -263,10 +263,9 @@ static const struct fs_parameter_spec btrfs_fs_parameters[] = {
>   
>   static bool btrfs_match_compress_type(const char *string, const char *type, bool may_have_level)
>   {
> -	const int len = strlen(type);
> +	const size_t len = str_has_prefix(string, type);
>   
> -	return (strncmp(string, type, len) == 0) &&
> -		((may_have_level && string[len] == ':') || string[len] == '\0');
> +	return len && ((may_have_level && string[len] == ':') || string[len] == '\0');

For this call site, both strings are NUL terminated so there is no 
problem about accessing beyond boundary.

But to be honest, I don't think this improves the readability.

I still have to check what str_has_prefix() really returns to understand 
the code, as the function is not a common helper and just by the name I 
don't get what if it will return.

>   }
>   
>   static int btrfs_parse_compress(struct btrfs_fs_context *ctx,
> diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
> index ab55d10bd71f..9011d8096e2d 100644
> --- a/fs/btrfs/xattr.c
> +++ b/fs/btrfs/xattr.c
> @@ -239,8 +239,7 @@ int btrfs_setxattr_trans(struct inode *inode, const char *name,
>   		 * block_rsv of the handle and trigger a warning for the start
>   		 * case.
>   		 */
> -		ASSERT(strncmp(name, XATTR_SECURITY_PREFIX,
> -			       XATTR_SECURITY_PREFIX_LEN) == 0);
> +		ASSERT(strstarts(name, XATTR_SECURITY_PREFIX));

@name is not NUL-terminated, thus even the old code is not safe.

The only thing saving us here is that we should have a security XATTR 
passed in, thus the name must have the "security." prefix and not cause 
access-beyond-boundary.

Again, I do not think it's a good idea to use strstarts() with any 
non-NUL-terminated strings.


>   		trans = current->journal_info;
>   	}
>   

