Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE653BBFD4
	for <linux-btrfs@vger.kernel.org>; Thu,  4 Jun 2026 23:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780614168; cv=none; b=tb3tLyy/+i/hGVdAMq1eNhfEe6pEJRf5zGLIvJ37eqEHsTXfLUIIv9KXkQm8/6BKuIWoweZHAoES3KWh/XhBK6HSaNaEzEK7c6/sfvxEuRYhJvi119MIPAKFcAXfd3eFFPQ94Fn0d7QaPJAOdQrRkXRRacC1SBsmoIyCjPSXHRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780614168; c=relaxed/simple;
	bh=Us5cQJhtCHSuyPvkztI3q7OdJzU7EiMMDFpHFdzQpPo=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=j7OgXNh+VqZ6XvWUwysdQDljXJFaM3BEdjT+NDPBbP6P786iq8ZAWcJo+pqd0/Z387gJmJSgamiRYH/B/dFpfn04ZpL5FZGugCyO6XnEnZdYje6LytY/LjTOcHdBxU61VeedBhNefhpFdHTqH/CjLoUGOW0EVuzx43HLyxsrqeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=AG9prGZT; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="AG9prGZT"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-bec449d0af2so149469066b.2
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Jun 2026 16:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1780614165; x=1781218965; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=kWvqDBEdNNwv+HxbBnj4yt4aMkP3PfL1BZmGiVQCZfg=;
        b=AG9prGZTQ/DbxCBK0nKY96Ei3kEpzc7chsS42SMT75mujaBZ0K1Lni4By40gzuXZhJ
         WpBQY5+3Da3TpHGTkOveWl6//ckeCcBoV7NwxmI46BOzuElbDvTUSdcL6+onUqrG2jR4
         wO73QEG+IAMob7iWq/00OuGEzQGejxF4V6ua3x2qo849L9uwMy+5l34829JiU20qOHTz
         0izgWXsUQeJc1LcuIkD+vPsxQIL0ztGgkPEwBvxPP3ONbkQ/n53eMJP6C20HcCvwTBvK
         ta/a+Nz3AhDIrURDgS0/lVLpXYEswYEn6IY9XlTtbzQRiEcC2z4zqD1C0iApQI7ld5Vp
         fHTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780614165; x=1781218965;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kWvqDBEdNNwv+HxbBnj4yt4aMkP3PfL1BZmGiVQCZfg=;
        b=apYDXtdPXDXU32oVIZhMA7c9qz03gLfFJOY5gWXverYB8EDtJQSKUNmWDi8fttgqVf
         RPNgpm+XruCo+APMe1CKQaaPvgK/0SHti5XTxipZ5c5R/C3HlSDEJNrvUMluQi4wRiJE
         4GgfPubIhQRfYwIDwvrseYZdLhYk7qlRACPbM5jkMUo709rUC4lcGTpQVxLuhPL8egTx
         C9BgbfU0Nefq6M29ertqasnGDzdkLxQnm0NQzS95r4/Q31HayhBp4cjP0lcE+BBlFcO+
         noI4mL9Fqdeg3SMH4YnRtfOBPmhH9pAE8ZFoIluQoVmn9UVD6pUJ83f4+ZRzukz7jBYu
         0jtA==
X-Forwarded-Encrypted: i=1; AFNElJ85sBOA7vrlID6wnXeCjRTQPwYddb3WtCUcf+WSR+eJt93TAQb/8s9JAQggHoedkT6pDA1Y8jTfq6SwSA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzY9KTE60T6+c+gS4Ev5dxEC8Wct7T9vEyZaT6VSQnX95NiWEQx
	Msf3XFYOVYvMCVGqg1wRMLi26T0DtOPPRvlyLeRyckLqV2te04J5LMI1QNrfKeIxcUw=
X-Gm-Gg: Acq92OETxlZAgb1vS1Xs+nQ08CtWcciISgTMlyc6/GQofH+Zr8ByiQaewktEKEp/hD+
	YtorABCFb2L2CadmqSzpQ0EeQTVwUka/16/jD67RoC65/psWG47rBJQx5JruO+rMypsIv3vcgku
	v2fgnEt0KWK87HTjlh4YnDQoSynWqIKLB9JXSSUVdu14QDZRXYB4ax+F+GxowRFdQmbX/8yVRoj
	Y9mdm0xaKG/YN5ISeDWOd4XvwsCaEtoElxpB5Eny2k8I050X0TIrvqVA0Ly029zP6ApwPmaYXaO
	u+4YFG8wfpOrhlTaEBZdvPe3bx/Q2DNSCHA24c2JGur2FNzy+iOTlg08FbYx18oISI+dGybWS+d
	xYyv/htd8a9JEFsEw32E6omOyXmstuoS3UTKiGxU0EcdAihTA2Re8HZEjhxA/6wxlLnK5UvsTNC
	coLx+oYf6BAEaDl0TvQT4WwLQJBZz0Pd3wLZGnEo50iFxcs74MBW4S+qsxx2Rp2tTlnhXX2CcCx
	Fcbsw0udEu4gDfxJYos4F4DFv86YpTqlGHIIjCp3Q+EBAzr05teU3Gv
