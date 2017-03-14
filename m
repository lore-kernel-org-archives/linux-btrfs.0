Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:58662 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750744AbdCNJJU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Mar 2017 05:09:20 -0400
Subject: Re: [PATCH v7 1/2] btrfs: Fix metadata underflow caused by
 btrfs_reloc_clone_csum error
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        <fdmanana@suse.com>
References: <20170308022552.14686-1-quwenruo@cn.fujitsu.com>
 <d4241168-4adf-6f36-af61-0487f7e74f91@profihost.ag>
 <03d57894-e8df-1001-b57a-daa205037f1c@cn.fujitsu.com>
 <899cc443-07ab-eb7a-5658-f68d8b8b3ce7@profihost.ag>
 <9aced194-dcf2-dbda-143b-dbf4b582822e@cn.fujitsu.com>
 <a6594c2f-d842-71af-54e1-f1576441dff4@profihost.ag>
 <1378f60c-da05-de19-1a17-4e9576f3343b@cn.fujitsu.com>
 <d85e1e17-a88d-9b37-c9b7-506fc57f64aa@profihost.ag>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <41f2abe3-6fc5-0f4f-26b4-69a6724864d7@cn.fujitsu.com>
Date: Tue, 14 Mar 2017 17:09:07 +0800
MIME-Version: 1.0
In-Reply-To: <d85e1e17-a88d-9b37-c9b7-506fc57f64aa@profihost.ag>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 03/14/2017 05:06 PM, Stefan Priebe - Profihost AG wrote:
> Thanks Qu, removing BTRFS_I from the inode fixes this issue to me.
>
> Greets,
> Stefan
>

Glad to hear that.

And a small tip is, when compiling kernel(at least btrfs module), any 
warning should be checked carefully.

Such type mismatch will cause a warning and can help us to avoid such 
problem.

Thanks,
Qu
>
> Am 14.03.2017 um 03:50 schrieb Qu Wenruo:
>>
>>
>> At 03/13/2017 09:26 PM, Stefan Priebe - Profihost AG wrote:
>>>
>>> Am 13.03.2017 um 08:39 schrieb Qu Wenruo:
>>>>
>>>>
>>>> At 03/13/2017 03:26 PM, Stefan Priebe - Profihost AG wrote:
>>>>> Hi Qu,
>>>>>
>>>>> Am 13.03.2017 um 02:16 schrieb Qu Wenruo:
>>>>>
>>>>> But wasn't this part of the code identical in V5? Why does it only
>>>>> happen with V7?
>>>>
>>>> There are still difference, but just as you said, the related
>>>> part(checking if inode is free space cache inode) is identical across v5
>>>> and v7.
>>>
>>> But if i boot v7 it always happens. If i boot v5 it always works. Have
>>> done 5 repeatet tests.
>>
>> I rechecked the code change between v7 and v5.
>>
>> It turns out that, the code base may cause the problem.
>>
>> In v7, the base is v4.11-rc1, which introduced quite a lot of
>> btrfs_inode cleanup.
>>
>> One of the difference is the parameter for btrfs_is_free_space_inode().
>>
>> In v7, the parameter @inode changed from struct inode to struct
>> btrfs_inode.
>>
>> So in v7, we're passing BTRFS_I(inode) to btrfs_is_free_space_inode(),
>> other than plain inode.
>>
>> That's the most possible cause for me here.
>>
>> So would you please paste the final patch applied to your tree?
>> Git diff or git format-patch can both handle it.
>>
>> Thanks,
>> Qu
>>
>>>
>>>> I'm afraid that's a rare race leading to NULL btrfs_inode->root, which
>>>> could happen in both v5 and v7.
>>>>
>>>> What's the difference between SUSE and mainline kernel?
>>>
>>> A lot ;-) But i don't think anything related.
>>>
>>>> Maybe some mainline kernel commits have already fixed it?
>>>
>>> May be no idea. But i haven't found any reason why v5 works.
>>>
>>> Stefan
>>>
>>>>
>>>> Thanks,
>>>> Qu
>>>>>
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


