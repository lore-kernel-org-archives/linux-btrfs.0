Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD47F473C84
	for <linux-btrfs@vger.kernel.org>; Wed,  7 Oct 2026 09:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791367171; cv=none; b=MzFnLvwRtT32NbMqEHxlXsKY1qwszcjIfs7U1opMklnLAxSCgSK6cbErXmWsw3h3Q5lKbOQqaw1Knur6m738xm3svnFSA7brN7NP2WuAWwKjImMVTTilyX6MNFbFLwiV1KS6e7+HK8Qxk2pb35cBKeFPMf0jjloqxdsbG6x6prk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791367171; c=relaxed/simple;
	bh=7bGn4hzYuOiNl03NQRVJsJ8Gc8tm3kDOThzL5Ps6sac=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=bNT/H/eRISC+1VvSm0pcUPmgISyF9E40Ss5bF/n+VK04ghr19WM7EL/i+/8iTfNTcRwbYp/In2UiSlrBFuzZ3OfMoCZk90sfTeVh6eubWqEVbFarN89UIIC0HHE/gb84Iihy1TD2HXnkj0/MXcNcmSJdm3r+g2CdalBq+fuhOqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=df7mLzRB; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="df7mLzRB"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4995b0343c1so26925665e9.3
        for <linux-btrfs@vger.kernel.org>; Wed, 07 Oct 2026 02:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791367161; x=1791971961; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:references:cc:to:from:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=sTw1DYJ/lie8TNqbfg32Xyb6W/CErQFnYS5LqwGE1n8=;
        b=df7mLzRBcHJmRZN1UZ17d8JzdKL793PmGk0bkhjaxs9huTNVOdzU6LvuNEvbi7rb8e
         fnLEQT0fOn179ZtnCsnNUX2/w2tfokXncHaBGRxizGHUS8LQxGpUIV5dOE9hKRCoubYL
         8PLYtGXkYc02H1FeqDnZRFSZoSyAPwrqwJQZU+GecM4CS0d1GDtQdk3A+Ko6dwTelfDw
         zPMZAkC/473cVS/yAZDJT8GcQB8pPboa4Spy/jncvpw4ZrFNHbOziw91I2tiyZURX5rB
         s9j8K6m6bbUHKKqJUr70MODMUVocXGpoQS6NwWeWT6DJEoBKw8KyUY732S1mWVHk6WbT
         vo/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791367161; x=1791971961;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:references:cc:to:from:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=sTw1DYJ/lie8TNqbfg32Xyb6W/CErQFnYS5LqwGE1n8=;
        b=ARr0M9X8H665J1tC8Tpf38mc8nbqm0ows9NUM7QecuCAZRWvj+9LaMCMavdeDJPfMW
         0agy65bJuI37Jyf39+9jbI+8474oCC5KNFdgsOV+c2S4uFJUVQSrgp9ZXQs01JbCLTHV
         YeHcvbSd41ras1+i2dFSpuSF/3kFSaPRGPWnd7oMun46KaYFivUhHZeZn7EaDW4T2V3b
         RX1PKgLr1FoYrseMmLC7WXk56W9I1nylasplFLv2Ysq6KPTiqYDRwEluHPkIO7FBVEmZ
         uLNko5EDBWZe1dSXYZzzRE05S4QoF71SlaBknDb+QlXK6sJ8I2aw6oprcXQjZK3xpyWZ
         auyg==
X-Forwarded-Encrypted: i=1; AKwUvBwnSanCbgAUAo8d452dSQiY9Pqi++xaTpQwpjoupOTtD0CGvGU1SxfKAWCW1n8sQjEHahPgzlK60AXMuQ==@vger.kernel.org
X-Gm-Message-State: AFuF++myDBnDKne9W/0SwZapPMXX3vAQ0EE/+bEAumMsDJpXqrJ5YZJo
	kkQVqnWBay1+lJcIfUoFey+6NUnwodUkl1P8KpcnSCWSIhLTzC+eAFRXYkos7FrU5wc=
