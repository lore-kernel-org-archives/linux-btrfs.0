Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:54782 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750704AbdAWAsE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 22 Jan 2017 19:48:04 -0500
Subject: Re: btrfs check lowmem vs original
To: Chris Murphy <chris@colorremedies.com>
References: <CAJCQCtQ-WkNShYNGi9hk8s7M_RdLGHV3Jw0zArt_W-uzYQ9BAg@mail.gmail.com>
 <6ee63ff7-6a0c-7828-0751-5769d59bb85f@cn.fujitsu.com>
 <CAJCQCtTdfD6=xWttk5D4JqLpzG9ZMxb-c=GopZPPNsLP6eHHpw@mail.gmail.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <aea6f1e7-7621-a32a-9cce-2e37357f4b82@cn.fujitsu.com>
Date: Mon, 23 Jan 2017 08:47:54 +0800
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTdfD6=xWttk5D4JqLpzG9ZMxb-c=GopZPPNsLP6eHHpw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 01/20/2017 11:10 PM, Chris Murphy wrote:
> On Thu, Jan 19, 2017 at 10:45 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>
>>> Another file system, 15 minutes old with two mounts in its whole
>>> lifetime, and only written with kernel 4.10-rc3 has over 30 lines of
>>> varying numbers:
>>>
>>> ERROR: root 257 EXTENT DATA[150134 11317248] prealloc shouln't have
>>> datasum
>>>
>>> That file system should have no preallocated extents (It's a clean
>>> installation of Fedora Rawhide, using only rsync)
>>
>>
>> btrfs-debug-tree will help to make sure what is wrong.
>
> 6b187fa6.logs.tar.gz 20M
> https://drive.google.com/open?id=0B_2Asp8DGjJ9SlRvZ2plNXVmTUU
>
>
> That's the small recent one, generic content. The others are bigger,
> and I should probably sanitize the filenames from debug-tree but can't
> find in the archives how to do that. Is btrfs-image useful for this?

Normally, btrfs-image is the best format, as we can just test if the fix 
is good or not directly on the image.

Not to mention btrfs-image has -s option to sanitize filenames. And 
btrfs-image is normally a little smaller than debug tree output.

Thanks,
Qu

>
>
>
>
>> That's why lowmem mode is still not the default option.
>>
>> The problem os original mode is, if you're checking a TB level fs and only 2
>> or 4G ram, then it's quite possible you ran out of memory and won't be able
>> to check the fs forever, more several than annoying.
>
> Fair enough.
>
>
>


