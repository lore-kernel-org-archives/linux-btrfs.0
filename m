Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9174B3438BD
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Jul 2026 21:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783979458; cv=none; b=D1vEnV/YDk3tj2S6Gs/tWw4CXq/XUD2b4smEZGlQOARfJUGIHUn/x+Gwm0YsB2enFO5VCVQkANkzVFk6BTfqIK2+aS0Hgv0BepdGat9834pF2EVh7VZ3NEbrokg/HbXmZa2/TqsHk/lULa3q+4HUBaiUKBquMIkLomLhBlzOvP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783979458; c=relaxed/simple;
	bh=lkNXmYTKJfNwzbgPkYkyyH8S/iJOXghBtWYAennis2Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jxWLqk1PJy2HzC7mK0k6eE40XVs6xwoQ/bo7D5s9KFM9pxJVK7mURcQxYB1FwTx+fzvUsSdM4SbZ6c/u9wgsz66vUPnqg7p9jU23HPrKPYWu+1anMN1GOR0poCRK+CwdEL26Ngh+Do9PUsQcLGQtPhqmg+vxXabchWsOyn30C1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=bbaFrJ3N; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="bbaFrJ3N"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-493bfe9f886so19804295e9.0
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Jul 2026 14:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1783979455; x=1784584255; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PfN53+GVezmBU87bZUIh0oDndUVaTtCNFje2ZOvEQxY=;
        b=bbaFrJ3NZdfR1bOIn8dmfbLJfirZ1VQ70bmgBZ+67aEGKjSEUgQRoCE/HGQxkkQ0HA
         b/Mmz2gPhMmZUJlADLwipK7WSluCyo2OR5QHJ4dPxBIMB66KlbbaPCI6KsJq9feXr/dg
         Y0Ymw1mcUzutr76J8C6zEt+W0wjYOHpo9hgvSeDIDDNo7kuQtT1q0NKch2/MLjnbv1Cz
         5lIdQ47AHeHS/ScgEMPI9VHhddhrsB/Tii+ywq6v5oIRDgwc9vvgonPD0kNLq9mFqtUG
         KehTQhnZCnzW70ECGAgoNoCMUKWZFdNYWoqMWF7UKbydqSQf3akLwFlP74XfAMvsl28E
         +n4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783979455; x=1784584255;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PfN53+GVezmBU87bZUIh0oDndUVaTtCNFje2ZOvEQxY=;
        b=U2LFYEdTqnV0BLEEgoRVMXYEW97+ew2KspZn1veSGFTxgrfM2Lzvv+QpKR3J/vMylb
         Dw1qWKwE/ldPblF7RBGl+3TmE3ekOoHTmlQxaqNM+718xGcx8WIJnzbPJVCSm4IDy2qx
         +A5rFRxvLAllVDzovedQK2jS9pQpNDEqjU5Jbwzb1oEhrJ6dfFm6EeHHe9fFdLSeIBJH
         BietFifcv+P4180Le0A7Pd091cJ5+M/7GP4fECNqsGK+OxVOG5OC/rJRKgjJU9DKqpiL
         L+WHgnZURhR2F2XlkfxejhiLahWnBSHyTbPQ3LLGbrBzEXTAEIHh0LO5G/cF7N2mL/Fn
         Psqg==
X-Gm-Message-State: AOJu0YzNAGoH4p947UNbI9lBq/TPsmfOyTHa/bfxmH83tHWAMIOqnk30
	m1ddvHBEIRrEkSen8hid55/Jr19gS4m2MfimObPmV57BtKPwk124n1uGc+KCSQREt/A=
X-Gm-Gg: AfdE7cmzG1FZVr9waS2GzyvrCtZmIbcb1hCu+lDfNwVA5tamBD9A3zmK5KCFVXr/1bU
	/l79EV3ECmnp/FpdXJ3sNK8pgjbVhqx5h0xMENxiD3yTZfSvDL0VR6lBt7XQulTr4LFOl3xxmHd
	UrE1QYHruUbcXvKiEhVn0zMpgBoK3CFNQoPk2hwoguhA3DQheNcOTDhZlt25AV2HuH4qrfMCM2J
	7bt2zJRg25DHEXlkDdytCYGAEAMTPshS9nv9XAgFewNPQvivdhbImIg3FX8xk42odq/g3y4QrGy
	b2e4vnZbH3ZPiUH6QXXO4FgMibnkC/DcYNup/QKLV2C6GsfUQZeWq0hYW4OQKoLTZA0ql4L6BiU
	JMpDD3shUwXhOuT9XMwQt3U6sQqTmdDjcC7w27aPOE2jfHkZtgZEs5ah676Z637Wzw7ENqE6HMd
	Dr/XcUbfnk0fCvHMoE
X-Received: by 2002:a05:600c:8b88:b0:494:e456:4596 with SMTP id 5b1f17b1804b1-494e45645ccmr22254645e9.21.1783979454832;
        Mon, 13 Jul 2026 14:50:54 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31174accb0esm76035575eec.30.2026.07.13.14.50.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jul 2026 14:50:53 -0700 (PDT)
Message-ID: <f9131134-9c8f-48c6-938a-0bbfe9695111@suse.com>
Date: Tue, 14 Jul 2026 07:20:49 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: btrfs lockdep issue
To: Christian Borntraeger <borntraeger@linux.ibm.com>,
 Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
References: <5a9d9847-4ae6-43c4-afdc-6e5fa51d6117@linux.ibm.com>
 <8cff9612-e5f4-4621-843e-0582493119fe@linux.ibm.com>
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
In-Reply-To: <8cff9612-e5f4-4621-843e-0582493119fe@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/7/14 01:39, Christian Borntraeger 写道:
> Am 13.07.26 um 14:07 schrieb Christian Borntraeger:
> [...]
> 
>>   Possible unsafe locking scenario:
>>         CPU0                    CPU1
>>         ----                    ----
>>    lock(&fs_devs->device_list_mutex);
>>                                 lock(&fs_info->tree_log_mutex);
>>                                 lock(&fs_devs->device_list_mutex);
>>    rlock(&type->i_mutex_dir_key#2);
>>   *** DEADLOCK ***
>> 2 locks held by (udev-worker)/1653:
>>   #0: 0000016c727051c8 (uuid_mutex){+.+.}-{3:3}, at: 
>> btrfs_control_ioctl+0x102/0x1e0
>>   #1: 00000069238564d8 (&fs_devs->device_list_mutex){+.+.}-{3:3}, at: 
>> device_list_add.constprop.0+0x148/0xc60 
> 
> So some additional detauls
> -------
> this was a udev-triggered btrfs device scan (BTRFS_IOC_SCAN_DEV) of
> /dev/dm-8. The scanned device belongs to the mounted btrfs root filesystem
> (multipath, the path flapped between /dev/mapper/mpathg2 and /dev/dm-8),
> 
> ---snip---
> BTRFS info: devid 1 device path /dev/mapper/mpathg2 changed to /dev/dm-8 
> scanned by (udev-worker) (1653)
> ---snip---
> Could this be due to  commit 2e8b6bc0ab41ce41e6dfcc204b6cc01d5abbc952
> ("btrfs: avoid unnecessary device path update for the same device")
> ?

I believe you're right.

That commit introduced extra path resolution when we're still holding 
device_list_mutex, meanwhile the path resolution will cause directory 
lookup, thus lead to the above report.

I think I can change the is_same_device() lookup to get rid of the path 
resolution and completely rely on path_devt and device->devt and avoid 
the path resolution completely.

Will send out a patch for you to test soon.

Thanks,
Qu
