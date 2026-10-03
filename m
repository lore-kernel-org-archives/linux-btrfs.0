Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9710718DB1F
	for <linux-btrfs@vger.kernel.org>; Sat,  3 Oct 2026 00:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790986779; cv=none; b=hvqyhJ095ybREdtV+OJwaQyZAvDsmpf4xafcc4aU8NQpUenzKOVfZPKgdhMDWlrtxz9Bq+z+c4BoBue1dLAKyufF4XH15q2ESJiV77PXJvHRRtYHd761Zm6bddJGDiEPBrW/teHVLKnp2rfZ9qwEzgMj01gON57ETog6Cezzfts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790986779; c=relaxed/simple;
	bh=Dp4cm+20XZCjHa39T+XZmndNIqW61Sr5Un2+6Ox9bgU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=g0xNlUO83IJKMXWB2LnbeVsk3SqWNJ56/BwMLM9/I3ZxB+sWnHkHoOkhIv3BneXVTS2WA+sCT99ktScOyWRhFD/+UqZaalWc/vMRs8GfepLcjcbqjVCpUwH3Cphq6pyWn8E7L705f98unYF4RrXG3K6F1dBUmsIjhDw+EH+JhdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=CgNxJS2K; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="CgNxJS2K"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-49d0da752ffso2281345e9.3
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Oct 2026 17:19:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1790986776; x=1791591576; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=u+qICMgCAax4iY4Cd0xQi6+wS6mleX9VHADkDIhVFB4=;
        b=CgNxJS2KCbYly7zCUl/YQInIr+74d3zxVlGnmwPBO8ekZvjuU19kN9cA/wyffh23qD
         +iCMij1+1Qkq6Q3gR3qNSYJIPgcWhM+ayNzK8O+AX0prkqKQWpilDupSNRTPc/BtJyh7
         yAj6qQTpkPMSzhyf39O5D9zcia1rlXUjAyoRH4HRkpPPs+4Ms9iViqQTAnv1e31FdZ5g
         x2phfNpHBRDnmWwWRK8cAgj+YIQcGxIqr2b5FrCvtQVbW1q6Or9Go/uA82p3SdfpjlQf
         V9uEnj3/PX0APbXs7T98nsIs+qm3IXFCeGlW4EptuaiE9seyHCodLkcHzjBuK3WDsu2b
         5JZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790986776; x=1791591576;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=u+qICMgCAax4iY4Cd0xQi6+wS6mleX9VHADkDIhVFB4=;
        b=JPauvR679dVq9kmVLSilTwxDUK1fA5yIEaeHF4HM2GZ5GN5m2qVemLryZNwThuT1n3
         Nv6tOk1waYqXpIGjM2TG7EQ0YJSrLgSqdAOp/MMQGpuyuXkGOhwsNZ0MeE2AWt8/3a9V
         5N3EJXf34Q6+SYqB3l3wIDHNjgpKlxIiKVBBCG+XVYoBCnXJgyMk2GhS5TimHRU8cD2G
         RuJ88Ayje1D/1yEOs7fSrJoR2BIF1RuGYlzr+pI+PWIvDiQS6Lu6sky8lJoLGOSvKzd6
         oMzV4oE99XWrF0aGhPWEIFgIy3aTK68vnct9Xx2sW9M4wFm9GIabrolMHMqC85SqIpQv
         QWkg==
X-Forwarded-Encrypted: i=1; AKwUvBxp1Rcyl726oi9DflLXkVa32es4gnkdNDScz+KZaVgaE9YNJM/VXr30M9tRi1iAsj7tCmUZ1Jx/u6xH1g==@vger.kernel.org
X-Gm-Message-State: AFuF++mwQOo1FSCt+FR4wDEstw+/87KqrF10INjN4VTMLSLonJ/+Lpsr
	lLqzbu3e1xuWokK4b+N0nDCCIYxtWOZ1eBvfhPaiDSIwYYH6HtjG7XpboItLh5xICXKhygKVsMf
	dKyYFj+y+OA==
X-Gm-Gg: AYBFou128q1S1XMe8uFXgmAlIuxCdmvBdvSQ6NH3Ke5WQyEiODNn+Wy6T3z2bV33IUS
	fRH539Ki6yAqaG0zVicWhAG0AN1QHlW0SDhc3zzBfHWvGlQx5jI+CsvoR3R2GbfJi4vZ7zBIVwo
	cSNul5C77xsS1D3+89rHBhqiEI6bDqKrpG0zwAzN7FYQv8HyEUig1i2YsVBzSggCofhPZuMKT1e
	ISy/RhvZQME0KsurWIVPLoS8i3PazijAc2UFh7S4D6JEbKUNDmMUkblXz0oluxy6cAhofSphz6L
	+Ha4ES69Y1RYmnsTSxSA79d/F9l6p8pLbwONGf2/qRZLLknlXL2n7Vmr+q6Vj9G76vHJYOS0YBc
	NA9PTxAe3TM8AxrtKbbG3iuGtIsbOZ/04TcaFG86WQ3euVDZQD1Hen8hCTgW+U5QOBwwyRRJozI
	s/9UctiIptUVmnQZ15zxm+Rwx1/boL+uDktzIjpiuCk8O/PPZEPdAEWfa6foreGIHI46fcxro2D
	A==
X-Received: by 2002:a05:600c:4e87:b0:4a0:2375:dc1a with SMTP id 5b1f17b1804b1-4a1680ece49mr11888165e9.21.1790986775720;
        Fri, 02 Oct 2026 17:19:35 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a78d4a5150sm660321a91.1.2026.10.02.17.19.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Oct 2026 17:19:33 -0700 (PDT)
Message-ID: <bf6b2c68-ef2d-48e0-ad43-6e300df64aa6@suse.com>
Date: Sat, 3 Oct 2026 09:49:27 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] btrfs: qgroup: abort transaction on failure to add
 qgroup relation
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <cover.1790967259.git.fdmanana@suse.com>
 <3035da7f5be049e54d539c1bb1ee11f3f15ed878.1790967259.git.fdmanana@suse.com>
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
In-Reply-To: <3035da7f5be049e54d539c1bb1ee11f3f15ed878.1790967259.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/10/3 04:25, fdmanana@kernel.org 写道:
> From: Filipe Manana <fdmanana@suse.com>
> 
> When adding a qgroup relation, if we fail to add the relation item from
> "dst" to "src", we attempt to delete the relation item from "src" to "dst"
> that we added just before, however we ignore the deletion result and if we
> failed to delete we leave an inconsistency in the quota root. So check the
> result of the deletion and if it fails, abort the transaction to avoid
> persisting an inconsistent state.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/qgroup.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 798f21608de5..4b6c82a24bc5 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -1616,7 +1616,11 @@ int btrfs_add_qgroup_relation(struct btrfs_trans_handle *trans, u64 src, u64 dst
>   
>   	ret = add_qgroup_relation_item(trans, dst, src);
>   	if (ret) {
> -		del_qgroup_relation_item(trans, src, dst);
> +		int ret2;
> +
> +		ret2 = del_qgroup_relation_item(trans, src, dst);
> +		if (ret2 < 0)
> +			btrfs_abort_transaction(trans, ret);
>   		goto out;
>   	}
>   

