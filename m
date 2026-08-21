Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD2E374E60
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Aug 2026 07:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787296123; cv=none; b=j74ltXS1mxXs2Szkh6+Dve17EUUF1eHVBvdm5kspIBLUNgAB+hDBZHjzuwSrP0XKqkNT9l+89lAJvxVJg1lSYJ0SdaBG2ZQZ4w51UHoXVa6+SYWcqlgpnDTnwrDf/0YRYryDwXfSWPZc0JciifQQfb7on/QH4jr43F5RMr/h2xU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787296123; c=relaxed/simple;
	bh=Rge5eqWSYEYWNSc3oqpwKT6ww5HLGkKTctDH8qCy+Ho=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ViCr/DMLeg+CFSIyPPAGIK8dVX/F3gzuxAUdYUr3/fRInat9CzreBelG7Tst9PKTojWmDbIhYM+E7O1hnKfSXXxbbUlHqzTLO9O3kLtqyABUjCElAQU/W2KTJfSjs4/46AmoRAWkbXNPC1ZI+bB5Oc4TvKlnI19cy8OSLiogtfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=DvX6hVQH; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="DvX6hVQH"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c160420289bso100015966b.0
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Aug 2026 00:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787296119; x=1787900919; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=d+8cTdoRMdDlquE/ywku2nlEVbRB6k7nnOU2LvwM7MM=;
        b=DvX6hVQHvtDbAqefUjgKxk6ZGvm4QKUg6ufgn8drxHuxIgQUB10NCgFETja24qWX9o
         ExsuD1kCbf5QLVItl62M3Aisvq0ytTxkhsmtII7JE6yov0is6OAikm6YhwZGYSW03zmu
         XYWS1/Qmn3jsfWxlPTXY0Vtv3Fdkp/rd0rXQiO+IC+ab+uLWal9W8+TayKzc71Yo+HYM
         GG692eJojE+xxGqXfwLNS7+fQLj+1pY0w1yIfghPZNEgF0MHvmsboEsCFnqW9NJmiXUj
         AK9UPLW8DdFatWAMIUaPp7XCFqacPmB6gj1kOVp7kusCYKmyZXW/5h1da1MOXCNAbABP
         Z4lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787296119; x=1787900919;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=d+8cTdoRMdDlquE/ywku2nlEVbRB6k7nnOU2LvwM7MM=;
        b=JKhies/E6yUpAaNG1q0OmwXdmqyUIRS2WDs2kqvxYvc6YWE7Z4YRPlR10l9sIJeWO3
         DqUOviTm8JTFscS6h/+HMwkrVGMqCRcQL45t8P7YkhvQawqz69XO/QUieImXqLZJcP35
         IReGozJwl4Nmma2gvB3M/yUYMCcptiDU/NYEcYeNsPDm0rkY0EKjFjHToHusuStIJ3z7
         KZ+HaJnyUMjq3/WDpNNVqieueYvApPZNpBr1bqxgJMVC/hJbHZ072Mymiku5cIehX0Rw
         G2Fa2+dxfJN2LrdM2vdna3RBaPivuQhRkjZUVtTuMDnLBpX86sCm6owvCV2geqJ3NNrM
         4djw==
X-Forwarded-Encrypted: i=1; AHgh+RqV3lUjtnfoqo4FMDG9BNvaT8hOhoYK/m9UGsKNRZUjh30e5PgI+Hk+5gKIIEA5dxX1tHCSomL3p8E/4A==@vger.kernel.org
X-Gm-Message-State: AFuF++l10VrwcbiYwJhlB3COc8GVe9Mvq5oornDe+XISHt5Bm+V33HJS
	YiV2OzqHetPwn0+aE8ZREO69xWPFLg9e3un08RPEuHTzS/pYg+70PS6qbrwcNH6xOCk=
X-Gm-Gg: AR+sD13Dg4veVBqXdYfQxKd7oMYwSQca7o1FBmgLiOfng5JmrF8WFGRCMkXKZC/Mr1E
	DfP0q+CnmB26H7wQTkTpH5b8ZnJL7Yf+JO49Rc0HTjyrI0H0+PewcYN9jTcEyVXJ47lZHdXs35i
	7ADW0SDhBL1YCIheSgQ2Ev9Ggv1VeeoESTrRNLtpHb0wH41Ct51TO3ET9YVkHM7ROzs/LAZ5KN7
	et++qqQ/x2hnBxlT0YhxDkChSQnMl+SattrbTV3LCHPBKPN6e3SHHFePLSt4y6wKWonK52//DD8
	HrbPgrCZcq3bJiB2sjr5dFa/6Qo2gE2JiclpDbwBOuvpqGFdNhiKCVQ01T87xdJm40hq+/DcT9m
	cOERdchq5JIzBCTAcWM1DtCLsJ/VyAAWUPXCZ3HCO+6Rm9ORZWkKvzJE+5xvuyI/QfeK2fThtnR
	CQIFXmosEnoVs9pshzhD+AJmln3O6pxwI1GTA8uaf27DDkjOtsUgTQXQ==
