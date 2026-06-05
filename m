Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 104DD2C1595
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Jun 2026 08:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780649843; cv=none; b=a8x/1dCEGogBq5Jq3dciDWD8G6ZJR/RE4Kg+BdfoxLRZ807qSmvTHygRDBYRn7mbRke4xmtsvqcnb/fomL+huDlhdx+dZBn8/eDJLR1H+mm7qM2ovQR0WlMW6MmzUwWBNG4m6InbA0e0p6cghq+TdxxrffzDCi+QP/t7gnVs2Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780649843; c=relaxed/simple;
	bh=iwUlfpEEffW54Uj6Kj6nQxoS1yFAiSEspGhg/6gkFN4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FGobURdK1bwHZKwpfMIPcg1VYGFM2uay/YM51VDGvowAyUyBGOi+9CJTCyVe7K0v8bYSfpuCyPOQ/E1Iv9Zgv4JM4q02mkjkjZjr467c5dXBQJfTG6ywOqjWKah68oehq5ywwIlP1fT1yg2WjFT1RyUEi9cyoFhe5tj2czuu5Vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=RretJ+oG; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="RretJ+oG"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-bec429c2bb1so249576466b.1
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Jun 2026 01:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1780649840; x=1781254640; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=6bTnxk9hct0APZRI72ObNXFOuF4kq3UuhhgjvUnS2Mc=;
        b=RretJ+oG9BLRbvUN33oqOnkNa1qx34Zy6hTNzA7izQHi7TdV8NbR9wl2XqLUhsN3k6
         Q4MysNyrs6p41s5dN3X3/kXhXesrwfp0KaBpMPwZoJXlJqvmK2Og5gzpgcaASHT7Z4oA
         kV+wJ9L6d+IG8BTvdGR9k0DtrVNejvrHCRlxwRSdAZkPK8cHdLYc69Oaigv9ptjUvBaI
         8wm8IDtfrVN2khZU0Z02pUMQ85zs0lptdqJf1M5/yTb4cxlAdJNEmrtDoaegwWD9yUtI
         s1K2Q48DOUUEWRA8427vREkCd4a0lEQkpwpvTjfLiX8tUzF7s9zKIs7lxGWHjmny7BZn
         aXag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780649840; x=1781254640;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6bTnxk9hct0APZRI72ObNXFOuF4kq3UuhhgjvUnS2Mc=;
        b=gjYGJKAKKBKH8z9FHkfTBCfSiYi54/0PApV+CAP2fEzmQrp4Iq4if6GVOXvF69qS5I
         FFM7K0jW0TYPvy227rlfwuLD8u4ZwGZnr3q1Se4K6dzomXCZptKyipfTHk726yyv6e5T
         sJBUWKktH29nT4W1C5DaP4fqFWYL3WsrHs1B86Tua89MVdaada9PbNDE9JnbGf7t1hHb
         ng2X3XAFZ/PTxkYlCUfrUueBpCqHWTNGE6UyhUY/Q8bhlCZxto7VM2fcUkA7pQslqGEy
         itj3+Q+i5ztoX+e0iJizJx0Pip3boAmhkB4sdkczYwOvFxm8l6CJXVdv68qPw9JzHq1z
         IoWQ==
X-Forwarded-Encrypted: i=1; AFNElJ9gEiqcJIZn3OcoYjczuTecNK1c66xZZADMJoI4cSQk2+MQ3eu/58x8XBeJMbiV1jaKZEN3sOSBk8ea3w==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4Ipe79Z8/wF/jFc2mRwZzBPrNfrQwGF5W0h20x2dw4it6Ucx7
	pArmm+UmjpImH6hf8H0F/ZxebtF6yDYlrQ4j4vgrgms/RHWVWoiowiHQT5icNl6kH7cF26r9HCd
	e0PMm
X-Gm-Gg: Acq92OFoqolI6FwVQteOTAYUNTXGIUGFdgVmJJ18rsaQPg5hA6450HN1pxg7dVEl2J4
	TViVMxIKZTHM4Sv7O+lhvRFayvw1z5AQ+yfH6hr5Vm7b/sk+hrw9LecdSu148hiIznOyvurQLFz
	Lhy1f/4TxbBmIoQ6xwXclX5YBRQEspZiNg/AdxSgajM4Ty/t+CwpklO1ERI18rj26dc6JbT4kmr
	p90ZNNgT34jIsGAQsImbgBxC5BceTmMtM5LGVz2/f/3bYZdJq0C3ydnjtd/pm9kcEJgHz6CPLQG
	ruF/0INmBnCG/+GxUEX2TLe2djSf0qQLzZOpMypfC4yK9tC60d64Vm9bSZu0/N0I0/xaSP+WVtI
	+5iyUjeDDMIg34Jxx18WMNB8Qqyub3ZPJs7Kz9fmhSROXrQSE2afVsUb2ahFGTk+KnC/oKc6XwX
	5gIsCkGC9kZKxn3Vo4zCnki7rffShZZiXpFUmlDSzs3Lz/aqAI8+ewJvwxvtbPWWV2CYE4JAVAU
	dhniFKMy5pMo6nEZ/uzBrWBoFyBNlDttMsgFzDuo8hlfEFkKNh/wWbq6A==
