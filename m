Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:13572 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751716AbcJQBuw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 16 Oct 2016 21:50:52 -0400
Subject: Re: speed up cp --reflink=always
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>,
        Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <6e902770-05f3-2562-eeb3-dd9ef53b9406@profihost.ag>
 <4e88008a-b844-e7d6-cba3-f86ce976b753@mendix.com>
 <4205dfd5-46ea-976b-f6b3-6aa5a5eca12f@profihost.ag>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <db2d3b51-1e3d-1308-3f26-1df96764d9fe@cn.fujitsu.com>
Date: Mon, 17 Oct 2016 09:50:45 +0800
MIME-Version: 1.0
In-Reply-To: <4205dfd5-46ea-976b-f6b3-6aa5a5eca12f@profihost.ag>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 10/17/2016 02:54 AM, Stefan Priebe - Profihost AG wrote:
> Am 16.10.2016 um 00:37 schrieb Hans van Kranenburg:
>> Hi,
>>
>> On 10/15/2016 10:49 PM, Stefan Priebe - Profihost AG wrote:
>>>
>>> cp --reflink=always takes sometimes very long. (i.e. 25-35 minutes)
>>>
>>> An example:
>>>
>>> source file:
>>> # ls -la vm-279-disk-1.img
>>> -rw-r--r-- 1 root root 204010946560 Oct 14 12:15 vm-279-disk-1.img
>>>
>>> target file after around 10 minutes:
>>> # ls -la vm-279-disk-1.img.tmp
>>> -rw-r--r-- 1 root root 65022328832 Oct 15 22:13 vm-279-disk-1.img.tmp
>>
>> Two quick thoughts:
>> 1. How many extents does this img have?
>
> filefrag says:
> 1011508 extents found

Too many fragments.
Average extent size is only about 200K.
Quite common for VM images, if not setting no copy-on-write (C) attr.

Normally it's not a good idea to put VM images into btrfs without any 
tuning.

Several default features of btrfs is not suitable for that use case:
1) Copy-on-Write
    For VM image, a lot of random write happens.
    This will create a lot of small extents, just as you see here.

    Traditional non-CoW filesystems, like Ext4 and (current) XFS,
    overwrite is just overwrite, won't be written into new places.
    So for these filesystems, no matter how many writes happen, the
    extent counts won't change much(mostly unchanged)

2) Extent booking
    Another result of CoW, data extents won't be freed until all its
    referencer get removed.
    Which leads to quite some space wastes.

3) Slow metadata operation
    Btfs tree cow and its lock mechanism makes metadata operation quite
    slow compared to other fs.

    Normal read/write is not metadata heavy operation, while reflinking
    is.
    (IIRC, xfs with reflink support, not mainlined yet, is faster than
     btrfs doing reflink)

Normally, no cow (C) attr is recommended for VM image use case.
This flag will make btrfs acts much like traditional fs, until there is 
a snapshot containing this file is created.

While it has the limitation that it will prohibit reflink, you can't use 
cp --reflink=always then.


If no cow flag is not what you want, and there is no other 
snapshot/subvolume/reflinked files sharing the file, defrag is high 
recommended before reflink.

That will hugely reduce the number of extents(fragments) and reduce the 
time calling reflink.

However I doubt the time consuming of defrag may be even longer than 
reflink.

Thanks,
Qu
>
>> 2. Is this an XY problem? Why not just put the img in a subvolume and
>> snapshot that?
>
> Sorry what's XY problem?
>
> Implementing cp reflink was easier - as the original code was based on
> XFS. But shouldn't be cp reflink / clone a file be nearly identical to a
> snapshot? Just creating refs to the extents?
>
> Greets,
> Stefan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


