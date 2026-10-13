Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4316502D72
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 21:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791927178; cv=none; b=R6jWcUJnqhFQl5xn3rzxaJJnj+b24GZNshiLYzLfzX5Zoepb6cnuRAH9qSx9G6N0y/qIP8h6imBYOUJYhx2N0GTYnUFhlDkWp8ZvNK1lixW+73jsVLfK3+a0wptGV2mzzjCMbLcQogr14hlPSEhsw8fPKYtZFx3WvEG9GXtNgIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791927178; c=relaxed/simple;
	bh=880ZtF+5tzQ2P0LCGzcqRzsUQKhl01mUitWipHZrb9Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tf2+g++sMWQHMGGUttYSy2XBrhrN6NkCIQN9J3nKuX12Y9Lg9+148EWytyjVq9S9x3cdDMoEZ4fX0Q5qFdBZbgaLbVzt6nt0ceDmFckS+tbf8yppSkxDsj6lZ4kTTyZkIMcZFL8JrunyREU9gJWJj3cH/AyNu/SDDXzKZTcJhxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=eqrMnZHw; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="eqrMnZHw"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a16c399641so34283375e9.2
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 14:32:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791927175; x=1792531975; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PK5LU9ngjxic8FDZZ6qRnTRzoXC/Qwv+KmootTFyQWE=;
        b=eqrMnZHw99Wy5Z42w9TfscUmgaKlKZxt5mJMW/PbTjniv5W7ZbTxAIPF5kDXDZ+aXm
         wvT7r65y9VG+9P1DbcwbdPkoayx2WZiwazI9tNEWe4V8lb1rasYwP6lXrAKYZF0V+jj8
         X5Q3oWZhgdLuKRNvG+weIh0yxxi9c1Kn8NaGiV3Dk8xbITQ3Cerf6wBu3c50Q5Yezh2u
         pIfVBk2Ik5Afpbh6Zf5caVQxbmssKWcxYonjiHip11Ijb1wAaL5lDazcrFA5uCt8SXwM
         njYBYT28cU5jeGosvf6Hdu5k+Wm/O/fZYUWMddpHyogc0d/o2HKy25otAlR/w7slbneb
         qKPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791927175; x=1792531975;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PK5LU9ngjxic8FDZZ6qRnTRzoXC/Qwv+KmootTFyQWE=;
        b=Obn7L24As1z4GOLxuIRKJJHLj4hlMctYjC7sj1nWbDxT6QpBoYtrX692KjkOqISJXA
         XNYEls7SsNHFAtIS1l95jX029PxKH0w1Bvno4tX7PJD/Odv/B2Y8lHtLioUxfLbYJ2ru
         VA+UNbzenmQgCpwWy0Jk7s8u5KUFjNvxKSeGg5lMdX2WEAgiPsbcnrM3BrNywDbuvJfA
         7m7uWgghYb+Bbjn3QlaklW62sUqT0BK4KHR65nKABtQ5TeDmgQdmSQXhf+WZDMux29a9
         WDNH0V1l83MpofTP8gwzBudkbzzhVcOZ2WNTRVVEVwjuwh1pJrorU4YQLHfmxf+7nLss
         mIuw==
X-Gm-Message-State: AFq9FYIExjZ2SUaA8If9tQVvPcn7TIC3QhXMON5ItZOc2M2rouIrcR6Y
	OP5/kkTv+bcfWjefxX8K/w8kbzP4lNuhYQwMIBiu2uJVC00JvlcjGlkKgw3iyxkxMFUUTMU9gxX
	7nEstypg=
X-Gm-Gg: AYBFou1xDD1fAL/nGdVFMfFs3oPtu7rRq5JqzQCzFWu4UzJxr/MMHCnmF69pqDYYI6a
	PVmZkQhTMdJ26qaRJitgL11ShMPJm+9SpmMGRe8Bj9seMUwD9vPZ44EYTpPJpM9qRAPed4+L+NU
	O7p1mAr74Za1n5f/H7h6fmcLhlWgttTw/zCtrfpNHqNqbboRiLZfluVeI3xcyyuqex9wyEYMm9/
	VfU+edYqG3qZXzQaLY5xWQn+jsVk+uiUMII5VGnPZnCxceaQ2D/LCSXJ77yerRC4IKcu+b5wTQi
	8iLMp2b7tvRBO6/kDlTgKaVr70VHsg2K7sVluVthx4/Bnqs+RxZbPJ9ulWTI35DUb42NrVHrTaI
	l+Om4Fe1b+As16Sw7PgM/ZTL/Quntw99JY/8GZUom97fFojij7lmqEDsa2+4AwsTwNNunHcNU9s
	w+/q+ls5UEjbVL8HAYf1W07flrA+B4/08V+CZL8br1b2EPFGYP7PAk33ujnaugV3s=
