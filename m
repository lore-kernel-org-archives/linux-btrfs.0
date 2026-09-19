Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B9225785D
	for <linux-btrfs@vger.kernel.org>; Sat, 19 Sep 2026 22:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789858111; cv=none; b=rUZiqa4s+KCOC5HJtAf/aCLt8VewpkI3NuwFb6JY1xGhLg7B2AuTNx6YVyoFFAcBdX55BUYzq7E0v0S/RRJNhQoWbr3UNTEhu911Oz/GynFMTqS/JDjeb/m6LHGSluc8aNLgVd91TrQyDI1dtIbpogfQexVmjWbSVXqoLgsFzTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789858111; c=relaxed/simple;
	bh=Z3Wpj0D4OQDBhw1ep/9u210zS6fVAe4BWuUVZvcgG0w=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=GzoSCICT18SQAxjNUNgHQmBrXcYF5FCcN18qM9To+QgrnUf3rvFxlknCl0nTBlP5ESCBSKTH9QuPWq59iGEoQm0PZBIUIxdnszcLiAXdQ9M6EEtalKoiapPNwzQXElXgvd4p8xBZ0P6XxWlf2R68rUHyAvA4oD1c3hSXejnsL/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=TqlOMu2X; arc=none smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="TqlOMu2X"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c29d33431c8so256219366b.2
        for <linux-btrfs@vger.kernel.org>; Sat, 19 Sep 2026 15:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789858108; x=1790462908; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:references:cc:to:from:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=VCWFC2ahy1XpyERV+64Yyy09zS49ZbAWWk1PcEV3MRU=;
        b=TqlOMu2X3FUykP5IEs4L9bElfYcZx9HF+KwCm/easHpO3z/Yqs5eg5e2X8esKMAt1L
         y15yJZrvv5mnQY7OePPH9wbaQswNI3gZ21JXkk5JlLLr+xkOdbX9ccDgtRJRI//IbJAq
         wQ51moS/TdGOf3VTdWtEij1aUbCGeoI5LZXs6dA0oiqPsrq+aaseiImM+BGMk77Q9/cM
         kmBbqjRwYhEuxeTU4OBdLHFCBv4kHXZs8Y7E9RgM6QwXdnx6BJpRgowUVjICEziAl45U
         +FL50i2UYlonti70NrGu0xPzpjAOG28SoZONMBkiizAGvagRqEJK8bVVU2q5cgYxgJJh
         stuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789858108; x=1790462908;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:references:cc:to:from:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=VCWFC2ahy1XpyERV+64Yyy09zS49ZbAWWk1PcEV3MRU=;
        b=dG4Gd+jvvUHDiSj0kEIblrOwe58rlVm7AQR17gOze9ysH5yHdJUHiq4hAZT0ciduzV
         iQZ56Ot75GnXpMgWVSNJZ684z4SrQdv2Tby6MG2TbWYmQdBsmY8V8Afpxsgd9Sd4PN8L
         N24kxt4enX/Gi0Cn5WhDt/U7DNiD3XIHKUCUtmun3efiLds8YBTcnKa35gcr7iq0TABu
         0N2NJFOHDjnCOm25JNhf72zM0FZGmXJbZbfozZBOGvsphSZtcA2DOzWX9rmvKgYDqluy
         55wdE1K+c5AV8feeKEcKau5tMcQkWYP6YGbWy19TRw3deqEkVypV88rjk9na/zkNIYfe
         wZAA==
X-Gm-Message-State: AFuF++k98iBIXm2TFssc2UvmaquFuUfiygZ6dS9d9Fre3ypJGMy80paH
	pgTdyj0Z68t2Bcr3hZomgUoOdfkpSuVkkXERLdzkF2HG8QkzCeWG6QB9bmSc54x26OlmoZypGxP
	Rqy5BZm8=
X-Gm-Gg: AYBFou2/P9HcVKfDXSR7gPSX7wDppoxl+jtJa8l75niNxaT2aJWFCtDnbNS2aZ5Usi4
	OzC4W2YdIrEAEowozyBiWLrZ4P2ofeMVd2KpTiDE0lorz9cyVA3MxCPnYuLaVHi8tIKnkMSscOt
	2fReNmnQXQ255kq2JPRZj+0cihnJwQkNjrnb7CLjoIjpu5ba5F+dxwTDJr2MibxxoPTj7hvLa/v
	SbYeSL9VTQe3i3eJpgv7OopxBall+ujyUVcFl8/k3pUtODKoQxOZ1zCAm8ICk2xmUoAjHe8LkgR
	f4niD8onyr9qU4CA+cjdE8WwCNzfhxOK4aTJT1JMS/vMvsHhrzgkKCrp3zELzBlB8i+OxwSZ34P
	VJNX3U18GIqI2+fdEwt1wRLqNTBu6Hl4szAALPCmF7KRsESchKaiJZD0vF4hAUrIm9Sx1/hPUwZ
	nCfI14LYbvVc6GG0pyCq1HVY+YcNyEBknpfOCs7eqsG5l+YwvN8CtiVyasozJfxyc=
