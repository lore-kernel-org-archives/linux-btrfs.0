Received: from mail-ed2-f35.google.com (mail-ed2-f35.google.com [74.125.228.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C0C35201B
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2026 21:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789768045; cv=none; b=pya6ojJEs/v54htBi5MKFqWbBJpMtaiyJ2JLq1JNAvokWP8qSpmWDsAnSbvZfoYAtvGtCvGzstthl3BP/JVEXsTpj8WEIm+lGQv6/62YN7y4zU6UDKNdHVbAthpWmXJP5suPPANRXOqHooFZCrYtb+HUoKsUkDgXkof1a51f/V4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789768045; c=relaxed/simple;
	bh=Ds3zOmDxokP2drk9u1iVJBf5FyWeNnUj4j/CawtEzBA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=jtFYNIU9WiP5JjSd/sjMYIBmBU7bcAPKUDQAae0Dr/J/ivGNAmc8qKdEBIR98X7E0bgqjJ4uaWq4IPp94yX1a/GMt2WYLvmDtx51RiUDY+44EG/3MtbltkZz5V0hMFKUHCXhHQEXkrLp7vmQ0ZoXEkVuexhTqlAlY8AS/Wjv+Ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Qyqu7e/i; arc=none smtp.client-ip=74.125.228.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Qyqu7e/i"
Received: by mail-ed2-f35.google.com with SMTP id 4fb4d7f45d1cf-6a6056ac81fso1984974a12.2
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2026 14:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789768041; x=1790372841; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=eH+RioRZ5RkDMU7w4RjfhJh5nWeMvS/VcsAp541LK/g=;
        b=Qyqu7e/ik3SZ8UdZnKkCyHWHuE02uoSBKxAQDY0cG/0WY9farV5bQZ76H3ZfelSNkJ
         S9/00cuCYkka0FhohXP6rm3hxiVFiJV7iX0fFC4YrkUEeRLp0TYXEG1ONAQkNoa3L78v
         MThUOHVz6czZ218ivGIrnnzIITZH+SJ8HiV9GWJNLBN8pn31zuAuEKYNlsvv4Ylc+0jv
         QpturXbDMLZBWM29QLoGE1jlsPYPQ7SUWoRUhH3xBX/1Korb8XWhDr3hObOuHRRAs0uR
         qji7HBdCsDpO57svZStRuf5Ywe8cTbEKvHIdxVfEO+ronL+nqxXP8tBmOibOSjzdri3Z
         HHcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789768041; x=1790372841;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eH+RioRZ5RkDMU7w4RjfhJh5nWeMvS/VcsAp541LK/g=;
        b=maaaxrY//63OGqAXyoZsG0iOc0orZABvcPB+mSAPMzjOxdOd9GyYCe0BIz/U7exDCn
         kDRmWG9XijTmyvmhlP5IW+DBGT0a7+ZKlw5v5f05yYGxzOn18orWvoWJR1VNy8zpdaU2
         MxtYMJwBp8+a05WxtxSkSwdwMkNlvrldQ8jAakpXIwHSpireVwsRP0yPaqRLhNE8Kb1i
         ZqkanflOGygBf3iNf3ywLvlgigKlZRbhOCfO6KBoEFc/7kmNfwtyLoSSrlBVQYEQfhn0
         3kHAlKaZAm13bFLCcex45DCW/3nd7HhRiRI2fttbnOdKBMUpHtLtKrgsbOKu3C2aLGz7
         GvNA==
X-Forwarded-Encrypted: i=1; AKwUvByzC2JBkg5REiOl9k+v8jOXSDI6OcpLc5jvYCPVmG31k/hvS4QIGQ+at1w0WctWW9gne/EhgrbZqMh2Xw==@vger.kernel.org
X-Gm-Message-State: AFuF++k7zxTTBb9FQTiaNzPkhHU/8yRSRhjpKYE/yUajzyuqUfUnKntG
	XNSK78w191gwbI0ZDXVNfhkTFK3J2ewJ6o6Xu5/rev7kkPbawHw542l6D/5hOZunIow60AU9WBk
	8ELM4jRs=
X-Gm-Gg: AYBFou38Pxi2oAaIMu1ODkzbIV8e0FT9ufAcG077xSJrRCETigAgNJKaPzMmKabQVC6
	1uKw/aCRjDqv9z66aN1OOucoF+cjggAHFgIhPAnVNCJ5fjjlNIMqql9AwzCsat02mGpGVQ1q99k
	RZ/xOZ/ME92WbyHwHoR/Togv2YWLHZUIjJ6OsiSvEgUiK2qJxknJ9mLLo/VSR3Z0W1vovefTznM
	KxeZ3ILImb4/RpmRg2aJm9nThGK0pT3aKy6cLaWYY73tnyD35IGkuHljDvDrpMhg+V2RRz+d8py
	V4tvMsYFfUQRZmKUwktCbbPATGse+2jBxFnvnrm/qGHXBN6xW5ka2gAKjEzwYsolp5eH8iCFICC
	oQLvYFlynVmHtwG453I56CKnzmO6cowIHpm6qu1XkNyqWe7mHCk3gWnqlbYhWh9yCIZ39ci87Ki
	VkNfE717NxTxd8W1jhaBO93sMnUC6p+k5xBPzE1O+9OHmeB543UjVWH10GYHT1eLI=
X-Received: by 2002:a05:6402:440a:b0:6a8:e223:fee1 with SMTP id 4fb4d7f45d1cf-6aa531e36ffmr2951969a12.43.1789768041635;
        Fri, 18 Sep 2026 14:47:21 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ddc179e253sm2070185ad.41.2026.09.18.14.47.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Sep 2026 14:47:19 -0700 (PDT)
Message-ID: <5a5fd42b-6949-4830-a8f5-72f584e7a098@suse.com>
Date: Sat, 19 Sep 2026 07:17:16 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] btrfs: assert reloc mutex is held in
 record_root_in_trans()
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <cover.1789734239.git.fdmanana@suse.com>
 <3fb8cf7a662a1612840b482754429fd3f5f3aaf2.1789734247.git.fdmanana@suse.com>
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
In-Reply-To: <3fb8cf7a662a1612840b482754429fd3f5f3aaf2.1789734247.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/9/18 21:58, fdmanana@kernel.org 写道:
> From: Filipe Manana <fdmanana@suse.com>
> 
> The fs_info->reloc_mutex is supposed to be held when record_root_in_trans()
> is called and we mention that in a comment inside the function. Add a
> lockdep assertion to check the lock is held.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/transaction.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 13203ea9e116..0a3913b61f16 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -413,6 +413,8 @@ static int record_root_in_trans(struct btrfs_trans_handle *trans,
>   	struct btrfs_fs_info *fs_info = root->fs_info;
>   	int ret = 0;
>   
> +	lockdep_assert_held(&fs_info->reloc_mutex);
> +
>   	if ((test_bit(BTRFS_ROOT_SHAREABLE, &root->state) &&
>   	    btrfs_get_root_last_trans(root) < trans->transid) || force) {
>   		WARN_ON(!force && root->commit_root != root->node);

