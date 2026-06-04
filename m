Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24E22EEE90
	for <linux-btrfs@vger.kernel.org>; Thu,  4 Jun 2026 22:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780611301; cv=none; b=AyOnhQVrDZ4vPWFwPF6NKPbS2oYDixYUACLgSzhYovbd17teOB+gOAHyXScKaLn30BRO7s2kkNtXy53nhVm2VfokXkXEa4iww2IZqgHS1CyK5oJLCxzYA5yQ8AWiceNJ7s2VJHwt5opYHfVq1KYaOGl3AwXmznnXQO4qhZDCLfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780611301; c=relaxed/simple;
	bh=nsAnKd2LuBCN97hLPwR548ZP+4PVMUjMOeGYCyp3mCw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d2JCK5uzxtUDs0jE35dM2V8hwH6CFMZrFooKk6o9sRZcOk+fjIMl0p72dng2OusSEhIhgSfQz6UBLzaZTbCsXHRH1B5hfJ1bMcgJzRZukkVZzhpKtYOilv6LfYox6l9RkvmiXOs/iixpmcvZg9uct1D7AwL51B9fRcKS9BjmHK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=CxbzXiFq; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="CxbzXiFq"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-becfa735b9aso176521266b.1
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Jun 2026 15:14:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1780611298; x=1781216098; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=swV2Gbwj1tjoYWtpb7LLSDT7BwBFiYnbxqafBDFuBsk=;
        b=CxbzXiFqsOZ2uoRvQfBgdOHv+AMk/PYd9QTOcx5GeCf7Sr+MKpIdLo8hREqbsqb00n
         RP4QY4Bc2ZUSBcULV8yyDYTTuGpfXuMLZ2o00O7gS/XUo9j0crBC2RePAp/xc68/KyPz
         iUu1a1lQ4FD5OvxyeD2dBIrsp453mDRWMZY8oFo1LcnOwUnJ0BumYXkdeqzhePDBOaoP
         6gi0MAG+cdoResjCErd51/44cpuKCsuKOafsx+uPwfrCmPeu6r/cZr3GHI5xHSBbCM2c
         25VyxUELKOOyzX6xG4D5oR3WYu7X9WYLFu+iRn1OqVc4CYdRbei1qetcVqPk1wcDjzLt
         iWpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780611298; x=1781216098;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=swV2Gbwj1tjoYWtpb7LLSDT7BwBFiYnbxqafBDFuBsk=;
        b=jJLgVl+aRphCZq49hXJPZkyZj9K8WbXW5eUAJOxhdmBWx3QR4ITd9OvcG/s937B9LU
         QAjM5+32JK2ZYQYjcgVJX/d1dF8zaFBNjwPJHUM/5ayUonrduuROOunecVi4saZBKy9E
         IrzWlckebRcO30cbIwyGAhHr9ySyJ9+KK82UR+bwOsmsLoprTyiCvXgJ8FAR63a+GgmB
         FqC/tJtOQk8OXtBkOtI7mGPzyORCSK3LFOwcBl2C5H/+xQ///9zLMcUN6J/yg5YIS5t/
         ILAGH7nEC83xxHb/Ntze+FOK/ZNfTnmDmosealVw8FBv6SAwG6bbkX2MTiPgjbSMON5T
         jA6Q==
X-Forwarded-Encrypted: i=1; AFNElJ8L8fOcT3xcsyH+B/GdAZDoMaSM1XZoFHOrdWPKw6DXI/o+Cg1gzoKQgMj05ANzqYDtjBU5gILc/+wl2A==@vger.kernel.org
X-Gm-Message-State: AOJu0YwaHMdAIJ8TUx9sbA6nTXwu8ksU1gqFhuPNFnIsKQ0HPAU2bNNW
	YXk8NIvfvg8EVUhT0WKHA0pCjqF64apv4ua4o1/L99wpVNXAp3p2gAhiQeRzvgbDOsE=
