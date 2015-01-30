Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:39344 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752285AbbA3Cvy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Jan 2015 21:51:54 -0500
Message-ID: <54CAF1C8.5010001@cn.fujitsu.com>
Date: Fri, 30 Jan 2015 10:51:52 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Miao Xie <miaoxie@huawei.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH RESEND v4 2/8] btrfs: Make btrfs_parse_options() parse
 mount option in a atomic way
References: <1422498281-20493-1-git-send-email-quwenruo@cn.fujitsu.com> <1422498281-20493-3-git-send-email-quwenruo@cn.fujitsu.com> <54CAD0FC.4010503@huawei.com> <54CADC6E.2070703@cn.fujitsu.com> <54CADE7D.5000607@huawei.com> <54CADF5D.4000003@cn.fujitsu.com> <54CAE719.6060604@huawei.com>
In-Reply-To: <54CAE719.6060604@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH RESEND v4 2/8] btrfs: Make btrfs_parse_options() 
parse mount option in a atomic way
From: Miao Xie <miaoxie@huawei.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Date: 2015年01月30日 10:06
> On Fri, 30 Jan 2015 09:33:17 +0800, Qu Wenruo wrote:
>> -------- Original Message --------
>> Subject: Re: [PATCH RESEND v4 2/8] btrfs: Make btrfs_parse_options() parse mount
>> option in a atomic way
>> From: Miao Xie <miaoxie@huawei.com>
>> To: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
>> Date: 2015年01月30日 09:29
>>> On Fri, 30 Jan 2015 09:20:46 +0800, Qu Wenruo wrote:
>>>>> Here need ACCESS_ONCE to wrap info->mount_opt, or the complier might use
>>>>> info->mount_opt instead of new_opt.
>>>> Thanks for pointing out this one.
>>>>> But I worried that this is not key reason of the wrong space cache. Could
>>>>> you explain the race condition which caused the wrong space cache?
>>>>>
>>>>> Thanks
>>>>> Miao
>>>> CPU0:
>>>> remount()
>>>> |- sync_fs() <- after sync_fs() we can start new trans
>>>> |- btrfs_parse_options()     CPU1:
>>>>                       |- start_transaction()
>>>>                       |- Do some bg allocation, not recorded in space_cache.
>>> I think it is a bug if a free space is not recorded in space cache. Could you
>>> explain why it is not recorded?
>>>
>>> Thanks
>>> Miao
>> IIRC, in that window, the fs_info->mount_opt's SPACE_CACHE bit is cleared.
>> So space cache is not recorded.
> SPACE_CACHE is used to control cache write out, not in-memory cache. All the
> free space should be recorded in in-memory cache.And when we write out
> the in-memory space cache, we need protect the space cache from changing.
>
> Thanks
> Miao
You're right, the wrong space cache problem is not caused by the 
non-atomic mount option problem.
But the atomic mount option change with per-transaction mount option 
will at least make it disappear
when using nospace_cache mount option.

Thanks,
Qu
>
>> Thanks,
>> Qu
>>>>        |- set SPACE_CACHE bit due to cache_gen
>>>>
>>>>                       |- commit_transaction()
>>>>                           |- write space cache and update cache_gen.
>>>>                               but since some of it is not recorded in space
>>>> cache,
>>>>                               the space cache missing some records.
>>>>        |- clear SPACE_CACHE bit dut to nospace_cache
>>>>
>>>> So the space cache is wrong.
>>>>
>>>> Thanks,
>>>> Qu
>>>>>> +    }
>>>>>>         kfree(orig);
>>>>>>         return ret;
>>>>>>     }
>>>>>>
>>>> .
>>>>
>>