X-Received: by 2002:a17:907:971b:b0:bee:965f:dcf7 with SMTP id a640c23a62f3a-bf37086a747mr37396166b.17.1780614165115;
        Thu, 04 Jun 2026 16:02:45 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36f6c668f9bsm4434111a91.7.2026.06.04.16.02.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2026 16:02:44 -0700 (PDT)
Message-ID: <8a85da40-4c7f-4366-b4da-fecec9d33970@suse.com>
Date: Fri, 5 Jun 2026 08:32:39 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: start qgroup ioctl transactions on the quota
 root
From: Qu Wenruo <wqu@suse.com>
To: Dongjiang Zhu <zhudongjiang@fnnas.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com, fdmanana@suse.com
References: <20260604085522.3872126-1-zhudongjiang@fnnas.com>
 <02849934-ca88-42a7-ba3e-a7196e1fcef1@suse.com>
 <60e3c20b-8490-41b6-8189-ea595dd2ffa5@fnnas.com>
 <f7550cda-a443-4979-b6c4-be086d23dfad@suse.com>
Content-Language: en-US
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
In-Reply-To: <f7550cda-a443-4979-b6c4-be086d23dfad@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/6/5 08:21, Qu Wenruo 写道:
> 
> 
> 在 2026/6/4 21:44, Dongjiang Zhu 写道:
>> 在 2026/6/4 17:15, Qu Wenruo 写道:
> [...]
>>> Furthermore, all those qgroup related operations (including enabling/
>>> disabling) are all holding qgroup_ioctl_lock, thus there is no way the
>>> quota root is gone halfway.
>>>
>>
>> I may have misunderstood this part.
>>
>> The ioctl handler checks btrfs_qgroup_enabled() before starting the
>> transaction, but it does not hold qgroup_ioctl_lock between that check
>> and btrfs_start_transaction(). btrfs_quota_disable() can clear
>> fs_info->quota_root and put the quota root under qgroup_ioctl_lock.
> 
> Then enlarge the lifespan of qgroup_ioctl_lock.
> 
> btrfs_add_qgroup_relation() and btrfs_del_qgroup_relation() they are 
> only called inside the assign function.
> You can drop the mutex lock/unlock inside them, change then to do a 
> lockdep_assert().
> 
> Then hold the qgroup_ioctl_lock inside the assign ioctl for the whole 
> duration, after start_transaction().
> 
> Then you can safely access quota_root without refcount.

My bad, this is totally wrong, you already need a quota root at start 
transaction.

I think the better solution is something like this:

	mutex_lock(qgroup_ioctl_lock);
	quota_root = btrfs_grab_root(fs_info->quota_root);
	mutex_unlock(qgroup_ioctl_lock);

	if (!quota_root)
		goto out;

	trans = btrfs_start_transaction(quota_root);
	/* Do the work */
	ret = btrfs_end_transaction(trans);
	btrfs_put_root(quota_root);

Even if there is a race with quota disable and quota disable later 
removed the quota_root, later functions like btrfs_add_qgroup_relation() 
will still do the proper fs_info->quota_root check and exit early if 
quota is already disabled.

But I have not yet tested this, you still need to run fstests to be 
extra sure.

