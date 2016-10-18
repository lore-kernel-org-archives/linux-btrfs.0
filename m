Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:54449 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S933143AbcJRG5r (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Oct 2016 02:57:47 -0400
Subject: Re: speed up cp --reflink=always
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>,
        Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <6e902770-05f3-2562-eeb3-dd9ef53b9406@profihost.ag>
 <4e88008a-b844-e7d6-cba3-f86ce976b753@mendix.com>
 <4205dfd5-46ea-976b-f6b3-6aa5a5eca12f@profihost.ag>
 <db2d3b51-1e3d-1308-3f26-1df96764d9fe@cn.fujitsu.com>
 <ca6a57c9-4bb3-a81c-4beb-770f5331e994@profihost.ag>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <04207d26-9399-b232-1e5b-1f3c53accb83@cn.fujitsu.com>
Date: Tue, 18 Oct 2016 14:57:32 +0800
MIME-Version: 1.0
In-Reply-To: <ca6a57c9-4bb3-a81c-4beb-770f5331e994@profihost.ag>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 10/17/2016 02:50 PM, Stefan Priebe - Profihost AG wrote:
> Am 17.10.2016 um 03:50 schrieb Qu Wenruo:
>> At 10/17/2016 02:54 AM, Stefan Priebe - Profihost AG wrote:
>>> Am 16.10.2016 um 00:37 schrieb Hans van Kranenburg:
>>>> Hi,
>>>>
>>>> On 10/15/2016 10:49 PM, Stefan Priebe - Profihost AG wrote:
>>>>>
>>>>> cp --reflink=always takes sometimes very long. (i.e. 25-35 minutes)
>>>>>
>>>>> An example:
>>>>>
>>>>> source file:
>>>>> # ls -la vm-279-disk-1.img
>>>>> -rw-r--r-- 1 root root 204010946560 Oct 14 12:15 vm-279-disk-1.img
>>>>>
>>>>> target file after around 10 minutes:
>>>>> # ls -la vm-279-disk-1.img.tmp
>>>>> -rw-r--r-- 1 root root 65022328832 Oct 15 22:13 vm-279-disk-1.img.tmp
>>>>
>>>> Two quick thoughts:
>>>> 1. How many extents does this img have?
>>>
>>> filefrag says:
>>> 1011508 extents found
>>
>> Too many fragments.
>> Average extent size is only about 200K.
>> Quite common for VM images, if not setting no copy-on-write (C) attr.
>>
>> Normally it's not a good idea to put VM images into btrfs without any
>> tuning.
>
> Those are backups just written sequentially once. As far as i know the
> extent size is hardcoded to 128k for compression. Isn't it?
>
> Stefan
>

Just as Duncan said, for compress, its extent size is limited to 128K, 
unless you prealloc the file, sequence write is not possible to create 
extent larger than 128K.

Thanks,
Qu
>> Thanks,
>> Qu
>>>
>>>> 2. Is this an XY problem? Why not just put the img in a subvolume and
>>>> snapshot that?
>>>
>>> Sorry what's XY problem?
>>>
>>> Implementing cp reflink was easier - as the original code was based on
>>> XFS. But shouldn't be cp reflink / clone a file be nearly identical to a
>>> snapshot? Just creating refs to the extents?
>>>
>>> Greets,
>>> Stefan
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>>
>>
>>
>
>