X-Received: by 2002:a05:600c:8105:b0:4a1:775b:5eb2 with SMTP id 5b1f17b1804b1-4a18e48362emr273940505e9.13.1791927174850;
        Tue, 13 Oct 2026 14:32:54 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac677adccfsm271055a91.2.2026.10.13.14.32.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Oct 2026 14:32:53 -0700 (PDT)
Message-ID: <ce9b3fa2-aab5-42b2-98e9-08995475df44@suse.com>
Date: Wed, 14 Oct 2026 08:02:49 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] btrfs: always remove quota_root from
 dirty_cowonly_roots
To: Filipe Manana <fdmanana@kernel.org>
Cc: linux-btrfs@vger.kernel.org
References: <cover.1791869895.git.wqu@suse.com>
 <e71e6fcda482f306e8841292ea0031594de78577.1791869895.git.wqu@suse.com>
 <CAL3q7H7Bo56aLRZ7w-LbZ2h01bZipsBAKXxWVpCTqvTMn=E8mw@mail.gmail.com>
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
In-Reply-To: <CAL3q7H7Bo56aLRZ7w-LbZ2h01bZipsBAKXxWVpCTqvTMn=E8mw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/10/14 03:22, Filipe Manana 写道:
> On Tue, Oct 13, 2026 at 6:41 AM Qu Wenruo <wqu@suse.com> wrote:
>>
>> [ERROR HANDLING QUIRK]
>> When btrfs_quota_disable() failed at btrfs_clean_quota_tree() or
>> btrfs_del_root(), the quota_root->dirty_list is not removed from
>> fs_info->dirty_cowonly_roots, but the quota_root itself will be freed.
>>
>> This leaves a dangling pointer in the dirty_cowonly_roots.
>>
>> This is not a huge problem, as the transaction is aborted thus no one
>> will read the dirty_cowonly_roots for now.
>>
>> Furthermore, quota_root should never be logged nor have qgroup swapped
>> tree blocks, thus it won't cause leaks from extent io tree nor qgroup
>> swapped blocks.
>>
>> [ENHANCEMENT]
>> For the incoming cleanup of dirty_cowonly_roots during
>> btrfs_free_fs_roots(), any root that is still linked to
>> dirty_cowonly_roots will be read again, and this existing dangling
>> pointer is going to cause problem.
>>
>> To prepare for that cleanup, move the list_del() call into the out
>> label, so that even if the transaction is aborted, we still unlink
>> quota_root from dirty_cowonly_roots before freeing it.
>>
>> Assisted-by: LLM (exposing the bug during review)
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>   fs/btrfs/qgroup.c | 10 ++++++----
>>   1 file changed, 6 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>> index a0651fbfe778..8bd3abdf4805 100644
>> --- a/fs/btrfs/qgroup.c
>> +++ b/fs/btrfs/qgroup.c
>> @@ -1440,10 +1440,6 @@ int btrfs_quota_disable(struct btrfs_fs_info *fs_info)
>>                  goto out;
>>          }
>>
>> -       spin_lock(&fs_info->trans_lock);
>> -       list_del(&quota_root->dirty_list);
>> -       spin_unlock(&fs_info->trans_lock);
>> -
>>          btrfs_tree_lock(quota_root->node);
>>          btrfs_clear_buffer_dirty(trans, quota_root->node);
>>          btrfs_tree_unlock(quota_root->node);
>> @@ -1454,6 +1450,12 @@ int btrfs_quota_disable(struct btrfs_fs_info *fs_info)
>>                  btrfs_abort_transaction(trans, ret);
>>
>>   out:
>> +       if (quota_root) {
>> +               spin_lock(&fs_info->trans_lock);
>> +               list_del(&quota_root->dirty_list);
>> +               spin_unlock(&fs_info->trans_lock);
>> +       }
>> +
>>          btrfs_put_root(quota_root);
> 
> Same comment I had in another patch:
> 
> Can we place btrfs_put_root() inside the if statement's block that
> checks quota_root is not NULL?
> It just feels odd to have it outside, even though it can handle a NULL pointer.

I can move the put_root call inside the if () at merge time.

Thanks,
Qu>
> Reviewed-by: Filipe Manana <fdmanana@suse.com>
> 
> Thanks.
> 
>>          mutex_unlock(&fs_info->qgroup_ioctl_lock);
>>          if (ret && trans)
>> --
>> 2.56.0
>>
>>