Thanks,
Qu
> 
>>
>> I enlarged that window locally. If the ioctl reads fs_info->quota_root
>> after the delay and passes it directly to btrfs_start_transaction(), it
>> can hit a NULL root after quota disable. If the ioctl saves
>> fs_info->quota_root into a local variable before the delay and then
>> starts the transaction on that saved pointer, KASAN reports a
>> slab-use-after-free in start_transaction(), with the root allocated by
>> btrfs_quota_enable() and freed by btrfs_quota_disable().
>>
>> So I think I may be missing the intended serialization here. Since
>> qgroup_ioctl_lock cannot be held across btrfs_start_transaction(), as
>> noted in btrfs_quota_enable(), what would be the right way to protect
>> the quota root for this transaction start?
>>
>>>> +    if (!quota_root) {
>>>> +        ret = -ENOTCONN;
>>>> +        goto drop_write;
>>>> +    }
>>>> +
>>>>        /* 2 BTRFS_QGROUP_RELATION_KEY items. */
>>>> -    trans = btrfs_start_transaction(root, 2);
>>>> +    trans = btrfs_start_transaction(quota_root, 2);
>>>> +    btrfs_put_root(quota_root);
>>>
>>> Again unnecessary.
>>>
>>> Furthermore, the pattern of grab root -> start trans -> put root is
>>> completely incorrect and dangerous.
>>>
>>> If we're the last one holding a root pointer, after holding a trans
>>> handler, calling btrfs_put_root() can cause the root pointer to be gone,
>>> resulting all kinds of use-after-free bugs.
>>>
>>> I do not understand where you come up this cursed usage, it's completely
>>> incorrect.
>>>
>>
>> Understood, I will drop that pattern. I added it only because of the
>> race above, but I misunderstood the root lifetime rules around
>> transaction start.
>>
>> For my understanding, is the problem that btrfs_start_transaction() does
>> not take ownership of the root pointer, so the caller must not drop the
>> last root reference while the transaction handle is still alive?
>>
>> I really appreciate your review and the detailed explanation.
>>
>> Thanks,
>> Dongjiang
>>
>>>>        if (IS_ERR(trans)) {
>>>>            ret = PTR_ERR(trans);
>>>>            goto drop_write;
>>>> @@ -3675,7 +3682,8 @@ static long btrfs_ioctl_qgroup_assign(struct
>>>> file *file, void __user *arg)
>>>>    static long btrfs_ioctl_qgroup_create(struct file *file, void __user
>>>> *arg)
>>>>    {
>>>>        struct inode *inode = file_inode(file);
>>>> -    struct btrfs_root *root = BTRFS_I(inode)->root;
>>>> +    struct btrfs_fs_info *fs_info = inode_to_fs_info(inode);
>>>> +    struct btrfs_root *quota_root;
>>>>        struct btrfs_ioctl_qgroup_create_args AUTO_KFREE(sa);
>>>>        struct btrfs_trans_handle *trans;
>>>>        int ret;
>>>> @@ -3684,7 +3692,7 @@ static long btrfs_ioctl_qgroup_create(struct
>>>> file *file, void __user *arg)
>>>>        if (!capable(CAP_SYS_ADMIN))
>>>>            return -EPERM;
>>>> -    if (!btrfs_qgroup_enabled(root->fs_info))
>>>> +    if (!btrfs_qgroup_enabled(fs_info))
>>>>            return -ENOTCONN;
>>>>        ret = mnt_want_write_file(file);
>>>> @@ -3707,11 +3715,18 @@ static long btrfs_ioctl_qgroup_create(struct
>>>> file *file, void __user *arg)
>>>>            goto drop_write;
>>>>        }
>>>> +    quota_root = btrfs_grab_root(fs_info->quota_root);
>>>
>>> The same.
>>>
>>>> +    if (!quota_root) {
>>>> +        ret = -ENOTCONN;
>>>> +        goto drop_write;
>>>> +    }
>>>> +
>>>>        /*
>>>>         * 1 BTRFS_QGROUP_INFO_KEY item.
>>>>         * 1 BTRFS_QGROUP_LIMIT_KEY item.
>>>>         */
>>>> -    trans = btrfs_start_transaction(root, 2);
>>>> +    trans = btrfs_start_transaction(quota_root, 2);
>>>> +    btrfs_put_root(quota_root);
>>>
>>> The same.
>>>>        if (IS_ERR(trans)) {
>>>>            ret = PTR_ERR(trans);
>>>>            goto drop_write;
>>>> @@ -3736,6 +3751,8 @@ static long btrfs_ioctl_qgroup_limit(struct file
>>>> *file, void __user *arg)
>>>>    {
>>>>        struct inode *inode = file_inode(file);
>>>>        struct btrfs_root *root = BTRFS_I(inode)->root;
>>>> +    struct btrfs_root *quota_root;
>>>> +    struct btrfs_fs_info *fs_info = root->fs_info;
>>>>        struct btrfs_ioctl_qgroup_limit_args AUTO_KFREE(sa);
>>>>        struct btrfs_trans_handle *trans;
>>>>        int ret;
>>>> @@ -3745,7 +3762,7 @@ static long btrfs_ioctl_qgroup_limit(struct file
>>>> *file, void __user *arg)
>>>>        if (!capable(CAP_SYS_ADMIN))
>>>>            return -EPERM;
>>>> -    if (!btrfs_qgroup_enabled(root->fs_info))
>>>> +    if (!btrfs_qgroup_enabled(fs_info))
>>>>            return -ENOTCONN;
>>>>        ret = mnt_want_write_file(file);
>>>> @@ -3758,8 +3775,15 @@ static long btrfs_ioctl_qgroup_limit(struct
>>>> file *file, void __user *arg)
>>>>            goto drop_write;
>>>>        }
>>>> +    quota_root = btrfs_grab_root(fs_info->quota_root);
>>>
>>> The same.
>>>
>>>> +    if (!quota_root) {
>>>> +        ret = -ENOTCONN;
>>>> +        goto drop_write;
>>>> +    }
>>>> +
>>>>        /* 1 BTRFS_QGROUP_LIMIT_KEY item. */
>>>> -    trans = btrfs_start_transaction(root, 1);
>>>> +    trans = btrfs_start_transaction(quota_root, 1);
>>>> +    btrfs_put_root(quota_root);
>>>
>>> The same.
>>>
>>>>        if (IS_ERR(trans)) {
>>>>            ret = PTR_ERR(trans);
>>>>            goto drop_write;
>>>
> 
> 

