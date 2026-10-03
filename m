Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB9B282F2C
	for <linux-btrfs@vger.kernel.org>; Sat,  3 Oct 2026 00:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790986986; cv=none; b=lb9whHX3LpmXJovPPDp/U9VhVjnQGJr9F40B0SX7o81mkOG+GVLWJBOR6WQWf82ZT+sKGmLs/nhPI13CIz+KeqIl8LNO2pkK5zO7bnB0dMKSZnEBoKX4Q+pcSMxNW5zy1TcoA94U7hB9jFREwOCb5JCBg3s4ciHio0P8u3qQIyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790986986; c=relaxed/simple;
	bh=mZXrnCgxIDPszD63BZXTsF/mM8KzeQUdXuSiPKo0Bc8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Xmug1YeNeICR5twvlchfcLFxn/meT9edcVB7TZ7bG6j0oE7tgHxodOHVdrmb9t4TpN4cM89YmyYkVm+nFBVX/ahMnJGA+S1Ck6CnONCWRzucQEamuMhiKA1z/j3AHIDo4Y1AuQ4Fda6fWQdfLG+ly9VQmziYaZvd4Elo/MORaBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=fWXeNjtq; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="fWXeNjtq"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c20ce3c118aso45327666b.0
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Oct 2026 17:23:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1790986983; x=1791591783; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=hlpEwepT4T+M/yFHsMgxum/NH81DvJqk4Iikt3e7lLY=;
        b=fWXeNjtqJC3/y+X9+uVetzvYCsBlVz/7tMaxfbS2ewcpZ2BEN/LZRXydpv/OV+0EWl
         kwwIp9N0oR1NQqQLsYLc++4gx7y3EnHJp0/0/buDt5bVielyWrCqmL0j1RInZIgHAaQE
         Kuqr3edrIrWuathyuMtH5lKBm6vAmHIE4PBzQwQDJ0XPsK9Sbd6vNqzEp3nHKT9FVblT
         RfltzomXXTXr5nDr0xPIC8AkqALgmZVpHIvKuJV8rxv0cTZ3SlZEGC4tnMpZ1PsW/2PR
         DnfKNWdv8mJnZ4kbb9P9Ae6px18uBHqzVizof3GOQIRGCL4OJtew8GuYm47NXQNUOw68
         ELWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790986983; x=1791591783;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hlpEwepT4T+M/yFHsMgxum/NH81DvJqk4Iikt3e7lLY=;
        b=PRin/2HQhCw8aop2yj0oXxDbuNl76wu7Kv8Y7Cr9bWTGy9hO4N426bNB1RDZ4leZ5o
         gLHk3QW1JSvfxl6+2uGw0DtQ0spwgmHXMh8Y1Ylh/wvuvz1s0uTGgHVE18jdg1taKDya
         1Hwpypm3OR8tiIV0b+wR5i4i6pneO1PqqQDd1E6dFulUrQDLsFTf4DRoZ4wAEkQ2nTY0
         LQ+wyPT4yVN2kRP5qna/BHJhTtQcZADpiZ7ZVZpL1eAI31EYXinzmJHbssM8WMLpg0h5
         6Uxffu7oacknyVgIzQxXc2AA1ytpFET3LeyFhMYFRlGSYfJ0tMEe46azqrMv6A1MQvlO
         saaw==
X-Forwarded-Encrypted: i=1; AKwUvBzkKlkoGyQopcNRZ9UMFbPZ+o6vGWMUvyXYHkvoRYdeaXPiOFF9iWy0vu9hREWdL8pHyK0PSkT3TIR75A==@vger.kernel.org
X-Gm-Message-State: AFuF++lIgoRENkf0VUtX5Q50H6H7WDmbXfgPHXGPbpcOhMSn6kmlukiP
	mbaD20cHyoWPR6Kgh6I5gD65kqOxvaKOFuoGIZiSqFqj/plbQMHuL+MH7nut237GeBZNEGCFs43
	cnCQcfUk9AA==