X-Received: by 2002:a17:907:e00c:20b0:c20:23f8:99a5 with SMTP id a640c23a62f3a-c246a6a402cmr308636966b.15.1787296119094;
        Fri, 21 Aug 2026 00:08:39 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-395c467d907sm1972014a91.7.2026.08.21.00.08.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Aug 2026 00:08:38 -0700 (PDT)
Message-ID: <f7fa4810-a494-487d-9c2b-b2e47cc08559@suse.com>
Date: Fri, 21 Aug 2026 16:38:33 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: drain sysfs callbacks before stopping transaction
 kthread
To: Jiacheng Xu <stitch@zju.edu.cn>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20b09e24.16b27.1a01f23ee08.Coremail.stitch@zju.edu.cn>
 <2252e770-a254-4971-9acc-c3768f3bb119@suse.com>
 <43775c17.162de.1a02295e080.Coremail.stitch@zju.edu.cn>
 <3dd5d093-0088-40d5-9daf-dd76f1839305@suse.com>
 <3cdedd9f.16449.1a02314f1b4.Coremail.stitch@zju.edu.cn>
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
In-Reply-To: <3cdedd9f.16449.1a02314f1b4.Coremail.stitch@zju.edu.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/8/21 16:19, Jiacheng Xu 写道:
> I think you are right. The previous patch only addressed the teardown
> case and did not fix the mount-time window.
> 
> However, moving the whole btrfs_sysfs_add_mounted() call is not a
> simple reorder because btrfs_init_space_info() creates child kobjects
> under space_info_kobj, which is created by btrfs_sysfs_add_mounted().
> 
> Also, creating sysfs after transaction_kthread but before BTRFS_FS_OPEN
> would still expose sysfs writes while the mount is not fully initialized.
> 
> Do you have any ideas?

For the space_info kobj, I think we can de-couple space info and its 
kobj file creation.
Aka, allow btrfs_init_space_info() to do everything except the kobj 
creation.

Then at the very end, create every kobj needed, and at that time, the 
full fs should be fully initialized.