X-Gm-Gg: Acq92OEuQyFZn2shvquHg8SuqUzSnzGHy6jis0+4ApdlHwpL+Q6bGwjtPbptcUEXa8H
	VwJypkAw513Y+5Dv008ZD3QU3jyH/u7YNuCR5jGiCVPi/7xcU1JwnVmF0Xoa+x0B+UuJ85IixEo
	f23IY7onUgi2RGyjZZBcUX3vJ2dcMgLqgqhSugox0MrXZxH0iY+QBCL3WwzKwceaQCsGKnEVoeP
	B+xq8pf0x/09WAwGa4fo5tNQDvRSQtc8CmsRUD+JN5KmlvA6BaxXbjZ+ON/VPokrHX8ynejSsw/
	S4hfu7y0PH7DltGG5987Novo8Hk0KWl0jdKrjrq5zxkMi467++sry7/i3tuOimgrVowlfwTXkef
	nyJuHR0lwLJa6xc2uK0glWXbg9+n7S2qXLJCFCgTGnOD4be56vJ0fakrjp9tR3tRegwH6tsDgna
	s7Czn1AEr8YiFsSae3L62Q53Wbr0tpoUg2vxu8DyK+o/ai1Xz2Abk6VtrBK+p3Nc62NvQfiNMr2
	TVNdKZ4MU2RGMGfJUpWlf7frX7azg4manNRG9x7fs/FpAAy/yQI8tHQqA==
X-Received: by 2002:a17:906:f5aa:b0:bec:6c5c:cced with SMTP id a640c23a62f3a-bf372159bf0mr29866266b.28.1780611298253;
        Thu, 04 Jun 2026 15:14:58 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36f6c668f9bsm4364545a91.7.2026.06.04.15.14.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2026 15:14:57 -0700 (PDT)
Message-ID: <45018d54-50c6-4804-8bce-6ae05c2ce715@suse.com>
Date: Fri, 5 Jun 2026 07:44:51 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: start qgroup ioctl transactions on the quota
 root
