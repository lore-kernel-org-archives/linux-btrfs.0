Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A4036B043
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Aug 2026 05:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787289713; cv=none; b=jMeCcoGKdAN/H5PmafJOCw8cbJlNN3k8zZofI7wH9ElTEV0HL3z2S5wIsvu4gowQDgPcIrVJfrU8kEKlyQ5OFXhafMpPKDZz2EpLkre2BqIM61lSE1l1NHQqHZkRXhzbouxi2Aage39heUJDoLOL/f8FdUdLimpCN4QQ2xny1cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787289713; c=relaxed/simple;
	bh=BAjoUga0yu0xaBmdkozEisGpDcBuF7jKSeP/P9gFDTQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DJD/0o8TZrnAknQ9JLJk320FLOCaJy7D2CMbeHxFH0PWv52T4fo7VCKU+x2LXBHnk8uvik/mOP6XNfnjhOShljITHSbenI6lyPhDh1W5QxKJGOXP8pd4G8JX6xX1+7ljPc4ar3KqEBU4bj85Af23/dR8gA6jTVMc7BllxBDubXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=XzAliBDT; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="XzAliBDT"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-490cf322ed0so5781425e9.1
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Aug 2026 22:21:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787289709; x=1787894509; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UyB3AD7YbRzkaurgWalfHTkpYIHtcCc6PspG28Getdk=;
        b=XzAliBDTIxQ8W+Lw+Ed+raT4ilcRvBHEnqyIF+k7WbPyblGirPDK57MC8qtuqtA4vI
         sDyg33fQZ6Z2n+bMPRuoMUZFI7yLVsnKm5EEeNTPnZnacQugwu60FMlSr6q77FERcaXc
         1Y9Srct8iBQK3YmXrCo24iAKNYDe1dqvUqArJiCGsfocXzhLVWrbjJT0NZ/HtFLeq0CX
         fD2S2t9nPNIYXZr9+lZB2YN9yeSOglGRk2TSJxM3MDcVOcoFy8C6oe1PVc5JFWXYDo2x
         toflVTZf6SlqGNTn1RZUAWMV6/jewh8Oe5Un3MnS5JDzHsaDsBvaPTLZ4mL1B8Kl/Ofo
         G02A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787289709; x=1787894509;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UyB3AD7YbRzkaurgWalfHTkpYIHtcCc6PspG28Getdk=;
        b=lx0HtO8K6wTm2eqKVj7/PNp4UBnQgM+kCRA/GSHux4Sttmr+eKJYuaatiiTLijAxke
         hsY3AMIFZFto4kgl1itpp0l7kv45G1eWiElLvyQWjSRti0ox7AQy4QATmd5KAwqxuVhv
         20RvRokbHbOZhb1EzdsGauLhLfI/OCsZavnqk9DWe2JmaJRu4XwpzK2cj54eWD0HHdSM
         Sttd96tU9qHb93Z7QqR9gvsLXieaEemBr+HGmL6eVdybVxE61orIefhXJjjrCj3ViBrA
         kl3zzHp8HcheK1PUXmFySSs0lUZAl4Ueo1MaSGiRy8P9OXooyabDauY5um0prprshiZX
         FX3w==
X-Forwarded-Encrypted: i=1; AHgh+RoTZ4gDrRR9FjXTGFlZ0kIk4kxs31Go0XZgmViLAWzjzB/5PmHz/Z70lR+FSgmPopQXx4BdMRL6p4K4FA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwHsrRtBs4Y+hO0jEils8p76mb3spDz8/JPa57Pdi9n2T3a5/DO
	vTYJFE81zs3DQ1byM+nx+2nnS8l5gSTNHNSw3COqIeDFTiQRGmPIxPJnT1goyHFkG+yTGKlIMZF
	a3Dq+v1k=