X-Gm-Gg: AYBFou02XdxcrfmRHIQAG6RAEa4c3LoLqsDxIf/KpIrEUbIMGstXXbyIOsOaP36nNHo
	wjF+jFIR2T4YeF8h9ViCxlrFHBTLe4zoloB6JQEV9c/IMmrHr7HGOFwy7g4TB3al2quHXvbuawK
	r2ZCZWfWfOAbjgGMB+A95jUimOuZJOIcVpbaXNb5X046pX4Ek/uM6vg78a8PZEJX0PoCPmxwt5X
	7Kc+xOh0oe1Pqhpi7nmAQ42500KxHS71e4tnqKdY7oXOGQbws+onCBIstFrQK3P0NJte+2WSrEo
	1hPSt1GeMdE/1aDvmRyDFsIBJmLPkpc8/6JOLDXQOyfTqCZHX+trcncyVJPuc/rR9d+b6ovJ+Tl
	1mqGMaAU9T3RO55wvR5Tek0RKsJGfkc49c+1p6GELLiylBSjdp2FoZbRxJVqUTBimCfEjSIdltH
	YWEOhV0OyubShaIrVc7d35X3/4NgWcSVHTjRbQpZRULmLGnjdCJhAbr/CUsHbfJ3o=
X-Received: by 2002:a17:907:94d1:b0:c29:519b:3aee with SMTP id a640c23a62f3a-c2e340e2e71mr622447766b.33.1790986983356;
        Fri, 02 Oct 2026 17:23:03 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc9f739a977sm1527933a12.26.2026.10.02.17.22.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Oct 2026 17:23:01 -0700 (PDT)
Message-ID: <88b6530f-9345-49a7-9793-8cdf4ca57fab@suse.com>
Date: Sat, 3 Oct 2026 09:52:55 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/6] btrfs: abort transaction on qgroup failures in
 create_pending_snapshot()
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <cover.1790967259.git.fdmanana@suse.com>
 <2709bf35200a66c31d1523ab2bd76def4ffbdeeb.1790967259.git.fdmanana@suse.com>
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
In-Reply-To: <2709bf35200a66c31d1523ab2bd76def4ffbdeeb.1790967259.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/10/3 04:25, fdmanana@kernel.org 写道:
> From: Filipe Manana <fdmanana@suse.com>
> 
> If we get an error when calling one of the qgroup functions, we jump to
> the 'fail' label without aborting the transaction. This is not a bug as up
> the call chain (transaction commit path), we will end up aborting the
> transaction. However having the explicit transaction abort in
> create_pending_snapshot() allows us to get a stack trace and log message
> that tells us exactly where we failed, useful for troubleshooting, and
> also adds consistency since in that function we abort the transaction in
> every other error path.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/transaction.c | 15 +++++++++++----
>   1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index da4ffa7bda00..fcbcb4a208be 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -1920,14 +1920,21 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
>   	 * To co-operate with that hack, we do hack again.
>   	 * Or snapshot will be greatly slowed down by a subtree qgroup rescan
>   	 */
> -	if (btrfs_qgroup_mode(fs_info) == BTRFS_QGROUP_MODE_FULL)
> +	if (btrfs_qgroup_mode(fs_info) == BTRFS_QGROUP_MODE_FULL) {
>   		ret = qgroup_account_snapshot(trans, root, parent_root,
>   					      pending->inherit, objectid);
> -	else if (btrfs_qgroup_mode(fs_info) == BTRFS_QGROUP_MODE_SIMPLE)
> +		if (unlikely(ret < 0)) {
> +			btrfs_abort_transaction(trans, ret);
> +			goto fail;
> +		}
> +	} else if (btrfs_qgroup_mode(fs_info) == BTRFS_QGROUP_MODE_SIMPLE) {
>   		ret = btrfs_qgroup_inherit(trans, btrfs_root_id(root), objectid,
>   					   btrfs_root_id(parent_root), pending->inherit);
> -	if (unlikely(ret < 0))
> -		goto fail;
> +		if (unlikely(ret < 0)) {
> +			btrfs_abort_transaction(trans, ret);
> +			goto fail;
> +		}
> +	}
>   
>   	ret = btrfs_insert_dir_item(trans, &fname.disk_name,
>   				    parent_inode, &key, BTRFS_FT_DIR, index, NULL);