To: Dongjiang Zhu <zhudongjiang@fnnas.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com, fdmanana@suse.com
References: <20260604085522.3872126-1-zhudongjiang@fnnas.com>
 <02849934-ca88-42a7-ba3e-a7196e1fcef1@suse.com>
 <60e3c20b-8490-41b6-8189-ea595dd2ffa5@fnnas.com>
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
In-Reply-To: <60e3c20b-8490-41b6-8189-ea595dd2ffa5@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/6/4 21:44, Dongjiang Zhu 写道:
> 在 2026/6/4 17:15, Qu Wenruo 写道:
>>
>>
>> 在 2026/6/4 18:25, Dongjiang Zhu 写道:
>>> The qgroup ioctls update the quota tree, but they currently start their
>>> transactions using the root of the inode passed to the ioctl. This makes
>>> the transaction reservation depend on the path used for the ioctl instead
>>> of the tree being modified.
>>>
>>> Start qgroup ioctl transactions on the quota root instead. Grab a
>>> reference to the quota root before starting the transaction, as quota
>>> disable can clear fs_info->quota_root concurrently after the early quota
>>> enabled check.
>>>
>>> Suggested-by: Qu Wenruo <wqu@suse.com>
>>> Signed-off-by: Dongjiang Zhu <zhudongjiang@fnnas.com>
>>> ---
>>> Changes since RFC:
>>> - Rework the fix to start qgroup ioctl transactions on fs_info-
>>>> quota_root
>>>     instead of adding a no-qgroup-enforce transaction helper.
>>> - Grab the quota root before starting the transaction to handle
>>> concurrent
>>>     quota disable.
>>>
>>>    fs/btrfs/ioctl.c | 38 +++++++++++++++++++++++++++++++-------
>>>    1 file changed, 31 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>>> index 9d47d16394fc..bec4f921aefd 100644
>>> --- a/fs/btrfs/ioctl.c
>>> +++ b/fs/btrfs/ioctl.c
>>> @@ -3606,7 +3606,7 @@ static long btrfs_ioctl_qgroup_assign(struct
>>> file *file, void __user *arg)
>>>    {
>>>        struct inode *inode = file_inode(file);
>>>        struct btrfs_fs_info *fs_info = inode_to_fs_info(inode);
>>> -    struct btrfs_root *root = BTRFS_I(inode)->root;
>>> +    struct btrfs_root *quota_root;
>>>        struct btrfs_ioctl_qgroup_assign_args AUTO_KFREE(sa);
>>>        struct btrfs_qgroup_list AUTO_KFREE(prealloc);
>>>        struct btrfs_trans_handle *trans;
>>> @@ -3637,8 +3637,15 @@ static long btrfs_ioctl_qgroup_assign(struct
>>> file *file, void __user *arg)
>>>            }
>>>        }
>>> +    quota_root = btrfs_grab_root(fs_info->quota_root);
>>
>> No need to increase the root refs.
>>
>> Qgroup root is a global one, no need to grabbing it using ref count.
>>
>> Furthermore, all those qgroup related operations (including enabling/
>> disabling) are all holding qgroup_ioctl_lock, thus there is no way the
>> quota root is gone halfway.
>>
> 
> I may have misunderstood this part.
> 
> The ioctl handler checks btrfs_qgroup_enabled() before starting the
> transaction, but it does not hold qgroup_ioctl_lock between that check
> and btrfs_start_transaction(). btrfs_quota_disable() can clear
> fs_info->quota_root and put the quota root under qgroup_ioctl_lock.
> 
> I enlarged that window locally. If the ioctl reads fs_info->quota_root
> after the delay and passes it directly to btrfs_start_transaction(), it
> can hit a NULL root after quota disable. If the ioctl saves
> fs_info->quota_root into a local variable before the delay and then
> starts the transaction on that saved pointer, KASAN reports a
> slab-use-after-free in start_transaction(), with the root allocated by
> btrfs_quota_enable() and freed by btrfs_quota_disable().
> 
> So I think I may be missing the intended serialization here. Since
> qgroup_ioctl_lock cannot be held across btrfs_start_transaction(), as
> noted in btrfs_quota_enable(), what would be the right way to protect
> the quota root for this transaction start?
> 
>>> +    if (!quota_root) {
>>> +        ret = -ENOTCONN;
>>> +        goto drop_write;
>>> +    }
>>> +
>>>        /* 2 BTRFS_QGROUP_RELATION_KEY items. */
>>> -    trans = btrfs_start_transaction(root, 2);
>>> +    trans = btrfs_start_transaction(quota_root, 2);
>>> +    btrfs_put_root(quota_root);
>>
>> Again unnecessary.
>>
>> Furthermore, the pattern of grab root -> start trans -> put root is
>> completely incorrect and dangerous.
>>
>> If we're the last one holding a root pointer, after holding a trans
>> handler, calling btrfs_put_root() can cause the root pointer to be gone,
>> resulting all kinds of use-after-free bugs.
>>
>> I do not understand where you come up this cursed usage, it's completely
>> incorrect.
>>
> 
> Understood, I will drop that pattern. I added it only because of the
> race above, but I misunderstood the root lifetime rules around
> transaction start.
> 
> For my understanding, is the problem that btrfs_start_transaction() does
> not take ownership of the root pointer, so the caller must not drop the
> last root reference while the transaction handle is still alive?

Yes.