X-Gm-Gg: AR+sD13wQoHKZ3KqUdHfayA55r6VHRMYVhqzgS38dk50qKCor3qfQ4btrdhJGXLBM5O
	F/W3MhnyXHxZQC1orB9ZC1zepWevXgNl5pnfwuAoGAk0FUXUTjEQ1q8cc/Cwo76eIgxuZPMgeqJ
	77KdGoMvhxZVqdfV1dPwvblEOviepBuf62y2/CeW/RGXRDoCRxGafoz/VxCCcODXKjm+ca0mW/9
	Zh8/Go3rkVrajWlwF7ww4rzmWaGOXT5gz14w2/4jpXRKM8aZnj8mbW+LKccu1gdYUHcElKcvZSj
	kAeMZyG+CkPlQ4tCjdU1+18+s75qf2e/BIVC928W8mv7YmN+7Rx1Nm8YOT/oEqteMs36DY2izkL
	YIBZ9JnTlgvyTv4TzgX61+TboreL6KdysKzXbaHty9FcIn4P278TocVkesiAdi1joi2sp1vDI2g
	KZ+piOksufq/CmsA3hONRnf+IX0v+MLXxo9A5jDDW5hN0vb9ypFLg5pCR4dfS1sUh6
X-Received: by 2002:a05:600c:1548:b0:495:7888:281c with SMTP id 5b1f17b1804b1-499b8268eb4mr54451995e9.0.1787289709350;
        Thu, 20 Aug 2026 22:21:49 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327bef3cde4sm26462067eec.4.2026.08.20.22.21.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Aug 2026 22:21:48 -0700 (PDT)
Message-ID: <3dd5d093-0088-40d5-9daf-dd76f1839305@suse.com>
Date: Fri, 21 Aug 2026 14:51:42 +0930
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
In-Reply-To: <43775c17.162de.1a02295e080.Coremail.stitch@zju.edu.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/8/21 14:00, Jiacheng Xu 写道:
> Hi Wenruo,
> 
> I agree that rejecting sysfs writes when FS_OPEN is unset or
> CLOSING_START is set fixes the mount-time NULL pointer dereference.
> 
> However, checking these flags alone does not fully protect the teardown
> path. There is still a check-then-use race:
> 
>        sysfs store callback                close_ctree()
> 
>        test FS_OPEN == 1
>        test CLOSING_START == 0
> 
>                                             set CLOSING_START
>                                             kthread_stop(transaction_kthread)
> 
>        wake_up_process(transaction_kthread)
>        use a stopped or freed task_struct
> 
> Thus, the flag check fixes the reported initialization race, but a
> separate teardown race remains unless active sysfs callbacks are drained
> or otherwise synchronized before stopping transaction_kthread.

OK, then the next quesstion is, why we don't move the sysfs creation 
after the commit transaction creation.

Even with your patch, it didn't solve the problem that during mount the 
sysfs is created before transaction kthread.

So in theory it's possible to do sysfs write before kthread initialized, 
still causing NULL pointer dereference.