X-Received: by 2002:a17:907:986:b0:bee:c13f:7ec0 with SMTP id a640c23a62f3a-bf370180feamr123741666b.8.1780649840121;
        Fri, 05 Jun 2026 01:57:20 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36f6bf830b2sm5298335a91.4.2026.06.05.01.57.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jun 2026 01:57:19 -0700 (PDT)
Message-ID: <e714a93e-a0b4-4cfd-afa3-adc912bd44ad@suse.com>
Date: Fri, 5 Jun 2026 18:27:13 +0930
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
 <f7550cda-a443-4979-b6c4-be086d23dfad@suse.com>
 <8a85da40-4c7f-4366-b4da-fecec9d33970@suse.com>
 <e9967ac7-05a4-484d-b2a7-8b246890fe0b@fnnas.com>
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
In-Reply-To: <e9967ac7-05a4-484d-b2a7-8b246890fe0b@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/6/5 18:23, Dongjiang Zhu 写道:
> 在 2026/6/5 7:02, Qu Wenruo 写道:
>>
>>
>> 在 2026/6/5 08:21, Qu Wenruo 写道:
>>>
>>>
>>> 在 2026/6/4 21:44, Dongjiang Zhu 写道:
>>>> 在 2026/6/4 17:15, Qu Wenruo 写道:
>>> [...]
>>>>> Furthermore, all those qgroup related operations (including enabling/
>>>>> disabling) are all holding qgroup_ioctl_lock, thus there is no way the
>>>>> quota root is gone halfway.
>>>>>
>>>>
>>>> I may have misunderstood this part.
>>>>
>>>> The ioctl handler checks btrfs_qgroup_enabled() before starting the
>>>> transaction, but it does not hold qgroup_ioctl_lock between that check
>>>> and btrfs_start_transaction(). btrfs_quota_disable() can clear
>>>> fs_info->quota_root and put the quota root under qgroup_ioctl_lock.
>>>
>>> Then enlarge the lifespan of qgroup_ioctl_lock.
>>>
>>> btrfs_add_qgroup_relation() and btrfs_del_qgroup_relation() they are
>>> only called inside the assign function.
>>> You can drop the mutex lock/unlock inside them, change then to do a
>>> lockdep_assert().
>>>
>>> Then hold the qgroup_ioctl_lock inside the assign ioctl for the whole
>>> duration, after start_transaction().
>>>
>>> Then you can safely access quota_root without refcount.
>>
>> My bad, this is totally wrong, you already need a quota root at start
>> transaction.
>>
>> I think the better solution is something like this:
>>
>>       mutex_lock(qgroup_ioctl_lock);
>>       quota_root = btrfs_grab_root(fs_info->quota_root);
>>       mutex_unlock(qgroup_ioctl_lock);
> 
> Yes, this makes sense. I missed that the quota root lookup and ref grab
> need to be protected by qgroup_ioctl_lock.
> 
>>       if (!quota_root)
>>           goto out;
>>
>>       trans = btrfs_start_transaction(quota_root);
>>       /* Do the work */
>>       ret = btrfs_end_transaction(trans);
>>       btrfs_put_root(quota_root);
>>
>> Even if there is a race with quota disable and quota disable later
>> removed the quota_root, later functions like btrfs_add_qgroup_relation()
>> will still do the proper fs_info->quota_root check and exit early if
>> quota is already disabled.
> 
> I am still trying to understand the needed lifetime here.
> 
> I rechecked this qgroup ioctl path, and I did not find a post-start user
> of the root pointer passed to btrfs_start_transaction(). The trans handle
> does not keep the root pointer, the quota root is not retained by
> btrfs_record_root_in_trans(), and the later qgroup helpers re-check
> fs_info->quota_root under qgroup_ioctl_lock.
> 
> So for this specific case, is dropping the temporary reference right
> after btrfs_start_transaction() still unsafe, or is holding it until
> btrfs_end_transaction() mainly the conservative pattern?

Just for the sake of consistency, I would prefer to not have a new 
pattern of doing grab->start_trans->put.

Just follow the common pattern would be much easier to maintain.

> 
> Is dropping the reference after btrfs_end_transaction(), but before the
> transaction is committed, safe in this case?
> 
>> But I have not yet tested this, you still need to run fstests to be
>> extra sure.
> 
> Sure, I will test it carefully with fstests.
> 
> Thanks a lot for your review and guidance.
> 
> Dongjiang

