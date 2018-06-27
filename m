Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45159 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933107AbeF0IE4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Jun 2018 04:04:56 -0400
Subject: Re: Enabling quota may not correctly rescan on 4.17
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <0ced0e29-9ecc-01fb-b0a5-9de32966666e@jp.fujitsu.com>
 <02577dd9-af06-95a6-77b4-954b583536e8@suse.com>
 <60daf28c-b76c-60b7-34b4-88ea2e5d8ae3@jp.fujitsu.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <b44d6839-3db3-ff29-a5ca-519185b601b4@suse.com>
Date: Wed, 27 Jun 2018 11:04:53 +0300
MIME-Version: 1.0
In-Reply-To: <60daf28c-b76c-60b7-34b4-88ea2e5d8ae3@jp.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 27.06.2018 10:55, Misono Tomohiro wrote:
> On 2018/06/27 16:40, Nikolay Borisov wrote:
>>
>>
>> On 26.06.2018 09:00, Misono Tomohiro wrote:
>>> Hello Nikolay,
>>>
>>> I noticed that commit 5d23515be669 ("btrfs: Move qgroup rescan
>>> on quota enable to btrfs_quota_enable") in 4.17 sometimes causes
>>> to fail correctly rescanning quota when quota is enabled.
>>>
>>> Simple reproducer:
>>>
>>> $ mkfs.btrfs -f $DEV
>>> $ mount $DEV /mnt
>>> $ dd if=/dev/urandom of=/mnt/file bs=1000 count=1000
>>> $ btrfs quota enbale /mnt
>>> $ umount /mnt
>>> $ btrfs check $DEV
>>> ...
>>> checking quota groups
>>> Counts for qgroup id: 0/5 are different
>>> our:            referenced 1019904 referenced compressed 1019904
>>> disk:           referenced 16384 referenced compressed 16384
>>> diff:           referenced 1003520 referenced compressed 1003520
>>> our:            exclusive 1019904 exclusive compressed 1019904
>>> disk:           exclusive 16384 exclusive compressed 16384
>>> diff:           exclusive 1003520 exclusive compressed 1003520
>>> found 1413120 bytes used, error(s) found
>>> ...
>>
>> I ran your script 100 times with progs 4.17 and 4.18-rc1 and didn't
>> observe this error. I didn't observe btrfs/114 also failing but I ran it
>> a lot less. Is there anything else i can do to make your small
>> reproducer more likely to trigger?
> 
> How about btrfs/114? I saw the problem in it first (progs 4.17/kernel 4.18-rc2)
> and it seems always happen in my environment. 

So far nothing, I'm using David's github/misc-next branch, and latest
commit is: 5330a89b3ee3.

My mount options are:

MOUNT_OPTIONS -- -o enospc_debug -o space_cache=v2 /dev/vdc /media/scratch

> 
>>
>>>
>>> This can be also observed in btrfs/114. (Note that progs < 4.17
>>> returns error code 0 even if quota is not consistency and therefore
>>> test will incorrectly pass.)
>>>
>>> My observation is that this commit changed to call initial quota rescan
>>> when quota is enabeld instead of first comit transaction after enabling
>>> quota, and therefore if there is something not commited at that time,
>>> their usage will not be accounted.
>>>
>>> Actually this can be simply fixed by calling "btrfs rescan" again or
>>> calling "btrfs fi sync" before "btrfs quota enable".
>>>
>>> I think the commit itself makes the code much easier to read, so it may
>>> be better to fix the problem in progs (i.e. calling sync before quota enable).
>>>
>>> Do you have any thoughts?
>>>
>>> Thanks,
>>> Tomohiro Misono
>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