This should solve the problem from the root, but will definitely need 
quite some changes to the mount/unmount path.
> 
> Thanks,
> Jiacheng
> 
>> -----原始邮件-----
>> 发件人: "Qu Wenruo" <wqu@suse.com>
>> 发送时间:2026-08-21 13:21:42 (星期五)
>> 收件人: "Jiacheng Xu" <stitch@zju.edu.cn>
>> 抄送: "Chris Mason" <clm@fb.com>, "David Sterba" <dsterba@suse.com>, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
>> 主题: Re: [PATCH] btrfs: drain sysfs callbacks before stopping transaction kthread
>>
>>
>>
>> 在 2026/8/21 14:00, Jiacheng Xu 写道:
>>> Hi Wenruo,
>>>
>>> I agree that rejecting sysfs writes when FS_OPEN is unset or
>>> CLOSING_START is set fixes the mount-time NULL pointer dereference.
>>>
>>> However, checking these flags alone does not fully protect the teardown
>>> path. There is still a check-then-use race:
>>>
>>>         sysfs store callback                close_ctree()
>>>
>>>         test FS_OPEN == 1
>>>         test CLOSING_START == 0
>>>
>>>                                              set CLOSING_START
>>>                                              kthread_stop(transaction_kthread)
>>>
>>>         wake_up_process(transaction_kthread)
>>>         use a stopped or freed task_struct
>>>
>>> Thus, the flag check fixes the reported initialization race, but a
>>> separate teardown race remains unless active sysfs callbacks are drained
>>> or otherwise synchronized before stopping transaction_kthread.
>>
>> OK, then the next quesstion is, why we don't move the sysfs creation
>> after the commit transaction creation.
>>
>> Even with your patch, it didn't solve the problem that during mount the
>> sysfs is created before transaction kthread.
>>
>> So in theory it's possible to do sysfs write before kthread initialized,
>> still causing NULL pointer dereference.
>>
>>>
>>> Thanks,
>>> Jiacheng
>>>
>>>> -----原始邮件-----
>>>> 发件人: "Qu Wenruo" <wqu@suse.com>
>>>> 发送时间:2026-08-21 06:32:14 (星期五)
>>>> 收件人: "Jiacheng Xu" <stitch@zju.edu.cn>, "Chris Mason" <clm@fb.com>
>>>> 抄送: "David Sterba" <dsterba@suse.com>, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
>>>> 主题: Re: [PATCH] btrfs: drain sysfs callbacks before stopping transaction kthread
>>>>
>>>>
>>>>
>>>> 在 2026/8/20 21:57, Jiacheng Xu 写道:
>>>>> btrfs_label_store() and btrfs_feature_attr_store() wake up the
>>>>> transaction kthread through fs_info->transaction_kthread.
>>>>>
>>>>> During filesystem teardown, close_ctree() stops the transaction kthread
>>>>> before removing the mounted filesystem's sysfs attributes. A concurrent
>>>>> sysfs write can therefore enter one of these callbacks after the kthread
>>>>> has been stopped and pass an invalid task pointer to wake_up_process().
>>>>>
>>>>> This results in a concurrent null-pointer dereference in
>>>>> try_to_wake_up(). The scheduler is not the root cause; the invalid
>>>>> transaction kthread pointer is used by a Btrfs sysfs callback during
>>>>> teardown.
>>>>>
>>>>> Split mounted sysfs cleanup into two stages. Remove attributes which may
>>>>> have store callbacks before stopping the transaction kthread. The
>>>>> remaining sysfs kobjects are removed at the original teardown point,
>>>>> after the kthread has been stopped.
>>>>
>>>> Why not just simpliy reject sysfs write operations when the fs has
>>>> CLOSING_START or without FS_OPEN flags?
>>>>
>>>>>
>>>>> Apply the same ordering to the open_ctree() failure path when the
>>>>> transaction kthread has already been created.
>>>>>
>>>>> Tested-by: Jiacheng Xu <stitch@zju.edu.cn>
>>>>> Signed-off-by: Jiacheng Xu <stitch@zju.edu.cn>
>>>>> ---
>>>>> fs/btrfs/disk-io.c | 16 ++++++++++++++--
>>>>> fs/btrfs/sysfs.c   | 26 +++++++++++++++++++++-----
>>>>> fs/btrfs/sysfs.h   |  3 +++
>>>>> 3 files changed, 38 insertions(+), 7 deletions(-)
>>>>>
>>>>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>>>>> index 2f1666d9544e..4f5bcc576dc6 100644
>>>>> --- a/fs/btrfs/disk-io.c
>>>>> +++ b/fs/btrfs/disk-io.c
>>>>> @@ -3363,6 +3363,7 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
>>>>>          struct btrfs_root *tree_root;
>>>>>          struct btrfs_root *chunk_root;
>>>>>          struct btrfs_root *remap_root;
>>>>> +     bool sysfs_attrs_removed = false;
>>>>>          int ret;
>>>>>          int level;
>>>>>
>>>>> @@ -3780,6 +3781,9 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
>>>>> fail_qgroup:
>>>>>          btrfs_free_qgroup_config(fs_info);
>>>>> fail_trans_kthread:
>>>>> +     btrfs_sysfs_remove_mounted_attrs(fs_info);
>>>>> +     sysfs_attrs_removed = true;
>>>>> +
>>>>>          kthread_stop(fs_info->transaction_kthread);
>>>>>          btrfs_cleanup_transaction(fs_info);
>>>>>          btrfs_free_fs_roots(fs_info);
>>>>> @@ -3793,7 +3797,9 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
>>>>>          filemap_write_and_wait(fs_info->btree_inode->i_mapping);
>>>>>
>>>>> fail_sysfs:
>>>>> -     btrfs_sysfs_remove_mounted(fs_info);
>>>>> +     if (!sysfs_attrs_removed)
>>>>> +             btrfs_sysfs_remove_mounted_attrs(fs_info);
>>>>> +     btrfs_sysfs_remove_mounted_kobjects(fs_info);
>>>>>
>>>>> fail_fsdev_sysfs:
>>>>>          btrfs_sysfs_remove_fsid(fs_info->fs_devices);
>>>>> @@ -4318,6 +4324,9 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
>>>>>
>>>>>          set_bit(BTRFS_FS_CLOSING_START, &fs_info->flags);
>>>>>
>>>>> +     /* Drain sysfs callbacks before stopping the transaction kthread. */
>>>>> +     btrfs_sysfs_remove_mounted_attrs(fs_info);
>>>>> +
>>>>>          /*
>>>>>          * If we had UNFINISHED_DROPS we could still be processing them, so
>>>>>          * clear that bit and wake up relocation so it can stop.
>>>>> @@ -4538,7 +4547,7 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
>>>>>                            percpu_counter_sum(&fs_info->ordered_bytes));
>>>>>
>>>>> -     btrfs_sysfs_remove_mounted(fs_info);
>>>>> +     btrfs_sysfs_remove_mounted_kobjects(fs_info);
>>>>>          btrfs_sysfs_remove_fsid(fs_info->fs_devices);
>>>>>
>>>>>          btrfs_put_block_group_cache(fs_info);
>>>>>
>>>>> diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
>>>>> index 0d14570c8bc2..d90d76a152e9 100644
>>>>> --- a/fs/btrfs/sysfs.c
>>>>> +++ b/fs/btrfs/sysfs.c
>>>>> @@ -1707,11 +1707,23 @@ static void btrfs_sysfs_remove_fs_devices(struct btrfs_fs_devices *fs_devices)
>>>>>          }
>>>>> }
>>>>>
>>>>> -void btrfs_sysfs_remove_mounted(struct btrfs_fs_info *fs_info)
>>>>> +/*
>>>>> + * Remove attributes which may have store callbacks. kernfs waits for active
>>>>> + * callbacks during removal, so this must be done before stopping any kthread
>>>>> + * which can be woken up by those callbacks.
>>>>> + */
>>>>> +void btrfs_sysfs_remove_mounted_attrs(struct btrfs_fs_info *fs_info)
>>>>> {
>>>>>          struct kobject *fsid_kobj = &fs_info->fs_devices->fsid_kobj;
>>>>>
>>>>> -     sysfs_remove_link(fsid_kobj, "bdi");
>>>>> +     addrm_unknown_feature_attrs(fs_info, false);
>>>>> +     sysfs_remove_group(fsid_kobj, &btrfs_feature_attr_group);
>>>>> +     sysfs_remove_files(fsid_kobj, btrfs_attrs);
>>>>> +}
>>>>> +
>>>>> +static void btrfs_sysfs_remove_mounted_dirs(struct btrfs_fs_info *fs_info)
>>>>> +{
>>>>> +     sysfs_remove_link(&fs_info->fs_devices->fsid_kobj, "bdi");
>>>>>
>>>>>          if (fs_info->space_info_kobj) {
>>>>>                sysfs_remove_files(fs_info->space_info_kobj, allocation_attrs);
>>>>> @@ -1730,9 +1742,18 @@ void btrfs_sysfs_remove_mounted(struct btrfs_fs_info *fs_info)
>>>>>                kobject_put(fs_info->debug_kobj);
>>>>>          }
>>>>> #endif
>>>>> -     addrm_unknown_feature_attrs(fs_info, false);
>>>>> -     sysfs_remove_group(fsid_kobj, &btrfs_feature_attr_group);
>>>>> -     sysfs_remove_files(fsid_kobj, btrfs_attrs);
>>>>> +}
>>>>> +
>>>>> +void btrfs_sysfs_remove_mounted_kobjects(struct btrfs_fs_info *fs_info)
>>>>> +{
>>>>> +     btrfs_sysfs_remove_mounted_dirs(fs_info);
>>>>> +     btrfs_sysfs_remove_fs_devices(fs_info->fs_devices);
>>>>> +}
>>>>> +
>>>>> +void btrfs_sysfs_remove_mounted(struct btrfs_fs_info *fs_info)
>>>>> +{
>>>>> +     btrfs_sysfs_remove_mounted_dirs(fs_info);
>>>>> +     btrfs_sysfs_remove_mounted_attrs(fs_info);
>>>>>          btrfs_sysfs_remove_fs_devices(fs_info->fs_devices);
>>>>> }
>>>>>
>>>>> diff --git a/fs/btrfs/sysfs.h b/fs/btrfs/sysfs.h
>>>>> index 05498e5346c3..0d008fc8f1b8 100644
>>>>> --- a/fs/btrfs/sysfs.h
>>>>> +++ b/fs/btrfs/sysfs.h
>>>>> @@ -35,6 +35,9 @@ void btrfs_kobject_uevent(struct block_device *bdev, enum kobject_action action)
>>>>> int __init btrfs_init_sysfs(void);
>>>>> void __cold btrfs_exit_sysfs(void);
>>>>> int btrfs_sysfs_add_mounted(struct btrfs_fs_info *fs_info);
>>>>> +void btrfs_sysfs_remove_mounted_attrs(struct btrfs_fs_info *fs_info);
>>>>> +void btrfs_sysfs_remove_mounted_kobjects(struct btrfs_fs_info *fs_info);
>>>>> void btrfs_sysfs_remove_mounted(struct btrfs_fs_info *fs_info);
>>>>> void btrfs_sysfs_add_block_group_type(struct btrfs_block_group *cache);
>>>>> int btrfs_sysfs_add_space_info_type(struct btrfs_space_info *space_info);

