Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm03.jp.fujitsu.com ([202.219.69.170]:60555 "EHLO
        mgwkm03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753188AbeF0IUe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Jun 2018 04:20:34 -0400
Received: from g01jpfmpwyt02.exch.g01.fujitsu.local (g01jpfmpwyt02.exch.g01.fujitsu.local [10.128.193.56])
        by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 0C81BAC029E
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Jun 2018 17:20:31 +0900 (JST)
Subject: Re: Enabling quota may not correctly rescan on 4.17
To: Nikolay Borisov <nborisov@suse.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <0ced0e29-9ecc-01fb-b0a5-9de32966666e@jp.fujitsu.com>
 <02577dd9-af06-95a6-77b4-954b583536e8@suse.com>
 <60daf28c-b76c-60b7-34b4-88ea2e5d8ae3@jp.fujitsu.com>
 <b44d6839-3db3-ff29-a5ca-519185b601b4@suse.com>
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Message-ID: <b9fad77c-c55d-5ca3-5ea8-17b8b2861225@jp.fujitsu.com>
Date: Wed, 27 Jun 2018 17:20:25 +0900
MIME-Version: 1.0
In-Reply-To: <b44d6839-3db3-ff29-a5ca-519185b601b4@suse.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018/06/27 17:04, Nikolay Borisov wrote:
> 
> 
> On 27.06.2018 10:55, Misono Tomohiro wrote:
>> On 2018/06/27 16:40, Nikolay Borisov wrote:
>>>
>>>
>>> On 26.06.2018 09:00, Misono Tomohiro wrote:
>>>> Hello Nikolay,
>>>>
>>>> I noticed that commit 5d23515be669 ("btrfs: Move qgroup rescan
>>>> on quota enable to btrfs_quota_enable") in 4.17 sometimes causes
>>>> to fail correctly rescanning quota when quota is enabled.
>>>>
>>>> Simple reproducer:
>>>>
>>>> $ mkfs.btrfs -f $DEV
>>>> $ mount $DEV /mnt
>>>> $ dd if=/dev/urandom of=/mnt/file bs=1000 count=1000
>>>> $ btrfs quota enbale /mnt
>>>> $ umount /mnt
>>>> $ btrfs check $DEV
>>>> ...
>>>> checking quota groups
>>>> Counts for qgroup id: 0/5 are different
>>>> our:            referenced 1019904 referenced compressed 1019904
>>>> disk:           referenced 16384 referenced compressed 16384
>>>> diff:           referenced 1003520 referenced compressed 1003520
>>>> our:            exclusive 1019904 exclusive compressed 1019904
>>>> disk:           exclusive 16384 exclusive compressed 16384
>>>> diff:           exclusive 1003520 exclusive compressed 1003520
>>>> found 1413120 bytes used, error(s) found
>>>> ...
>>>
>>> I ran your script 100 times with progs 4.17 and 4.18-rc1 and didn't
>>> observe this error. I didn't observe btrfs/114 also failing but I ran it
>>> a lot less. Is there anything else i can do to make your small
>>> reproducer more likely to trigger?
>>
>> How about btrfs/114? I saw the problem in it first (progs 4.17/kernel 4.18-rc2)
>> and it seems always happen in my environment. 
> 
> So far nothing, I'm using David's github/misc-next branch, and latest
> commit is: 5330a89b3ee3.
> 
> My mount options are:
> 
> MOUNT_OPTIONS -- -o enospc_debug -o space_cache=v2 /dev/vdc /media/scratch

I can see the failure with or without options...
maybe it depends on machine spec?

> 
>>
>>>
>>>>
>>>> This can be also observed in btrfs/114. (Note that progs < 4.17
>>>> returns error code 0 even if quota is not consistency and therefore
>>>> test will incorrectly pass.)
>>>>
>>>> My observation is that this commit changed to call initial quota rescan
>>>> when quota is enabeld instead of first comit transaction after enabling
>>>> quota, and therefore if there is something not commited at that time,
>>>> their usage will not be accounted.
>>>>
>>>> Actually this can be simply fixed by calling "btrfs rescan" again or
>>>> calling "btrfs fi sync" before "btrfs quota enable".
>>>>
>>>> I think the commit itself makes the code much easier to read, so it may
>>>> be better to fix the problem in progs (i.e. calling sync before quota enable).
>>>>
>>>> Do you have any thoughts?
>>>>
>>>> Thanks,
>>>> Tomohiro Misono
>>>>
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 