X-Gm-Gg: AYBFou3ISXir3145czjCLgbcW/0YrmNBAZbGLNM/IEIlZMIyjTOZtKqpbXfrCVVpqeH
	WDrv6ocAfew3AqxcdyLQNflle3u9cJR/yDL/1/sopEC0h1FAXxBrUL80zaZIQuRyDx/B8FlA0Zl
	QqPc0aE2CW0RDtmQjFGAdKrDPjuv0p4bDv8EKv/zaBiN8GT/b7eHm54zumhhFeh7l/htxe5mNju
	qUp9hE3pq3R9Cwj6dcQvnxnZgwUN5W98v0Kl69yq8F9s+yvxi1ICqkhQ8PJRNm8ZkDwKtS2R0wu
	/1nUI4ir59WuK7X/fPCKfmF8mxq763YIL2AenbON+M+91YgvZilR6E9J0NAS7DHawG/8O0UbtfF
	Z0vudWtXXIX8VGsY5JuByo2dEDyaQSIoFZx9iJZLiXboV/36jqn7eGDIc8yIr/+qW9qVYZ9Ur8s
	fjw9e2TPZoZjTRTm5k8UUIuimPbJ9NxjLMLIUi5pzuFVLdkFlGn2nqZfSd6PmIKxU=
X-Received: by 2002:a05:600c:46d3:b0:49c:dada:30b7 with SMTP id 5b1f17b1804b1-4a1800d42abmr23981425e9.2.1791367160821;
        Wed, 07 Oct 2026 02:59:20 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e604852563sm7217615ad.62.2026.10.07.02.59.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Oct 2026 02:59:19 -0700 (PDT)
Message-ID: <55739226-436a-42c3-a5fa-c699b01f819e@suse.com>
Date: Wed, 7 Oct 2026 20:29:14 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: fix use-after-free on quota enable allocation
 failure
From: Qu Wenruo <wqu@suse.com>
To: pavankumaryalagada@gmail.com, dsterba@suse.com
Cc: mason@kernel.org, fdmanana@suse.com, shuah@kernel.org,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzbot+947286c775f432b073a8@syzkaller.appspotmail.com
References: <20261007090656.20609-1-pavankumaryalagada@gmail.com>
 <4851139b-6cd0-4b1a-9a6e-1af947d49098@suse.com>
Content-Language: en-US
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
In-Reply-To: <4851139b-6cd0-4b1a-9a6e-1af947d49098@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/10/7 19:47, Qu Wenruo 写道:
> 
> 
> 在 2026/10/7 19:36, pavankumaryalagada@gmail.com 写道:
>> From: Yalagada Pavan Kumar <pavankumaryalagada@gmail.com>
>>
>> The quota root remains on the transaction's dirty root list when
>> kzalloc_obj() fails and btrfs_quota_enable() releases it without
>> aborting the transaction. Later add_root_to_dirty_list() then accesses
>> the freed dirty_list, causing a slab-use-after-free.
>>
>> Abort the transaction on allocation failure to clean up the dirty
>> root before releasing the quota root.
>>
>> Reported-by: syzbot+947286c775f432b073a8@syzkaller.appspotmail.com
>> Closes: https://syzkaller.appspot.com/bug?extid=947286c775f432b073a8
>> Fixes: 8d54518b5e52 ("btrfs: qgroup: pre-allocate btrfs_qgroup to 
>> reduce GFP_ATOMIC usage")
>> Signed-off-by: Yalagada Pavan Kumar <pavankumaryalagada@gmail.com>
> 
> Reviewed-by: Qu Wenruo <wqu@suse.com>

My bad, Sashiko exposed a valid but very rare race that the temporary 
quota_root can be added to fs_info->dirty_cowonly_roots list.

This requires enough subvolumes to make quota_root to be higher than 
level 0 in the first place, which is not common but definitely possible.

Although all readers of fs_info->dirty_cowonly_roots won't be reached 
after the transaction is aborted, there is still a very small window 
that another thread is already holding a trans handler just after the 
transaction is aborted and the quota root is freed.

In that case the other thread may access the already freed quota_root 
through fs_info->dirty_cowonly_roots->next.

I'm afraid we need to call list_del(&quota_root->dirty_list) with proper 
trans_lock hold during error handling.
> 
>> ---
>>   fs/btrfs/qgroup.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>> index f68b696b4bf7..42be06675c90 100644
>> --- a/fs/btrfs/qgroup.c
>> +++ b/fs/btrfs/qgroup.c
>> @@ -1204,6 +1204,7 @@ int btrfs_quota_enable(struct btrfs_fs_info 
>> *fs_info,
>>       prealloc = kzalloc_obj(*prealloc, GFP_NOFS);
>>       if (!prealloc) {
>>           ret = -ENOMEM;
>> +        btrfs_abort_transaction(trans, ret);
>>           goto out_free_path;
>>       }
>>       qgroup = add_qgroup_rb(fs_info, prealloc, BTRFS_FS_TREE_OBJECTID);
> 

