Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57070285C84
	for <linux-btrfs@vger.kernel.org>; Thu,  4 Jun 2026 22:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780613511; cv=none; b=L1ubgg+mGxEIK7/h5e+VHl9jrKZ/NpQ3qeW8dbrziMMBIi3EsTvtydNEgc6Y0CbTp7EXo8eT6BD+oBs8gLzX7STwqZs7kghq9KiEx9B0S4Nm3xZA+dZgHvW0MeUgvnhAfhjsvte2jXxV9Vus5lufAqsaMT2w+btqgkZ3KKyv9ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780613511; c=relaxed/simple;
	bh=x6MpqbkUCQ1G289Or0Sd2TKDbFML9fvZ2SbIvXLDx8g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uRcEoXyMZQd2DtXrEG6seE5GIiFoufulUl1b0i+aZ79ChoptyZvUH4MCPRrzjjdrgHeAg3pmtpkKoVcbTgsS13rE8+QnLvsVpmEng3Kiwfbm8nZfRgtckhZH6o/C+z+RojnDNKdE9ajGsM2j9D8pZJxmYJ2W43IuWr3UcxjZ6tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=bXSkgkkt; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="bXSkgkkt"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-bef1e6423e7so136568966b.1
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Jun 2026 15:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1780613507; x=1781218307; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=DUKZDxfajH37nlw3xRkmQhwUkFADCv3ENqC3QSb/tKw=;
        b=bXSkgkktIXyd5+PFPwIo0/gClBnmWKjfImSMZUOdnX0Cwngotg3fT17cAvp+0l83+m
         NLclnSMEVewgEKIAosNXeT+qPh9ATHa59qXitStQGN6exy7ojwCyKug4q6qUmYz0nyRS
         XJttt0HAugNV0sMGNBHejqQiHzpBpla8n91cN0E8MtMv5cRd/5GAGLBuB8zc/IewvtZT
         4c5c3CpfEhiS2Qx1wy41v62YOMaVmmmoQhfYzxMdKxJmLyReZnLj9olPNLkFaYTd2BgZ
         5Ioludh/AkIuzTaugR5OZ+f/TzkQOsfs6CGc/btah9ucJnGcdxF+GAjnTJIZyD75Bkel
         J1Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780613507; x=1781218307;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DUKZDxfajH37nlw3xRkmQhwUkFADCv3ENqC3QSb/tKw=;
        b=ba3wl7fSovhkrKv0sx1aFZLGCtR0wde5iRmVSUckLALK798559GjBim1ZCOan4xTJR
         RHQiJ5zVxxlJS/YkuyLaSJ/KneacZ+OaCFiSNfzW9SO09OKnbVbcVcfy1i+2a2ojUMd4
         c12PpSFAx1ZCK0zIhu2aHEETIzDvc6sQUoTn4eBV15X5WxAP0ozlUgThOJ8UnMZcIsI5
         0i3eyjOvUkTWDotU+BEne3iHbAy5Pfw6Dn9WOZY9BglfFQ0vyxnW0VP3CP257/eIzIgw
         6L0VFaFPAnN9yGm7K3+JRjshjLtfnmqa84rm2d9UtVqF/VXr02li7kwbNoMcqKk/NFri
         lRzw==
X-Forwarded-Encrypted: i=1; AFNElJ/SLDW6lyXNiu/MABjqsrNR0t1Uf/CVgTHwHU7a6gZwi86p+l57QI6+n8I2EOTc3/mapAp3V5jVelfhGA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy97bMBLrdIXIhoCZaPxYY0yaaKE3yTXME5O/QgoODka815IhE4
	X+hLoU+FjmfMkpf8Vaz17agiDdhDmYxar6kSnp675zHnJNAdr0vQgHuU8NECQVpL8tI=
X-Gm-Gg: Acq92OEfEvU1F4kzpEKT0Yvenoez1Q6sddpaPISCuZHMnkl70RY0sluOxr7h+7BuQAl
	gLkpUCn/COJc9012mOmWQ8NTJ0HDWia1UoSvcmntvpOThW3jtG8/6vEr/JieR/UcPrc8znJ38Gs
	0jTZ1sKP/3weJMihA51xD+hVjSvQ+1jl0IfBhDNHpnJ3vCSz3ULeyd4YYefT0/+oM/K1o654/AD
	cIKtQ8RZn3/GUr851/f4I9nVbvCCmYOdme/6D0E3CAl7OE3LGRnfnTHI73t/Pva2iYHYHUe5F3B
	22J2uapEHErcdC+/AN7aE5WzbuK9BzScJAOdDIrYnuLric9qSxj/K9TVAwkxIAHEYFJvgU7W/Cy
	ok7MXa1AhH53xdZeuEibdBtHzp+2SNzajeYDs94aNDHF2X9P7x5FaL1UBByxaD5tyz/SsQJL/Ao
	l4rwQvzYcfdOpcN7Gd0c7BoZ0+uLOV7fThDA+g2JsXT9XXRoouh1gYIZ7bP8bZKcAzevpcxWWRS
	mYPIqKxSCJMnb+X46rcVlLg3VP1KWt+vnZfjMvSPNZb6RWlsVRJCqkC
X-Received: by 2002:a17:907:8693:b0:beb:f71c:63a with SMTP id a640c23a62f3a-bf370e62bc1mr29386666b.2.1780613507130;
        Thu, 04 Jun 2026 15:51:47 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-842828cf783sm7540448b3a.40.2026.06.04.15.51.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2026 15:51:44 -0700 (PDT)
Message-ID: <f7550cda-a443-4979-b6c4-be086d23dfad@suse.com>
Date: Fri, 5 Jun 2026 08:21:39 +0930
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
[...]
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

Then enlarge the lifespan of qgroup_ioctl_lock.

btrfs_add_qgroup_relation() and btrfs_del_qgroup_relation() they are 
only called inside the assign function.
You can drop the mutex lock/unlock inside them, change then to do a 
lockdep_assert().

Then hold the qgroup_ioctl_lock inside the assign ioctl for the whole 
duration, after start_transaction().

Then you can safely access quota_root without refcount.

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

