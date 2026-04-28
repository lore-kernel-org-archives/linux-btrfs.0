Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EDF740DFA4
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Apr 2026 00:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777337090; cv=none; b=b6iO2bgjw4WyDITcD+rq88unOUVqishXS429IY7Zqo2k8kq8QAwj0aE6jOHserW0ziNIT2a1NymmGCOU2HKNVfVZw63xhjz3tWFJkVlUX05qrXcL1IqxZGFE/FJvHUrQyorYbu7k/zzgyQK9A+buJuuuLx+9FGol0ahQPWcbrwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777337090; c=relaxed/simple;
	bh=eBPfR27QqC1mrp2mef1oIe1Ma9CfzTLxxqwRBDqV9t4=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=r9GXND6aB9ZH1oC/Ysedo9sgx7yAT0QSStUJ2Jg7i3mlLz06vmJP3eYB6sbJfANm3ZDE56qIoBLHNVoRqedYcqHA3q6Q0ukPNjgDyFBtJ+HtdAYSgeM/6SSMR9N/UUhX+7kNQ25sDK2n61eP3GixegKd4u1TzjBt/9pnHkk8qrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=d7QQu/SZ; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="d7QQu/SZ"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4891e5b9c1fso92557325e9.2
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2026 17:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777337087; x=1777941887; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=nb4NRueAr6JEPvZEii46NSmwu+/ago1NiKDDod9yq+U=;
        b=d7QQu/SZX6811b/xyCvKTjU2YF17jD24XVDTU+0uuR0vO9cLLzVoKh3eTCFzgjCRvI
         YEN3JCS/hJDig+FPXUU3B9VN3FaHqZxsl3uYIoVWCJHpajdQpXBV+MRQyGMBtySAj4RM
         dGjt9HItZo3KM40OO/m21UpY+Z7cESVWO8hXEudUwwf2cdFjn1TQ5Q8nqFFhl/IlkwZr
         k5LnCbalu4+O7HqF0wv4Fkne5/mxTXEhcK1i5gzwIvcHzmqAS9GodeWP+j8BIj+XxzWq
         iGmUApaj1Sa6qM9sFESKJ4ZkqHxD9UYcWB8np00RzA3D7CGfqf2Xx7PxDlAeWAf9KVam
         Zj1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777337087; x=1777941887;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nb4NRueAr6JEPvZEii46NSmwu+/ago1NiKDDod9yq+U=;
        b=nbRKoh3VUT+mpKVZ+OZxqApz1m9QWaWp2CknG+Enna6XcYdw2vc8DG7eZXdPhjS3Cb
         ycdwLFbkJl9upbLJfoKLiuCX7KGr1IQJIA3ZS/4jK5E+alafaPy4ibM6hKbTXiqWJ+0v
         gERxKgxKUcd99k56Qw+JQUQT63L3nwRD+WezTxtIRcWy89ifqplDTpiYsnsvvlBv46wl
         yprBCZE2TprLXVy1IdDfQDmZdvVAahPLygUP85P8mJ3C7YoTeF5ZpOby9+7CW0KmLNGq
         dEFVM113MW6d9rfQs/zkqgW7xKyy38+LfdbWAsFZEXr7wesCf+BOFn83by6TNnqDNHu1
         lFDQ==
X-Forwarded-Encrypted: i=1; AFNElJ+uIlVBa8R8OwwTBivkcHBQzG94EysJDArOAPVQvDlaUW/92rPcpDpaK7bIm7ZvjM/UR3paTDU9q3NZWA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzGh6/4JqNUxfik5acdx+RzpOOqP+zjHxl5YgjmgeI07TQmGK8r
	u9ZViio6BGHcvMXxkNJSiU7yiOx4pmD31bDrjlBNN1Tid3w00Ki10xhlFP6yctvX/bw=