X-Received: by 2002:a17:906:c111:b0:c29:53eb:9919 with SMTP id a640c23a62f3a-c2a157fbe47mr523333966b.40.1789858107714;
        Sat, 19 Sep 2026 15:48:27 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-877a95f2abesm1345496b3a.26.2026.09.19.15.48.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Sep 2026 15:48:25 -0700 (PDT)
Message-ID: <98f6ac8c-48ca-4d07-a120-2dbefcbb443f@suse.com>
Date: Sun, 20 Sep 2026 08:18:20 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: qgroup rescan worker makes suspend fail
From: Qu Wenruo <wqu@suse.com>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 Richard Weinberger <richard@nod.at>
Cc: linux-btrfs@vger.kernel.org
References: <mu8fq8a8.b9a9a1ae-dd6b-45a4-a415-5db853d61536@nod.at>
 <aq7HYO9SKdIaqvr_@mayhem.fritz.box>
 <38c0b7f1-a876-45ab-92e2-223e2f70d82d@suse.com>
Content-Language: en-US
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
In-Reply-To: <38c0b7f1-a876-45ab-92e2-223e2f70d82d@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/9/20 08:09, Qu Wenruo 写道:
> 
> 
> 在 2026/9/20 03:04, Johannes Thumshirn 写道:
>> On Sat, Sep 19, 2026 at 01:40:27PM +0000, Richard Weinberger wrote:
>>> Once in a while, suspending my laptop just causes the screen to freeze.
>>> Initially, I thought Linux had crashed, but it usually recovers after 
>>> 2 minutes,
>>> though the suspend doesn't actually happen. You can imagine this can 
>>> be very
>>> unfortunate when you just close the laptop lid and pack the laptop 
>>> into your
>>> bag...
>>>
>>> After the problem started occurring more frequently, I investigated 
>>> and found
>>> that the qgroup rescan worker is the problem. In dmesg, logs like 
>>> these can
>>> usually be found:
> 
> To be honest, qgroup mode is no longer recommended, except for rigid 
> subvolume layouts, and since you need rescan it's definitely the not 
> recommended case.
> 
> The current only well known user is snapper, and we're pushing snapper 
> not to utilize qgroup by default.
> 
> So unless you have a very clear use case, it's better just disable 
> qgroups completely.
>>>
>>> [246013.777637] [ T278489] Freezing remaining freezable tasks
>>> [246033.780538] [ T278489] Freezing remaining freezable tasks failed 
>>> after 20.003 seconds (0 tasks refusing to freeze, wq_busy=1):
>>> [246033.780576] [ T278489] Showing freezable workqueues that are 
>>> still busy:
>>> [246033.780582] [ T278489] workqueue events_freezable: flags=0x104
>>> [246033.780590] [ T278489]   pwq 10: cpus=2 node=0 flags=0x0 nice=0 
>>> active=0 refcnt=2
>>> [246033.780609] [ T278489]     inactive: pci_pme_list_scan
>>> [246033.780642] [ T278489] workqueue btrfs-endio-meta: flags=0xe
>>> [246033.780649] [ T278489]   pwq 57: cpus=0-13 node=0 flags=0x4 
>>> nice=0 active=0 refcnt=2
>>> [246033.780660] [ T278489]     inactive: simple_end_io_work [btrfs]
>>> [246033.781183] [ T278489] workqueue btrfs-qgroup-rescan: flags=0x2000e
>>> [246033.781189] [ T278489]   pwq 56: cpus=0-13 flags=0x4 nice=0 
>>> active=1 refcnt=16
>>> [246033.781199] [ T278489]     in-flight: 205929:btrfs_work_helper 
>>> [btrfs] for 111s
>>> [246033.781721] [ T278489] workqueue wg-kex-wginterproc: flags=0x6
>>> [246033.781726] [ T278489]   pwq 57: cpus=0-13 node=0 flags=0x4 
>>> nice=0 active=0 refcnt=2
>>> [246033.781736] [ T278489]     inactive: 
>>> wg_packet_handshake_send_worker [wireguard]
>>>
>>> My first thought was that the worker is likely not freezable, but it is.
>>> The problem is that the whole qgroup rescan is a single work item.
>>> In my case, such a scan can take up to 10 minutes, even though I have a
>>> fast NVMe SSD installed...
>>>
>>> Wouldn't it make sense to have rescan_should_stop() return true when
>>> suspend starts? I think using a pm notifier could help here.
>>> What do you think?
>>
>> Something like this (completely untested):
>>
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index a1d83ad9a4c0..541735d8fdb6 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -17,6 +17,7 @@
>>   #include <linux/error-injection.h>
>>   #include <linux/crc32c.h>
>>   #include <linux/sched/mm.h>
>> +#include <linux/suspend.h>
>>   #include <linux/unaligned.h>
>>   #include "ctree.h"
>>   #include "disk-io.h"
>> @@ -3198,6 +3199,29 @@ int btrfs_start_pre_rw_mount(struct 
>> btrfs_fs_info *fs_info)
>>       return 0;
>>   }
>> +static int btrfs_pm_notifier(struct notifier_block *nb, unsigned long 
>> action,
>> +                 void *data)
>> +{
>> +    struct btrfs_fs_info *fs_info = container_of(nb, struct 
>> btrfs_fs_info,
>> +                             pm_notifier);
> 
> IIRC this is a little too complex, we had similar cases in scrub, which 
> checks "freezing(current)".

OK, that doesn't work for freezable workqueue.

But we still have super block level s_writers.frozen checks to detect if 
the fs is being frozen.
It may not be good enough depending on if pm freezes processes or fs first.

I think it may be better to migrate the qgroup rescan worker to a 
dedicated kthread instead, then we can have much simpler checks.

Thanks,
Qu
> 
> That looks like a much simpler solution.
> 
> Thanks,
> Qu
> 
>> +
>> +    switch (action) {
>> +    case PM_HIBERNATION_PREPARE:
>> +    case PM_SUSPEND_PREPARE:
>> +    case PM_RESTORE_PREPARE:
>> +        set_bit(BTRFS_FS_PM_SUSPENDING, &fs_info->flags);
>> +        break;
>> +    case PM_POST_HIBERNATION:
>> +    case PM_POST_SUSPEND:
>> +    case PM_POST_RESTORE:
>> +        clear_bit(BTRFS_FS_PM_SUSPENDING, &fs_info->flags);
>> +        btrfs_qgroup_rescan_resume(fs_info);
>> +        break;
>> +    }
>> +
>> +    return NOTIFY_DONE;
>> +}
>> +
>>   /*
>>    * Do various sanity and dependency checks of different features.
>>    *
>> @@ -3794,6 +3818,9 @@ int __cold open_ctree(struct super_block *sb, 
>> struct btrfs_fs_devices *fs_device
>>       set_bit(BTRFS_FS_OPEN, &fs_info->flags);
>> +    fs_info->pm_notifier.notifier_call = btrfs_pm_notifier;
>> +    register_pm_notifier(&fs_info->pm_notifier);
>> +
>>       /* Kick the cleaner thread so it'll start deleting snapshots. */
>>       if (test_bit(BTRFS_FS_UNFINISHED_DROPS, &fs_info->flags))
>>           wake_up_process(fs_info->cleaner_kthread);
>> @@ -4370,6 +4397,8 @@ void __cold close_ctree(struct btrfs_fs_info 
>> *fs_info)
>>        */
>>       kthread_park(fs_info->cleaner_kthread);
>> +    unregister_pm_notifier(&fs_info->pm_notifier);
>> +
>>       /* wait for the qgroup rescan worker to stop */
>>       btrfs_qgroup_wait_for_completion(fs_info, false);
>> diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
>> index 3eba8438593c..caa90dc98e59 100644
>> --- a/fs/btrfs/fs.h
>> +++ b/fs/btrfs/fs.h
>> @@ -26,6 +26,7 @@
>>   #include <linux/wait_bit.h>
>>   #include <linux/sched.h>
>>   #include <linux/rbtree.h>
>> +#include <linux/notifier.h>
>>   #include <linux/xxhash.h>
>>   #include <linux/fserror.h>
>>   #include <uapi/linux/btrfs.h>
>> @@ -234,6 +235,8 @@ enum {
>>        */
>>       BTRFS_FS_UNALIGNED_TREE_BLOCK,
>> +    BTRFS_FS_PM_SUSPENDING,
>> +
>>   #if BITS_PER_LONG == 32
>>       /* Indicate if we have error/warn message printed on 32bit 
>> systems */
>>       BTRFS_FS_32BIT_ERROR,
>> @@ -841,6 +844,8 @@ struct btrfs_fs_info {
>>       u8 qgroup_drop_subtree_thres;
>>       u64 qgroup_enable_gen;
>> +    struct notifier_block pm_notifier;
>> +
>>       /*
>>        * If this is not 0, then it indicates a serious filesystem 
>> error has
>>        * happened and it contains that error (negative errno value).
>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>> index 05e35eb126dc..b4f1290d1e14 100644
>> --- a/fs/btrfs/qgroup.c
>> +++ b/fs/btrfs/qgroup.c
>> @@ -3883,6 +3883,7 @@ static void btrfs_qgroup_rescan_worker(struct 
>> btrfs_work *work)
>>       struct btrfs_trans_handle *trans = NULL;
>>       int ret = 0;
>>       bool stopped = false;
>> +    bool pm_paused = false;
>>       bool did_leaf_rescans = false;
>>       if (btrfs_qgroup_mode(fs_info) == BTRFS_QGROUP_MODE_SIMPLE)
>> @@ -3900,7 +3901,18 @@ static void btrfs_qgroup_rescan_worker(struct 
>> btrfs_work *work)
>>       path->search_commit_root = true;
>>       path->skip_locking = true;
>> -    while (!ret && !(stopped = rescan_should_stop(fs_info))) {
>> +    while (!ret) {
>> +        if (rescan_should_stop(fs_info)) {
>> +            stopped = true;
>> +            break;
>> +        }
>> +
>> +        if (test_bit(BTRFS_FS_PM_SUSPENDING, &fs_info->flags)) {
>> +            stopped = true;
>> +            pm_paused = true;
>> +            break;
>> +        }
>> +
>>           trans = btrfs_start_transaction(fs_info->fs_root, 0);
>>           if (IS_ERR(trans)) {
>>               ret = PTR_ERR(trans);
>> @@ -3963,12 +3975,17 @@ static void btrfs_qgroup_rescan_worker(struct 
>> btrfs_work *work)
>>       complete_all(&fs_info->qgroup_rescan_completion);
>>       mutex_unlock(&fs_info->qgroup_rescan_lock);
>> +    if (pm_paused && !test_bit(BTRFS_FS_PM_SUSPENDING, &fs_info->flags))
>> +        btrfs_qgroup_rescan_resume(fs_info);
>> +
>>       if (!trans)
>>           return;
>>       btrfs_end_transaction(trans);
>> -    if (stopped) {
>> +    if (pm_paused) {
>> +        btrfs_info(fs_info, "qgroup scan paused for system suspend");
>> +    } else if (stopped) {
>>           btrfs_info(fs_info, "qgroup scan paused");
>>       } else if (test_bit(BTRFS_QGROUP_RUNTIME_BIT_CANCEL_RESCAN, 
>> &fs_info->qgroup_flags)) {
>>           btrfs_info(fs_info, "qgroup scan cancelled");
>> @@ -4142,13 +4159,20 @@ int btrfs_qgroup_wait_for_completion(struct 
>> btrfs_fs_info *fs_info,
>>   void
>>   btrfs_qgroup_rescan_resume(struct btrfs_fs_info *fs_info)
>>   {
>> -    if (test_bit(BTRFS_QGROUP_STATUS_BIT_RESCAN, &fs_info- 
>> >qgroup_flags)) {
>> -        mutex_lock(&fs_info->qgroup_rescan_lock);
>> +    if (!test_bit(BTRFS_QGROUP_STATUS_BIT_RESCAN, &fs_info- 
>> >qgroup_flags))
>> +        return;
>> +
>> +    if (btrfs_fs_closing(fs_info))
>> +        return;
>> +
>> +    mutex_lock(&fs_info->qgroup_rescan_lock);
>> +    if (!fs_info->qgroup_rescan_running) {
>> +        reinit_completion(&fs_info->qgroup_rescan_completion);
>>           fs_info->qgroup_rescan_running = true;
>>           btrfs_queue_work(fs_info->qgroup_rescan_workers,
>>                    &fs_info->qgroup_rescan_work);
>> -        mutex_unlock(&fs_info->qgroup_rescan_lock);
>>       }
>> +    mutex_unlock(&fs_info->qgroup_rescan_lock);
>>   }
>>   #define rbtree_iterate_from_safe(node, next, start)                \
> 

