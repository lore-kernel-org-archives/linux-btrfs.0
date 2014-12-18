Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:55657 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750959AbaLRJXT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Dec 2014 04:23:19 -0500
Message-ID: <54929D05.8040902@cn.fujitsu.com>
Date: Thu, 18 Dec 2014 17:23:17 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <bo.li.liu@oracle.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: Enhance btrfs chunk allocation algorithm to reduce
 ENOSPC caused by unbalanced data/metadata allocation.
References: <1414031871-10859-1-git-send-email-quwenruo@cn.fujitsu.com> <20141024110624.GB32526@localhost.localdomain> <544D8F44.8050706@cn.fujitsu.com> <20141027081456.GD27271@localhost.localdomain> <544E040A.3090407@cn.fujitsu.com> <20141029142917.GA9547@localhost.localdomain> <54518D1F.9040008@cn.fujitsu.com> <5451B48A.4080508@cn.fujitsu.com> <20141030093941.GC26064@localhost.localdomain>
In-Reply-To: <20141030093941.GC26064@localhost.localdomain>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH] btrfs: Enhance btrfs chunk allocation algorithm to 
reduce ENOSPC caused by unbalanced data/metadata allocation.
From: Liu Bo <bo.li.liu@oracle.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2014年10月30日 17:39
> On Thu, Oct 30, 2014 at 11:46:18AM +0800, Qu Wenruo wrote:
>> [snipped]
> Okay, I buy this.
>
>> Thanks,
>> Qu
>>>>> Thanks,
>>>>> Qu
>>>>>>>>> [snipped]
>>>>>>>>>       /*
>>>>>>>>> +     * Try not to occupy more than half of the unallocated space.
>>>>>>>>> +     * When run short of space and alloc all the space to
>>>>>>>>> +     * data/metadata will cause ENOSPC to be
>>>>>>>>> triggered more easily.
>>>>>>>>> +     *
>>>>>>>>> +     * And since the minimum chunk size is 16M, the
>>>>>>>>> half-half will cause
>>>>>>>>> +     * 16M allocated from 20M available space and
>>>>>>>>> reset 4M will not be
>>>>>>>>> +     * used ever. In that case(16~32M), allocate all directly.
>>>>>>>>> +     */
>>>>>>>>> +    if (total_avail_space < 32 * 1024 * 1024 &&
>>>>>>>>> +        total_avail_space > 16 * 1024 * 1024)
>>>>>>>>> +        max_chunk_size = total_avail_space;
>>>>>>>>> +    else
>>>>>>>>> +        max_chunk_size = min(total_avail_space / 2,
>>>>>>>>> max_chunk_size);
>>>>>>>>> +    max_chunk_size = min(total_avail_space / 2, max_chunk_size);
>                ^^^^^^^^
>
> Why another one?  This won't make it use all space within [16M, 32M].
>
> thanks,
> -liubo
Sorry for the later reply, I didn't notice the mail for a long time.

Yes, that's my mistake setting the size twice...
Will fix it soon.

Thanks,
Qu
>
>>>>>>>>> +
>>>>>>>>> +    /*
>>>>>>>>>        * now sort the devices by hole size / available space
>>>>>>>>>        */
>>>>>>>>>       sort(devices_info, ndevs, sizeof(struct btrfs_device_info),
>>>>>>>>> -- 
>>>>>>>>> 2.1.2
>>>>>>>>>
>>>>>>>>> -- 
>>>>>>>>> To unsubscribe from this list: send the line
>>>>>>>>> "unsubscribe linux-btrfs" in
>>>>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>>>>> More majordomo info at http://vger.kernel.org/majordomo-info.html

