Received: from mail-ed2-f12.google.com (mail-ed2-f12.google.com [74.125.228.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D45C2E62A9
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2026 21:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789768031; cv=none; b=ESRGooaN0iiEwAE2cJG1Rzag+D8JEgIJkT1XSFoJWqQr1jGo12SB+NKgFj+FnzcrZsBWxhrKL9kG/wOkZYbcXC9KMWiuvfqv3Y6/0qwrc1sxL01HlL+421yYwmK2fOw1ETeDRmT+ieNlsdowH79GCwvorlr/odFV9ep7yjFUZis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789768031; c=relaxed/simple;
	bh=Q/NdhQnMQ9/VsWXEIcPbW4xL31vkR1NUAQBvh6/3cpw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=u15O/Ai9gEoQZviP4X+2DWPNLCE1XPJT0Rw4V+p4J4TUzwsNHisgMyAkyrRCVIgpNV8sKJB0c1U9vjWg6fMJfqse414R1+lXrgG4ALw50FKuE1oCIpV779Xh0PQIKPt+VvboVSUwePh3WScLKF5s/rnG/Riy3p6h0/FdqHKGQzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WKA14ymR; arc=none smtp.client-ip=74.125.228.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WKA14ymR"
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a996c8adf3so1881261a12.1
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2026 14:47:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789768028; x=1790372828; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=87XH0Nypzn1s/HuP5xzyU6MpT7gXSg9cDLAye+I2x6M=;
        b=WKA14ymRCfmeRrMTvQfaNUnMu9Y2xoaePhAxtBFPrObfH6Fd7dDfAYN30pp5+d3rU5
         wyHK0YhoE0zzSZEIzUjKhPZ1qRLSvg+UfeWVkVg8nddhxpQVn6CHykmgnTO9gg1zD5Gl
         mGMY4jFeTkwY6wVV/AHvWWT3UBMQoyK5sl8ct3rL76opxmGWOqZxvWx4UwwuFssqoOUu
         DOZJxoL9LZTVX1Iv1xHsGVIi7cH769h2JCsaEIiTLl2vpCQVFyFfpiaP1jGH+MbyPQqc
         gfkMaebcn3ACoBZajKakVnKP86KQbYttjTNZLIWQVuU3Zplfow8HQEzkM/r7F5FN83Af
         zBmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789768028; x=1790372828;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=87XH0Nypzn1s/HuP5xzyU6MpT7gXSg9cDLAye+I2x6M=;
        b=0A+WBxldz5zGFXkE0FveVQOK3zQqJw9j2oSEczwRInZOyNLcY7hUApo6ypn71I+Du7
         bBaNUUmRnp/bgdk6atA7ZsYgDsEZp0qb0+t4JRkIfaqfHXcsdiiLVieVCbSOWNHHWJgF
         eBelyqYo3hX8WcoHhGT3isQ2Sn2uhJ0kHIbJycgcGt9cCXlAiu4Wo3PM/IbeS9liDRs5
         GQkaRE1Egq9lw35TORxEkDSvThSRlmxkvh00y9rCRLNpsbg9G3t0C55Jx3EkutvSCRdS
         ZbDiRKzeMgxMBB533Hd59Dxppfc4M0aXfFuf5mEBO3r+PXWYYAvHObiUerOuFHJbcH+p
         PQCg==
X-Forwarded-Encrypted: i=1; AKwUvBxqNaQL+tlYg8PkT4soCiVrpdRSUHZWtuQLHfuEdHugemEcuLVon+tNexuBEqa0ueBXychbqUZMJ1FZeg==@vger.kernel.org
X-Gm-Message-State: AFuF++lLIgCx5Fo5dZ9JqCUykInyBAt06IAOVcTG0dNzmAxOqNnNQdNN
	RjbUxw2RbGjZmc1kxLtXB7N1SKb+25rsDiVmhvZwuOMaLM8IitWhkUWl8FmaaOK2vPqJWQeESO4
	x+2znRlw=
X-Gm-Gg: AYBFou2sVvceJic+sWheDSmpUV3D10jbt1Z0PT4WsTAndmYJJ5Q4JGwz8kkX4Q0w0nf
	XDEZqRj0YAUzwQocj09ie9j+F0XSnDBSoqhLEa2PmMcqnsU85i7B2y5GLiEMR0DsGbCf70UhMA/
	2EUgvlPtfbEXYs8s+hPRjMv++/9PsHOU1RV8HG9EGo0rbMoZHh/7vAhNBl+LyvfMN3hxgoi6eaY
	Zp0/qoz8Go/goxQwHn1gJYu+P6NCHHjT4RPb0XwiOcV7zTPq8l5cMNkOKx6vXmkqLeSG5I1LILE
	hCrxyuNgb8BZE+6sbSU0tdrKtcTypxZV8o7JVCO8xpq3pydrI3+qwhbIaiaFOGVVBaODaAWAVI/
	gUF4NIgMRpdLMzH1xRmXc+vwktcGDtIFOgYWd4EL0xnHywdr4QUoJhhOW1EZrstKF/p8kC4A4sS
	EngAseN1np+d3ZWFrm7jJW59NWVqFbi1Zl5252+39RClPkU4MCS0jZuWbqbsdmIrY=
X-Received: by 2002:a05:6402:158e:b0:6aa:19bd:dc9d with SMTP id 4fb4d7f45d1cf-6aa526f8035mr2522754a12.13.1789768027550;
        Fri, 18 Sep 2026 14:47:07 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e6fb75539sm717966a91.3.2026.09.18.14.47.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Sep 2026 14:47:05 -0700 (PDT)
Message-ID: <6ae96b86-24d0-4a27-bdb2-6c84b5918745@suse.com>
Date: Sat, 19 Sep 2026 07:16:59 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] btrfs: clear BTRFS_ROOT_IN_TRANS_SETUP on early exit
 from record_root_in_trans()
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <cover.1789734239.git.fdmanana@suse.com>
 <410734082c3a544458920efe7be7a39222424aeb.1789734245.git.fdmanana@suse.com>
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
In-Reply-To: <410734082c3a544458920efe7be7a39222424aeb.1789734245.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/9/18 21:58, fdmanana@kernel.org 写道:
> From: Filipe Manana <fdmanana@suse.com>
> 
> If we exit early because the transaction that last used the root already
> matches the current transaction, we leave the BTRFS_ROOT_IN_TRANS_SETUP
> bit set in the root (which we just set right before the exit). While this
> does not cause any functional issue, it makes callers of
> btrfs_record_root_in_trans() always lock fs_info->reloc_mutex and call
> record_root_in_trans() for nothing, causing unnecessary lock contention.
> One caller of btrfs_record_root_in_trans() is start_transaction(), used to
> start new transaction or joining an existing one, which is a hot path.
> 
> So clear BTRFS_ROOT_IN_TRANS_SETUP on early exit.
> 
> Assisted-by: LLM
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/transaction.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index ca114235bbe1..c1555621ae4e 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -432,6 +432,7 @@ static int record_root_in_trans(struct btrfs_trans_handle *trans,
>   		spin_lock(&fs_info->fs_roots_radix_lock);
>   		if (btrfs_get_root_last_trans(root) == trans->transid && !force) {
>   			spin_unlock(&fs_info->fs_roots_radix_lock);
> +			clear_bit(BTRFS_ROOT_IN_TRANS_SETUP, &root->state);
>   			return 0;
>   		}
>   		radix_tree_tag_set(&fs_info->fs_roots_radix,

