Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26056 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750786AbdKBF4q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Nov 2017 01:56:46 -0400
Subject: Re: [PATCH v2 1/2] btrfs: match btrfs_device->mode same as it used
 for open
To: Nikolay Borisov <nborisov@suse.com>, dsterba@suse.cz,
        linux-btrfs@vger.kernel.org
References: <20171020103325.9595-1-anand.jain@oracle.com>
 <20171020140715.3110-1-anand.jain@oracle.com>
 <20171030143938.GW3521@twin.jikos.cz>
 <0ae0edc8-2557-b3ba-9157-b5ecdf37d31c@oracle.com>
 <fb901ef0-d4ee-66e8-c8ba-2736d856a5ca@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <069ca762-6e7a-ff41-44ae-ff1db44e40d8@oracle.com>
Date: Thu, 2 Nov 2017 13:55:46 +0800
MIME-Version: 1.0
In-Reply-To: <fb901ef0-d4ee-66e8-c8ba-2736d856a5ca@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10/31/2017 10:21 PM, Nikolay Borisov wrote:
> 
> 
> On 31.10.2017 04:11, Anand Jain wrote:
>>
>>
>> On 10/30/2017 10:39 PM, David Sterba wrote:
>>> On Fri, Oct 20, 2017 at 10:07:15PM +0800, Anand Jain wrote:
>>>> We aren't setting the FMODE_WRITE when initializing btrfs_device
>>>> structure and when calling blkdev_put, however we are setting it
>>>> only when calling blkdev_get_by_path().
>>>
>>> But this still does not say why this is a problem worth fixing. Nikolay
>>> asked for it, and I would do the same, but why do we even have to ask
>>> for that?
>>
>>   Here its just a cleanup of miss match of open mode and close modes.>  And there isn't any problem that I noticed.
> 
> Even if that's the case, please state that explicitly in your changelog
> and also put "No functional changes" if you expect it to not introduce
> any change in behavior.
> 


Ah. Will update change log.

Thanks, Anand


>>
>> Thanks, Anand
>>
>>
>>> https://www.kernel.org/doc/html/latest/process/submitting-patches.html#describe-your-changes
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
