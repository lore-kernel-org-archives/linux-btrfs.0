Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:47574 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbeGMHeI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Jul 2018 03:34:08 -0400
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
 <09411b1f-f92d-ed7e-2a12-b12d352f780a@oracle.com>
 <a5635255-2aaa-7091-8723-93912ff126dd@gmx.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <369f812e-b82a-a0f7-a6b1-b5259d24a728@oracle.com>
Date: Fri, 13 Jul 2018 15:24:04 +0800
MIME-Version: 1.0
In-Reply-To: <a5635255-2aaa-7091-8723-93912ff126dd@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/13/2018 01:39 PM, Qu Wenruo wrote:
> 
> 
> On 2018年07月13日 13:32, Anand Jain wrote:
>>
>>
>>
>>
>>
>>>> But if you are planning to
>>>>     record and start at transaction [14] then its an overkill because
>>>>     transaction [19 and [20] are already in the disk.
>>>
>>> Yes, I'm doing it overkilled.
>>
>>   Ah. Ok.
>>
>>> But it's already much better than scrub all block groups (my original
>>> plan).
>>
>>   That's true. Which can be optimized later, but how? and scrub can't
>>   fix RAID1.
> 
> How could scrub not fix RAID1?

  Because degraded RAID1 allocates and writes data to the single chunks.
  There is no mirrored copy of these data and it would remain as it is
  even after the scrub.

> For metadata or data with csum, just goes normal scrub.

  Still need to fix the generation check for bg/parent transit
  verification across the trees/disks part. IMO.

> For data without csum, we know which device is resilvering, just use the
> other copy.

  If its a short term fix then its ok. But I think the approach is
  similar to Liubo's InSync patch. Problem with this is, we will fail
  to recover any data when the good disk throws media errors.

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
>>>>
>>>> Thanks, Anand
>>>>
>>>>
>>>>> Thanks,
>>>>> Qu
>>>>>
>>>>>>       [3] https://patchwork.kernel.org/patch/10403311/
>>>>>>
>>>>>>     Further, as we do a self adapting chunk allocation in RAID1, it
>>>>>> needs
>>>>>>     balance-convert to fix. IMO at some point we have to provide
>>>>>> degraded
>>>>>>     raid1 chunk allocation and also modify the scrub to be chunk
>>>>>> granular.
>>>>>>
>>>>>> Thanks, Anand
>>>>>>
>>>>>>> Any idea on this?
>>>>>>>
>>>>>>> Thanks,
>>>>>>> Qu
>>>>>>>
>>>>>>>> Unlock: btrfs_fs_info::chunk_mutex
>>>>>>>> Unlock: btrfs_fs_devices::device_list_mutex
>>>>>>>>
>>>>>>>> -----------------------------------------------------------------------
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>> Thanks, Anand
>>>>>>>> -- 
>>>>>>>> To unsubscribe from this list: send the line "unsubscribe
>>>>>>>> linux-btrfs" in
>>>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>>>
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
> 
