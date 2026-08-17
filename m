Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D772771B
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Aug 2026 03:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786936160; cv=none; b=ehxO4kDHmBnVy2lAQwZ4cVZ57Xey7MkXF9eUDml2eSN79rO2NdIkMfzE+vZ+/5tE1J1rHR2B2C1jLcJ+yMD6MWXWjcUsHqK4H6RTISyKywLIlYh0rHPxSak/09DOsKofi75HA97inhmPCluvKx/dLfYbFXd30t4U4qmmepkBoQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786936160; c=relaxed/simple;
	bh=ToCIilkiZehuWnlJUZIJ75OJiLWtOxuqXQcRkO5P57A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ODJ90GWKeAR3vx3xSNB6Y1hG2BSdEW40ZFt7yn0Q51nQkI3kzb1I8idxMLvIkEm/W6CF52EZwGtvuTCZ0+UyixoMXWzJAV9ZCEFwqTWS8FgKEGd599TWzosyaQnf4K/Er8x8UZ6oPyZpYsT16qRQJWOZxpkP7YhanKOsQ+pl0i8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=DYEdgsI+; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="DYEdgsI+"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-49557167508so29033755e9.1
        for <linux-btrfs@vger.kernel.org>; Sun, 16 Aug 2026 20:09:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786936157; x=1787540957; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=W5wfhHA59qxRq1XUr0lkUdphHXqJnRChXPFDDSI5xqc=;
        b=DYEdgsI+lMlRbS71gcF2ho/rZ4x3fo2+22jaX2pEyDqeq+eqxfaGKkWXvTNpfacJOc
         nmL1apGqTmUfl5yiZGWPf6KNWVb9eSLXyTpvZdtnhsmAW+3Psj8AYgmWzb3duQLuG2ro
         FZNXSVcNfCqgFwZowfLq14OlSr7vJiZ3e4PVNlgfHuUhEmtlgXe3kC+vhIqXJwLIWWtF
         24b3wP6hCQ6VNHxaCazp9Lh5503gDqEXVjYqMmKycRgUTgiJg44ZMMzNdjhXSQv92hR1
         0l7ioU9rSaEo4uF+ZNGolbBhv03EF7iTzg95uELFudCgYdTaYClINB4siyf19yDuWC2h
         J7kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786936157; x=1787540957;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=W5wfhHA59qxRq1XUr0lkUdphHXqJnRChXPFDDSI5xqc=;
        b=PVtpTYOAX4IYDVfEtukaFNvG3luItVjF1L16TnDro78JvufWfl6RcLL9plrY2WDvVJ
         l9A68jgfMgKBQiuNfsEFzQqObCb94cD25Q2CGRheI/IHfpv/Tvv7inJ2qBoheKIlL/xH
         fLbcNg2d5xJAMZakKzkUcvyfkEzEAHYllXVTJcm5QKAlB7zHol40tfBKlbSg80pLY+EE
         V60wi4+MXfackOXdgBBaYqjWXfJjV/8tkP470SnAnSVYgoRFFKphwGe97u7Jd0xXY6rR
         TgGdhdrGRuBQiim+PRnxsnKqFp4KulTo6cURSetRGR3oV99YYwOD3ZiLvxHNG63GqyOl
         KSbA==
X-Gm-Message-State: AOJu0YwrBU9rzS7xKZ8W7LxXerIyZL77QifOHYORb0v4HyCiBVbUmEis
	neTl6JbfStqtqddEPaHAUZYBX7agkZPSYCEfcCHL9ngMCi6Baz8uzIc219Niy9vluak=
X-Gm-Gg: AR+sD11wCULpX4AyFiVJYgNiDRNFO+ko0yIcSKru3j65UU3Q6ouN+CkVssKTNwuIm/a
	mh2BN7eaFQYebB3+AUDUtlnKjKoHdYxmXOy4RxIcH/EyQDsfnkO2dGE7PC5uO7PFJ+lK9GYB4FB
	2iDI2tNpL2YISAbWpbu+WxxPXupb4BelCq2RHiE+DyH0rmRBw3ofCR5UPVcOZpZMYjIyIiG7Ijb
	x7LUDttnjnPf37PQhp09FkHv7t/7LGuGx/nJviMiRtpZL/OSqiQViiZZlUVKlEQOhTZTj5AP4fD
	Zu6sQmCgCL6cBpeLPgibgRkcnTkussM6DTyg/RlhbLMXk2C1TEk4IJikQLQtUOC10r3USHXTZCl
	ZlckfuVcZVXTP8P9jRtD9mXk6Rgh0GE2nmsBoCTvQ4kryvoYPAK/vD5eRhypA6XFuW3J9ZFr2el
	fNCkMbw8UKnH8OiIm0I44vANC6SOKXGotZIB8k8979ciqjJg+KbsjtUYzaZcoZC1AM
