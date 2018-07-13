Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:42674 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbeGMFmJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Jul 2018 01:42:09 -0400
Subject: Re: [DOC] BTRFS Volume operations, Device Lists and Locks all in one
 page
To: Qu Wenruo <quwenruo.btrfs@gmx.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <4fba8087-ebbe-1d05-1f72-e1683981235e@oracle.com>
 <db352d50-ce1b-f5fe-afbb-57bdd322b5fb@gmx.com>
 <49fc4dbb-5e02-ab13-d7f1-7e52bf8868d6@oracle.com>
 <e968020c-f68a-16f2-521b-6aaa08e9d654@gmx.com>
 <940b5763-3144-954b-ee90-71270a348b21@oracle.com>
 <84f4c573-9831-8c2f-0370-78ea3018b569@gmx.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <09411b1f-f92d-ed7e-2a12-b12d352f780a@oracle.com>
Date: Fri, 13 Jul 2018 13:32:26 +0800
MIME-Version: 1.0
In-Reply-To: <84f4c573-9831-8c2f-0370-78ea3018b569@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>






>> But if you are planning to
>>    record and start at transaction [14] then its an overkill because
>>    transaction [19 and [20] are already in the disk.
> 
> Yes, I'm doing it overkilled.

  Ah. Ok.

> But it's already much better than scrub all block groups (my original plan).

  That's true. Which can be optimized later, but how? and scrub can't
  fix RAID1.

Thanks, Anand


> Thanks,
> Qu
> 
>>
>> Thanks, Anand
>>
>>
>>> Thanks,
>>> Qu
>>>
>>>>      [3] https://patchwork.kernel.org/patch/10403311/
>>>>
>>>>    Further, as we do a self adapting chunk allocation in RAID1, it needs
>>>>    balance-convert to fix. IMO at some point we have to provide degraded
>>>>    raid1 chunk allocation and also modify the scrub to be chunk granular.
>>>>
>>>> Thanks, Anand
>>>>
>>>>> Any idea on this?
>>>>>
>>>>> Thanks,
>>>>> Qu
>>>>>
>>>>>> Unlock: btrfs_fs_info::chunk_mutex
>>>>>> Unlock: btrfs_fs_devices::device_list_mutex
>>>>>>
>>>>>> -----------------------------------------------------------------------
>>>>>>
>>>>>>
>>>>>> Thanks, Anand
>>>>>> -- 
>>>>>> To unsubscribe from this list: send the line "unsubscribe
>>>>>> linux-btrfs" in
>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>
>>>> -- 
>>>> To unsubscribe from this list: send the line "unsubscribe
>>>> linux-btrfs" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