> 
> Thanks,
> Jiacheng
> 
>> -----原始邮件-----
>> 发件人: "Qu Wenruo" <wqu@suse.com>
>> 发送时间:2026-08-21 06:32:14 (星期五)
>> 收件人: "Jiacheng Xu" <stitch@zju.edu.cn>, "Chris Mason" <clm@fb.com>
>> 抄送: "David Sterba" <dsterba@suse.com>, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
>> 主题: Re: [PATCH] btrfs: drain sysfs callbacks before stopping transaction kthread
>>
>>
>>
>> 在 2026/8/20 21:57, Jiacheng Xu 写道:
>>> btrfs_label_store() and btrfs_feature_attr_store() wake up the
>>> transaction kthread through fs_info->transaction_kthread.
>>>
>>> During filesystem teardown, close_ctree() stops the transaction kthread
>>> before removing the mounted filesystem's sysfs attributes. A concurrent
>>> sysfs write can therefore enter one of these callbacks after the kthread
>>> has been stopped and pass an invalid task pointer to wake_up_process().
>>>
>>> This results in a concurrent null-pointer dereference in
>>> try_to_wake_up(). The scheduler is not the root cause; the invalid
>>> transaction kthread pointer is used by a Btrfs sysfs callback during
>>> teardown.
>>>
>>> Split mounted sysfs cleanup into two stages. Remove attributes which may
>>> have store callbacks before stopping the transaction kthread. The
>>> remaining sysfs kobjects are removed at the original teardown point,
>>> after the kthread has been stopped.
>>
>> Why not just simpliy reject sysfs write operations when the fs has
>> CLOSING_START or without FS_OPEN flags?
>>
>>>
>>> Apply the same ordering to the open_ctree() failure path when the
>>> transaction kthread has already been created.
>>>
>>> Tested-by: Jiacheng Xu <stitch@zju.edu.cn>
>>> Signed-off-by: Jiacheng Xu <stitch@zju.edu.cn>
>>> ---
>>> fs/btrfs/disk-io.c | 16 ++++++++++++++--
>>> fs/btrfs/sysfs.c   | 26 +++++++++++++++++++++-----
>>> fs/btrfs/sysfs.h   |  3 +++
>>> 3 files changed, 38 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>>> index 2f1666d9544e..4f5bcc576dc6 100644
>>> --- a/fs/btrfs/disk-io.c
>>> +++ b/fs/btrfs/disk-io.c
>>> @@ -3363,6 +3363,7 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
>>>         struct btrfs_root *tree_root;
>>>         struct btrfs_root *chunk_root;
>>>         struct btrfs_root *remap_root;
>>> +     bool sysfs_attrs_removed = false;
>>>         int ret;
>>>         int level;
>>>
>>> @@ -3780,6 +3781,9 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
>>> fail_qgroup:
>>>         btrfs_free_qgroup_config(fs_info);
>>> fail_trans_kthread:
>>> +     btrfs_sysfs_remove_mounted_attrs(fs_info);
>>> +     sysfs_attrs_removed = true;
>>> +
>>>         kthread_stop(fs_info->transaction_kthread);
>>>         btrfs_cleanup_transaction(fs_info);
>>>         btrfs_free_fs_roots(fs_info);
>>> @@ -3793,7 +3797,9 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
>>>         filemap_write_and_wait(fs_info->btree_inode->i_mapping);
>>>
>>> fail_sysfs:
>>> -     btrfs_sysfs_remove_mounted(fs_info);
>>> +     if (!sysfs_attrs_removed)
>>> +             btrfs_sysfs_remove_mounted_attrs(fs_info);
>>> +     btrfs_sysfs_remove_mounted_kobjects(fs_info);
>>>
>>> fail_fsdev_sysfs:
>>>         btrfs_sysfs_remove_fsid(fs_info->fs_devices);
>>> @@ -4318,6 +4324,9 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
>>>
>>>         set_bit(BTRFS_FS_CLOSING_START, &fs_info->flags);
>>>
>>> +     /* Drain sysfs callbacks before stopping the transaction kthread. */
>>> +     btrfs_sysfs_remove_mounted_attrs(fs_info);
>>> +
>>>         /*
>>>         * If we had UNFINISHED_DROPS we could still be processing them, so
>>>         * clear that bit and wake up relocation so it can stop.
>>> @@ -4538,7 +4547,7 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
>>>                           percpu_counter_sum(&fs_info->ordered_bytes));
>>>
>>> -     btrfs_sysfs_remove_mounted(fs_info);
>>> +     btrfs_sysfs_remove_mounted_kobjects(fs_info);
>>>         btrfs_sysfs_remove_fsid(fs_info->fs_devices);
>>>
>>>         btrfs_put_block_group_cache(fs_info);
>>>
>>> diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
>>> index 0d14570c8bc2..d90d76a152e9 100644
>>> --- a/fs/btrfs/sysfs.c
>>> +++ b/fs/btrfs/sysfs.c
>>> @@ -1707,11 +1707,23 @@ static void btrfs_sysfs_remove_fs_devices(struct btrfs_fs_devices *fs_devices)
>>>         }
>>> }
>>>
>>> -void btrfs_sysfs_remove_mounted(struct btrfs_fs_info *fs_info)
>>> +/*
>>> + * Remove attributes which may have store callbacks. kernfs waits for active
>>> + * callbacks during removal, so this must be done before stopping any kthread
>>> + * which can be woken up by those callbacks.
>>> + */
>>> +void btrfs_sysfs_remove_mounted_attrs(struct btrfs_fs_info *fs_info)
>>> {
>>>         struct kobject *fsid_kobj = &fs_info->fs_devices->fsid_kobj;
>>>
>>> -     sysfs_remove_link(fsid_kobj, "bdi");
>>> +     addrm_unknown_feature_attrs(fs_info, false);
>>> +     sysfs_remove_group(fsid_kobj, &btrfs_feature_attr_group);
>>> +     sysfs_remove_files(fsid_kobj, btrfs_attrs);
>>> +}
>>> +
>>> +static void btrfs_sysfs_remove_mounted_dirs(struct btrfs_fs_info *fs_info)
>>> +{
>>> +     sysfs_remove_link(&fs_info->fs_devices->fsid_kobj, "bdi");
>>>
>>>         if (fs_info->space_info_kobj) {
>>>               sysfs_remove_files(fs_info->space_info_kobj, allocation_attrs);
>>> @@ -1730,9 +1742,18 @@ void btrfs_sysfs_remove_mounted(struct btrfs_fs_info *fs_info)
>>>               kobject_put(fs_info->debug_kobj);
>>>         }
>>> #endif
>>> -     addrm_unknown_feature_attrs(fs_info, false);
>>> -     sysfs_remove_group(fsid_kobj, &btrfs_feature_attr_group);
>>> -     sysfs_remove_files(fsid_kobj, btrfs_attrs);
>>> +}
>>> +
>>> +void btrfs_sysfs_remove_mounted_kobjects(struct btrfs_fs_info *fs_info)
>>> +{
>>> +     btrfs_sysfs_remove_mounted_dirs(fs_info);
>>> +     btrfs_sysfs_remove_fs_devices(fs_info->fs_devices);
>>> +}
>>> +
>>> +void btrfs_sysfs_remove_mounted(struct btrfs_fs_info *fs_info)
>>> +{
>>> +     btrfs_sysfs_remove_mounted_dirs(fs_info);
>>> +     btrfs_sysfs_remove_mounted_attrs(fs_info);
>>>         btrfs_sysfs_remove_fs_devices(fs_info->fs_devices);
>>> }
>>>
>>> diff --git a/fs/btrfs/sysfs.h b/fs/btrfs/sysfs.h
>>> index 05498e5346c3..0d008fc8f1b8 100644
>>> --- a/fs/btrfs/sysfs.h
>>> +++ b/fs/btrfs/sysfs.h
>>> @@ -35,6 +35,9 @@ void btrfs_kobject_uevent(struct block_device *bdev, enum kobject_action action)
>>> int __init btrfs_init_sysfs(void);
>>> void __cold btrfs_exit_sysfs(void);
>>> int btrfs_sysfs_add_mounted(struct btrfs_fs_info *fs_info);
>>> +void btrfs_sysfs_remove_mounted_attrs(struct btrfs_fs_info *fs_info);
>>> +void btrfs_sysfs_remove_mounted_kobjects(struct btrfs_fs_info *fs_info);
>>> void btrfs_sysfs_remove_mounted(struct btrfs_fs_info *fs_info);
>>> void btrfs_sysfs_add_block_group_type(struct btrfs_block_group *cache);
>>> int btrfs_sysfs_add_space_info_type(struct btrfs_space_info *space_info);

