Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C20254785
	for <linux-btrfs@vger.kernel.org>; Sat,  3 Oct 2026 21:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791063366; cv=none; b=i5uCFsbVoJplTO6GWbr/PwM2m9u+7sXxOyO2gCVgqAf/zMNFok8hVSzhwt6Xkb5xxkLG12gctHAOXgM8Hw9k87tuZbpX+sXxHj8yIzzJNfN0QbLPKU47lyzcPy2Go2AhCXasy+sbV0JiSfchn6yz9Buq3+dC37KFi7WtwlB96Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791063366; c=relaxed/simple;
	bh=DJxW2wfDu6bubPRDIyjz57zvXFjJOi5njIStX2VsVtU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=rNnpJ8lm4neqhrQO89v70fEeuyuDj/lihpiCHL1h2r4WLFks4U7XAafVORUpzMTetypvgcPsm9rMgohWjL3F228DzQmAwtzGr8F5PB6rmJa0O+bRAfRrAUpaO7hUjptXmFWr37Ek+TOJ8g7vNRIO1juhpJKw8FzS8qkVqxAQh9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=TxJnWwf/; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="TxJnWwf/"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49e66390995so4731205e9.2
        for <linux-btrfs@vger.kernel.org>; Sat, 03 Oct 2026 14:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791063363; x=1791668163; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=okrz1AScyQw1sqru72c8SvlHHsLR2Z86m3kd7J6/KE0=;
        b=TxJnWwf/4118Y709g6ugb9J6vvNZjpI+kd3wNSup0VZzml8JRmOXKFinEYF6AAGm/K
         wq8zCeOGQbN1MUtmIS1YS3fRCVEZVzuY1oBPYRjOabSQ371cnkiuJw9fNcAvs2zIUjhz
         KvAFIebjk0THaD4kvOimy39UB/k4PG23nQKShTKsRsI8HJwlqA1PC+JbfkBNxrd0FyLA
         FVGVTBy2bS6xHEQ5eIXU8yxxuHJF9Cvn7w6O2V2TTHKKYgvrLY9NDJsjRM74VgT9cgxW
         QaPB3MH3+k0Q/sVGh0h8Bqx4ln4O5MjOg8+uv+5a48ddZjzXay1a6Zaz4ob2aU9I6PTK
         qFNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791063363; x=1791668163;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=okrz1AScyQw1sqru72c8SvlHHsLR2Z86m3kd7J6/KE0=;
        b=UhhnpjDJSshVQxokzwKDuyE/EIRoFyXzk75UlTC7ElQSxL3/xVqDEpSdtG3yJg+Yb0
         ytFn8aOwtNAlqZ4W4CDlGSkWcfA01k2nsO6/ofwPKaMnsEvqSaIcHmAG4as8VheIpPd5
         FU5/QffZWnvnr96Ij6Lo2Eh7bbDl8sjH5tEM7Iku7ux+YkiHkgvRGPPUPeEuwBwrPWSq
         ndIDmzjdzivEdgy0JjeGutzSji3/5YR1fvw0sBEx6XueBmXNfZWGqkS3PsciAVp8O25d
         KTEaPPbl5+LTnrRb/X52wJMqcbs5Eu1fKtb6hyJZSq75xsCvrvFCUrxs5yfhvIF64PzM
         MaCg==
X-Forwarded-Encrypted: i=1; AKwUvBwG0Ou30hFnvUO2Tr+YyhruYEtAKZ+DTpkoHRFOikvCqP/Fdxnvufo9i5S6VLRV3cifknzRT+0jE+h6vQ==@vger.kernel.org
X-Gm-Message-State: AFuF++lBX7Dqoxp/qoDmdgvqG2lnVrytOmblEUn/FF357gMfNVLGlMsy
	CP2Gzk+VCs5bolnp+MRm8arYTsulMSmO3wO8OMA6T+fbLI5VC/7B38YWrgOLq0gSIO0d6tj+TGm
	wOqgqFKSUbQ==
X-Gm-Gg: AYBFou1P3tQsChtddRjfrmhQz4JnAA2D1CUfhSX6oV++I/+odNWd7zH+DSmtEsI5S5C
	OvZ2QmIOF9letA/xuVIzxW4P3bsXDnvjK5eDemqnSCHrTFW/H/IXmKkQ0K8fgWSjDcx0ntD67UX
	RKNAmFx/QdaoxkOddz6om6B/oB375PSZjb2Jc21QOgmEZRw1rSz89+sJK7bZzvOmNxDQIwZqcRc
	lqiHeAUcOTGd2IWJDTUwYmr46prKjVYQrFsfgoQCNrjhk1DKAUGnCBZetgty2j5X4wA4FqTKf1u
	RsUdWBSmXAmfID4/A9SGORT6nDOSOu6V08OYgbEJ7/2kuA3pMYy0fD24r89PG5sNjnU7QqNTgk3
	bTkA0XjyjyXwn4OdzOvoN1IPB93rULiisVPcwVMIvLvJfUxHSw8+8cdnt9OjRDFlZH2DwxwBXVP
	05+jx8G8b5t6vWid2Z6sDAg7mYJHozt1aDarSKr+BDOlNmPAKMI7ddNfTYooN132E=
X-Received: by 2002:a05:600c:5489:b0:49c:fea3:8633 with SMTP id 5b1f17b1804b1-4a02769f2f6mr122586625e9.24.1791063363234;
        Sat, 03 Oct 2026 14:36:03 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a78e4f3911sm4214844a91.15.2026.10.03.14.35.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Oct 2026 14:36:02 -0700 (PDT)
Message-ID: <62697432-fef9-4e5d-bbe2-36e661439430@suse.com>
Date: Sun, 4 Oct 2026 08:05:57 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/6] btrfs: qgroup: fix leak of qgroups in rb tree
 after failure to enable quotas
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <cover.1791046651.git.fdmanana@suse.com>
 <2435981dcde450de7ffedc604e39168c19c2c4ab.1791046651.git.fdmanana@suse.com>
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
In-Reply-To: <2435981dcde450de7ffedc604e39168c19c2c4ab.1791046651.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/10/4 03:30, fdmanana@kernel.org 写道:
> From: Filipe Manana <fdmanana@suse.com>
> 
> When enabling quotas we add struct btrfs_qroup items to the rbtree
> fs_info->qgroup_tree, however if there's an error during the quota enable
> operation after adding those items, we exit without removing the items
> from the rbtree and freeing them.
> 
> Fix this by calling btrfs_free_qgroup_config() on error, which also
> deletes all sysfs entries (it calls btrfs_sysfs_del_qgroups()).
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu> ---
>   fs/btrfs/qgroup.c | 9 +++++++--
>   1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 4b6c82a24bc5..9f21b091c545 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -1293,8 +1293,13 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info,
>   	if (ret)
>   		btrfs_put_root(quota_root);
>   out:
> -	if (ret)
> -		btrfs_sysfs_del_qgroups(fs_info);
> +	if (ret) {
> +		/*
> +		 * Free all qgroups previously added with add_qgroup_rb() and
> +		 * sysfs entries.
> +		 */
> +		btrfs_free_qgroup_config(fs_info);
> +	}
>   	mutex_unlock(&fs_info->qgroup_ioctl_lock);
>   	if (ret && trans)
>   		btrfs_end_transaction(trans);