X-Received: by 2002:a05:600c:870c:b0:499:8a3a:fd3a with SMTP id 5b1f17b1804b1-49991099160mr233962755e9.5.1786936157089;
        Sun, 16 Aug 2026 20:09:17 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-326798cb9f5sm1066252eec.13.2026.08.16.20.09.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Aug 2026 20:09:16 -0700 (PDT)
Message-ID: <586ff25f-3a54-4ab7-b533-abdf692dbd22@suse.com>
Date: Mon, 17 Aug 2026 12:39:09 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: fix use-after-free in mark_block_group_to_copy
To: Hongling Zeng <zhongling0719@126.com>, clm@fb.com, dsterba@suse.com,
 naohiro.aota@wdc.com, josef@toxicpanda.com
Cc: linux-btrfs@vger.kernel.org, stable@vger.kernel.org
References: <20260817014633.13293-1-zenghongling@kylinos.cn>
 <6A8275D6.4060709@126.com>
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
In-Reply-To: <6A8275D6.4060709@126.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/8/17 12:15, Hongling Zeng 写道:
>    Thanks for the review.
> 
>    This patch was developed with assistance from Claude AI.
> 
>    The AI helped with:
>    - Analyzing the code paths to understand the use-after-free scenario
>    - Identifying potential deadlock risks with different locking approaches
>    - Cross-referencing similar locking patterns in send.c and backref.c
>    - Drafting the commit message
> 
>    I modified the code to add the commit_root_sem locking myself, reviewed and
>    tested the changes before submission.
> 
>    Apologies for not disclosing AI assistance earlier. I will ensure to do so in
>    future submissions.
> 
>    Best regards,
>    Hongling Zeng
> 
> 在 2026年08月17日 09:46, Hongling Zeng 写道:
>> mark_block_group_to_copy() iterates over the commit root with
>> skip_locking=true to avoid lock contention. Without holding
>> commit_root_sem,a concurrent transaction commit can swap and free
>> the commit root during iteration, leading to use-after-free when
>> accessing extent buffers.
>>
>> The fix adds commit_root_sem locking, but CRITICALLY must only cover the
>> actual search period (btrfs_for_each_slot), NOT the preceding while loop
>> which calls btrfs_commit_transaction(). If held during that loop, we get
>> self-deadlock: down_read(commit_root_sem) → btrfs_commit_transaction()
>> → switch_commit_roots() → down_write(commit_root_sem), blocking forever
>> on our own read lock.
>>
>> Lock scope:
>> - down_read() after path setup, before btrfs_for_each_slot
>> - up_read() immediately after btrfs_for_each_slot completes
>> - NOT held during while loop (btrfs_commit_transaction) path
>> - NOT held on the !path error path (goto unlock before lock
>>    acquisition)
>>
>> This matches the established btrfs pattern used in send.c, backref.c, etc.:
>> hold commit_root_sem read lock ONLY while searching commit root, never
>> across transaction commits.
>>
>> Fixes: 78ce9fc269af ("btrfs: zoned: mark block groups to copy for device-replace")
>> Cc:stable@vger.kernel.org
>> Signed-off-by: Hongling Zeng<zenghongling@kylinos.cn>
>> ---
>>   fs/btrfs/dev-replace.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
>> index dc0834f920c3..734807bf48b3 100644
>> --- a/fs/btrfs/dev-replace.c
>> +++ b/fs/btrfs/dev-replace.c
>> @@ -499,6 +499,7 @@ static int mark_block_group_to_copy(struct btrfs_fs_info *fs_info,
>>   	key.type = BTRFS_DEV_EXTENT_KEY;
>>   	key.offset = 0;
>>   
>> +	down_read(&fs_info->commit_root_sem);

And there is already path::need_commit_sem, which does a smaller 
critical section than holding it manually.

>>   	btrfs_for_each_slot(root, &key, &found_key, path, iter_ret) {
>>   		struct extent_buffer *leaf = path->nodes[0];
>>   
>> @@ -525,6 +526,8 @@ static int mark_block_group_to_copy(struct btrfs_fs_info *fs_info,
>>   	if (iter_ret < 0)
>>   		ret = iter_ret;
>>   
>> +	up_read(&fs_info->commit_root_sem);
>> +
>>   	btrfs_free_path(path);
>>   unlock:
>>   	mutex_unlock(&fs_info->chunk_mutex);
> 