X-Gm-Gg: AeBDiesWVZSuWVs+KIaoI4KjrrVUYZgBhLzGLMSg+BoJtyd4/pAlcjOTjY/oG09/pWh
	Gq0r6vIwRoaZXf1RGPVq3lHRsWU/K+IvF6rVguyUtBbJ/uhq4L5ffONsHMCRS+fKHfqikOaxfNY
	jcqJjWBx8EFf7U9XXu0jRN9dijaYpNrzKEd3/43lWlBu5sTrKKaYi0fCMqOjeqJKW6ahukZX5X5
	/YQd3XoKgY+DMpp88Y5YH578q7QMqIjQevAtjnml3l/uGtBBTOtM3dZrH0L7xJ7Ex3W04tOjV3J
	ln0a2IhCiy9S8RuMLnraXOEYuXwuR5l9rWn82y8Z6jmhsl9oL1hn7Q+NKAQhMvxypIuQBHHdsh0
	W72c6ZqGzkAsrkz5QmJuMsTOQHsBMl5yfJvqFEQf+7AoOaARF/A705hGLSwB2K0O1PJbq1SHI0m
	JhDNmDf8UDEjlmr01L1HDjBxzQS/FwX0JAFA7bEYemQZE4xgSniRyzdYWNAisNWg==
X-Received: by 2002:a05:600c:1d0a:b0:488:a797:f0ac with SMTP id 5b1f17b1804b1-48a77b1f088mr11359185e9.28.1777337086517;
        Mon, 27 Apr 2026 17:44:46 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36490a7476csm340649a91.2.2026.04.27.17.44.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2026 17:44:45 -0700 (PDT)
Message-ID: <4fed7e18-4bc7-43a5-8438-62bff279fbe7@suse.com>
Date: Tue, 28 Apr 2026 10:14:40 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] btrfs: validate data reloc tree file extent item
 members in tree-checker
From: Qu Wenruo <wqu@suse.com>
To: Teng Liu <27rabbitlt@gmail.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com, clm@fb.com, linux-kernel@vger.kernel.org,
 syzbot+3e20d8f3d41bac5dc9a2@syzkaller.appspotmail.com
References: <20260426201605.36626-1-27rabbitlt@gmail.com>
 <20260427202822.278326-1-27rabbitlt@gmail.com>
 <aeb71a41-2727-472d-a869-20ca9bd2b005@suse.com>
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
In-Reply-To: <aeb71a41-2727-472d-a869-20ca9bd2b005@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/4/28 07:45, Qu Wenruo 写道:
> 
> 
> 在 2026/4/28 05:54, Teng Liu 写道:
>> get_new_location() uses BUG_ON() to crash the kernel if the file extent
>> item it looks up has any of offset, compression, encryption, or
>> other_encoding set. The data reloc inode is only written by relocation's
>> own paths -- insert_prealloc_file_extent() and
>> insert_ordered_extent_file_extent() -- which always leave those four
>> fields at 0 (the data reloc inode is created with BTRFS_INODE_NOCOMPRESS,
>> and encryption/other_encoding are reserved-and-zero). Observing a
>> non-zero value therefore means the leaf decoded from disk does not match
>> what the kernel wrote, i.e. on-disk corruption. A malformed image can
>> reach this code via balance and panic the kernel.
>>
>> Move the validation into tree-checker's check_extent_data_item(), where
>> the constraint is enforced when the leaf is read off disk rather than
>> after relocation has already started. The data reloc tree has a fixed
>> root id (BTRFS_DATA_RELOC_TREE_OBJECTID) recorded in the extent buffer
>> header, so check_extent_data_item() has all the information it needs to
>> apply this check on its own. Report violations via file_extent_err() and
>> print the four offending values.
>>
>> In get_new_location() replace the BUG_ON() with an ASSERT().
>> The caller in replace_file_extents() already handles non-zero returns 
>> from
>> get_new_location() by breaking out of the loop without aborting the
>> transaction, so no caller changes are needed.
>>
>> Suggested-by: Qu Wenruo <wqu@suse.com>
>> Suggested-by: David Sterba <dsterba@suse.com>
>> Reported-by: syzbot+3e20d8f3d41bac5dc9a2@syzkaller.appspotmail.com
>> Closes: https://syzkaller.appspot.com/bug?extid=3e20d8f3d41bac5dc9a2
>> Signed-off-by: Teng Liu <27rabbitlt@gmail.com>
> 
> Reviewed-by: Qu Wenruo <wqu@suse.com>
> 
> And merged.

Unfortunately this tree-checker got triggered during btrfs/061 runs at 
write-time tree-checker, with arm64 64K page size.

The offending file extent is as the following:

[  536.885066] 	item 69 key (258 EXTENT_DATA 4063232) itemoff 12400 
itemsize 53
[  536.885067] 		generation 28 type 1
[  536.885067] 		extent data disk bytenr 10512723968 nr 36864
[  536.885068] 		extent data offset 24576 nr 12288 ram 36864
[  536.885069] 		extent compression 0