> 
> I really appreciate your review and the detailed explanation.
> 
> Thanks,
> Dongjiang
> 
>>>        if (IS_ERR(trans)) {
>>>            ret = PTR_ERR(trans);
>>>            goto drop_write;
>>> @@ -3675,7 +3682,8 @@ static long btrfs_ioctl_qgroup_assign(struct
>>> file *file, void __user *arg)
>>>    static long btrfs_ioctl_qgroup_create(struct file *file, void __user
>>> *arg)
>>>    {
>>>        struct inode *inode = file_inode(file);
>>> -    struct btrfs_root *root = BTRFS_I(inode)->root;
>>> +    struct btrfs_fs_info *fs_info = inode_to_fs_info(inode);
>>> +    struct btrfs_root *quota_root;
>>>        struct btrfs_ioctl_qgroup_create_args AUTO_KFREE(sa);
>>>        struct btrfs_trans_handle *trans;
>>>        int ret;
>>> @@ -3684,7 +3692,7 @@ static long btrfs_ioctl_qgroup_create(struct
>>> file *file, void __user *arg)
>>>        if (!capable(CAP_SYS_ADMIN))
>>>            return -EPERM;
>>> -    if (!btrfs_qgroup_enabled(root->fs_info))
>>> +    if (!btrfs_qgroup_enabled(fs_info))
>>>            return -ENOTCONN;
>>>        ret = mnt_want_write_file(file);
>>> @@ -3707,11 +3715,18 @@ static long btrfs_ioctl_qgroup_create(struct
>>> file *file, void __user *arg)
>>>            goto drop_write;
>>>        }
>>> +    quota_root = btrfs_grab_root(fs_info->quota_root);
>>
>> The same.
>>
>>> +    if (!quota_root) {
>>> +        ret = -ENOTCONN;
>>> +        goto drop_write;
>>> +    }
>>> +
>>>        /*
>>>         * 1 BTRFS_QGROUP_INFO_KEY item.
>>>         * 1 BTRFS_QGROUP_LIMIT_KEY item.
>>>         */
>>> -    trans = btrfs_start_transaction(root, 2);
>>> +    trans = btrfs_start_transaction(quota_root, 2);
>>> +    btrfs_put_root(quota_root);
>>
>> The same.
>>>        if (IS_ERR(trans)) {
>>>            ret = PTR_ERR(trans);
>>>            goto drop_write;
>>> @@ -3736,6 +3751,8 @@ static long btrfs_ioctl_qgroup_limit(struct file
>>> *file, void __user *arg)
>>>    {
>>>        struct inode *inode = file_inode(file);
>>>        struct btrfs_root *root = BTRFS_I(inode)->root;
>>> +    struct btrfs_root *quota_root;
>>> +    struct btrfs_fs_info *fs_info = root->fs_info;
>>>        struct btrfs_ioctl_qgroup_limit_args AUTO_KFREE(sa);
>>>        struct btrfs_trans_handle *trans;
>>>        int ret;
>>> @@ -3745,7 +3762,7 @@ static long btrfs_ioctl_qgroup_limit(struct file
>>> *file, void __user *arg)
>>>        if (!capable(CAP_SYS_ADMIN))
>>>            return -EPERM;
>>> -    if (!btrfs_qgroup_enabled(root->fs_info))
>>> +    if (!btrfs_qgroup_enabled(fs_info))
>>>            return -ENOTCONN;
>>>        ret = mnt_want_write_file(file);
>>> @@ -3758,8 +3775,15 @@ static long btrfs_ioctl_qgroup_limit(struct
>>> file *file, void __user *arg)
>>>            goto drop_write;
>>>        }
>>> +    quota_root = btrfs_grab_root(fs_info->quota_root);
>>
>> The same.
>>
>>> +    if (!quota_root) {
>>> +        ret = -ENOTCONN;
>>> +        goto drop_write;
>>> +    }
>>> +
>>>        /* 1 BTRFS_QGROUP_LIMIT_KEY item. */
>>> -    trans = btrfs_start_transaction(root, 1);
>>> +    trans = btrfs_start_transaction(quota_root, 1);
>>> +    btrfs_put_root(quota_root);
>>
>> The same.
>>
>>>        if (IS_ERR(trans)) {
>>>            ret = PTR_ERR(trans);
>>>            goto drop_write;
>>