Note the offset is not zero, and the type is 1 which means it's a 
regular file extent.

So the check is causing false alerts.

Now the patch is reverted, and I'll spend more time digging into the case.

Thanks,
Qu

> 
> Thanks,
> Qu
> 
>> ---
>> Changes in v3:
>>   - Move the corruption check from relocation.c into tree-checker's
>>     check_extent_data_item(), per Qu and David. The data reloc tree's
>>     fixed objectid is recorded in the extent buffer header, so the
>>     check has all the context it needs at read time.
>>   - Use file_extent_err() and print offset/compression/encryption/
>>     other_encoding values, per Qu.
>>   - Replace the BUG_ON in get_new_location() with ASSERT() rather than
>>     -EUCLEAN, per David.
>>
>> Changes in v2:
>>   - Pair the -EUCLEAN return with btrfs_print_leaf() and btrfs_err() so
>>     the offending leaf is dumped to dmesg, per Qu's review of v1.
>>   - Expand the changelog to argue why non-zero
>>     compression/encryption/other_encoding in the data reloc inode imply
>>     on-disk corruption.
>>
>>   fs/btrfs/relocation.c   |  8 ++++----
>>   fs/btrfs/tree-checker.c | 21 +++++++++++++++++++++
>>   2 files changed, 25 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
>> index 1c42c5180bdd..527d4dbfe31c 100644
>> --- a/fs/btrfs/relocation.c
>> +++ b/fs/btrfs/relocation.c
>> @@ -835,10 +835,10 @@ static int get_new_location(struct inode 
>> *reloc_inode, u64 *new_bytenr,
>>       fi = btrfs_item_ptr(leaf, path->slots[0],
>>                   struct btrfs_file_extent_item);
>> -    BUG_ON(btrfs_file_extent_offset(leaf, fi) ||
>> -           btrfs_file_extent_compression(leaf, fi) ||
>> -           btrfs_file_extent_encryption(leaf, fi) ||
>> -           btrfs_file_extent_other_encoding(leaf, fi));
>> +    ASSERT(!btrfs_file_extent_offset(leaf, fi) &&
>> +           !btrfs_file_extent_compression(leaf, fi) &&
>> +           !btrfs_file_extent_encryption(leaf, fi) &&
>> +           !btrfs_file_extent_other_encoding(leaf, fi));
>>       if (num_bytes != btrfs_file_extent_disk_num_bytes(leaf, fi))
>>           return -EINVAL;
>> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
>> index 1f15d0793a9c..e4864f7a471e 100644
>> --- a/fs/btrfs/tree-checker.c
>> +++ b/fs/btrfs/tree-checker.c
>> @@ -296,6 +296,27 @@ static int check_extent_data_item(struct 
>> extent_buffer *leaf,
>>           return 0;
>>       }
>> +    /*
>> +     * For the data reloc tree, file extent items are written by
>> +     * relocation's own paths, which always leave offset, compression,
>> +     * encryption and other_encoding as 0. Any non-zero value here means
>> +     * the leaf decoded from disk does not match what the kernel wrote,
>> +     * i.e. on-disk corruption.
>> +     */
>> +    if (unlikely(btrfs_header_owner(leaf) == 
>> BTRFS_DATA_RELOC_TREE_OBJECTID &&
>> +             (btrfs_file_extent_offset(leaf, fi) ||
>> +              btrfs_file_extent_compression(leaf, fi) ||
>> +              btrfs_file_extent_encryption(leaf, fi) ||
>> +              btrfs_file_extent_other_encoding(leaf, fi)))) {
>> +        file_extent_err(leaf, slot,
>> +"invalid members for data reloc tree, offset=%llu compress=%u 
>> encryption=%u other_encoding=%u",
>> +                btrfs_file_extent_offset(leaf, fi),
>> +                btrfs_file_extent_compression(leaf, fi),
>> +                btrfs_file_extent_encryption(leaf, fi),
>> +                btrfs_file_extent_other_encoding(leaf, fi));
>> +        return -EUCLEAN;
>> +    }
>> +
>>       /* Regular or preallocated extent has fixed item size */
>>       if (unlikely(item_size != sizeof(*fi))) {
>>           file_extent_err(leaf, slot,
> 
> 

